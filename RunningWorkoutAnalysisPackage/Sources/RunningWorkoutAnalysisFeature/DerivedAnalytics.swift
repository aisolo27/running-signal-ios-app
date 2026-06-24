import Foundation

public struct DerivedAnalyticsInputSummary: Codable, Equatable, Sendable {
    public var workoutID: String
    public var evidenceLoadedAt: Date
    public var seriesSampleCounts: [String: Int]
    public var seriesValueSums: [String: Double]
    public var seriesFirstSampleAt: [String: Date]
    public var seriesLastSampleAt: [String: Date]
    public var routePointCount: Int
    public var routeSignature: String
    public var eventCount: Int
    public var eventSignature: String
    public var distanceMeters: Double?
    public var durationSeconds: Double

    public init(workout: CanonicalWorkout, evidence: WorkoutEvidence) {
        workoutID = workout.id
        evidenceLoadedAt = evidence.loadedAt
        seriesSampleCounts = Dictionary(
            uniqueKeysWithValues: WorkoutEvidenceMetric.allCases.map { ($0.rawValue, evidence.sampleCount($0)) }
        )
        seriesValueSums = Dictionary(
            uniqueKeysWithValues: WorkoutEvidenceMetric.allCases.map { metric in
                (metric.rawValue, evidence.series[metric]?.points.map(\.value).reduce(0, +) ?? 0)
            }
        )
        seriesFirstSampleAt = Dictionary(
            uniqueKeysWithValues: WorkoutEvidenceMetric.allCases.compactMap { metric in
                guard let date = evidence.series[metric]?.points.first?.date else { return nil }
                return (metric.rawValue, date)
            }
        )
        seriesLastSampleAt = Dictionary(
            uniqueKeysWithValues: WorkoutEvidenceMetric.allCases.compactMap { metric in
                guard let date = evidence.series[metric]?.points.last?.date else { return nil }
                return (metric.rawValue, date)
            }
        )
        routePointCount = evidence.route.count
        routeSignature = Self.routeSignature(evidence.route)
        eventCount = evidence.events.count
        eventSignature = Self.eventSignature(evidence.events)
        distanceMeters = workout.distanceMeters
        durationSeconds = workout.durationSeconds
    }

    private static func routeSignature(_ route: [WorkoutRoutePoint]) -> String {
        guard let first = route.first, let last = route.last else { return "none" }
        return [
            "\(first.date.ISO8601Format())@\(first.latitude),\(first.longitude)",
            "\(last.date.ISO8601Format())@\(last.latitude),\(last.longitude)"
        ].joined(separator: "...")
    }

    private static func eventSignature(_ events: [WorkoutEvidenceEvent]) -> String {
        guard !events.isEmpty else { return "none" }
        return events.map { event in
            [
                event.startDate.ISO8601Format(),
                event.endDate.ISO8601Format(),
                event.type,
                event.label ?? ""
            ].joined(separator: ":")
        }.joined(separator: "|")
    }
}

public struct DerivedBestEffortEstimate: Codable, Equatable, Sendable {
    public var label: String
    public var distanceMeters: Double
    public var durationSecondsEstimate: Double
    public var paceSecondsPerKmEstimate: Double
    public var confidence: ConfidenceLevel
    public var source: String
}

public struct DerivedSplitEstimate: Codable, Equatable, Sendable {
    public var label: String
    public var distanceMeters: Double
    public var durationSecondsEstimate: Double
    public var paceSecondsPerKmEstimate: Double
    public var confidence: ConfidenceLevel
}

public struct DerivedExecutionSegment: Codable, Equatable, Sendable {
    public var label: String
    public var heartRateAverage: Double?
    public var heartRateConfidence: ConfidenceLevel
    public var paceSecondsPerKmEstimate: Double?
    public var paceConfidence: ConfidenceLevel
}

public enum DerivedIntervalLabel: String, Codable, Sendable {
    case warmup
    case work
    case recovery
    case cooldown
    case open
    case unknown

    public var displayName: String {
        switch self {
        case .warmup: "Warmup"
        case .work: "Work"
        case .recovery: "Recovery"
        case .cooldown: "Cooldown"
        case .open: "Open"
        case .unknown: "Unknown"
        }
    }
}

