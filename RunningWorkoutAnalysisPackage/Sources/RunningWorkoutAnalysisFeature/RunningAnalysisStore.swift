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
            "History Queued"
        case .running:
            "Loading History"
        case .paused:
            "History Paused"
        case .completed:
            "History Current"
        case .failed:
            "History Load Failed"
        case .blocked:
            "History Load Blocked"
        }
    }

    public var detailText: String {
        var parts = ["\(importedCount) \(importedCount == 1 ? "run" : "runs") loaded"]
        if status == .running, let currentWindowStart {
            parts.append("Checking history before \(RunFormatters.date.string(from: currentWindowStart))")
        }
        if let lastError, !lastError.isEmpty {
            parts.append(lastError)
        } else if status == .completed {
            parts.append("History is up to date")
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
    private static let personalBestCacheKey = "RunSignal.PersonalBestEffortSummary.v2"
    private static let foregroundSyncMinimumInterval: TimeInterval = 15 * 60
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
    public private(set) var usesSampleData = false
    public private(set) var healthContext = HealthContext()
    public private(set) var heartRateZoneProfiles: [HeartRateZoneProfile] = []
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
    public private(set) var analysisProgressByWorkoutID: [String: WorkoutAnalysisProgress] = [:]
    public private(set) var pendingManualWorkoutIDs: Set<String> = []
    public private(set) var isCheckingBestEffortHistory = false
    public private(set) var bestEffortAnalysisPauseMessage: String?
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
    private var automaticEvidenceTask: Task<Void, Never>?
    private var prioritizedEvidenceWorkoutIDs: Set<String> = []
    private var automaticEvidenceAttemptedWorkoutIDs: Set<String> = []
    private var workoutPlanMetadataHydrationIDs: Set<String> = []
    private var personalBestEffortRefreshGeneration = 0
    private var bestEffortHistoryCheckpoint = BestEffortHistoryCheckpoint()
    private var cachedEvidenceWorkoutIDs: Set<String> = []
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
        heartRateZoneProfiles = HeartRateZoneProfilePersistence.load(defaults: syncDefaults)
        bestEffortHistoryCheckpoint = BestEffortHistoryCheckpointStore.load(defaults: syncDefaults)
    }

    public var authorizationState: AuthorizationState {
        healthKitStatus.authorizationState
    }

    public var healthKitConnectionPresentation: HealthKitConnectionPresentation {
        HealthKitConnectionPresentation.make(
            authorizationState: authorizationState,
            importStatus: healthKitImportJobSummary?.status,
            hasWorkouts: !V1WorkoutFilters.completedRuns(from: workouts).isEmpty,
            isLoading: isLoading
        )
    }

    public var bestEffortCoverageSummary: BestEffortCoverageSummary {
        let eligibleIDs = bestEffortEligibleWorkoutIDs
        let checkedIDs = bestEffortHistoryCheckpoint.checkedWorkoutIDs
            .union(cachedEvidenceWorkoutIDs)
            .intersection(eligibleIDs)
        let failedIDs = bestEffortHistoryCheckpoint.failedWorkoutIDs
            .subtracting(checkedIDs)
            .intersection(eligibleIDs)
        let importStatus: HealthKitImportJobStatus?
        if let status = healthKitImportJobSummary?.status {
            importStatus = status
        } else {
            importStatus = workouts.isEmpty ? nil : .completed
        }
        return BestEffortCoverageSummary(
            checkedRunCount: checkedIDs.count,
            pendingRunCount: eligibleIDs.subtracting(checkedIDs).subtracting(failedIDs).count,
            failedRunCount: failedIDs.count,
            historyImportStatus: importStatus,
            isCheckingDetailedData: isCheckingBestEffortHistory,
            pauseMessage: bestEffortAnalysisPauseMessage
        )
    }

    public var shouldSyncHealthKitOnForeground: Bool {
        guard HealthKitSyncStateStore.hasAnchor(defaults: syncDefaults) else { return false }
        return !workouts.isEmpty
            || healthKitStatus.authorizationState == .authorized
            || healthKitStatus.authorizationState == .partial
            || syncState.lastSyncAt != nil
    }

    public func automaticHeartRateZoneInputs(now: Date = Date()) -> AutomaticHeartRateZoneInputs? {
        if usesSampleData {
            return AutomaticHeartRateZoneInputs(
                restingHeartRate: 48,
                maximumHeartRate: 194,
                maximumHeartRateDate: SampleData.workouts.max { ($0.maxHeartRate ?? 0) < ($1.maxHeartRate ?? 0) }?.startDate,
                lookbackMonths: HeartRateZoneProfileFactory.automaticLookbackMonths
            )
        }
        return HeartRateZoneProfileFactory.automaticInputs(
            workouts: workouts,
            healthContext: healthContext,
            now: now
        )
    }

    public func maximumHeartRateLookback(now: Date = Date()) -> MaximumHeartRateLookbackResult? {
        if usesSampleData {
            return MaximumHeartRateLookbackResult(
                maximumHeartRate: 194,
                maximumHeartRateDate: SampleData.workouts.max { ($0.maxHeartRate ?? 0) < ($1.maxHeartRate ?? 0) }?.startDate,
                lookbackMonths: HeartRateZoneProfileFactory.automaticLookbackMonths
            )
        }
        return HeartRateZoneProfileFactory.maximumHeartRateInput(workouts: workouts, now: now)
    }

    public func heartRateZoneProfile(for workoutDate: Date) -> HeartRateZoneProfile? {
        HeartRateZoneProfileTimeline.profile(for: workoutDate, profiles: heartRateZoneProfiles)
            ?? (usesSampleData ? SampleData.heartRateZoneProfile : nil)
    }

    public var currentHeartRateZoneProfile: HeartRateZoneProfile? {
        heartRateZoneProfiles.max { $0.effectiveDate < $1.effectiveDate }
            ?? (usesSampleData ? SampleData.heartRateZoneProfile : nil)
    }

    @discardableResult
    public func saveHeartRateZoneProfile(
        method: HeartRateZoneMethod,
        manualLowerBounds: [Int] = [],
        maximumHeartRateOverride: Int? = nil,
        now: Date = Date()
    ) -> Bool {
        if heartRateZoneProfiles.isEmpty {
            refreshAutomaticHeartRateZoneProfileIfNeeded(now: now)
        }

        let effectiveDate = heartRateZoneProfiles.isEmpty ? Date.distantPast : now
        let baseInputs = automaticHeartRateZoneInputs(now: now)
        let selectedInputs: AutomaticHeartRateZoneInputs?
        if let maximumHeartRateOverride {
            if let restingValue = healthContext.restingHeartRate {
                let resting = Int(restingValue.rounded())
                if maximumHeartRateOverride >= 80,
                   maximumHeartRateOverride <= 230,
                   maximumHeartRateOverride >= resting + 20 {
                    selectedInputs = AutomaticHeartRateZoneInputs(
                        restingHeartRate: resting,
                        maximumHeartRate: maximumHeartRateOverride,
                        maximumHeartRateDate: nil,
                        lookbackMonths: HeartRateZoneProfileFactory.automaticLookbackMonths
                    )
                } else {
                    selectedInputs = nil
                }
            } else {
                selectedInputs = nil
            }
        } else {
            selectedInputs = baseInputs
        }
        let selectedMaximumInput: MaximumHeartRateLookbackResult?
        if let maximumHeartRateOverride {
            selectedMaximumInput = maximumHeartRateOverride >= 80 && maximumHeartRateOverride <= 230
                ? MaximumHeartRateLookbackResult(
                    maximumHeartRate: maximumHeartRateOverride,
                    maximumHeartRateDate: nil,
                    lookbackMonths: HeartRateZoneProfileFactory.automaticLookbackMonths
                )
                : nil
        } else {
            selectedMaximumInput = maximumHeartRateLookback(now: now)
        }
        let profile: HeartRateZoneProfile?
        switch method {
        case .automaticHeartRateReserve:
            profile = selectedInputs.map {
                HeartRateZoneProfileFactory.automaticProfile(
                    inputs: $0,
                    effectiveDate: effectiveDate,
                    createdAt: now,
                    isHistoricalBackfill: heartRateZoneProfiles.isEmpty,
                    maximumHeartRateIsUserOverride: maximumHeartRateOverride != nil
                )
            }
        case .percentMaximum:
            profile = selectedMaximumInput.map {
                HeartRateZoneProfileFactory.percentMaximumProfile(
                    maximumInput: $0,
                    effectiveDate: effectiveDate,
                    createdAt: now,
                    maximumHeartRateIsUserOverride: maximumHeartRateOverride != nil
                )
            }
        case .manual:
            profile = HeartRateZoneProfileFactory.manualProfile(
                zoneLowerBounds: manualLowerBounds,
                effectiveDate: effectiveDate,
                createdAt: now
            )
        }
        guard let profile else { return false }

        if let currentHeartRateZoneProfile,
           currentHeartRateZoneProfile.method == profile.method,
           currentHeartRateZoneProfile.restingHeartRate == profile.restingHeartRate,
           currentHeartRateZoneProfile.maximumHeartRate == profile.maximumHeartRate,
           currentHeartRateZoneProfile.maximumHeartRateIsUserOverride == profile.maximumHeartRateIsUserOverride,
           currentHeartRateZoneProfile.zoneLowerBounds == profile.zoneLowerBounds {
            return true
        }
        heartRateZoneProfiles.append(profile)
        heartRateZoneProfiles.sort { $0.effectiveDate < $1.effectiveDate }
        HeartRateZoneProfilePersistence.save(heartRateZoneProfiles, defaults: syncDefaults)
        return true
    }

    @discardableResult
    public func resetHeartRateZoneProfileHistoryToCurrent(now: Date = Date()) -> Bool {
        guard let currentHeartRateZoneProfile else { return false }
        let replacement = HeartRateZoneProfile(
            effectiveDate: .distantPast,
            createdAt: now,
            method: currentHeartRateZoneProfile.method,
            restingHeartRate: currentHeartRateZoneProfile.restingHeartRate,
            maximumHeartRate: currentHeartRateZoneProfile.maximumHeartRate,
            maximumHeartRateIsUserOverride: currentHeartRateZoneProfile.maximumHeartRateIsUserOverride,
            zoneLowerBounds: currentHeartRateZoneProfile.zoneLowerBounds,
            lookbackMonths: currentHeartRateZoneProfile.lookbackMonths,
            sourceDetail: "History reset from \(currentHeartRateZoneProfile.sourceDetail)",
            isHistoricalBackfill: true
        )
        heartRateZoneProfiles = [replacement]
        HeartRateZoneProfilePersistence.save(heartRateZoneProfiles, defaults: syncDefaults)
        return true
    }

    public func refreshAutomaticHeartRateZoneProfileIfNeeded(now: Date = Date()) {
        guard let inputs = automaticHeartRateZoneInputs(now: now) else { return }
        if heartRateZoneProfiles.isEmpty {
            heartRateZoneProfiles = [
                HeartRateZoneProfileFactory.automaticProfile(
                    inputs: inputs,
                    effectiveDate: Date.distantPast,
                    createdAt: now,
                    isHistoricalBackfill: true
                )
            ]
            HeartRateZoneProfilePersistence.save(heartRateZoneProfiles, defaults: syncDefaults)
            return
        }
        guard let current = currentHeartRateZoneProfile,
              current.method == .automaticHeartRateReserve else { return }
        let calendar = Calendar.current
        guard !calendar.isDate(current.createdAt, equalTo: now, toGranularity: .month) else { return }
        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) ?? now
        let refreshedInputs = current.maximumHeartRateIsUserOverride
            ? AutomaticHeartRateZoneInputs(
                restingHeartRate: inputs.restingHeartRate,
                maximumHeartRate: current.maximumHeartRate ?? inputs.maximumHeartRate,
                maximumHeartRateDate: nil,
                lookbackMonths: inputs.lookbackMonths
            )
            : inputs
        let profile = HeartRateZoneProfileFactory.automaticProfile(
            inputs: refreshedInputs,
            effectiveDate: monthStart,
            createdAt: now,
            maximumHeartRateIsUserOverride: current.maximumHeartRateIsUserOverride
        )
        heartRateZoneProfiles.append(profile)
        heartRateZoneProfiles.sort { $0.effectiveDate < $1.effectiveDate }
        HeartRateZoneProfilePersistence.save(heartRateZoneProfiles, defaults: syncDefaults)
    }

    private func automaticHeartRateZoneRefreshIsDue(now: Date = Date()) -> Bool {
        guard let current = currentHeartRateZoneProfile else { return true }
        guard current.method == .automaticHeartRateReserve else { return false }
        return !Calendar.current.isDate(current.createdAt, equalTo: now, toGranularity: .month)
    }

    nonisolated public static func automaticEvidenceCandidateIDs(
        workouts: [CanonicalWorkout],
        cachedEvidenceIDs: Set<String>,
        now: Date = Date(),
        dayWindow: Int = 30,
        limit: Int = 20
    ) -> [String] {
        automaticEvidenceWindow(
            workouts: workouts,
            now: now,
            dayWindow: dayWindow,
            limit: limit
        )
        .filter { workout in
            workout.evidence == nil && !cachedEvidenceIDs.contains(workout.id)
        }
        .map(\.id)
    }

    nonisolated private static func automaticEvidenceWindow(
        workouts: [CanonicalWorkout],
        now: Date,
        dayWindow: Int = 30,
        limit: Int = 20
    ) -> [CanonicalWorkout] {
        let calendar = Calendar(identifier: .gregorian)
        let cutoff = calendar.date(byAdding: .day, value: -dayWindow, to: now) ?? now.addingTimeInterval(-Double(dayWindow) * 86_400)
        return workouts
            .filter { workout in
                workout.startDate >= cutoff
                    && workout.startDate <= now.addingTimeInterval(300)
                    && !workout.isDuplicate
                    && workout.dataSourceLabel.contains("HealthKit")
            }
            .sorted { $0.startDate > $1.startDate }
            .prefix(limit)
            .map { $0 }
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

    public func runTypeSuggestion(for workoutID: String) -> RunTypeSuggestion? {
        guard let workout = workouts.first(where: { $0.id == workoutID }) else { return nil }
        return RunClassifier.suggestion(
            for: workout,
            history: workouts,
            maxHeartRate: healthContext.maxHeartRate
        )
    }

    public func bootstrap(modelContext: ModelContext) async {
        guard !didBootstrap else { return }
        didBootstrap = true
        self.modelContext = modelContext
        PersistenceService.pauseRunningEvidenceRefreshJobs(context: modelContext)

        let persisted = PersistenceService.fetchWorkouts(context: modelContext)
        let persistedRealWorkouts = persisted.filter { !isSampleWorkout($0) }
        if persistedRealWorkouts.isEmpty {
            workouts = []
            healthContext = HealthContext()
            usesSampleData = false
            updateHealthKitStatus(
                authorizationState: .notDetermined,
                message: "Connect Apple Health to load your completed running workouts."
            )
            let legacySampleIDs = sampleWorkoutIDs(in: persisted)
            if !legacySampleIDs.isEmpty {
                PersistenceService.deleteWorkouts(ids: legacySampleIDs, context: modelContext)
            }
        } else {
            workouts = persistedRealWorkouts
            usesSampleData = false
            if workouts.count != persisted.count {
                PersistenceService.deleteWorkouts(ids: sampleWorkoutIDs(in: persisted), context: modelContext)
            }
            workouts = DuplicateDetector.markDuplicates(workouts)
            updateHealthKitStatus(
                authorizationState: .partial,
                message: "Loaded \(workouts.count) completed running workouts from the local Apple Health cache. Current read access is confirmed only by new Apple Health query results."
            )
        }
        reviewedRunTypes = RunTypeReviewImportService.loadSavedReviews()
        syncState = HealthKitSyncState(lastSyncAt: HealthKitSyncStateStore.loadLastSyncAt(defaults: syncDefaults))
        loadPersistedTrainingPeriodSummaries()
        applyReviewedRunTypes()
        recompute(hydrateEvidence: false, refreshDerivedAnalyses: false, refreshTrainingPeriodSummaries: trainingPeriodSummaries.isEmpty)
        await refreshPersonalBestEffortsFromInMemoryEvidence()
        refreshEvidenceRefreshJobs()
        refreshHealthKitImportJobSummary()
        bestEffortHistoryCheckpoint.retainWorkouts(ids: bestEffortEligibleWorkoutIDs)
    }

    @discardableResult
    public func requestHealthKitAccess() async -> Bool {
        if authorizationState == .authorized || authorizationState == .partial {
            return true
        }

        isLoading = true
        updateHealthKitStatus(
            authorizationState: .requesting,
            message: "Waiting for your Apple Health choices."
        )
        let state = await healthKitService.requestAuthorization()
        isLoading = false

        guard state == .authorized || state == .partial else {
            updateHealthKitStatus(
                authorizationState: state,
                message: state == .unavailable
                    ? "Apple Health is unavailable on this device."
                    : "Apple Health access was not completed. You can try again when you are ready."
            )
            return false
        }

        updateHealthKitStatus(
            authorizationState: state,
            message: "Apple Health is connected. Finding your completed runs."
        )
        return true
    }

    public func connectAndImportFromHealthKit() async {
        guard await requestHealthKitAccess() else { return }
        await refreshFromHealthKit()
        await analyzeBestEffortHistory()
    }

    public func analyzeBestEffortHistory(retryFailures: Bool = false) async {
        if let automaticEvidenceTask {
            await automaticEvidenceTask.value
        }
        guard !isCheckingBestEffortHistory else { return }
        guard authorizationState == .authorized || authorizationState == .partial else { return }
        guard !bestEffortEligibleWorkoutIDs.isEmpty else { return }

        if retryFailures {
            bestEffortHistoryCheckpoint.failedWorkoutIDs.removeAll()
            BestEffortHistoryCheckpointStore.save(bestEffortHistoryCheckpoint, defaults: syncDefaults)
        }
        guard !bestEffortPendingWorkoutIDs.isEmpty else { return }

        isCheckingBestEffortHistory = true
        bestEffortAnalysisPauseMessage = nil
        defer { isCheckingBestEffortHistory = false }
        await runBestEffortHistoryAnalysis()
    }

    private func runBestEffortHistoryAnalysis() async {
        var budget = makeImportBudgetPolicy()

        while !Task.isCancelled {
            if let reason = budget.pauseReason(allowsDetailedEvidence: true) {
                if reason == .elapsedBudgetExceeded {
                    await Task.yield()
                    let continuedBudget = makeImportBudgetPolicy()
                    if continuedBudget.pauseReason(allowsDetailedEvidence: true) == nil {
                        budget = continuedBudget
                        continue
                    }
                    bestEffortAnalysisPauseMessage = "Paused briefly to keep RunSignal responsive."
                } else {
                    bestEffortAnalysisPauseMessage = reason.message
                }
                return
            }

            let requestedIDs = Array(bestEffortPendingWorkoutIDs.prefix(4))
            guard !requestedIDs.isEmpty else {
                bestEffortAnalysisPauseMessage = nil
                return
            }

            let result = await healthKitService.loadBestEffortEvidence(ids: requestedIDs)
            guard result.authorizationState == .authorized || result.authorizationState == .partial else {
                bestEffortHistoryCheckpoint.failedWorkoutIDs.formUnion(requestedIDs)
                BestEffortHistoryCheckpointStore.save(bestEffortHistoryCheckpoint, defaults: syncDefaults)
                bestEffortAnalysisPauseMessage = result.message ?? "Apple Health could not check these runs."
                return
            }

            let returnedIDs = Set(result.workouts.map(\.id))
            let workoutSnapshot = result.workouts
            let exactRecords = await Task.detached(priority: .utility) {
                workoutSnapshot
                    .flatMap(PersonalBestEffortEngine.records(for:))
                    .filter { $0.confidence == .exact || $0.confidence == .exactTotal }
            }.value
            personalBestEffortSummary = mergePersonalBestEfforts(
                cached: personalBestEffortSummary,
                computed: PersonalBestEffortSummary(allTime: exactRecords)
            )
            savePersonalBestEffortCache(personalBestEffortSummary)

            bestEffortHistoryCheckpoint.checkedWorkoutIDs.formUnion(returnedIDs)
            bestEffortHistoryCheckpoint.failedWorkoutIDs.subtract(returnedIDs)
            bestEffortHistoryCheckpoint.failedWorkoutIDs.formUnion(Set(requestedIDs).subtracting(returnedIDs))
            BestEffortHistoryCheckpointStore.save(bestEffortHistoryCheckpoint, defaults: syncDefaults)
            await Task.yield()
        }
    }

    private var bestEffortEligibleWorkoutIDs: Set<String> {
        Set(V1WorkoutFilters.completedRuns(from: workouts)
            .filter { !isSampleWorkout($0) }
            .map(\.id))
    }

    private var bestEffortPendingWorkoutIDs: [String] {
        let resolvedIDs = bestEffortHistoryCheckpoint.checkedWorkoutIDs
            .union(bestEffortHistoryCheckpoint.failedWorkoutIDs)
            .union(cachedEvidenceWorkoutIDs)
        return V1WorkoutFilters.completedRuns(from: workouts)
            .filter { !isSampleWorkout($0) && !resolvedIDs.contains($0.id) }
            .sorted { lhs, rhs in
                let lhsDistance = lhs.distanceMeters ?? 0
                let rhsDistance = rhs.distanceMeters ?? 0
                if lhsDistance != rhsDistance { return lhsDistance > rhsDistance }
                return lhs.startDate > rhs.startDate
            }
            .map(\.id)
    }

    public func refreshFromHealthKit() async {
        let accessIsReady = authorizationState == .authorized || authorizationState == .partial
        if !accessIsReady {
            guard await requestHealthKitAccess() else { return }
        }
        await importHealthKitHistory(authorizationState: authorizationState)
    }

    private func importHealthKitHistory(authorizationState: AuthorizationState) async {
        isLoading = true
        defer {
            isLoading = false
            startAutomaticEvidenceEnrichment()
        }

        guard let modelContext else {
            await loadHealthKitRunsWithoutImportJob()
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

        var budget = makeImportBudgetPolicy()
        var importedTotal = 0
        var sawAuthorizedEmptyWindow = false
        for (index, window) in windows.enumerated() {
            let loadsDetailedEvidence = index == 0
            if let reason = budget.pauseReason(allowsDetailedEvidence: loadsDetailedEvidence) {
                if reason == .elapsedBudgetExceeded {
                    updateHealthKitStatus(
                        authorizationState: authorizationState,
                        message: "Continuing your run-history import while keeping RunSignal responsive."
                    )
                    await Task.yield()
                    let continuedBudget = makeImportBudgetPolicy()
                    if continuedBudget.pauseReason(allowsDetailedEvidence: loadsDetailedEvidence) == nil {
                        budget = continuedBudget
                    } else {
                        PersistenceService.pauseHealthKitImportJob(reason: reason, context: modelContext)
                        refreshHealthKitImportJobSummary()
                        updateHealthKitStatus(
                            authorizationState: authorizationState,
                            message: "History import paused. Tap Continue History Import when you are ready."
                        )
                        recompute()
                        await refreshPersonalBestEffortsFromInMemoryEvidence()
                        return
                    }
                } else {
                    PersistenceService.pauseHealthKitImportJob(reason: reason, context: modelContext)
                    refreshHealthKitImportJobSummary()
                    updateHealthKitStatus(authorizationState: authorizationState, message: reason.message)
                    recompute()
                    await refreshPersonalBestEffortsFromInMemoryEvidence()
                    return
                }
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
                recompute()
                await refreshPersonalBestEffortsFromInMemoryEvidence()
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
        PersistenceService.finishHealthKitImportJob(status: .completed, message: nil, context: modelContext)
        refreshHealthKitImportJobSummary()
        updateHealthKitStatus(
            authorizationState: authorizationState,
            message: healthKitImportFinishedMessage(earliestPermittedDate: earliestPermittedDate)
        )
        await startHealthKitBackgroundDelivery()
        refreshAutomaticHeartRateZoneProfileIfNeeded()
        recompute()
        await refreshPersonalBestEffortsFromInMemoryEvidence()
    }

    private func loadHealthKitRunsWithoutImportJob() async {
        let result = await healthKitService.loadRunningWorkouts()
        healthContext = result.healthContext
        updateHealthKitStatus(
            authorizationState: result.authorizationState,
            message: result.message ?? "Loaded \(result.workouts.count) Apple Health running workouts."
        )

        guard !result.workouts.isEmpty else {
            if result.authorizationState == .authorized || result.authorizationState == .partial {
                usesSampleData = false
                workouts = []
                persistCurrent()
            }
            recompute()
            await refreshPersonalBestEffortsFromInMemoryEvidence()
            return
        }

        usesSampleData = false
        workouts = Self.mergeImportedWorkouts(incoming: result.workouts, current: workouts)
        deletePersistedSampleWorkoutsIfNeeded()
        applyReviewedRunTypes()
        persistCurrent()
        refreshAutomaticHeartRateZoneProfileIfNeeded()
        recompute()
        await refreshPersonalBestEffortsFromInMemoryEvidence()
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
        if includePostSyncMaintenance {
            isLoading = true
        }
        defer {
            if includePostSyncMaintenance {
                isLoading = false
            }
            startAutomaticEvidenceEnrichment()
        }

        let batches = await syncService.syncRunningWorkoutBatches(from: HealthKitSyncStateStore.loadAnchor(defaults: syncDefaults))
        guard !batches.isEmpty else {
            if !usesSampleData && automaticHeartRateZoneRefreshIsDue() {
                healthContext = await healthKitService.loadHealthContext()
                refreshAutomaticHeartRateZoneProfileIfNeeded()
            }
            updateHealthKitStatus(
                authorizationState: .partial,
                message: "HealthKit sync found no new running workout changes."
            )
            if includePostSyncMaintenance {
                recompute()
                await refreshPersonalBestEffortsFromInMemoryEvidence()
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
                    await refreshPersonalBestEffortsFromInMemoryEvidence()
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
                    await refreshPersonalBestEffortsFromInMemoryEvidence()
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

        refreshAutomaticHeartRateZoneProfileIfNeeded()
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
            await refreshPersonalBestEffortsFromInMemoryEvidence()
        }
    }

    public func syncHealthKitChangesOnForeground(now: Date = Date()) async {
        guard !isForegroundSyncInFlight else { return }
        guard didBootstrap, !isLoading, !isEnrichingAudit else { return }
        guard shouldSyncHealthKitOnForeground else { return }
        let throttleReference = lastForegroundSyncAt ?? syncState.lastSyncAt
        if let throttleReference,
           now.timeIntervalSince(throttleReference) < Self.foregroundSyncMinimumInterval {
            return
        }
        lastForegroundSyncAt = now
        isForegroundSyncInFlight = true
        defer { isForegroundSyncInFlight = false }
        await syncHealthKitChanges(includePostSyncMaintenance: false)
    }

    public func startHealthKitBackgroundDelivery() async {
        guard didBootstrap,
              authorizationState == .authorized || authorizationState == .partial else { return }
        let result = await syncService.startObservingRunningWorkoutChanges { [weak self] in
            guard let self else { return }
            await self.syncHealthKitChanges(includePostSyncMaintenance: false)
        }
        guard result.authorizationState == .authorized || result.authorizationState == .partial else {
            if result.authorizationState == .error {
                Self.refreshLogger.notice("Apple Health background delivery unavailable; foreground refresh remains active")
                message = "Apple Health is connected. RunSignal will check for new runs when you open the app."
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
        await refreshPersonalBestEffortsFromInMemoryEvidence()
    }

    public func loadFullAnalysisForWorkout(workoutID: String) async {
        guard workouts.contains(where: { $0.id == workoutID }) else {
            updateHealthKitStatus(
                authorizationState: .error,
                message: "Workout is not loaded in the current RunSignal store."
            )
            return
        }
        guard !usesSampleData else { return }
        automaticEvidenceAttemptedWorkoutIDs.remove(workoutID)
        prioritizedEvidenceWorkoutIDs.insert(workoutID)
        analysisProgressByWorkoutID[workoutID] = WorkoutAnalysisProgress(
            stage: .queued,
            message: "Preparing this run for full analysis."
        )
        startAutomaticEvidenceEnrichment()
        await automaticEvidenceTask?.value
    }

    public func startAutomaticEvidenceEnrichment(now: Date = Date()) {
        guard automaticEvidenceTask == nil, !usesSampleData else { return }
        let cachedEvidenceIDs = modelContext.map(PersistenceService.fetchEvidenceIDs(context:)) ?? []
        for workoutID in Self.automaticEvidenceCandidateIDs(
            workouts: workouts,
            cachedEvidenceIDs: cachedEvidenceIDs,
            now: now
        ) where !automaticEvidenceAttemptedWorkoutIDs.contains(workoutID) {
            analysisProgressByWorkoutID[workoutID] = WorkoutAnalysisProgress(
                stage: .queued,
                message: "Queued for automatic analysis."
            )
        }

        automaticEvidenceTask = Task { @MainActor [weak self] in
            guard let self else { return }
            while self.isEnrichingAudit, !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(100))
            }
            guard !Task.isCancelled else {
                self.automaticEvidenceTask = nil
                return
            }
            await self.runAutomaticEvidenceQueue(now: now)
        }
    }

    public func prioritizeFullAnalysisForWorkout(workoutID: String) {
        guard !usesSampleData,
              let workout = workouts.first(where: { $0.id == workoutID }),
              workout.evidence == nil else { return }
        prioritizedEvidenceWorkoutIDs.insert(workoutID)
        analysisProgressByWorkoutID[workoutID] = WorkoutAnalysisProgress(
            stage: .queued,
            message: "Preparing this run for full analysis."
        )
        startAutomaticEvidenceEnrichment()
    }

    private func runAutomaticEvidenceQueue(now: Date) async {
        let budget = makeImportBudgetPolicy()
        defer {
            automaticEvidenceTask = nil
            isEnrichingAudit = false
        }

        while !Task.isCancelled {
            if let workoutID = nextAutomaticPreparedWorkoutID(now: now) {
                if pauseAutomaticEvidenceQueueIfNeeded(workoutID: workoutID, budget: budget) {
                    break
                }
                automaticEvidenceAttemptedWorkoutIDs.insert(workoutID)
                await prepareExistingDetailedWorkout(workoutID: workoutID)
                await Task.yield()
                continue
            }

            guard let workoutID = nextAutomaticEvidenceWorkoutID(now: now) else { break }
            if let reason = budget.pauseReason(allowsDetailedEvidence: true) {
                message = reason.message
                analysisProgressByWorkoutID[workoutID] = WorkoutAnalysisProgress(
                    stage: .paused,
                    message: reason.message
                )
                break
            }
            automaticEvidenceAttemptedWorkoutIDs.insert(workoutID)
            prioritizedEvidenceWorkoutIDs.remove(workoutID)
            await enrichSingleWorkout(workoutID: workoutID, budget: budget)
            await Task.yield()
        }
    }

    private func pauseAutomaticEvidenceQueueIfNeeded(
        workoutID: String,
        budget: IngestionBudgetPolicy
    ) -> Bool {
        guard let reason = budget.pauseReason(allowsDetailedEvidence: true) else { return false }
        message = reason.message
        analysisProgressByWorkoutID[workoutID] = WorkoutAnalysisProgress(
            stage: .paused,
            message: reason.message
        )
        return true
    }

    private func nextAutomaticPreparedWorkoutID(now: Date) -> String? {
        Self.automaticEvidenceWindow(workouts: workouts, now: now)
            .first { workout in
                workout.evidence != nil
                    && derivedAnalysesByWorkoutID[workout.id] == nil
                    && !automaticEvidenceAttemptedWorkoutIDs.contains(workout.id)
            }?
            .id
    }

    private func nextAutomaticEvidenceWorkoutID(now: Date) -> String? {
        let existingEvidenceIDs = Set(workouts.compactMap { $0.evidence == nil ? nil : $0.id })
        let cachedEvidenceIDs = modelContext.map(PersistenceService.fetchEvidenceIDs(context:)) ?? []
        let unavailableIDs = existingEvidenceIDs.union(cachedEvidenceIDs).union(automaticEvidenceAttemptedWorkoutIDs)

        let prioritized = workouts
            .filter { prioritizedEvidenceWorkoutIDs.contains($0.id) && !unavailableIDs.contains($0.id) }
            .sorted(by: { $0.startDate > $1.startDate })
            .first

        if let prioritized {
            return prioritized.id
        }

        return Self.automaticEvidenceCandidateIDs(
            workouts: workouts,
            cachedEvidenceIDs: cachedEvidenceIDs,
            now: now
        )
        .first { !automaticEvidenceAttemptedWorkoutIDs.contains($0) }
    }

    private func enrichSingleWorkout(workoutID: String, budget: IngestionBudgetPolicy) async {
        if let reason = budget.pauseReason(allowsDetailedEvidence: true) {
            message = reason.message
            analysisProgressByWorkoutID[workoutID] = WorkoutAnalysisProgress(
                stage: .paused,
                message: reason.message
            )
            return
        }

        isEnrichingAudit = true
        analyzingWorkoutIDs.insert(workoutID)
        analysisProgressByWorkoutID[workoutID] = WorkoutAnalysisProgress(
            stage: .readingHealthKit,
            message: "Reading workout samples, route, and plan. You can keep using RunSignal."
        )
        defer {
            analyzingWorkoutIDs.remove(workoutID)
            isEnrichingAudit = false
        }

        let result = await healthKitService.enrichRunningWorkouts(ids: [workoutID])
        updateHealthKitStatus(
            authorizationState: result.authorizationState,
            message: result.message ?? "Full analysis refresh finished."
        )

        let canUseResult = result.authorizationState == .authorized || result.authorizationState == .partial
        guard canUseResult,
              var returnedWorkout = result.workouts.first(where: { $0.id == workoutID }),
              let evidence = returnedWorkout.evidence else {
            let failureMessage = result.message ?? "HealthKit did not return detailed evidence for this workout."
            markEvidenceQueueAttempt(ids: [workoutID], status: .failed, message: failureMessage)
            analysisProgressByWorkoutID[workoutID] = WorkoutAnalysisProgress(
                stage: .failed,
                message: failureMessage
            )
            return
        }

        returnedWorkout.inferredRunType = RunClassifier.inferRunType(for: returnedWorkout)
        returnedWorkout.evidence = evidence
        returnedWorkout.workoutPlanName = evidence.workoutPlanAudit?.displayName
        analysisProgressByWorkoutID[workoutID] = WorkoutAnalysisProgress(
            stage: .processing,
            message: "Building charts, splits, and workout intervals in the background."
        )
        let persistenceWorkout = returnedWorkout
        let persistenceEvidence = evidence
        let prepared = await Task.detached(priority: .utility) { [persistenceWorkout, persistenceEvidence] in
            PreparedWorkoutPersistence.make(workout: persistenceWorkout, evidence: persistenceEvidence)
        }.value

        workouts = removeSampleWorkoutsIfRealDataExists(
            mergeSyncedWorkouts(changes: [returnedWorkout], current: workouts)
        )
        deletePersistedSampleWorkoutsIfNeeded()
        applyReviewedRunTypes()
        if let modelContext {
            PersistenceService.upsertPreparedDetailedWorkout(
                returnedWorkout,
                evidence: evidence,
                prepared: prepared,
                context: modelContext
            )
        }
        derivedAnalysesByWorkoutID[workoutID] = prepared.analysis
        markEvidenceQueueAttempt(ids: [workoutID], status: .enriched, message: result.message)
        refreshSingleWorkoutDerivedState(workoutID: workoutID)
        analysisProgressByWorkoutID[workoutID] = WorkoutAnalysisProgress(
            stage: .ready,
            message: "Full analysis is ready."
        )

        if evidence.cityName == nil, !evidence.route.isEmpty {
            Task { @MainActor [weak self] in
                await self?.resolveAndCacheCityName(workoutID: workoutID)
            }
        }
    }

    private func prepareExistingDetailedWorkout(workoutID: String) async {
        guard let index = workouts.firstIndex(where: { $0.id == workoutID }),
              let evidence = workouts[index].evidence else { return }
        var workout = workouts[index]
        workout.workoutPlanName = evidence.workoutPlanAudit?.displayName ?? workout.workoutPlanName
        let suggestion = RunClassifier.suggestion(
            for: workout,
            history: workouts,
            maxHeartRate: healthContext.maxHeartRate
        )
        if suggestion.runType != .unknown || workout.inferredRunType == .unknown {
            workout.inferredRunType = suggestion.runType
        }
        analysisProgressByWorkoutID[workoutID] = WorkoutAnalysisProgress(
            stage: .processing,
            message: "Building charts, splits, and workout intervals in the background."
        )
        let suggestedRunType = workout.inferredRunType
        let persistenceWorkout = workout
        let persistenceEvidence = evidence
        let prepared = await Task.detached(priority: .utility) { [persistenceWorkout, persistenceEvidence] in
            PreparedWorkoutPersistence.make(workout: persistenceWorkout, evidence: persistenceEvidence)
        }.value
        guard let currentIndex = workouts.firstIndex(where: { $0.id == workoutID }) else { return }
        workouts[currentIndex].inferredRunType = suggestedRunType
        workouts[currentIndex].workoutPlanName = workout.workoutPlanName
        if let modelContext {
            PersistenceService.upsertPreparedDetailedWorkout(
                workouts[currentIndex],
                evidence: evidence,
                prepared: prepared,
                context: modelContext
            )
        }
        derivedAnalysesByWorkoutID[workoutID] = prepared.analysis
        refreshSingleWorkoutDerivedState(workoutID: workoutID)
        analysisProgressByWorkoutID[workoutID] = WorkoutAnalysisProgress(
            stage: .ready,
            message: "Full analysis is ready."
        )
        if evidence.cityName == nil, !evidence.route.isEmpty {
            Task { @MainActor [weak self] in
                await self?.resolveAndCacheCityName(workoutID: workoutID)
            }
        }
    }

    private func refreshSingleWorkoutDerivedState(workoutID: String) {
        applySuggestedRunTypes()
        guard let workout = workouts.first(where: { $0.id == workoutID }) else { return }
        refreshTrainingPeriodSummaryCache(affectedBy: workout, persist: true)
        snapshot = AnalyticsEngine.snapshot(for: workouts, healthContext: healthContext)
        let derived = PersonalBestEffortSummary(
            allTime: derivedAnalysesByWorkoutID.values.flatMap { $0.personalBestEffortRecords ?? [] }
        )
        personalBestEffortSummary = mergePersonalBestEfforts(
            cached: loadPersonalBestEffortCache(),
            computed: derived
        )
        savePersonalBestEffortCache(personalBestEffortSummary)
        refreshEvidenceQueueSummary()
    }

    private func resolveAndCacheCityName(workoutID: String) async {
        guard let index = workouts.firstIndex(where: { $0.id == workoutID }),
              var evidence = workouts[index].evidence,
              evidence.cityName == nil,
              !evidence.route.isEmpty else { return }
        guard let cityName = await WorkoutCityResolver.cityName(for: evidence.route) else { return }
        evidence.cityName = cityName
        let evidenceSnapshot = evidence
        let evidenceData = await Task.detached(priority: .utility) { [evidenceSnapshot] in
            (try? JSONEncoder().encode(evidenceSnapshot)) ?? Data()
        }.value
        guard let currentIndex = workouts.firstIndex(where: { $0.id == workoutID }) else { return }
        workouts[currentIndex].evidence = evidence
        workouts[currentIndex].workoutPlanName = evidence.workoutPlanAudit?.displayName ?? workouts[currentIndex].workoutPlanName
        if let modelContext {
            PersistenceService.updatePreparedEvidence(
                workoutID: workoutID,
                evidence: evidence,
                evidenceData: evidenceData,
                context: modelContext
            )
        }
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
        await hydrateCachedEvidenceIfAvailable(for: workoutID)
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
        await refreshPersonalBestEffortsFromInMemoryEvidence()
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
            await hydrateCachedEvidenceIfAvailable(for: workout.id)
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
        await refreshPersonalBestEffortsFromInMemoryEvidence()
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
        pendingManualWorkoutIDs.insert(workoutID)
        let version = (manualWorkoutUpdateVersions[workoutID] ?? 0) + 1
        manualWorkoutUpdateVersions[workoutID] = version
        refreshTrainingPeriodSummaryCache(affectedBy: workouts[index], persist: false)

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
            refreshTrainingPeriodSummaryCache(affectedBy: currentWorkout, persist: true)
            runTypeReconciliation = RunTypeReviewBridge.reconcile(reviews: reviewedRunTypes, workouts: workouts)
            snapshot = AnalyticsEngine.snapshot(for: workouts, healthContext: healthContext)

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

    public func hydrateCachedEvidenceIfAvailable(for workoutID: String) async {
        guard let index = workouts.firstIndex(where: { $0.id == workoutID }),
              workouts[index].evidence == nil,
              let modelContext,
              let evidenceData = PersistenceService.fetchEvidenceData(workoutID: workoutID, context: modelContext)
        else { return }

        let evidence = await Task.detached(priority: .userInitiated) {
            try? JSONDecoder().decode(WorkoutEvidence.self, from: evidenceData)
        }.value
        guard let evidence,
              let currentIndex = workouts.firstIndex(where: { $0.id == workoutID }),
              workouts[currentIndex].evidence == nil else { return }

        var hydratedWorkout = workouts[currentIndex]
        hydratedWorkout.evidence = evidence
        hydratedWorkout.workoutPlanName = evidence.workoutPlanAudit?.displayName ?? hydratedWorkout.workoutPlanName
        hydratedWorkout.routePointCount = evidence.route.count
        hydratedWorkout.seriesSampleCount = evidence.seriesSampleCount
        hydratedWorkout.routeAvailable = hydratedWorkout.routeAvailable || !evidence.route.isEmpty
        hydratedWorkout.seriesAvailable = hydratedWorkout.seriesAvailable || evidence.seriesSampleCount > 0

        let cachedAnalysis = PersistenceService.fetchDerivedAnalysis(workoutID: workoutID, context: modelContext)
        let prepared: PreparedWorkoutPersistence?
        if cachedAnalysis?.calculationVersion == DerivedWorkoutAnalysis.currentVersion {
            prepared = nil
        } else {
            let workoutSnapshot = hydratedWorkout
            let evidenceSnapshot = evidence
            prepared = await Task.detached(priority: .userInitiated) {
                PreparedWorkoutPersistence.make(workout: workoutSnapshot, evidence: evidenceSnapshot)
            }.value
        }

        guard let refreshedIndex = workouts.firstIndex(where: { $0.id == workoutID }),
              workouts[refreshedIndex].evidence == nil else { return }
        workouts[refreshedIndex] = hydratedWorkout
        PersistenceService.updateWorkoutPlanClassification(
            workoutID: workoutID,
            name: workouts[refreshedIndex].workoutPlanName,
            inferredRunType: workouts[refreshedIndex].inferredRunType,
            context: modelContext
        )
        analysisProgressByWorkoutID[workoutID] = WorkoutAnalysisProgress(
            stage: .ready,
            message: "Full analysis is ready."
        )

        if let prepared {
            PersistenceService.upsertPreparedDetailedWorkout(
                hydratedWorkout,
                evidence: evidence,
                prepared: prepared,
                context: modelContext
            )
            derivedAnalysesByWorkoutID[workoutID] = prepared.analysis
        } else if let cachedAnalysis {
            derivedAnalysesByWorkoutID[workoutID] = cachedAnalysis
        }
        refreshEvidenceQueueSummary()
    }

    public func hydrateCachedWorkoutPlanNameIfAvailable(for workoutID: String) async {
        guard let index = workouts.firstIndex(where: { $0.id == workoutID }),
              !workoutPlanMetadataHydrationIDs.contains(workoutID),
              let modelContext
        else { return }

        workoutPlanMetadataHydrationIDs.insert(workoutID)

        let existingName = workouts[index].workoutPlanName?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard existingName?.isEmpty != false,
              let evidenceData = PersistenceService.fetchEvidenceData(workoutID: workoutID, context: modelContext)
        else { return }

        let planName = await Task.detached(priority: .utility) {
            guard let evidence = try? JSONDecoder().decode(WorkoutEvidence.self, from: evidenceData) else {
                return Optional<String>.none
            }
            return evidence.workoutPlanAudit?.displayName?.trimmingCharacters(in: .whitespacesAndNewlines)
        }.value
        guard let currentIndex = workouts.firstIndex(where: { $0.id == workoutID }) else { return }

        if let planName, !planName.isEmpty {
            workouts[currentIndex].workoutPlanName = planName
        }
        PersistenceService.updateWorkoutPlanClassification(
            workoutID: workoutID,
            name: workouts[currentIndex].workoutPlanName,
            inferredRunType: workouts[currentIndex].inferredRunType,
            context: modelContext
        )
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
                merged.workoutPlanName = workout.evidence?.workoutPlanAudit?.displayName
                    ?? workout.workoutPlanName
                    ?? existing.workoutPlanName
            } else {
                merged.workoutPlanName = workout.evidence?.workoutPlanAudit?.displayName
                    ?? workout.workoutPlanName
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
                merged.workoutPlanName = change.evidence?.workoutPlanAudit?.displayName
                    ?? change.workoutPlanName
                    ?? existing.workoutPlanName
            } else {
                merged.workoutPlanName = change.evidence?.workoutPlanAudit?.displayName
                    ?? change.workoutPlanName
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
            return "Apple Health history is up to date. Access is reflected by the workouts Apple Health returned."
        }
        return "Apple Health history is up to date for the history available from \(earliestPermittedDate.formatted(date: .abbreviated, time: .omitted))."
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

    private func persistCurrent() {
        guard let modelContext else { return }
        PersistenceService.upsert(workouts, context: modelContext)
    }

    private func recompute(
        hydrateEvidence shouldHydrateEvidence: Bool = false,
        refreshDerivedAnalyses shouldRefreshDerivedAnalyses: Bool = false,
        refreshTrainingPeriodSummaries shouldRefreshTrainingPeriodSummaries: Bool = true
    ) {
        if shouldHydrateEvidence {
            hydrateCachedEvidence()
        }
        workouts = DuplicateDetector.markDuplicates(workouts)
        applySuggestedRunTypes()
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
            hydrated.workoutPlanName = evidence.workoutPlanAudit?.displayName ?? hydrated.workoutPlanName
            hydrated.routePointCount = evidence.route.count
            hydrated.seriesSampleCount = evidence.seriesSampleCount
            hydrated.routeAvailable = hydrated.routeAvailable || !evidence.route.isEmpty
            hydrated.seriesAvailable = hydrated.seriesAvailable || evidence.seriesSampleCount > 0
            return hydrated
        }
    }

    private func refreshPersonalBestEffortsFromInMemoryEvidence() async {
        personalBestEffortRefreshGeneration += 1
        let generation = personalBestEffortRefreshGeneration
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

        let workoutSnapshot = workouts
        let computed = await Task.detached(priority: .utility) {
            PersonalBestEffortEngine.summarize(workouts: workoutSnapshot)
        }.value
        guard generation == personalBestEffortRefreshGeneration, !Task.isCancelled else { return }
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
        let candidates = ((cached?.allTime ?? []) + computed.allTime)
            .filter { $0.confidence == .exact || $0.confidence == .exactTotal }
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
        guard let decoded = try? JSONDecoder().decode(PersonalBestEffortSummary.self, from: data) else {
            return nil
        }
        return PersonalBestEffortSummary(
            allTime: decoded.allTime.filter { $0.confidence == .exact || $0.confidence == .exactTotal }
        )
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

    private func refreshTrainingPeriodSummaryCache(
        affectedBy workout: CanonicalWorkout,
        persist: Bool
    ) {
        let refreshed: [CachedTrainingPeriodSummary]
        if persist, let modelContext {
            refreshed = PersistenceService.refreshTrainingPeriodSummaries(
                affectedBy: workout,
                workouts: workouts,
                context: modelContext
            )
        } else {
            refreshed = CachedTrainingPeriodSummary.makeAffectedByManualChange(
                workout: workout,
                workouts: workouts
            )
        }

        var summariesByKey: [String: CachedTrainingPeriodSummary] = [:]
        for summary in trainingPeriodSummaries {
            summariesByKey[summary.cacheKey] = summary
        }
        for summary in refreshed {
            summariesByKey[summary.cacheKey] = summary
        }
        trainingPeriodSummaries = summariesByKey.values.sorted { lhs, rhs in
            if lhs.period.rawValue != rhs.period.rawValue {
                return lhs.period.rawValue < rhs.period.rawValue
            }
            return lhs.periodStart > rhs.periodStart
        }
    }

    private func applyReviewedRunTypes() {
        guard !reviewedRunTypes.isEmpty else { return }
        workouts = RunTypeReviewBridge.applyConfidentMatches(reviews: reviewedRunTypes, to: workouts)
    }

    private func applySuggestedRunTypes() {
        let history = workouts
        workouts = workouts.map { workout in
            var classified = workout
            let suggestion = RunClassifier.suggestion(
                for: workout,
                history: history,
                maxHeartRate: healthContext.maxHeartRate
            )
            if suggestion.runType != .unknown || classified.inferredRunType == .unknown {
                classified.inferredRunType = suggestion.runType
            }
            return classified
        }
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
            cachedEvidenceWorkoutIDs = Set(workouts.compactMap { $0.evidence == nil ? nil : $0.id })
            let items = EvidenceEnrichmentQueue.items(workouts: workouts, cachedEvidenceIDs: cachedEvidenceWorkoutIDs)
            evidenceQueueSummary = EvidenceEnrichmentQueue.summary(for: items)
            return
        }
        cachedEvidenceWorkoutIDs = PersistenceService.fetchEvidenceIDs(context: modelContext)
        let items = EvidenceEnrichmentQueue.items(
            workouts: workouts,
            cachedEvidenceIDs: cachedEvidenceWorkoutIDs,
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
