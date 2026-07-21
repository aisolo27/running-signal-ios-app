import Foundation
import Observation
import SwiftData
import Testing
@testable import RunningWorkoutAnalysisFeature

@MainActor
@Test(.timeLimit(.minutes(1)))
func automaticEvidenceQueueBatchesCrossHistoryPublicationsUntilQueueCompletion() async throws {
    let context = try batchingTestModelContext()
    let suiteName = "AutomaticEvidenceBatchingTests.\(UUID().uuidString)"
    let defaults = try #require(UserDefaults(suiteName: suiteName))
    defer {
        defaults.removePersistentDomain(forName: suiteName)
    }

    let now = Date()
    let newest = batchingTestWorkout(
        id: "automatic-batch-newest",
        start: now.addingTimeInterval(-60),
        distanceMeters: 6_000,
        durationSeconds: 1_800
    )
    let next = batchingTestWorkout(
        id: "automatic-batch-next",
        start: now.addingTimeInterval(-3_600),
        distanceMeters: 5_000,
        durationSeconds: 1_500
    )
    PersistenceService.upsert([newest, next], context: context)

    let service = BatchingHealthKitService(
        detailedWorkoutsByID: [
            newest.id: detailedBatchingWorkout(from: newest),
            next.id: detailedBatchingWorkout(from: next)
        ]
    )
    let store = RunningAnalysisStore(
        healthKitService: service,
        syncDefaults: defaults
    )
    await store.bootstrap(modelContext: context)

    #expect(store.snapshot.dataQuality.seriesCoverage == 0)
    #expect(store.evidenceQueueSummary.pendingCount == 2)
    #expect(store.personalBestEffortSummary.allTime.contains(where: { $0.bucket == .fourHundredMeters }) == false)
    #expect(store.automaticEvidenceAggregatePublicationCount == 0)

    store.startAutomaticEvidenceEnrichment(now: now)
    await service.waitUntilSecondEnrichmentStarts()

    let firstWorkout = try #require(store.workouts.first { $0.id == newest.id })
    #expect(firstWorkout.inferredRunType == .interval)
    #expect(store.analysisProgressByWorkoutID[newest.id]?.stage == .ready)
    #expect(store.derivedAnalysesByWorkoutID[newest.id] != nil)

    let weekStart = WeeklyAnalyticsSummary.weekStart(containing: newest.startDate)
    let currentWeek = store.trainingPeriodSummary(period: .week, periodStart: weekStart)
    #expect(currentWeek.categoryTotals.first { $0.category == .interval }?.runCount == 1)

    #expect(store.snapshot.dataQuality.seriesCoverage == 0)
    #expect(store.evidenceQueueSummary.pendingCount == 2)
    #expect(store.personalBestEffortSummary.allTime.contains(where: { $0.bucket == .fourHundredMeters }) == false)
    #expect(store.automaticEvidenceAggregatePublicationCount == 0)

    await service.releaseSecondEnrichment()
    await waitUntilBatchingObservation {
        store.automaticEvidenceAggregatePublicationCount == 1
    }

    #expect(store.derivedAnalysesByWorkoutID.count == 2)
    #expect(store.snapshot.dataQuality.seriesCoverage == 1)
    #expect(store.evidenceQueueSummary.pendingCount == 0)
    #expect(store.personalBestEffortSummary.allTime.contains { $0.bucket == .fourHundredMeters })
    #expect(store.automaticEvidenceAggregatePublicationCount == 1)
}

@MainActor
private func waitUntilBatchingObservation(
    _ condition: @escaping @MainActor @Sendable () -> Bool
) async {
    guard condition() == false else { return }

    await withCheckedContinuation { continuation in
        withObservationTracking {
            _ = condition()
        } onChange: {
            Task { @MainActor in
                await waitUntilBatchingObservation(condition)
                continuation.resume()
            }
        }
    }
}

