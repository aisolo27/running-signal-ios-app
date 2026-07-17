import Foundation

public enum HealthKitPrimaryAction: Equatable, Sendable {
    case connect
    case continueImport
    case refresh

    public var title: String {
        switch self {
        case .connect: "Connect Apple Health"
        case .continueImport: "Continue History Import"
        case .refresh: "Refresh Apple Health"
        }
    }

    public var systemImage: String {
        switch self {
        case .connect: "heart.text.square"
        case .continueImport: "arrow.clockwise"
        case .refresh: "arrow.clockwise"
        }
    }
}

public enum HealthKitConnectionPhase: Equatable, Sendable {
    case disconnected
    case requestingAuthorization
    case loadingHistory
    case paused
    case healthAccessReview
    case ready
    case failed
    case unavailable
}

public struct HealthKitConnectionPresentation: Equatable, Sendable {
    public var phase: HealthKitConnectionPhase
    public var title: String
    public var detailText: String
    public var action: HealthKitPrimaryAction
    public var showsProgress: Bool
    public var showsPrimaryAction: Bool
    public var loadedRunCount: Int

    public var showsHealthAccessRecoveryGuidance: Bool {
        phase == .healthAccessReview
    }

    public static func make(
        authorizationState: AuthorizationState,
        importStatus: HealthKitImportJobStatus?,
        loadedRunCount: Int,
        isLoading: Bool
    ) -> HealthKitConnectionPresentation {
        let runLabel = loadedRunCount == 1 ? "run" : "runs"

        if authorizationState == .requesting {
            return HealthKitConnectionPresentation(
                phase: .requestingAuthorization,
                title: "Waiting for Apple Health",
                detailText: "Choose the Health data you want RunSignal to read.",
                action: .connect,
                showsProgress: true,
                showsPrimaryAction: false,
                loadedRunCount: loadedRunCount
            )
        }

        if isLoading || importStatus == .running || importStatus == .queued {
            return HealthKitConnectionPresentation(
                phase: .loadingHistory,
                title: loadedRunCount == 0 ? "Finding Your Runs" : "Loading Run History",
                detailText: loadedRunCount == 0
                    ? "RunSignal is checking Apple Health for completed running workouts."
                    : "\(loadedRunCount) completed \(runLabel) available. RunSignal is still checking older history.",
                action: loadedRunCount > 0 ? .refresh : .connect,
                showsProgress: true,
                showsPrimaryAction: false,
                loadedRunCount: loadedRunCount
            )
        }

        if importStatus == .paused {
            return HealthKitConnectionPresentation(
                phase: .paused,
                title: "History Import Paused",
                detailText: loadedRunCount == 0
                    ? "RunSignal paused before finding a completed run. Continue when you are ready."
                    : "\(loadedRunCount) completed \(runLabel) available. Continue to check older history.",
                action: .continueImport,
                showsProgress: false,
                showsPrimaryAction: true,
                loadedRunCount: loadedRunCount
            )
        }

        if importStatus == .failed || importStatus == .blocked || authorizationState == .error {
            return HealthKitConnectionPresentation(
                phase: .failed,
                title: importStatus == .blocked ? "History Load Blocked" : "History Load Stopped",
                detailText: loadedRunCount == 0
                    ? "RunSignal could not finish loading your Apple Health run history."
                    : "\(loadedRunCount) completed \(runLabel) remain available. Try the history load again.",
                action: loadedRunCount > 0 ? .refresh : .connect,
                showsProgress: false,
                showsPrimaryAction: true,
                loadedRunCount: loadedRunCount
            )
        }

        if authorizationState == .partial,
           importStatus == .completed,
           loadedRunCount == 0 {
            return HealthKitConnectionPresentation(
                phase: .healthAccessReview,
                title: "Review Apple Health Access",
                detailText: "RunSignal finished checking Apple Health, but no completed running workouts were returned. If you already have runs, review RunSignal's Health access, then refresh.",
                action: .refresh,
                showsProgress: false,
                showsPrimaryAction: true,
                loadedRunCount: loadedRunCount
            )
        }

        if loadedRunCount > 0 || authorizationState == .authorized || authorizationState == .partial {
            return HealthKitConnectionPresentation(
                phase: .ready,
                title: "Apple Health Connected",
                detailText: loadedRunCount == 0
                    ? "Connected, but no completed running workouts were found."
                    : "\(loadedRunCount) completed \(runLabel) available in RunSignal.",
                action: .refresh,
                showsProgress: false,
                showsPrimaryAction: true,
                loadedRunCount: loadedRunCount
            )
        }

        if authorizationState == .unavailable {
            return HealthKitConnectionPresentation(
                phase: .unavailable,
                title: "Apple Health Unavailable",
                detailText: "Apple Health is not available on this device.",
                action: .connect,
                showsProgress: false,
                showsPrimaryAction: false,
                loadedRunCount: loadedRunCount
            )
        }

        return HealthKitConnectionPresentation(
            phase: .disconnected,
            title: "Connect Apple Health",
            detailText: "Connect Apple Health to load your completed running workouts.",
            action: .connect,
            showsProgress: false,
            showsPrimaryAction: true,
            loadedRunCount: loadedRunCount
        )
    }
}

