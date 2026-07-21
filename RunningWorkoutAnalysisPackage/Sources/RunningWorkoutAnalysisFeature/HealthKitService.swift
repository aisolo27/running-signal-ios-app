import Foundation
@preconcurrency import HealthKit

public struct HealthKitLoadResult: Sendable {
    public var authorizationState: AuthorizationState
    public var workouts: [CanonicalWorkout]
    public var healthContext: HealthContext
    public var message: String?
}

public protocol HealthKitServicing: AnyObject, Sendable {
    var isAvailable: Bool { get }

    func requestAuthorization() async -> AuthorizationState
    func loadRunningWorkouts() async -> HealthKitLoadResult
    func loadRunningWorkouts(
        startDate: Date?,
        endDate: Date?,
        detailedEvidenceLimit: Int,
        probeRoutesWhenEvidenceMissing: Bool
    ) async -> HealthKitLoadResult
    func loadRunningWorkouts(
        startDate: Date?,
        endDate: Date?,
        detailedEvidenceLimit: Int,
        probeRoutesWhenEvidenceMissing: Bool,
        requestsAuthorization: Bool,
        loadsHealthContext: Bool
    ) async -> HealthKitLoadResult
    func enrichRunningWorkouts(ids: [String]) async -> HealthKitLoadResult
    func loadBestEffortEvidence(ids: [String]) async -> HealthKitLoadResult
    func loadHealthContext() async -> HealthContext
    func earliestPermittedSampleDate() async -> Date?
}

public extension HealthKitServicing {
    func loadRunningWorkouts(
        startDate: Date?,
        endDate: Date?,
        detailedEvidenceLimit: Int,
        probeRoutesWhenEvidenceMissing: Bool,
        requestsAuthorization: Bool,
        loadsHealthContext: Bool
    ) async -> HealthKitLoadResult {
        await loadRunningWorkouts(
            startDate: startDate,
            endDate: endDate,
            detailedEvidenceLimit: detailedEvidenceLimit,
            probeRoutesWhenEvidenceMissing: probeRoutesWhenEvidenceMissing
        )
    }

    func earliestPermittedSampleDate() async -> Date? { nil }

    func loadBestEffortEvidence(ids: [String]) async -> HealthKitLoadResult {
        await enrichRunningWorkouts(ids: ids)
    }
}

