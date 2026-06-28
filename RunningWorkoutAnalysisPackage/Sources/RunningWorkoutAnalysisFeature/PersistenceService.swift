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

    public static func deleteEvidence(ids: Set<String>, context: ModelContext) {
        guard !ids.isEmpty else { return }
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

    @discardableResult
    public static func refreshStaleDerivedAnalyses(context: ModelContext) -> Int {
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
            let expectedSignature = PersistedDerivedWorkoutAnalysis.signature(for: analysis.inputSummary)
            if let record = derivedAnalysisByID[workoutID] {
                guard record.calculationVersion != analysis.calculationVersion || record.inputSignature != expectedSignature else {
                    continue
                }
                record.update(analysis: analysis)
            } else {
                let record = PersistedDerivedWorkoutAnalysis(analysis: analysis)
                context.insert(record)
                derivedAnalysisByID[workoutID] = record
            }
            refreshedCount += 1
        }

        if refreshedCount > 0 {
            try? context.save()
        }
        return refreshedCount
    }

    public static func fetchEnrichmentStateByID(context: ModelContext) -> [String: PersistedEvidenceEnrichmentState] {
        Dictionary(uniqueKeysWithValues: fetchEnrichmentStates(context: context).map { ($0.workoutID, $0) })
    }

    public static func outdatedDerivedAnalysisVersionIDs(context: ModelContext) -> [String] {
        fetchPersistedDerivedAnalyses(context: context)
            .filter { $0.calculationVersion != DerivedWorkoutAnalysis.currentVersion }
            .map(\.workoutID)
            .sorted()
    }

    public static func staleDerivedAnalysisIDs(context: ModelContext) -> [String] {
        let workoutsByID = Dictionary(uniqueKeysWithValues: fetchPersisted(context: context).map { ($0.id, $0.canonical) })
        let evidenceByID = Dictionary(uniqueKeysWithValues: fetchPersistedEvidence(context: context).compactMap { record in
            record.evidence.map { (record.workoutID, $0) }
        })
        let derivedAnalysisByID = Dictionary(
            uniqueKeysWithValues: fetchPersistedDerivedAnalyses(context: context).map { ($0.workoutID, $0) }
        )

        return evidenceByID.compactMap { (workoutID: String, evidence: WorkoutEvidence) -> String? in
            guard let workout = workoutsByID[workoutID] else { return nil }
            let analysis = DerivedAnalyticsEngine.analyze(workout: workout, evidence: evidence)
            let expectedSignature = PersistedDerivedWorkoutAnalysis.signature(for: analysis.inputSummary)
            guard let record = derivedAnalysisByID[workoutID] else { return workoutID }
            return record.calculationVersion != analysis.calculationVersion || record.inputSignature != expectedSignature ? workoutID : nil
        }
        .sorted()
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

    public static func fetchEvidenceRefreshJobs(context: ModelContext) -> [PersistedEvidenceRefreshJob] {
        fetchRefreshJobs(context: context)
            .sorted { $0.updatedAt > $1.updatedAt }
    }

    public static func fetchEvidenceRefreshItems(jobID: String, context: ModelContext) -> [PersistedEvidenceRefreshJobItem] {
        fetchRefreshJobItems(context: context)
            .filter { $0.jobID == jobID }
            .sorted { $0.workoutID < $1.workoutID }
    }

    @discardableResult
    public static func startEvidenceRefreshJob(
        refreshKind: EvidenceRefreshKind,
        scopeType: EvidenceRefreshScopeType,
        scopeKey: String,
        workoutIDs: [String],
        context: ModelContext,
        at date: Date = Date()
    ) -> PersistedEvidenceRefreshJob {
        let dedupKey = PersistedEvidenceRefreshJob.makeDedupKey(
            refreshKind: refreshKind,
            scopeType: scopeType,
            scopeKey: scopeKey
        )
        let activeStatuses: Set<EvidenceRefreshJobStatus> = [.queued, .running, .paused, .failed, .blocked]
        let job = fetchRefreshJobs(context: context).first {
            $0.dedupKey == dedupKey && activeStatuses.contains($0.status)
        } ?? {
            let job = PersistedEvidenceRefreshJob(
                refreshKind: refreshKind,
                scopeType: scopeType,
                scopeKey: scopeKey,
                createdAt: date,
                totalCount: workoutIDs.count
            )
            context.insert(job)
            return job
        }()

        job.totalCount = workoutIDs.count
        job.markRunning(at: date)

        var itemsByID = Dictionary(
            uniqueKeysWithValues: fetchRefreshJobItems(context: context)
                .filter { $0.jobID == job.jobID }
                .map { ($0.workoutID, $0) }
        )
        for workoutID in workoutIDs where itemsByID[workoutID] == nil {
            let item = PersistedEvidenceRefreshJobItem(jobID: job.jobID, workoutID: workoutID, createdAt: date)
            context.insert(item)
            itemsByID[workoutID] = item
        }
        refreshEvidenceRefreshJobCounts(job: job, context: context, at: date)
        try? context.save()
        return job
    }

    public static func markEvidenceRefreshItemRunning(
        jobID: String,
        workoutID: String,
        context: ModelContext,
        at date: Date = Date()
    ) {
        guard let item = fetchRefreshJobItems(context: context)
            .first(where: { $0.jobID == jobID && $0.workoutID == workoutID }) else { return }
        item.markRunning(at: date)
        try? context.save()
    }

    public static func finishEvidenceRefreshItem(
        jobID: String,
        workoutID: String,
        status: EvidenceRefreshJobItemStatus,
        message: String?,
        oldEvidencePreserved: Bool,
        newEvidenceCommitted: Bool,
        context: ModelContext,
        at date: Date = Date()
    ) {
        guard let item = fetchRefreshJobItems(context: context)
            .first(where: { $0.jobID == jobID && $0.workoutID == workoutID }) else { return }
        item.finish(
            status: status,
            message: message,
            oldEvidencePreserved: oldEvidencePreserved,
            newEvidenceCommitted: newEvidenceCommitted,
            at: date
        )
        if let job = fetchRefreshJobs(context: context).first(where: { $0.jobID == jobID }) {
            refreshEvidenceRefreshJobCounts(job: job, context: context, at: date)
        }
        try? context.save()
    }

    public static func finishEvidenceRefreshJob(
        jobID: String,
        context: ModelContext,
        at date: Date = Date()
    ) {
        guard let job = fetchRefreshJobs(context: context).first(where: { $0.jobID == jobID }) else { return }
        refreshEvidenceRefreshJobCounts(job: job, context: context, at: date)
        let status: EvidenceRefreshJobStatus
        if job.completedCount + job.failedCount + job.skippedCount >= job.totalCount {
            if job.failedCount > 0 {
                status = .failed
            } else if job.completedCount == 0 && job.skippedCount > 0 {
                status = .blocked
            } else {
                status = .completed
            }
        } else {
            status = .paused
        }
        let message: String?
        switch status {
        case .failed:
            message = "\(job.failedCount) workout evidence refresh item(s) failed."
        case .blocked:
            message = "\(job.skippedCount) workout evidence refresh item(s) skipped because HealthKit was unavailable or unsupported."
        default:
            message = nil
        }
        job.finish(
            status: status,
            message: message,
            at: date
        )
        try? context.save()
    }

    @discardableResult
    public static func pauseRunningEvidenceRefreshJobs(
        context: ModelContext,
        at date: Date = Date(),
        message: String = "Paused after app relaunch before completion."
    ) -> Int {
        var pausedCount = 0
        for job in fetchRefreshJobs(context: context) where job.status == .running {
            job.markPaused(at: date, message: message)
            pausedCount += 1
        }
        if pausedCount > 0 {
            try? context.save()
        }
        return pausedCount
    }

    public static func updateManualFields(id: String, runType: RunType?, notes: String, context: ModelContext) {
        guard let record = fetchPersisted(context: context).first(where: { $0.id == id }) else { return }
        record.manualRunTypeRaw = runType?.rawValue
        record.notes = notes
        record.updatedAt = Date()
        try? context.save()
    }

    private static func refreshEvidenceRefreshJobCounts(
        job: PersistedEvidenceRefreshJob,
        context: ModelContext,
        at date: Date
    ) {
        let items = fetchRefreshJobItems(context: context).filter { $0.jobID == job.jobID }
        job.updateCounts(
            completed: items.filter { $0.status == .success }.count,
            failed: items.filter { $0.status == .failed }.count,
            skipped: items.filter { $0.status == .skipped }.count,
            at: date
        )
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

    private static func fetchRefreshJobs(context: ModelContext) -> [PersistedEvidenceRefreshJob] {
        do {
            return try context.fetch(FetchDescriptor<PersistedEvidenceRefreshJob>())
        } catch {
            return []
        }
    }

    private static func fetchRefreshJobItems(context: ModelContext) -> [PersistedEvidenceRefreshJobItem] {
        do {
            return try context.fetch(FetchDescriptor<PersistedEvidenceRefreshJobItem>())
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
