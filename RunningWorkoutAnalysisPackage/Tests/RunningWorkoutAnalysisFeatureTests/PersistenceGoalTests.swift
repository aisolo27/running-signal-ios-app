import Foundation
import SwiftData
import Testing
@testable import RunningWorkoutAnalysisFeature

@MainActor
@Test func targetedSummaryUpsertPreservesUnrelatedEvidenceAnalysisAndManualFields() throws {
    let context = try persistenceGoalContext()
    var changed = persistenceGoalWorkout(id: "changed", duration: 1_500, heartRate: 145)
    let untouched = persistenceGoalWorkout(id: "untouched", duration: 1_800, heartRate: 155)
    PersistenceService.upsert([changed, untouched], context: context)
    PersistenceService.updateManualFields(
        id: untouched.id,
        runType: .longRun,
        notes: "Keep me",
        context: context
    )

    let untouchedEvidenceBefore = try #require(
        PersistenceService.fetchEvidence(workoutID: untouched.id, context: context)
    )
    let untouchedAnalysisBefore = try #require(
        PersistenceService.fetchDerivedAnalysis(workoutID: untouched.id, context: context)
    )

    changed.evidence = nil
    changed.durationSeconds = 1_600
    changed.endDate = changed.startDate.addingTimeInterval(1_600)
    PersistenceService.upsert([changed], context: context)

    let workouts = PersistenceService.fetchWorkouts(context: context)
    let persistedUntouched = try #require(workouts.first { $0.id == untouched.id })
    #expect(PersistenceService.fetchEvidence(workoutID: untouched.id, context: context) == untouchedEvidenceBefore)
    #expect(PersistenceService.fetchDerivedAnalysis(workoutID: untouched.id, context: context) == untouchedAnalysisBefore)
    #expect(persistedUntouched.manualRunType == .longRun)
    #expect(persistedUntouched.notes == "Keep me")
}

@MainActor
@Test func targetedEvidenceDeleteAndDerivedRefreshLeaveOtherWorkoutIntact() throws {
    let context = try persistenceGoalContext()
    let deleted = persistenceGoalWorkout(id: "delete-evidence", duration: 1_500, heartRate: 142)
    let kept = persistenceGoalWorkout(id: "keep-evidence", duration: 1_700, heartRate: 152)
    PersistenceService.upsert([deleted, kept], context: context)

    let keptEvidence = try #require(PersistenceService.fetchEvidence(workoutID: kept.id, context: context))
    let keptAnalysis = try #require(PersistenceService.fetchDerivedAnalysis(workoutID: kept.id, context: context))
    PersistenceService.deleteEvidence(ids: [deleted.id], context: context)

    #expect(PersistenceService.fetchEvidence(workoutID: deleted.id, context: context) == nil)
    #expect(PersistenceService.fetchDerivedAnalysis(workoutID: deleted.id, context: context) == nil)
    #expect(PersistenceService.fetchEvidence(workoutID: kept.id, context: context) == keptEvidence)
    #expect(PersistenceService.fetchDerivedAnalysis(workoutID: kept.id, context: context) == keptAnalysis)
    #expect(PersistenceService.fetchEvidenceIDs(workoutIDs: [deleted.id, kept.id], context: context) == Set([kept.id]))
    #expect(PersistenceService.refreshDerivedAnalyses(workoutIDs: [deleted.id, kept.id], context: context) == 1)
}

private func persistenceGoalWorkout(
    id: String,
    duration: TimeInterval,
    heartRate: Double
) -> CanonicalWorkout {
    let start = Date(timeIntervalSince1970: id == "changed" ? 10_000 : 20_000)
    let evidence = WorkoutEvidence(
        workoutID: id,
        loadedAt: start,
        series: [
            .heartRate: WorkoutMetricSeries(
                metric: .heartRate,
                unit: "count/min",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(60), value: heartRate),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(120), value: heartRate + 2)
                ]
            )
        ]
    )
    return CanonicalWorkout(
        id: id,
        sourceID: id,
        sourceName: "Persistence tests",
        startDate: start,
        endDate: start.addingTimeInterval(duration),
        environment: .outdoor,
        distanceMeters: 5_000,
        durationSeconds: duration,
        evidence: evidence
    )
}

@MainActor
private func persistenceGoalContext() throws -> ModelContext {
    let schema = Schema(versionedSchema: RunSignalPersistenceSchemaV2.self)
    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    let container = try RunSignalPersistenceContainer.make(configurations: [configuration])
    return ModelContext(container)
}
