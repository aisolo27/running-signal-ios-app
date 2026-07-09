import Foundation

public enum CustomWorkoutResolvedIntervalRows {
    public static func resolve(
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence
    ) -> WorkoutIntervalReconstructionResult? {
        guard let audit = evidence.workoutPlanAudit,
              audit.status == .available,
              !audit.plannedSteps.isEmpty else {
            return nil
        }

        let plannedSteps = audit.plannedSteps.sorted { $0.index < $1.index }
        let activities = evidence.activities.sorted { $0.startDate < $1.startDate }
        guard plannedSteps.indices.allSatisfy({ plannedSteps[$0].index == $0 + 1 }) else {
            return nil
        }
        guard hasCompleteRepeatContext(plannedSteps) else {
            return nil
        }
        guard hasConsistentRepeatIterationShape(plannedSteps) else {
            return nil
        }
        guard !activities.isEmpty,
              activities.count <= plannedSteps.count,
              activitiesAreCompleteAndContiguous(activities) else {
            return nil
        }

        guard let pauses = pairedPauseIntervals(in: evidence.events, workout: workout),
              pausesAreAssignableToSingleRows(pauses, activities: activities) else {
            return nil
        }

        let resolvedPlannedSteps = Array(plannedSteps.prefix(activities.count))
        var rows = zip(resolvedPlannedSteps, activities).map { step, activity in
            resolvedRow(
                index: step.index,
                label: step.label,
                stepType: step.stepType,
                plannedGoalType: step.plannedGoalType,
                plannedGoalValue: step.plannedGoalValue,
                plannedGoalDisplayText: step.plannedGoalDisplayText,
                plannedTargetDisplayText: step.plannedTargetDisplayText,
                start: activity.startDate,
                end: activity.endDate ?? activity.startDate.addingTimeInterval(activity.durationSeconds),
                activity: activity,
                distanceMeters: activityDistanceMeters(activity),
                pauseIntervals: pauses,
                evidence: evidence,
                sourceNote: "Resolved from complete contiguous HealthKit activity rows mapped to expanded WorkoutKit planned steps."
            )
        }

        if activities.count == plannedSteps.count {
            appendOpenTailIfNeeded(
                to: &rows,
                plannedSteps: plannedSteps,
                workout: workout,
                activities: activities,
                pauses: pauses,
                evidence: evidence
            )
        }

        guard rows.allSatisfy({ $0.actualEndDate > $0.actualStartDate }) else {
            return nil
        }

        let executionDiagnostics = plannedExecutionDiagnostics(
            plannedSteps: resolvedPlannedSteps,
            rows: rows
        )

        return WorkoutIntervalReconstructionResult(
            planSource: .workoutKit,
            windowSource: .healthKitActivityBoundaries,
            intervals: rows,
            notes: [
                "Resolved custom workout rows use HealthKit activity boundaries for row windows.",
                "Displayed row duration prefers native HealthKit activity duration when available."
            ] + (activities.count < plannedSteps.count ? [
                "Workout ended before all planned rows completed; only completed HealthKit activity rows are shown."
            ] : []) + executionDiagnostics
        )
    }

