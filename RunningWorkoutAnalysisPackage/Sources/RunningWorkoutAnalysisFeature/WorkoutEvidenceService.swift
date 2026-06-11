import CoreLocation
import Foundation
@preconcurrency import HealthKit

public final class WorkoutEvidenceService: @unchecked Sendable {
    private let store: HKHealthStore

    public init(store: HKHealthStore = HKHealthStore()) {
        self.store = store
    }

    public var isAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    public func loadEvidence(for workout: HKWorkout) async -> WorkoutEvidence {
        async let heartRate = quantitySeries(.heartRate, unit: HKUnit.count().unitDivided(by: .minute()), metric: .heartRate, unitLabel: "bpm", workout: workout)
        async let speed = quantitySeries(.runningSpeed, unit: HKUnit.meter().unitDivided(by: .second()), metric: .runningSpeed, unitLabel: "m/s", workout: workout)
        async let distance = quantitySeries(.distanceWalkingRunning, unit: .meter(), metric: .distance, unitLabel: "m", workout: workout)
        async let activeEnergy = quantitySeries(.activeEnergyBurned, unit: .kilocalorie(), metric: .activeEnergy, unitLabel: "kcal", workout: workout)
        async let basalEnergy = quantitySeries(.basalEnergyBurned, unit: .kilocalorie(), metric: .basalEnergy, unitLabel: "kcal", workout: workout)
        async let power = quantitySeries(.runningPower, unit: .watt(), metric: .runningPower, unitLabel: "W", workout: workout)
        async let cadence = stepCadenceSeries(for: workout)
        async let steps = quantitySeries(.stepCount, unit: .count(), metric: .stepCount, unitLabel: "steps", workout: workout)
        async let stride = quantitySeries(.runningStrideLength, unit: .meter(), metric: .strideLength, unitLabel: "m", workout: workout)
        async let vertical = quantitySeries(.runningVerticalOscillation, unit: HKUnit.meterUnit(with: .centi), metric: .verticalOscillation, unitLabel: "cm", workout: workout)
        async let ground = quantitySeries(.runningGroundContactTime, unit: HKUnit.secondUnit(with: .milli), metric: .groundContactTime, unitLabel: "ms", workout: workout)
        async let route = routePoints(for: workout)

        let loadedSeries = await [
            heartRate,
            speed,
            distance,
            activeEnergy,
            basalEnergy,
            power,
            cadence,
            steps,
            stride,
            vertical,
            ground
        ]

        let series = Dictionary(
            uniqueKeysWithValues: loadedSeries.compactMap { metricSeries -> (WorkoutEvidenceMetric, WorkoutMetricSeries)? in
                guard let metricSeries, !metricSeries.points.isEmpty else { return nil }
                return (metricSeries.metric, metricSeries)
            }
        )

        return await WorkoutEvidence(
            workoutID: workout.uuid.uuidString,
            loadedAt: Date(),
            series: series,
            route: route,
            events: evidenceEvents(for: workout)
        )
    }

