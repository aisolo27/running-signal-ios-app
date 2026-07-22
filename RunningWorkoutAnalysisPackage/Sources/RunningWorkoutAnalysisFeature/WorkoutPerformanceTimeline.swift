import Foundation

public enum WorkoutTimelineMetric: String, CaseIterable, Identifiable, Sendable {
    case elevation
    case heartRate
    case pace
    case power
    case cadence
    case verticalOscillation
    case groundContactTime
    case strideLength

    public var id: String { rawValue }

    var title: String {
        switch self {
        case .elevation: "Elevation"
        case .heartRate: "Heart Rate"
        case .pace: "Pace"
        case .power: "Power"
        case .cadence: "Cadence"
        case .verticalOscillation: "Vertical Oscillation"
        case .groundContactTime: "Ground Contact Time"
        case .strideLength: "Stride Length"
        }
    }
}

public struct WorkoutTimelineBucket: Identifiable, Equatable, Sendable {
    public let index: Int
    public let startOffsetSeconds: Double
    public let endOffsetSeconds: Double
    public let minimum: Double
    public let maximum: Double
    public let median: Double
    public let sampleCount: Int

    public var id: Int { index }
    public var offsetSeconds: Double { (startOffsetSeconds + endOffsetSeconds) / 2 }
}

public struct WorkoutTimelineSeries: Identifiable, Equatable, Sendable {
    public let metric: WorkoutTimelineMetric
    public let buckets: [WorkoutTimelineBucket]
    public let average: Double?
    public let yDomain: ClosedRange<Double>
    public let rawSampleCount: Int
    public let coverageFraction: Double
    public let hasClippedValues: Bool

    public var id: WorkoutTimelineMetric { metric }

    public var isCadenceDetailTrustworthy: Bool {
        metric != .cadence || (rawSampleCount >= 6 && coverageFraction >= 0.25)
    }

    public func bucket(at index: Int) -> WorkoutTimelineBucket? {
        buckets.first { $0.index == index }
    }
}

public struct WorkoutTimelineSelection: Identifiable, Equatable, Sendable {
    public let index: Int
    public let offsetSeconds: Double
    public let distanceMeters: Double?
    public let routePointIndex: Int?

    public var id: Int { index }
}

public struct WorkoutPerformanceTimeline: Equatable, Sendable {
    public let workoutStart: Date
    public let durationSeconds: Double
    public let bucketSeconds: Double
    public let selections: [WorkoutTimelineSelection]
    public let series: [WorkoutTimelineSeries]
    public let route: [WorkoutRoutePoint]

    public var visibleSeries: [WorkoutTimelineSeries] {
        series.filter { !$0.buckets.isEmpty && $0.isCadenceDetailTrustworthy }
    }

    public var cadenceWasWithheld: Bool {
        series.contains { $0.metric == .cadence && !$0.buckets.isEmpty && !$0.isCadenceDetailTrustworthy }
    }

    public func selection(at index: Int?) -> WorkoutTimelineSelection? {
        guard let index, selections.indices.contains(index) else { return nil }
        return selections[index]
    }

    public func series(for metric: WorkoutTimelineMetric) -> WorkoutTimelineSeries? {
        series.first { $0.metric == metric }
    }
}

public enum WorkoutPerformanceTimelineBuilder {
    public static let maximumBucketCount = 90.0

    public static func make(workout: CanonicalWorkout) -> WorkoutPerformanceTimeline? {
        guard let evidence = workout.evidence else { return nil }
        let duration = max(workout.endDate.timeIntervalSince(workout.startDate), workout.durationSeconds)
        guard duration > 0 else { return nil }

        let bucketSeconds = adaptiveBucketSeconds(durationSeconds: duration)
        let bucketCount = max(1, Int(ceil(duration / bucketSeconds)))
        let metricSamples = Dictionary(
            uniqueKeysWithValues: WorkoutTimelineMetric.allCases.map { metric in
                (metric, samples(for: metric, workout: workout, evidence: evidence))
            }
        )

        let series = WorkoutTimelineMetric.allCases.compactMap { metric -> WorkoutTimelineSeries? in
            guard let samples = metricSamples[metric], !samples.isEmpty else { return nil }
            let buckets = buckets(
                samples: samples,
                bucketCount: bucketCount,
                bucketSeconds: bucketSeconds,
                durationSeconds: duration
            )
            guard !buckets.isEmpty else { return nil }
            let domain = robustDomain(metric: metric, values: buckets.map(\.median))
            let occupied = Set(buckets.map(\.index)).count
            return WorkoutTimelineSeries(
                metric: metric,
                buckets: buckets,
                average: summaryAverage(metric: metric, workout: workout, samples: samples),
                yDomain: domain,
                rawSampleCount: samples.count,
                coverageFraction: Double(occupied) / Double(bucketCount),
                hasClippedValues: buckets.contains { $0.minimum < domain.lowerBound || $0.maximum > domain.upperBound }
            )
        }

        let route = evidence.route.sorted { $0.date < $1.date }
        let distanceContributions = reconciledDistanceContributions(
            workout: workout,
            series: evidence.series[.distance]
        )
        let selections = (0..<bucketCount).map { index in
            let offset = min((Double(index) + 0.5) * bucketSeconds, duration)
            let date = workout.startDate.addingTimeInterval(offset)
            return WorkoutTimelineSelection(
                index: index,
                offsetSeconds: offset,
                distanceMeters: cumulativeDistance(
                    at: date,
                    contributions: distanceContributions
                ),
                routePointIndex: nearestRoutePointIndex(to: date, route: route)
            )
        }

        return WorkoutPerformanceTimeline(
            workoutStart: workout.startDate,
            durationSeconds: duration,
            bucketSeconds: bucketSeconds,
            selections: selections,
            series: series,
            route: route
        )
    }

