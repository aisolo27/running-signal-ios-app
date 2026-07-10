import Foundation

public struct CanonicalPaceRange: Codable, Equatable, Hashable, Sendable {
    public var fastestSecondsPerKilometer: Double
    public var slowestSecondsPerKilometer: Double

    public init(fastestSecondsPerKilometer: Double, slowestSecondsPerKilometer: Double) {
        self.fastestSecondsPerKilometer = min(fastestSecondsPerKilometer, slowestSecondsPerKilometer)
        self.slowestSecondsPerKilometer = max(fastestSecondsPerKilometer, slowestSecondsPerKilometer)
    }

    public func contains(_ paceSecondsPerKilometer: Double) -> Bool {
        paceSecondsPerKilometer >= fastestSecondsPerKilometer
            && paceSecondsPerKilometer <= slowestSecondsPerKilometer
    }
}

public enum WorkTargetResult: String, Codable, Equatable, Hashable, Sendable {
    case onTarget
    case fast
    case slow
    case noTarget
}

public enum WorkCompletionStatus: String, Codable, Equatable, Hashable, Sendable {
    case completed
    case shortened
    case openEnded
}

public enum WorkPaceMeasurementBasis: String, Codable, Equatable, Hashable, Sendable {
    case completedGoalWindow
    case completedPlannedDistance
    case shortenedMeasured
    case measured
    case unavailable
}

public struct WorkPaceMeasurement: Codable, Equatable, Sendable {
    public var paceSecondsPerKilometer: Double?
    public var durationSeconds: Double?
    public var distanceMeters: Double?
    public var basis: WorkPaceMeasurementBasis
}

public struct WorkTargetEvaluation: Codable, Equatable, Sendable {
    public var rowIndex: Int
    public var targetRange: CanonicalPaceRange?
    public var result: WorkTargetResult
    public var completionStatus: WorkCompletionStatus
    public var measurement: WorkPaceMeasurement
}

public enum WorkTargetEvaluator {
    public static func evaluate(
        interval: ReconstructedWorkoutInterval,
        plannedTargets: [PlannedWorkoutTarget]? = nil,
        completionRatio: Double = 0.9
    ) -> WorkTargetEvaluation? {
        guard interval.stepType == .work else { return nil }

        let completion = completionStatus(interval: interval, completionRatio: completionRatio)
        let measurement = paceMeasurement(interval: interval, completionStatus: completion)
        let range = canonicalPaceRange(from: plannedTargets ?? interval.plannedTargets)
        let result: WorkTargetResult
        if let range, let pace = measurement.paceSecondsPerKilometer {
            if range.contains(pace) {
                result = .onTarget
            } else if pace < range.fastestSecondsPerKilometer {
                result = .fast
            } else {
                result = .slow
            }
        } else {
            result = .noTarget
        }

        return WorkTargetEvaluation(
            rowIndex: interval.index,
            targetRange: range,
            result: result,
            completionStatus: completion,
            measurement: measurement
        )
    }

    public static func canonicalPaceRange(from targets: [PlannedWorkoutTarget]?) -> CanonicalPaceRange? {
        guard let target = targets?.first(where: {
                  ($0.kind == .pace || $0.kind == .speed) && $0.semantics != .threshold
              }),
              let lower = target.lowerBound,
              let upper = target.upperBound,
              lower > 0,
              upper > 0,
              let firstPace = paceSecondsPerKilometer(value: lower, unit: target.unit),
              let secondPace = paceSecondsPerKilometer(value: upper, unit: target.unit)
        else {
            return nil
        }
        return CanonicalPaceRange(
            fastestSecondsPerKilometer: min(firstPace, secondPace),
            slowestSecondsPerKilometer: max(firstPace, secondPace)
        )
    }

    private static func completionStatus(
        interval: ReconstructedWorkoutInterval,
        completionRatio: Double
    ) -> WorkCompletionStatus {
        switch interval.plannedGoalType {
        case .distance:
            guard let goal = interval.plannedGoalValue, goal > 0,
                  let measured = interval.actualDistanceMeters
            else { return .shortened }
            return measured >= goal * completionRatio ? .completed : .shortened
        case .time:
            guard let goal = interval.plannedGoalValue, goal > 0 else { return .shortened }
            return interval.activeTimerDurationSeconds >= goal * completionRatio ? .completed : .shortened
        case .open, .energy, .unavailable:
            return .openEnded
        }
    }