    private static func resolvedRow(
        index: Int,
        label: String,
        stepType: DerivedIntervalLabel,
        plannedGoalType: PlannedWorkoutGoalType,
        plannedGoalValue: Double?,
        plannedGoalDisplayText: String,
        plannedTargetDisplayText: String?,
        start: Date,
        end: Date,
        activity: WorkoutEvidenceActivity? = nil,
        distanceMeters: Double?,
        pauseIntervals: [DateInterval],
        evidence: WorkoutEvidence,
        sourceNote: String,
        tailDiagnostics: TailDiagnostics? = nil
    ) -> ReconstructedWorkoutInterval {
        let elapsed = max(0, end.timeIntervalSince(start))
        let eventPauseOverlap = pauseOverlapSeconds(start: start, end: end, pauses: pauseIntervals)
        let nativeActiveDuration = (activity?.durationSeconds).flatMap { duration -> Double? in
            guard duration > 0, duration <= elapsed + 1 else { return nil }
            let eventDerivedActive = max(0, elapsed - eventPauseOverlap)
            if eventPauseOverlap > 0.5, abs(duration - elapsed) <= 1, abs(duration - eventDerivedActive) > 1 {
                return nil
            }
            return min(duration, elapsed)
        } ?? max(0, elapsed - eventPauseOverlap)
        let activeDuration = nativeActiveDuration
        let pauseOverlap = max(eventPauseOverlap, max(0, elapsed - activeDuration))
        let displayRule: ReconstructedIntervalDurationDisplayRule = pauseOverlap > 0.5 ? .activeTimer : .elapsedRowWindow
        let displayDuration = displayRule == .activeTimer ? activeDuration : elapsed
        let pace = distanceMeters.flatMap { distance -> Double? in
            guard distance > 0, displayDuration > 0 else { return nil }
            return displayDuration / (distance / 1_000)
        }
        let heartRates = values(metric: .heartRate, start: start, end: end, evidence: evidence)
        let averageHeartRate = activityAverage(.heartRate, in: activity) ?? average(heartRates)
        let maxHeartRate = activityMaximum(.heartRate, in: activity) ?? heartRates.max()
        let cadence = activityAverage(.cadence, in: activity)
            ?? average(values(metric: .cadence, start: start, end: end, evidence: evidence))
            ?? average(values(metric: .stepCount, start: start, end: end, evidence: evidence))
        let power = activityAverage(.runningPower, in: activity)
            ?? average(values(metric: .runningPower, start: start, end: end, evidence: evidence))
        let plannedDistanceWindow = plannedDistanceMetricWindow(
            plannedGoalType: plannedGoalType,
            plannedGoalValue: plannedGoalValue,
            start: start,
            rowEnd: end,
            evidence: evidence
        )

        return ReconstructedWorkoutInterval(
            index: index,
            label: label,
            stepType: stepType,
            plannedGoalType: plannedGoalType,
            plannedGoalValue: plannedGoalValue,
            plannedGoalDisplayText: plannedGoalDisplayText,
            plannedTargetDisplayText: plannedTargetDisplayText,
            actualStartDate: start,
            actualEndDate: end,
            actualDurationSeconds: displayDuration,
            elapsedDurationSeconds: elapsed,
            pauseOverlapSeconds: pauseOverlap,
            activeDurationSeconds: activeDuration,
            durationDisplayRule: displayRule,
            actualDistanceMeters: distanceMeters,
            actualPaceSecondsPerKm: pace,
            averageHeartRateBpm: averageHeartRate,
            maxHeartRateBpm: maxHeartRate,
            averageCadence: cadence,
            averagePower: power,
            plannedDistanceMetricWindow: plannedDistanceWindow,
            planSource: .workoutKit,
            windowSource: .healthKitActivityBoundaries,
            boundaryStrategy: nil,
            boundaryAdjustmentSeconds: nil,
            boundaryOvershootMeters: nil,
            boundaryDiagnostics: nil,
            tailDiagnostics: tailDiagnostics,
            sourceNote: sourceNote,
            confidence: .high
        )
    }

    private static func pairedPauseIntervals(
        in events: [WorkoutEvidenceEvent],
        workout: CanonicalWorkout
    ) -> [DateInterval]? {
        var pendingPause: Date?
        var intervals: [DateInterval] = []
        var sawPauseEvidence = false
        for event in events.sorted(by: { $0.startDate < $1.startDate }) {
            if isTerminalZeroDurationPauseMarker(event, workout: workout) {
                continue
            }
            let label = event.displayLabel.lowercased()
            let type = event.type.lowercased()
            let isPause = (label.contains("pause") && !label.contains("resume"))
                || type.contains("rawvalue: 1")
                || type.contains("rawvalue: 5")
            let isResume = label.contains("resume")
                || type.contains("rawvalue: 2")
                || type.contains("rawvalue: 6")
            if isPause {
                sawPauseEvidence = true
                if pendingPause != nil {
                    return nil
                }
                pendingPause = event.startDate
            } else if isResume, let start = pendingPause {
                sawPauseEvidence = true
                let end = min(event.startDate, workout.endDate)
                if end > start {
                    intervals.append(DateInterval(start: max(start, workout.startDate), end: end))
                }
                pendingPause = nil
            } else if isResume {
                sawPauseEvidence = true
                return nil
            }
        }
        if sawPauseEvidence, pendingPause != nil {
            return nil
        }
        return intervals
    }

    private static func isTerminalZeroDurationPauseMarker(
        _ event: WorkoutEvidenceEvent,
        workout: CanonicalWorkout
    ) -> Bool {
        let type = event.type.lowercased()
        guard type.contains("rawvalue: 1") else { return false }

        let duration = event.endDate.timeIntervalSince(event.startDate)
        let startsAtWorkoutEnd = abs(event.startDate.timeIntervalSince(workout.endDate)) <= 1
        return duration <= 0.5 && startsAtWorkoutEnd
    }