public enum DerivedIntervalSource: String, Codable, Sendable {
    case healthKitLabeledEvent
    case healthKitSegmentPattern
    case inferredPattern
    case manual

    public var displayName: String {
        switch self {
        case .healthKitLabeledEvent: "HealthKit labeled event"
        case .healthKitSegmentPattern: "HealthKit segment pattern"
        case .inferredPattern: "Inferred pattern"
        case .manual: "Manual"
        }
    }
}

public enum DerivedIntervalMarkerKind: String, Codable, Sendable {
    case appleFitnessIntervalCandidate
    case splitMarker
    case overlappingSegmentMarker
    case rawSegmentMarker

    public var displayName: String {
        switch self {
        case .appleFitnessIntervalCandidate: "Interval candidate"
        case .splitMarker: "Split marker"
        case .overlappingSegmentMarker: "Overlapping segment marker"
        case .rawSegmentMarker: "Raw segment marker"
        }
    }
}

public struct DerivedWorkoutInterval: Codable, Equatable, Sendable {
    public var index: Int
    public var label: DerivedIntervalLabel
    public var startDate: Date
    public var endDate: Date
    public var startOffsetSeconds: Double
    public var endOffsetSeconds: Double
    public var durationSeconds: Double
    public var distanceMeters: Double?
    public var paceSecondsPerKm: Double?
    public var averageHeartRateBpm: Double?
    public var source: DerivedIntervalSource
    public var markerKind: DerivedIntervalMarkerKind
    public var confidence: ConfidenceLevel
    public var caveats: [String]
}

public struct DerivedWorkoutAnalysis: Codable, Equatable, Sendable {
    public static let currentVersion = "derived-workout-v2"

    public var workoutID: String
    public var calculationVersion: String
    public var inputSummary: DerivedAnalyticsInputSummary
    public var paceSecondsPerKmEstimate: Double?
    public var paceConfidence: ConfidenceLevel
    public var pacingShape: String?
    public var pacingShapeConfidence: ConfidenceLevel
    public var heartRateDriftPercent: Double?
    public var heartRateDriftConfidence: ConfidenceLevel
    public var cadenceAverage: Double?
    public var powerAverage: Double?
    public var strideLengthAverage: Double?
    public var verticalOscillationAverage: Double?
    public var groundContactAverage: Double?
    public var mechanicsConfidence: ConfidenceLevel
    public var bestEffortEstimates: [DerivedBestEffortEstimate]
    public var splitEstimates: [DerivedSplitEstimate]?
    public var executionSegments: [DerivedExecutionSegment]?
    public var intervalCandidates: [DerivedWorkoutInterval]?
    public var intervalCount: Int
    public var intervalConfidence: ConfidenceLevel
    public var readinessConfidence: ConfidenceLevel
    public var dataQualityConfidence: ConfidenceLevel
    public var caveats: [String]
}

