import Foundation

public enum PlannedWorkoutGoalType: String, Codable, Equatable, Sendable {
    case distance
    case time
    case open
    case energy
    case unavailable
}

public enum IntervalPlanSource: String, Codable, Equatable, Sendable {
    case workoutKit
    case runSignal
    case unavailable

    public var label: String {
        switch self {
        case .workoutKit: "WorkoutKit"
        case .runSignal: "RunSignal"
        case .unavailable: "Unavailable"
        }
    }
}

public enum IntervalWindowSource: String, Codable, Equatable, Sendable {
    case planDerivedFromDistanceAndTimeSamples
    case healthKitActivityBoundaries
    case unavailable

    public var label: String {
        switch self {
        case .planDerivedFromDistanceAndTimeSamples: "Plan-derived from HealthKit distance/time samples"
        case .healthKitActivityBoundaries: "HealthKit activity boundaries"
        case .unavailable: "Unavailable"
        }
    }
}

public enum IntervalReconstructionConfidence: String, Codable, Equatable, Sendable {
    case high
    case medium
    case low
    case unavailable

    public var label: String {
        switch self {
        case .high: "High"
        case .medium: "Medium"
        case .low: "Low"
        case .unavailable: "Unavailable"
        }
    }
}

public enum DistanceGoalBoundaryStrategy: String, Codable, Equatable, Sendable {
    case interpolatedCrossing
    case crossingSampleEnd
    case nearestSampleBoundaryAfterCrossing

    public var label: String {
        switch self {
        case .interpolatedCrossing: "interpolated crossing"
        case .crossingSampleEnd: "crossing sample end"
        case .nearestSampleBoundaryAfterCrossing: "nearest sample boundary"
        }
    }
}

public enum ReconstructedIntervalDurationDisplayRule: String, Codable, Equatable, Sendable {
    case elapsedRowWindow
    case activeTimer
}

public struct PlannedWorkoutStep: Codable, Equatable, Sendable {
    public var index: Int
    public var label: String
    public var stepType: DerivedIntervalLabel
    public var repeatBlockIndex: Int?
    public var repeatIndex: Int?
    public var plannedGoalType: PlannedWorkoutGoalType
    public var plannedGoalValue: Double?
    public var plannedGoalDisplayText: String
    public var plannedTargetDisplayText: String?

    public init(
        index: Int,
        label: String,
        stepType: DerivedIntervalLabel,
        repeatBlockIndex: Int? = nil,
        repeatIndex: Int? = nil,
        plannedGoalType: PlannedWorkoutGoalType,
        plannedGoalValue: Double? = nil,
        plannedGoalDisplayText: String,
        plannedTargetDisplayText: String? = nil
    ) {
        self.index = index
        self.label = label
        self.stepType = stepType
        self.repeatBlockIndex = repeatBlockIndex
        self.repeatIndex = repeatIndex
        self.plannedGoalType = plannedGoalType
        self.plannedGoalValue = plannedGoalValue
        self.plannedGoalDisplayText = plannedGoalDisplayText
        self.plannedTargetDisplayText = plannedTargetDisplayText
    }
}

public struct ReconstructedWorkoutInterval: Codable, Equatable, Sendable {
    public var index: Int
    public var label: String
    public var stepType: DerivedIntervalLabel
    public var plannedGoalType: PlannedWorkoutGoalType
    public var plannedGoalValue: Double?
    public var plannedGoalDisplayText: String
    public var plannedTargetDisplayText: String?
    public var actualStartDate: Date
    public var actualEndDate: Date
    public var actualDurationSeconds: Double
    public var elapsedDurationSeconds: Double?
    public var pauseOverlapSeconds: Double?
    public var activeDurationSeconds: Double?
    public var durationDisplayRule: ReconstructedIntervalDurationDisplayRule?
    public var actualDistanceMeters: Double?
    public var actualPaceSecondsPerKm: Double?
    public var averageHeartRateBpm: Double?
    public var maxHeartRateBpm: Double?
    public var averageCadence: Double?
    public var averagePower: Double?
    public var planSource: IntervalPlanSource
    public var windowSource: IntervalWindowSource
    public var boundaryStrategy: DistanceGoalBoundaryStrategy?
    public var boundaryAdjustmentSeconds: Double?
    public var boundaryOvershootMeters: Double?
    public var boundaryDiagnostics: DistanceBoundaryDiagnostics?
    public var tailDiagnostics: TailDiagnostics?
    public var sourceNote: String
    public var confidence: IntervalReconstructionConfidence

    public var elapsedRowWindowDurationSeconds: Double {
        elapsedDurationSeconds ?? actualDurationSeconds
    }

    public var activeTimerDurationSeconds: Double {
        activeDurationSeconds ?? actualDurationSeconds
    }

    public var displayDurationSeconds: Double {
        switch durationDisplayRule ?? .elapsedRowWindow {
        case .elapsedRowWindow:
            elapsedRowWindowDurationSeconds
        case .activeTimer:
            activeTimerDurationSeconds
        }
    }
}

enum PauseResolutionEventKind: Equatable, Sendable {
    case pause
    case resume
    case toggle
}

struct PauseResolutionEvent: Equatable, Sendable {
    var timestamp: Date
    var kind: PauseResolutionEventKind
}

struct PauseWindowResolution: Equatable, Sendable {
    var intervals: [DateInterval]
    var confidence: IntervalReconstructionConfidence
    var caveats: [String]

    var isReliableForNormalDetail: Bool {
        caveats.isEmpty
    }
}

enum PauseWindowResolver {
    static func resolve(
        events: [PauseResolutionEvent],
        workoutStart: Date,
        workoutEnd: Date
    ) -> PauseWindowResolution {
        var intervals: [DateInterval] = []
        var caveats: [String] = []
        var pauseStart: Date?

        for event in events.sorted(by: { $0.timestamp < $1.timestamp }) {
            guard event.timestamp >= workoutStart, event.timestamp <= workoutEnd else {
                caveats.append("Pause event outside workout bounds ignored")
                continue
            }

            switch event.kind {
            case .pause:
                guard pauseStart == nil else {
                    caveats.append("Duplicate pause event ignored")
                    continue
                }
                pauseStart = event.timestamp
            case .resume:
                guard let start = pauseStart else {
                    caveats.append("Resume event without active pause ignored")
                    continue
                }
                if event.timestamp > start {
                    intervals.append(DateInterval(start: start, end: event.timestamp))
                } else {
                    caveats.append("Zero-length pause window ignored")
                }
                pauseStart = nil
            case .toggle:
                if let start = pauseStart {
                    if event.timestamp > start {
                        intervals.append(DateInterval(start: start, end: event.timestamp))
                    } else {
                        caveats.append("Zero-length pause window ignored")
                    }
                    pauseStart = nil
                } else {
                    pauseStart = event.timestamp
                }
            }
        }

        if let start = pauseStart {
            if workoutEnd > start {
                intervals.append(DateInterval(start: start, end: workoutEnd))
                caveats.append("Dangling pause closed at workout end")
            } else {
                caveats.append("Dangling pause at or after workout end ignored")
            }
        }

        return PauseWindowResolution(
            intervals: intervals,
            confidence: caveats.isEmpty ? .high : .low,
            caveats: caveats
        )
    }
}