    public static func adaptiveBucketSeconds(durationSeconds: Double) -> Double {
        guard durationSeconds > 0 else { return 5 }
        let raw = durationSeconds / maximumBucketCount
        return max(5, ceil(raw / 5) * 5)
    }

    public static func robustDomain(
        metric: WorkoutTimelineMetric,
        values: [Double]
    ) -> ClosedRange<Double> {
        let sorted = values.filter(\.isFinite).sorted()
        guard let absoluteMinimum = sorted.first, let absoluteMaximum = sorted.last else { return 0...1 }

        let minimum: Double
        let maximum: Double
        if sorted.count >= 12 {
            minimum = sorted[quantileIndex(0.02, count: sorted.count)]
            maximum = sorted[quantileIndex(0.98, count: sorted.count)]
        } else {
            minimum = absoluteMinimum
            maximum = absoluteMaximum
        }

        if minimum == maximum {
            let padding = max(metric.minimumPadding, abs(minimum) * 0.05, 1)
            return metric.lowerBound(minimum - padding)...(maximum + padding)
        }

        let padding = max((maximum - minimum) * 0.12, metric.minimumPadding)
        return metric.lowerBound(minimum - padding)...(maximum + padding)
    }

    private static func quantileIndex(_ quantile: Double, count: Int) -> Int {
        min(max(Int((Double(count - 1) * quantile).rounded(.down)), 0), count - 1)
    }

    private static func samples(
        for metric: WorkoutTimelineMetric,
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence
    ) -> [WorkoutTimelineSample] {
        switch metric {
        case .elevation:
            return evidence.route.compactMap { point in
                guard let altitude = point.altitudeMeters, altitude.isFinite else { return nil }
                return sample(
                    value: altitude,
                    startDate: point.date,
                    endDate: point.date,
                    workoutStart: workout.startDate
                )
            }
        case .heartRate:
            return evidenceSamples(.heartRate, workout: workout, evidence: evidence)
        case .pace:
            return paceSamples(workout: workout, evidence: evidence)
        case .power:
            return evidenceSamples(.runningPower, workout: workout, evidence: evidence)
        case .cadence:
            let cadence = evidenceSamples(.cadence, workout: workout, evidence: evidence).map { sample in
                WorkoutTimelineSample(
                    value: normalizedFullStepCadence(sample.value),
                    startOffsetSeconds: sample.startOffsetSeconds,
                    endOffsetSeconds: sample.endOffsetSeconds,
                    representativeOffsetSeconds: sample.representativeOffsetSeconds
                )
            }
            return cadence.isEmpty
                ? cadenceFromStepCount(workout: workout, evidence: evidence)
                : cadence
        case .verticalOscillation:
            return evidenceSamples(.verticalOscillation, workout: workout, evidence: evidence)
        case .groundContactTime:
            return evidenceSamples(.groundContactTime, workout: workout, evidence: evidence)
        case .strideLength:
            return evidenceSamples(.strideLength, workout: workout, evidence: evidence)
        }
    }

    private static func cadenceFromStepCount(
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence
    ) -> [WorkoutTimelineSample] {
        guard let points = evidence.series[.stepCount]?.points else { return [] }
        return points.compactMap { point in
            let duration = point.endDate.timeIntervalSince(point.startDate)
            guard duration > 0, point.value >= 0 else { return nil }
            return sample(
                value: point.value / duration * 60,
                startDate: point.startDate,
                endDate: point.endDate,
                representativeDate: point.date,
                workoutStart: workout.startDate
            )
        }
    }

