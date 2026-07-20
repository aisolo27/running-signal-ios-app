import Foundation
import HealthKit
import Testing
@testable import RunningWorkoutAnalysisFeature

@MainActor
@Test func historicalImportUnionKeepsEarlierWindowsAndManualFields() {
    var cached = ingestionWorkout(id: "newer", start: 2_000)
    cached.manualRunType = .threshold
    cached.notes = "Keep this"

    var refreshed = ingestionWorkout(id: "newer", start: 2_000)
    refreshed.distanceMeters = 5_100
    let older = ingestionWorkout(id: "older", start: 1_000)

    let afterNewestWindow = RunningAnalysisStore.mergeImportedWorkouts(
        incoming: [refreshed],
        current: [cached]
    )
    let afterOlderWindow = RunningAnalysisStore.mergeImportedWorkouts(
        incoming: [older],
        current: afterNewestWindow
    )

    #expect(afterOlderWindow.map(\.id) == ["newer", "older"])
    #expect(afterOlderWindow.first?.distanceMeters == 5_100)
    #expect(afterOlderWindow.first?.manualRunType == .threshold)
    #expect(afterOlderWindow.first?.notes == "Keep this")
}

@Test func detailedEvidenceBudgetStopsForLowPowerAndSeriousThermalState() {
    let lowPower = IngestionBudgetPolicy(
        maxElapsedSeconds: 30,
        isCancelled: { false },
        isLowPowerModeEnabled: { true },
        thermalState: { .nominal }
    )
    let seriousThermal = IngestionBudgetPolicy(
        maxElapsedSeconds: 30,
        isCancelled: { false },
        isLowPowerModeEnabled: { false },
        thermalState: { .serious }
    )

    #expect(lowPower.pauseReason(allowsDetailedEvidence: true) == .lowPowerMode)
    #expect(lowPower.pauseReason(allowsDetailedEvidence: false) == nil)
    #expect(seriousThermal.pauseReason(allowsDetailedEvidence: true) == .thermalSerious)
    #expect(seriousThermal.pauseReason(allowsDetailedEvidence: false) == nil)
}

@MainActor
@Test(.timeLimit(.minutes(1)))
func foregroundAndObserverStyleSyncCallsShareOneInFlightSync() async {
    let sync = CoalescingSyncStub()
    let store = RunningAnalysisStore(
        healthKitService: IngestionHealthKitStub(),
        syncService: sync
    )

    async let foreground: Void = store.syncHealthKitChanges(includePostSyncMaintenance: true)
    async let observer: Void = store.syncHealthKitChanges(includePostSyncMaintenance: false)
    await sync.waitUntilSyncStarts()
    await sync.releaseSync()
    _ = await (foreground, observer)

    #expect(sync.callCount == 1)
}

private func ingestionWorkout(id: String, start: TimeInterval) -> CanonicalWorkout {
    let startDate = Date(timeIntervalSince1970: start)
    return CanonicalWorkout(
        id: id,
        sourceID: "healthkit",
        sourceName: "HealthKit",
        startDate: startDate,
        endDate: startDate.addingTimeInterval(1_500),
        environment: .outdoor,
        distanceMeters: 5_000,
        durationSeconds: 1_500
    )
}

private final class IngestionHealthKitStub: HealthKitServicing, @unchecked Sendable {
    var isAvailable: Bool { true }
    func requestAuthorization() async -> AuthorizationState { .partial }
    func loadRunningWorkouts() async -> HealthKitLoadResult { emptyResult }
    func loadRunningWorkouts(
        startDate: Date?,
        endDate: Date?,
        detailedEvidenceLimit: Int,
        probeRoutesWhenEvidenceMissing: Bool
    ) async -> HealthKitLoadResult { emptyResult }
    func enrichRunningWorkouts(ids: [String]) async -> HealthKitLoadResult { emptyResult }
    func loadHealthContext() async -> HealthContext { HealthContext() }

    private var emptyResult: HealthKitLoadResult {
        HealthKitLoadResult(
            authorizationState: .partial,
            workouts: [],
            healthContext: HealthContext(),
            message: "No changes."
        )
    }
}

private final class CoalescingSyncStub: HealthKitWorkoutSyncServicing, @unchecked Sendable {
    private let lock = NSLock()
    private let gate = CoalescingSyncGate()
    private var calls = 0

    var callCount: Int { lock.withLock { calls } }

    func syncRunningWorkouts(from anchor: HKQueryAnchor?) async -> HealthKitWorkoutSyncResult {
        (await syncRunningWorkoutBatches(from: anchor)).first!
    }

    func syncRunningWorkoutBatches(from anchor: HKQueryAnchor?) async -> [HealthKitWorkoutSyncResult] {
        lock.withLock { calls += 1 }
        await gate.enterAndWait()
        return [HealthKitWorkoutSyncResult(authorizationState: .partial, message: "No changes.")]
    }

    func waitUntilSyncStarts() async {
        await gate.waitUntilEntered()
    }

    func releaseSync() async {
        await gate.release()
    }
}

private actor CoalescingSyncGate {
    private var didEnter = false
    private var isReleased = false
    private var entryWaiters: [CheckedContinuation<Void, Never>] = []
    private var releaseWaiters: [CheckedContinuation<Void, Never>] = []

    func enterAndWait() async {
        didEnter = true
        for waiter in entryWaiters {
            waiter.resume()
        }
        entryWaiters.removeAll()

        guard isReleased == false else { return }
        await withCheckedContinuation { continuation in
            releaseWaiters.append(continuation)
        }
    }

    func waitUntilEntered() async {
        guard didEnter == false else { return }
        await withCheckedContinuation { continuation in
            entryWaiters.append(continuation)
        }
    }

    func release() {
        isReleased = true
        for waiter in releaseWaiters {
            waiter.resume()
        }
        releaseWaiters.removeAll()
    }
}
