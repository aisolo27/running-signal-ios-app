import Foundation
@preconcurrency import HealthKit

public struct HealthKitLoadResult: Sendable {
    public var authorizationState: AuthorizationState
    public var workouts: [CanonicalWorkout]
    public var healthContext: HealthContext
    public var message: String?
}

public final class HealthKitService: @unchecked Sendable {
    private let store = HKHealthStore()
    public static let defaultDetailedEvidenceLimit = 20

    public init() {}

    public var isAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    public func requestAuthorization() async -> AuthorizationState {
        guard isAvailable else { return .unavailable }
        do {
            try await store.requestAuthorization(toShare: [], read: readTypes)
            return .authorized
        } catch {
            return .error
        }
    }

    public func loadRunningWorkouts() async -> HealthKitLoadResult {
        guard isAvailable else {
            return HealthKitLoadResult(authorizationState: .unavailable, workouts: [], healthContext: HealthContext(), message: "HealthKit is not available on this device.")
        }

        let state = await requestAuthorization()
        guard state == .authorized else {
            return HealthKitLoadResult(authorizationState: state, workouts: [], healthContext: HealthContext(), message: "HealthKit permission is not fully available.")
        }

        do {
            let workouts = try await queryRunningWorkouts()
            let healthContext = await queryHealthContext()
            let canonical = await HealthKitWorkoutMapper.normalize(
                workouts,
                store: store,
                detailedEvidenceLimit: Self.defaultDetailedEvidenceLimit
            )
            return HealthKitLoadResult(
                authorizationState: canonical.isEmpty ? .partial : .authorized,
                workouts: DuplicateDetector.markDuplicates(canonical),
                healthContext: healthContext,
                message: canonical.isEmpty ? "No HealthKit running workouts were returned. Sample data is still available for Simulator testing." : nil
            )
        } catch {
            return HealthKitLoadResult(authorizationState: .error, workouts: [], healthContext: HealthContext(), message: "Could not read HealthKit running workouts.")
        }
    }

    public func enrichRunningWorkouts(ids: [String]) async -> HealthKitLoadResult {
        guard isAvailable else {
            return HealthKitLoadResult(authorizationState: .unavailable, workouts: [], healthContext: HealthContext(), message: "HealthKit is not available on this device.")
        }

        let state = await requestAuthorization()
        guard state == .authorized else {
            return HealthKitLoadResult(authorizationState: state, workouts: [], healthContext: HealthContext(), message: "HealthKit permission is not fully available.")
        }

        do {
            let workouts = try await queryRunningWorkouts(ids: ids)
            let canonical = await HealthKitWorkoutMapper.normalize(
                workouts,
                store: store,
                detailedEvidenceLimit: workouts.count
            )
            return HealthKitLoadResult(
                authorizationState: canonical.isEmpty ? .partial : .authorized,
                workouts: DuplicateDetector.markDuplicates(canonical),
                healthContext: HealthContext(),
                message: canonical.isEmpty ? "No matching HealthKit running workouts were found for enrichment." : "Enriched \(canonical.count) HealthKit running workouts."
            )
        } catch {
            return HealthKitLoadResult(authorizationState: .error, workouts: [], healthContext: HealthContext(), message: "Could not enrich HealthKit running workouts.")
        }
    }

    public func loadHealthContext() async -> HealthContext {
        guard isAvailable else { return HealthContext() }
        return await queryHealthContext()
    }

    private var readTypes: Set<HKObjectType> {
        HealthKitPermissionCatalog.readTypes
    }

    private func queryRunningWorkouts() async throws -> [HKWorkout] {
        let predicate = HKQuery.predicateForWorkouts(with: .running)
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: HKObjectType.workoutType(),
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sort]
            ) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: samples as? [HKWorkout] ?? [])
            }
            store.execute(query)
        }
    }

    private func queryRunningWorkouts(ids: [String]) async throws -> [HKWorkout] {
        let uuids = Set(ids.compactMap(UUID.init(uuidString:)))
        guard !uuids.isEmpty else { return [] }

        let idPredicate = HKQuery.predicateForObjects(with: uuids)
        let runningPredicate = HKQuery.predicateForWorkouts(with: .running)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate, runningPredicate])
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: HKObjectType.workoutType(),
                predicate: predicate,
                limit: ids.count,
                sortDescriptors: [sort]
            ) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: samples as? [HKWorkout] ?? [])
            }
            store.execute(query)
        }
    }

    private func queryHealthContext(now: Date = Date()) async -> HealthContext {
        let vo2Unit = HKUnit.literUnit(with: .milli)
            .unitDivided(by: HKUnit.gramUnit(with: .kilo).unitMultiplied(by: .minute()))

        async let vo2Max = latestQuantity(.vo2Max, unit: vo2Unit, now: now)
        async let restingHeartRate = latestQuantity(.restingHeartRate, unit: HKUnit.count().unitDivided(by: .minute()), now: now)
        async let averageHeartRate = statistics(.heartRate, unit: HKUnit.count().unitDivided(by: .minute()), option: .discreteAverage, now: now)
        async let maxHeartRate = statistics(.heartRate, unit: HKUnit.count().unitDivided(by: .minute()), option: .discreteMax, now: now)
        async let activeEnergy = statistics(.activeEnergyBurned, unit: .kilocalorie(), option: .sum, now: now)

        return await HealthContext(
            vo2Max: vo2Max,
            restingHeartRate: restingHeartRate,
            averageHeartRate: averageHeartRate,
            maxHeartRate: maxHeartRate,
            activeEnergyKilocaloriesTotal: activeEnergy
        )
    }

    private func latestQuantity(
        _ identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        now: Date
    ) async -> Double? {
        guard let type = HKObjectType.quantityType(forIdentifier: identifier) else {
            return nil
        }

        let predicate = HKQuery.predicateForSamples(withStart: nil, end: now)
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: type,
                predicate: predicate,
                limit: 1,
                sortDescriptors: [sort]
            ) { _, samples, _ in
                let value = (samples?.first as? HKQuantitySample)?.quantity.doubleValue(for: unit)
                continuation.resume(returning: value)
            }
            store.execute(query)
        }
    }

    private func statistics(
        _ identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        option: QuantityOption,
        now: Date
    ) async -> Double? {
        guard let type = HKObjectType.quantityType(forIdentifier: identifier) else {
            return nil
        }

        let predicate = HKQuery.predicateForSamples(withStart: nil, end: now)
        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: option.statisticsOptions) { _, statistics, _ in
                continuation.resume(returning: option.quantity(from: statistics)?.doubleValue(for: unit))
            }
            store.execute(query)
        }
    }

}
