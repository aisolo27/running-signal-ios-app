import CoreLocation
import Foundation
@preconcurrency import HealthKit
#if canImport(WorkoutKit)
import WorkoutKit
#endif

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
        async let planAudit = workoutPlanAudit(for: workout)

        let activityResult = evidenceActivities(for: workout)
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
        let routeResult = await route
        let planAuditResult = await planAudit

        let series = Dictionary(
            uniqueKeysWithValues: loadedSeries.compactMap { result -> (WorkoutEvidenceMetric, WorkoutMetricSeries)? in
                guard let metricSeries = result.series, !metricSeries.points.isEmpty else { return nil }
                return (metricSeries.metric, metricSeries)
            }
        )
        let diagnostics = WorkoutEvidenceDiagnostics(
            queryDiagnostics: loadedSeries.map(\.diagnostic) + [
                routeResult.diagnostic,
                planAuditResult.diagnostic,
                activityResult.diagnostic
            ]
        )

        return WorkoutEvidence(
            workoutID: workout.uuid.uuidString,
            loadedAt: Date(),
            series: series,
            route: routeResult.points,
            events: evidenceEvents(for: workout),
            activities: activityResult.activities,
            workoutPlanAudit: planAuditResult.audit,
            diagnostics: diagnostics
        )
    }

    private func quantitySeries(
        _ identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        metric: WorkoutEvidenceMetric,
        unitLabel: String,
        workout: HKWorkout
    ) async -> MetricLoadResult {
        guard let type = HKObjectType.quantityType(forIdentifier: identifier) else {
            return MetricLoadResult(
                series: nil,
                diagnostic: WorkoutEvidenceQueryDiagnostic(
                    name: metric.rawValue,
                    status: .unavailable,
                    count: 0,
                    message: "HealthKit quantity type is unavailable."
                )
            )
        }

        let predicate = HKQuery.predicateForObjects(from: workout)
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let associated = await quantitySamples(type: type, predicate: predicate, sort: sort, unit: unit, sampleSource: .associatedWorkout)
        if !associated.isEmpty {
            return MetricLoadResult(
                series: WorkoutMetricSeries(metric: metric, unit: unitLabel, points: associated.points),
                diagnostic: WorkoutEvidenceQueryDiagnostic(name: metric.rawValue, status: .loaded, count: associated.points.count)
            )
        }

        let datePredicate = HKQuery.predicateForSamples(
            withStart: workout.startDate.addingTimeInterval(-2),
            end: workout.endDate.addingTimeInterval(2)
        )
        let sourcePredicate = HKQuery.predicateForObjects(from: workout.sourceRevision.source)
        let fallbackPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, sourcePredicate])
        let fallback = await quantitySamples(type: type, predicate: fallbackPredicate, sort: sort, unit: unit, sampleSource: .sourceDateFallback)
        let errors = [associated.errorMessage, fallback.errorMessage].compactMap { $0 }.joined(separator: " ")
        let message: String?
        if !fallback.points.isEmpty {
            message = "Using source/date fallback samples; associated workout samples were unavailable."
        } else if !errors.isEmpty {
            message = errors
        } else {
            message = "No associated or source/date fallback samples returned."
        }
        return MetricLoadResult(
            series: WorkoutMetricSeries(metric: metric, unit: unitLabel, points: fallback.points),
            diagnostic: WorkoutEvidenceQueryDiagnostic(
                name: metric.rawValue,
                status: fallback.points.isEmpty ? (errors.isEmpty ? .unavailable : .failed) : .loaded,
                count: fallback.points.count,
                message: message
            )
        )
    }

    private func quantitySamples(
        type: HKQuantityType,
        predicate: NSPredicate,
        sort: NSSortDescriptor,
        unit: HKUnit,
        sampleSource: WorkoutEvidenceSampleSource
    ) async -> SampleQueryResult {
        await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: type,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sort]
            ) { _, samples, error in
                let points = (samples as? [HKQuantitySample] ?? []).map {
                    Self.evidencePoint(sample: $0, unit: unit, sampleSource: sampleSource)
                }
                continuation.resume(returning: SampleQueryResult(points: points, errorMessage: error.map { String(describing: $0) }))
            }
            store.execute(query)
        }
    }

    private func stepCadenceSeries(for workout: HKWorkout) async -> MetricLoadResult {
        guard let type = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            return MetricLoadResult(
                series: nil,
                diagnostic: WorkoutEvidenceQueryDiagnostic(
                    name: WorkoutEvidenceMetric.cadence.rawValue,
                    status: .unavailable,
                    count: 0,
                    message: "Step count type is unavailable for cadence derivation."
                )
            )
        }

        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let associated = await stepCadencePoints(type: type, predicate: HKQuery.predicateForObjects(from: workout), sort: sort, sampleSource: .associatedWorkout)
        if !associated.isEmpty {
            return MetricLoadResult(
                series: WorkoutMetricSeries(metric: .cadence, unit: "spm", points: associated.points),
                diagnostic: WorkoutEvidenceQueryDiagnostic(name: WorkoutEvidenceMetric.cadence.rawValue, status: .loaded, count: associated.points.count)
            )
        }

        let datePredicate = HKQuery.predicateForSamples(
            withStart: workout.startDate.addingTimeInterval(-2),
            end: workout.endDate.addingTimeInterval(2)
        )
        let sourcePredicate = HKQuery.predicateForObjects(from: workout.sourceRevision.source)
        let fallbackPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, sourcePredicate])
        let fallback = await stepCadencePoints(type: type, predicate: fallbackPredicate, sort: sort, sampleSource: .sourceDateFallback)
        let errors = [associated.errorMessage, fallback.errorMessage].compactMap { $0 }.joined(separator: " ")
        return MetricLoadResult(
            series: WorkoutMetricSeries(metric: .cadence, unit: "spm", points: fallback.points),
            diagnostic: WorkoutEvidenceQueryDiagnostic(
                name: WorkoutEvidenceMetric.cadence.rawValue,
                status: fallback.points.isEmpty ? (errors.isEmpty ? .unavailable : .failed) : .loaded,
                count: fallback.points.count,
                message: fallback.points.isEmpty ? (errors.isEmpty ? "No step samples returned for cadence derivation." : errors) : "Using source/date fallback step samples for cadence derivation."
            )
        )
    }

    private func stepCadencePoints(
        type: HKQuantityType,
        predicate: NSPredicate,
        sort: NSSortDescriptor,
        sampleSource: WorkoutEvidenceSampleSource
    ) async -> SampleQueryResult {
        await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: type,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sort]
            ) { _, samples, error in
                let points = (samples as? [HKQuantitySample] ?? []).compactMap { sample -> WorkoutEvidencePoint? in
                    let minutes = sample.endDate.timeIntervalSince(sample.startDate) / 60
                    guard minutes > 0 else { return nil }
                    let steps = sample.quantity.doubleValue(for: .count())
                    return Self.evidencePoint(
                        sample: sample,
                        unit: .count(),
                        value: steps / minutes,
                        sampleSource: sampleSource,
                        representativeDate: sample.startDate
                    )
                }
                continuation.resume(returning: SampleQueryResult(points: points, errorMessage: error.map { String(describing: $0) }))
            }
            store.execute(query)
        }
    }

    private func routePoints(for workout: HKWorkout) async -> RouteLoadResult {
        let routeType = HKSeriesType.workoutRoute()
        let predicate = HKQuery.predicateForObjects(from: workout)

        let routeQueryResult: RouteQueryResult = await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: routeType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: nil
            ) { _, samples, error in
                continuation.resume(returning: RouteQueryResult(routes: samples as? [HKWorkoutRoute] ?? [], errorMessage: error.map { String(describing: $0) }))
            }
            store.execute(query)
        }

        var points: [WorkoutRoutePoint] = []
        for route in routeQueryResult.routes {
            points.append(contentsOf: await locations(for: route))
        }
        let sorted = points.sorted { $0.date < $1.date }
        let message: String?
        if let error = routeQueryResult.errorMessage {
            message = error
        } else if routeQueryResult.routes.isEmpty {
            message = "No workout routes returned."
        } else if sorted.isEmpty {
            message = "Workout route objects returned no locations."
        } else {
            message = nil
        }
        return RouteLoadResult(
            points: sorted,
            diagnostic: WorkoutEvidenceQueryDiagnostic(
                name: "route",
                status: sorted.isEmpty ? (routeQueryResult.errorMessage == nil ? .unavailable : .failed) : .loaded,
                count: sorted.count,
                message: message
            )
        )
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
            evidenceEvent(from: event)
        }
    }

    private func evidenceEvent(from event: HKWorkoutEvent) -> WorkoutEvidenceEvent {
        WorkoutEvidenceEvent(
            startDate: event.dateInterval.start,
            endDate: event.dateInterval.end,
            type: eventTypeLabel(event.type),
            kind: eventKind(event.type),
            label: eventLabel(event),
            metadataKeys: event.metadata.map { metadata in
                metadata.keys.map { String(describing: $0) }.sorted()
            }
        )
    }

    private func evidenceActivities(for workout: HKWorkout) -> ActivityLoadResult {
        if #available(iOS 16.0, macOS 13.0, macCatalyst 16.0, watchOS 9.0, *) {
            let activities = workout.workoutActivities.map { activity in
                WorkoutEvidenceActivity(
                    id: activity.uuid.uuidString,
                    activityType: String(describing: activity.workoutConfiguration.activityType),
                    locationType: String(describing: activity.workoutConfiguration.locationType),
                    startDate: activity.startDate,
                    endDate: activity.endDate,
                    durationSeconds: activity.duration,
                    metadataKeys: activity.metadata.map { metadata in
                        metadata.keys.map { String(describing: $0) }.sorted()
                    },
                    events: activity.workoutEvents.map(evidenceEvent(from:)),
                    statistics: activityStatistics(activity.allStatistics)
                )
            }
            return ActivityLoadResult(
                activities: activities,
                diagnostic: WorkoutEvidenceQueryDiagnostic(
                    name: "workoutActivities",
                    status: .loaded,
                    count: activities.count,
                    message: activities.isEmpty ? "No HKWorkoutActivity records returned." : nil
                )
            )
        }

        return ActivityLoadResult(
            activities: [],
            diagnostic: WorkoutEvidenceQueryDiagnostic(
                name: "workoutActivities",
                status: .unavailable,
                count: 0,
                message: "HKWorkout.workoutActivities is unavailable on this OS."
            )
        )
    }

    @available(iOS 16.0, macOS 13.0, macCatalyst 16.0, watchOS 9.0, *)
    private func activityStatistics(_ statistics: [HKQuantityType: HKStatistics]) -> [WorkoutEvidenceActivityStatistic] {
        statistics
            .sorted { $0.key.identifier < $1.key.identifier }
            .map { quantityType, statistic in
                let displayUnit = activityStatisticUnit(for: quantityType.identifier)
                return WorkoutEvidenceActivityStatistic(
                    quantityType: quantityType.identifier,
                    unit: displayUnit?.label,
                    startDate: statistic.startDate,
                    endDate: statistic.endDate,
                    sourceCount: statistic.sources?.count ?? 0,
                    sum: displayUnit.flatMap { statistic.sumQuantity()?.doubleValue(for: $0.unit) },
                    average: displayUnit.flatMap { statistic.averageQuantity()?.doubleValue(for: $0.unit) },
                    minimum: displayUnit.flatMap { statistic.minimumQuantity()?.doubleValue(for: $0.unit) },
                    maximum: displayUnit.flatMap { statistic.maximumQuantity()?.doubleValue(for: $0.unit) },
                    durationSeconds: statistic.duration()?.doubleValue(for: .second())
                )
            }
    }

    private func activityStatisticUnit(for identifier: String) -> (unit: HKUnit, label: String)? {
        switch HKQuantityTypeIdentifier(rawValue: identifier) {
        case .heartRate:
            (HKUnit.count().unitDivided(by: .minute()), "bpm")
        case .runningSpeed:
            (HKUnit.meter().unitDivided(by: .second()), "m/s")
        case .distanceWalkingRunning, .distanceCycling, .distanceSwimming, .distanceDownhillSnowSports:
            (.meter(), "m")
        case .activeEnergyBurned, .basalEnergyBurned:
            (.kilocalorie(), "kcal")
        case .runningPower:
            (.watt(), "W")
        case .stepCount:
            (.count(), "count")
        case .runningStrideLength:
            (.meter(), "m")
        case .runningVerticalOscillation:
            (HKUnit.meterUnit(with: .centi), "cm")
        case .runningGroundContactTime:
            (HKUnit.secondUnit(with: .milli), "ms")
        default:
            nil
        }
    }

    private static func evidencePoint(
        sample: HKQuantitySample,
        unit: HKUnit,
        value: Double? = nil,
        sampleSource: WorkoutEvidenceSampleSource,
        representativeDate: Date? = nil
    ) -> WorkoutEvidencePoint {
        WorkoutEvidencePoint(
            date: representativeDate ?? sample.startDate,
            value: value ?? sample.quantity.doubleValue(for: unit),
            startDate: sample.startDate,
            endDate: sample.endDate,
            sampleSource: sampleSource,
            sourceName: sample.sourceRevision.source.name,
            sourceVersion: sample.sourceRevision.version,
            deviceName: deviceName(sample.device),
            metadataKeys: sample.metadata.map { $0.keys.map { String(describing: $0) }.sorted() } ?? []
        )
    }

    private static func deviceName(_ device: HKDevice?) -> String? {
        let value = [
            device?.name,
            device?.manufacturer,
            device?.model,
            device?.hardwareVersion,
            device?.softwareVersion
        ]
        .compactMap { $0 }
        .filter { !$0.isEmpty }
        .joined(separator: " ")
        return value.isEmpty ? nil : value
    }

    private func eventTypeLabel(_ type: HKWorkoutEventType) -> String {
        eventKind(type).rawValue
    }

    private func eventKind(_ type: HKWorkoutEventType) -> WorkoutEvidenceEventKind {
        switch type {
        case .pause: .pause
        case .resume: .resume
        case .lap: .lap
        case .marker: .marker
        case .motionPaused: .motionPaused
        case .motionResumed: .motionResumed
        case .segment: .segment
        case .pauseOrResumeRequest: .pauseOrResumeRequest
        @unknown default: .unknown
        }
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

    private func workoutPlanAudit(for workout: HKWorkout) async -> PlanAuditLoadResult {
        #if canImport(WorkoutKit)
        if #available(iOS 17.0, macOS 15.0, macCatalyst 18.0, watchOS 10.0, *) {
            do {
                guard let plan = try await workout.workoutPlan else {
                    let audit = WorkoutPlanAudit(
                        status: .unavailable,
                        summaryLines: ["WorkoutKit returned no workout plan for this completed workout."]
                    )
                    return PlanAuditLoadResult(
                        audit: audit,
                        diagnostic: WorkoutEvidenceQueryDiagnostic(name: "workoutKitPlan", status: .unavailable, count: 0, message: audit.summaryLines.first)
                    )
                }
                let audit = WorkoutKitPlanAuditFormatter.audit(plan)
                return PlanAuditLoadResult(
                    audit: audit,
                    diagnostic: WorkoutEvidenceQueryDiagnostic(name: "workoutKitPlan", status: .loaded, count: audit.plannedSteps.count)
                )
            } catch {
                let audit = WorkoutPlanAudit(
                    status: .failed,
                    summaryLines: ["WorkoutKit lookup failed; keep interval UI gated."],
                    errorMessage: String(describing: error)
                )
                return PlanAuditLoadResult(
                    audit: audit,
                    diagnostic: WorkoutEvidenceQueryDiagnostic(name: "workoutKitPlan", status: .failed, count: 0, message: audit.errorMessage)
                )
            }
        }
        #endif

        let audit = WorkoutPlanAudit(
            status: .unsupported,
            summaryLines: ["WorkoutKit workout plan lookup is not available on this OS or SDK."]
        )
        return PlanAuditLoadResult(
            audit: audit,
            diagnostic: WorkoutEvidenceQueryDiagnostic(name: "workoutKitPlan", status: .unavailable, count: 0, message: audit.summaryLines.first)
        )
    }
}

