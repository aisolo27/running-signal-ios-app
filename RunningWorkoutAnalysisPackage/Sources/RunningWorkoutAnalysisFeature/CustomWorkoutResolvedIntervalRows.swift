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
        guard !plannedSteps.contains(where: { ($0.repeatIndex ?? 1) > 1 })
            || plannedSteps.contains(where: { ($0.repeatIndex ?? 1) == 1 && $0.repeatBlockIndex != nil }) else {
            return nil
        }
        guard !activities.isEmpty,
              activities.count == plannedSteps.count,
              activitiesAreCompleteAndContiguous(activities) else {
            return nil
        }

        guard let pauses = pairedPauseIntervals(in: evidence.events, workout: workout),
              pausesAreAssignableToSingleRows(pauses, activities: activities) else {
            return nil
        }

        var rows = zip(plannedSteps, activities).map { step, activity in
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
                distanceMeters: activityDistanceMeters(activity),
                pauseIntervals: pauses,
                evidence: evidence,
                sourceNote: "Resolved from complete contiguous HealthKit activity rows mapped to expanded WorkoutKit planned steps."
            )
        }

        appendOpenTailIfNeeded(to: &rows, workout: workout, activities: activities, pauses: pauses, evidence: evidence)

        guard rows.allSatisfy({ $0.actualEndDate > $0.actualStartDate }) else {
            return nil
        }

        return WorkoutIntervalReconstructionResult(
            planSource: .workoutKit,
            windowSource: .healthKitActivityBoundaries,
            intervals: rows,
            notes: [
                "Resolved custom workout rows use HealthKit activity boundaries for row windows.",
                "Displayed row duration uses active timer time when paired pause overlap is present."
            ]
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
        distanceMeters: Double?,
        pauseIntervals: [DateInterval],
        evidence: WorkoutEvidence,
        sourceNote: String
    ) -> ReconstructedWorkoutInterval {
        let elapsed = max(0, end.timeIntervalSince(start))
        let pauseOverlap = pauseOverlapSeconds(start: start, end: end, pauses: pauseIntervals)
        let activeDuration = max(0, elapsed - pauseOverlap)
        let displayRule: ReconstructedIntervalDurationDisplayRule = pauseOverlap > 0 ? .activeTimer : .elapsedRowWindow
        let displayDuration = displayRule == .activeTimer ? activeDuration : elapsed
        let pace = distanceMeters.flatMap { distance -> Double? in
            guard distance > 0, displayDuration > 0 else { return nil }
            return displayDuration / (distance / 1_000)
        }
        let heartRates = values(metric: .heartRate, start: start, end: end, evidence: evidence)
        let cadence = average(values(metric: .cadence, start: start, end: end, evidence: evidence))
            ?? average(values(metric: .stepCount, start: start, end: end, evidence: evidence))
        let power = average(values(metric: .runningPower, start: start, end: end, evidence: evidence))

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
            averageHeartRateBpm: average(heartRates),
            maxHeartRateBpm: heartRates.max(),
            averageCadence: cadence,
            averagePower: power,
            planSource: .workoutKit,
            windowSource: .healthKitActivityBoundaries,
            boundaryStrategy: nil,
            boundaryAdjustmentSeconds: nil,
            boundaryOvershootMeters: nil,
            boundaryDiagnostics: nil,
            tailDiagnostics: nil,
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
        workout: CanonicalWorkout,
        activities: [WorkoutEvidenceActivity],
        pauses: [DateInterval],
        evidence: WorkoutEvidence
    ) {
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
                sourceNote: "Resolved from workout tail after complete fixed planned rows."
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

    private static func activityDistanceMeters(_ activity: WorkoutEvidenceActivity) -> Double? {
        activity.statistics.first {
            $0.quantityType == "HKQuantityTypeIdentifierDistanceWalkingRunning"
        }?.sum
    }

    private static func values(
        metric: WorkoutEvidenceMetric,
        start: Date,
        end: Date,
        evidence: WorkoutEvidence
    ) -> [Double] {
        evidence.series[metric]?.points.compactMap { point in
            point.date >= start && point.date <= end ? point.value : nil
        } ?? []
    }

    private static func average(_ values: [Double]) -> Double? {
        guard !values.isEmpty else { return nil }
        return values.reduce(0, +) / Double(values.count)
    }
}