    private static func paceMeasurement(
        interval: ReconstructedWorkoutInterval,
        completionStatus: WorkCompletionStatus
    ) -> WorkPaceMeasurement {
        if interval.plannedGoalType == .distance,
           completionStatus == .completed,
           let plannedDistance = interval.plannedGoalValue,
           plannedDistance > 0 {
            let duration = interval.activeTimerDurationSeconds
            return WorkPaceMeasurement(
                paceSecondsPerKilometer: pace(durationSeconds: duration, distanceMeters: plannedDistance),
                durationSeconds: duration > 0 ? duration : nil,
                distanceMeters: plannedDistance,
                basis: .completedPlannedDistance
            )
        }

        let duration = interval.activeTimerDurationSeconds
        let distance = interval.actualDistanceMeters
        return WorkPaceMeasurement(
            paceSecondsPerKilometer: pace(durationSeconds: duration, distanceMeters: distance),
            durationSeconds: duration > 0 ? duration : nil,
            distanceMeters: distance,
            basis: completionStatus == .shortened ? .shortenedMeasured : .measured
        )
    }

    private static func pace(durationSeconds: Double, distanceMeters: Double?) -> Double? {
        guard durationSeconds > 0, let distanceMeters, distanceMeters > 0 else { return nil }
        return durationSeconds / (distanceMeters / 1_000)
    }

    private static func paceSecondsPerKilometer(value: Double, unit: String?) -> Double? {
        let normalized = (unit ?? "m/s")
            .lowercased()
            .replacingOccurrences(of: " ", with: "")
        switch normalized {
        case "m/s", "m·s⁻¹", "m·s-1":
            return 1_000 / value
        case "km/h", "km/hr", "kph":
            return 3_600 / value
        case "mi/h", "mph":
            return 3_600 / (value * 1.609_344)
        case "s/km", "sec/km", "seconds/km":
            return value
        case "min/km", "minutes/km":
            return value * 60
        default:
            return nil
        }
    }
}

public struct IntervalGoalSignature: Codable, Equatable, Hashable, Sendable {
    public var type: PlannedWorkoutGoalType
    public var value: Double?

    public init(type: PlannedWorkoutGoalType, value: Double?) {
        self.type = type
        self.value = value.map { ($0 * 10).rounded() / 10 }
    }
}

public struct IntervalPrescriptionSignature: Codable, Equatable, Hashable, Sendable {
    public var workGoals: [IntervalGoalSignature]
    public var recoveryGoals: [IntervalGoalSignature]
    public var workCount: Int
    public var recoveryCount: Int
    public var paceTarget: CanonicalPaceRange?
}

public struct OfficialIntervalWorkout: Codable, Equatable, Sendable {
    public var workoutID: String
    public var startDate: Date
    public var rows: [ReconstructedWorkoutInterval]
    public var plannedTargetsByRow: [Int: [PlannedWorkoutTarget]]

    public init(
        workoutID: String,
        startDate: Date,
        rows: [ReconstructedWorkoutInterval],
        plannedTargetsByRow: [Int: [PlannedWorkoutTarget]] = [:]
    ) {
        self.workoutID = workoutID
        self.startDate = startDate
        self.rows = rows
        self.plannedTargetsByRow = plannedTargetsByRow
    }
}

enum OfficialIntervalWorkoutMerger {
    static func merged(
        persisted: [OfficialIntervalWorkout],
        loaded: [OfficialIntervalWorkout]
    ) -> [OfficialIntervalWorkout] {
        var workoutsByID: [String: OfficialIntervalWorkout] = [:]
        for workout in persisted {
            workoutsByID[workout.workoutID] = workout
        }
        for workout in loaded {
            workoutsByID[workout.workoutID] = workout
        }
        return workoutsByID.values.sorted {
            if $0.startDate != $1.startDate {
                return $0.startDate > $1.startDate
            }
            return $0.workoutID < $1.workoutID
        }
    }
}

