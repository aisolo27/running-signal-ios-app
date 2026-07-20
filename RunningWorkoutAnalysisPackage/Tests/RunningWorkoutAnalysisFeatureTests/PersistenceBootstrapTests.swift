import Foundation
import SwiftData
import Testing
@testable import RunningWorkoutAnalysisFeature

@MainActor
@Suite("Persistence bootstrap recovery")
struct PersistenceBootstrapTests {
    @Test("A local cache read failure is explicit and retryable")
    func localCacheReadFailureCanRetryWithoutHealthKitMutation() async throws {
        enum SyntheticReadError: Error {
            case unavailable
        }

        let context = try persistenceBootstrapContext()
        let workout = persistenceBootstrapWorkout()
        var loadAttempts = 0
        let store = RunningAnalysisStore(
            persistedWorkoutLoader: { _ in
                loadAttempts += 1
                if loadAttempts == 1 {
                    throw SyntheticReadError.unavailable
                }
                return [workout]
            }
        )

        await store.bootstrap(modelContext: context)

        #expect(loadAttempts == 1)
        #expect(store.localDataLoadFailed)
        #expect(store.authorizationState == .error)
        #expect(store.workouts.isEmpty)
        #expect(store.healthKitConnectionPresentation.title == "Saved Run History Unavailable")
        #expect(store.healthKitConnectionPresentation.action == .retryLocalData)

        await store.performPrimaryHealthAction(.retryLocalData)

        #expect(loadAttempts == 2)
        #expect(store.localDataLoadFailed == false)
        #expect(store.authorizationState == .partial)
        #expect(store.workouts.map(\.id) == [workout.id])
    }

    @Test("A legitimate empty local store remains the normal first-run state")
    func emptyStoreDoesNotBecomePersistenceFailure() async throws {
        let context = try persistenceBootstrapContext()
        let store = RunningAnalysisStore(
            persistedWorkoutLoader: { _ in [] }
        )

        await store.bootstrap(modelContext: context)

        #expect(store.localDataLoadFailed == false)
        #expect(store.authorizationState == .notDetermined)
        #expect(store.healthKitConnectionPresentation.action == .connect)
    }
}

@MainActor
private func persistenceBootstrapContext() throws -> ModelContext {
    let schema = Schema(versionedSchema: RunSignalPersistenceSchemaV1.self)
    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    let container = try RunSignalPersistenceContainer.make(configurations: [configuration])
    return ModelContext(container)
}

private func persistenceBootstrapWorkout() -> CanonicalWorkout {
    let start = Date(timeIntervalSince1970: 1_800_000_000)
    return CanonicalWorkout(
        id: "persistence-bootstrap",
        sourceID: "persistence-bootstrap",
        sourceName: "Persistence bootstrap test",
        startDate: start,
        endDate: start.addingTimeInterval(1_800),
        environment: .outdoor,
        distanceMeters: 5_000,
        durationSeconds: 1_800
    )
}