    private static func pausesAreAssignableToSingleRows(
        _ pauses: [DateInterval],
        activities: [WorkoutEvidenceActivity]
    ) -> Bool {
        pauses.allSatisfy { pause in
            let containingRows = activities.filter { activity in
                guard let endDate = activity.endDate else { return false }
                return pause.start >= activity.startDate.addingTimeInterval(-1)
                    && pause.end <= endDate.addingTimeInterval(1)
            }
            return containingRows.count == 1
        }
    }

    private static func appendOpenTailIfNeeded(
        to rows: inout [ReconstructedWorkoutInterval],
        plannedSteps: [PlannedWorkoutStep],
        workout: CanonicalWorkout,
        activities: [WorkoutEvidenceActivity],
        pauses: [DateInterval],
        evidence: WorkoutEvidence
    ) {
        guard activities.count == plannedSteps.count,
              let finalStep = plannedSteps.last,
              finalStep.plannedGoalType != .open,
              finalStep.stepType == .work || finalStep.stepType == .cooldown else {
            return
        }
        guard let lastEnd = activities.last?.endDate,
              workout.endDate > lastEnd else {
            return
        }
        let mappedDistance = rows.compactMap(\.actualDistanceMeters).reduce(0, +)
        let tailDistance = workout.distanceMeters.map { max(0, $0 - mappedDistance) }
        let tailDuration = workout.endDate.timeIntervalSince(lastEnd)
        guard tailDuration > 0.5 || (tailDistance ?? 0) > 0.5 else {
            return
        }

        rows.append(
            resolvedRow(
                index: rows.count + 1,
                label: "Open / Extra",
                stepType: .open,
                plannedGoalType: .open,
                plannedGoalValue: nil,
                plannedGoalDisplayText: "Open",
                plannedTargetDisplayText: nil,
                start: lastEnd,
                end: workout.endDate,
                distanceMeters: tailDistance,
                pauseIntervals: pauses,
                evidence: evidence,
                sourceNote: "Resolved from workout tail after complete fixed planned rows.",
                tailDiagnostics: TailDiagnostics(
                    plannedFinalStepEndDate: lastEnd,
                    workoutEndDate: workout.endDate,
                    remainingSeconds: tailDuration,
                    remainingMeters: tailDistance,
                    finalDistanceSampleDate: evidence.series[.distance]?.points.last?.date,
                    finalDistanceSampleCumulativeDistanceMeters: evidence.series[.distance]?.points.last?.value,
                    lastHeartRateSampleDate: evidence.series[.heartRate]?.points.last?.date,
                    lastPowerSampleDate: evidence.series[.runningPower]?.points.last?.date,
                    lastCadenceSampleDate: evidence.series[.cadence]?.points.last?.date,
                    creationReason: "Remaining workout time or distance exceeded Open / Extra threshold after complete activity-boundary rows."
                )
            )
        )
    }

    private static func pauseOverlapSeconds(start: Date, end: Date, pauses: [DateInterval]) -> Double {
        pauses.reduce(0) { total, pause in
            let overlapStart = max(start, pause.start)
            let overlapEnd = min(end, pause.end)
            return total + max(0, overlapEnd.timeIntervalSince(overlapStart))
        }
    }

    private static func activitiesAreCompleteAndContiguous(_ activities: [WorkoutEvidenceActivity]) -> Bool {
        for index in activities.indices {
            guard let end = activities[index].endDate,
                  end > activities[index].startDate else {
                return false
            }
            if index > 0, let previousEnd = activities[index - 1].endDate {
                let gap = abs(activities[index].startDate.timeIntervalSince(previousEnd))
                if gap > 1 {
                    return false
                }
            }
        }
        return true
    }

    private static func hasCompleteRepeatContext(_ plannedSteps: [PlannedWorkoutStep]) -> Bool {
        let repeatSteps = plannedSteps.filter { $0.repeatBlockIndex != nil || ($0.repeatIndex ?? 1) > 1 }
        guard !repeatSteps.isEmpty else {
            return true
        }

        let grouped = Dictionary(grouping: repeatSteps) { $0.repeatBlockIndex ?? -1 }
        return grouped.values.allSatisfy { steps in
            let repeatIndexes = Set(steps.map { $0.repeatIndex ?? 1 })
            guard let maxRepeatIndex = repeatIndexes.max(), maxRepeatIndex >= 1 else {
                return false
            }
            return Set(1...maxRepeatIndex).isSubset(of: repeatIndexes)
        }
    }