enum WorkTargetPresentation {
    static func badgeLabel(for evaluation: WorkTargetEvaluation) -> String {
        let result = resultLabel(evaluation.result)
        switch evaluation.completionStatus {
        case .shortened:
            return "\(result) · Shortened"
        case .openEnded:
            return "\(result) · Open"
        case .completed:
            return result
        }
    }

    static func summaryText(_ evaluations: [WorkTargetEvaluation]) -> String {
        let targeted = evaluations.filter { $0.result != .noTarget }
        let hit = targeted.count { $0.result == .onTarget }
        let fast = targeted.count { $0.result == .fast }
        let slow = targeted.count { $0.result == .slow }
        let shortened = targeted.count { $0.completionStatus == .shortened }
        let shortenedText = shortened > 0 ? " · \(shortened) shortened" : ""
        return "\(hit) of \(targeted.count) on target · \(fast) fast · \(slow) slow\(shortenedText)"
    }

    static func resultLabel(_ result: WorkTargetResult) -> String {
        switch result {
        case .onTarget: "On Target"
        case .fast: "Fast"
        case .slow: "Slow"
        case .noTarget: "No Target"
        }
    }

    static func completionLabel(_ completion: WorkCompletionStatus) -> String {
        switch completion {
        case .completed: "Completed"
        case .shortened: "Shortened"
        case .openEnded: "Open"
        }
    }
}

public struct IntervalTrendPoint: Identifiable, Equatable, Sendable {
    public var id: String { workoutID }
    public var workoutID: String
    public var startDate: Date
    public var workCount: Int
    public var aggregatePaceSecondsPerKilometer: Double?
    public var onTargetCount: Int
    public var fastCount: Int
    public var slowCount: Int
    public var noTargetCount: Int
    public var shortenedCount: Int
    public var fadePercent: Double?
    public var consistencyCoefficientOfVariationPercent: Double?
    public var durationWeightedHeartRate: Double?
    public var durationWeightedPower: Double?
}

public struct IntervalLibraryGroup: Identifiable, Equatable, Sendable {
    public var id: IntervalPrescriptionSignature { signature }
    public var signature: IntervalPrescriptionSignature
    public var workouts: [OfficialIntervalWorkout]
    public var trendPoints: [IntervalTrendPoint]
}

public enum IntervalLibraryBuilder {
    public static func groups(from workouts: [OfficialIntervalWorkout]) -> [IntervalLibraryGroup] {
        let signed = workouts.compactMap { workout -> (IntervalPrescriptionSignature, OfficialIntervalWorkout)? in
            guard let signature = signature(for: workout) else { return nil }
            return (signature, workout)
        }
        let grouped = Dictionary(grouping: signed, by: \.0)
        return grouped.map { signature, entries in
            let workouts = entries.map(\.1).sorted { $0.startDate < $1.startDate }
            return IntervalLibraryGroup(
                signature: signature,
                workouts: workouts,
                trendPoints: workouts.map(trendPoint(for:))
            )
        }
        .sorted { signatureSortKey($0.signature) < signatureSortKey($1.signature) }
    }

    public static func signature(for workout: OfficialIntervalWorkout) -> IntervalPrescriptionSignature? {
        let ordered = workout.rows.sorted { $0.index < $1.index }
        let workRows = ordered.filter { $0.stepType == .work && $0.planSource == .workoutKit }
        guard !workRows.isEmpty else { return nil }
        let recoveryRows = ordered.filter { $0.stepType == .recovery && $0.planSource == .workoutKit }
        let workGoals = condensedGoals(workRows.map(goalSignature))
        let recoveryGoals = condensedGoals(recoveryRows.map(goalSignature))
        let targets = workRows.compactMap {
            WorkTargetEvaluator.canonicalPaceRange(from: workout.plannedTargetsByRow[$0.index] ?? $0.plannedTargets)
        }
        let commonTarget = targets.count == workRows.count && Set(targets).count == 1 ? targets.first : nil
        return IntervalPrescriptionSignature(
            workGoals: workGoals,
            recoveryGoals: recoveryGoals,
            workCount: workRows.count,
            recoveryCount: recoveryRows.count,
            paceTarget: commonTarget
        )
    }