public enum DerivedAnalyticsEngine {
    public static func analyze(workout: CanonicalWorkout, evidence: WorkoutEvidence) -> DerivedWorkoutAnalysis {
        let speedSeries = evidence.series[.runningSpeed]
        let distanceSeries = evidence.series[.distance]
        let heartRateSeries = evidence.series[.heartRate]
        let coverage = WorkoutEvidenceAnalyzer.coverage(for: evidence)
        let inputSummary = DerivedAnalyticsInputSummary(workout: workout, evidence: evidence)

        let pace = PaceMath.paceSecondsPerKm(
            distanceMeters: workout.distanceMeters ?? evidence.sum(.distance),
            durationSeconds: workout.durationSeconds
        )

        let hasRollingPaceEvidence = (speedSeries?.sampleCount ?? 0) > 1 || (distanceSeries?.sampleCount ?? 0) > 1
        let paceConfidence: ConfidenceLevel = hasRollingPaceEvidence ? .moderate : (pace == nil ? .unavailable : .limited)

        let pacingShape: String?
        let pacingShapeConfidence: ConfidenceLevel
        if let speedSeries, speedSeries.sampleCount >= 3 {
            pacingShape = paceShape(from: speedSeries.points.map(\.value))
            pacingShapeConfidence = .moderate
        } else if let distanceSeries, distanceSeries.sampleCount >= 3 {
            pacingShape = "Distance-series based"
            pacingShapeConfidence = .limited
        } else {
            pacingShape = nil
            pacingShapeConfidence = .unavailable
        }

        let heartRateDrift = heartRateSeries.flatMap { driftPercent(values: $0.points.map(\.value)) }
        let heartRateDriftConfidence: ConfidenceLevel = heartRateDrift == nil ? .unavailable : .moderate
        let mechanicsConfidence: ConfidenceLevel = coverage.mechanics ? (coverage.speedOrDistance ? .moderate : .limited) : .unavailable

        var caveats = coverage.caveats
        if !hasRollingPaceEvidence {
            caveats.append("Whole-workout average pace is an estimate until rolling speed or distance evidence exists.")
        }
        if heartRateDrift == nil {
            caveats.append("Heart-rate drift is unavailable without enough heart-rate samples.")
        }

        return DerivedWorkoutAnalysis(
            workoutID: workout.id,
            calculationVersion: DerivedWorkoutAnalysis.currentVersion,
            inputSummary: inputSummary,
            paceSecondsPerKmEstimate: pace,
            paceConfidence: paceConfidence,
            pacingShape: pacingShape,
            pacingShapeConfidence: pacingShapeConfidence,
            heartRateDriftPercent: heartRateDrift,
            heartRateDriftConfidence: heartRateDriftConfidence,
            cadenceAverage: evidence.average(.cadence) ?? evidence.average(.stepCount),
            powerAverage: evidence.average(.runningPower),
            strideLengthAverage: evidence.average(.strideLength),
            verticalOscillationAverage: evidence.average(.verticalOscillation),
            groundContactAverage: evidence.average(.groundContactTime),
            mechanicsConfidence: mechanicsConfidence,
            bestEffortEstimates: bestEffortEstimates(
                workout: workout,
                evidence: evidence,
                paceEstimate: pace,
                paceConfidence: paceConfidence
            ),
            splitEstimates: splitEstimates(workout: workout, evidence: evidence),
            executionSegments: executionSegments(heartRateSeries: heartRateSeries, speedSeries: speedSeries),
            intervalCandidates: intervalCandidates(workout: workout, evidence: evidence),
            intervalCount: evidence.events.count,
            intervalConfidence: evidence.events.isEmpty ? .unavailable : .limited,
            readinessConfidence: minConfidence(coverage.confidence, paceConfidence),
            dataQualityConfidence: coverage.confidence,
            caveats: orderedUnique(caveats)
        )
    }

    private static func paceShape(from values: [Double]) -> String {
        guard let first = values.first, let last = values.last, first > 0 else { return "Unknown" }
        let change = (last - first) / first
        if change >= 0.05 { return "Faster finish" }
        if change <= -0.05 { return "Fading finish" }
        return "Even"
    }

    private static func driftPercent(values: [Double]) -> Double? {
        guard values.count >= 4 else { return nil }
        let midpoint = values.count / 2
        let firstHalf = Array(values.prefix(midpoint))
        let secondHalf = Array(values.suffix(values.count - midpoint))
        let firstAverage = firstHalf.reduce(0, +) / Double(firstHalf.count)
        guard firstAverage > 0 else { return nil }
        let secondAverage = secondHalf.reduce(0, +) / Double(secondHalf.count)
        return ((secondAverage - firstAverage) / firstAverage) * 100
    }

