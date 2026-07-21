import Foundation
import SwiftData

public enum PersistenceReadError: Error, Equatable, LocalizedError, Sendable {
    case workoutFetchFailed(details: String)

    public var errorDescription: String? {
        switch self {
        case .workoutFetchFailed:
            return "The saved workout cache could not be read. Your Apple Health data has not been changed."
        }
    }

    public var diagnosticDetails: String {
        switch self {
        case let .workoutFetchFailed(details):
            return details
        }
    }
}

@MainActor
public enum PersistenceService {
    public static func fetchWorkouts(context: ModelContext) -> [CanonicalWorkout] {
        (try? fetchWorkoutsForBootstrap(context: context)) ?? []
    }

    public static func fetchWorkoutsForBootstrap(context: ModelContext) throws -> [CanonicalWorkout] {
        let workouts = try fetchWorkoutsForBootstrap { descriptor in
            try context.fetch(descriptor)
        }
        let effortScores = Dictionary(
            uniqueKeysWithValues: fetchPersistedWorkoutEffortScores(context: context).compactMap { record in
                WorkoutEffortScore.normalized(record.score).map { (record.workoutID, $0) }
            }
        )
        return workouts.map { workout in
            var workout = workout
            workout.workoutEffortScore = effortScores[workout.id]
            return workout
        }
    }

    static func fetchWorkoutsForBootstrap(
        performingFetch fetch: (FetchDescriptor<PersistedWorkout>) throws -> [PersistedWorkout]
    ) throws -> [CanonicalWorkout] {
        let descriptor = FetchDescriptor<PersistedWorkout>(
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )
        do {
            return try fetch(descriptor).map(\.canonical)
        } catch {
            throw PersistenceReadError.workoutFetchFailed(details: String(describing: error))
        }
    }

    public static func fetchTrainingPeriodSummaries(context: ModelContext) -> [CachedTrainingPeriodSummary] {
        fetchPersistedTrainingPeriodSummaries(context: context)
            .compactMap(\.cachedSummary)
            .filter { $0.calculationVersion == CachedTrainingPeriodSummary.currentCalculationVersion }
    }

    @discardableResult
    public static func refreshTrainingPeriodSummaries(
        workouts: [CanonicalWorkout],
        context: ModelContext,
        now: Date = Date()
    ) -> [CachedTrainingPeriodSummary] {
        let summaries = CachedTrainingPeriodSummary.makeAll(workouts: workouts, now: now)
        var recordsByKey = Dictionary(
            uniqueKeysWithValues: fetchPersistedTrainingPeriodSummaries(context: context).map { ($0.cacheKey, $0) }
        )
        let activeKeys = Set(summaries.map(\.cacheKey))

        for summary in summaries {
            if let record = recordsByKey[summary.cacheKey] {
                record.update(summary: summary)
            } else {
                let record = PersistedTrainingPeriodSummary(summary: summary)
                context.insert(record)
                recordsByKey[summary.cacheKey] = record
            }
        }

        for record in recordsByKey.values where !activeKeys.contains(record.cacheKey) {
            context.delete(record)
        }

        try? context.save()
        return summaries
    }

    @discardableResult
    public static func refreshTrainingPeriodSummaries(
        affectedBy workout: CanonicalWorkout,
        workouts: [CanonicalWorkout],
        context: ModelContext,
        now: Date = Date()
    ) -> [CachedTrainingPeriodSummary] {
        let summaries = CachedTrainingPeriodSummary.makeAffectedByManualChange(
            workout: workout,
            workouts: workouts,
            now: now
        )
        var recordsByKey: [String: PersistedTrainingPeriodSummary] = [:]
        for record in fetchPersistedTrainingPeriodSummaries(context: context) {
            recordsByKey[record.cacheKey] = record
        }

        for summary in summaries {
            if let record = recordsByKey[summary.cacheKey] {
                record.update(summary: summary)
            } else {
                let record = PersistedTrainingPeriodSummary(summary: summary)
                context.insert(record)
                recordsByKey[summary.cacheKey] = record
            }
        }

        try? context.save()
        return summaries
    }

    public static func upsert(_ workouts: [CanonicalWorkout], context: ModelContext) {
        try? upsertAndSave(workouts, context: context)
    }

    public static func upsertAndSave(_ workouts: [CanonicalWorkout], context: ModelContext) throws {
        applyUpserts(workouts, context: context)
        try context.save()
    }

