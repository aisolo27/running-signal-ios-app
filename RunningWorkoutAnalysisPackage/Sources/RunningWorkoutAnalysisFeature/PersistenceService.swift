import Foundation
import SwiftData

@MainActor
public enum PersistenceService {
    public static func fetchWorkouts(context: ModelContext) -> [CanonicalWorkout] {
        let descriptor = FetchDescriptor<PersistedWorkout>(
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )
        do {
            return try context.fetch(descriptor).map(\.canonical)
        } catch {
            return []
        }
    }

    public static func upsert(_ workouts: [CanonicalWorkout], context: ModelContext) {
        let existing = fetchPersisted(context: context)
        var byID = Dictionary(uniqueKeysWithValues: existing.map { ($0.id, $0) })
        let existingEvidence = fetchPersistedEvidence(context: context)
        var evidenceByID = Dictionary(uniqueKeysWithValues: existingEvidence.map { ($0.workoutID, $0) })
        let existingDerivedAnalyses = fetchPersistedDerivedAnalyses(context: context)
        var derivedAnalysisByID = Dictionary(uniqueKeysWithValues: existingDerivedAnalyses.map { ($0.workoutID, $0) })

        for workout in workouts {
            let record: PersistedWorkout
            if let existingRecord = byID[workout.id] {
                existingRecord.update(from: workout, preservingManualFields: true)
                record = existingRecord
            } else {
                let newRecord = PersistedWorkout(workout: workout)
                context.insert(newRecord)
                byID[workout.id] = newRecord
                record = newRecord
            }

            let sourceSummary = "\(workout.sourceName) · \(workout.startDate.ISO8601Format())"
            if let evidence = workout.evidence {
                if let evidenceRecord = evidenceByID[workout.id] {
                    evidenceRecord.update(evidence: evidence, sourceSummary: sourceSummary)
                } else {
                    let evidenceRecord = PersistedWorkoutEvidence(workoutID: workout.id, evidence: evidence, sourceSummary: sourceSummary)
                    context.insert(evidenceRecord)
                    evidenceByID[workout.id] = evidenceRecord
                }
            }

            guard let evidence = workout.evidence ?? evidenceByID[workout.id]?.evidence else { continue }
            let analysis = DerivedAnalyticsEngine.analyze(workout: record.canonical, evidence: evidence)
            if let analysisRecord = derivedAnalysisByID[workout.id] {
                analysisRecord.update(analysis: analysis)
            } else {
                let analysisRecord = PersistedDerivedWorkoutAnalysis(analysis: analysis)
                context.insert(analysisRecord)
                derivedAnalysisByID[workout.id] = analysisRecord
            }
        }

        try? context.save()
    }

    public static func deleteWorkouts(ids: Set<String>, context: ModelContext) {
        guard !ids.isEmpty else { return }
        for record in fetchPersisted(context: context) where ids.contains(record.id) {
            context.delete(record)
        }
        for record in fetchPersistedEvidence(context: context) where ids.contains(record.workoutID) {
            context.delete(record)
        }
        for record in fetchEnrichmentStates(context: context) where ids.contains(record.workoutID) {
            context.delete(record)
        }
        for record in fetchPersistedDerivedAnalyses(context: context) where ids.contains(record.workoutID) {
            context.delete(record)
        }
        try? context.save()
    }

    public static func fetchEvidence(workoutID: String, context: ModelContext) -> WorkoutEvidence? {
        fetchPersistedEvidence(context: context)
            .first { $0.workoutID == workoutID }?
            .evidence
    }

    public static func fetchEvidenceByWorkoutID(context: ModelContext) -> [String: WorkoutEvidence] {
        Dictionary(uniqueKeysWithValues: fetchPersistedEvidence(context: context).compactMap { record in
            guard let evidence = record.evidence else { return nil }
            return (record.workoutID, evidence)
        })
    }

    public static func fetchEvidenceSummaries(context: ModelContext) -> [PersistedWorkoutEvidence] {
        fetchPersistedEvidence(context: context)
    }

