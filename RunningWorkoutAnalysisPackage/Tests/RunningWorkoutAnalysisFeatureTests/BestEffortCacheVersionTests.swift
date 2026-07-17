import Foundation
import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func threeKilometerUpgradeIgnoresCompletedLegacyHistoryCheckpoint() throws {
    let suiteName = "RunSignalTests.\(UUID().uuidString)"
    let defaults = try #require(UserDefaults(suiteName: suiteName))
    defer { defaults.removePersistentDomain(forName: suiteName) }
    let legacy = BestEffortHistoryCheckpoint(
        checkedWorkoutIDs: ["previously-checked"],
        failedWorkoutIDs: ["previously-failed"]
    )
    defaults.set(
        try JSONEncoder().encode(legacy),
        forKey: "RunSignal.BestEffortHistoryCheckpoint.v1"
    )

    let loaded = BestEffortHistoryCheckpointStore.load(defaults: defaults)

    #expect(loaded == BestEffortHistoryCheckpoint())
}

@Test func currentBestEffortHistoryCheckpointStillPersists() throws {
    let suiteName = "RunSignalTests.\(UUID().uuidString)"
    let defaults = try #require(UserDefaults(suiteName: suiteName))
    defer { defaults.removePersistentDomain(forName: suiteName) }
    let checkpoint = BestEffortHistoryCheckpoint(
        checkedWorkoutIDs: ["checked"],
        failedWorkoutIDs: ["failed"]
    )

    BestEffortHistoryCheckpointStore.save(checkpoint, defaults: defaults)

    #expect(BestEffortHistoryCheckpointStore.load(defaults: defaults) == checkpoint)
}