public enum FirstRunOnboardingPolicy {
    public static func shouldPresent(
        onboardingCompleted: Bool,
        hasWorkouts: Bool,
        authorizationState: AuthorizationState
    ) -> Bool {
        !onboardingCompleted
            && !hasWorkouts
            && authorizationState == .notDetermined
    }
}

public struct BestEffortCoverageSummary: Equatable, Sendable {
    public var checkedRunCount: Int
    public var pendingRunCount: Int
    public var failedRunCount: Int
    public var historyImportStatus: HealthKitImportJobStatus?
    public var isCheckingDetailedData: Bool
    public var pauseMessage: String? = nil

    public var totalRunCount: Int {
        checkedRunCount + pendingRunCount + failedRunCount
    }

    public var isComplete: Bool {
        historyImportIsComplete
            && pendingRunCount == 0
            && failedRunCount == 0
            && totalRunCount > 0
    }

    public var sectionTitle: String {
        isComplete ? "All-Time Records" : "Verified Best Efforts"
    }

    public var showsProgress: Bool {
        historyImportIsRunning || isCheckingDetailedData
    }

    public var statusTitle: String {
        if historyImportIsRunning {
            return "Loading run history"
        }
        if historyImportStatus == .paused {
            return "Run history paused"
        }
        if pauseMessage != nil {
            return "Best Effort analysis paused"
        }
        if isComplete {
            return "All eligible runs checked"
        }
        if isCheckingDetailedData {
            return "Checking runs for best efforts"
        }
        if failedRunCount > 0 {
            return failedRunCount == 1 ? "1 run could not be checked" : "Some runs could not be checked"
        }
        return "Best Effort analysis pending"
    }

    public var actionTitle: String {
        if historyImportStatus == .paused {
            return "Continue History Import"
        }
        if failedRunCount > 0 {
            return "Retry \(failedRunCount) \(failedRunCount == 1 ? "Run" : "Runs")"
        }
        return "Continue Analysis"
    }

    public var detailText: String {
        if historyImportIsRunning {
            return "Verified best efforts will appear as RunSignal loads older runs and checks detailed Apple Health distance data."
        }
        if historyImportStatus == .paused {
            return "Continue the Apple Health history import before RunSignal can finish checking older runs for verified best efforts."
        }
        if let pauseMessage {
            return "\(pauseMessage) Tap Continue Analysis when you are ready."
        }
        if totalRunCount == 0 {
            return "Connect Apple Health to load runs before RunSignal can verify best efforts."
        }
        if isComplete {
            return "RunSignal checked detailed Apple Health data for all \(totalRunCount) loaded runs."
        }

        var detail = "\(checkedRunCount) of \(totalRunCount) loaded runs analyzed for verified best efforts."
        if failedRunCount > 0 {
            detail += " \(failedRunCount) could not be checked yet; retrying will only revisit those runs."
        } else if isCheckingDetailedData {
            detail += " Verified records update as analysis finishes."
        } else {
            detail += " More run data remains to be checked."
        }
        return detail
    }

    public func analyticsSummary(recordCount: Int) -> String {
        if isComplete {
            return "\(recordCount) official all-time \(recordCount == 1 ? "record" : "records")"
        }
        if recordCount == 0 {
            return "Verified records appear as detailed run data is checked"
        }
        return "\(recordCount) verified exact \(recordCount == 1 ? "record" : "records") · history analysis pending"
    }

    private var historyImportIsRunning: Bool {
        historyImportStatus == .queued || historyImportStatus == .running
    }

    private var historyImportIsComplete: Bool {
        historyImportStatus == nil || historyImportStatus == .completed
    }
}
