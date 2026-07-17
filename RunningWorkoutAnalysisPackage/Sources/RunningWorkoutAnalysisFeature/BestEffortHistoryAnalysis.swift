import Foundation

public struct BestEffortHistoryCheckpoint: Codable, Equatable, Sendable {
    public var checkedWorkoutIDs: Set<String>
    public var failedWorkoutIDs: Set<String>

    public init(
        checkedWorkoutIDs: Set<String> = [],
        failedWorkoutIDs: Set<String> = []
    ) {
        self.checkedWorkoutIDs = checkedWorkoutIDs
        self.failedWorkoutIDs = failedWorkoutIDs
    }

    public mutating func retainWorkouts(ids: Set<String>) {
        checkedWorkoutIDs.formIntersection(ids)
        failedWorkoutIDs.formIntersection(ids)
        failedWorkoutIDs.subtract(checkedWorkoutIDs)
    }
}

enum BestEffortHistoryCheckpointStore {
    private static let key = "RunSignal.BestEffortHistoryCheckpoint.v2"

    static func load(defaults: UserDefaults) -> BestEffortHistoryCheckpoint {
        guard let data = defaults.data(forKey: key),
              let checkpoint = try? JSONDecoder().decode(BestEffortHistoryCheckpoint.self, from: data)
        else { return BestEffortHistoryCheckpoint() }
        return checkpoint
    }

    static func save(_ checkpoint: BestEffortHistoryCheckpoint, defaults: UserDefaults) {
        guard let data = try? JSONEncoder().encode(checkpoint) else { return }
        defaults.set(data, forKey: key)
    }
}
