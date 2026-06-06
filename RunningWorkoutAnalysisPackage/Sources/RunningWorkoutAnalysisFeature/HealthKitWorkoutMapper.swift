import Foundation
@preconcurrency import HealthKit

enum HealthKitWorkoutMapper {
    static func normalize(_ workouts: [HKWorkout], store: HKHealthStore) async -> [CanonicalWorkout] {
        var normalized: [CanonicalWorkout] = []
        for workout in workouts {
            let routeAvailable = await hasRoute(for: workout, store: store)
            var canonical = CanonicalWorkout(
                id: workout.uuid.uuidString,
                sourceID: workout.uuid.uuidString,
                sourceName: workout.sourceRevision.source.name,
                startDate: workout.startDate,
                endDate: workout.endDate,
                environment: inferEnvironment(workout: workout, routeAvailable: routeAvailable),
                distanceMeters: quantity(workout, .distanceWalkingRunning, unit: .meter()),
                durationSeconds: workout.duration,
                averageHeartRate: quantity(workout, .heartRate, unit: HKUnit.count().unitDivided(by: .minute()), option: .discreteAverage),
                maxHeartRate: quantity(workout, .heartRate, unit: HKUnit.count().unitDivided(by: .minute()), option: .discreteMax),
                averageCadence: quantity(workout, .stepCount, unit: HKUnit.count().unitDivided(by: .minute()), option: .discreteAverage),
                averagePower: quantity(workout, .runningPower, unit: .watt(), option: .discreteAverage),
                strideLengthMeters: quantity(workout, .runningStrideLength, unit: .meter(), option: .discreteAverage),
                verticalOscillationCentimeters: quantity(workout, .runningVerticalOscillation, unit: HKUnit.meterUnit(with: .centi), option: .discreteAverage),
                groundContactMilliseconds: quantity(workout, .runningGroundContactTime, unit: HKUnit.secondUnit(with: .milli), option: .discreteAverage),
                routeAvailable: routeAvailable,
                seriesAvailable: hasSeriesCandidate(workout)
            )
            canonical.inferredRunType = RunClassifier.inferRunType(for: canonical)
            normalized.append(canonical)
        }
        return normalized
    }

    private static func hasRoute(for workout: HKWorkout, store: HKHealthStore) async -> Bool {
        let routeType = HKSeriesType.workoutRoute()
        let predicate = HKQuery.predicateForObjects(from: workout)
        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: routeType,
                predicate: predicate,
                limit: 1,
                sortDescriptors: nil
            ) { _, samples, _ in
                continuation.resume(returning: !(samples ?? []).isEmpty)
            }
            store.execute(query)
        }
    }

    private static func quantity(
        _ workout: HKWorkout,
        _ identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        option: QuantityOption = .sum
    ) -> Double? {
        guard let type = HKObjectType.quantityType(forIdentifier: identifier),
              let statistics = workout.statistics(for: type) else {
            return nil
        }
        switch option {
        case .sum:
            return statistics.sumQuantity()?.doubleValue(for: unit)
        case .discreteAverage:
            return statistics.averageQuantity()?.doubleValue(for: unit)
        case .discreteMax:
            return statistics.maximumQuantity()?.doubleValue(for: unit)
        }
    }

    private static func inferEnvironment(workout: HKWorkout, routeAvailable: Bool) -> RunEnvironment {
        if let indoor = workout.metadata?[HKMetadataKeyIndoorWorkout] as? Bool {
            return indoor ? .indoor : .outdoor
        }
        return routeAvailable ? .outdoor : .unknown
    }

    private static func hasSeriesCandidate(_ workout: HKWorkout) -> Bool {
        workout.duration > 60 && quantity(workout, .heartRate, unit: HKUnit.count().unitDivided(by: .minute()), option: .discreteAverage) != nil
    }
}

enum QuantityOption {
    case sum
    case discreteAverage
    case discreteMax

    var statisticsOptions: HKStatisticsOptions {
        switch self {
        case .sum: .cumulativeSum
        case .discreteAverage: .discreteAverage
        case .discreteMax: .discreteMax
        }
    }

    func quantity(from statistics: HKStatistics?) -> HKQuantity? {
        switch self {
        case .sum: statistics?.sumQuantity()
        case .discreteAverage: statistics?.averageQuantity()
        case .discreteMax: statistics?.maximumQuantity()
        }
    }
}