    public static func trendPoint(for workout: OfficialIntervalWorkout) -> IntervalTrendPoint {
        let workRows = workout.rows
            .filter { $0.stepType == .work && $0.planSource == .workoutKit }
            .sorted { $0.index < $1.index }
        let evaluations = workRows.compactMap { row in
            WorkTargetEvaluator.evaluate(interval: row, plannedTargets: workout.plannedTargetsByRow[row.index] ?? row.plannedTargets)
        }
        let totals = evaluations.reduce(into: (duration: 0.0, distance: 0.0)) { partial, evaluation in
            guard let duration = evaluation.measurement.durationSeconds,
                  let distance = evaluation.measurement.distanceMeters,
                  duration > 0,
                  distance > 0 else { return }
            partial.duration += duration
            partial.distance += distance
        }
        let paces = evaluations.compactMap(\.measurement.paceSecondsPerKilometer)

        return IntervalTrendPoint(
            workoutID: workout.workoutID,
            startDate: workout.startDate,
            workCount: workRows.count,
            aggregatePaceSecondsPerKilometer: totals.distance > 0
                ? totals.duration / (totals.distance / 1_000)
                : nil,
            onTargetCount: evaluations.count { $0.result == .onTarget },
            fastCount: evaluations.count { $0.result == .fast },
            slowCount: evaluations.count { $0.result == .slow },
            noTargetCount: evaluations.count { $0.result == .noTarget },
            shortenedCount: evaluations.count { $0.completionStatus == .shortened },
            fadePercent: fadePercent(paces),
            consistencyCoefficientOfVariationPercent: coefficientOfVariationPercent(paces),
            durationWeightedHeartRate: durationWeightedAverage(workRows, value: \.averageHeartRateBpm),
            durationWeightedPower: durationWeightedAverage(workRows, value: \.averagePower)
        )
    }

    private static func goalSignature(_ row: ReconstructedWorkoutInterval) -> IntervalGoalSignature {
        IntervalGoalSignature(type: row.plannedGoalType, value: row.plannedGoalValue)
    }

    private static func condensedGoals(_ goals: [IntervalGoalSignature]) -> [IntervalGoalSignature] {
        guard let first = goals.first else { return [] }
        return goals.allSatisfy { $0 == first } ? [first] : goals
    }

    private static func fadePercent(_ paces: [Double]) -> Double? {
        guard paces.count >= 2, let first = paces.first, let last = paces.last, first > 0 else { return nil }
        return ((last - first) / first) * 100
    }

    private static func coefficientOfVariationPercent(_ values: [Double]) -> Double? {
        guard values.count >= 2 else { return nil }
        let mean = values.reduce(0, +) / Double(values.count)
        guard mean > 0 else { return nil }
        let variance = values.reduce(0) { $0 + pow($1 - mean, 2) } / Double(values.count)
        return sqrt(variance) / mean * 100
    }

    private static func durationWeightedAverage(
        _ rows: [ReconstructedWorkoutInterval],
        value: KeyPath<ReconstructedWorkoutInterval, Double?>
    ) -> Double? {
        let totals = rows.reduce(into: (weighted: 0.0, duration: 0.0)) { partial, row in
            guard let value = row[keyPath: value], row.activeTimerDurationSeconds > 0 else { return }
            partial.weighted += value * row.activeTimerDurationSeconds
            partial.duration += row.activeTimerDurationSeconds
        }
        return totals.duration > 0 ? totals.weighted / totals.duration : nil
    }

    private static func signatureSortKey(_ signature: IntervalPrescriptionSignature) -> String {
        let work = signature.workGoals.map { "\($0.type.rawValue):\($0.value ?? -1)" }.joined(separator: ",")
        let recovery = signature.recoveryGoals.map { "\($0.type.rawValue):\($0.value ?? -1)" }.joined(separator: ",")
        return "\(work)|\(signature.workCount)|\(recovery)|\(signature.recoveryCount)"
    }
}
