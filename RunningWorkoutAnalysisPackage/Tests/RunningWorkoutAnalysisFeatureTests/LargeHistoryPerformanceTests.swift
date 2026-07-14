import Foundation
import Testing
@testable import RunningWorkoutAnalysisFeature

@Test(arguments: [1_000, 5_000])
func largeRunHistoryKeepsCoreListAndAnalyticsWorkBounded(count: Int) {
    let workouts = largeHistoryWorkouts(count: count)
    let clock = ContinuousClock()
    let startedAt = clock.now

    let marked = DuplicateDetector.markDuplicates(workouts)
    let completed = V1WorkoutFilters.completedRuns(from: marked)
    let snapshot = AnalyticsEngine.snapshot(for: marked, now: Date(timeIntervalSince1970: 1_800_000_000))
    let elapsed = clock.now - startedAt

    #expect(marked.count == count)
    #expect(completed.count == count)
    #expect(snapshot.dataQuality.includedWorkoutCount == count)
    #expect(elapsed < .seconds(3))
}

@MainActor
@Test func fiveThousandRunHistoryMergePreservesEveryWindowWithoutHistoryWideDelay() {
    let current = largeHistoryWorkouts(count: 4_800)
    let incoming = Array(largeHistoryWorkouts(count: 5_000).dropFirst(4_800))
    let clock = ContinuousClock()
    let startedAt = clock.now

    let merged = RunningAnalysisStore.mergeImportedWorkouts(incoming: incoming, current: current)
    let elapsed = clock.now - startedAt

    #expect(merged.count == 5_000)
    #expect(Set(merged.map(\.id)).count == 5_000)
    #expect(elapsed < .seconds(3))
}

private func largeHistoryWorkouts(count: Int) -> [CanonicalWorkout] {
    let reference = Date(timeIntervalSince1970: 1_800_000_000)
    return (0..<count).map { index in
        let start = reference.addingTimeInterval(-Double(index) * 12 * 60 * 60)
        let duration = 1_500.0 + Double(index % 900)
        return CanonicalWorkout(
            id: "large-history-\(index)",
            sourceID: "large-history-\(index)",
            sourceName: "HealthKit",
            deviceName: "Apple Watch",
            startDate: start,
            endDate: start.addingTimeInterval(duration),
            environment: .outdoor,
            distanceMeters: 5_000 + Double(index % 8_000),
            durationSeconds: duration,
            averageHeartRate: 140 + Double(index % 25),
            inferredRunType: index.isMultiple(of: 7) ? .longRun : .easy
        )
    }
}