    private func quantitySeries(
        _ identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        metric: WorkoutEvidenceMetric,
        unitLabel: String,
        workout: HKWorkout
    ) async -> WorkoutMetricSeries? {
        guard let type = HKObjectType.quantityType(forIdentifier: identifier) else {
            return nil
        }

        let predicate = HKQuery.predicateForObjects(from: workout)
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let associated = await quantitySamples(type: type, predicate: predicate, sort: sort, unit: unit)
        if !associated.isEmpty {
            return WorkoutMetricSeries(metric: metric, unit: unitLabel, points: associated)
        }

        let datePredicate = HKQuery.predicateForSamples(
            withStart: workout.startDate.addingTimeInterval(-2),
            end: workout.endDate.addingTimeInterval(2)
        )
        let sourcePredicate = HKQuery.predicateForObjects(from: workout.sourceRevision.source)
        let fallbackPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, sourcePredicate])
        let fallback = await quantitySamples(type: type, predicate: fallbackPredicate, sort: sort, unit: unit)
        return WorkoutMetricSeries(metric: metric, unit: unitLabel, points: fallback)
    }

    private func quantitySamples(
        type: HKQuantityType,
        predicate: NSPredicate,
        sort: NSSortDescriptor,
        unit: HKUnit
    ) async -> [WorkoutEvidencePoint] {
        await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: type,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sort]
            ) { _, samples, _ in
                let points = (samples as? [HKQuantitySample] ?? []).map {
                    WorkoutEvidencePoint(date: $0.startDate, value: $0.quantity.doubleValue(for: unit))
                }
                continuation.resume(returning: points)
            }
            store.execute(query)
        }
    }

    private func stepCadenceSeries(for workout: HKWorkout) async -> WorkoutMetricSeries? {
        guard let type = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            return nil
        }

        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let associated = await stepCadencePoints(type: type, predicate: HKQuery.predicateForObjects(from: workout), sort: sort)
        if !associated.isEmpty {
            return WorkoutMetricSeries(metric: .cadence, unit: "spm", points: associated)
        }

        let datePredicate = HKQuery.predicateForSamples(
            withStart: workout.startDate.addingTimeInterval(-2),
            end: workout.endDate.addingTimeInterval(2)
        )
        let sourcePredicate = HKQuery.predicateForObjects(from: workout.sourceRevision.source)
        let fallbackPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, sourcePredicate])
        let fallback = await stepCadencePoints(type: type, predicate: fallbackPredicate, sort: sort)
        return WorkoutMetricSeries(metric: .cadence, unit: "spm", points: fallback)
    }

    private func stepCadencePoints(
        type: HKQuantityType,
        predicate: NSPredicate,
        sort: NSSortDescriptor
    ) async -> [WorkoutEvidencePoint] {
        await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: type,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sort]
            ) { _, samples, _ in
                let points = (samples as? [HKQuantitySample] ?? []).compactMap { sample -> WorkoutEvidencePoint? in
                    let minutes = sample.endDate.timeIntervalSince(sample.startDate) / 60
                    guard minutes > 0 else { return nil }
                    let steps = sample.quantity.doubleValue(for: .count())
                    return WorkoutEvidencePoint(date: sample.startDate, value: steps / minutes)
                }
                continuation.resume(returning: points)
            }
            store.execute(query)
        }
    }

    private func routePoints(for workout: HKWorkout) async -> [WorkoutRoutePoint] {
        let routeType = HKSeriesType.workoutRoute()
        let predicate = HKQuery.predicateForObjects(from: workout)

        let routes = await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: routeType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: nil
            ) { _, samples, _ in
                continuation.resume(returning: samples as? [HKWorkoutRoute] ?? [])
            }
            store.execute(query)
        }

        var points: [WorkoutRoutePoint] = []
        for route in routes {
            points.append(contentsOf: await locations(for: route))
        }
        return points.sorted { $0.date < $1.date }
    }

    private func locations(for route: HKWorkoutRoute) async -> [WorkoutRoutePoint] {
        await withCheckedContinuation { continuation in
            let collector = RoutePointCollector()
            let query = HKWorkoutRouteQuery(route: route) { _, locations, done, _ in
                collector.append((locations ?? []).map(locationPoint))
                if done {
                    continuation.resume(returning: collector.points)
                }
            }
            store.execute(query)
        }
    }

    private func evidenceEvents(for workout: HKWorkout) -> [WorkoutEvidenceEvent] {
        (workout.workoutEvents ?? []).map { event in
            WorkoutEvidenceEvent(
                startDate: event.dateInterval.start,
                endDate: event.dateInterval.end,
                type: eventTypeLabel(event.type),
                label: eventLabel(event)
            )
        }
    }

    private func eventTypeLabel(_ type: HKWorkoutEventType) -> String {
        String(describing: type)
    }

    private func eventLabel(_ event: HKWorkoutEvent) -> String? {
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

private final class RoutePointCollector: @unchecked Sendable {
    private let lock = NSLock()
    private var storage: [WorkoutRoutePoint] = []

    var points: [WorkoutRoutePoint] {
        lock.lock()
        defer { lock.unlock() }
        return storage
    }

    func append(_ points: [WorkoutRoutePoint]) {
        lock.lock()
        storage.append(contentsOf: points)
        lock.unlock()
    }
}

private func locationPoint(_ location: CLLocation) -> WorkoutRoutePoint {
    WorkoutRoutePoint(
        date: location.timestamp,
        latitude: location.coordinate.latitude,
        longitude: location.coordinate.longitude,
        altitudeMeters: location.verticalAccuracy >= 0 ? location.altitude : nil,
        speedMetersPerSecond: location.speed >= 0 ? location.speed : nil
    )
}