    private static func bestEffortEstimates(
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence,
        paceEstimate: Double?,
        paceConfidence: ConfidenceLevel
    ) -> [DerivedBestEffortEstimate] {
        guard let workoutDistance = workout.distanceMeters, workoutDistance > 0 else { return [] }
        let targets: [(String, Double)] = [
            ("400m", 400),
            ("1K", 1_000),
            ("Mile", 1_609.34),
            ("2-mile", 3_218.68),
            ("5K", 5_000),
            ("10K", 10_000)
        ]
        let distanceSeries = evidence.series[.distance]

        return targets.compactMap { label, target in
            guard workoutDistance >= target * 0.96 else { return nil }
            let rollingDuration = distanceSeries.flatMap {
                durationToCover(distanceMeters: target, from: $0, workoutStart: workout.startDate)
            }
            let duration = rollingDuration ?? paceEstimate.map {
                PaceMath.secondsForDistance(paceSecondsPerKm: $0, distanceMeters: target)
            }
            guard let duration, duration.isFinite, duration > 0 else { return nil }
            let confidence: ConfidenceLevel = rollingDuration == nil ? minConfidence(paceConfidence, .limited) : .moderate
            return DerivedBestEffortEstimate(
                label: label,
                distanceMeters: target,
                durationSecondsEstimate: duration,
                paceSecondsPerKmEstimate: duration / (target / 1_000),
                confidence: confidence,
                source: rollingDuration == nil ? "whole-workout pace estimate" : "rolling distance evidence"
            )
        }
    }

    private static func splitEstimates(workout: CanonicalWorkout, evidence: WorkoutEvidence) -> [DerivedSplitEstimate] {
        guard let distanceSeries = evidence.series[.distance], distanceSeries.points.count > 1 else { return [] }

        let targetMeters = 1_000.0
        let maxSplits = 10
        var cumulativeDistance = 0.0
        var nextTarget = targetMeters
        var previousCrossingDate = workout.startDate
        var estimates: [DerivedSplitEstimate] = []

        var previousSampleDate = workout.startDate

        for point in distanceSeries.points {
            let previousDistance = cumulativeDistance
            let previousDate = previousSampleDate
            cumulativeDistance += point.value

            while cumulativeDistance >= nextTarget && estimates.count < maxSplits {
                let crossingDate = interpolatedDate(
                    targetDistance: nextTarget,
                    previousDistance: previousDistance,
                    currentDistance: cumulativeDistance,
                    previousDate: previousDate,
                    currentDate: point.date
                )
                let splitDuration = crossingDate.timeIntervalSince(previousCrossingDate)
                if splitDuration > 0 {
                    let splitNumber = estimates.count + 1
                    estimates.append(
                        DerivedSplitEstimate(
                            label: "KM \(splitNumber)",
                            distanceMeters: targetMeters,
                            durationSecondsEstimate: splitDuration,
                            paceSecondsPerKmEstimate: splitDuration,
                            confidence: .moderate
                        )
                    )
                    previousCrossingDate = crossingDate
                }
                nextTarget += targetMeters
            }
            previousSampleDate = point.date
        }

        return estimates
    }

    private static func executionSegments(
        heartRateSeries: WorkoutMetricSeries?,
        speedSeries: WorkoutMetricSeries?
    ) -> [DerivedExecutionSegment] {
        let heartRateHalves = heartRateSeries.flatMap {
            halfAverages(from: $0.points.map(\.value), minimumCount: 4)
        }
        let speedHalves = speedSeries.flatMap {
            halfAverages(from: $0.points.map(\.value), minimumCount: 4)
        }

        guard heartRateHalves != nil || speedHalves != nil else { return [] }

        return [
            DerivedExecutionSegment(
                label: "Opening",
                heartRateAverage: heartRateHalves?.first,
                heartRateConfidence: heartRateHalves == nil ? .unavailable : .moderate,
                paceSecondsPerKmEstimate: speedHalves.flatMap { paceSecondsPerKm(fromMetersPerSecond: $0.first) },
                paceConfidence: speedHalves == nil ? .unavailable : .moderate
            ),
            DerivedExecutionSegment(
                label: "Finish",
                heartRateAverage: heartRateHalves?.second,
                heartRateConfidence: heartRateHalves == nil ? .unavailable : .moderate,
                paceSecondsPerKmEstimate: speedHalves.flatMap { paceSecondsPerKm(fromMetersPerSecond: $0.second) },
                paceConfidence: speedHalves == nil ? .unavailable : .moderate
            )
        ]
    }