fileprivate enum WorkoutPauseTimingSemantics {
    static func pauseEventKind(for event: WorkoutEvidenceEvent) -> PauseResolutionEventKind? {
        let normalizedType = normalizedPauseText(event.type)
        let normalizedLabel = normalizedPauseText(event.displayLabel)

        if normalizedType.contains("pauseorresumerequest")
            || normalizedLabel.contains("pauseresumerequest") {
            return .toggle
        }
        if normalizedType.contains("motionpaused")
            || normalizedLabel.contains("motionpaused") {
            return .pause
        }
        if normalizedType.contains("motionresumed")
            || normalizedLabel.contains("motionresumed") {
            return .resume
        }
        if normalizedLabel.contains("resume") || normalizedType.contains("resume") {
            return .resume
        }
        if normalizedLabel.contains("pause") || normalizedType.contains("pause") {
            return .pause
        }
        return nil
    }

    static func hasPauseOrResumeEvents(in events: [WorkoutEvidenceEvent]) -> Bool {
        events.contains { pauseEventKind(for: $0) != nil }
    }

    static func pairedPauseCount(in events: [WorkoutEvidenceEvent]) -> Int {
        reliablePauses(in: events)?.count ?? 0
    }

    static func pairedPauseIntervals(in events: [WorkoutEvidenceEvent]) -> [DateInterval]? {
        reliablePauses(in: events)
    }

    static func pairedPauseOverlapSeconds(
        in events: [WorkoutEvidenceEvent],
        start: Date,
        end: Date
    ) -> Double? {
        guard let pauseIntervals = pairedPauseIntervals(in: events) else {
            return nil
        }

        return pauseIntervals.reduce(0) { total, pauseInterval in
            let overlapStart = max(start, pauseInterval.start)
            let overlapEnd = min(end, pauseInterval.end)
            guard overlapEnd > overlapStart else { return total }
            return total + overlapEnd.timeIntervalSince(overlapStart)
        }
    }

    private static func reliablePauses(in events: [WorkoutEvidenceEvent]) -> [DateInterval]? {
        let pauseEvents = events.compactMap { event -> PauseResolutionEvent? in
            guard let kind = pauseEventKind(for: event) else { return nil }
            return PauseResolutionEvent(timestamp: event.startDate, kind: kind)
        }
        guard !pauseEvents.isEmpty else {
            return []
        }

        guard let workoutStart = pauseEvents.map(\.timestamp).min(),
              let workoutEnd = pauseEvents.map(\.timestamp).max() else {
            return []
        }
        let resolution = PauseWindowResolver.resolve(
            events: pauseEvents,
            workoutStart: workoutStart,
            workoutEnd: workoutEnd
        )
        guard resolution.isReliableForNormalDetail else {
            return nil
        }
        return resolution.intervals
    }

    private static func normalizedPauseText(_ text: String) -> String {
        text.lowercased().filter { $0.isLetter || $0.isNumber }
    }
}

public struct DistanceBoundaryDiagnostics: Codable, Equatable, Sendable {
    public var targetDistanceMeters: Double
    public var cumulativeDistanceAtStartMeters: Double
    public var cumulativeDistanceAtEndMeters: Double
    public var interpolationFraction: Double?
    public var previousSample: DistanceBoundarySample?
    public var crossingSample: DistanceBoundarySample?
    public var nextSample: DistanceBoundarySample?
}

public struct DistanceBoundarySample: Codable, Equatable, Sendable {
    public var startDate: Date
    public var endDate: Date
    public var startCumulativeDistanceMeters: Double
    public var endCumulativeDistanceMeters: Double
}

public struct TailDiagnostics: Codable, Equatable, Sendable {
    public var plannedFinalStepEndDate: Date
    public var workoutEndDate: Date
    public var remainingSeconds: Double
    public var remainingMeters: Double?
    public var finalDistanceSampleDate: Date?
    public var finalDistanceSampleCumulativeDistanceMeters: Double?
    public var lastHeartRateSampleDate: Date?
    public var lastPowerSampleDate: Date?
    public var lastCadenceSampleDate: Date?
    public var creationReason: String
}

public struct WorkoutIntervalReconstructionResult: Codable, Equatable, Sendable {
    public var planSource: IntervalPlanSource
    public var windowSource: IntervalWindowSource
    public var intervals: [ReconstructedWorkoutInterval]
    public var notes: [String]

    public init(
        planSource: IntervalPlanSource,
        windowSource: IntervalWindowSource,
        intervals: [ReconstructedWorkoutInterval],
        notes: [String] = []
    ) {
        self.planSource = planSource
        self.windowSource = windowSource
        self.intervals = intervals
        self.notes = notes
    }
}

public enum WorkoutIntervalReconstructionFormat {
    public static func paceRangeDisplay(speedLowerMetersPerSecond lower: Double, speedUpperMetersPerSecond upper: Double) -> String? {
        guard let slowPace = paceSecondsPerKilometer(speedMetersPerSecond: lower),
              let fastPace = paceSecondsPerKilometer(speedMetersPerSecond: upper) else {
            return nil
        }
        return "\(durationLabel(fastPace))-\(durationLabel(slowPace)) /km"
    }

    public static func paceSecondsPerKilometer(speedMetersPerSecond: Double) -> Double? {
        guard speedMetersPerSecond > 0 else { return nil }
        return 1_000 / speedMetersPerSecond
    }

    public static func durationLabel(_ seconds: Double) -> String {
        let rounded = Int((seconds / 5).rounded() * 5)
        return "\(rounded / 60):\(String(format: "%02d", rounded % 60))"
    }
}

public enum WorkoutIntervalReconstructionEngine {
    public static func reconstruct(workout: CanonicalWorkout, evidence: WorkoutEvidence) -> WorkoutIntervalReconstructionResult? {
        guard let audit = evidence.workoutPlanAudit,
              audit.status == .available,
              !audit.plannedSteps.isEmpty else {
            return nil
        }

        var cursor = workout.startDate
        var intervals: [ReconstructedWorkoutInterval] = []
        var notes = [
            "Plan source: WorkoutKit",
            "Window source: Plan-derived from HealthKit distance/time samples",
            "Stats source: HealthKit samples",
            "HealthKit segment markers: not used"
        ]

        for step in audit.plannedSteps {
            guard cursor < workout.endDate else { break }
            let endDate: Date?
            let boundaryResolution: DistanceBoundaryResolution?
            let sourceNoteOverride: String?
            switch step.plannedGoalType {
            case .distance:
                sourceNoteOverride = nil
                if let target = step.plannedGoalValue, target > 0 {
                    boundaryResolution = distanceBoundary(
                        after: target,
                        from: cursor,
                        workout: workout,
                        evidence: evidence
                    )
                    endDate = boundaryResolution?.endDate
                } else {
                    boundaryResolution = nil
                    endDate = nil
                }
            case .time:
                sourceNoteOverride = nil
                boundaryResolution = nil
                if let seconds = step.plannedGoalValue, seconds > 0 {
                    endDate = minDate(cursor.addingTimeInterval(seconds), workout.endDate)
                } else {
                    endDate = nil
                }
            case .open, .energy, .unavailable:
                boundaryResolution = nil
                if step.plannedGoalType == .open && step.stepType == .cooldown {
                    endDate = workout.endDate
                    sourceNoteOverride = "Planned open cooldown extended to workout end"
                } else {
                    endDate = nil
                    sourceNoteOverride = nil
                }
            }

            guard let endDate, endDate > cursor else {
                notes.append("Could not reconstruct \(step.label); missing usable \(step.plannedGoalType.rawValue) evidence.")
                continue
            }

            let interval = reconstructedInterval(
                step: step,
                start: cursor,
                end: endDate,
                workout: workout,
                evidence: evidence,
                sourceNote: sourceNoteOverride ?? sourceNote(for: step, boundaryResolution: boundaryResolution),
                boundaryResolution: boundaryResolution,
                tailDiagnostics: nil
            )
            intervals.append(interval)
            cursor = endDate
        }

        if cursor < workout.endDate {
            let remainingTime = workout.endDate.timeIntervalSince(cursor)
            let tailDistance = intervalDistance(start: cursor, end: workout.endDate, workout: workout, evidence: evidence)
            let remainingDistance = tailDistance ?? 0
            if remainingTime > 5 || remainingDistance > 5 {
                let step = PlannedWorkoutStep(
                    index: intervals.count + 1,
                    label: "Open / Extra",
                    stepType: .open,
                    plannedGoalType: .open,
                    plannedGoalDisplayText: "Open",
                    plannedTargetDisplayText: nil
                )
                intervals.append(
                    reconstructedInterval(
                        step: step,
                        start: cursor,
                        end: workout.endDate,
                        workout: workout,
                        evidence: evidence,
                        sourceNote: "Extra tail after planned WorkoutKit steps",
                        boundaryResolution: nil,
                        tailDiagnostics: tailDiagnostics(
                            plannedFinalStepEnd: cursor,
                            workout: workout,
                            evidence: evidence,
                            remainingTime: remainingTime,
                            remainingDistance: tailDistance,
                            reason: "Remaining workout time or distance exceeded Open / Extra threshold after planned WorkoutKit steps."
                        )
                    )
                )
            }
        }

        guard !intervals.isEmpty else { return nil }
        return WorkoutIntervalReconstructionResult(
            planSource: .workoutKit,
            windowSource: .planDerivedFromDistanceAndTimeSamples,
            intervals: intervals,
            notes: notes
        )
    }

