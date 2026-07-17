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
    func syncRunningWorkoutBatches(from anchor: HKQueryAnchor?) async -> [HealthKitWorkoutSyncResult]
    func startObservingRunningWorkoutChanges(
        _ handler: @escaping @MainActor @Sendable () async -> Void
    ) async -> HealthKitWorkoutSyncResult
}

public extension HealthKitWorkoutSyncServicing {
    func syncRunningWorkoutBatches(from anchor: HKQueryAnchor?) async -> [HealthKitWorkoutSyncResult] {
        [await syncRunningWorkouts(from: anchor)]
    }

    func startObservingRunningWorkoutChanges(
        _ handler: @escaping @MainActor @Sendable () async -> Void
    ) async -> HealthKitWorkoutSyncResult {
        HealthKitWorkoutSyncResult(authorizationState: .unavailable, message: "HealthKit background delivery is unavailable for this sync service.")
    }
}

public final class HealthKitWorkoutSyncService: HealthKitWorkoutSyncServicing, @unchecked Sendable {
    private let store = HKHealthStore()
    private let healthKitService: any HealthKitServicing
    private var observerQuery: HKObserverQuery?
    public static let defaultSyncBatchLimit = 100
    public static let defaultMaxSyncBatches = 20

    public init(healthKitService: any HealthKitServicing = HealthKitService()) {
        self.healthKitService = healthKitService
    }

    public func syncRunningWorkouts(from anchor: HKQueryAnchor?) async -> HealthKitWorkoutSyncResult {
        let batches = await syncRunningWorkoutBatches(from: anchor)
        guard let first = batches.first else {
            return HealthKitWorkoutSyncResult(authorizationState: .partial, message: "HealthKit sync found no new running workout changes.")
        }

        return HealthKitWorkoutSyncResult(
            authorizationState: batches.contains { $0.authorizationState == .error } ? .error : first.authorizationState,
            fetchedWorkouts: batches.flatMap(\.fetchedWorkouts),
            deletedWorkoutIDs: batches.flatMap(\.deletedWorkoutIDs),
            newAnchor: batches.last?.newAnchor,
            healthContext: batches.last?.healthContext ?? first.healthContext,
            message: syncMessage(
                fetchedCount: batches.reduce(0) { $0 + $1.fetchedWorkouts.count },
                deletedCount: batches.reduce(0) { $0 + $1.deletedWorkoutIDs.count }
            )
        )
    }

    public func syncRunningWorkoutBatches(from anchor: HKQueryAnchor?) async -> [HealthKitWorkoutSyncResult] {
        guard HKHealthStore.isHealthDataAvailable() else {
            return [HealthKitWorkoutSyncResult(authorizationState: .unavailable, message: "HealthKit is not available on this device.")]
        }

        let state = await healthKitService.requestAuthorization()
        guard state == .authorized || state == .partial else {
            return [HealthKitWorkoutSyncResult(authorizationState: state, message: "The HealthKit authorization request could not be completed.")]
        }

        do {
            var batches: [HealthKitWorkoutSyncResult] = []
            var currentAnchor = anchor
            for _ in 0..<Self.defaultMaxSyncBatches {
                try Task.checkCancellation()
                let anchored = try await anchoredRunningWorkouts(from: currentAnchor)
                let canonical = await HealthKitWorkoutMapper.normalize(
                    anchored.workouts,
                    store: store,
                    detailedEvidenceLimit: 0,
                    probeRoutesWhenEvidenceMissing: false
                )
                let batch = HealthKitWorkoutSyncResult(
                    authorizationState: .partial,
                    fetchedWorkouts: DuplicateDetector.markDuplicates(canonical),
                    deletedWorkoutIDs: anchored.deletedWorkoutIDs,
                    newAnchor: anchored.anchor,
                    healthContext: HealthContext(),
                    message: syncMessage(fetchedCount: canonical.count, deletedCount: anchored.deletedWorkoutIDs.count)
                )
                batches.append(batch)
                currentAnchor = anchored.anchor
                if canonical.count + anchored.deletedWorkoutIDs.count < Self.defaultSyncBatchLimit {
                    break
                }
                await Task.yield()
            }

            let healthContext = await healthKitService.loadHealthContext()
            if var last = batches.popLast() {
                last.healthContext = healthContext
                batches.append(last)
            }
            return batches
        } catch {
            return [HealthKitWorkoutSyncResult(authorizationState: .error, message: "Could not sync HealthKit running workouts.")]
        }
    }

    public func startObservingRunningWorkoutChanges(
        _ handler: @escaping @MainActor @Sendable () async -> Void
    ) async -> HealthKitWorkoutSyncResult {
        guard HKHealthStore.isHealthDataAvailable() else {
            return HealthKitWorkoutSyncResult(authorizationState: .unavailable, message: "HealthKit is not available on this device.")
        }
        // RunningAnalysisStore registers observation only after its explicit
        // authorization/import path is ready. Re-requesting here can cause a
        // redundant authorization cycle immediately after first import.

        let workoutType = HKObjectType.workoutType()
        if observerQuery == nil {
            let predicate = HKQuery.predicateForWorkouts(with: .running)
            let query = HKObserverQuery(sampleType: workoutType, predicate: predicate) { _, completionHandler, error in
                guard error == nil else {
                    completionHandler()
                    return
                }
                nonisolated(unsafe) let finish = completionHandler
                Task {
                    await handler()
                    finish()
                }
            }
            observerQuery = query
            store.execute(query)
        }

        do {
            try await enableBackgroundDelivery(for: workoutType)
            return HealthKitWorkoutSyncResult(
                authorizationState: .partial,
                message: "HealthKit background delivery is registered for running workout summaries."
            )
        } catch {
            return HealthKitWorkoutSyncResult(
                authorizationState: .error,
                message: "Automatic background updates are unavailable. RunSignal will refresh HealthKit when you open the app."
            )
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

    private func enableBackgroundDelivery(for type: HKObjectType) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, any Error>) in
            store.enableBackgroundDelivery(for: type, frequency: .immediate) { success, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                if success {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: CocoaError(.featureUnsupported))
                }
            }
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
