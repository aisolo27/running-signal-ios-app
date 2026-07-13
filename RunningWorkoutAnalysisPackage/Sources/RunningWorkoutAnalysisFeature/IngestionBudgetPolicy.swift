import Foundation

public enum IngestionPauseReason: String, Codable, Sendable {
    case cancelled
    case lowPowerMode
    case thermalSerious
    case thermalCritical
    case elapsedBudgetExceeded

    public var message: String {
        switch self {
        case .cancelled:
            "Paused because the task was cancelled."
        case .lowPowerMode:
            "Paused because Low Power Mode is enabled."
        case .thermalSerious:
            "Paused because the device is running hot."
        case .thermalCritical:
            "Stopped because the device thermal state is critical."
        case .elapsedBudgetExceeded:
            "Paused briefly to keep RunSignal responsive."
        }
    }
}

public struct IngestionBudgetPolicy: Sendable {
    public var startedAt: Date
    public var maxElapsedSeconds: TimeInterval
    public var allowsDetailedEvidenceInLowPowerMode: Bool
    public var now: @Sendable () -> Date
    public var isCancelled: @Sendable () -> Bool
    public var isLowPowerModeEnabled: @Sendable () -> Bool
    public var thermalState: @Sendable () -> ProcessInfo.ThermalState

    public init(
        startedAt: Date = Date(),
        maxElapsedSeconds: TimeInterval = 30,
        allowsDetailedEvidenceInLowPowerMode: Bool = false,
        now: @escaping @Sendable () -> Date = Date.init,
        isCancelled: @escaping @Sendable () -> Bool = { Task.isCancelled },
        isLowPowerModeEnabled: @escaping @Sendable () -> Bool = { ProcessInfo.processInfo.isLowPowerModeEnabled },
        thermalState: @escaping @Sendable () -> ProcessInfo.ThermalState = { ProcessInfo.processInfo.thermalState }
    ) {
        self.startedAt = startedAt
        self.maxElapsedSeconds = maxElapsedSeconds
        self.allowsDetailedEvidenceInLowPowerMode = allowsDetailedEvidenceInLowPowerMode
        self.now = now
        self.isCancelled = isCancelled
        self.isLowPowerModeEnabled = isLowPowerModeEnabled
        self.thermalState = thermalState
    }

    public func pauseReason(allowsDetailedEvidence: Bool) -> IngestionPauseReason? {
        if isCancelled() {
            return .cancelled
        }
        if now().timeIntervalSince(startedAt) >= maxElapsedSeconds {
            return .elapsedBudgetExceeded
        }
        switch thermalState() {
        case .critical:
            return .thermalCritical
        case .serious:
            return allowsDetailedEvidence ? .thermalSerious : nil
        default:
            break
        }
        if allowsDetailedEvidence && !allowsDetailedEvidenceInLowPowerMode && isLowPowerModeEnabled() {
            return .lowPowerMode
        }
        return nil
    }
}