    public static func reconstructFromActivityBoundaries(
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
        guard plannedSteps.count == activities.count,
              !activities.isEmpty else {
            return nil
        }

        var intervals: [ReconstructedWorkoutInterval] = []
        for (step, activity) in zip(plannedSteps, activities) {
            guard let endDate = activity.endDate,
                  endDate > activity.startDate,
                  let distance = activityDistanceMeters(activity) else {
                return nil
            }
            intervals.append(
                reconstructedInterval(
                    step: step,
                    start: activity.startDate,
                    end: endDate,
                    workout: workout,
                    evidence: evidence,
                    sourceNote: "Mapped from WorkoutKit planned step order to public HealthKit activity boundary.",
                    boundaryResolution: nil,
                    tailDiagnostics: nil,
                    actualDistanceOverride: distance,
                    windowSource: .healthKitActivityBoundaries,
                    confidence: .high
                )
            )
        }

        if let lastActivityEnd = activities.last?.endDate,
           lastActivityEnd < workout.endDate {
            let remainingTime = workout.endDate.timeIntervalSince(lastActivityEnd)
            let totalActivityDistance = activities.compactMap(activityDistanceMeters).reduce(0, +)
            let remainingDistance = workout.distanceMeters.map { max(0, $0 - totalActivityDistance) }
                ?? intervalDistance(start: lastActivityEnd, end: workout.endDate, workout: workout, evidence: evidence)
            if remainingTime > 5 || (remainingDistance ?? 0) > 5 {
                let step = PlannedWorkoutStep(
                    index: intervals.count + 1,
                    label: "Open / Extra",
                    stepType: .open,
                    plannedGoalType: .open,
                    plannedGoalDisplayText: "Open",
                    plannedTargetDisplayText: nil
                )
                intervals.append(
                    reconstructedInterval(
                        step: step,
                        start: lastActivityEnd,
                        end: workout.endDate,
                        workout: workout,
                        evidence: evidence,
                        sourceNote: "Inferred from workout end minus final mapped HealthKit activity boundary.",
                        boundaryResolution: nil,
                        tailDiagnostics: tailDiagnostics(
                            plannedFinalStepEnd: lastActivityEnd,
                            workout: workout,
                            evidence: evidence,
                            remainingTime: remainingTime,
                            remainingDistance: remainingDistance,
                            reason: "Remaining workout time or distance exceeded Open / Extra threshold after mapped HealthKit activity rows."
                        ),
                        actualDistanceOverride: remainingDistance,
                        windowSource: .healthKitActivityBoundaries,
                        confidence: .medium
                    )
                )
            }
        }

        guard !intervals.isEmpty else { return nil }
        return WorkoutIntervalReconstructionResult(
            planSource: .workoutKit,
            windowSource: .healthKitActivityBoundaries,
            intervals: intervals,
            notes: [
                "Plan source: WorkoutKit",
                "Window source: Public HealthKit activity boundaries mapped by planned step order",
                "Stats source: HealthKit samples and activity distance statistics",
                "HealthKit segment markers: not used"
            ]
        )
    }

    private static func reconstructedInterval(
        step: PlannedWorkoutStep,
        start: Date,
        end: Date,
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence,
        sourceNote: String,
        boundaryResolution: DistanceBoundaryResolution?,
        tailDiagnostics: TailDiagnostics?,
        actualDistanceOverride: Double? = nil,
        windowSource: IntervalWindowSource = .planDerivedFromDistanceAndTimeSamples,
        confidence confidenceOverride: IntervalReconstructionConfidence? = nil
    ) -> ReconstructedWorkoutInterval {
        let duration = end.timeIntervalSince(start)
        let distance = actualDistanceOverride ?? intervalDistance(start: start, end: end, workout: workout, evidence: evidence)
        let pauseOverlap = WorkoutPauseTimingSemantics.pairedPauseOverlapSeconds(in: evidence.events, start: start, end: end)
        let activeDuration = pauseOverlap.map { max(0, duration - $0) }
        let pace = distance.flatMap { distance -> Double? in
            guard distance > 0 else { return nil }
            return duration / (distance / 1_000)
        }
        let heartRates = values(metric: .heartRate, start: start, end: end, evidence: evidence)
        let cadence = average(values(metric: .cadence, start: start, end: end, evidence: evidence))
            ?? average(values(metric: .stepCount, start: start, end: end, evidence: evidence))
        let power = average(values(metric: .runningPower, start: start, end: end, evidence: evidence))

        let confidence: IntervalReconstructionConfidence = confidenceOverride ?? {
            if step.plannedGoalType == .distance && distance != nil {
                return .high
            } else if step.plannedGoalType == .time {
                return distance == nil ? .medium : .high
            } else {
                return .medium
            }
        }()

        return ReconstructedWorkoutInterval(
            index: step.index,
            label: step.label,
            stepType: step.stepType,
            plannedGoalType: step.plannedGoalType,
            plannedGoalValue: step.plannedGoalValue,
            plannedGoalDisplayText: step.plannedGoalDisplayText,
            plannedTargetDisplayText: step.plannedTargetDisplayText,
            actualStartDate: start,
            actualEndDate: end,
            actualDurationSeconds: duration,
            elapsedDurationSeconds: duration,
            pauseOverlapSeconds: pauseOverlap,
            activeDurationSeconds: activeDuration,
            durationDisplayRule: .elapsedRowWindow,
            actualDistanceMeters: distance,
            actualPaceSecondsPerKm: pace,
            averageHeartRateBpm: average(heartRates),
            maxHeartRateBpm: heartRates.max(),
            averageCadence: cadence,
            averagePower: power,
            planSource: .workoutKit,
            windowSource: windowSource,
            boundaryStrategy: boundaryResolution?.strategy,
            boundaryAdjustmentSeconds: boundaryResolution?.adjustmentSeconds,
            boundaryOvershootMeters: boundaryResolution?.overshootMeters,
            boundaryDiagnostics: boundaryResolution?.diagnostics,
            tailDiagnostics: tailDiagnostics,
            sourceNote: sourceNote,
            confidence: confidence
        )
    }

    private static func sourceNote(
        for step: PlannedWorkoutStep,
        boundaryResolution: DistanceBoundaryResolution?
    ) -> String {
        switch step.plannedGoalType {
        case .distance:
            guard let boundaryResolution else {
                return "Distance-goal window reconstructed from HealthKit distance samples"
            }
            return "Distance-goal boundary: \(boundaryResolution.strategy.label), adjustment \(signedSeconds(boundaryResolution.adjustmentSeconds)), overshoot \(metersLabel(boundaryResolution.overshootMeters))"
        case .time:
            return "Time-goal window reconstructed from WorkoutKit duration; active duration subtracts reliable paired pause overlap."
        case .open:
            return "Open step reconstructed from remaining workout tail"
        case .energy:
            return "Energy-goal steps are not reconstructed in this prototype"
        case .unavailable:
            return "Planned goal unavailable"
        }
    }

