import Foundation
import Observation
import OSLog
import SwiftData

public struct EvidenceRefreshJobSummary: Identifiable, Equatable {
    public static let interruptedRelaunchMessage = "Paused after app relaunch before completion."

    public var id: String { jobID }
    public let jobID: String
    public let scopeKey: String
    public let status: EvidenceRefreshJobStatus
    public let totalCount: Int
    public let completedCount: Int
    public let failedCount: Int
    public let skippedCount: Int
    public let updatedAt: Date
    public let lastError: String?
    public let interruptionCount: Int
    public let lastInterruptedAt: Date?

    public var processedCount: Int {
        completedCount + failedCount + skippedCount
    }

    public var pendingCount: Int {
        max(totalCount - processedCount, 0)
    }

    public var progressText: String {
        "\(processedCount)/\(totalCount)"
    }

    public var canRecover: Bool {
        status == .paused || status == .failed || failedCount > 0 || pendingCount > 0
    }

    public var pausedAfterRelaunch: Bool {
        status == .paused && lastError == Self.interruptedRelaunchMessage
    }

    public var hasInterruptionHistory: Bool {
        interruptionCount > 0 || pausedAfterRelaunch
    }

    public var actionTitle: String {
        if status == .blocked { return "Health access needed" }
        return failedCount > 0 ? "Retry failed refresh items" : "Resume refresh"
    }

    public var statusTitle: String {
        switch status {
        case .queued:
            return "Queued"
        case .running:
            return "Refreshing"
        case .paused:
            return "Paused"
        case .completed:
            return "Completed"
        case .failed:
            return "Failed"
        case .blocked:
            return "Blocked"
        }
    }

    public var detailText: String {
        var parts = ["\(progressText) processed"]
        if failedCount > 0 { parts.append("\(failedCount) failed") }
        if skippedCount > 0 { parts.append("\(skippedCount) skipped") }
        if pendingCount > 0 { parts.append("\(pendingCount) pending") }
        return parts.joined(separator: " · ")
    }

    public var recoveryProofText: String {
        if pausedAfterRelaunch {
            return "Interrupted refresh was detected on app relaunch and preserved as a paused job."
        }
        if hasInterruptionHistory && status == .completed {
            return "Interrupted refresh later completed after foreground resume."
        }
        if status == .paused {
            return "Refresh is paused with cached evidence preserved."
        }
        if status == .failed {
            return "Refresh finished with failed items available for foreground retry."
        }
        if status == .blocked {
            return "Refresh is blocked until HealthKit is available or Apple Health access is granted."
        }
        if status == .completed {
            return "Refresh completed without requiring recovery."
        }
        return "Refresh recovery proof is pending for this job state."
    }

    init(job: PersistedEvidenceRefreshJob) {
        jobID = job.jobID
        scopeKey = job.scopeKey
        status = job.status
        totalCount = job.totalCount
        completedCount = job.completedCount
        failedCount = job.failedCount
        skippedCount = job.skippedCount
        updatedAt = job.updatedAt
        lastError = job.lastError
        interruptionCount = job.interruptionCount
        lastInterruptedAt = job.lastInterruptedAt
    }
}

public struct RefreshInterruptionProofSummary: Equatable, Sendable {
    public let statusTitle: String
    public let completedSteps: [String]
    public let pendingSteps: [String]

    public static func make(from summary: EvidenceRefreshJobSummary?) -> RefreshInterruptionProofSummary {
        guard let summary else {
            return RefreshInterruptionProofSummary(
                statusTitle: "Needs physical run",
                completedSteps: [],
                pendingSteps: [
                    "Start a month refresh on the physical iPhone.",
                    "Interrupt the app before the refresh finishes.",
                    "Reopen RunSignal and confirm the job is paused.",
                    "Resume the foreground refresh and export monthly diagnostics."
                ]
            )
        }

        var completed: [String] = []
        var pending: [String] = []

        if summary.hasInterruptionHistory {
            completed.append("Interrupted relaunch was recorded for this refresh job.")
        } else {
            pending.append("Interrupt and relaunch the physical iPhone app during this refresh.")
        }

        if summary.pausedAfterRelaunch || (summary.hasInterruptionHistory && summary.status != .running) {
            completed.append("The interrupted job is recoverable from persisted refresh state.")
        } else {
            pending.append("Reopen the app and verify the interrupted job becomes recoverable.")
        }

        if summary.status == .completed && summary.hasInterruptionHistory {
            completed.append("The interrupted job completed after foreground resume.")
        } else if summary.canRecover {
            pending.append("Tap Resume/Retry and let the foreground refresh finish.")
        } else {
            pending.append("Export monthly diagnostics after the recovery path is complete.")
        }

        let statusTitle = pending.isEmpty ? "Proof complete" : "Proof pending"
        return RefreshInterruptionProofSummary(statusTitle: statusTitle, completedSteps: completed, pendingSteps: pending)
    }

    public var detailText: String {
        if pendingSteps.isEmpty {
            return "Physical interruption drill evidence is complete for this refresh job."
        }
        return "\(completedSteps.count) complete, \(pendingSteps.count) pending."
    }
}

public struct HealthKitImportJobSummary: Equatable {
    public let status: HealthKitImportJobStatus
    public let importedCount: Int
    public let currentWindowStart: Date?
    public let currentWindowEnd: Date?
    public let lastError: String?

    public var statusTitle: String {
        switch status {
        case .queued:
            "Queued"
        case .running:
            "Importing"
        case .paused:
            "Paused"
        case .completed:
            "Completed"
        case .failed:
            "Failed"
        case .blocked:
            "Blocked"
        }
    }

    public var detailText: String {
        var parts = ["\(importedCount) imported"]
        if status == .running, let currentWindowStart, let currentWindowEnd, currentWindowStart != currentWindowEnd {
            parts.append("Checking \(RunFormatters.date.string(from: currentWindowStart)) - \(RunFormatters.date.string(from: currentWindowEnd))")
        }
        if let lastError, !lastError.isEmpty {
            parts.append(lastError)
        } else if status == .completed {
            parts.append("Up to date")
        }
        return parts.joined(separator: " · ")
    }

    init(job: PersistedHealthKitImportJob) {
        status = job.status
        importedCount = job.importedCount
        currentWindowStart = job.currentWindowStart
        currentWindowEnd = job.currentWindowEnd
        lastError = job.lastError
    }
}

public struct ManualWorkoutFieldUpdate: Equatable, Sendable {
    public var id: String
    public var runType: RunType?
    public var notes: String

    public init(id: String, runType: RunType?, notes: String) {
        self.id = id
        self.runType = runType
        self.notes = notes
    }
}