public final class HealthKitService: HealthKitServicing, @unchecked Sendable {
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
            // HealthKit confirms that the authorization sheet completed, but it
            // intentionally does not disclose whether every read type was granted.
            return .partial
        } catch {
            return .error
        }
    }

    public func loadRunningWorkouts() async -> HealthKitLoadResult {
        await loadRunningWorkouts(
            startDate: nil,
            endDate: nil,
            detailedEvidenceLimit: Self.defaultDetailedEvidenceLimit,
            probeRoutesWhenEvidenceMissing: true
        )
    }

    public func loadRunningWorkouts(
        startDate: Date?,
        endDate: Date?,
        detailedEvidenceLimit: Int,
        probeRoutesWhenEvidenceMissing: Bool
    ) async -> HealthKitLoadResult {
        await loadRunningWorkouts(
            startDate: startDate,
            endDate: endDate,
            detailedEvidenceLimit: detailedEvidenceLimit,
            probeRoutesWhenEvidenceMissing: probeRoutesWhenEvidenceMissing,
            requestsAuthorization: true,
            loadsHealthContext: true
        )
    }

    public func loadRunningWorkouts(
        startDate: Date?,
        endDate: Date?,
        detailedEvidenceLimit: Int,
        probeRoutesWhenEvidenceMissing: Bool,
        requestsAuthorization: Bool,
        loadsHealthContext: Bool
    ) async -> HealthKitLoadResult {
        guard isAvailable else {
            return HealthKitLoadResult(authorizationState: .unavailable, workouts: [], healthContext: HealthContext(), message: "HealthKit is not available on this device.")
        }

        if requestsAuthorization {
            let state = await requestAuthorization()
            guard state == .authorized || state == .partial else {
                return HealthKitLoadResult(authorizationState: state, workouts: [], healthContext: HealthContext(), message: "The HealthKit authorization request could not be completed.")
            }
        }

        do {
            let workouts = try await queryRunningWorkouts(startDate: startDate, endDate: endDate)
            let effortScores = try await queryWorkoutEffortScoresIfAvailable(for: workouts)
            let healthContext = loadsHealthContext ? await queryHealthContext() : HealthContext()
            let canonical = await HealthKitWorkoutMapper.normalize(
                workouts,
                store: store,
                detailedEvidenceLimit: detailedEvidenceLimit,
                probeRoutesWhenEvidenceMissing: probeRoutesWhenEvidenceMissing,
                workoutEffortScores: effortScores ?? [:],
                workoutEffortQuerySucceeded: effortScores != nil
            )
            return HealthKitLoadResult(
                authorizationState: .partial,
                workouts: DuplicateDetector.markDuplicates(canonical),
                healthContext: healthContext,
                message: canonical.isEmpty ? "HealthKit Loaded: no completed running workouts were returned." : nil
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
        guard state == .authorized || state == .partial else {
            return HealthKitLoadResult(authorizationState: state, workouts: [], healthContext: HealthContext(), message: "The HealthKit authorization request could not be completed.")
        }

        do {
            let workouts = try await queryRunningWorkouts(ids: ids)
            let effortScores = try await queryWorkoutEffortScoresIfAvailable(for: workouts)
            let canonical = await HealthKitWorkoutMapper.normalize(
                workouts,
                store: store,
                detailedEvidenceLimit: workouts.count,
                workoutEffortScores: effortScores ?? [:],
                workoutEffortQuerySucceeded: effortScores != nil
            )
            return HealthKitLoadResult(
                authorizationState: .partial,
                workouts: DuplicateDetector.markDuplicates(canonical),
                healthContext: HealthContext(),
                message: canonical.isEmpty ? "No matching HealthKit running workouts were found for enrichment." : "Enriched \(canonical.count) HealthKit running workouts."
            )
        } catch {
            return HealthKitLoadResult(authorizationState: .error, workouts: [], healthContext: HealthContext(), message: "Could not enrich HealthKit running workouts.")
        }
    }

    public func loadBestEffortEvidence(ids: [String]) async -> HealthKitLoadResult {
        guard isAvailable else {
            return HealthKitLoadResult(authorizationState: .unavailable, workouts: [], healthContext: HealthContext(), message: "Apple Health is not available on this device.")
        }

        do {
            let workouts = try await queryRunningWorkouts(ids: ids)
            let effortScores = try await queryWorkoutEffortScoresIfAvailable(for: workouts)
            var canonical = await HealthKitWorkoutMapper.normalize(
                workouts,
                store: store,
                detailedEvidenceLimit: 0,
                probeRoutesWhenEvidenceMissing: false,
                workoutEffortScores: effortScores ?? [:],
                workoutEffortQuerySucceeded: effortScores != nil
            )
            let evidenceService = WorkoutEvidenceService(store: store)
            for index in canonical.indices {
                guard let healthKitWorkout = workouts.first(where: {
                    $0.uuid.uuidString == canonical[index].id
                }) else { continue }
                canonical[index].evidence = await evidenceService.loadBestEffortEvidence(for: healthKitWorkout)
            }
            return HealthKitLoadResult(
                authorizationState: .partial,
                workouts: canonical,
                healthContext: HealthContext(),
                message: nil
            )
        } catch {
            return HealthKitLoadResult(
                authorizationState: .error,
                workouts: [],
                healthContext: HealthContext(),
                message: "Could not check Apple Health distance samples for Best Efforts."
            )
        }
    }

    public func loadHealthContext() async -> HealthContext {
        guard isAvailable else { return HealthContext() }
        return await queryHealthContext()
    }

    public func earliestPermittedSampleDate() async -> Date? {
        guard isAvailable else { return nil }
        return store.earliestPermittedSampleDate()
    }

    private var readTypes: Set<HKObjectType> {
        HealthKitPermissionCatalog.readTypes
    }

    private func queryRunningWorkouts(startDate: Date? = nil, endDate: Date? = nil) async throws -> [HKWorkout] {
        let predicate = HKQuery.predicateForWorkouts(with: .running)
        let finalPredicate: NSPredicate
        if startDate != nil || endDate != nil {
            let datePredicate = HKQuery.predicateForSamples(
                withStart: startDate,
                end: endDate,
                options: [.strictStartDate]
            )
            finalPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, datePredicate])
        } else {
            finalPredicate = predicate
        }
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: HKObjectType.workoutType(),
                predicate: finalPredicate,
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

    private func queryWorkoutEffortScoresIfAvailable(
        for workouts: [HKWorkout]
    ) async throws -> [String: Double]? {
        guard !workouts.isEmpty else { return [:] }
        guard #available(iOS 18.0, macOS 15.0, *) else { return nil }

        let workoutIDs = Set(workouts.map(\.uuid))
        let predicate = HKQuery.predicateForObjects(with: workoutIDs)
        let descriptor = HKWorkoutEffortRelationshipQueryDescriptor(
            predicate: predicate,
            anchor: nil,
            option: .mostRelevant
        )

        do {
            let result = try await descriptor.result(for: store)
            let userRatingIdentifier = HKQuantityTypeIdentifier.workoutEffortScore.rawValue
            var scores: [String: Double] = [:]

            for relationship in result.relationships where relationship.activity == nil {
                let sample = relationship.samples?
                    .compactMap { $0 as? HKQuantitySample }
                    .filter { $0.quantityType.identifier == userRatingIdentifier }
                    .max { $0.endDate < $1.endDate }
                guard let sample,
                      let score = WorkoutEffortScore.normalized(
                        sample.quantity.doubleValue(for: .appleEffortScore())
                      ) else { continue }
                scores[relationship.workout.uuid.uuidString] = score
            }
            return scores
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            // Effort is optional. A relationship-query failure must not block the
            // completed workout history or clear a previously cached rating.
            return nil
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