    private struct DistanceBoundaryResolution {
        var endDate: Date
        var interpolatedDate: Date
        var strategy: DistanceGoalBoundaryStrategy
        var adjustmentSeconds: Double
        var overshootMeters: Double
        var diagnostics: DistanceBoundaryDiagnostics
    }

    private static func distanceBoundary(
        after targetDistance: Double,
        from start: Date,
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence
    ) -> DistanceBoundaryResolution? {
        guard let startDistance = cumulativeDistance(at: start, workoutStart: workout.startDate, evidence: evidence) else {
            return nil
        }
        return boundaryAtCumulativeDistance(
            startDistance + targetDistance,
            stepGoalDistance: targetDistance,
            stepStartDistance: startDistance,
            workoutStart: workout.startDate,
            evidence: evidence
        )
    }

    private static func intervalDistance(start: Date, end: Date, workout: CanonicalWorkout, evidence: WorkoutEvidence) -> Double? {
        guard let startDistance = cumulativeDistance(at: start, workoutStart: workout.startDate, evidence: evidence),
              let endDistance = cumulativeDistance(at: end, workoutStart: workout.startDate, evidence: evidence),
              endDistance >= startDistance else {
            return nil
        }
        return endDistance - startDistance
    }

    private static func cumulativeDistance(at date: Date, workoutStart: Date, evidence: WorkoutEvidence) -> Double? {
        guard let series = evidence.series[.distance], date >= workoutStart else { return nil }
        var cumulative = 0.0
        var previousDate = workoutStart
        var previousDistance = 0.0

        for point in series.points {
            let currentDistance = cumulative + point.value
            if date <= point.date {
                return interpolatedDistance(
                    date: date,
                    previousDate: previousDate,
                    currentDate: point.date,
                    previousDistance: previousDistance,
                    currentDistance: currentDistance
                )
            }
            cumulative = currentDistance
            previousDistance = cumulative
            previousDate = point.date
        }

        return cumulative
    }

    private static func boundaryAtCumulativeDistance(
        _ targetDistance: Double,
        stepGoalDistance: Double,
        stepStartDistance: Double,
        workoutStart: Date,
        evidence: WorkoutEvidence
    ) -> DistanceBoundaryResolution? {
        guard let series = evidence.series[.distance] else { return nil }
        var cumulative = 0.0
        var previousDate = workoutStart
        var sampleWindows: [DistanceBoundarySample] = []

        for (index, point) in series.points.enumerated() {
            let previousDistance = cumulative
            cumulative += point.value
            let crossingSample = DistanceBoundarySample(
                startDate: previousDate,
                endDate: point.date,
                startCumulativeDistanceMeters: previousDistance,
                endCumulativeDistanceMeters: cumulative
            )
            sampleWindows.append(crossingSample)
            if cumulative >= targetDistance {
                let fraction = interpolationFraction(
                    targetDistance: targetDistance,
                    previousDistance: previousDistance,
                    currentDistance: cumulative,
                    previousDate: previousDate,
                    currentDate: point.date
                )
                let interpolatedDate = previousDate.addingTimeInterval(point.date.timeIntervalSince(previousDate) * fraction)
                let overshoot = max(0, cumulative - targetDistance)
                let nextSample: DistanceBoundarySample?
                if series.points.indices.contains(index + 1) {
                    let nextPoint = series.points[index + 1]
                    nextSample = DistanceBoundarySample(
                        startDate: point.date,
                        endDate: nextPoint.date,
                        startCumulativeDistanceMeters: cumulative,
                        endCumulativeDistanceMeters: cumulative + nextPoint.value
                    )
                } else {
                    nextSample = nil
                }
                let diagnostics = DistanceBoundaryDiagnostics(
                    targetDistanceMeters: stepGoalDistance,
                    cumulativeDistanceAtStartMeters: stepStartDistance,
                    cumulativeDistanceAtEndMeters: cumulative,
                    interpolationFraction: fraction,
                    previousSample: index > 0 ? sampleWindows[index - 1] : nil,
                    crossingSample: crossingSample,
                    nextSample: nextSample
                )
                if shouldUseCrossingSampleEnd(overshootMeters: overshoot, stepGoalDistance: stepGoalDistance) {
                    return DistanceBoundaryResolution(
                        endDate: point.date,
                        interpolatedDate: interpolatedDate,
                        strategy: .crossingSampleEnd,
                        adjustmentSeconds: point.date.timeIntervalSince(interpolatedDate),
                        overshootMeters: overshoot,
                        diagnostics: diagnostics
                    )
                }
                return DistanceBoundaryResolution(
                    endDate: interpolatedDate,
                    interpolatedDate: interpolatedDate,
                    strategy: .interpolatedCrossing,
                    adjustmentSeconds: 0,
                    overshootMeters: overshoot,
                    diagnostics: diagnostics
                )
            }
            previousDate = point.date
        }

        return nil
    }

    private static func shouldUseCrossingSampleEnd(overshootMeters: Double, stepGoalDistance: Double) -> Bool {
        overshootMeters <= crossingSampleEndToleranceMeters(stepGoalDistance: stepGoalDistance)
    }

    private static func crossingSampleEndToleranceMeters(stepGoalDistance: Double) -> Double {
        if stepGoalDistance <= 500 {
            return min(5, stepGoalDistance * 0.01)
        }
        return min(15, max(10, stepGoalDistance * 0.0075))
    }

    private static func interpolatedDistance(
        date: Date,
        previousDate: Date,
        currentDate: Date,
        previousDistance: Double,
        currentDistance: Double
    ) -> Double {
        let timeDelta = currentDate.timeIntervalSince(previousDate)
        guard timeDelta > 0 else { return currentDistance }
        let ratio = min(max(date.timeIntervalSince(previousDate) / timeDelta, 0), 1)
        return previousDistance + ((currentDistance - previousDistance) * ratio)
    }

    private static func interpolationFraction(
        targetDistance: Double,
        previousDistance: Double,
        currentDistance: Double,
        previousDate: Date,
        currentDate: Date
    ) -> Double {
        let distanceDelta = currentDistance - previousDistance
        guard distanceDelta > 0, currentDate > previousDate else { return 1 }
        return min(max((targetDistance - previousDistance) / distanceDelta, 0), 1)
    }

    private static func values(metric: WorkoutEvidenceMetric, start: Date, end: Date, evidence: WorkoutEvidence) -> [Double] {
        evidence.series[metric]?.points
            .filter { $0.date >= start && $0.date <= end }
            .map(\.value) ?? []
    }

    private static func average(_ values: [Double]) -> Double? {
        guard !values.isEmpty else { return nil }
        return values.reduce(0, +) / Double(values.count)
    }

    private static func tailDiagnostics(
        plannedFinalStepEnd: Date,
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence,
        remainingTime: Double,
        remainingDistance: Double?,
        reason: String
    ) -> TailDiagnostics {
        TailDiagnostics(
            plannedFinalStepEndDate: plannedFinalStepEnd,
            workoutEndDate: workout.endDate,
            remainingSeconds: remainingTime,
            remainingMeters: remainingDistance,
            finalDistanceSampleDate: evidence.series[.distance]?.points.last?.date,
            finalDistanceSampleCumulativeDistanceMeters: finalCumulativeDistance(metric: .distance, evidence: evidence),
            lastHeartRateSampleDate: evidence.series[.heartRate]?.points.last?.date,
            lastPowerSampleDate: evidence.series[.runningPower]?.points.last?.date,
            lastCadenceSampleDate: evidence.series[.cadence]?.points.last?.date ?? evidence.series[.stepCount]?.points.last?.date,
            creationReason: reason
        )
    }