private struct MetricLoadResult {
    var series: WorkoutMetricSeries?
    var diagnostic: WorkoutEvidenceQueryDiagnostic
}

private struct SampleQueryResult {
    var points: [WorkoutEvidencePoint]
    var errorMessage: String?

    var isEmpty: Bool {
        points.isEmpty
    }
}

private struct RouteQueryResult {
    var routes: [HKWorkoutRoute]
    var errorMessage: String?
}

private struct RouteLoadResult {
    var points: [WorkoutRoutePoint]
    var diagnostic: WorkoutEvidenceQueryDiagnostic
}

private struct PlanAuditLoadResult {
    var audit: WorkoutPlanAudit
    var diagnostic: WorkoutEvidenceQueryDiagnostic
}

private struct ActivityLoadResult {
    var activities: [WorkoutEvidenceActivity]
    var diagnostic: WorkoutEvidenceQueryDiagnostic
}

#if canImport(WorkoutKit)
@available(iOS 17.0, macOS 15.0, macCatalyst 18.0, watchOS 10.0, *)
private enum WorkoutKitPlanAuditFormatter {
    static func audit(_ plan: WorkoutPlan) -> WorkoutPlanAudit {
        switch plan.workout {
        case .custom(let workout):
            return WorkoutPlanAudit(
                status: .available,
                planID: plan.id.uuidString,
                planType: "Custom workout",
                displayName: workout.displayName,
                summaryLines: customWorkoutLines(workout),
                plannedSteps: customWorkoutSteps(workout)
            )
        case .goal(let workout):
            return WorkoutPlanAudit(
                status: .available,
                planID: plan.id.uuidString,
                planType: "Single goal workout",
                summaryLines: [
                    "Activity: \(activityLabel(workout.activity))",
                    "Goal: \(goalLabel(workout.goal))"
                ]
            )
        case .pacer(let workout):
            return WorkoutPlanAudit(
                status: .available,
                planID: plan.id.uuidString,
                planType: "Pacer workout",
                summaryLines: [
                    "Activity: \(activityLabel(workout.activity))",
                    "Distance: \(measurementLabel(workout.distance))",
                    "Time: \(measurementLabel(workout.time))"
                ]
            )
        case .swimBikeRun(let workout):
            return WorkoutPlanAudit(
                status: .available,
                planID: plan.id.uuidString,
                planType: "Swim bike run workout",
                displayName: workout.displayName,
                summaryLines: workout.activities.enumerated().map { index, activity in
                    "Activity \(index + 1): \(String(describing: activity))"
                }
            )
        @unknown default:
            return WorkoutPlanAudit(
                status: .available,
                planID: plan.id.uuidString,
                planType: "Unknown workout plan",
                summaryLines: ["WorkoutKit returned a workout plan type RunSignal does not recognize yet."]
            )
        }
    }

