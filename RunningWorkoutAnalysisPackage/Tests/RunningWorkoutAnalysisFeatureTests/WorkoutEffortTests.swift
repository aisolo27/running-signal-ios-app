import Foundation
import SwiftData
import Testing
@testable import RunningWorkoutAnalysisFeature

@Suite("Workout effort")
struct WorkoutEffortTests {
    @Test("Only finite Apple effort scores from 1 through 10 are accepted")
    func validatesScoreRange() {
        #expect(WorkoutEffortScore.normalized(nil) == nil)
        #expect(WorkoutEffortScore.normalized(.nan) == nil)
        #expect(WorkoutEffortScore.normalized(.infinity) == nil)
        #expect(WorkoutEffortScore.normalized(0.9) == nil)
        #expect(WorkoutEffortScore.normalized(10.1) == nil)
        #expect(WorkoutEffortScore.normalized(1) == 1)
        #expect(WorkoutEffortScore.normalized(7) == 7)
        #expect(WorkoutEffortScore.normalized(10) == 10)
    }

    @Test("A supplied score has factual optional UI copy")
    func presentationIsOptionalAndFactual() throws {
        #expect(WorkoutEffortPresentation.make(score: nil) == nil)
        let presentation = try #require(WorkoutEffortPresentation.make(score: 7))
        #expect(presentation.value == "7/10")
        #expect(presentation.detail == "Apple Health rating")
        #expect(presentation.accessibilityValue.contains("7 out of 10"))
    }

    @Test("Permission catalog requests the user effort score but not Apple's estimate")
    func permissionCatalogUsesUserRatingOnly() {
        let identifiers = Set(HealthKitPermissionCatalog.readItems.map(\.healthKitIdentifier))
        #expect(identifiers.contains("HKQuantityTypeIdentifierWorkoutEffortScore"))
        #expect(!identifiers.contains("HKQuantityTypeIdentifierEstimatedWorkoutEffortScore"))
    }

    @MainActor
    @Test("V2 persists, preserves, and removes an effort score only after a completed query")
    func persistenceReconcilesAuthoritativeQueries() throws {
        let context = try makeEffortContext()
        var workout = makeEffortWorkout(score: 7, wasQueried: true)

        try PersistenceService.upsertAndSave([workout], context: context)
        var loaded = try #require(PersistenceService.fetchWorkoutsForBootstrap(context: context).first)
        #expect(loaded.workoutEffortScore == 7)
        #expect(loaded.workoutEffortWasQueried == false)

        loaded.workoutEffortScore = nil
        loaded.workoutEffortWasQueried = false
        try PersistenceService.upsertAndSave([loaded], context: context)
        #expect(try #require(PersistenceService.fetchWorkoutsForBootstrap(context: context).first).workoutEffortScore == 7)

        workout.workoutEffortScore = nil
        workout.workoutEffortWasQueried = true
        try PersistenceService.upsertAndSave([workout], context: context)
        #expect(try #require(PersistenceService.fetchWorkoutsForBootstrap(context: context).first).workoutEffortScore == nil)
    }

    @MainActor
    @Test("A non-authoritative refresh preserves the currently loaded effort score")
    func mergePreservesEffortWhenQueryDidNotComplete() throws {
        let existing = makeEffortWorkout(score: 7, wasQueried: false)
        let incoming = makeEffortWorkout(score: nil, wasQueried: false)

        let merged = try #require(
            RunningAnalysisStore.mergeImportedWorkouts(incoming: [incoming], current: [existing]).first
        )

        #expect(merged.workoutEffortScore == 7)
        #expect(merged.workoutEffortWasQueried == false)
    }
}

@MainActor
private func makeEffortContext() throws -> ModelContext {
    let schema = Schema(versionedSchema: RunSignalPersistenceSchemaV2.self)
    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    let container = try RunSignalPersistenceContainer.make(configurations: [configuration])
    return ModelContext(container)
}

private func makeEffortWorkout(score: Double?, wasQueried: Bool) -> CanonicalWorkout {
    let start = Date(timeIntervalSince1970: 1_800_000_000)
    return CanonicalWorkout(
        id: "effort-workout",
        sourceID: "effort-workout",
        sourceName: "Apple Watch",
        startDate: start,
        endDate: start.addingTimeInterval(1_800),
        environment: .outdoor,
        distanceMeters: 5_000,
        durationSeconds: 1_800,
        workoutEffortScore: score,
        workoutEffortWasQueried: wasQueried
    )
}