    private static func finalCumulativeDistance(metric: WorkoutEvidenceMetric, evidence: WorkoutEvidence) -> Double? {
        guard let points = evidence.series[metric]?.points, !points.isEmpty else { return nil }
        return points.map(\.value).reduce(0, +)
    }

    private static func activityDistanceMeters(_ activity: WorkoutEvidenceActivity) -> Double? {
        activity.statistics.first {
            $0.quantityType == "HKQuantityTypeIdentifierDistanceWalkingRunning"
        }?.sum
    }

    private static func signedSeconds(_ seconds: Double) -> String {
        "\(seconds >= 0 ? "+" : "")\(String(format: "%.1f", seconds))s"
    }

    private static func metersLabel(_ meters: Double) -> String {
        "\(String(format: "%.1f", meters)) m"
    }

    private static func minDate(_ lhs: Date, _ rhs: Date) -> Date {
        lhs <= rhs ? lhs : rhs
    }
}

public enum CustomWorkoutNormalDetailGate {
    public static func supportedIntervals(
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence
    ) -> WorkoutIntervalReconstructionResult? {
        CustomWorkoutResolvedIntervalRows.resolve(workout: workout, evidence: evidence)
        ??
        supportedNarrowSingleFixedDistanceWorkStoppedEarly(workout: workout, evidence: evidence)
        ?? supportedNarrowSimpleFixedDistanceWorkOpenTail(workout: workout, evidence: evidence)
            ?? supportedNarrowWarmupWorkOpenCooldown(workout: workout, evidence: evidence)
            ?? supportedNarrowWarmupWorkFixedCooldownOpenTail(workout: workout, evidence: evidence)
            ?? supportedNarrowRecoveryContainingFixedCooldownOpenTail(workout: workout, evidence: evidence)
            ?? supportedNarrowPausedRepeatBlockOpenCooldown(workout: workout, evidence: evidence)
            ?? supportedNarrowPausedRepeatBlockFixedCooldownOpenTail(workout: workout, evidence: evidence)
            ?? supportedNarrowNoPauseRepeatBlockOpenCooldown(workout: workout, evidence: evidence)
            ?? supportedNarrowNoPauseRepeatBlockFixedCooldownOpenTail(workout: workout, evidence: evidence)
    }

    public static func blockedReasons(
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence
    ) -> [String] {
        if supportedIntervals(workout: workout, evidence: evidence) != nil {
            return []
        }
        guard let audit = evidence.workoutPlanAudit else {
            return ["WorkoutKit plan evidence is missing."]
        }
        guard audit.status == .available else {
            return ["WorkoutKit plan is \(audit.status.label.lowercased())."]
        }

        let plannedSteps = audit.plannedSteps.sorted { $0.index < $1.index }
        let activities = evidence.activities.sorted { $0.startDate < $1.startDate }
        guard !plannedSteps.isEmpty else {
            return ["WorkoutKit plan has no planned rows."]
        }

        var reasons: [String] = []
        if activities.isEmpty {
            reasons.append(CustomWorkoutFallbackReason.missingActivityRows.normalDetailBlockedReasonLabel)
        } else if plannedSteps.count != activities.count {
            reasons.append(CustomWorkoutFallbackReason.activityCountMismatch.normalDetailBlockedReasonLabel)
        }
        if activities.contains(where: { $0.endDate == nil }) {
            reasons.append(CustomWorkoutFallbackReason.missingEndBoundary.normalDetailBlockedReasonLabel)
        }
        if !activityRowsAreContiguous(activities) {
            reasons.append(CustomWorkoutFallbackReason.nonContiguousActivityRows.normalDetailBlockedReasonLabel)
        }
        if plannedSteps.contains(where: { $0.plannedGoalType == .time }) && WorkoutPauseTimingSemantics.hasPauseOrResumeEvents(in: evidence.events) {
            if WorkoutPauseTimingSemantics.pairedPauseIntervals(in: evidence.events) == nil {
                reasons.append("Time-goal rows have unpaired pause/resume evidence, and pause-adjusted timer logic is not enabled yet.")
            } else {
                reasons.append("Time-goal rows have paired pause/resume evidence, and pause-adjusted timer logic is not enabled yet.")
            }
        }
        if !isApprovedNormalDetailShape(plannedSteps) {
            reasons.append("Workout shape is outside the approved normal-detail interval gates.")
        }

        let comparison = approvedComparison(plannedSteps: plannedSteps, activities: activities, workout: workout)
        if comparison.status != .supported {
            reasons.append(comparison.status.normalDetailBlockedReasonLabel)
        }
        for fallback in comparison.fallbackReasons {
            reasons.append(fallback.normalDetailBlockedReasonLabel)
        }
        if comparison.tailAmbiguity != .none {
            reasons.append(comparison.tailAmbiguity.normalDetailBlockedReasonLabel)
        }

        if isApprovedNormalDetailShape(plannedSteps),
           comparison.status == .supported,
           WorkoutIntervalReconstructionEngine.reconstructFromActivityBoundaries(workout: workout, evidence: evidence) == nil {
            reasons.append("RunSignal could not build mapped interval rows from complete HealthKit activity boundaries.")
        }

        return uniqueReasonLabels(reasons)
    }

    public static func supportedNarrowSingleFixedDistanceWorkStoppedEarly(
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence
    ) -> WorkoutIntervalReconstructionResult? {
        guard let audit = evidence.workoutPlanAudit,
              !WorkoutPauseTimingSemantics.hasPauseOrResumeEvents(in: evidence.events) else { return nil }
        let plannedSteps = audit.plannedSteps.sorted { $0.index < $1.index }
        let activities = evidence.activities.sorted { $0.startDate < $1.startDate }
        let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
            plannedSteps: plannedSteps,
            activities: activities,
            workout: workout
        )

        guard comparison.status == .supported,
              isNarrowSingleFixedDistanceWorkStoppedEarly(plannedSteps, activities: activities),
              let result = WorkoutIntervalReconstructionEngine.reconstructFromActivityBoundaries(workout: workout, evidence: evidence),
              result.intervals.count == 1,
              result.intervals.first?.stepType == .work,
              result.intervals.first?.plannedGoalType == .distance,
              result.intervals.map(\.label).contains("Open / Extra") == false else {
            return nil
        }