    private static func customWorkoutLines(_ workout: CustomWorkout) -> [String] {
        var lines: [String] = ["Activity: \(activityLabel(workout.activity))"]
        if let warmup = workout.warmup {
            lines.append("Warmup: \(stepLabel(warmup))")
        } else {
            lines.append("Warmup: none")
        }

        if workout.blocks.isEmpty {
            lines.append("Interval blocks: none")
        } else {
            for (blockIndex, block) in workout.blocks.enumerated() {
                lines.append("Block \(blockIndex + 1): \(block.iterations)x, \(block.steps.count) step(s)")
                for (stepIndex, intervalStep) in block.steps.enumerated() {
                    lines.append("Block \(blockIndex + 1) step \(stepIndex + 1): \(purposeLabel(intervalStep.purpose)) - \(stepLabel(intervalStep.step))")
                }
            }
        }

        if let cooldown = workout.cooldown {
            lines.append("Cooldown: \(stepLabel(cooldown))")
        } else {
            lines.append("Cooldown: none")
        }
        return lines
    }

    private static func customWorkoutSteps(_ workout: CustomWorkout) -> [PlannedWorkoutStep] {
        var steps: [PlannedWorkoutStep] = []

        if let warmup = workout.warmup {
            steps.append(
                plannedStep(
                    index: steps.count + 1,
                    label: "Warmup",
                    stepType: .warmup,
                    step: warmup
                )
            )
        }

        for (blockIndex, block) in workout.blocks.enumerated() {
            for repeatIndex in 1...max(block.iterations, 1) {
                for intervalStep in block.steps {
                    let type: DerivedIntervalLabel = intervalStep.purpose == .work ? .work : .recovery
                    let label = type == .work ? "Work \(repeatIndex)" : "Recovery \(repeatIndex)"
                    steps.append(
                        plannedStep(
                            index: steps.count + 1,
                            label: label,
                            stepType: type,
                            repeatBlockIndex: blockIndex + 1,
                            repeatIndex: repeatIndex,
                            step: intervalStep.step
                        )
                    )
                }
            }
        }

        if let cooldown = workout.cooldown {
            steps.append(
                plannedStep(
                    index: steps.count + 1,
                    label: "Cooldown",
                    stepType: .cooldown,
                    step: cooldown
                )
            )
        }

        return steps
    }