    public static func intervalCandidates(workout: CanonicalWorkout, evidence: WorkoutEvidence) -> [DerivedWorkoutInterval] {
        let events = evidence.events
            .filter { event in
                event.endDate > event.startDate
                    && event.startDate >= workout.startDate
                    && event.endDate <= workout.endDate.addingTimeInterval(1)
            }
            .prefix(20)
        guard !events.isEmpty else { return [] }

        return events.enumerated().map { offset, event in
            let previous = offset > 0 ? events[events.index(events.startIndex, offsetBy: offset - 1)] : nil
            let distance = intervalDistance(start: event.startDate, end: event.endDate, workout: workout, evidence: evidence)
            let duration = event.endDate.timeIntervalSince(event.startDate)
            let pace = distance.flatMap { distance -> Double? in
                guard distance > 0 else { return nil }
                return duration / (distance / 1_000)
            }
            let heartRate = averageHeartRate(start: event.startDate, end: event.endDate, evidence: evidence)
            let label = intervalLabel(for: event)
            let markerKind = markerKind(event: event, previous: previous, label: label, distanceMeters: distance)
            var caveats: [String] = []
            if label == .unknown {
                caveats.append("HealthKit did not expose an Apple Fitness interval label for this event.")
            }
            switch markerKind {
            case .splitMarker:
                caveats.append("This event window matches a split-like distance marker, not an Apple Fitness interval row.")
            case .overlappingSegmentMarker:
                caveats.append("This event overlaps another segment window, so it should stay raw/debug-only.")
            case .rawSegmentMarker:
                caveats.append("This event is a raw HealthKit marker until interval parity is proven.")
            case .appleFitnessIntervalCandidate:
                break
            }
            caveats.append("Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.")
            if evidence.workoutPlanAudit?.plannedSteps.isEmpty == false {
                caveats.append("WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics.")
            }
            if distance == nil {
                caveats.append("Distance series is unavailable for this event window.")
            }
            if heartRate == nil {
                caveats.append("Heart-rate samples are unavailable for this event window.")
            }

            let confidence: ConfidenceLevel
            if label != .unknown && distance != nil && heartRate != nil {
                confidence = .strong
            } else if label != .unknown && distance != nil {
                confidence = .moderate
            } else if distance != nil {
                confidence = .limited
            } else {
                confidence = .unavailable
            }

            return DerivedWorkoutInterval(
                index: offset + 1,
                label: label,
                startDate: event.startDate,
                endDate: event.endDate,
                startOffsetSeconds: event.startDate.timeIntervalSince(workout.startDate),
                endOffsetSeconds: event.endDate.timeIntervalSince(workout.startDate),
                durationSeconds: duration,
                distanceMeters: distance,
                paceSecondsPerKm: pace,
                averageHeartRateBpm: heartRate,
                source: label == .unknown ? .healthKitSegmentPattern : .healthKitLabeledEvent,
                markerKind: markerKind,
                confidence: confidence,
                caveats: orderedUnique(caveats)
            )
        }
    }

    private static func markerKind(
        event: WorkoutEvidenceEvent,
        previous: WorkoutEvidenceEvent?,
        label: DerivedIntervalLabel,
        distanceMeters: Double?
    ) -> DerivedIntervalMarkerKind {
        if label != .unknown {
            return .appleFitnessIntervalCandidate
        }
        if let previous, event.startDate < previous.endDate {
            return .overlappingSegmentMarker
        }
        if let distanceMeters, distanceMeters >= 950, distanceMeters <= 1_050 {
            return .splitMarker
        }
        return .rawSegmentMarker
    }

    private static func intervalDistance(start: Date, end: Date, workout: CanonicalWorkout, evidence: WorkoutEvidence) -> Double? {
        guard let distanceSeries = evidence.series[.distance], !distanceSeries.points.isEmpty,
              let startDistance = cumulativeDistance(at: start, workoutStart: workout.startDate, series: distanceSeries),
              let endDistance = cumulativeDistance(at: end, workoutStart: workout.startDate, series: distanceSeries),
              endDistance >= startDistance else {
            return nil
        }
        let distance = endDistance - startDistance
        return distance > 0 ? distance : nil
    }

    private static func cumulativeDistance(at date: Date, workoutStart: Date, series: WorkoutMetricSeries) -> Double? {
        guard date >= workoutStart else { return nil }
        var cumulative = 0.0
        var previousDate = workoutStart
        var previousDistance = 0.0

        for point in series.points {
            let currentDistance = cumulative + point.value
            if date <= point.date {
                let interpolated = interpolatedDistance(
                    date: date,
                    previousDate: previousDate,
                    currentDate: point.date,
                    previousDistance: previousDistance,
                    currentDistance: currentDistance
                )
                return interpolated
            }
            cumulative = currentDistance
            previousDistance = cumulative
            previousDate = point.date
        }

        return cumulative
    }

