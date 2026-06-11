import Foundation
@preconcurrency import HealthKit

enum HealthKitWorkoutMapper {
    static func normalize(_ workouts: [HKWorkout], store: HKHealthStore, detailedEvidenceLimit: Int = 20) async -> [CanonicalWorkout] {
        var normalized: [CanonicalWorkout] = []
        let evidenceService = WorkoutEvidenceService(store: store)
        let detailWorkoutIDs = Set(workouts.prefix(detailedEvidenceLimit).map(\.uuid))
        for workout in workouts {
            let shouldLoadDetail = detailWorkoutIDs.contains(workout.uuid)
            let evidence = shouldLoadDetail
                ? await evidenceService.loadEvidence(for: workout)
                : WorkoutEvidence(workoutID: workout.uuid.uuidString)
            let routeAvailable = if !evidence.route.isEmpty {
                true
            } else {
                await hasRoute(for: workout, store: store)
            }
            var canonical = CanonicalWorkout(
                id: workout.uuid.uuidString,
                sourceID: workout.uuid.uuidString,
                sourceName: workout.sourceRevision.source.name,
                deviceName: deviceName(workout),
                startDate: workout.startDate,
                endDate: workout.endDate,
                environment: inferEnvironment(workout: workout, routeAvailable: routeAvailable),
                distanceMeters: workout.totalDistance?.doubleValue(for: .meter())
                    ?? quantity(workout, .distanceWalkingRunning, unit: .meter())
                    ?? evidence.sum(.distance),
                durationSeconds: workout.duration,
                elapsedSeconds: workout.endDate.timeIntervalSince(workout.startDate),
                activeEnergyKilocalories: quantity(workout, .activeEnergyBurned, unit: .kilocalorie())
                    ?? evidence.sum(.activeEnergy),
                totalEnergyKilocalories: nil,
                elevationGainMeters: evidence.elevationGainMeters,
                averageHeartRate: quantity(workout, .heartRate, unit: HKUnit.count().unitDivided(by: .minute()), option: .discreteAverage) ?? evidence.average(.heartRate),
                maxHeartRate: quantity(workout, .heartRate, unit: HKUnit.count().unitDivided(by: .minute()), option: .discreteMax) ?? evidence.maximum(.heartRate),
                averageCadence: evidence.average(.cadence),
                averagePower: quantity(workout, .runningPower, unit: .watt(), option: .discreteAverage) ?? evidence.average(.runningPower),
                strideLengthMeters: quantity(workout, .runningStrideLength, unit: .meter(), option: .discreteAverage) ?? evidence.average(.strideLength),
                verticalOscillationCentimeters: quantity(workout, .runningVerticalOscillation, unit: HKUnit.meterUnit(with: .centi), option: .discreteAverage) ?? evidence.average(.verticalOscillation),
                groundContactMilliseconds: quantity(workout, .runningGroundContactTime, unit: HKUnit.secondUnit(with: .milli), option: .discreteAverage) ?? evidence.average(.groundContactTime),
                routeAvailable: routeAvailable,
                seriesAvailable: hasSeriesCandidate(workout) || evidence.seriesSampleCount > 0,
                routePointCount: evidence.route.count,
                seriesSampleCount: evidence.seriesSampleCount,
                heartRateSampleCount: evidence.sampleCount(.heartRate),
                runningSpeedSampleCount: evidence.sampleCount(.runningSpeed),
                distanceSampleCount: evidence.sampleCount(.distance),
                activeEnergySampleCount: evidence.sampleCount(.activeEnergy),
                runningPowerSampleCount: evidence.sampleCount(.runningPower),
                cadenceSampleCount: evidence.sampleCount(.cadence),
                stepCountSampleCount: evidence.sampleCount(.stepCount),
                strideLengthSampleCount: evidence.sampleCount(.strideLength),
                verticalOscillationSampleCount: evidence.sampleCount(.verticalOscillation),
                groundContactTimeSampleCount: evidence.sampleCount(.groundContactTime),
                intervalCount: intervalEvents(workout).count,
                intervalLabelsSummary: intervalLabelsSummary(workout),
                evidence: shouldLoadDetail ? evidence : nil
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

    private static func deviceName(_ workout: HKWorkout) -> String? {
        let device = workout.device
        return [
            device?.name,
            device?.manufacturer,
            device?.model
        ]
        .compactMap { $0 }
        .filter { !$0.isEmpty }
        .joined(separator: " ")
        .nilIfEmpty
    }

    private static func hasSeriesCandidate(_ workout: HKWorkout) -> Bool {
        workout.duration > 60 && quantity(workout, .heartRate, unit: HKUnit.count().unitDivided(by: .minute()), option: .discreteAverage) != nil
    }

    private static func intervalEvents(_ workout: HKWorkout) -> [HKWorkoutEvent] {
        (workout.workoutEvents ?? []).filter { event in
            event.type == .segment || event.type == .lap
        }
    }

    private static func intervalLabelsSummary(_ workout: HKWorkout) -> String? {
        let labels = intervalEvents(workout).compactMap(intervalLabel)
        let uniqueLabels = Array(NSOrderedSet(array: labels)) as? [String] ?? labels
        guard !uniqueLabels.isEmpty else { return nil }
        return uniqueLabels.prefix(6).joined(separator: ", ")
    }

    private static func intervalLabel(_ event: HKWorkoutEvent) -> String? {
        guard let metadata = event.metadata else { return nil }
        let preferredKeys = [
            HKMetadataKeyWorkoutBrandName,
            "HKWorkoutSegmentName",
            "WorkoutSegmentName",
            "segmentName",
            "name",
            "label"
        ]

        for key in preferredKeys {
            if let value = metadata[key] as? String, !value.isEmpty {
                return value
            }
        }

        return metadata.values.compactMap { value -> String? in
            guard let label = value as? String, !label.isEmpty else { return nil }
            return label
        }.first
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

private extension String {
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}
