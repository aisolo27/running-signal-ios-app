import Foundation
import Observation
import SwiftData

@MainActor
@Observable
public final class RunningAnalysisStore {
    public private(set) var workouts: [CanonicalWorkout] = []
    public private(set) var snapshot = AnalyticsEngine.snapshot(for: [])
    public private(set) var healthKitStatus = HealthKitActionStatus()
    public private(set) var isLoading = false
    public private(set) var isEnrichingAudit = false
    public private(set) var message = HealthKitActionStatus().message
    public private(set) var usesSampleData = true
    public private(set) var healthContext = SampleData.healthContext
    public private(set) var reviewedRunTypes: [ReviewedRunTypeRecord] = []
    public private(set) var runTypeReconciliation = RunTypeReconciliationSummary.empty
    public private(set) var syncState = HealthKitSyncState.empty
    public private(set) var evidenceQueueSummary = EvidenceEnrichmentQueueSummary.empty
    public private(set) var derivedAnalysesByWorkoutID: [String: DerivedWorkoutAnalysis] = [:]

    private let healthKitService: HealthKitService
    private let syncService: HealthKitWorkoutSyncService
    private var didBootstrap = false
    private weak var modelContext: ModelContext?

    public init(
        healthKitService: HealthKitService = HealthKitService(),
        syncService: HealthKitWorkoutSyncService? = nil
    ) {
        self.healthKitService = healthKitService
        self.syncService = syncService ?? HealthKitWorkoutSyncService(healthKitService: healthKitService)
    }

    public var authorizationState: AuthorizationState {
        healthKitStatus.authorizationState
    }

    public func bootstrap(modelContext: ModelContext) async {
        guard !didBootstrap else { return }
        didBootstrap = true
        self.modelContext = modelContext

        let persisted = PersistenceService.fetchWorkouts(context: modelContext)
        if persisted.isEmpty {
            workouts = SampleData.workouts
            healthContext = SampleData.healthContext
            PersistenceService.upsert(workouts, context: modelContext)
        } else if needsSampleEvidenceBackfill(persisted) {
            workouts = SampleData.workouts
            healthContext = SampleData.healthContext
            PersistenceService.upsert(workouts, context: modelContext)
        } else {
            workouts = removeSampleWorkoutsIfRealDataExists(persisted)
            if workouts.count != persisted.count {
                PersistenceService.deleteWorkouts(ids: sampleWorkoutIDs(in: persisted), context: modelContext)
            }
            workouts = DuplicateDetector.markDuplicates(workouts)
        }
        reviewedRunTypes = RunTypeReviewImportService.loadSavedReviews()
        syncState = HealthKitSyncState(lastSyncAt: HealthKitSyncStateStore.loadLastSyncAt())
        applyReviewedRunTypes()
        recompute()
    }

    public func refreshFromHealthKit() async {
        isLoading = true
        defer { isLoading = false }

        let result = await healthKitService.loadRunningWorkouts()
        healthContext = result.healthContext
        updateHealthKitStatus(
            authorizationState: result.authorizationState,
            message: result.message ?? "Loaded \(result.workouts.count) HealthKit running workouts."
        )

        guard !result.workouts.isEmpty else {
            usesSampleData = true
            healthContext = SampleData.healthContext
            if workouts.isEmpty {
                workouts = SampleData.workouts
                persistCurrent()
            }
            recompute()
            return
        }

        usesSampleData = false
        workouts = removeSampleWorkoutsIfRealDataExists(mergeManualFields(incoming: result.workouts, current: workouts))
        deletePersistedSampleWorkoutsIfNeeded()
        applyReviewedRunTypes()
        persistCurrent()
        recompute()
    }

    public func syncHealthKitChanges() async {
        isLoading = true
        defer { isLoading = false }

        let currentIDs = Set(workouts.map(\.id))
        let result = await syncService.syncRunningWorkouts(from: HealthKitSyncStateStore.loadAnchor())
        healthContext = result.healthContext
        updateHealthKitStatus(
            authorizationState: result.authorizationState,
            message: result.message ?? "HealthKit sync finished."
        )

        guard result.authorizationState == .authorized || result.authorizationState == .partial else {
            recompute()
            return
        }

        if let anchor = result.newAnchor {
            HealthKitSyncStateStore.saveAnchor(anchor)
        }

        let insertedCount = result.fetchedWorkouts.filter { !currentIDs.contains($0.id) }.count
        let updatedCount = result.fetchedWorkouts.count - insertedCount
        let deletedCount = result.deletedWorkoutIDs.count
        let syncedAt = Date()
        HealthKitSyncStateStore.saveLastSyncAt(syncedAt)

        if !result.fetchedWorkouts.isEmpty {
            usesSampleData = false
            workouts = removeSampleWorkoutsIfRealDataExists(mergeSyncedWorkouts(changes: result.fetchedWorkouts, current: workouts))
            deletePersistedSampleWorkoutsIfNeeded()
            applyReviewedRunTypes()
            persistCurrent()
        }
        refreshEvidenceQueueSummary()

        syncState = HealthKitSyncState(
            lastSyncAt: syncedAt,
            lastFetchedCount: result.fetchedWorkouts.count,
            lastInsertedCount: insertedCount,
            lastUpdatedCount: updatedCount,
            lastDeletedCount: deletedCount,
            lastEvidencePendingCount: evidenceQueueSummary.pendingCount
        )
        recompute()
    }