    public static func fetchEvidenceIDs(context: ModelContext) -> Set<String> {
        Set(fetchPersistedEvidence(context: context).map(\.workoutID))
    }

    public static func fetchDerivedAnalysis(workoutID: String, context: ModelContext) -> DerivedWorkoutAnalysis? {
        fetchPersistedDerivedAnalyses(context: context)
            .first { $0.workoutID == workoutID }?
            .analysis
    }

    public static func fetchDerivedAnalysisSummaries(context: ModelContext) -> [PersistedDerivedWorkoutAnalysis] {
        fetchPersistedDerivedAnalyses(context: context)
    }

    @discardableResult
    public static func refreshDerivedAnalyses(context: ModelContext) -> Int {
        let workoutsByID = Dictionary(uniqueKeysWithValues: fetchPersisted(context: context).map { ($0.id, $0.canonical) })
        let evidenceByID = Dictionary(uniqueKeysWithValues: fetchPersistedEvidence(context: context).compactMap { record in
            record.evidence.map { (record.workoutID, $0) }
        })
        var derivedAnalysisByID = Dictionary(
            uniqueKeysWithValues: fetchPersistedDerivedAnalyses(context: context).map { ($0.workoutID, $0) }
        )
        var refreshedCount = 0

        for (workoutID, evidence) in evidenceByID {
            guard let workout = workoutsByID[workoutID] else { continue }
            let analysis = DerivedAnalyticsEngine.analyze(workout: workout, evidence: evidence)
            if let record = derivedAnalysisByID[workoutID] {
                record.update(analysis: analysis)
            } else {
                let record = PersistedDerivedWorkoutAnalysis(analysis: analysis)
                context.insert(record)
                derivedAnalysisByID[workoutID] = record
            }
            refreshedCount += 1
        }

        try? context.save()
        return refreshedCount
    }

    public static func fetchEnrichmentStateByID(context: ModelContext) -> [String: PersistedEvidenceEnrichmentState] {
        Dictionary(uniqueKeysWithValues: fetchEnrichmentStates(context: context).map { ($0.workoutID, $0) })
    }

    public static func markEnrichmentAttempt(
        ids: [String],
        status: EvidenceEnrichmentStatus,
        message: String?,
        context: ModelContext,
        at date: Date = Date()
    ) {
        guard !ids.isEmpty else { return }
        var byID = fetchEnrichmentStateByID(context: context)
        for id in ids {
            if let record = byID[id] {
                record.markAttempt(status: status, message: message, at: date)
            } else {
                let record = PersistedEvidenceEnrichmentState(
                    workoutID: id,
                    status: status,
                    lastAttemptAt: date,
                    attemptCount: 1,
                    message: message
                )
                context.insert(record)
                byID[id] = record
            }
        }
        try? context.save()
    }

    public static func updateManualFields(id: String, runType: RunType?, notes: String, context: ModelContext) {
        guard let record = fetchPersisted(context: context).first(where: { $0.id == id }) else { return }
        record.manualRunTypeRaw = runType?.rawValue
        record.notes = notes
        record.updatedAt = Date()
        try? context.save()
    }

    private static func fetchPersisted(context: ModelContext) -> [PersistedWorkout] {
        do {
            return try context.fetch(FetchDescriptor<PersistedWorkout>())
        } catch {
            return []
        }
    }

    private static func fetchPersistedEvidence(context: ModelContext) -> [PersistedWorkoutEvidence] {
        do {
            return try context.fetch(FetchDescriptor<PersistedWorkoutEvidence>())
        } catch {
            return []
        }
    }

    private static func fetchEnrichmentStates(context: ModelContext) -> [PersistedEvidenceEnrichmentState] {
        do {
            return try context.fetch(FetchDescriptor<PersistedEvidenceEnrichmentState>())
        } catch {
            return []
        }
    }

    private static func fetchPersistedDerivedAnalyses(context: ModelContext) -> [PersistedDerivedWorkoutAnalysis] {
        do {
            return try context.fetch(FetchDescriptor<PersistedDerivedWorkoutAnalysis>())
        } catch {
            return []
        }
    }
}