public struct DerivedAnalysisRefreshSummary: Equatable, Sendable {
    public let refreshedWorkoutIDs: [String]
    public let checkedAt: Date?

    public static let empty = DerivedAnalysisRefreshSummary(refreshedWorkoutIDs: [], checkedAt: nil)

    public var refreshedCount: Int {
        refreshedWorkoutIDs.count
    }

    public var hasRefreshedWorkouts: Bool {
        !refreshedWorkoutIDs.isEmpty
    }

    public var statusTitle: String {
        hasRefreshedWorkouts ? "Recomputed" : "Current"
    }

    public var detailText: String {
        if refreshedWorkoutIDs.isEmpty {
            return "No stale derived analytics found on the latest check."
        }
        return "\(refreshedWorkoutIDs.count) workout analysis row(s) refreshed from cached raw evidence."
    }
}

@MainActor
@Observable
public final class RunningAnalysisStore {
    private static let personalBestCacheKey = "RunSignal.PersonalBestEffortSummary.v1"
    private static let refreshLogger = Logger(
        subsystem: "com.adrielsolorzano.runninganalysis",
        category: "EvidenceRefresh"
    )

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
    public private(set) var personalBestEffortSummary = PersonalBestEffortEngine.summarize(workouts: [])
    public private(set) var derivedAnalysesByWorkoutID: [String: DerivedWorkoutAnalysis] = [:]
    public private(set) var parityForceReenrichResults: [String: ParityForceReenrichResult] = [:]
    public private(set) var monthlyEvidenceRefreshResults: [String: MonthlyEvidenceRefreshResult] = [:]
    public private(set) var evidenceRefreshJobs: [PersistedEvidenceRefreshJob] = []
    public private(set) var healthKitImportJobSummary: HealthKitImportJobSummary?
    public private(set) var derivedAnalysisRefreshSummary = DerivedAnalysisRefreshSummary.empty
    public private(set) var trainingPeriodSummaries: [CachedTrainingPeriodSummary] = []
    public private(set) var analyzingWorkoutIDs: Set<String> = []
    public private(set) var pendingManualWorkoutIDs: Set<String> = []
    private var manualWorkoutUpdateVersions: [String: Int] = [:]

    public var evidenceRefreshJobSummaries: [EvidenceRefreshJobSummary] {
        evidenceRefreshJobs.map(EvidenceRefreshJobSummary.init(job:))
    }

    private let healthKitService: any HealthKitServicing
    private let syncService: any HealthKitWorkoutSyncServicing
    private let syncDefaults: UserDefaults
    private let syncPersistenceSave: ([CanonicalWorkout], Set<String>, ModelContext) throws -> Void
    private let makeImportBudgetPolicy: () -> IngestionBudgetPolicy
    private var didBootstrap = false
    private var lastForegroundSyncAt: Date?
    private var isForegroundSyncInFlight = false
    private var healthKitSyncTask: Task<Void, Never>?
    private weak var modelContext: ModelContext?

    public init(
        healthKitService: any HealthKitServicing = HealthKitService(),
        syncService: (any HealthKitWorkoutSyncServicing)? = nil,
        syncDefaults: UserDefaults = .standard,
        makeImportBudgetPolicy: @escaping () -> IngestionBudgetPolicy = {
            IngestionBudgetPolicy(maxElapsedSeconds: 45)
        },
        syncPersistenceSave: @escaping ([CanonicalWorkout], Set<String>, ModelContext) throws -> Void = { workouts, ids, context in
            try PersistenceService.applySyncChangesAndSave(upserting: workouts, deletingIDs: ids, context: context)
        }
    ) {
        self.healthKitService = healthKitService
        self.syncService = syncService ?? HealthKitWorkoutSyncService(healthKitService: healthKitService)
        self.syncDefaults = syncDefaults
        self.syncPersistenceSave = syncPersistenceSave
        self.makeImportBudgetPolicy = makeImportBudgetPolicy
    }

    public var authorizationState: AuthorizationState {
        healthKitStatus.authorizationState
    }

    public var shouldSyncHealthKitOnForeground: Bool {
        guard HealthKitSyncStateStore.hasAnchor(defaults: syncDefaults) else { return false }
        return !usesSampleData || healthKitStatus.authorizationState == .authorized || healthKitStatus.authorizationState == .partial || syncState.lastSyncAt != nil
    }

    public func availableTrainingPeriodStarts(for period: TrainingAnalyticsPeriod) -> [Date] {
        guard period != .allTime else { return [] }
        let cached = trainingPeriodSummaries
            .filter { $0.period == period }
            .map(\.periodStart)
            .sorted(by: >)
        if !cached.isEmpty {
            return cached
        }
        return TrainingPeriodAnalyticsSummary.availablePeriodStarts(workouts: workouts, period: period)
    }

    public func trainingPeriodSummary(
        period: TrainingAnalyticsPeriod,
        periodStart: Date
    ) -> TrainingPeriodAnalyticsSummary {
        if let cached = trainingPeriodSummaries.first(where: { $0.period == period && $0.periodStart == periodStart }) {
            return cached.materializedSummary(workouts: workouts)
        }
        return TrainingPeriodAnalyticsSummary.make(workouts: workouts, period: period, periodStart: periodStart)
    }

    public func defaultTrainingPeriodStart(for period: TrainingAnalyticsPeriod) -> Date {
        if period == .allTime,
           let cached = trainingPeriodSummaries.first(where: { $0.period == .allTime }) {
            return cached.periodStart
        }
        return TrainingPeriodAnalyticsSummary.make(workouts: workouts, period: period).periodStart
    }

