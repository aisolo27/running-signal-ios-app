import Foundation

public enum RunClassifier {
    public static func inferRunType(for workout: CanonicalWorkout) -> RunType {
        guard let distanceKm = workout.distanceKilometers else { return .unknown }
        let pace = workout.paceSecondsPerKm

        if distanceKm >= 12 {
            return .longRun
        }
        if let pace, pace <= RunningGoal.sub20FiveK.targetPaceSecondsPerKm + 25, distanceKm >= 3 {
            return .threshold
        }
        if distanceKm < 2.5, workout.durationSeconds < 20 * 60 {
            return .recovery
        }
        if workout.averageHeartRate != nil, distanceKm >= 4 {
            return .easy
        }
        return .unknown
    }
}

public enum DuplicateDetector {
    public static func markDuplicates(_ workouts: [CanonicalWorkout]) -> [CanonicalWorkout] {
        let sorted = workouts.sorted { $0.startDate < $1.startDate }
        var result: [CanonicalWorkout] = []

        for var candidate in sorted {
            if let original = result.first(where: { isLikelyDuplicate($0, candidate) }) {
                candidate.isDuplicate = true
                candidate.duplicateOfID = original.id
            }
            result.append(candidate)
        }

        return result.sorted { $0.startDate > $1.startDate }
    }

    public static func isLikelyDuplicate(_ first: CanonicalWorkout, _ second: CanonicalWorkout) -> Bool {
        let startDelta = abs(first.startDate.timeIntervalSince(second.startDate))
        guard startDelta <= 90 else { return false }

        let durationDelta = abs(first.durationSeconds - second.durationSeconds)
        let durationClose = durationDelta <= max(60, min(first.durationSeconds, second.durationSeconds) * 0.05)

        let distanceClose: Bool
        if let firstDistance = first.distanceMeters, let secondDistance = second.distanceMeters {
            distanceClose = abs(firstDistance - secondDistance) <= max(80, min(firstDistance, secondDistance) * 0.03)
        } else {
            distanceClose = true
        }

        return durationClose && distanceClose
    }
}