    private static func plannedStep(
        index: Int,
        label: String,
        stepType: DerivedIntervalLabel,
        repeatBlockIndex: Int? = nil,
        repeatIndex: Int? = nil,
        step: WorkoutStep
    ) -> PlannedWorkoutStep {
        let goal = plannedGoal(step.goal)
        return PlannedWorkoutStep(
            index: index,
            label: label,
            stepType: stepType,
            repeatBlockIndex: repeatBlockIndex,
            repeatIndex: repeatIndex,
            plannedGoalType: goal.type,
            plannedGoalValue: goal.value,
            plannedGoalDisplayText: goal.display,
            plannedTargetDisplayText: step.alert.map(alertLabel),
            plannedTargets: step.alert.map { [plannedTarget($0)] }
        )
    }

    private static func plannedGoal(_ goal: WorkoutGoal) -> (type: PlannedWorkoutGoalType, value: Double?, display: String) {
        switch goal {
        case .open:
            return (.open, nil, "Open")
        case .distance(let value, let unit):
            let meters = Measurement(value: value, unit: unit).converted(to: .meters).value
            return (.distance, meters, distanceDisplay(meters))
        case .time(let value, let unit):
            let seconds = Measurement(value: value, unit: unit).converted(to: .seconds).value
            return (.time, seconds, "\(Int(seconds.rounded())) s")
        case .energy(let value, let unit):
            let kilocalories = Measurement(value: value, unit: unit).converted(to: .kilocalories).value
            return (.energy, kilocalories, "\(numberLabel(kilocalories)) kcal")
        case .poolSwimDistanceWithTime(let distance, let time):
            let meters = distance.converted(to: .meters).value
            let seconds = time.converted(to: .seconds).value
            return (.distance, meters, "\(distanceDisplay(meters)) in \(Int(seconds.rounded())) s")
        @unknown default:
            return (.unavailable, nil, String(describing: goal))
        }
    }