    public func enrichNextHealthKitAuditBatch(limit: Int = HealthKitService.defaultDetailedEvidenceLimit) async {
        let candidates = nextEvidenceQueueCandidateIDs(limit: limit)

        guard !candidates.isEmpty else {
            message = "No pending HealthKit evidence enrichment items are available."
            return
        }

        isEnrichingAudit = true
        defer { isEnrichingAudit = false }

        let result = await healthKitService.enrichRunningWorkouts(ids: Array(candidates))
        let statusMessage = result.message ?? "HealthKit audit enrichment finished."
        updateHealthKitStatus(authorizationState: result.authorizationState, message: statusMessage)
        if result.authorizationState == .authorized || result.authorizationState == .partial {
            let returnedIDs = Set(result.workouts.map(\.id))
            workouts = removeSampleWorkoutsIfRealDataExists(mergeSyncedWorkouts(changes: result.workouts, current: workouts))
            deletePersistedSampleWorkoutsIfNeeded()
            applyReviewedRunTypes()
            persistCurrent()
            markEvidenceQueueAttempt(ids: Array(returnedIDs), status: .enriched, message: result.message)
            let missingIDs = candidates.filter { !returnedIDs.contains($0) }
            markEvidenceQueueAttempt(
                ids: missingIDs,
                status: .failed,
                message: "HealthKit did not return this workout for enrichment."
            )
        } else {
            markEvidenceQueueAttempt(ids: candidates, status: .failed, message: result.message)
        }
        recompute()
    }

    public func update(workoutID: String, manualRunType: RunType?, notes: String) {
        guard let index = workouts.firstIndex(where: { $0.id == workoutID }) else { return }
        workouts[index].manualRunType = manualRunType
        workouts[index].notes = notes
        if let modelContext {
            PersistenceService.updateManualFields(id: workoutID, runType: manualRunType, notes: notes, context: modelContext)
        }
        recompute()
    }

    public func importReviewedRunTypes(from url: URL) {
        do {
            let reviews = try RunTypeReviewImportService.importReviews(from: url)
            reviewedRunTypes = reviews
            RunTypeReviewImportService.saveReviews(reviews)
            applyReviewedRunTypes()
            persistCurrent()
            recompute()
            message = "Imported \(reviews.count) reviewed web run categories."
        } catch {
            message = error.localizedDescription
        }
    }

    public var latestOutdoorRun: CanonicalWorkout? {
        workouts
            .filter { !$0.isDuplicate && $0.environment == .outdoor }
            .sorted { $0.startDate > $1.startDate }
            .first
    }

    public var includedWorkouts: [CanonicalWorkout] {
        workouts.filter { !$0.isDuplicate }
    }

    public func derivedAnalysis(for workoutID: String) -> DerivedWorkoutAnalysis? {
        derivedAnalysesByWorkoutID[workoutID]
    }

    public var exportMarkdown: String {
        AnalyticsEngine.markdownSummary(workouts: workouts, snapshot: snapshot, healthContext: healthContext)
    }

    public var diagnosticsMarkdown: String {
        DiagnosticsExport.markdown(
            workouts: workouts,
            snapshot: snapshot,
            healthContext: healthContext,
            reconciliation: runTypeReconciliation,
            authorizationState: healthKitStatus.authorizationState,
            syncState: syncState,
            message: healthKitStatus.message
        )
    }

    public var healthKitAuditMarkdown: String {
        HealthKitAudit.markdown(workouts: workouts)
    }

    public var physicalVerificationMarkdown: String {
        PhysicalVerificationReport.markdown(workouts: workouts)
    }

    private func mergeManualFields(incoming: [CanonicalWorkout], current: [CanonicalWorkout]) -> [CanonicalWorkout] {
        let currentByID = Dictionary(uniqueKeysWithValues: current.map { ($0.id, $0) })
        return incoming.map { workout in
            var merged = workout
            if let existing = currentByID[workout.id] {
                merged.manualRunType = existing.manualRunType
                merged.importedRunType = existing.importedRunType
                merged.importedReviewID = existing.importedReviewID
                merged.notes = existing.notes
            }
            return merged
        }
    }

    private func mergeSyncedWorkouts(changes: [CanonicalWorkout], current: [CanonicalWorkout]) -> [CanonicalWorkout] {
        var byID = Dictionary(uniqueKeysWithValues: current.map { ($0.id, $0) })
        for change in changes {
            var merged = change
            if let existing = byID[change.id] {
                merged.manualRunType = existing.manualRunType
                merged.importedRunType = existing.importedRunType
                merged.importedReviewID = existing.importedReviewID
                merged.notes = existing.notes
            }
            byID[change.id] = merged
        }
        return byID.values.sorted { $0.startDate > $1.startDate }
    }