private actor BatchingHealthKitServiceState {
    let detailedWorkoutsByID: [String: CanonicalWorkout]
    var enrichmentCallCount = 0
    var secondCallWaiters: [CheckedContinuation<Void, Never>] = []
    var secondCallRelease: CheckedContinuation<Void, Never>?
    var secondCallIsReleased = false

    init(detailedWorkoutsByID: [String: CanonicalWorkout]) {
        self.detailedWorkoutsByID = detailedWorkoutsByID
    }

    func enrich(ids: [String]) async -> HealthKitLoadResult {
        enrichmentCallCount += 1
        if enrichmentCallCount == 2 {
            for waiter in secondCallWaiters {
                waiter.resume()
            }
            secondCallWaiters.removeAll()
            if !secondCallIsReleased {
                await withCheckedContinuation { continuation in
                    secondCallRelease = continuation
                }
            }
        }
        return HealthKitLoadResult(
            authorizationState: .authorized,
            workouts: ids.compactMap { detailedWorkoutsByID[$0] },
            healthContext: HealthContext(),
            message: nil
        )
    }

    func waitUntilSecondEnrichmentStarts() async {
        guard enrichmentCallCount < 2 else { return }
        await withCheckedContinuation { continuation in
            secondCallWaiters.append(continuation)
        }
    }

    func releaseSecondEnrichment() {
        secondCallIsReleased = true
        secondCallRelease?.resume()
        secondCallRelease = nil
    }
}

private final class BatchingHealthKitService: HealthKitServicing, @unchecked Sendable {
    private let state: BatchingHealthKitServiceState

    init(detailedWorkoutsByID: [String: CanonicalWorkout]) {
        state = BatchingHealthKitServiceState(detailedWorkoutsByID: detailedWorkoutsByID)
    }

    var isAvailable: Bool { true }

    func requestAuthorization() async -> AuthorizationState {
        .authorized
    }

    func loadRunningWorkouts() async -> HealthKitLoadResult {
        HealthKitLoadResult(
            authorizationState: .authorized,
            workouts: [],
            healthContext: HealthContext(),
            message: nil
        )
    }

    func loadRunningWorkouts(
        startDate: Date?,
        endDate: Date?,
        detailedEvidenceLimit: Int,
        probeRoutesWhenEvidenceMissing: Bool
    ) async -> HealthKitLoadResult {
        await loadRunningWorkouts()
    }

    func enrichRunningWorkouts(ids: [String]) async -> HealthKitLoadResult {
        await state.enrich(ids: ids)
    }

    func loadBestEffortEvidence(ids: [String]) async -> HealthKitLoadResult {
        await loadRunningWorkouts()
    }

    func loadHealthContext() async -> HealthContext {
        HealthContext()
    }

    func waitUntilSecondEnrichmentStarts() async {
        await state.waitUntilSecondEnrichmentStarts()
    }

    func releaseSecondEnrichment() async {
        await state.releaseSecondEnrichment()
    }
}

@MainActor
private func batchingTestModelContext() throws -> ModelContext {
    let schema = Schema(versionedSchema: RunSignalPersistenceSchemaV2.self)
    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    let container = try ModelContainer(for: schema, configurations: [configuration])
    return ModelContext(container)
}

private func batchingTestWorkout(
    id: String,
    start: Date,
    distanceMeters: Double,
    durationSeconds: TimeInterval
) -> CanonicalWorkout {
    CanonicalWorkout(
        id: id,
        sourceID: id,
        sourceName: "HealthKit",
        startDate: start,
        endDate: start.addingTimeInterval(durationSeconds),
        environment: .outdoor,
        distanceMeters: distanceMeters,
        durationSeconds: durationSeconds,
        inferredRunType: .easy
    )
}

private func detailedBatchingWorkout(from summary: CanonicalWorkout) -> CanonicalWorkout {
    var workout = summary
    let sampleCount = 180
    let sampleDuration = summary.durationSeconds / Double(sampleCount)
    let sampleDistance = (summary.distanceMeters ?? 0) / Double(sampleCount)
    let points = (1...sampleCount).map { index in
        let sampleStart = summary.startDate.addingTimeInterval(Double(index - 1) * sampleDuration)
        let sampleEnd = summary.startDate.addingTimeInterval(Double(index) * sampleDuration)
        return WorkoutEvidencePoint(
            date: sampleEnd,
            value: sampleDistance,
            startDate: sampleStart,
            endDate: sampleEnd
        )
    }
    workout.evidence = WorkoutEvidence(
        workoutID: summary.id,
        loadedAt: summary.endDate,
        series: [
            .distance: WorkoutMetricSeries(metric: .distance, unit: "m", points: points)
        ],
        workoutPlanAudit: WorkoutPlanAudit(
            status: .available,
            planType: "Custom workout",
            displayName: "Interval Session",
            plannedSteps: []
        )
    )
    workout.seriesAvailable = true
    workout.seriesSampleCount = points.count
    workout.distanceSampleCount = points.count
    return workout
}