    private static func hasConsistentRepeatIterationShape(_ plannedSteps: [PlannedWorkoutStep]) -> Bool {
        let grouped = Dictionary(grouping: plannedSteps.filter { $0.repeatBlockIndex != nil }) { $0.repeatBlockIndex ?? -1 }
        return grouped.values.allSatisfy { steps in
            let byIteration = Dictionary(grouping: steps) { $0.repeatIndex ?? 1 }
            let sortedIterations = byIteration.keys.sorted()
            guard let firstIteration = sortedIterations.first,
                  let firstSignature = byIteration[firstIteration]?.map(\.stepType),
                  let lastIteration = sortedIterations.last else {
                return true
            }
            return sortedIterations.allSatisfy { iteration in
                guard let signature = byIteration[iteration]?.map(\.stepType) else {
                    return false
                }
                if signature.filter({ $0 == .work }).count > 1, !signature.contains(.recovery) {
                    return false
                }
                if signature == firstSignature {
                    return true
                }
                if iteration == lastIteration,
                   firstSignature.last == .recovery,
                   signature == Array(firstSignature.dropLast()),
                   plannedSteps.last?.stepType == .cooldown {
                    return true
                }
                return false
            }
        }
    }

    private static func activityDistanceMeters(_ activity: WorkoutEvidenceActivity) -> Double? {
        activitySum(.distance, in: activity)
    }

    private static func plannedExecutionDiagnostics(
        plannedSteps: [PlannedWorkoutStep],
        rows: [ReconstructedWorkoutInterval]
    ) -> [String] {
        zip(plannedSteps, rows).compactMap { step, row in
            guard step.plannedGoalType == .distance,
                  let plannedDistance = step.plannedGoalValue,
                  plannedDistance > 0,
                  let actualDistance = row.actualDistanceMeters,
                  actualDistance > 0,
                  actualDistance < plannedDistance * 0.9 else {
                return nil
            }
            return "\(step.label) ended at \(Int(actualDistance.rounded())) m before its planned \(Int(plannedDistance.rounded())) m distance; treat as shortened/skipped HealthKit activity evidence, not plan-derived completion."
        }
    }

    private static func activitySum(_ metric: WorkoutEvidenceMetric, in activity: WorkoutEvidenceActivity?) -> Double? {
        activityStatistic(metric, in: activity)?.sum
    }

    private static func activityAverage(_ metric: WorkoutEvidenceMetric, in activity: WorkoutEvidenceActivity?) -> Double? {
        activityStatistic(metric, in: activity)?.average
    }

    private static func activityMaximum(_ metric: WorkoutEvidenceMetric, in activity: WorkoutEvidenceActivity?) -> Double? {
        activityStatistic(metric, in: activity)?.maximum
    }

    private static func activityStatistic(
        _ metric: WorkoutEvidenceMetric,
        in activity: WorkoutEvidenceActivity?
    ) -> WorkoutEvidenceActivityStatistic? {
        guard let identifier = healthKitIdentifier(for: metric) else { return nil }
        return activity?.statistics.first { $0.quantityType == identifier }
    }

    private static func healthKitIdentifier(for metric: WorkoutEvidenceMetric) -> String? {
        switch metric {
        case .heartRate:
            "HKQuantityTypeIdentifierHeartRate"
        case .runningSpeed:
            "HKQuantityTypeIdentifierRunningSpeed"
        case .distance:
            "HKQuantityTypeIdentifierDistanceWalkingRunning"
        case .activeEnergy:
            "HKQuantityTypeIdentifierActiveEnergyBurned"
        case .basalEnergy:
            "HKQuantityTypeIdentifierBasalEnergyBurned"
        case .runningPower:
            "HKQuantityTypeIdentifierRunningPower"
        case .stepCount:
            "HKQuantityTypeIdentifierStepCount"
        case .strideLength:
            "HKQuantityTypeIdentifierRunningStrideLength"
        case .verticalOscillation:
            "HKQuantityTypeIdentifierRunningVerticalOscillation"
        case .groundContactTime:
            "HKQuantityTypeIdentifierRunningGroundContactTime"
        case .cadence:
            nil
        }
    }

    private static func values(
        metric: WorkoutEvidenceMetric,
        start: Date,
        end: Date,
        evidence: WorkoutEvidence
    ) -> [Double] {
        evidence.series[metric]?.points.compactMap { point in
            let overlaps = point.endDate >= start && point.startDate <= end
            return overlaps ? point.value : nil
        } ?? []
    }