    public func bootstrap(modelContext: ModelContext) async {
        guard !didBootstrap else { return }
        didBootstrap = true
        self.modelContext = modelContext
        PersistenceService.pauseRunningEvidenceRefreshJobs(context: modelContext)

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
                    authorizationState: .partial,
                    message: "Loaded \(workouts.count) completed running workouts from the local HealthKit cache. Current read access is confirmed only by new HealthKit query results."
                )
            }
        }
        reviewedRunTypes = RunTypeReviewImportService.loadSavedReviews()
        syncState = HealthKitSyncState(lastSyncAt: HealthKitSyncStateStore.loadLastSyncAt(defaults: syncDefaults))
        loadPersistedTrainingPeriodSummaries()
        applyReviewedRunTypes()
        recompute(hydrateEvidence: false, refreshDerivedAnalyses: false, refreshTrainingPeriodSummaries: trainingPeriodSummaries.isEmpty)
        refreshEvidenceRefreshJobs()
        refreshHealthKitImportJobSummary()
    }

    public func refreshFromHealthKit() async {
        isLoading = true
        defer { isLoading = false }

        guard let modelContext else {
            await loadHealthKitRunsWithoutImportJob()
            return
        }

        let budget = makeImportBudgetPolicy()
        let authorizationState = await healthKitService.requestAuthorization()
        guard authorizationState == .authorized || authorizationState == .partial else {
            PersistenceService.finishHealthKitImportJob(status: .blocked, message: "The HealthKit authorization request could not be completed.", context: modelContext)
            refreshHealthKitImportJobSummary()
            updateHealthKitStatus(authorizationState: authorizationState, message: "The HealthKit authorization request could not be completed.")
            return
        }
        healthContext = await healthKitService.loadHealthContext()
        let earliestPermittedDate = await healthKitService.earliestPermittedSampleDate()
        let windows = healthKitImportWindows(
            resumingFrom: PersistenceService.fetchHealthKitImportJob(context: modelContext)?.currentWindowEnd,
            earliestPermittedDate: earliestPermittedDate
        )
        guard let firstWindow = windows.first else {
            PersistenceService.finishHealthKitImportJob(status: .completed, message: nil, context: modelContext)
            refreshHealthKitImportJobSummary()
            return
        }

        PersistenceService.startHealthKitImportJob(
            context: modelContext,
            windowStart: firstWindow.start,
            windowEnd: firstWindow.end
        )
        refreshHealthKitImportJobSummary()

        var importedTotal = 0
        var sawAuthorizedEmptyWindow = false
        for (index, window) in windows.enumerated() {
            let loadsDetailedEvidence = index == 0
            if let reason = budget.pauseReason(allowsDetailedEvidence: loadsDetailedEvidence) {
                PersistenceService.pauseHealthKitImportJob(reason: reason, context: modelContext)
                refreshHealthKitImportJobSummary()
                updateHealthKitStatus(authorizationState: authorizationState, message: reason.message)
                recompute()
                return
            }

            let result = await healthKitService.loadRunningWorkouts(
                startDate: window.start,
                endDate: window.end,
                detailedEvidenceLimit: index == 0 ? HealthKitService.defaultDetailedEvidenceLimit : 0,
                probeRoutesWhenEvidenceMissing: index == 0,
                requestsAuthorization: false,
                loadsHealthContext: false
            )
            let importMessage = result.workouts.isEmpty
                ? "Checking older HealthKit running history."
                : "Imported \(result.workouts.count) HealthKit running workouts."
            updateHealthKitStatus(
                authorizationState: result.authorizationState,
                message: importMessage
            )

            guard result.authorizationState == .authorized || result.authorizationState == .partial else {
                let status: HealthKitImportJobStatus = result.authorizationState == .unavailable ? .blocked : .failed
                PersistenceService.finishHealthKitImportJob(status: status, message: result.message, context: modelContext)
                refreshHealthKitImportJobSummary()
                if workouts.isEmpty {
                    usesSampleData = true
                    workouts = SampleData.workouts
                    healthContext = SampleData.healthContext
                    persistCurrent()
                }
                recompute()
                return
            }

            sawAuthorizedEmptyWindow = sawAuthorizedEmptyWindow || result.workouts.isEmpty
            importedTotal += result.workouts.count
            if !result.workouts.isEmpty {
                usesSampleData = false
                workouts = Self.mergeImportedWorkouts(incoming: result.workouts, current: workouts)
                deletePersistedSampleWorkoutsIfNeeded()
                applyReviewedRunTypes()
                persistCurrent()
            }
            PersistenceService.updateHealthKitImportProgress(
                imported: result.workouts.count,
                windowStart: window.start,
                windowEnd: window.start,
                context: modelContext
            )
            refreshHealthKitImportJobSummary()
            await Task.yield()
        }

        if importedTotal == 0 && sawAuthorizedEmptyWindow && workouts.allSatisfy(isSampleWorkout) {
            usesSampleData = false
            let previousSampleIDs = sampleWorkoutIDs(in: workouts)
            workouts = []
            if !previousSampleIDs.isEmpty {
                PersistenceService.deleteWorkouts(ids: previousSampleIDs, context: modelContext)
            }
            persistCurrent()
        }
        if workouts.isEmpty && usesSampleData {
            workouts = SampleData.workouts
            persistCurrent()
        }
        PersistenceService.finishHealthKitImportJob(status: .completed, message: nil, context: modelContext)
        refreshHealthKitImportJobSummary()
        updateHealthKitStatus(
            authorizationState: authorizationState,
            message: healthKitImportFinishedMessage(earliestPermittedDate: earliestPermittedDate)
        )
        await startHealthKitBackgroundDelivery()
        recompute()
    }

    private func loadHealthKitRunsWithoutImportJob() async {
        let result = await healthKitService.loadRunningWorkouts()
        healthContext = result.healthContext
        updateHealthKitStatus(
            authorizationState: result.authorizationState,
            message: result.message ?? "Loaded \(result.workouts.count) HealthKit running workouts."
        )

        guard !result.workouts.isEmpty else {
            if result.authorizationState == .authorized || result.authorizationState == .partial {
                usesSampleData = false
                workouts = []
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
        workouts = Self.mergeImportedWorkouts(incoming: result.workouts, current: workouts)
        deletePersistedSampleWorkoutsIfNeeded()
        applyReviewedRunTypes()
        persistCurrent()
        recompute()
    }

    public func refreshRunsListFromHealthKit() async {
        if shouldSyncHealthKitOnForeground {
            await syncHealthKitChanges()
        } else {
            await refreshFromHealthKit()
        }
    }

    public func syncHealthKitChanges(includePostSyncMaintenance: Bool = true) async {
        if let healthKitSyncTask {
            await healthKitSyncTask.value
            return
        }
        let task = Task { @MainActor [weak self] in
            guard let self else { return }
            await self.performHealthKitChangesSync(includePostSyncMaintenance: includePostSyncMaintenance)
        }
        healthKitSyncTask = task
        await task.value
        healthKitSyncTask = nil
    }

    private func performHealthKitChangesSync(includePostSyncMaintenance: Bool) async {
        isLoading = true
        defer { isLoading = false }

        let batches = await syncService.syncRunningWorkoutBatches(from: HealthKitSyncStateStore.loadAnchor(defaults: syncDefaults))
        guard !batches.isEmpty else {
            updateHealthKitStatus(
                authorizationState: .partial,
                message: "HealthKit sync found no new running workout changes."
            )
            if includePostSyncMaintenance {
                recompute()
            }
            return
        }

        var knownIDs = Set(workouts.map(\.id))
        var fetchedCount = 0
        var insertedCount = 0
        var updatedCount = 0
        var deletedCount = 0
        var lastMessage: String?
        var lastAuthorizationState: AuthorizationState = .partial

        for result in batches {
            healthContext = result.healthContext
            lastMessage = result.message ?? lastMessage
            lastAuthorizationState = result.authorizationState

            guard result.authorizationState == .authorized || result.authorizationState == .partial else {
                updateHealthKitStatus(
                    authorizationState: result.authorizationState,
                    message: result.message ?? "HealthKit sync finished."
                )
                if includePostSyncMaintenance {
                    recompute()
                }
                return
            }

            let deletedIDs = Set(result.deletedWorkoutIDs)
            let batchInsertedCount = result.fetchedWorkouts.filter { !knownIDs.contains($0.id) }.count
            let batchUpdatedCount = result.fetchedWorkouts.count - batchInsertedCount
            let previousWorkouts = workouts
            let previousUsesSampleData = usesSampleData

            if !result.fetchedWorkouts.isEmpty {
                usesSampleData = false
            }
            var merged = mergeSyncedWorkouts(changes: result.fetchedWorkouts, current: workouts)
            if !deletedIDs.isEmpty {
                merged.removeAll { deletedIDs.contains($0.id) }
            }
            workouts = removeSampleWorkoutsIfRealDataExists(merged)
            applyReviewedRunTypes()

            let fetchedIDs = Set(result.fetchedWorkouts.map(\.id))
            let workoutsToPersist = workouts.filter { fetchedIDs.contains($0.id) }
            var idsToDelete = deletedIDs
            if workouts.contains(where: { !isSampleWorkout($0) }) {
                idsToDelete.formUnion(SampleData.workouts.map(\.id))
            }

            do {
                if let modelContext {
                    try syncPersistenceSave(workoutsToPersist, idsToDelete, modelContext)
                } else if !workoutsToPersist.isEmpty || !idsToDelete.isEmpty {
                    throw CocoaError(.fileNoSuchFile)
                }
            } catch {
                workouts = previousWorkouts
                usesSampleData = previousUsesSampleData
                updateHealthKitStatus(
                    authorizationState: .error,
                    message: "HealthKit sync stopped before saving its anchor because local persistence failed."
                )
                if includePostSyncMaintenance {
                    recompute()
                }
                return
            }

            if let anchor = result.newAnchor {
                HealthKitSyncStateStore.saveAnchor(anchor, defaults: syncDefaults)
            }

            fetchedCount += result.fetchedWorkouts.count
            insertedCount += batchInsertedCount
            updatedCount += batchUpdatedCount
            deletedCount += result.deletedWorkoutIDs.count
            knownIDs.subtract(deletedIDs)
            knownIDs.formUnion(fetchedIDs)
        }

        let syncedAt = Date()
        HealthKitSyncStateStore.saveLastSyncAt(syncedAt, defaults: syncDefaults)
        refreshTrainingPeriodSummaryCache()
        updateHealthKitStatus(
            authorizationState: lastAuthorizationState,
            message: lastMessage ?? "HealthKit sync finished."
        )
        if includePostSyncMaintenance {
            refreshEvidenceQueueSummary()
        }

        syncState = HealthKitSyncState(
            lastSyncAt: syncedAt,
            lastFetchedCount: fetchedCount,
            lastInsertedCount: insertedCount,
            lastUpdatedCount: updatedCount,
            lastDeletedCount: deletedCount,
            lastEvidencePendingCount: evidenceQueueSummary.pendingCount
        )
        if includePostSyncMaintenance {
            recompute()
        }
    }

    public func syncHealthKitChangesOnForeground(now: Date = Date()) async {
        guard !isForegroundSyncInFlight else { return }
        guard didBootstrap, !isLoading, !isEnrichingAudit else { return }
        guard shouldSyncHealthKitOnForeground else { return }
        if let lastForegroundSyncAt, now.timeIntervalSince(lastForegroundSyncAt) < 300 {
            return
        }
        lastForegroundSyncAt = now
        isForegroundSyncInFlight = true
        defer { isForegroundSyncInFlight = false }
        await syncHealthKitChanges(includePostSyncMaintenance: false)
    }

    public func startHealthKitBackgroundDelivery() async {
        guard didBootstrap, !usesSampleData || authorizationState == .authorized || authorizationState == .partial else { return }
        let result = await syncService.startObservingRunningWorkoutChanges { [weak self] in
            guard let self else { return }
            await self.syncHealthKitChanges(includePostSyncMaintenance: false)
        }
        guard result.authorizationState == .authorized || result.authorizationState == .partial else {
            if result.authorizationState == .error {
                updateHealthKitStatus(
                    authorizationState: result.authorizationState,
                    message: result.message ?? "Could not register HealthKit background delivery."
                )
            }
            return
        }
        updateHealthKitStatus(
            authorizationState: result.authorizationState,
            message: result.message ?? "HealthKit background delivery is registered."
        )
    }

    public func enrichNextHealthKitAuditBatch(limit: Int = HealthKitService.defaultDetailedEvidenceLimit) async {
        let budget = makeImportBudgetPolicy()
        if let reason = budget.pauseReason(allowsDetailedEvidence: true) {
            message = reason.message
            return
        }
        let candidates = nextEvidenceQueueCandidateIDs(limit: limit)

        guard !candidates.isEmpty else {
            message = "No pending HealthKit evidence enrichment items are available."
            return
        }

        isEnrichingAudit = true
        analyzingWorkoutIDs.formUnion(candidates)
        defer {
            analyzingWorkoutIDs.subtract(candidates)
            isEnrichingAudit = false
        }

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

    public func loadFullAnalysisForWorkout(workoutID: String) async {
        guard workouts.contains(where: { $0.id == workoutID }) else {
            updateHealthKitStatus(
                authorizationState: .error,
                message: "Workout is not loaded in the current RunSignal store."
            )
            return
        }
        guard !isEnrichingAudit else {
            message = "HealthKit evidence refresh is already running."
            return
        }
        let budget = makeImportBudgetPolicy()
        if let reason = budget.pauseReason(allowsDetailedEvidence: true) {
            message = reason.message
            return
        }

        isEnrichingAudit = true
        analyzingWorkoutIDs.insert(workoutID)
        defer {
            analyzingWorkoutIDs.remove(workoutID)
            isEnrichingAudit = false
        }

        let result = await healthKitService.enrichRunningWorkouts(ids: [workoutID])
        updateHealthKitStatus(
            authorizationState: result.authorizationState,
            message: result.message ?? "Full analysis refresh finished."
        )

        let returnedWorkout = result.workouts.first { $0.id == workoutID }
        let canUseResult = result.authorizationState == .authorized || result.authorizationState == .partial
        if canUseResult, let returnedWorkout, returnedWorkout.evidence != nil {
            workouts = removeSampleWorkoutsIfRealDataExists(mergeSyncedWorkouts(changes: [returnedWorkout], current: workouts))
            deletePersistedSampleWorkoutsIfNeeded()
            applyReviewedRunTypes()
            persistCurrent()
            markEvidenceQueueAttempt(ids: [workoutID], status: .enriched, message: result.message)
        } else {
            markEvidenceQueueAttempt(
                ids: [workoutID],
                status: .failed,
                message: result.message ?? "HealthKit did not return detailed evidence for this workout."
            )
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
        let budget = makeImportBudgetPolicy()
        if let reason = budget.pauseReason(allowsDetailedEvidence: true) {
            message = reason.message
            return
        }

        isEnrichingAudit = true
        analyzingWorkoutIDs.insert(workoutID)
        defer {
            analyzingWorkoutIDs.remove(workoutID)
            isEnrichingAudit = false
        }

        let cacheWasPresent = workouts.first(where: { $0.id == workoutID })?.evidence != nil
            || (modelContext.map { PersistenceService.fetchEvidence(workoutID: workoutID, context: $0) } ?? nil) != nil
        let requestedAt = Date()

        let result = await healthKitService.enrichRunningWorkouts(ids: [workoutID])
        updateHealthKitStatus(
            authorizationState: result.authorizationState,
            message: result.message ?? "Parity force re-enrich finished."
        )

        let returnedWorkout = result.workouts.first { $0.id == workoutID }
        let canUseResult = result.authorizationState == .authorized || result.authorizationState == .partial
        if canUseResult, let returnedWorkout, returnedWorkout.evidence != nil {
            workouts = removeSampleWorkoutsIfRealDataExists(mergeSyncedWorkouts(changes: [returnedWorkout], current: workouts))
            deletePersistedSampleWorkoutsIfNeeded()
            applyReviewedRunTypes()
            persistCurrent()
            markEvidenceQueueAttempt(
                ids: [workoutID],
                status: .enriched,
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
            invalidatedCache: canUseResult && returnedWorkout?.evidence != nil,
            freshQueryReturnedWorkout: returnedWorkout != nil,
            authorizationState: result.authorizationState,
            message: result.message,
            evidenceCounts: returnedWorkout.map(ParityEvidenceCounts.init(workout:)),
            diagnosticsWarnings: returnedWorkout?.evidence?.diagnostics?.warnings ?? []
        )
        recompute()
    }

    public func refreshEvidenceForMonth(containing selectedMonth: Date, calendar: Calendar = .current) async {
        guard !isEnrichingAudit else {
            message = "HealthKit evidence refresh is already running."
            return
        }

        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedMonth) else {
            message = "Could not resolve the selected month for evidence refresh."
            return
        }
        let scopeKey = monthScopeKey(for: selectedMonth, calendar: calendar)

        let monthWorkouts = workouts
            .filter { monthInterval.contains($0.startDate) }
            .sorted { $0.startDate < $1.startDate }
        Self.refreshLogger.info("Monthly evidence refresh requested month=\(scopeKey, privacy: .public) workoutCount=\(monthWorkouts.count, privacy: .public)")
        guard !monthWorkouts.isEmpty else {
            message = "No loaded running workouts are available for the selected month."
            Self.refreshLogger.info("Monthly evidence refresh skipped month=\(scopeKey, privacy: .public) reason=no-loaded-workouts")
            return
        }

        isEnrichingAudit = true
        defer { isEnrichingAudit = false }
        let budget = makeImportBudgetPolicy()

        let job = modelContext.map {
            PersistenceService.startEvidenceRefreshJob(
                refreshKind: .monthlyEvidenceRefresh,
                scopeType: .month,
                scopeKey: scopeKey,
                workoutIDs: monthWorkouts.map(\.id),
                context: $0
            )
        }
        if let job {
            Self.refreshLogger.info("Monthly evidence refresh job started jobID=\(job.jobID, privacy: .public) month=\(scopeKey, privacy: .public) total=\(job.totalCount, privacy: .public)")
        } else {
            Self.refreshLogger.info("Monthly evidence refresh running without persisted job month=\(scopeKey, privacy: .public)")
        }
        refreshEvidenceRefreshJobs()
        let completedWorkoutIDs = Set(
            job.flatMap { job in
                modelContext.map {
                    PersistenceService.fetchEvidenceRefreshItems(jobID: job.jobID, context: $0)
                        .filter { $0.status == .success }
                        .map(\.workoutID)
                }
            } ?? []
        )

        for workout in monthWorkouts {
            if let reason = budget.pauseReason(allowsDetailedEvidence: true) {
                message = reason.message
                if let modelContext {
                    PersistenceService.pauseRunningEvidenceRefreshJobs(context: modelContext, message: reason.message)
                    refreshEvidenceRefreshJobs()
                }
                break
            }
            let requestedAt = Date()
            let cacheWasPresent = workout.evidence != nil
                || (modelContext.map { PersistenceService.fetchEvidence(workoutID: workout.id, context: $0) } ?? nil) != nil

            if completedWorkoutIDs.contains(workout.id) {
                let cachedWorkout = workouts.first { $0.id == workout.id }
                Self.refreshLogger.info("Monthly evidence refresh item skipped month=\(scopeKey, privacy: .public) workoutID=\(workout.id, privacy: .public) reason=already-succeeded cacheWasPresent=\(cacheWasPresent, privacy: .public)")
                monthlyEvidenceRefreshResults[workout.id] = MonthlyEvidenceRefreshResult(
                    workoutID: workout.id,
                    requestedAt: requestedAt,
                    completedAt: Date(),
                    refreshStatus: .skipped,
                    cacheWasPresent: cacheWasPresent,
                    invalidatedCache: false,
                    freshQueryReturnedWorkout: false,
                    authorizationState: healthKitStatus.authorizationState,
                    evidenceCounts: cachedWorkout.map(ParityEvidenceCounts.init(workout:)),
                    evidenceLoadedAt: cachedWorkout?.evidence?.loadedAt,
                    diagnosticsWarnings: cachedWorkout?.evidence?.diagnostics?.warnings ?? []
                )
                continue
            }

            if let modelContext, let job {
                PersistenceService.markEvidenceRefreshItemRunning(
                    jobID: job.jobID,
                    workoutID: workout.id,
                    context: modelContext
                )
                refreshEvidenceRefreshJobs()
            }

            Self.refreshLogger.info("Monthly evidence refresh item started month=\(scopeKey, privacy: .public) workoutID=\(workout.id, privacy: .public) cacheWasPresent=\(cacheWasPresent, privacy: .public)")
            let result = await healthKitService.enrichRunningWorkouts(ids: [workout.id])
            updateHealthKitStatus(
                authorizationState: result.authorizationState,
                message: result.message ?? "Monthly evidence refresh is running."
            )
            Self.refreshLogger.info("Monthly evidence refresh HealthKit returned month=\(scopeKey, privacy: .public) workoutID=\(workout.id, privacy: .public) authorization=\(result.authorizationState.rawValue, privacy: .public) returnedCount=\(result.workouts.count, privacy: .public)")

            let returnedWorkout = result.workouts.first { $0.id == workout.id }
            let canUseResult = result.authorizationState == .authorized || result.authorizationState == .partial
            if canUseResult, let returnedWorkout, returnedWorkout.evidence != nil {
                workouts = removeSampleWorkoutsIfRealDataExists(mergeSyncedWorkouts(changes: [returnedWorkout], current: workouts))
                deletePersistedSampleWorkoutsIfNeeded()
                applyReviewedRunTypes()
                persistCurrent()
                markEvidenceQueueAttempt(
                    ids: [workout.id],
                    status: .enriched,
                    message: result.message
                )
            } else {
                markEvidenceQueueAttempt(ids: [workout.id], status: .failed, message: result.message)
            }

            let refreshedWorkout = workouts.first { $0.id == workout.id }
            let refreshStatus: MonthlyEvidenceRefreshStatus
            if result.authorizationState == .unavailable {
                refreshStatus = .unsupported
            } else if canUseResult, returnedWorkout?.evidence != nil {
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
                invalidatedCache: refreshStatus == .success,
                freshQueryReturnedWorkout: returnedWorkout != nil,
                authorizationState: result.authorizationState,
                evidenceCounts: refreshedWorkout.map(ParityEvidenceCounts.init(workout:)),
                evidenceLoadedAt: refreshedWorkout?.evidence?.loadedAt,
                diagnosticsWarnings: refreshedWorkout?.evidence?.diagnostics?.warnings ?? []
            )
            Self.refreshLogger.info("Monthly evidence refresh item finished month=\(scopeKey, privacy: .public) workoutID=\(workout.id, privacy: .public) status=\(refreshStatus.rawValue, privacy: .public) oldEvidencePreserved=\(cacheWasPresent && refreshStatus != .success, privacy: .public) newEvidenceCommitted=\(refreshStatus == .success, privacy: .public)")
            if let modelContext, let job {
                PersistenceService.finishEvidenceRefreshItem(
                    jobID: job.jobID,
                    workoutID: workout.id,
                    status: evidenceRefreshItemStatus(for: refreshStatus),
                    message: evidenceRefreshItemMessage(for: refreshStatus, resultMessage: result.message),
                    oldEvidencePreserved: cacheWasPresent && refreshStatus != .success,
                    newEvidenceCommitted: refreshStatus == .success,
                    context: modelContext
                )
                refreshEvidenceRefreshJobs()
            }
            await Task.yield()
        }

        Self.refreshLogger.info("Monthly evidence refresh recompute started month=\(scopeKey, privacy: .public)")
        recompute()
        Self.refreshLogger.info("Monthly evidence refresh recompute finished month=\(scopeKey, privacy: .public)")

        if let modelContext, let job {
            PersistenceService.finishEvidenceRefreshJob(jobID: job.jobID, context: modelContext)
            refreshEvidenceRefreshJobs()
            if let summary = evidenceRefreshSummary(containing: selectedMonth, calendar: calendar) {
                Self.refreshLogger.info("Monthly evidence refresh job finished jobID=\(summary.jobID, privacy: .public) month=\(scopeKey, privacy: .public) status=\(summary.status.rawValue, privacy: .public) completed=\(summary.completedCount, privacy: .public) failed=\(summary.failedCount, privacy: .public) skipped=\(summary.skippedCount, privacy: .public)")
            }
        }

        message = "Monthly evidence refresh finished for \(monthWorkouts.count) running workouts."
    }

    public func resumeEvidenceRefreshForMonth(containing selectedMonth: Date, calendar: Calendar = .current) async {
        await refreshEvidenceForMonth(containing: selectedMonth, calendar: calendar)
    }

    public func update(workoutID: String, manualRunType: RunType?, notes: String) {
        guard let index = workouts.firstIndex(where: { $0.id == workoutID }) else { return }
        workouts[index].manualRunType = manualRunType
        workouts[index].notes = notes
        refreshTrainingPeriodSummaryCache()
        pendingManualWorkoutIDs.insert(workoutID)
        let version = (manualWorkoutUpdateVersions[workoutID] ?? 0) + 1
        manualWorkoutUpdateVersions[workoutID] = version

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 150_000_000)
            guard manualWorkoutUpdateVersions[workoutID] == version,
                  let currentIndex = workouts.firstIndex(where: { $0.id == workoutID }) else { return }

            let currentWorkout = workouts[currentIndex]
            if let modelContext {
                PersistenceService.updateManualFields(
                    id: workoutID,
                    runType: currentWorkout.manualRunType,
                    notes: currentWorkout.notes,
                    context: modelContext
                )
            }
            recompute(hydrateEvidence: false, refreshDerivedAnalyses: false)

            if manualWorkoutUpdateVersions[workoutID] == version {
                pendingManualWorkoutIDs.remove(workoutID)
            }
        }
    }

    public func updateManualFields(_ updates: [ManualWorkoutFieldUpdate]) {
        guard !updates.isEmpty else { return }
        let updatesByID = Dictionary(uniqueKeysWithValues: updates.map { ($0.id, $0) })
        var changed = false

        for index in workouts.indices {
            guard let update = updatesByID[workouts[index].id] else { continue }
            workouts[index].manualRunType = update.runType
            workouts[index].notes = update.notes
            changed = true
        }

        guard changed else { return }
        if let modelContext {
            PersistenceService.updateManualFields(updates: updates, context: modelContext)
        }
        recompute(hydrateEvidence: false, refreshDerivedAnalyses: false)
    }

    public func hydrateCachedEvidenceIfAvailable(for workoutID: String) {
        guard let index = workouts.firstIndex(where: { $0.id == workoutID }),
              workouts[index].evidence == nil,
              let modelContext,
              let evidence = PersistenceService.fetchEvidence(workoutID: workoutID, context: modelContext)
        else { return }

        workouts[index].evidence = evidence
        workouts[index].routePointCount = evidence.route.count
        workouts[index].seriesSampleCount = evidence.seriesSampleCount
        workouts[index].routeAvailable = workouts[index].routeAvailable || !evidence.route.isEmpty
        workouts[index].seriesAvailable = workouts[index].seriesAvailable || evidence.seriesSampleCount > 0

        if let derivedAnalysis = PersistenceService.fetchDerivedAnalysis(workoutID: workoutID, context: modelContext) {
            derivedAnalysesByWorkoutID[workoutID] = derivedAnalysis
        }
        refreshEvidenceQueueSummary()
    }

    public func evidenceQueueItem(for workoutID: String) -> EvidenceEnrichmentQueueItem? {
        guard let modelContext else {
            return EvidenceEnrichmentQueue.items(workouts: workouts, cachedEvidenceIDs: [])
                .first { $0.workoutID == workoutID }
        }
        return EvidenceEnrichmentQueue.items(
            workouts: workouts,
            cachedEvidenceIDs: PersistenceService.fetchEvidenceIDs(workoutIDs: [workoutID], context: modelContext),
            failedStates: PersistenceService.fetchEnrichmentStateByID(workoutIDs: [workoutID], context: modelContext)
        )
        .first { $0.workoutID == workoutID }
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
            monthlyRefreshResults: monthlyEvidenceRefreshResults,
            derivedRefreshSummary: derivedAnalysisRefreshSummary,
            evidenceRefreshSummary: evidenceRefreshSummary(containing: selectedMonth)
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
            monthlyRefreshResults: monthlyEvidenceRefreshResults,
            derivedRefreshSummary: derivedAnalysisRefreshSummary,
            evidenceRefreshSummary: evidenceRefreshSummary(containing: selectedMonth)
        )
    }

    public func evidenceRefreshSummary(containing selectedMonth: Date, calendar: Calendar = .current) -> EvidenceRefreshJobSummary? {
        let scopeKey = monthScopeKey(for: selectedMonth, calendar: calendar)
        return evidenceRefreshJobSummaries.first { $0.scopeKey == scopeKey }
    }

    static func mergeImportedWorkouts(incoming: [CanonicalWorkout], current: [CanonicalWorkout]) -> [CanonicalWorkout] {
        let currentByID = Dictionary(uniqueKeysWithValues: current.map { ($0.id, $0) })
        var byID = currentByID
        for workout in incoming {
            var merged = workout
            if let existing = currentByID[workout.id] {
                merged.manualRunType = existing.manualRunType
                merged.importedRunType = existing.importedRunType
                merged.importedReviewID = existing.importedReviewID
                merged.notes = existing.notes
            }
            byID[workout.id] = merged
        }
        let merged = Array(byID.values)
        let sampleIDs = Set(SampleData.workouts.map(\.id))
        let withoutSamples = merged.contains(where: { !sampleIDs.contains($0.id) })
            ? merged.filter { !sampleIDs.contains($0.id) }
            : merged
        return DuplicateDetector.markDuplicates(withoutSamples.sorted { $0.startDate > $1.startDate })
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

    private func healthKitImportWindows(
        resumingFrom resumeEnd: Date?,
        earliestPermittedDate: Date? = nil
    ) -> [(start: Date, end: Date)] {
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        let productLowerBound = calendar.date(from: DateComponents(year: 2000, month: 1, day: 1)) ?? Date(timeIntervalSince1970: 0)
        let lowerBound = max(productLowerBound, earliestPermittedDate ?? productLowerBound)
        var end = resumeEnd ?? now
        var windows: [(start: Date, end: Date)] = []
        while end > lowerBound {
            let start = max(calendar.date(byAdding: .year, value: -1, to: end) ?? lowerBound, lowerBound)
            windows.append((start: start, end: end))
            end = start
        }
        return windows
    }

    private func healthKitImportFinishedMessage(earliestPermittedDate: Date?) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let productLowerBound = calendar.date(from: DateComponents(year: 2000, month: 1, day: 1)) ?? Date(timeIntervalSince1970: 0)
        guard let earliestPermittedDate, earliestPermittedDate > productLowerBound else {
            return "HealthKit import finished. Read access is reflected by the workouts HealthKit returned."
        }
        return "HealthKit import finished for the history HealthKit permits from \(earliestPermittedDate.formatted(date: .abbreviated, time: .omitted))."
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

    private func recompute(
        hydrateEvidence shouldHydrateEvidence: Bool = true,
        refreshDerivedAnalyses shouldRefreshDerivedAnalyses: Bool = true,
        refreshTrainingPeriodSummaries shouldRefreshTrainingPeriodSummaries: Bool = true
    ) {
        if shouldHydrateEvidence {
            hydrateCachedEvidence()
        }
        workouts = DuplicateDetector.markDuplicates(workouts)
        if shouldRefreshTrainingPeriodSummaries {
            refreshTrainingPeriodSummaryCache()
        } else if trainingPeriodSummaries.isEmpty {
            loadPersistedTrainingPeriodSummaries()
        }
        runTypeReconciliation = RunTypeReviewBridge.reconcile(reviews: reviewedRunTypes, workouts: workouts)
        snapshot = AnalyticsEngine.snapshot(for: workouts, healthContext: healthContext)
        if !shouldRefreshDerivedAnalyses {
            loadPersistedDerivedAnalyses()
        }
        refreshPersonalBestEffortsFromInMemoryEvidence()
        refreshEvidenceQueueSummary()
        if shouldRefreshDerivedAnalyses {
            derivedAnalysisRefreshSummary = refreshDerivedAnalyses()
        } else {
            derivedAnalysisRefreshSummary = .empty
        }
    }

    private func hydrateCachedEvidence() {
        guard let modelContext else { return }
        let missingIDs = workouts.filter { $0.evidence == nil }.map(\.id)
        let evidenceByID = PersistenceService.fetchEvidenceByWorkoutID(workoutIDs: missingIDs, context: modelContext)
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

    private func refreshPersonalBestEffortsFromInMemoryEvidence() {
        let currentIDs = Set(workouts.map(\.id))
        let cached: PersonalBestEffortSummary? = loadPersonalBestEffortCache().flatMap { summary in
            let records = summary.allTime.filter { currentIDs.contains($0.workoutID) }
            return records.isEmpty ? nil : PersonalBestEffortSummary(allTime: records)
        }
        let hasDetailedEvidence = workouts.contains { $0.evidence != nil }
        guard hasDetailedEvidence || cached == nil else {
            personalBestEffortSummary = cached ?? PersonalBestEffortSummary(allTime: [])
            return
        }

        let computed = PersonalBestEffortEngine.summarize(workouts: workouts)
        let derived = PersonalBestEffortSummary(
            allTime: derivedAnalysesByWorkoutID.values.flatMap { $0.personalBestEffortRecords ?? [] }
        )
        personalBestEffortSummary = mergePersonalBestEfforts(
            cached: mergePersonalBestEfforts(cached: cached, computed: derived),
            computed: computed
        )
        savePersonalBestEffortCache(personalBestEffortSummary)
    }

    private func mergePersonalBestEfforts(
        cached: PersonalBestEffortSummary?,
        computed: PersonalBestEffortSummary
    ) -> PersonalBestEffortSummary {
        let candidates = (cached?.allTime ?? []) + computed.allTime
        let grouped = Dictionary(grouping: candidates, by: \.bucket)
        let selected = PersonalBestEffortBucket.allCases.compactMap { bucket -> PersonalBestEffortRecord? in
            guard let records = grouped[bucket], !records.isEmpty else { return nil }
            return records.sorted { lhs, rhs in
                let lhsRank = personalBestConfidenceRank(lhs.confidence)
                let rhsRank = personalBestConfidenceRank(rhs.confidence)
                if lhsRank != rhsRank { return lhsRank > rhsRank }
                if bucket == .longestRun { return lhs.distanceMeters > rhs.distanceMeters }
                return (lhs.durationSeconds ?? .greatestFiniteMagnitude) < (rhs.durationSeconds ?? .greatestFiniteMagnitude)
            }.first
        }
        return PersonalBestEffortSummary(allTime: selected)
    }

    private func personalBestConfidenceRank(_ confidence: PersonalBestEffortConfidence) -> Int {
        switch confidence {
        case .exact, .exactTotal: 2
        case .estimated: 1
        case .unavailable: 0
        }
    }

    private func loadPersonalBestEffortCache() -> PersonalBestEffortSummary? {
        guard let data = syncDefaults.data(forKey: Self.personalBestCacheKey) else { return nil }
        return try? JSONDecoder().decode(PersonalBestEffortSummary.self, from: data)
    }

    private func savePersonalBestEffortCache(_ summary: PersonalBestEffortSummary) {
        guard let data = try? JSONEncoder().encode(summary) else { return }
        syncDefaults.set(data, forKey: Self.personalBestCacheKey)
    }

    private func loadPersistedTrainingPeriodSummaries() {
        guard let modelContext else {
            trainingPeriodSummaries = CachedTrainingPeriodSummary.makeAll(workouts: workouts)
            return
        }
        trainingPeriodSummaries = PersistenceService.fetchTrainingPeriodSummaries(context: modelContext)
    }

    private func refreshTrainingPeriodSummaryCache() {
        guard let modelContext else {
            trainingPeriodSummaries = CachedTrainingPeriodSummary.makeAll(workouts: workouts)
            return
        }
        trainingPeriodSummaries = PersistenceService.refreshTrainingPeriodSummaries(workouts: workouts, context: modelContext)
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
            cachedEvidenceIDs: PersistenceService.fetchEvidenceIDs(workoutIDs: workouts.map(\.id), context: modelContext),
            failedStates: PersistenceService.fetchEnrichmentStateByID(workoutIDs: workouts.map(\.id), context: modelContext),
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
            cachedEvidenceIDs: PersistenceService.fetchEvidenceIDs(workoutIDs: workouts.map(\.id), context: modelContext),
            failedStates: PersistenceService.fetchEnrichmentStateByID(workoutIDs: workouts.map(\.id), context: modelContext)
        )
        evidenceQueueSummary = EvidenceEnrichmentQueue.summary(for: items)
    }

    private func refreshDerivedAnalyses() -> DerivedAnalysisRefreshSummary {
        guard let modelContext else {
            derivedAnalysesByWorkoutID = [:]
            return .empty
        }
        let records = PersistenceService.fetchDerivedAnalysisSummaries(context: modelContext)
        var refreshedWorkoutIDs: [String] = []
        if records.contains(where: { $0.calculationVersion != DerivedWorkoutAnalysis.currentVersion }) {
            let outdatedIDs = PersistenceService.outdatedDerivedAnalysisVersionIDs(context: modelContext)
            let staleIDs = PersistenceService.staleDerivedAnalysisIDs(context: modelContext)
            refreshedWorkoutIDs = Array(Set(outdatedIDs + staleIDs)).sorted()
            PersistenceService.refreshDerivedAnalyses(workoutIDs: refreshedWorkoutIDs, context: modelContext)
        } else {
            refreshedWorkoutIDs = PersistenceService.staleDerivedAnalysisIDs(context: modelContext)
            PersistenceService.refreshDerivedAnalyses(workoutIDs: refreshedWorkoutIDs, context: modelContext)
        }
        derivedAnalysesByWorkoutID = Dictionary(
            uniqueKeysWithValues: PersistenceService.fetchDerivedAnalysisSummaries(context: modelContext).compactMap { record in
                guard let analysis = record.analysis else { return nil }
                return (record.workoutID, analysis)
            }
        )
        return DerivedAnalysisRefreshSummary(
            refreshedWorkoutIDs: refreshedWorkoutIDs,
            checkedAt: Date()
        )
    }

    private func loadPersistedDerivedAnalyses() {
        guard let modelContext else {
            derivedAnalysesByWorkoutID = [:]
            return
        }
        derivedAnalysesByWorkoutID = Dictionary(
            uniqueKeysWithValues: PersistenceService.fetchDerivedAnalysisSummaries(context: modelContext).compactMap { record in
                guard let analysis = record.analysis else { return nil }
                return (record.workoutID, analysis)
            }
        )
    }

    private func refreshEvidenceRefreshJobs() {
        guard let modelContext else {
            evidenceRefreshJobs = []
            return
        }
        evidenceRefreshJobs = PersistenceService.fetchEvidenceRefreshJobs(context: modelContext)
    }

    private func refreshHealthKitImportJobSummary() {
        guard let modelContext else {
            healthKitImportJobSummary = nil
            return
        }
        healthKitImportJobSummary = PersistenceService.fetchHealthKitImportJob(context: modelContext).map(HealthKitImportJobSummary.init(job:))
    }

    private func monthScopeKey(for date: Date, calendar: Calendar) -> String {
        let components = calendar.dateComponents([.year, .month], from: date)
        let year = components.year ?? 0
        let month = components.month ?? 0
        return String(format: "%04d-%02d", year, month)
    }

    private func evidenceRefreshItemStatus(for refreshStatus: MonthlyEvidenceRefreshStatus) -> EvidenceRefreshJobItemStatus {
        switch refreshStatus {
        case .success:
            return .success
        case .skipped, .unsupported:
            return .skipped
        case .failed:
            return .failed
        }
    }

    private func evidenceRefreshItemMessage(
        for refreshStatus: MonthlyEvidenceRefreshStatus,
        resultMessage: String?
    ) -> String? {
        switch refreshStatus {
        case .success:
            return nil
        case .unsupported:
            return resultMessage ?? "HealthKit is unavailable for monthly evidence refresh."
        case .skipped:
            return resultMessage ?? "Monthly evidence refresh item was skipped."
        case .failed:
            return resultMessage ?? "HealthKit did not return usable evidence during month refresh."
        }
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
