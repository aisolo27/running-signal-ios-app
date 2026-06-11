import Foundation

public struct RunWorkout: Identifiable, Equatable, Sendable {
    public var id: String { workout.id }
    public var workout: CanonicalWorkout

    public init(workout: CanonicalWorkout) {
        self.workout = workout
    }

    public var displayName: String {
        if workout.environment == .outdoor {
            return "Outdoor Run"
        }
        if workout.environment == .indoor {
            return "Indoor Run"
        }
        return "Running Workout"
    }
}

public struct RunWorkoutSeries: Equatable, Sendable {
    public var workoutID: String
    public var heartRate: WorkoutMetricSeries?
    public var paceOrSpeed: WorkoutMetricSeries?
    public var power: WorkoutMetricSeries?
    public var cadence: WorkoutMetricSeries?
    public var verticalOscillation: WorkoutMetricSeries?
    public var groundContactTime: WorkoutMetricSeries?
    public var strideLength: WorkoutMetricSeries?
    public var route: [WorkoutRoutePoint]

    public init(workout: CanonicalWorkout) {
        let evidence = workout.evidence
        workoutID = workout.id
        heartRate = evidence?.series[.heartRate]
        paceOrSpeed = evidence?.series[.runningSpeed] ?? evidence?.series[.distance]
        power = evidence?.series[.runningPower]
        cadence = evidence?.series[.cadence] ?? evidence?.series[.stepCount]
        verticalOscillation = evidence?.series[.verticalOscillation]
        groundContactTime = evidence?.series[.groundContactTime]
        strideLength = evidence?.series[.strideLength]
        route = evidence?.route ?? []
    }
}

public struct RunWorkoutSegments: Equatable, Sendable {
    public var workoutID: String
    public var kilometerSplits: [DerivedSplitEstimate]
    public var events: [WorkoutEvidenceEvent]

    public init(workout: CanonicalWorkout, analysis: DerivedWorkoutAnalysis?) {
        workoutID = workout.id
        let derivedSplits = analysis?.splitEstimates ?? []
        kilometerSplits = derivedSplits.isEmpty ? Self.fallbackKilometerSplits(workout: workout) : derivedSplits
        events = workout.evidence?.events ?? []
    }

    private static func fallbackKilometerSplits(workout: CanonicalWorkout) -> [DerivedSplitEstimate] {
        guard let distanceMeters = workout.distanceMeters,
              distanceMeters >= 1_000,
              let pace = workout.paceSecondsPerKm else {
            return []
        }

        let fullKilometers = min(Int(distanceMeters / 1_000), 10)
        var splits = (1...fullKilometers).map { index in
            DerivedSplitEstimate(
                label: "KM \(index)",
                distanceMeters: 1_000,
                durationSecondsEstimate: pace,
                paceSecondsPerKmEstimate: pace,
                confidence: .limited
            )
        }

        let remainder = distanceMeters.truncatingRemainder(dividingBy: 1_000)
        if remainder >= 250, splits.count < 12 {
            let duration = PaceMath.secondsForDistance(paceSecondsPerKm: pace, distanceMeters: remainder)
            splits.append(
                DerivedSplitEstimate(
                    label: "Final",
                    distanceMeters: remainder,
                    durationSecondsEstimate: duration,
                    paceSecondsPerKmEstimate: pace,
                    confidence: .limited
                )
            )
        }

        return splits
    }
}

public enum V1WorkoutFilters {
    public static func completedRuns(from workouts: [CanonicalWorkout]) -> [CanonicalWorkout] {
        workouts
            .filter { !$0.isDuplicate }
            .filter { $0.durationSeconds > 0 }
            .sorted { lhs, rhs in
                if lhs.startDate == rhs.startDate {
                    return preferredSourceScore(lhs) > preferredSourceScore(rhs)
                }
                return lhs.startDate > rhs.startDate
            }
    }

    public static func recentOutdoorAppleWatchRuns(from workouts: [CanonicalWorkout], limit: Int = 12) -> [CanonicalWorkout] {
        completedRuns(from: workouts)
            .filter { $0.environment == .outdoor }
            .sorted { lhs, rhs in
                let lhsScore = preferredSourceScore(lhs)
                let rhsScore = preferredSourceScore(rhs)
                if lhsScore != rhsScore {
                    return lhsScore > rhsScore
                }
                return lhs.startDate > rhs.startDate
            }
            .prefix(limit)
            .map { $0 }
    }

    private static func preferredSourceScore(_ workout: CanonicalWorkout) -> Int {
        let haystack = [workout.sourceName, workout.deviceName, workout.sourceID]
            .compactMap { $0?.lowercased() }
            .joined(separator: " ")
        var score = 0
        if haystack.contains("apple watch") { score += 5 }
        if haystack.contains("watch") { score += 3 }
        if haystack.contains("fitness") { score += 2 }
        if haystack.contains("health") { score += 1 }
        return score
    }
}