    private static func plannedDistanceMetricWindow(
        plannedGoalType: PlannedWorkoutGoalType,
        plannedGoalValue: Double?,
        start: Date,
        rowEnd: Date,
        evidence: WorkoutEvidence
    ) -> PlannedDistanceMetricWindow? {
        guard plannedGoalType == .distance,
              let plannedGoalValue,
              plannedGoalValue > 0,
              let startDistance = cumulativeDistance(at: start, evidence: evidence),
              let endDate = date(atCumulativeDistance: startDistance + plannedGoalValue, evidence: evidence),
              endDate > start,
              endDate <= rowEnd.addingTimeInterval(1) else {
            return nil
        }

        let heartRates = values(metric: .heartRate, start: start, end: endDate, evidence: evidence)
        let cadence = average(values(metric: .cadence, start: start, end: endDate, evidence: evidence))
            ?? average(values(metric: .stepCount, start: start, end: endDate, evidence: evidence))
        let power = average(values(metric: .runningPower, start: start, end: endDate, evidence: evidence))

        return PlannedDistanceMetricWindow(
            startDate: start,
            endDate: endDate,
            distanceMeters: plannedGoalValue,
            averageHeartRateBpm: average(heartRates),
            maxHeartRateBpm: heartRates.max(),
            averageCadence: cadence,
            averagePower: power
        )
    }

    private static func cumulativeDistance(at date: Date, evidence: WorkoutEvidence) -> Double? {
        guard let series = evidence.series[.distance] else { return nil }
        var cumulative = 0.0
        var previousSampleEnd: Date?

        for point in series.points {
            let sampleStart = sampleStartDate(for: point, previousSampleEnd: previousSampleEnd)
            let sampleEnd = sampleEndDate(for: point, sampleStart: sampleStart)

            if date <= sampleStart {
                return cumulative
            }

            if date < sampleEnd {
                return interpolatedDistance(
                    at: date,
                    previousDate: sampleStart,
                    currentDate: sampleEnd,
                    previousDistance: cumulative,
                    currentDistance: cumulative + point.value
                )
            }

            cumulative += point.value
            previousSampleEnd = sampleEnd
        }

        return cumulative
    }

    private static func date(atCumulativeDistance targetDistance: Double, evidence: WorkoutEvidence) -> Date? {
        guard let series = evidence.series[.distance] else { return nil }
        var cumulative = 0.0
        var previousSampleEnd: Date?

        for point in series.points {
            let sampleStart = sampleStartDate(for: point, previousSampleEnd: previousSampleEnd)
            let sampleEnd = sampleEndDate(for: point, sampleStart: sampleStart)
            let currentDistance = cumulative + point.value

            if currentDistance >= targetDistance {
                let fraction = interpolationFraction(
                    targetDistance: targetDistance,
                    previousDistance: cumulative,
                    currentDistance: currentDistance
                )
                return sampleStart.addingTimeInterval(sampleEnd.timeIntervalSince(sampleStart) * fraction)
            }

            cumulative = currentDistance
            previousSampleEnd = sampleEnd
        }

        return nil
    }

    private static func sampleStartDate(for point: WorkoutEvidencePoint, previousSampleEnd: Date?) -> Date {
        if point.startDate < point.endDate {
            return point.startDate
        }
        return previousSampleEnd ?? point.date
    }

    private static func sampleEndDate(for point: WorkoutEvidencePoint, sampleStart: Date) -> Date {
        if point.endDate > sampleStart {
            return point.endDate
        }
        return point.date
    }

    private static func interpolatedDistance(
        at date: Date,
        previousDate: Date,
        currentDate: Date,
        previousDistance: Double,
        currentDistance: Double
    ) -> Double {
        let duration = currentDate.timeIntervalSince(previousDate)
        guard duration > 0 else { return currentDistance }
        let fraction = min(max(date.timeIntervalSince(previousDate) / duration, 0), 1)
        return previousDistance + (currentDistance - previousDistance) * fraction
    }

    private static func interpolationFraction(
        targetDistance: Double,
        previousDistance: Double,
        currentDistance: Double
    ) -> Double {
        let distanceDelta = currentDistance - previousDistance
        guard distanceDelta > 0 else { return 0 }
        return min(max((targetDistance - previousDistance) / distanceDelta, 0), 1)
    }

    private static func average(_ values: [Double]) -> Double? {
        guard !values.isEmpty else { return nil }
        return values.reduce(0, +) / Double(values.count)
    }
}
