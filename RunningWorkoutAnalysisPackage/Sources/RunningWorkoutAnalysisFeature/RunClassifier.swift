import Foundation

public enum RunClassifier {
    public static func inferRunType(for workout: CanonicalWorkout) -> RunType {
        inferRunType(
            for: workout,
            officialIntervalRows: officialIntervalRows(for: workout)
        )
    }

    public static func inferRunType(
        for workout: CanonicalWorkout,
        officialIntervalRows: [ReconstructedWorkoutInterval]
    ) -> RunType {
        if isStructuredIntervalWorkout(officialIntervalRows) {
            return .interval
        }
        return .unknown
    }

    public static func isStructuredIntervalWorkout(_ rows: [ReconstructedWorkoutInterval]) -> Bool {
        let officialRows = rows.filter { $0.planSource == .workoutKit }
        let workCount = officialRows.filter { $0.stepType == .work }.count
        let hasRecovery = officialRows.contains { $0.stepType == .recovery }
        return workCount >= 2 || (workCount == 1 && hasRecovery)
    }

    private static func officialIntervalRows(for workout: CanonicalWorkout) -> [ReconstructedWorkoutInterval] {
        guard let evidence = workout.evidence,
              let result = CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence)
        else {
            return []
        }
        return result.intervals
    }
}

public enum DuplicateDetector {
    public static func markDuplicates(_ workouts: [CanonicalWorkout]) -> [CanonicalWorkout] {
        let sorted = workouts.sorted { $0.startDate < $1.startDate }
        var groups: [[CanonicalWorkout]] = []

        for candidate in sorted {
            if let index = groups.firstIndex(where: { group in
                group.contains { isLikelyDuplicate($0, candidate) }
            }) {
                groups[index].append(candidate)
            } else {
                groups.append([candidate])
            }
        }

        return groups
            .flatMap(markDuplicateGroup)
            .sorted { $0.startDate > $1.startDate }
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

    private static func markDuplicateGroup(_ group: [CanonicalWorkout]) -> [CanonicalWorkout] {
        guard group.count > 1 else {
            return group.map { workout in
                var included = workout
                included.isDuplicate = false
                included.duplicateOfID = nil
                return included
            }
        }

        let preferred = group.max { lhs, rhs in
            preferredScore(lhs) < preferredScore(rhs)
        }
        let preferredID = preferred?.id

        return group.map { workout in
            var marked = workout
            marked.isDuplicate = workout.id != preferredID
            marked.duplicateOfID = marked.isDuplicate ? preferredID : nil
            return marked
        }
    }

    private static func preferredScore(_ workout: CanonicalWorkout) -> Int {
        let sourceText = "\(workout.sourceName) \(workout.deviceName ?? "")".lowercased()
        let appleWatchScore = sourceText.contains("apple watch") || sourceText.contains("apple fitness") ? 10_000 : 0
        let evidenceScore = workout.seriesSampleCount
            + workout.routePointCount
            + workout.heartRateSampleCount
            + workout.runningSpeedSampleCount
            + workout.distanceSampleCount
            + workout.runningPowerSampleCount
            + workout.cadenceSampleCount
            + workout.stepCountSampleCount
        let summaryScore = (workout.distanceMeters == nil ? 0 : 100)
            + (workout.activeEnergyKilocalories == nil ? 0 : 25)
            + (workout.averageHeartRate == nil ? 0 : 25)
        return appleWatchScore + evidenceScore + summaryScore
    }
}