    private static func normalizedFullStepCadence(_ value: Double) -> Double {
        value > 0 && value < 120 ? value * 2 : value
    }

    private static func evidenceSamples(
        _ metric: WorkoutEvidenceMetric,
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence
    ) -> [WorkoutTimelineSample] {
        guard let points = evidence.series[metric]?.points else { return [] }
        return points.compactMap { point in
            sample(
                value: point.value,
                startDate: point.startDate,
                endDate: point.endDate,
                representativeDate: point.date,
                workoutStart: workout.startDate
            )
        }
    }

    private static func paceSamples(
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence
    ) -> [WorkoutTimelineSample] {
        if let speedPoints = evidence.series[.runningSpeed]?.points, speedPoints.count >= 2 {
            return speedPoints.compactMap { point in
                guard point.value > 0 else { return nil }
                return sample(
                    value: 1_000 / point.value,
                    startDate: point.startDate,
                    endDate: point.endDate,
                    representativeDate: point.date,
                    workoutStart: workout.startDate
                )
            }
        }

        guard let distancePoints = evidence.series[.distance]?.points else { return [] }
        var previousEnd = workout.startDate
        return distancePoints.compactMap { point in
            let hasWindow = point.endDate > point.startDate
            let start = hasWindow ? point.startDate : previousEnd
            let end = hasWindow ? point.endDate : point.date
            defer { previousEnd = max(previousEnd, end) }
            let seconds = end.timeIntervalSince(start)
            guard seconds > 0, point.value > 0 else { return nil }
            return sample(
                value: seconds / (point.value / 1_000),
                startDate: start,
                endDate: end,
                representativeDate: end,
                workoutStart: workout.startDate
            )
        }
    }

    private static func sample(
        value: Double,
        startDate: Date,
        endDate: Date,
        representativeDate: Date? = nil,
        workoutStart: Date
    ) -> WorkoutTimelineSample? {
        guard value.isFinite else { return nil }
        let representative = representativeDate ?? startDate
        return WorkoutTimelineSample(
            value: value,
            startOffsetSeconds: max(0, startDate.timeIntervalSince(workoutStart)),
            endOffsetSeconds: max(0, endDate.timeIntervalSince(workoutStart)),
            representativeOffsetSeconds: max(0, representative.timeIntervalSince(workoutStart))
        )
    }

    private static func buckets(
        samples: [WorkoutTimelineSample],
        bucketCount: Int,
        bucketSeconds: Double,
        durationSeconds: Double
    ) -> [WorkoutTimelineBucket] {
        var valuesByBucket: [Int: [Double]] = [:]
        for sample in samples {
            let sampleStart = min(max(sample.startOffsetSeconds, 0), durationSeconds)
            let sampleEnd = min(max(sample.endOffsetSeconds, sampleStart), durationSeconds)
            if sampleEnd > sampleStart {
                let firstIndex = min(Int(floor(sampleStart / bucketSeconds)), bucketCount - 1)
                let lastIndex = min(Int(floor(max(sampleEnd.nextDown, sampleStart) / bucketSeconds)), bucketCount - 1)
                for index in firstIndex...lastIndex {
                    valuesByBucket[index, default: []].append(sample.value)
                }
            } else {
                let index = min(Int(floor(sample.representativeOffsetSeconds / bucketSeconds)), bucketCount - 1)
                valuesByBucket[max(0, index), default: []].append(sample.value)
            }
        }

        return valuesByBucket.keys.sorted().compactMap { index in
            guard let values = valuesByBucket[index], !values.isEmpty else { return nil }
            let sorted = values.sorted()
            return WorkoutTimelineBucket(
                index: index,
                startOffsetSeconds: Double(index) * bucketSeconds,
                endOffsetSeconds: min(Double(index + 1) * bucketSeconds, durationSeconds),
                minimum: sorted[0],
                maximum: sorted[sorted.count - 1],
                median: sorted[sorted.count / 2],
                sampleCount: sorted.count
            )
        }
    }

