import Foundation

public enum PaceMath {
    public static func paceSecondsPerKm(distanceMeters: Double?, durationSeconds: Double?) -> Double? {
        guard let distanceMeters, let durationSeconds, distanceMeters > 0, durationSeconds > 0 else {
            return nil
        }
        return durationSeconds / (distanceMeters / 1_000)
    }

    public static func weightedPaceSecondsPerKm(_ workouts: [CanonicalWorkout]) -> Double? {
        let totals = workouts.reduce(into: (distance: 0.0, duration: 0.0)) { partial, workout in
            guard !workout.isDuplicate, let distance = workout.distanceMeters, distance > 0 else { return }
            partial.distance += distance
            partial.duration += workout.durationSeconds
        }
        return paceSecondsPerKm(distanceMeters: totals.distance, durationSeconds: totals.duration)
    }

    public static func secondsForDistance(paceSecondsPerKm: Double, distanceMeters: Double) -> Double {
        paceSecondsPerKm * (distanceMeters / 1_000)
    }
}
