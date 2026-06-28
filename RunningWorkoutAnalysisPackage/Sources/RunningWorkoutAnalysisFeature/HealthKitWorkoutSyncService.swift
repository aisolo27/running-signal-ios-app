import Foundation
@preconcurrency import HealthKit

public struct HealthKitSyncState: Equatable, Sendable {
    public var lastSyncAt: Date?
    public var lastFetchedCount: Int
    public var lastInsertedCount: Int
    public var lastUpdatedCount: Int
    public var lastDeletedCount: Int
    public var lastEvidencePendingCount: Int

    public init(
        lastSyncAt: Date? = nil,
        lastFetchedCount: Int = 0,
        lastInsertedCount: Int = 0,
        lastUpdatedCount: Int = 0,
        lastDeletedCount: Int = 0,
        lastEvidencePendingCount: Int = 0
    ) {
        self.lastSyncAt = lastSyncAt
        self.lastFetchedCount = lastFetchedCount
        self.lastInsertedCount = lastInsertedCount
        self.lastUpdatedCount = lastUpdatedCount
        self.lastDeletedCount = lastDeletedCount
        self.lastEvidencePendingCount = lastEvidencePendingCount
    }

    public static let empty = HealthKitSyncState()
}

public struct HealthKitWorkoutSyncResult: Sendable {
    public var authorizationState: AuthorizationState
    public var fetchedWorkouts: [CanonicalWorkout]
    public var deletedWorkoutIDs: [String]
    public var newAnchor: HKQueryAnchor?
    public var healthContext: HealthContext
    public var message: String?

    public init(
        authorizationState: AuthorizationState,
        fetchedWorkouts: [CanonicalWorkout] = [],
        deletedWorkoutIDs: [String] = [],
        newAnchor: HKQueryAnchor? = nil,
        healthContext: HealthContext = HealthContext(),
        message: String? = nil
    ) {
        self.authorizationState = authorizationState
        self.fetchedWorkouts = fetchedWorkouts
        self.deletedWorkoutIDs = deletedWorkoutIDs
        self.newAnchor = newAnchor
        self.healthContext = healthContext
        self.message = message
    }
}

public protocol HealthKitWorkoutSyncServicing: AnyObject, Sendable {
    func syncRunningWorkouts(from anchor: HKQueryAnchor?) async -> HealthKitWorkoutSyncResult
}

public final class HealthKitWorkoutSyncService: HealthKitWorkoutSyncServicing, @unchecked Sendable {
    private let store = HKHealthStore()
    private let healthKitService: any HealthKitServicing
    public static let defaultSyncBatchLimit = 100

    public init(healthKitService: any HealthKitServicing = HealthKitService()) {
        self.healthKitService = healthKitService
    }

    public func syncRunningWorkouts(from anchor: HKQueryAnchor?) async -> HealthKitWorkoutSyncResult {
        guard HKHealthStore.isHealthDataAvailable() else {
            return HealthKitWorkoutSyncResult(authorizationState: .unavailable, message: "HealthKit is not available on this device.")
        }

        let state = await healthKitService.requestAuthorization()
        guard state == .authorized else {
            return HealthKitWorkoutSyncResult(authorizationState: state, message: "HealthKit permission is not fully available.")
        }

        do {
            let anchored = try await anchoredRunningWorkouts(from: anchor)
            let canonical = await HealthKitWorkoutMapper.normalize(anchored.workouts, store: store)
            return HealthKitWorkoutSyncResult(
                authorizationState: canonical.isEmpty && anchored.deletedWorkoutIDs.isEmpty ? .partial : .authorized,
                fetchedWorkouts: DuplicateDetector.markDuplicates(canonical),
                deletedWorkoutIDs: anchored.deletedWorkoutIDs,
                newAnchor: anchored.anchor,
                healthContext: await healthKitService.loadHealthContext(),
                message: syncMessage(fetchedCount: canonical.count, deletedCount: anchored.deletedWorkoutIDs.count)
            )
        } catch {
            return HealthKitWorkoutSyncResult(authorizationState: .error, message: "Could not sync HealthKit running workouts.")
        }
    }

    private func anchoredRunningWorkouts(
        from anchor: HKQueryAnchor?,
        limit: Int = HealthKitWorkoutSyncService.defaultSyncBatchLimit
    ) async throws -> (workouts: [HKWorkout], deletedWorkoutIDs: [String], anchor: HKQueryAnchor?) {
        let predicate = HKQuery.predicateForWorkouts(with: .running)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKAnchoredObjectQuery(
                type: HKObjectType.workoutType(),
                predicate: predicate,
                anchor: anchor,
                limit: limit
            ) { _, samples, deletedObjects, newAnchor, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                let workouts = samples as? [HKWorkout] ?? []
                let deletedIDs = (deletedObjects ?? []).map { $0.uuid.uuidString }
                continuation.resume(returning: (workouts, deletedIDs, newAnchor))
            }
            store.execute(query)
        }
    }

    private func syncMessage(fetchedCount: Int, deletedCount: Int) -> String {
        if fetchedCount == 0 && deletedCount == 0 {
            return "HealthKit sync found no new running workout changes."
        }
        return "Synced \(fetchedCount) HealthKit running workout changes and detected \(deletedCount) deleted records."
    }
}

public enum HealthKitSyncStateStore {
    private static let anchorKey = "RunSignal.HealthKitSync.Anchor.v1"
    private static let lastSyncAtKey = "RunSignal.HealthKitSync.LastSyncAt.v1"

    public static func loadAnchor(defaults: UserDefaults = .standard) -> HKQueryAnchor? {
        guard let data = defaults.data(forKey: anchorKey) else { return nil }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: HKQueryAnchor.self, from: data)
    }

    public static func hasAnchor(defaults: UserDefaults = .standard) -> Bool {
        loadAnchor(defaults: defaults) != nil
    }

    public static func saveAnchor(_ anchor: HKQueryAnchor?, defaults: UserDefaults = .standard) {
        guard let anchor,
              let data = try? NSKeyedArchiver.archivedData(withRootObject: anchor, requiringSecureCoding: true) else {
            defaults.removeObject(forKey: anchorKey)
            return
        }
        defaults.set(data, forKey: anchorKey)
    }

    public static func loadLastSyncAt(defaults: UserDefaults = .standard) -> Date? {
        defaults.object(forKey: lastSyncAtKey) as? Date
    }

    public static func saveLastSyncAt(_ date: Date?, defaults: UserDefaults = .standard) {
        if let date {
            defaults.set(date, forKey: lastSyncAtKey)
        } else {
            defaults.removeObject(forKey: lastSyncAtKey)
        }
    }

    public static func reset(defaults: UserDefaults = .standard) {
        defaults.removeObject(forKey: anchorKey)
        defaults.removeObject(forKey: lastSyncAtKey)
    }
}