    private static func summaryAverage(
        metric: WorkoutTimelineMetric,
        workout: CanonicalWorkout,
        samples: [WorkoutTimelineSample]
    ) -> Double? {
        switch metric {
        case .elevation:
            return median(samples.map(\.value))
        case .heartRate:
            return workout.averageHeartRate ?? median(samples.map(\.value))
        case .pace:
            return workout.paceSecondsPerKm ?? median(samples.map(\.value))
        case .power:
            return workout.averagePower ?? median(samples.map(\.value))
        case .cadence:
            return workout.fullStepCadence ?? median(samples.map(\.value))
        case .verticalOscillation:
            return workout.verticalOscillationCentimeters ?? median(samples.map(\.value))
        case .groundContactTime:
            return workout.groundContactMilliseconds ?? median(samples.map(\.value))
        case .strideLength:
            return workout.strideLengthMeters ?? median(samples.map(\.value))
        }
    }

    private static func median(_ values: [Double]) -> Double? {
        let sorted = values.filter(\.isFinite).sorted()
        guard !sorted.isEmpty else { return nil }
        return sorted[sorted.count / 2]
    }

    private static func reconciledDistanceContributions(
        workout: CanonicalWorkout,
        series: WorkoutMetricSeries?
    ) -> [WorkoutDistanceContribution]? {
        guard let series, !series.points.isEmpty else { return nil }
        let sorted = series.points.sorted {
            if $0.startDate == $1.startDate { return $0.endDate < $1.endDate }
            return $0.startDate < $1.startDate
        }
        var uniquePoints: [WorkoutEvidencePoint] = []
        for point in sorted {
            guard point.value.isFinite,
                  point.value >= 0,
                  point.endDate >= point.startDate,
                  point.startDate >= workout.startDate.addingTimeInterval(-5),
                  point.endDate <= workout.endDate.addingTimeInterval(5) else {
                return nil
            }
            if let previous = uniquePoints.last,
               previous.startDate == point.startDate,
               previous.endDate == point.endDate,
               abs(previous.value - point.value) < 0.000_001 {
                continue
            }
            uniquePoints.append(point)
        }

        let total = uniquePoints.map(\.value).reduce(0, +)
        guard total > 0 else { return nil }
        if let summaryDistance = workout.distanceMeters {
            let tolerance = max(50, summaryDistance * 0.03)
            guard abs(total - summaryDistance) <= tolerance else { return nil }
        }

        var previousEnd = workout.startDate
        return uniquePoints.map { point in
            let hasWindow = point.endDate > point.startDate
            let start = hasWindow ? point.startDate : previousEnd
            let end = hasWindow ? point.endDate : point.date
            previousEnd = max(previousEnd, end)
            return WorkoutDistanceContribution(startDate: start, endDate: end, meters: point.value)
        }
    }

    private static func cumulativeDistance(
        at date: Date,
        contributions: [WorkoutDistanceContribution]?
    ) -> Double? {
        guard let contributions else { return nil }
        return contributions.reduce(0) { cumulative, contribution in
            guard date > contribution.startDate else { return cumulative }
            let duration = contribution.endDate.timeIntervalSince(contribution.startDate)
            guard date < contribution.endDate, duration > 0 else {
                return cumulative + contribution.meters
            }
            let fraction = min(max(date.timeIntervalSince(contribution.startDate) / duration, 0), 1)
            return cumulative + (contribution.meters * fraction)
        }
    }

    private static func nearestRoutePointIndex(
        to date: Date,
        route: [WorkoutRoutePoint]
    ) -> Int? {
        guard !route.isEmpty else { return nil }
        var lower = 0
        var upper = route.count
        while lower < upper {
            let middle = (lower + upper) / 2
            if route[middle].date < date {
                lower = middle + 1
            } else {
                upper = middle
            }
        }
        if lower == 0 { return 0 }
        if lower == route.count { return route.count - 1 }
        let previous = lower - 1
        return abs(route[previous].date.timeIntervalSince(date)) <= abs(route[lower].date.timeIntervalSince(date))
            ? previous
            : lower
    }
}

private struct WorkoutTimelineSample: Equatable, Sendable {
    let value: Double
    let startOffsetSeconds: Double
    let endOffsetSeconds: Double
    let representativeOffsetSeconds: Double
}

private struct WorkoutDistanceContribution: Equatable, Sendable {
    let startDate: Date
    let endDate: Date
    let meters: Double
}

private extension WorkoutTimelineMetric {
    var minimumPadding: Double {
        switch self {
        case .elevation: 1
        case .heartRate: 5
        case .pace: 15
        case .power: 10
        case .cadence: 5
        case .verticalOscillation: 0.25
        case .groundContactTime: 5
        case .strideLength: 0.05
        }
    }

    func lowerBound(_ value: Double) -> Double {
        switch self {
        case .heartRate: max(40, value)
        case .pace: max(90, value)
        case .elevation, .power, .cadence, .verticalOscillation, .groundContactTime, .strideLength:
            max(0, value)
        }
    }
}