    public static func applySyncChangesAndSave(
        upserting workouts: [CanonicalWorkout],
        deletingIDs ids: Set<String>,
        context: ModelContext
    ) throws {
        guard !workouts.isEmpty || !ids.isEmpty else { return }
        applyWorkoutDeletes(ids: ids, context: context)
        applyUpserts(workouts, context: context)
        try context.save()
    }

    public static func upsertPreparedDetailedWorkout(
        _ workout: CanonicalWorkout,
        evidence: WorkoutEvidence,
        prepared: PreparedWorkoutPersistence,
        context: ModelContext
    ) {
        if let record = fetchPersistedWorkout(id: workout.id, context: context) {
            record.update(from: workout, preservingManualFields: true)
        } else {
            context.insert(PersistedWorkout(workout: workout))
        }
        reconcileWorkoutEffort(for: workout, context: context)

        let sourceSummary = "\(workout.sourceName) · \(workout.startDate.ISO8601Format())"
        if let evidenceRecord = fetchPersistedEvidence(workoutID: workout.id, context: context) {
            evidenceRecord.update(
                loadedAt: evidence.loadedAt,
                sourceSummary: sourceSummary,
                seriesSampleCount: evidence.seriesSampleCount,
                routePointCount: evidence.route.count,
                eventCount: evidence.events.count,
                evidenceData: prepared.evidenceData
            )
        } else {
            context.insert(
                PersistedWorkoutEvidence(
                    workoutID: workout.id,
                    loadedAt: evidence.loadedAt,
                    sourceSummary: sourceSummary,
                    seriesSampleCount: evidence.seriesSampleCount,
                    routePointCount: evidence.route.count,
                    eventCount: evidence.events.count,
                    evidenceData: prepared.evidenceData
                )
            )
        }

        if let analysisRecord = fetchPersistedDerivedAnalysis(workoutID: workout.id, context: context) {
            analysisRecord.update(analysis: prepared.analysis, analysisData: prepared.analysisData)
        } else {
            context.insert(
                PersistedDerivedWorkoutAnalysis(
                    analysis: prepared.analysis,
                    analysisData: prepared.analysisData
                )
            )
        }
        try? context.save()
    }

    public static func updatePreparedEvidence(
        workoutID: String,
        evidence: WorkoutEvidence,
        evidenceData: Data,
        context: ModelContext
    ) {
        guard let record = fetchPersistedEvidence(workoutID: workoutID, context: context) else { return }
        record.update(
            loadedAt: evidence.loadedAt,
            sourceSummary: record.sourceSummary,
            seriesSampleCount: evidence.seriesSampleCount,
            routePointCount: evidence.route.count,
            eventCount: evidence.events.count,
            evidenceData: evidenceData
        )
        try? context.save()
    }

    public static func updateWorkoutPlanName(
        workoutID: String,
        name: String,
        context: ModelContext
    ) {
        guard let record = fetchPersistedWorkout(id: workoutID, context: context) else { return }
        record.workoutPlanName = name
        record.updatedAt = Date()
        try? context.save()
    }

    public static func updateWorkoutPlanClassification(
        workoutID: String,
        name: String?,
        inferredRunType: RunType,
        context: ModelContext
    ) {
        guard let record = fetchPersistedWorkout(id: workoutID, context: context) else { return }
        if let name = name?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty {
            record.workoutPlanName = name
        }
        record.inferredRunTypeRaw = inferredRunType.rawValue
        record.updatedAt = Date()
        try? context.save()
    }

    private static func applyUpserts(_ workouts: [CanonicalWorkout], context: ModelContext) {
        for workout in workouts {
            let record: PersistedWorkout
            if let existingRecord = fetchPersistedWorkout(id: workout.id, context: context) {
                existingRecord.update(from: workout, preservingManualFields: true)
                record = existingRecord
            } else {
                let newRecord = PersistedWorkout(workout: workout)
                context.insert(newRecord)
                record = newRecord
            }

            reconcileWorkoutEffort(for: workout, context: context)

            let sourceSummary = "\(workout.sourceName) · \(workout.startDate.ISO8601Format())"
            let evidenceRecord = fetchPersistedEvidence(workoutID: workout.id, context: context)
            if let evidence = workout.evidence {
                if let evidenceRecord {
                    evidenceRecord.update(evidence: evidence, sourceSummary: sourceSummary)
                } else {
                    let evidenceRecord = PersistedWorkoutEvidence(workoutID: workout.id, evidence: evidence, sourceSummary: sourceSummary)
                    context.insert(evidenceRecord)
                }
            }

            // A summary refresh can change duration or other workout-level inputs, so its
            // derived analysis still needs refreshing. Decode only this workout's cached
            // evidence rather than faulting every evidence blob in the store.
            guard let evidence = workout.evidence ?? evidenceRecord?.evidence else { continue }
            let analysis = DerivedAnalyticsEngine.analyze(workout: record.canonical, evidence: evidence)
            if let analysisRecord = fetchPersistedDerivedAnalysis(workoutID: workout.id, context: context) {
                analysisRecord.update(analysis: analysis)
            } else {
                let analysisRecord = PersistedDerivedWorkoutAnalysis(analysis: analysis)
                context.insert(analysisRecord)
            }
        }

    }