    private static func stepLabel(_ step: WorkoutStep) -> String {
        var parts = ["goal \(goalLabel(step.goal))"]
        if let displayName = stepDisplayName(step) {
            parts.append("display name \(displayName)")
        }
        if let alert = step.alert {
            parts.append("alert \(alertLabel(alert))")
        } else {
            parts.append("alert none")
        }
        return parts.joined(separator: ", ")
    }

    private static func stepDisplayName(_ step: WorkoutStep) -> String? {
        if #available(iOS 18.0, macCatalyst 18.0, watchOS 11.0, *) {
            return step.displayName
        }
        return nil
    }

    private static func purposeLabel(_ purpose: IntervalStep.Purpose) -> String {
        switch purpose {
        case .work: "Work"
        case .recovery: "Recovery"
        @unknown default: String(describing: purpose)
        }
    }

    private static func goalLabel(_ goal: WorkoutGoal) -> String {
        switch goal {
        case .open:
            return "open"
        case .distance(let value, let unit):
            return measurementLabel(Measurement(value: value, unit: unit))
        case .time(let value, let unit):
            return measurementLabel(Measurement(value: value, unit: unit))
        case .energy(let value, let unit):
            return measurementLabel(Measurement(value: value, unit: unit))
        case .poolSwimDistanceWithTime(let distance, let time):
            return "\(measurementLabel(distance)) in \(measurementLabel(time))"
        @unknown default:
            return String(describing: goal)
        }
    }

    private static func distanceDisplay(_ meters: Double) -> String {
        if meters >= 1_000 {
            return "\(numberLabel(meters / 1_000)) km"
        }
        return "\(numberLabel(meters)) m"
    }

    private static func alertLabel(_ alert: any WorkoutAlert) -> String {
        switch alert {
        case let alert as SpeedRangeAlert:
            return speedRangeLabel(alert.target, metric: alert.metric)
        case let alert as SpeedThresholdAlert:
            return speedThresholdLabel(alert.target, metric: alert.metric)
        case let alert as HeartRateRangeAlert:
            return "heart rate range \(measurementLabel(alert.target.lowerBound))-\(measurementLabel(alert.target.upperBound))"
        case let alert as HeartRateZoneAlert:
            return "heart rate zone \(alert.zone)"
        case let alert as PowerRangeAlert:
            return "power range \(measurementLabel(alert.target.lowerBound))-\(measurementLabel(alert.target.upperBound))"
        case let alert as PowerThresholdAlert:
            return "power \(measurementLabel(alert.target))"
        case let alert as PowerZoneAlert:
            return "power zone \(alert.zone)"
        case let alert as CadenceRangeAlert:
            return "cadence range \(measurementLabel(alert.target.lowerBound))-\(measurementLabel(alert.target.upperBound))"
        case let alert as CadenceThresholdAlert:
            return "cadence \(measurementLabel(alert.target))"
        default:
            return String(describing: type(of: alert))
        }
    }

    private static func plannedTarget(_ alert: any WorkoutAlert) -> PlannedWorkoutTarget {
        let display = alertLabel(alert)
        switch alert {
        case let alert as SpeedRangeAlert:
            let metric = String(describing: alert.metric).lowercased()
            let lowerSpeed = alert.target.lowerBound.converted(to: .metersPerSecond).value
            let upperSpeed = alert.target.upperBound.converted(to: .metersPerSecond).value
            if metric.contains("pace") {
                return PlannedWorkoutTarget(
                    kind: .pace,
                    lowerBound: WorkoutIntervalReconstructionFormat.paceSecondsPerKilometer(speedMetersPerSecond: upperSpeed),
                    upperBound: WorkoutIntervalReconstructionFormat.paceSecondsPerKilometer(speedMetersPerSecond: lowerSpeed),
                    unit: "s/km",
                    displayText: display
                )
            }
            return PlannedWorkoutTarget(
                kind: .speed,
                lowerBound: lowerSpeed,
                upperBound: upperSpeed,
                unit: "m/s",
                displayText: display
            )
        case let alert as SpeedThresholdAlert:
            let metric = String(describing: alert.metric).lowercased()
            let speed = alert.target.converted(to: .metersPerSecond).value
            if metric.contains("pace") {
                let pace = WorkoutIntervalReconstructionFormat.paceSecondsPerKilometer(speedMetersPerSecond: speed)
                return PlannedWorkoutTarget(
                    kind: .pace,
                    lowerBound: pace,
                    upperBound: pace,
                    unit: "s/km",
                    displayText: display,
                    semantics: .threshold
                )
            }
            return PlannedWorkoutTarget(
                kind: .speed,
                lowerBound: speed,
                upperBound: speed,
                unit: "m/s",
                displayText: display,
                semantics: .threshold
            )
        case let alert as HeartRateRangeAlert:
            return PlannedWorkoutTarget(
                kind: .heartRate,
                lowerBound: alert.target.lowerBound.value,
                upperBound: alert.target.upperBound.value,
                unit: alert.target.lowerBound.unit.symbol,
                displayText: display
            )
        case _ as HeartRateZoneAlert:
            return PlannedWorkoutTarget(kind: .zone, unit: "heart-rate zone", displayText: display, semantics: .zone)
        case let alert as PowerRangeAlert:
            return PlannedWorkoutTarget(
                kind: .power,
                lowerBound: alert.target.lowerBound.value,
                upperBound: alert.target.upperBound.value,
                unit: alert.target.lowerBound.unit.symbol,
                displayText: display
            )
        case let alert as PowerThresholdAlert:
            return PlannedWorkoutTarget(kind: .power, lowerBound: alert.target.value, upperBound: alert.target.value, unit: alert.target.unit.symbol, displayText: display, semantics: .threshold)
        case _ as PowerZoneAlert:
            return PlannedWorkoutTarget(kind: .zone, unit: "power zone", displayText: display, semantics: .zone)
        case let alert as CadenceRangeAlert:
            return PlannedWorkoutTarget(
                kind: .cadence,
                lowerBound: alert.target.lowerBound.value,
                upperBound: alert.target.upperBound.value,
                unit: alert.target.lowerBound.unit.symbol,
                displayText: display
            )
        case let alert as CadenceThresholdAlert:
            return PlannedWorkoutTarget(kind: .cadence, lowerBound: alert.target.value, upperBound: alert.target.value, unit: alert.target.unit.symbol, displayText: display, semantics: .threshold)
        default:
            return PlannedWorkoutTarget(kind: .unknown, displayText: display)
        }
    }

    private static func activityLabel(_ activity: HKWorkoutActivityType) -> String {
        String(describing: activity)
    }

    private static func measurementLabel<UnitType: Unit>(_ measurement: Measurement<UnitType>) -> String {
        "\(numberLabel(measurement.value)) \(measurement.unit.symbol)"
    }

    private static func speedRangeLabel(_ range: ClosedRange<Measurement<UnitSpeed>>, metric: WorkoutAlertMetric) -> String {
        let lowerMetersPerSecond = range.lowerBound.converted(to: .metersPerSecond).value
        let upperMetersPerSecond = range.upperBound.converted(to: .metersPerSecond).value
        if let paceRange = WorkoutIntervalReconstructionFormat.paceRangeDisplay(
            speedLowerMetersPerSecond: lowerMetersPerSecond,
            speedUpperMetersPerSecond: upperMetersPerSecond
        ) {
            return "pace range \(paceRange), speed \(measurementLabel(range.lowerBound))-\(measurementLabel(range.upperBound)), metric \(String(describing: metric))"
        }
        return "speed range \(measurementLabel(range.lowerBound))-\(measurementLabel(range.upperBound)), metric \(String(describing: metric))"
    }

    private static func speedThresholdLabel(_ speed: Measurement<UnitSpeed>, metric: WorkoutAlertMetric) -> String {
        let metersPerSecond = speed.converted(to: .metersPerSecond).value
        if let pace = WorkoutIntervalReconstructionFormat.paceSecondsPerKilometer(speedMetersPerSecond: metersPerSecond) {
            return "pace \(WorkoutIntervalReconstructionFormat.durationLabel(pace)) /km, speed \(measurementLabel(speed)), metric \(String(describing: metric))"
        }
        return "speed \(measurementLabel(speed)), metric \(String(describing: metric))"
    }

    private static func numberLabel(_ value: Double) -> String {
        if abs(value.rounded() - value) < 0.01 {
            return String(Int(value.rounded()))
        }
        return String(format: "%.2f", value)
    }
}
#endif

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
        speedMetersPerSecond: location.speed >= 0 ? location.speed : nil,
        horizontalAccuracyMeters: location.horizontalAccuracy >= 0 ? location.horizontalAccuracy : nil,
        verticalAccuracyMeters: location.verticalAccuracy >= 0 ? location.verticalAccuracy : nil
    )
}
