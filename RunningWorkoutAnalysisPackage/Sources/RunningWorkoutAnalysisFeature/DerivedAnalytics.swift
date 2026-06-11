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

        for point in distanceSeries.points {
            cumulativeDistance += point.value

            while cumulativeDistance >= nextTarget && estimates.count < maxSplits {
                let splitDuration = point.date.timeIntervalSince(previousCrossingDate)
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
                    previousCrossingDate = point.date
                }
                nextTarget += targetMeters
            }
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
        for point in series.points {
            total += point.value
            guard total >= target else { continue }
            let duration = point.date.timeIntervalSince(workoutStart)
            return duration > 0 ? duration : nil
        }
        return nil
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
