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
    public private(set) var derivedAnalysisRefreshSummary = DerivedAnalysisRefreshSummary.empty

    public var evidenceRefreshJobSummaries: [EvidenceRefreshJobSummary] {
        evidenceRefreshJobs.map(EvidenceRefreshJobSummary.init(job:))
    }

    private let healthKitService: any HealthKitServicing
    private let syncService: any HealthKitWorkoutSyncServicing
    private var didBootstrap = false
    private var lastForegroundSyncAt: Date?
    private weak var modelContext: ModelContext?

    public init(
        healthKitService: any HealthKitServicing = HealthKitService(),
        syncService: (any HealthKitWorkoutSyncServicing)? = nil
    ) {
        self.healthKitService = healthKitService
        self.syncService = syncService ?? HealthKitWorkoutSyncService(healthKitService: healthKitService)
    }

    public var authorizationState: AuthorizationState {
        healthKitStatus.authorizationState
    }

    public var shouldSyncHealthKitOnForeground: Bool {
        !usesSampleData || healthKitStatus.authorizationState == .authorized || healthKitStatus.authorizationState == .partial || syncState.lastSyncAt != nil
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
                    authorizationState: .authorized,
                    message: "HealthKit Loaded from local cache: \(workouts.count) completed running workouts."
                )
            }
        }
        reviewedRunTypes = RunTypeReviewImportService.loadSavedReviews()
        syncState = HealthKitSyncState(lastSyncAt: HealthKitSyncStateStore.loadLastSyncAt())
        applyReviewedRunTypes()
        recompute(refreshDerivedAnalyses: false)
        refreshEvidenceRefreshJobs()
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

    public func syncHealthKitChangesOnForeground(now: Date = Date()) async {
        guard didBootstrap, !isLoading, !isEnrichingAudit else { return }
        guard shouldSyncHealthKitOnForeground else { return }
        if let lastForegroundSyncAt, now.timeIntervalSince(lastForegroundSyncAt) < 300 {
            return
        }
        lastForegroundSyncAt = now
        await syncHealthKitChanges()
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
            Self.refreshLogger.info("Monthly evidence refresh recompute started month=\(scopeKey, privacy: .public) workoutID=\(workout.id, privacy: .public)")
            recompute()
            Self.refreshLogger.info("Monthly evidence refresh recompute finished month=\(scopeKey, privacy: .public) workoutID=\(workout.id, privacy: .public)")
        }

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

    private func recompute(refreshDerivedAnalyses shouldRefreshDerivedAnalyses: Bool = true) {
        hydrateCachedEvidence()
        workouts = DuplicateDetector.markDuplicates(workouts)
        runTypeReconciliation = RunTypeReviewBridge.reconcile(reviews: reviewedRunTypes, workouts: workouts)
        snapshot = AnalyticsEngine.snapshot(for: workouts, healthContext: healthContext)
        personalBestEffortSummary = PersonalBestEffortEngine.summarize(workouts: workouts)
        refreshEvidenceQueueSummary()
        if shouldRefreshDerivedAnalyses {
            derivedAnalysisRefreshSummary = refreshDerivedAnalyses()
        } else {
            loadPersistedDerivedAnalyses()
            derivedAnalysisRefreshSummary = .empty
        }
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
            PersistenceService.refreshDerivedAnalyses(context: modelContext)
        } else {
            refreshedWorkoutIDs = PersistenceService.staleDerivedAnalysisIDs(context: modelContext)
            PersistenceService.refreshStaleDerivedAnalyses(context: modelContext)
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
