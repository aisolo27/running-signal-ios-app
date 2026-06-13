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
    public private(set) var parityForceReenrichResults: [String: ParityForceReenrichResult] = [:]
    public private(set) var monthlyEvidenceRefreshResults: [String: MonthlyEvidenceRefreshResult] = [:]

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
            usesSampleData = true
            updateHealthKitStatus(
                authorizationState: .notDetermined,
                message: "Using Sample Data. Load HealthKit to replace these sample workouts."
            )
            PersistenceService.upsert(workouts, context: modelContext)
        } else if needsSampleEvidenceBackfill(persisted) {
            workouts = SampleData.workouts
            healthContext = SampleData.healthContext
            usesSampleData = true
            updateHealthKitStatus(
                authorizationState: .notDetermined,
                message: "Using Sample Data. Load HealthKit to replace these sample workouts."
            )
            PersistenceService.upsert(workouts, context: modelContext)
        } else {
            workouts = removeSampleWorkoutsIfRealDataExists(persisted)
            usesSampleData = workouts.allSatisfy(isSampleWorkout)
            if workouts.count != persisted.count {
                PersistenceService.deleteWorkouts(ids: sampleWorkoutIDs(in: persisted), context: modelContext)
            }
            workouts = DuplicateDetector.markDuplicates(workouts)
            if usesSampleData {
                updateHealthKitStatus(
                    authorizationState: .notDetermined,
                    message: "Using Sample Data. Load HealthKit to replace these sample workouts."
                )
            } else {
                updateHealthKitStatus(
                    authorizationState: .authorized,
                    message: "HealthKit Loaded from local cache: \(workouts.count) completed running workouts."
                )
            }
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
            if result.authorizationState == .authorized || result.authorizationState == .partial {
                usesSampleData = false
                let previousSampleIDs = sampleWorkoutIDs(in: workouts)
                workouts = []
                if let modelContext, !previousSampleIDs.isEmpty {
                    PersistenceService.deleteWorkouts(ids: previousSampleIDs, context: modelContext)
                }
                persistCurrent()
            } else {
                usesSampleData = true
                healthContext = SampleData.healthContext
            }
            if workouts.isEmpty && usesSampleData {
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

    public func forceReenrichEvidenceForParity(workoutID: String) async {
        guard workouts.contains(where: { $0.id == workoutID }) else {
            parityForceReenrichResults[workoutID] = ParityForceReenrichResult(
                workoutID: workoutID,
                requestedAt: Date(),
                completedAt: Date(),
                cacheWasPresent: false,
                invalidatedCache: false,
                freshQueryReturnedWorkout: false,
                authorizationState: .error,
                message: "Workout is not loaded in the current RunSignal store."
            )
            return
        }

        isEnrichingAudit = true
        defer { isEnrichingAudit = false }

        let cacheWasPresent = workouts.first(where: { $0.id == workoutID })?.evidence != nil
            || (modelContext.map { PersistenceService.fetchEvidence(workoutID: workoutID, context: $0) } ?? nil) != nil
        let requestedAt = Date()
        if let modelContext {
            PersistenceService.deleteEvidence(ids: [workoutID], context: modelContext)
        }
        workouts = workouts.map { workout in
            guard workout.id == workoutID else { return workout }
            var invalidated = workout
            invalidated.evidence = nil
            invalidated.routePointCount = 0
            invalidated.seriesSampleCount = 0
            invalidated.heartRateSampleCount = 0
            invalidated.runningSpeedSampleCount = 0
            invalidated.distanceSampleCount = 0
            invalidated.activeEnergySampleCount = 0
            invalidated.runningPowerSampleCount = 0
            invalidated.cadenceSampleCount = 0
            invalidated.stepCountSampleCount = 0
            invalidated.strideLengthSampleCount = 0
            invalidated.verticalOscillationSampleCount = 0
            invalidated.groundContactTimeSampleCount = 0
            invalidated.intervalCount = 0
            invalidated.intervalLabelsSummary = nil
            return invalidated
        }
        recompute()

        let result = await healthKitService.enrichRunningWorkouts(ids: [workoutID])
        updateHealthKitStatus(
            authorizationState: result.authorizationState,
            message: result.message ?? "Parity force re-enrich finished."
        )

        let returnedWorkout = result.workouts.first { $0.id == workoutID }
        if result.authorizationState == .authorized || result.authorizationState == .partial, !result.workouts.isEmpty {
            workouts = removeSampleWorkoutsIfRealDataExists(mergeSyncedWorkouts(changes: result.workouts, current: workouts))
            deletePersistedSampleWorkoutsIfNeeded()
            applyReviewedRunTypes()
            persistCurrent()
            markEvidenceQueueAttempt(
                ids: [workoutID],
                status: returnedWorkout == nil ? .failed : .enriched,
                message: result.message
            )
        } else {
            markEvidenceQueueAttempt(ids: [workoutID], status: .failed, message: result.message)
        }

        parityForceReenrichResults[workoutID] = ParityForceReenrichResult(
            workoutID: workoutID,
            requestedAt: requestedAt,
            completedAt: Date(),
            cacheWasPresent: cacheWasPresent,
            invalidatedCache: true,
            freshQueryReturnedWorkout: returnedWorkout != nil,
            authorizationState: result.authorizationState,
            message: result.message,
            evidenceCounts: returnedWorkout.map(ParityEvidenceCounts.init(workout:)),
            diagnosticsWarnings: returnedWorkout?.evidence?.diagnostics?.warnings ?? []
        )
        recompute()
    }

    public func refreshEvidenceForMonth(containing selectedMonth: Date, calendar: Calendar = .current) async {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedMonth) else {
            message = "Could not resolve the selected month for evidence refresh."
            return
        }

        let monthWorkouts = workouts
            .filter { monthInterval.contains($0.startDate) }
            .sorted { $0.startDate < $1.startDate }
        guard !monthWorkouts.isEmpty else {
            message = "No loaded running workouts are available for the selected month."
            return
        }

        isEnrichingAudit = true
        defer { isEnrichingAudit = false }

        for workout in monthWorkouts {
            let requestedAt = Date()
            let cacheWasPresent = workout.evidence != nil
                || (modelContext.map { PersistenceService.fetchEvidence(workoutID: workout.id, context: $0) } ?? nil) != nil

            if let modelContext {
                PersistenceService.deleteEvidence(ids: [workout.id], context: modelContext)
            }
            invalidateLoadedEvidence(workoutID: workout.id)

            let result = await healthKitService.enrichRunningWorkouts(ids: [workout.id])
            updateHealthKitStatus(
                authorizationState: result.authorizationState,
                message: result.message ?? "Monthly evidence refresh is running."
            )

            let returnedWorkout = result.workouts.first { $0.id == workout.id }
            let canUseResult = result.authorizationState == .authorized || result.authorizationState == .partial
            if canUseResult, !result.workouts.isEmpty {
                workouts = removeSampleWorkoutsIfRealDataExists(mergeSyncedWorkouts(changes: result.workouts, current: workouts))
                deletePersistedSampleWorkoutsIfNeeded()
                applyReviewedRunTypes()
                persistCurrent()
                markEvidenceQueueAttempt(
                    ids: [workout.id],
                    status: returnedWorkout == nil ? .failed : .enriched,
                    message: result.message
                )
            } else {
                markEvidenceQueueAttempt(ids: [workout.id], status: .failed, message: result.message)
            }

            let refreshedWorkout = workouts.first { $0.id == workout.id }
            let refreshStatus: MonthlyEvidenceRefreshStatus
            if result.authorizationState == .unavailable {
                refreshStatus = .unsupported
            } else if returnedWorkout != nil {
                refreshStatus = .success
            } else {
                refreshStatus = .failed
            }
            monthlyEvidenceRefreshResults[workout.id] = MonthlyEvidenceRefreshResult(
                workoutID: workout.id,
                requestedAt: requestedAt,
                completedAt: Date(),
                refreshStatus: refreshStatus,
                refreshError: refreshStatus == .success ? nil : (result.message ?? "HealthKit did not return this workout during month refresh."),
                cacheWasPresent: cacheWasPresent,
                invalidatedCache: true,
                freshQueryReturnedWorkout: returnedWorkout != nil,
                authorizationState: result.authorizationState,
                evidenceCounts: refreshedWorkout.map(ParityEvidenceCounts.init(workout:)),
                evidenceLoadedAt: refreshedWorkout?.evidence?.loadedAt,
                diagnosticsWarnings: refreshedWorkout?.evidence?.diagnostics?.warnings ?? []
            )
            recompute()
        }

        message = "Monthly evidence refresh finished for \(monthWorkouts.count) running workouts."
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

    public var goldenValidationResults: [GoldenAppleFitnessWorkoutResult] {
        GoldenAppleFitnessValidation.results(workouts: workouts)
    }

    public var goldenValidationFixtureJSON: String {
        GoldenAppleFitnessValidation.fixtureTemplate(workouts: workouts)
    }

    public var goldenValidationFixtureCSV: String {
        GoldenAppleFitnessValidation.csvTemplate(workouts: workouts)
    }

    public var goldenValidationChecklistMarkdown: String {
        GoldenAppleFitnessValidation.checklistMarkdown(workouts: workouts)
    }

    public var healthKitPermissionReviewMarkdown: String {
        HealthKitPermissionCatalog.markdown()
    }

    public func parityPacketJSON(for workout: CanonicalWorkout) -> String {
        DiagnosticsExport.parityPacketJSON(
            workout: workout,
            forceReenrichResult: parityForceReenrichResults[workout.id]
        )
    }

    public func monthlyDiagnosticsJSON(containing workout: CanonicalWorkout) -> String {
        monthlyDiagnosticsJSON(selectedMonth: workout.startDate)
    }

    public func monthlyDiagnosticsJSON(selectedMonth: Date) -> String {
        DiagnosticsExport.monthlyDiagnosticsJSON(
            workouts: workouts,
            selectedMonth: selectedMonth,
            forceReenrichResults: parityForceReenrichResults,
            monthlyRefreshResults: monthlyEvidenceRefreshResults
        )
    }

    public func monthlyDiagnosticsMarkdown(containing workout: CanonicalWorkout) -> String {
        monthlyDiagnosticsMarkdown(selectedMonth: workout.startDate)
    }

    public func monthlyDiagnosticsMarkdown(selectedMonth: Date) -> String {
        DiagnosticsExport.monthlyDiagnosticsMarkdown(
            workouts: workouts,
            selectedMonth: selectedMonth,
            forceReenrichResults: parityForceReenrichResults,
            monthlyRefreshResults: monthlyEvidenceRefreshResults
        )
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

    private func invalidateLoadedEvidence(workoutID: String) {
        workouts = workouts.map { workout in
            guard workout.id == workoutID else { return workout }
            var invalidated = workout
            invalidated.evidence = nil
            invalidated.routePointCount = 0
            invalidated.seriesSampleCount = 0
            invalidated.heartRateSampleCount = 0
            invalidated.runningSpeedSampleCount = 0
            invalidated.distanceSampleCount = 0
            invalidated.activeEnergySampleCount = 0
            invalidated.runningPowerSampleCount = 0
            invalidated.cadenceSampleCount = 0
            invalidated.stepCountSampleCount = 0
            invalidated.strideLengthSampleCount = 0
            invalidated.verticalOscillationSampleCount = 0
            invalidated.groundContactTimeSampleCount = 0
            invalidated.intervalCount = 0
            invalidated.intervalLabelsSummary = nil
            return invalidated
        }
        recompute()
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
        hydrateCachedEvidence()
        workouts = DuplicateDetector.markDuplicates(workouts)
        runTypeReconciliation = RunTypeReviewBridge.reconcile(reviews: reviewedRunTypes, workouts: workouts)
        snapshot = AnalyticsEngine.snapshot(for: workouts)
        refreshEvidenceQueueSummary()
        refreshDerivedAnalyses()
    }

    private func hydrateCachedEvidence() {
        guard let modelContext else { return }
        let evidenceByID = PersistenceService.fetchEvidenceByWorkoutID(context: modelContext)
        guard !evidenceByID.isEmpty else { return }
        workouts = workouts.map { workout in
            guard workout.evidence == nil, let evidence = evidenceByID[workout.id] else {
                return workout
            }
            var hydrated = workout
            hydrated.evidence = evidence
            hydrated.routePointCount = evidence.route.count
            hydrated.seriesSampleCount = evidence.seriesSampleCount
            hydrated.routeAvailable = hydrated.routeAvailable || !evidence.route.isEmpty
            hydrated.seriesAvailable = hydrated.seriesAvailable || evidence.seriesSampleCount > 0
            return hydrated
        }
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
