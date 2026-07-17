import Foundation

public struct HealthKitHistoryImportProgress: Equatable, Sendable {
    public var completedDateWindowCount: Int
    public var totalDateWindowCount: Int
    public var currentWindowStartDate: Date?
    public var currentWindowEndDate: Date?
    public var importedWorkoutCount: Int

    public init(
        completedDateWindowCount: Int,
        totalDateWindowCount: Int,
        currentWindowStartDate: Date? = nil,
        currentWindowEndDate: Date? = nil,
        importedWorkoutCount: Int
    ) {
        self.completedDateWindowCount = completedDateWindowCount
        self.totalDateWindowCount = totalDateWindowCount
        self.currentWindowStartDate = currentWindowStartDate
        self.currentWindowEndDate = currentWindowEndDate
        self.importedWorkoutCount = importedWorkoutCount
    }

    public var fractionComplete: Double {
        guard totalDateWindowCount > 0 else { return 0 }
        return Double(clampedCompletedDateWindowCount) / Double(totalDateWindowCount)
    }

    public var progressText: String {
        let rangeLabel = totalDateWindowCount == 1 ? "range" : "ranges"
        return "\(clampedCompletedDateWindowCount) of \(max(totalDateWindowCount, 0)) history \(rangeLabel) checked"
    }

    private var clampedCompletedDateWindowCount: Int {
        min(max(completedDateWindowCount, 0), max(totalDateWindowCount, 0))
    }
}