    private func removeSampleWorkoutsIfRealDataExists(_ workouts: [CanonicalWorkout]) -> [CanonicalWorkout] {
        guard workouts.contains(where: { !isSampleWorkout($0) }) else { return workouts }
        return workouts.filter { !isSampleWorkout($0) }
    }

    private func deletePersistedSampleWorkoutsIfNeeded() {
        guard let modelContext,
              workouts.contains(where: { !isSampleWorkout($0) }) else { return }
        PersistenceService.deleteWorkouts(ids: Set(SampleData.workouts.map(\.id)), context: modelContext)
    }

    private func sampleWorkoutIDs(in workouts: [CanonicalWorkout]) -> Set<String> {
        Set(workouts.filter(isSampleWorkout).map(\.id))
    }

    private func isSampleWorkout(_ workout: CanonicalWorkout) -> Bool {
        workout.sourceName == "Sample Apple Watch" || workout.id.hasPrefix("sample-")
    }

    private func evidencePendingCount(in workouts: [CanonicalWorkout]) -> Int {
        evidenceQueueSummary.pendingCount
    }

    private func needsSampleEvidenceBackfill(_ workouts: [CanonicalWorkout]) -> Bool {
        workouts.allSatisfy { $0.sourceName == "Sample Apple Watch" }
            && workouts.contains { $0.seriesAvailable && $0.seriesSampleCount == 0 }
    }

    private func persistCurrent() {
        guard let modelContext else { return }
        PersistenceService.upsert(workouts, context: modelContext)
    }

    private func recompute() {
        workouts = DuplicateDetector.markDuplicates(workouts)
        runTypeReconciliation = RunTypeReviewBridge.reconcile(reviews: reviewedRunTypes, workouts: workouts)
        snapshot = AnalyticsEngine.snapshot(for: workouts)
        refreshEvidenceQueueSummary()
        refreshDerivedAnalyses()
    }

    private func applyReviewedRunTypes() {
        guard !reviewedRunTypes.isEmpty else { return }
        workouts = RunTypeReviewBridge.applyConfidentMatches(reviews: reviewedRunTypes, to: workouts)
    }

    private func nextEvidenceQueueCandidateIDs(limit: Int) -> [String] {
        guard let modelContext else {
            return EvidenceEnrichmentQueue.nextPendingIDs(
                workouts: workouts,
                cachedEvidenceIDs: [],
                limit: limit
            )
        }
        return EvidenceEnrichmentQueue.nextPendingIDs(
            workouts: workouts,
            cachedEvidenceIDs: PersistenceService.fetchEvidenceIDs(context: modelContext),
            failedStates: PersistenceService.fetchEnrichmentStateByID(context: modelContext),
            limit: limit
        )
    }

    private func markEvidenceQueueAttempt(ids: [String], status: EvidenceEnrichmentStatus, message: String?) {
        guard let modelContext else { return }
        PersistenceService.markEnrichmentAttempt(ids: ids, status: status, message: message, context: modelContext)
    }

    private func refreshEvidenceQueueSummary() {
        guard let modelContext else {
            let items = EvidenceEnrichmentQueue.items(workouts: workouts, cachedEvidenceIDs: [])
            evidenceQueueSummary = EvidenceEnrichmentQueue.summary(for: items)
            return
        }
        let items = EvidenceEnrichmentQueue.items(
            workouts: workouts,
            cachedEvidenceIDs: PersistenceService.fetchEvidenceIDs(context: modelContext),
            failedStates: PersistenceService.fetchEnrichmentStateByID(context: modelContext)
        )
        evidenceQueueSummary = EvidenceEnrichmentQueue.summary(for: items)
    }

    private func refreshDerivedAnalyses() {
        guard let modelContext else {
            derivedAnalysesByWorkoutID = [:]
            return
        }
        let records = PersistenceService.fetchDerivedAnalysisSummaries(context: modelContext)
        if records.contains(where: { $0.calculationVersion != DerivedWorkoutAnalysis.currentVersion }) {
            PersistenceService.refreshDerivedAnalyses(context: modelContext)
        }
        derivedAnalysesByWorkoutID = Dictionary(
            uniqueKeysWithValues: PersistenceService.fetchDerivedAnalysisSummaries(context: modelContext).compactMap { record in
                guard let analysis = record.analysis else { return nil }
                return (record.workoutID, analysis)
            }
        )
    }

    private func updateHealthKitStatus(authorizationState: AuthorizationState, message: String) {
        healthKitStatus = HealthKitActionStatus(
            authorizationState: authorizationState,
            message: message,
            updatedAt: Date()
        )
        self.message = message
    }
}