    public static func deleteWorkouts(ids: Set<String>, context: ModelContext) {
        try? deleteWorkoutsAndSave(ids: ids, context: context)
    }

    public static func deleteWorkoutsAndSave(ids: Set<String>, context: ModelContext) throws {
        applyWorkoutDeletes(ids: ids, context: context)
        try context.save()
    }

    private static func applyWorkoutDeletes(ids: Set<String>, context: ModelContext) {
        guard !ids.isEmpty else { return }
        for id in ids {
            fetchPersistedWorkout(id: id, context: context).map(context.delete)
            fetchPersistedWorkoutEffortScore(workoutID: id, context: context).map(context.delete)
            fetchPersistedEvidence(workoutID: id, context: context).map(context.delete)
            fetchEnrichmentState(workoutID: id, context: context).map(context.delete)
            fetchPersistedDerivedAnalysis(workoutID: id, context: context).map(context.delete)
        }
    }

    public static func deleteEvidence(ids: Set<String>, context: ModelContext) {
        guard !ids.isEmpty else { return }
        for id in ids {
            fetchPersistedEvidence(workoutID: id, context: context).map(context.delete)
            fetchEnrichmentState(workoutID: id, context: context).map(context.delete)
            fetchPersistedDerivedAnalysis(workoutID: id, context: context).map(context.delete)
        }
        try? context.save()
    }

    public static func fetchEvidence(workoutID: String, context: ModelContext) -> WorkoutEvidence? {
        fetchPersistedEvidence(workoutID: workoutID, context: context)?.evidence
    }

    public static func fetchEvidenceData(workoutID: String, context: ModelContext) -> Data? {
        fetchPersistedEvidence(workoutID: workoutID, context: context)?.evidenceData
    }

    /// Fetches one evidence cache row without decoding its evidence blob.
    public static func fetchEvidenceSummary(
        workoutID: String,
        context: ModelContext
    ) -> PersistedWorkoutEvidence? {
        fetchPersistedEvidence(workoutID: workoutID, context: context)
    }

    public static func fetchEvidenceByWorkoutID(context: ModelContext) -> [String: WorkoutEvidence] {
        Dictionary(uniqueKeysWithValues: fetchPersistedEvidence(context: context).compactMap { record in
            guard let evidence = record.evidence else { return nil }
            return (record.workoutID, evidence)
        })
    }

    public static func fetchEvidenceByWorkoutID(
        workoutIDs: some Sequence<String>,
        context: ModelContext
    ) -> [String: WorkoutEvidence] {
        var result: [String: WorkoutEvidence] = [:]
        for id in Set(workoutIDs) {
            result[id] = fetchPersistedEvidence(workoutID: id, context: context)?.evidence
        }
        return result
    }

    public static func fetchEvidenceSummaries(context: ModelContext) -> [PersistedWorkoutEvidence] {
        fetchPersistedEvidence(context: context)
    }

    public static func fetchEvidenceIDs(context: ModelContext) -> Set<String> {
        var descriptor = FetchDescriptor<PersistedWorkoutEvidence>()
        descriptor.propertiesToFetch = [\.workoutID]
        return Set((try? context.fetch(descriptor).map(\.workoutID)) ?? [])
    }

    /// Returns only the requested IDs that currently have persisted evidence.
    /// Use this for bounded queues to avoid materializing the complete evidence table.
    public static func fetchEvidenceIDs(
        workoutIDs: some Sequence<String>,
        context: ModelContext
    ) -> Set<String> {
        Set(workoutIDs.compactMap { id in
            fetchPersistedEvidence(workoutID: id, context: context)?.workoutID
        })
    }

    public static func fetchDerivedAnalysis(workoutID: String, context: ModelContext) -> DerivedWorkoutAnalysis? {
        fetchPersistedDerivedAnalysis(workoutID: workoutID, context: context)?.analysis
    }

