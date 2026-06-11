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
    case unavailable

    public var label: String {
        switch self {
        case .planDerivedFromDistanceAndTimeSamples: "Plan-derived from HealthKit distance/time samples"
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
    public var actualDistanceMeters: Double?
    public var actualPaceSecondsPerKm: Double?
    public var averageHeartRateBpm: Double?
    public var maxHeartRateBpm: Double?
    public var averageCadence: Double?
    public var averagePower: Double?
    public var planSource: IntervalPlanSource
    public var windowSource: IntervalWindowSource
    public var sourceNote: String
    public var confidence: IntervalReconstructionConfidence
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
            switch step.plannedGoalType {
            case .distance:
                if let target = step.plannedGoalValue, target > 0 {
                    endDate = dateAfterDistance(target, from: cursor, workout: workout, evidence: evidence)
                } else {
                    endDate = nil
                }
            case .time:
                if let seconds = step.plannedGoalValue, seconds > 0 {
                    endDate = minDate(cursor.addingTimeInterval(seconds), workout.endDate)
                } else {
                    endDate = nil
                }
            case .open, .energy, .unavailable:
                endDate = nil
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
                sourceNote: sourceNote(for: step)
            )
            intervals.append(interval)
            cursor = endDate
        }

        if cursor < workout.endDate {
            let remainingTime = workout.endDate.timeIntervalSince(cursor)
            let remainingDistance = intervalDistance(start: cursor, end: workout.endDate, workout: workout, evidence: evidence) ?? 0
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
                        sourceNote: "Extra tail after planned WorkoutKit steps"
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

    private static func reconstructedInterval(
        step: PlannedWorkoutStep,
        start: Date,
        end: Date,
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence,
        sourceNote: String
    ) -> ReconstructedWorkoutInterval {
        let duration = end.timeIntervalSince(start)
        let distance = intervalDistance(start: start, end: end, workout: workout, evidence: evidence)
        let pace = distance.flatMap { distance -> Double? in
            guard distance > 0 else { return nil }
            return duration / (distance / 1_000)
        }
        let heartRates = values(metric: .heartRate, start: start, end: end, evidence: evidence)
        let cadence = average(values(metric: .cadence, start: start, end: end, evidence: evidence))
            ?? average(values(metric: .stepCount, start: start, end: end, evidence: evidence))
        let power = average(values(metric: .runningPower, start: start, end: end, evidence: evidence))

        let confidence: IntervalReconstructionConfidence
        if step.plannedGoalType == .distance && distance != nil {
            confidence = .high
        } else if step.plannedGoalType == .time {
            confidence = distance == nil ? .medium : .high
        } else {
            confidence = .medium
        }

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
            actualDistanceMeters: distance,
            actualPaceSecondsPerKm: pace,
            averageHeartRateBpm: average(heartRates),
            maxHeartRateBpm: heartRates.max(),
            averageCadence: cadence,
            averagePower: power,
            planSource: .workoutKit,
            windowSource: .planDerivedFromDistanceAndTimeSamples,
            sourceNote: sourceNote,
            confidence: confidence
        )
    }

    private static func sourceNote(for step: PlannedWorkoutStep) -> String {
        switch step.plannedGoalType {
        case .distance: "Distance-goal window reconstructed from HealthKit distance samples"
        case .time: "Time-goal window reconstructed from WorkoutKit duration; TODO pause-adjusted active duration"
        case .open: "Open step reconstructed from remaining workout tail"
        case .energy: "Energy-goal steps are not reconstructed in this prototype"
        case .unavailable: "Planned goal unavailable"
        }
    }

    private static func dateAfterDistance(
        _ targetDistance: Double,
        from start: Date,
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence
    ) -> Date? {
        guard let startDistance = cumulativeDistance(at: start, workoutStart: workout.startDate, evidence: evidence) else {
            return nil
        }
        return dateAtCumulativeDistance(startDistance + targetDistance, workoutStart: workout.startDate, evidence: evidence)
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

    private static func dateAtCumulativeDistance(_ targetDistance: Double, workoutStart: Date, evidence: WorkoutEvidence) -> Date? {
        guard let series = evidence.series[.distance] else { return nil }
        var cumulative = 0.0
        var previousDate = workoutStart

        for point in series.points {
            let previousDistance = cumulative
            cumulative += point.value
            if cumulative >= targetDistance {
                return interpolatedDate(
                    targetDistance: targetDistance,
                    previousDistance: previousDistance,
                    currentDistance: cumulative,
                    previousDate: previousDate,
                    currentDate: point.date
                )
            }
            previousDate = point.date
        }

        return nil
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

    private static func interpolatedDate(
        targetDistance: Double,
        previousDistance: Double,
        currentDistance: Double,
        previousDate: Date,
        currentDate: Date
    ) -> Date {
        let distanceDelta = currentDistance - previousDistance
        guard distanceDelta > 0 else { return currentDate }
        let ratio = min(max((targetDistance - previousDistance) / distanceDelta, 0), 1)
        return previousDate.addingTimeInterval(currentDate.timeIntervalSince(previousDate) * ratio)
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

    private static func minDate(_ lhs: Date, _ rhs: Date) -> Date {
        lhs <= rhs ? lhs : rhs
    }
}