    private static func interpolatedDistance(
        date: Date,
        previousDate: Date,
        currentDate: Date,
        previousDistance: Double,
        currentDistance: Double
    ) -> Double {
        let timeDelta = currentDate.timeIntervalSince(previousDate)
        guard timeDelta > 0 else { return currentDistance }
        let ratio = min(max(date.timeIntervalSince(previousDate) / timeDelta, 0), 1)
        return previousDistance + ((currentDistance - previousDistance) * ratio)
    }

    private static func averageHeartRate(start: Date, end: Date, evidence: WorkoutEvidence) -> Double? {
        guard let points = evidence.series[.heartRate]?.points.filter({ $0.date >= start && $0.date <= end }),
              !points.isEmpty else {
            return nil
        }
        return points.map(\.value).reduce(0, +) / Double(points.count)
    }

    private static func intervalLabel(for event: WorkoutEvidenceEvent) -> DerivedIntervalLabel {
        let label = (event.label ?? event.displayLabel).lowercased()
        if label.contains("warm") { return .warmup }
        if label.contains("recover") { return .recovery }
        if label.contains("cool") { return .cooldown }
        if label.contains("open") { return .open }
        if label.contains("work") { return .work }
        return .unknown
    }

    private static func halfAverages(from values: [Double], minimumCount: Int) -> (first: Double, second: Double)? {
        guard values.count >= minimumCount else { return nil }
        let midpoint = values.count / 2
        let firstHalf = Array(values.prefix(midpoint))
        let secondHalf = Array(values.suffix(values.count - midpoint))
        guard !firstHalf.isEmpty, !secondHalf.isEmpty else { return nil }
        return (
            firstHalf.reduce(0, +) / Double(firstHalf.count),
            secondHalf.reduce(0, +) / Double(secondHalf.count)
        )
    }

    private static func paceSecondsPerKm(fromMetersPerSecond speed: Double) -> Double? {
        guard speed > 0 else { return nil }
        return 1_000 / speed
    }

    private static func durationToCover(
        distanceMeters target: Double,
        from series: WorkoutMetricSeries,
        workoutStart: Date
    ) -> Double? {
        guard series.points.count > 1 else { return nil }
        var total = 0.0
        var previousDate = workoutStart
        for point in series.points {
            let previousTotal = total
            total += point.value
            if total >= target {
                let crossingDate = interpolatedDate(
                    targetDistance: target,
                    previousDistance: previousTotal,
                    currentDistance: total,
                    previousDate: previousDate,
                    currentDate: point.date
                )
                let duration = crossingDate.timeIntervalSince(workoutStart)
                return duration > 0 ? duration : nil
            }
            previousDate = point.date
        }
        return nil
    }

    private static func interpolatedDate(
        targetDistance: Double,
        previousDistance: Double,
        currentDistance: Double,
        previousDate: Date,
        currentDate: Date
    ) -> Date {
        let distanceDelta = currentDistance - previousDistance
        guard distanceDelta > 0 else { return currentDate }
        let ratio = min(max((targetDistance - previousDistance) / distanceDelta, 0), 1)
        let timeDelta = currentDate.timeIntervalSince(previousDate)
        guard timeDelta > 0 else { return currentDate }
        return previousDate.addingTimeInterval(timeDelta * ratio)
    }

    private static func minConfidence(_ lhs: ConfidenceLevel, _ rhs: ConfidenceLevel) -> ConfidenceLevel {
        let order: [ConfidenceLevel: Int] = [.unavailable: 0, .blocked: 0, .weak: 1, .limited: 2, .moderate: 3, .strong: 4]
        return (order[lhs, default: 0] <= order[rhs, default: 0]) ? lhs : rhs
    }

    private static func orderedUnique(_ values: [String]) -> [String] {
        var seen: Set<String> = []
        return values.filter { seen.insert($0).inserted }
    }
}
