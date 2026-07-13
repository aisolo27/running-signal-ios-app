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

public struct HealthKitConnectionPresentation: Equatable, Sendable {
    public var title: String
    public var action: HealthKitPrimaryAction
    public var showsProgress: Bool

    public static func make(
        authorizationState: AuthorizationState,
        importStatus: HealthKitImportJobStatus?,
        hasWorkouts: Bool,
        isLoading: Bool
    ) -> HealthKitConnectionPresentation {
        if isLoading || importStatus == .running || importStatus == .queued {
            return HealthKitConnectionPresentation(
                title: "Loading Apple Health",
                action: hasWorkouts ? .refresh : .connect,
                showsProgress: true
            )
        }

        if importStatus == .paused {
            return HealthKitConnectionPresentation(
                title: "History Import Paused",
                action: .continueImport,
                showsProgress: false
            )
        }

        if hasWorkouts || authorizationState == .authorized || authorizationState == .partial {
            return HealthKitConnectionPresentation(
                title: "Apple Health Connected",
                action: .refresh,
                showsProgress: false
            )
        }

        if authorizationState == .unavailable {
            return HealthKitConnectionPresentation(
                title: "Apple Health Unavailable",
                action: .connect,
                showsProgress: false
            )
        }

        return HealthKitConnectionPresentation(
            title: "Connect Apple Health",
            action: .connect,
            showsProgress: false
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
        return "Best Effort analysis pending"
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

        var detail = "\(checkedRunCount) of \(totalRunCount) loaded runs checked for detailed Apple Health data."
        if failedRunCount > 0 {
            detail += " \(failedRunCount) need another check."
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