        return result
    }

    public static func supportedNarrowSimpleFixedDistanceWorkOpenTail(
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence
    ) -> WorkoutIntervalReconstructionResult? {
        guard let audit = evidence.workoutPlanAudit,
              !WorkoutPauseTimingSemantics.hasPauseOrResumeEvents(in: evidence.events) else { return nil }
        let plannedSteps = audit.plannedSteps.sorted { $0.index < $1.index }
        let activities = evidence.activities.sorted { $0.startDate < $1.startDate }
        let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
            plannedSteps: plannedSteps,
            activities: activities,
            workout: workout,
            simpleWorkOpenRuleApproved: true
        )

        guard comparison.status == .supported,
              comparison.tailAmbiguity == .fixedCooldownFollowedByPossibleOpenExtraTail,
              isNarrowSimpleFixedDistanceWorkOpenTail(plannedSteps, activities: activities),
              let result = WorkoutIntervalReconstructionEngine.reconstructFromActivityBoundaries(workout: workout, evidence: evidence),
              result.intervals.count == 2,
              result.intervals[0].stepType == .work,
              result.intervals[0].plannedGoalType == .distance,
              result.intervals[1].stepType == .open,
              result.intervals[1].label == "Open / Extra",
              result.intervals[1].tailDiagnostics != nil else {
            return nil
        }

        return result
    }

    public static func supportedNarrowWarmupWorkOpenCooldown(
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence
    ) -> WorkoutIntervalReconstructionResult? {
        guard let audit = evidence.workoutPlanAudit else { return nil }
        let plannedSteps = audit.plannedSteps.sorted { $0.index < $1.index }
        let activities = evidence.activities.sorted { $0.startDate < $1.startDate }
        let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
            plannedSteps: plannedSteps,
            activities: activities,
            workout: workout
        )

        guard comparison.status == .supported,
              isNarrowWarmupWorkOpenCooldown(plannedSteps),
              let result = WorkoutIntervalReconstructionEngine.reconstructFromActivityBoundaries(workout: workout, evidence: evidence),
              result.intervals.count == 3,
              result.intervals.map(\.stepType) == [.warmup, .work, .cooldown],
              !WorkoutPauseTimingSemantics.hasPauseOrResumeEvents(in: evidence.events) else {
            return nil
        }

        return result
    }

    public static func supportedNarrowNoPauseRepeatBlockFixedCooldownOpenTail(
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence
    ) -> WorkoutIntervalReconstructionResult? {
        guard let audit = evidence.workoutPlanAudit,
              !WorkoutPauseTimingSemantics.hasPauseOrResumeEvents(in: evidence.events) else { return nil }
        let plannedSteps = audit.plannedSteps.sorted { $0.index < $1.index }
        let activities = evidence.activities.sorted { $0.startDate < $1.startDate }
        let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
            plannedSteps: plannedSteps,
            activities: activities,
            workout: workout,
            repeatBlockRuleApproved: true,
            openTailRuleApproved: true
        )

        guard comparison.status == .supported,
              comparison.tailAmbiguity == .fixedCooldownFollowedByPossibleOpenExtraTail,
              isNarrowNoPauseRepeatBlockFixedCooldownOpenTail(plannedSteps),
              let result = WorkoutIntervalReconstructionEngine.reconstructFromActivityBoundaries(workout: workout, evidence: evidence),
              result.intervals.count == plannedSteps.count + 1,
              result.intervals.first?.stepType == .warmup,
              result.intervals.dropLast().last?.stepType == .cooldown,
              result.intervals.last?.stepType == .open,
              result.intervals.last?.tailDiagnostics != nil,
              result.intervals.map(\.stepType).dropFirst().dropLast(2).allSatisfy({ $0 == .work || $0 == .recovery }) else {
            return nil
        }

        return result
    }

    public static func supportedNarrowPausedRepeatBlockFixedCooldownOpenTail(
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence
    ) -> WorkoutIntervalReconstructionResult? {
        guard let audit = evidence.workoutPlanAudit,
              WorkoutPauseTimingSemantics.pairedPauseCount(in: evidence.events) > 0,
              let pairedPauses = WorkoutPauseTimingSemantics.pairedPauseIntervals(in: evidence.events)
        else { return nil }

        let plannedSteps = audit.plannedSteps.sorted { $0.index < $1.index }
        let activities = evidence.activities.sorted { $0.startDate < $1.startDate }
        let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
            plannedSteps: plannedSteps,
            activities: activities,
            workout: workout,
            repeatBlockRuleApproved: true,
            openTailRuleApproved: true,
            pausedRepeatBlockRuleApproved: true,
            pausedRepeatTailRuleApproved: true,
            pairedPauseCount: pairedPauses.count,
            pauseEvidenceState: .paired
        )
        guard comparison.status == .supported,
              comparison.tailAmbiguity == .fixedCooldownFollowedByPossibleOpenExtraTail,
              isNarrowNoPauseRepeatBlockFixedCooldownOpenTail(plannedSteps),
              let result = WorkoutIntervalReconstructionEngine.reconstructFromActivityBoundaries(workout: workout, evidence: evidence),
              result.intervals.count == plannedSteps.count + 1,
              result.intervals.first?.stepType == .warmup,
              result.intervals.dropLast().last?.stepType == .cooldown,
              result.intervals.last?.stepType == .open,
              result.intervals.last?.tailDiagnostics != nil,
              result.intervals.map(\.stepType).dropFirst().dropLast(2).allSatisfy({ $0 == .work || $0 == .recovery }),
              activityRowsMatchReconstructedRows(result: result, activities: activities, workout: workout),
              pausesAreAssignableToSingleRows(pairedPauses, intervals: result.intervals),
              result.intervals.contains(where: { ($0.pauseOverlapSeconds ?? 0) > 0 })
        else {
            return nil
        }

        return activeTimerDisplayForPausedRows(result)
    }

    public static func supportedNarrowWarmupWorkFixedCooldownOpenTail(
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence
    ) -> WorkoutIntervalReconstructionResult? {
        guard let audit = evidence.workoutPlanAudit else { return nil }
        let plannedSteps = audit.plannedSteps.sorted { $0.index < $1.index }
        let activities = evidence.activities.sorted { $0.startDate < $1.startDate }
        let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
            plannedSteps: plannedSteps,
            activities: activities,
            workout: workout,
            openTailRuleApproved: true
        )

        guard comparison.status == .supported,
              comparison.tailAmbiguity == .fixedCooldownFollowedByPossibleOpenExtraTail,
              isNarrowWarmupWorkFixedCooldownOpenTail(plannedSteps),
              let result = WorkoutIntervalReconstructionEngine.reconstructFromActivityBoundaries(workout: workout, evidence: evidence),
              result.intervals.count == 4,
              result.intervals.map(\.stepType) == [.warmup, .work, .cooldown, .open],
              result.intervals.last?.tailDiagnostics != nil,
              !WorkoutPauseTimingSemantics.hasPauseOrResumeEvents(in: evidence.events) else {
            return nil
        }

        return result
    }

    public static func supportedNarrowRecoveryContainingFixedCooldownOpenTail(
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence
    ) -> WorkoutIntervalReconstructionResult? {
        guard let audit = evidence.workoutPlanAudit else { return nil }

        let pairedPauses: [DateInterval]
        if let intervals = WorkoutPauseTimingSemantics.pairedPauseIntervals(in: evidence.events) {
            pairedPauses = intervals
        } else if WorkoutPauseTimingSemantics.hasPauseOrResumeEvents(in: evidence.events) {
            return nil
        } else {
            pairedPauses = []
        }

        let plannedSteps = audit.plannedSteps.sorted { $0.index < $1.index }
        let activities = evidence.activities.sorted { $0.startDate < $1.startDate }
        let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
            plannedSteps: plannedSteps,
            activities: activities,
            workout: workout,
            recoveryContainingOpenTailRuleApproved: true,
            pairedPauseCount: pairedPauses.count
        )

        guard comparison.status == .supported,
              comparison.tailAmbiguity == .fixedCooldownFollowedByPossibleOpenExtraTail,
              isNarrowRecoveryContainingFixedCooldownOpenTail(plannedSteps),
              let result = WorkoutIntervalReconstructionEngine.reconstructFromActivityBoundaries(workout: workout, evidence: evidence),
              result.intervals.count == plannedSteps.count + 1,
              result.intervals.last?.stepType == .open,
              result.intervals.last?.tailDiagnostics != nil,
              result.intervals.dropLast().map(\.stepType) == plannedSteps.map(\.stepType),
              activityRowsMatchReconstructedRows(result: result, activities: activities, workout: workout),
              pausesAreAssignableToSingleRows(pairedPauses, intervals: result.intervals) else {
            return nil
        }

        return activeTimerDisplayForPausedRows(result)
    }

    public static func supportedNarrowNoPauseRepeatBlockOpenCooldown(
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence
    ) -> WorkoutIntervalReconstructionResult? {
        guard let audit = evidence.workoutPlanAudit,
              !WorkoutPauseTimingSemantics.hasPauseOrResumeEvents(in: evidence.events) else { return nil }
        let plannedSteps = audit.plannedSteps.sorted { $0.index < $1.index }
        let activities = evidence.activities.sorted { $0.startDate < $1.startDate }
        let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
            plannedSteps: plannedSteps,
            activities: activities,
            workout: workout,
            repeatBlockRuleApproved: true
        )

        guard comparison.status == .supported,
              comparison.tailAmbiguity == .plannedOpenCooldownContinuesToWorkoutEnd,
              isNarrowNoPauseRepeatBlockOpenCooldown(plannedSteps),
              let result = WorkoutIntervalReconstructionEngine.reconstructFromActivityBoundaries(workout: workout, evidence: evidence),
              result.intervals.count == plannedSteps.count,
              result.intervals.first?.stepType == .warmup,
              result.intervals.last?.stepType == .cooldown,
              result.intervals.map(\.stepType).dropFirst().dropLast().allSatisfy({ $0 == .work || $0 == .recovery }),
              result.intervals.map(\.label).contains("Open / Extra") == false else {
            return nil
        }

        return result
    }

    public static func supportedNarrowPausedRepeatBlockOpenCooldown(
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence
    ) -> WorkoutIntervalReconstructionResult? {
        guard
            let audit = evidence.workoutPlanAudit,
            WorkoutPauseTimingSemantics.pairedPauseCount(in: evidence.events) > 0,
            let pairedPauses = WorkoutPauseTimingSemantics.pairedPauseIntervals(in: evidence.events)
        else { return nil }

        let plannedSteps = audit.plannedSteps.sorted { $0.index < $1.index }
        let activities = evidence.activities.sorted { $0.startDate < $1.startDate }
        let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
            plannedSteps: plannedSteps,
            activities: activities,
            workout: workout,
            repeatBlockRuleApproved: true,
            pausedRepeatBlockRuleApproved: true,
            pairedPauseCount: pairedPauses.count
        )

        guard
            comparison.status == .supported,
            comparison.tailAmbiguity == .plannedOpenCooldownContinuesToWorkoutEnd,
            isNarrowNoPauseRepeatBlockOpenCooldown(plannedSteps),
            let result = WorkoutIntervalReconstructionEngine.reconstructFromActivityBoundaries(workout: workout, evidence: evidence),
            result.intervals.count == plannedSteps.count,
            result.intervals.first?.stepType == .warmup,
            result.intervals.last?.stepType == .cooldown,
            result.intervals.allSatisfy({ $0.stepType != .open && $0.tailDiagnostics == nil }),
            pausesAreAssignableToSingleRows(pairedPauses, intervals: result.intervals),
            result.intervals.contains(where: { ($0.pauseOverlapSeconds ?? 0) > 0 })
        else { return nil }

        return activeTimerDisplayForPausedRows(result)
    }

    private static func isNarrowWarmupWorkOpenCooldown(_ plannedSteps: [PlannedWorkoutStep]) -> Bool {
        guard plannedSteps.count == 3 else { return false }
        let warmup = plannedSteps[0]
        let work = plannedSteps[1]
        let cooldown = plannedSteps[2]

        return warmup.stepType == .warmup
            && warmup.plannedGoalType == .distance
            && abs((warmup.plannedGoalValue ?? 0) - 2_000) <= 1
            && work.stepType == .work
            && (work.repeatIndex ?? 1) == 1
            && cooldown.stepType == .cooldown
            && cooldown.plannedGoalType == .open
    }

    private static func isNarrowWarmupWorkFixedCooldownOpenTail(_ plannedSteps: [PlannedWorkoutStep]) -> Bool {
        guard plannedSteps.count == 3 else { return false }
        let warmup = plannedSteps[0]
        let work = plannedSteps[1]
        let cooldown = plannedSteps[2]

        return warmup.stepType == .warmup
            && warmup.plannedGoalType == .distance
            && abs((warmup.plannedGoalValue ?? 0) - 2_000) <= 1
            && work.stepType == .work
            && (work.repeatIndex ?? 1) == 1
            && (work.plannedGoalType == .time || work.plannedGoalType == .distance)
            && cooldown.stepType == .cooldown
            && (cooldown.plannedGoalType == .time || cooldown.plannedGoalType == .distance)
    }

    private static func isNarrowRecoveryContainingFixedCooldownOpenTail(_ plannedSteps: [PlannedWorkoutStep]) -> Bool {
        guard plannedSteps.count == 4 else { return false }

        let stepTypes = plannedSteps.map(\.stepType)
        guard stepTypes == [.warmup, .recovery, .work, .cooldown],
              plannedSteps.allSatisfy({ $0.repeatBlockIndex == nil && $0.repeatIndex == nil }),
              plannedSteps.allSatisfy({ $0.plannedGoalType == .distance || $0.plannedGoalType == .time }) else {
            return false
        }

        let warmup = plannedSteps[0]
        let finalCooldown = plannedSteps[3]

        return warmup.plannedGoalType == .distance
            && abs((warmup.plannedGoalValue ?? 0) - 2_000) <= 1
            && finalCooldown.stepType == .cooldown
            && (finalCooldown.plannedGoalType == .distance || finalCooldown.plannedGoalType == .time)
    }

    private static func isNarrowNoPauseRepeatBlockOpenCooldown(_ plannedSteps: [PlannedWorkoutStep]) -> Bool {
        guard plannedSteps.count >= 6,
              let warmup = plannedSteps.first,
              let cooldown = plannedSteps.last else { return false }

        let repeatedSteps = plannedSteps.dropFirst().dropLast()
        let repeatIndexes = repeatedSteps.compactMap(\.repeatIndex)

        guard warmup.stepType == .warmup,
              warmup.plannedGoalType == .distance,
              abs((warmup.plannedGoalValue ?? 0) - 2_000) <= 1,
              cooldown.stepType == .cooldown,
              cooldown.plannedGoalType == .open,
              repeatIndexes.contains(where: { $0 > 1 }),
              repeatedSteps.allSatisfy({ $0.repeatBlockIndex != nil && $0.repeatIndex != nil }),
              repeatedSteps.count.isMultiple(of: 2) else {
            return false
        }

        for (offset, step) in repeatedSteps.enumerated() {
            let expectedType: DerivedIntervalLabel = offset.isMultiple(of: 2) ? .work : .recovery
            if step.stepType != expectedType {
                return false
            }
        }

        return true
    }

    private static func isNarrowNoPauseRepeatBlockFixedCooldownOpenTail(_ plannedSteps: [PlannedWorkoutStep]) -> Bool {
        guard isNarrowRepeatBlockShape(plannedSteps),
              let cooldown = plannedSteps.last else {
            return false
        }
        return cooldown.plannedGoalType == .time || cooldown.plannedGoalType == .distance
    }

    private static func isNarrowSingleFixedDistanceWorkStoppedEarly(
        _ plannedSteps: [PlannedWorkoutStep],
        activities: [WorkoutEvidenceActivity]
    ) -> Bool {
        guard isNarrowSingleFixedDistanceWorkShape(plannedSteps),
              activities.count == 1,
              let step = plannedSteps.first,
              let activity = activities.first,
              let plannedDistance = step.plannedGoalValue,
              let activityDistance = activityDistanceMeters(activity),
              activityDistance > 0,
              activityDistance < plannedDistance - activityDistanceToleranceMeters(plannedDistance),
              activity.endDate != nil else {
            return false
        }

        return true
    }

    private static func isNarrowSimpleFixedDistanceWorkOpenTail(
        _ plannedSteps: [PlannedWorkoutStep],
        activities: [WorkoutEvidenceActivity]
    ) -> Bool {
        guard isNarrowSingleFixedDistanceWorkShape(plannedSteps),
              activities.count == 1,
              let step = plannedSteps.first,
              let activity = activities.first,
              let plannedDistance = step.plannedGoalValue,
              let activityDistance = activityDistanceMeters(activity),
              activityDistance >= plannedDistance - activityDistanceToleranceMeters(plannedDistance),
              activity.endDate != nil else {
            return false
        }

        return true
    }

    private static func isNarrowSingleFixedDistanceWorkShape(_ plannedSteps: [PlannedWorkoutStep]) -> Bool {
        guard plannedSteps.count == 1,
              let step = plannedSteps.first else { return false }

        return step.stepType == .work
            && step.plannedGoalType == .distance
            && (step.plannedGoalValue ?? 0) > 0
            && (step.repeatIndex ?? 1) == 1
    }

    private static func isNarrowRepeatBlockShape(_ plannedSteps: [PlannedWorkoutStep]) -> Bool {
        guard plannedSteps.count >= 6,
              let warmup = plannedSteps.first,
              let cooldown = plannedSteps.last else { return false }

        let repeatedSteps = plannedSteps.dropFirst().dropLast()
        let repeatIndexes = repeatedSteps.compactMap(\.repeatIndex)

        guard warmup.stepType == .warmup,
              warmup.plannedGoalType == .distance,
              abs((warmup.plannedGoalValue ?? 0) - 2_000) <= 1,
              cooldown.stepType == .cooldown,
              repeatIndexes.contains(where: { $0 > 1 }),
              repeatedSteps.allSatisfy({ $0.repeatBlockIndex != nil && $0.repeatIndex != nil }),
              repeatedSteps.count.isMultiple(of: 2) else {
            return false
        }

        for (offset, step) in repeatedSteps.enumerated() {
            let expectedType: DerivedIntervalLabel = offset.isMultiple(of: 2) ? .work : .recovery
            if step.stepType != expectedType {
                return false
            }
        }

        return true
    }

    private static func isApprovedNormalDetailShape(_ plannedSteps: [PlannedWorkoutStep]) -> Bool {
        isNarrowSingleFixedDistanceWorkShape(plannedSteps)
            || isNarrowWarmupWorkOpenCooldown(plannedSteps)
            || isNarrowWarmupWorkFixedCooldownOpenTail(plannedSteps)
            || isNarrowRecoveryContainingFixedCooldownOpenTail(plannedSteps)
            || isNarrowNoPauseRepeatBlockOpenCooldown(plannedSteps)
            || isNarrowNoPauseRepeatBlockFixedCooldownOpenTail(plannedSteps)
    }

    private static func activeTimerDisplayForPausedRows(
        _ result: WorkoutIntervalReconstructionResult
    ) -> WorkoutIntervalReconstructionResult {
        var adjusted = result
        adjusted.intervals = result.intervals.map { interval in
            var row = interval
            guard (row.pauseOverlapSeconds ?? 0) > 0 else { return row }

            row.durationDisplayRule = .activeTimer
            row.activeDurationSeconds = max(0, row.elapsedRowWindowDurationSeconds - (row.pauseOverlapSeconds ?? 0))

            if let distance = row.actualDistanceMeters,
               distance > 0,
               row.activeTimerDurationSeconds > 0 {
                row.actualPaceSecondsPerKm = row.activeTimerDurationSeconds / (distance / 1_000)
            }

            return row
        }
        return adjusted
    }

    private static func pausesAreAssignableToSingleRows(
        _ pauseIntervals: [DateInterval],
        intervals: [ReconstructedWorkoutInterval]
    ) -> Bool {
        pauseIntervals.allSatisfy { pauseInterval in
            let containingRows = intervals.filter { interval in
                pauseInterval.start >= interval.actualStartDate.addingTimeInterval(-activityTimeToleranceSeconds)
                    && pauseInterval.end <= interval.actualEndDate.addingTimeInterval(activityTimeToleranceSeconds)
            }
            return containingRows.count == 1
        }
    }

    private static func approvedComparison(
        plannedSteps: [PlannedWorkoutStep],
        activities: [WorkoutEvidenceActivity],
        workout: CanonicalWorkout
    ) -> DebugCustomWorkoutComparison {
        DebugCustomWorkoutComparisonBuilder.comparison(
            plannedSteps: plannedSteps,
            activities: activities,
            workout: workout,
            repeatBlockRuleApproved: isNarrowNoPauseRepeatBlockOpenCooldown(plannedSteps)
                || isNarrowNoPauseRepeatBlockFixedCooldownOpenTail(plannedSteps),
            openTailRuleApproved: isNarrowWarmupWorkFixedCooldownOpenTail(plannedSteps)
                || isNarrowNoPauseRepeatBlockFixedCooldownOpenTail(plannedSteps),
            simpleWorkOpenRuleApproved: true,
            recoveryContainingOpenTailRuleApproved: isNarrowRecoveryContainingFixedCooldownOpenTail(plannedSteps)
        )
    }

    private static func activityRowsMatchReconstructedRows(
        result: WorkoutIntervalReconstructionResult,
        activities: [WorkoutEvidenceActivity],
        workout: CanonicalWorkout
    ) -> Bool {
        let plannedIntervals = result.intervals.filter { $0.stepType != .open }
        guard plannedIntervals.count == activities.count else { return false }

        for (interval, activity) in zip(plannedIntervals, activities) {
            guard let activityEnd = activity.endDate,
                  abs(activity.startDate.timeIntervalSince(interval.actualStartDate)) <= activityTimeToleranceSeconds,
                  abs(activityEnd.timeIntervalSince(interval.actualEndDate)) <= activityTimeToleranceSeconds,
                  let activityDistance = activityDistanceMeters(activity),
                  let intervalDistance = interval.actualDistanceMeters,
                  abs(activityDistance - intervalDistance) <= activityDistanceToleranceMeters(activityDistance) else {
                return false
            }
        }

        let openTail = result.intervals.last?.stepType == .open ? result.intervals.last : nil
        if let openTail {
            guard let lastActivityEnd = activities.last?.endDate,
                  abs(lastActivityEnd.timeIntervalSince(openTail.actualStartDate)) <= activityTimeToleranceSeconds,
                  abs(workout.endDate.timeIntervalSince(openTail.actualEndDate)) <= activityTimeToleranceSeconds else {
                return false
            }

            if let workoutDistance = workout.distanceMeters,
               let tailDistance = openTail.actualDistanceMeters {
                let activityDistanceTotal = activities.compactMap(activityDistanceMeters).reduce(0, +)
                let expectedTailDistance = max(0, workoutDistance - activityDistanceTotal)
                if abs(expectedTailDistance - tailDistance) > activityDistanceToleranceMeters(max(expectedTailDistance, tailDistance)) {
                    return false
                }
            }
        }

        return true
    }

    private static var activityTimeToleranceSeconds: Double { 3 }

    private static func activityDistanceToleranceMeters(_ distanceMeters: Double) -> Double {
        max(10, min(25, distanceMeters * 0.02))
    }

    private static func activityDistanceMeters(_ activity: WorkoutEvidenceActivity) -> Double? {
        activity.statistics.first {
            $0.quantityType == "HKQuantityTypeIdentifierDistanceWalkingRunning"
        }?.sum
    }

    private static func activityRowsAreContiguous(_ activities: [WorkoutEvidenceActivity]) -> Bool {
        guard activities.count > 1 else { return true }
        for index in activities.indices.dropFirst() {
            guard let previousEnd = activities[index - 1].endDate else { return false }
            if abs(activities[index].startDate.timeIntervalSince(previousEnd)) > 1 {
                return false
            }
        }
        return true
    }

    private static func uniqueReasonLabels(_ reasons: [String]) -> [String] {
        var seen: Set<String> = []
        return reasons.filter { seen.insert($0).inserted }
    }

}