    /// Fetches one derived-analysis cache row without decoding its analysis blob.
    public static func fetchDerivedAnalysisSummary(
        workoutID: String,
        context: ModelContext
    ) -> PersistedDerivedWorkoutAnalysis? {
        fetchPersistedDerivedAnalysis(workoutID: workoutID, context: context)
    }

    public static func fetchDerivedAnalysisSummaries(context: ModelContext) -> [PersistedDerivedWorkoutAnalysis] {
        fetchPersistedDerivedAnalyses(context: context)
    }

    /// Refreshes derived analytics for a bounded set of workouts. Missing workout
    /// summaries or evidence are left untouched, which preserves the last valid cache.
    @discardableResult
    public static func refreshDerivedAnalyses(
        workoutIDs: some Sequence<String>,
        context: ModelContext
    ) -> Int {
        var refreshedCount = 0
        for workoutID in workoutIDs {
            guard let workout = fetchPersistedWorkout(id: workoutID, context: context)?.canonical,
                  let evidence = fetchPersistedEvidence(workoutID: workoutID, context: context)?.evidence else {
                continue
            }
            let analysis = DerivedAnalyticsEngine.analyze(workout: workout, evidence: evidence)
            if let record = fetchPersistedDerivedAnalysis(workoutID: workoutID, context: context) {
                record.update(analysis: analysis)
            } else {
                context.insert(PersistedDerivedWorkoutAnalysis(analysis: analysis))
            }
            refreshedCount += 1
        }
        if refreshedCount > 0 {
            try? context.save()
        }
        return refreshedCount
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

    public static func fetchEnrichmentStateByID(
        workoutIDs: some Sequence<String>,
        context: ModelContext
    ) -> [String: PersistedEvidenceEnrichmentState] {
        var result: [String: PersistedEvidenceEnrichmentState] = [:]
        for id in Set(workoutIDs) {
            result[id] = fetchEnrichmentState(workoutID: id, context: context)
        }
        return result
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
        for id in ids {
            if let record = fetchEnrichmentState(workoutID: id, context: context) {
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
            }
        }
        try? context.save()
    }

    public static func fetchEvidenceRefreshJobs(context: ModelContext) -> [PersistedEvidenceRefreshJob] {
        fetchRefreshJobs(context: context)
            .sorted { $0.updatedAt > $1.updatedAt }
    }

    public static func fetchEvidenceRefreshJob(
        jobID: String,
        context: ModelContext
    ) -> PersistedEvidenceRefreshJob? {
        fetchRefreshJob(jobID: jobID, context: context)
    }

    public static func fetchEvidenceRefreshItems(jobID: String, context: ModelContext) -> [PersistedEvidenceRefreshJobItem] {
        fetchRefreshJobItems(jobID: jobID, context: context)
            .sorted { $0.workoutID < $1.workoutID }
    }

    public static func fetchEvidenceRefreshItem(
        jobID: String,
        workoutID: String,
        context: ModelContext
    ) -> PersistedEvidenceRefreshJobItem? {
        fetchRefreshJobItem(jobID: jobID, workoutID: workoutID, context: context)
    }

    public static func fetchHealthKitImportJob(context: ModelContext) -> PersistedHealthKitImportJob? {
        fetchHealthKitImportJob(jobID: "initial-healthkit-import", context: context)
    }

    @discardableResult
    public static func startHealthKitImportJob(
        context: ModelContext,
        windowStart: Date?,
        windowEnd: Date?,
        at date: Date = Date()
    ) -> PersistedHealthKitImportJob {
        let job = fetchHealthKitImportJob(context: context) ?? {
            let job = PersistedHealthKitImportJob(createdAt: date)
            context.insert(job)
            return job
        }()
        if job.status == .completed {
            job.importedCount = 0
            job.failedCount = 0
            job.skippedCount = 0
        }
        job.markRunning(windowStart: windowStart, windowEnd: windowEnd, at: date)
        try? context.save()
        return job
    }

    public static func updateHealthKitImportProgress(
        imported: Int,
        windowStart: Date?,
        windowEnd: Date?,
        context: ModelContext,
        at date: Date = Date()
    ) {
        guard let job = fetchHealthKitImportJob(context: context) else { return }
        job.markProgress(imported: imported, windowStart: windowStart, windowEnd: windowEnd, at: date)
        try? context.save()
    }

    public static func pauseHealthKitImportJob(
        reason: IngestionPauseReason,
        context: ModelContext,
        at date: Date = Date()
    ) {
        guard let job = fetchHealthKitImportJob(context: context) else { return }
        job.markPaused(reason: reason, at: date)
        try? context.save()
    }

    public static func finishHealthKitImportJob(
        status: HealthKitImportJobStatus,
        message: String?,
        context: ModelContext,
        at date: Date = Date()
    ) {
        guard let job = fetchHealthKitImportJob(context: context) else { return }
        job.markFinished(status: status, message: message, at: date)
        try? context.save()
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
        let job = fetchRefreshJobs(dedupKey: dedupKey, context: context)
            .first { activeStatuses.contains($0.status) } ?? {
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
            uniqueKeysWithValues: fetchRefreshJobItems(jobID: job.jobID, context: context)
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
        guard let item = fetchRefreshJobItem(jobID: jobID, workoutID: workoutID, context: context) else { return }
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
        guard let item = fetchRefreshJobItem(jobID: jobID, workoutID: workoutID, context: context) else { return }
        item.finish(
            status: status,
            message: message,
            oldEvidencePreserved: oldEvidencePreserved,
            newEvidenceCommitted: newEvidenceCommitted,
            at: date
        )
        if let job = fetchRefreshJob(jobID: jobID, context: context) {
            refreshEvidenceRefreshJobCounts(job: job, context: context, at: date)
        }
        try? context.save()
    }

    public static func finishEvidenceRefreshJob(
        jobID: String,
        context: ModelContext,
        at date: Date = Date()
    ) {
        guard let job = fetchRefreshJob(jobID: jobID, context: context) else { return }
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
        for job in fetchRefreshJobs(status: .running, context: context) {
            job.markPaused(at: date, message: message)
            pausedCount += 1
        }
        if pausedCount > 0 {
            try? context.save()
        }
        return pausedCount
    }

    public static func updateManualFields(id: String, runType: RunType?, notes: String, context: ModelContext) {
        guard let record = fetchPersistedWorkout(id: id, context: context) else { return }
        record.manualRunTypeRaw = runType?.rawValue
        record.notes = notes
        record.updatedAt = Date()
        try? context.save()
    }

    public static func updateManualFields(updates: [ManualWorkoutFieldUpdate], context: ModelContext) {
        guard !updates.isEmpty else { return }
        var changed = false
        let date = Date()

        for update in updates {
            guard let record = fetchPersistedWorkout(id: update.id, context: context) else { continue }
            record.manualRunTypeRaw = update.runType?.rawValue
            record.notes = update.notes
            record.updatedAt = date
            changed = true
        }

        if changed {
            try? context.save()
        }
    }

    private static func refreshEvidenceRefreshJobCounts(
        job: PersistedEvidenceRefreshJob,
        context: ModelContext,
        at date: Date
    ) {
        let items = fetchRefreshJobItems(jobID: job.jobID, context: context)
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

    private static func fetchPersistedWorkout(id: String, context: ModelContext) -> PersistedWorkout? {
        var descriptor = FetchDescriptor<PersistedWorkout>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    private static func fetchPersistedWorkoutEffortScores(context: ModelContext) -> [PersistedWorkoutEffortScore] {
        do {
            return try context.fetch(FetchDescriptor<PersistedWorkoutEffortScore>())
        } catch {
            return []
        }
    }

    private static func fetchPersistedWorkoutEffortScore(
        workoutID: String,
        context: ModelContext
    ) -> PersistedWorkoutEffortScore? {
        var descriptor = FetchDescriptor<PersistedWorkoutEffortScore>(
            predicate: #Predicate { $0.workoutID == workoutID }
        )
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    private static func reconcileWorkoutEffort(for workout: CanonicalWorkout, context: ModelContext) {
        guard workout.workoutEffortWasQueried else { return }
        let record = fetchPersistedWorkoutEffortScore(workoutID: workout.id, context: context)
        if let score = WorkoutEffortScore.normalized(workout.workoutEffortScore) {
            if let record {
                record.update(score: score)
            } else {
                context.insert(PersistedWorkoutEffortScore(workoutID: workout.id, score: score))
            }
        } else {
            record.map(context.delete)
        }
    }

    private static func fetchPersistedEvidence(context: ModelContext) -> [PersistedWorkoutEvidence] {
        do {
            return try context.fetch(FetchDescriptor<PersistedWorkoutEvidence>())
        } catch {
            return []
        }
    }

    private static func fetchPersistedEvidence(
        workoutID: String,
        context: ModelContext
    ) -> PersistedWorkoutEvidence? {
        var descriptor = FetchDescriptor<PersistedWorkoutEvidence>(
            predicate: #Predicate { $0.workoutID == workoutID }
        )
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    private static func fetchEnrichmentStates(context: ModelContext) -> [PersistedEvidenceEnrichmentState] {
        do {
            return try context.fetch(FetchDescriptor<PersistedEvidenceEnrichmentState>())
        } catch {
            return []
        }
    }

    private static func fetchEnrichmentState(
        workoutID: String,
        context: ModelContext
    ) -> PersistedEvidenceEnrichmentState? {
        var descriptor = FetchDescriptor<PersistedEvidenceEnrichmentState>(
            predicate: #Predicate { $0.workoutID == workoutID }
        )
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    private static func fetchRefreshJobs(context: ModelContext) -> [PersistedEvidenceRefreshJob] {
        do {
            return try context.fetch(FetchDescriptor<PersistedEvidenceRefreshJob>())
        } catch {
            return []
        }
    }

    private static func fetchRefreshJob(
        jobID: String,
        context: ModelContext
    ) -> PersistedEvidenceRefreshJob? {
        var descriptor = FetchDescriptor<PersistedEvidenceRefreshJob>(
            predicate: #Predicate { $0.jobID == jobID }
        )
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    private static func fetchRefreshJobs(
        dedupKey: String,
        context: ModelContext
    ) -> [PersistedEvidenceRefreshJob] {
        let descriptor = FetchDescriptor<PersistedEvidenceRefreshJob>(
            predicate: #Predicate { $0.dedupKey == dedupKey }
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    private static func fetchRefreshJobs(
        status: EvidenceRefreshJobStatus,
        context: ModelContext
    ) -> [PersistedEvidenceRefreshJob] {
        let statusRaw = status.rawValue
        let descriptor = FetchDescriptor<PersistedEvidenceRefreshJob>(
            predicate: #Predicate { $0.statusRaw == statusRaw }
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    private static func fetchRefreshJobItems(context: ModelContext) -> [PersistedEvidenceRefreshJobItem] {
        do {
            return try context.fetch(FetchDescriptor<PersistedEvidenceRefreshJobItem>())
        } catch {
            return []
        }
    }

    private static func fetchRefreshJobItems(
        jobID: String,
        context: ModelContext
    ) -> [PersistedEvidenceRefreshJobItem] {
        let descriptor = FetchDescriptor<PersistedEvidenceRefreshJobItem>(
            predicate: #Predicate { $0.jobID == jobID }
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    private static func fetchRefreshJobItem(
        jobID: String,
        workoutID: String,
        context: ModelContext
    ) -> PersistedEvidenceRefreshJobItem? {
        let itemID = PersistedEvidenceRefreshJobItem.makeItemID(jobID: jobID, workoutID: workoutID)
        var descriptor = FetchDescriptor<PersistedEvidenceRefreshJobItem>(
            predicate: #Predicate { $0.itemID == itemID }
        )
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    private static func fetchHealthKitImportJobs(context: ModelContext) -> [PersistedHealthKitImportJob] {
        do {
            return try context.fetch(FetchDescriptor<PersistedHealthKitImportJob>())
        } catch {
            return []
        }
    }

    private static func fetchHealthKitImportJob(
        jobID: String,
        context: ModelContext
    ) -> PersistedHealthKitImportJob? {
        var descriptor = FetchDescriptor<PersistedHealthKitImportJob>(
            predicate: #Predicate { $0.jobID == jobID }
        )
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    private static func fetchPersistedDerivedAnalyses(context: ModelContext) -> [PersistedDerivedWorkoutAnalysis] {
        do {
            return try context.fetch(FetchDescriptor<PersistedDerivedWorkoutAnalysis>())
        } catch {
            return []
        }
    }

    private static func fetchPersistedDerivedAnalysis(
        workoutID: String,
        context: ModelContext
    ) -> PersistedDerivedWorkoutAnalysis? {
        var descriptor = FetchDescriptor<PersistedDerivedWorkoutAnalysis>(
            predicate: #Predicate { $0.workoutID == workoutID }
        )
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    private static func fetchPersistedTrainingPeriodSummaries(context: ModelContext) -> [PersistedTrainingPeriodSummary] {
        do {
            return try context.fetch(FetchDescriptor<PersistedTrainingPeriodSummary>())
        } catch {
            return []
        }
    }
}
