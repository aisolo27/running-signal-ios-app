import Foundation

public enum EvidenceEnrichmentStatus: String, Codable, CaseIterable, Sendable {
    case pending
    case enriched
    case failed

    public var label: String {
        switch self {
        case .pending: "Pending"
        case .enriched: "Enriched"
        case .failed: "Failed"
        }
    }
}

public enum EvidenceEnrichmentPriority: String, Codable, CaseIterable, Sendable {
    case latestRun
    case recentQuality
    case recentLongRun
    case needsReview
    case olderBenchmark
    case historical

    public var label: String {
        switch self {
        case .latestRun: "Latest run"
        case .recentQuality: "Recent quality"
        case .recentLongRun: "Recent long run"
        case .needsReview: "Needs review"
        case .olderBenchmark: "Older benchmark"
        case .historical: "Historical"
        }
    }

    var sortRank: Int {
        switch self {
        case .latestRun: 0
        case .recentQuality: 1
        case .recentLongRun: 2
        case .needsReview: 3
        case .olderBenchmark: 4
        case .historical: 5
        }
    }
}

public struct EvidenceEnrichmentQueueItem: Identifiable, Equatable, Sendable {
    public var id: String { workoutID }
    public var workoutID: String
    public var startDate: Date
    public var priority: EvidenceEnrichmentPriority
    public var status: EvidenceEnrichmentStatus
    public var message: String?

    public init(
        workoutID: String,
        startDate: Date,
        priority: EvidenceEnrichmentPriority,
        status: EvidenceEnrichmentStatus,
        message: String? = nil
    ) {
        self.workoutID = workoutID
        self.startDate = startDate
        self.priority = priority
        self.status = status
        self.message = message
    }
}

public struct EvidenceEnrichmentQueueSummary: Equatable, Sendable {
    public var pendingCount: Int
    public var enrichedCount: Int
    public var failedCount: Int
    public var nextPriority: EvidenceEnrichmentPriority?

    public static let empty = EvidenceEnrichmentQueueSummary(
        pendingCount: 0,
        enrichedCount: 0,
        failedCount: 0,
        nextPriority: nil
    )
}

public enum EvidenceEnrichmentQueue {
    public static func items(
        workouts: [CanonicalWorkout],
        cachedEvidenceIDs: Set<String>,
        failedStates: [String: PersistedEvidenceEnrichmentState] = [:]
    ) -> [EvidenceEnrichmentQueueItem] {
        let eligible = workouts
            .filter { !$0.isDuplicate }
            .filter { !isSampleWorkout($0) }
        let latestWorkout = eligible.sorted { $0.startDate > $1.startDate }.first
        let latestID = latestWorkout?.id
        let recentCutoff = latestWorkout?.startDate.addingTimeInterval(-120 * 86_400)

        return eligible
            .map { workout in
                let status: EvidenceEnrichmentStatus
                let message: String?
                if cachedEvidenceIDs.contains(workout.id) {
                    status = .enriched
                    message = nil
                } else if let failed = failedStates[workout.id], failed.status == .failed {
                    status = .failed
                    message = failed.message
                } else {
                    status = .pending
                    message = nil
                }

                return EvidenceEnrichmentQueueItem(
                    workoutID: workout.id,
                    startDate: workout.startDate,
                    priority: priority(for: workout, latestID: latestID, recentCutoff: recentCutoff),
                    status: status,
                    message: message
                )
            }
            .sorted(by: queueSort)
    }

    public static func nextPendingIDs(
        workouts: [CanonicalWorkout],
        cachedEvidenceIDs: Set<String>,
        failedStates: [String: PersistedEvidenceEnrichmentState] = [:],
        limit: Int
    ) -> [String] {
        items(workouts: workouts, cachedEvidenceIDs: cachedEvidenceIDs, failedStates: failedStates)
            .filter { $0.status == .pending }
            .prefix(limit)
            .map(\.workoutID)
    }

    public static func summary(for items: [EvidenceEnrichmentQueueItem]) -> EvidenceEnrichmentQueueSummary {
        let pending = items.filter { $0.status == .pending }
        return EvidenceEnrichmentQueueSummary(
            pendingCount: pending.count,
            enrichedCount: items.filter { $0.status == .enriched }.count,
            failedCount: items.filter { $0.status == .failed }.count,
            nextPriority: pending.first?.priority
        )
    }

    private static func priority(
        for workout: CanonicalWorkout,
        latestID: String?,
        recentCutoff: Date?
    ) -> EvidenceEnrichmentPriority {
        if workout.id == latestID {
            return .latestRun
        }
        let isRecent = recentCutoff.map { workout.startDate >= $0 } ?? false
        if isQuality(workout.effectiveRunType) {
            return isRecent ? .recentQuality : .olderBenchmark
        }
        if workout.effectiveRunType == .longRun || (workout.distanceMeters ?? 0) >= 10_000 {
            return isRecent ? .recentLongRun : .historical
        }
        if workout.manualRunType == nil && workout.inferredRunType == .unknown {
            return .needsReview
        }
        return .historical
    }

    private static func isQuality(_ runType: RunType) -> Bool {
        switch runType {
        case .tempo, .threshold, .interval, .race, .progression, .hills:
            true
        case .easy, .recovery, .longRun, .unknown:
            false
        }
    }

    private static func queueSort(lhs: EvidenceEnrichmentQueueItem, rhs: EvidenceEnrichmentQueueItem) -> Bool {
        let lhsStatusRank = statusRank(lhs.status)
        let rhsStatusRank = statusRank(rhs.status)
        if lhsStatusRank != rhsStatusRank { return lhsStatusRank < rhsStatusRank }
        if lhs.priority.sortRank != rhs.priority.sortRank { return lhs.priority.sortRank < rhs.priority.sortRank }
        return lhs.startDate > rhs.startDate
    }

    private static func statusRank(_ status: EvidenceEnrichmentStatus) -> Int {
        switch status {
        case .pending: 0
        case .failed: 1
        case .enriched: 2
        }
    }

    private static func isSampleWorkout(_ workout: CanonicalWorkout) -> Bool {
        workout.sourceName == "Sample Apple Watch" || workout.id.hasPrefix("sample-")
    }
}
