import Foundation
import SwiftData
import Testing
@testable import RunningWorkoutAnalysisFeature

@MainActor
@Suite("Persistence hardening")
struct PersistenceHardeningTests {
    @Test("A legitimate empty store is distinguishable from a read failure")
    func emptyStoreLoadsSuccessfully() throws {
        let context = try makeInMemoryContext()

        let workouts = try PersistenceService.fetchWorkoutsForBootstrap(context: context)

        #expect(workouts.isEmpty)
    }

    @Test("The startup workout fetch preserves a typed read failure")
    func startupFetchPreservesReadFailure() {
        enum SyntheticFetchError: Error {
            case unavailable
        }

        #expect(throws: PersistenceReadError.self) {
            _ = try PersistenceService.fetchWorkoutsForBootstrap { _ in
                throw SyntheticFetchError.unavailable
            }
        }

        do {
            _ = try PersistenceService.fetchWorkoutsForBootstrap { _ in
                throw SyntheticFetchError.unavailable
            }
            Issue.record("Expected the startup fetch to fail")
        } catch let error as PersistenceReadError {
            #expect(error == .workoutFetchFailed(details: "unavailable"))
            #expect(error.localizedDescription.contains("saved workout cache could not be read"))
            #expect(error.localizedDescription.contains("unavailable") == false)
            #expect(error.diagnosticDetails == "unavailable")
        } catch {
            Issue.record("Expected PersistenceReadError, received \(error)")
        }
    }

    @Test("The V1 schema contains every current persisted model exactly once")
    func schemaContainsCurrentModels() {
        let schema = Schema(versionedSchema: RunSignalPersistenceSchemaV1.self)
        let modelNames = Set(schema.entities.map(\.name))

        #expect(RunSignalPersistenceSchemaV1.versionIdentifier == Schema.Version(1, 0, 0))
        #expect(schema.entities.count == 8)
        #expect(modelNames == Set([
            "PersistedWorkout",
            "PersistedWorkoutEvidence",
            "PersistedEvidenceEnrichmentState",
            "PersistedEvidenceRefreshJob",
            "PersistedEvidenceRefreshJobItem",
            "PersistedHealthKitImportJob",
            "PersistedDerivedWorkoutAnalysis",
            "PersistedTrainingPeriodSummary"
        ]))
    }

    @Test("The versioned in-memory container round-trips workouts")
    func versionedContainerRoundTripsWorkout() throws {
        let context = try makeInMemoryContext()
        let workout = makeWorkout(id: "versioned-round-trip", start: 20_000)

        try PersistenceService.upsertAndSave([workout], context: context)

        let loaded = try PersistenceService.fetchWorkoutsForBootstrap(context: context)
        #expect(loaded.map(\.id) == [workout.id])
    }

    @Test("An existing unversioned V1 store opens through the migration plan without data loss")
    func unversionedStoreOpensWithVersionedPlan() throws {
        let directory = FileManager.default.temporaryDirectory
            .appending(path: "RunSignalPersistenceHardening-\(UUID().uuidString)", directoryHint: .isDirectory)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let storeURL = directory.appending(path: "RunSignal.store")
        let legacySchema = Schema(RunSignalPersistenceSchemaV1.models)
        let workout = makeWorkout(id: "legacy-store-workout", start: 30_000)

        try writeLegacyStore(schema: legacySchema, storeURL: storeURL, workout: workout)

        let versionedSchema = Schema(versionedSchema: RunSignalPersistenceSchemaV1.self)
        let configuration = ModelConfiguration(schema: versionedSchema, url: storeURL)
        let container = try RunSignalPersistenceContainer.make(configurations: [configuration])
        let loaded = try PersistenceService.fetchWorkoutsForBootstrap(context: ModelContext(container))

        #expect(loaded.map(\.id) == [workout.id])
    }

    @Test("Identifier-only evidence fetch returns every stored ID")
    func identifierOnlyEvidenceFetchReturnsIDs() throws {
        let context = try makeInMemoryContext()
        let first = makeWorkout(id: "evidence-one", start: 40_000)
        let second = makeWorkout(id: "evidence-two", start: 50_000)

        PersistenceService.upsert([first, second], context: context)

        #expect(PersistenceService.fetchEvidenceIDs(context: context) == Set([first.id, second.id]))
    }
}

@MainActor
private func makeInMemoryContext() throws -> ModelContext {
    let schema = Schema(versionedSchema: RunSignalPersistenceSchemaV1.self)
    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    let container = try RunSignalPersistenceContainer.make(configurations: [configuration])
    return ModelContext(container)
}

@MainActor
private func writeLegacyStore(
    schema: Schema,
    storeURL: URL,
    workout: CanonicalWorkout
) throws {
    let configuration = ModelConfiguration(schema: schema, url: storeURL)
    let container = try ModelContainer(for: schema, configurations: [configuration])
    let context = ModelContext(container)
    try PersistenceService.upsertAndSave([workout], context: context)
}

private func makeWorkout(id: String, start: TimeInterval) -> CanonicalWorkout {
    let startDate = Date(timeIntervalSince1970: start)
    return CanonicalWorkout(
        id: id,
        sourceID: id,
        sourceName: "Persistence hardening tests",
        startDate: startDate,
        endDate: startDate.addingTimeInterval(1_800),
        environment: .outdoor,
        distanceMeters: 5_000,
        durationSeconds: 1_800,
        evidence: WorkoutEvidence(workoutID: id, loadedAt: startDate)
    )
}
