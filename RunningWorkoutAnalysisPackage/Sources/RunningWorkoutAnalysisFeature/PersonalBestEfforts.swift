import Foundation

public enum PersonalBestEffortBucket: String, Codable, CaseIterable, Sendable {
    case fourHundredMeters
    case halfMile
    case oneKilometer
    case oneMile
    case threeKilometer
    case twoMile
    case fiveKilometer
    case tenKilometer
    case fifteenKilometer
    case tenMile
    case twentyKilometer
    case halfMarathon
    case marathon
    case longestRun

    public var label: String {
        switch self {
        case .fourHundredMeters: "400m"
        case .halfMile: "1/2 mile"
        case .oneKilometer: "1K"
        case .oneMile: "1 mile"
        case .threeKilometer: "3K"
        case .twoMile: "2 mile"
        case .fiveKilometer: "5K"
        case .tenKilometer: "10K"
        case .fifteenKilometer: "15K"
        case .tenMile: "10 mile"
        case .twentyKilometer: "20K"
        case .halfMarathon: "Half marathon"
        case .marathon: "Marathon"
        case .longestRun: "Longest run"
        }
    }

    public var distanceMeters: Double? {
        switch self {
        case .fourHundredMeters: 400
        case .halfMile: 804.672
        case .oneKilometer: 1_000
        case .oneMile: 1_609.34
        case .threeKilometer: 3_000
        case .twoMile: 3_218.68
        case .fiveKilometer: 5_000
        case .tenKilometer: 10_000
        case .fifteenKilometer: 15_000
        case .tenMile: 16_093.4
        case .twentyKilometer: 20_000
        case .halfMarathon: 21_097.5
        case .marathon: 42_195
        case .longestRun: nil
        }
    }

    var isSegmentBucket: Bool {
        self != .longestRun
    }

    var isShortSegmentBucket: Bool {
        guard let distanceMeters else { return false }
        return distanceMeters < 1_000
    }
}

public enum PersonalBestEffortMethod: String, Codable, Sendable {
    case exactSegment
    case wholeRunEstimate
    case totalDistance
}

public enum PersonalBestEffortConfidence: String, Codable, Sendable {
    case exact
    case estimated
    case exactTotal
    case unavailable
}

public enum PersonalBestEffortCaveat: String, Codable, CaseIterable, Sendable {
    case summaryOnlyEstimate
    case indoorDeviceDerivedDistance
    case routeMissing
    case pauseOverlap
    case sampleGap
    case shortBucketDensityLimited
    case unrealisticSegmentPace
    case distanceSeriesUnusable
}

public struct PersonalBestEffortRecord: Codable, Equatable, Sendable {
    public var bucket: PersonalBestEffortBucket
    public var workoutID: String
    public var date: Date
    public var distanceMeters: Double
    public var durationSeconds: Double?
    public var paceSecondsPerKm: Double?
    public var method: PersonalBestEffortMethod
    public var confidence: PersonalBestEffortConfidence
    public var caveats: [PersonalBestEffortCaveat]
    public var segmentStartDate: Date?
    public var segmentEndDate: Date?
    public var sourceWorkoutDistanceMeters: Double?
}

public struct PersonalBestEffortRankedRecord: Codable, Equatable, Sendable {
    public var record: PersonalBestEffortRecord
    public var lifetimeRank: Int

    public init(record: PersonalBestEffortRecord, lifetimeRank: Int) {
        self.record = record
        self.lifetimeRank = lifetimeRank
    }
}

public struct PersonalBestEffortSummary: Codable, Equatable, Sendable {
    public var allTime: [PersonalBestEffortRecord]
    public var rankedAllTime: [PersonalBestEffortRankedRecord]

    public init(
        allTime: [PersonalBestEffortRecord],
        rankedAllTime: [PersonalBestEffortRankedRecord]? = nil
    ) {
        self.allTime = allTime
        self.rankedAllTime = rankedAllTime
            ?? PersonalBestEffortEngine.rankedRecords(from: allTime)
    }

    private enum CodingKeys: String, CodingKey {
        case allTime
        case rankedAllTime
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        allTime = try container.decode([PersonalBestEffortRecord].self, forKey: .allTime)
        rankedAllTime = try container.decodeIfPresent(
            [PersonalBestEffortRankedRecord].self,
            forKey: .rankedAllTime
        ) ?? PersonalBestEffortEngine.rankedRecords(from: allTime)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(allTime, forKey: .allTime)
        try container.encode(rankedAllTime, forKey: .rankedAllTime)
    }
}

public enum PersonalBestEffortEngine {
    public static func summarize(
        workouts: [CanonicalWorkout]
    ) -> PersonalBestEffortSummary {
        let included = workouts.filter { !$0.isDuplicate }
        let records = included.flatMap(records(for:))

        return summary(from: records)
    }

    static func summary(from records: [PersonalBestEffortRecord]) -> PersonalBestEffortSummary {
        let ranked = rankedRecords(from: records)
        let rankOneByBucket = Dictionary(
            uniqueKeysWithValues: ranked
                .filter { $0.lifetimeRank == 1 }
                .map { ($0.record.bucket, $0.record) }
        )
        let longestRun = bestLongestRun(from: records)
        let winners = PersonalBestEffortBucket.allCases.compactMap { bucket in
            bucket == .longestRun ? longestRun : rankOneByBucket[bucket]
        }
        return PersonalBestEffortSummary(allTime: winners, rankedAllTime: ranked)
    }

    static func rankedRecords(
        from records: [PersonalBestEffortRecord],
        limitPerBucket: Int = 3
    ) -> [PersonalBestEffortRankedRecord] {
        guard limitPerBucket > 0 else { return [] }
        let exactSegments = records.filter {
            $0.bucket.isSegmentBucket
                && $0.method == .exactSegment
                && $0.confidence == .exact
                && ($0.durationSeconds?.isFinite == true)
                && ($0.durationSeconds ?? 0) > 0
        }
        let deduplicated = Dictionary(grouping: exactSegments) {
            RankedRecordKey(bucket: $0.bucket, workoutID: $0.workoutID)
        }.compactMap { _, candidates in
            candidates.sorted(by: segmentRecordIsPreferred).first
        }
        let recordsByBucket = Dictionary(grouping: deduplicated, by: \.bucket)

        return PersonalBestEffortBucket.allCases
            .filter(\.isSegmentBucket)
            .flatMap { bucket in
                (recordsByBucket[bucket] ?? [])
                    .sorted(by: segmentRecordIsPreferred)
                    .prefix(limitPerBucket)
                    .enumerated()
                    .map { index, record in
                        PersonalBestEffortRankedRecord(
                            record: record,
                            lifetimeRank: index + 1
                        )
                    }
            }
    }

    static func merging(
        cached: PersonalBestEffortSummary?,
        computed: PersonalBestEffortSummary,
        replacingWorkoutIDs: Set<String> = []
    ) -> PersonalBestEffortSummary {
        let retainedCached = candidateRecords(in: cached)
            .filter { !replacingWorkoutIDs.contains($0.workoutID) }
        return summary(from: retainedCached + candidateRecords(in: computed))
    }

    static func candidateRecords(
        in summary: PersonalBestEffortSummary?
    ) -> [PersonalBestEffortRecord] {
        guard let summary else { return [] }
        return summary.rankedAllTime.map(\.record)
            + summary.allTime.filter { $0.bucket == .longestRun }
    }

    public static func records(for workout: CanonicalWorkout) -> [PersonalBestEffortRecord] {
        guard let workoutDistance = workout.distanceMeters, workoutDistance > 0 else { return [] }

        let sourceCaveats = distanceSourceCaveats(for: workout, evidence: workout.evidence)
        let distanceSeries = workout.evidence?.series[.distance]
        let timeline = distanceSeries.flatMap { DistanceTimeline(series: $0, workoutStart: workout.startDate) }
        let pauseIntervals = pauseIntervals(
            in: workout.evidence?.events ?? [],
            workoutStart: workout.startDate,
            workoutEnd: workout.endDate
        )

        var records = PersonalBestEffortBucket.allCases
            .filter(\.isSegmentBucket)
            .compactMap {
                record(
                    for: $0,
                    workout: workout,
                    workoutDistance: workoutDistance,
                    sourceCaveats: sourceCaveats,
                    hasDistanceSeries: distanceSeries != nil,
                    timeline: timeline,
                    pauseIntervals: pauseIntervals
                )
            }

        records.append(longestRunRecord(for: workout, workoutDistance: workoutDistance))
        return records
    }

    private static func record(
        for bucket: PersonalBestEffortBucket,
        workout: CanonicalWorkout,
        workoutDistance: Double,
        sourceCaveats: [PersonalBestEffortCaveat],
        hasDistanceSeries: Bool,
        timeline: DistanceTimeline?,
        pauseIntervals: [DateInterval]
    ) -> PersonalBestEffortRecord? {
        guard let target = bucket.distanceMeters, workoutDistance >= target else { return nil }

        if let timeline {
            let exact = exactSegmentRecord(
                bucket: bucket,
                workout: workout,
                target: target,
                timeline: timeline,
                sourceCaveats: sourceCaveats,
                pauseIntervals: pauseIntervals
            )
            if let record = exact.record {
                return record
            }
            return estimatedRecord(
                bucket: bucket,
                workout: workout,
                target: target,
                workoutDistance: workoutDistance,
                caveats: sourceCaveats + exact.fallbackCaveats
            )
        }

        if hasDistanceSeries {
            return estimatedRecord(
                bucket: bucket,
                workout: workout,
                target: target,
                workoutDistance: workoutDistance,
                caveats: sourceCaveats + [.distanceSeriesUnusable]
            )
        }

        return estimatedRecord(
            bucket: bucket,
            workout: workout,
            target: target,
            workoutDistance: workoutDistance,
            caveats: sourceCaveats + [.summaryOnlyEstimate]
        )
    }

    private static func exactSegmentRecord(
        bucket: PersonalBestEffortBucket,
        workout: CanonicalWorkout,
        target: Double,
        timeline: DistanceTimeline,
        sourceCaveats: [PersonalBestEffortCaveat],
        pauseIntervals: [DateInterval]
    ) -> (record: PersonalBestEffortRecord?, fallbackCaveats: [PersonalBestEffortCaveat]) {
        var bestWindow: SegmentWindow?
        var failureCaveats: [PersonalBestEffortCaveat] = []

        var endIndex = 0
        for startIndex in timeline.samples.indices {
            let startSample = timeline.samples[startIndex]
            let endDistance = startSample.cumulativeDistance + target
            endIndex = max(endIndex, startIndex)
            while endIndex < timeline.samples.count,
                  timeline.samples[endIndex].cumulativeDistance < endDistance {
                endIndex += 1
            }
            guard endIndex < timeline.samples.count else { continue }
            let endDate = timeline.interpolatedDate(
                targetDistance: endDistance,
                lowerSampleIndex: max(endIndex - 1, 0),
                upperSampleIndex: endIndex
            )
            guard endDate > startSample.date else { continue }

            var caveats = sourceCaveats
            caveats.append(contentsOf: qualityCaveats(
                bucket: bucket,
                startSampleIndex: startIndex,
                endSampleIndex: endIndex,
                end: endDate,
                timeline: timeline
            ))
            if pauseIntervals.contains(where: { overlaps($0, start: startSample.date, end: endDate) }) {
                caveats.append(.pauseOverlap)
            }

            let duration = endDate.timeIntervalSince(startSample.date)
            if isUnrealisticSegment(durationSeconds: duration, distanceMeters: target) {
                caveats.append(.unrealisticSegmentPace)
            }

            let hardFailures = caveats.filter { $0 == .sampleGap || $0 == .shortBucketDensityLimited || $0 == .unrealisticSegmentPace }
            if !hardFailures.isEmpty {
                failureCaveats.append(contentsOf: hardFailures)
                continue
            }

            let window = SegmentWindow(startDate: startSample.date, endDate: endDate, durationSeconds: duration, caveats: orderedUnique(caveats))
            if bestWindow.map({ duration < $0.durationSeconds }) ?? true {
                bestWindow = window
            }
        }

        guard let bestWindow else {
            var fallback = orderedUnique([.distanceSeriesUnusable] + failureCaveats)
            if fallback.isEmpty {
                fallback = [.distanceSeriesUnusable]
            }
            return (nil, fallback)
        }

        return (
            PersonalBestEffortRecord(
                bucket: bucket,
                workoutID: workout.id,
                date: workout.startDate,
                distanceMeters: target,
                durationSeconds: bestWindow.durationSeconds,
                paceSecondsPerKm: bestWindow.durationSeconds / (target / 1_000),
                method: .exactSegment,
                confidence: .exact,
                caveats: bestWindow.caveats,
                segmentStartDate: bestWindow.startDate,
                segmentEndDate: bestWindow.endDate,
                sourceWorkoutDistanceMeters: workout.distanceMeters
            ),
            []
        )
    }

    private static func estimatedRecord(
        bucket: PersonalBestEffortBucket,
        workout: CanonicalWorkout,
        target: Double,
        workoutDistance: Double,
        caveats: [PersonalBestEffortCaveat]
    ) -> PersonalBestEffortRecord? {
        let pace = PaceMath.paceSecondsPerKm(distanceMeters: workoutDistance, durationSeconds: workout.durationSeconds)
        let duration = pace.map { PaceMath.secondsForDistance(paceSecondsPerKm: $0, distanceMeters: target) }
        guard let duration, duration.isFinite, duration > 0 else { return nil }
        return PersonalBestEffortRecord(
            bucket: bucket,
            workoutID: workout.id,
            date: workout.startDate,
            distanceMeters: target,
            durationSeconds: duration,
            paceSecondsPerKm: duration / (target / 1_000),
            method: .wholeRunEstimate,
            confidence: .estimated,
            caveats: orderedUnique(caveats),
            segmentStartDate: nil,
            segmentEndDate: nil,
            sourceWorkoutDistanceMeters: workoutDistance
        )
    }

    private static func longestRunRecord(
        for workout: CanonicalWorkout,
        workoutDistance: Double
    ) -> PersonalBestEffortRecord {
        let pace = PaceMath.paceSecondsPerKm(distanceMeters: workoutDistance, durationSeconds: workout.durationSeconds)
        return PersonalBestEffortRecord(
            bucket: .longestRun,
            workoutID: workout.id,
            date: workout.startDate,
            distanceMeters: workoutDistance,
            durationSeconds: workout.durationSeconds,
            paceSecondsPerKm: pace,
            method: .totalDistance,
            confidence: .exactTotal,
            caveats: orderedUnique(distanceSourceCaveats(
                for: workout,
                evidence: workout.evidence
            )),
            segmentStartDate: nil,
            segmentEndDate: nil,
            sourceWorkoutDistanceMeters: workoutDistance
        )
    }

    private static func bestLongestRun(
        from records: [PersonalBestEffortRecord]
    ) -> PersonalBestEffortRecord? {
        records
            .filter {
                $0.bucket == .longestRun
                    && $0.method == .totalDistance
                    && $0.confidence == .exactTotal
            }
            .sorted(by: longestRunRecordIsPreferred)
            .first
    }

    private static func segmentRecordIsPreferred(
        _ lhs: PersonalBestEffortRecord,
        _ rhs: PersonalBestEffortRecord
    ) -> Bool {
        let lhsDuration = lhs.durationSeconds ?? .infinity
        let rhsDuration = rhs.durationSeconds ?? .infinity
        if lhsDuration != rhsDuration {
            return lhsDuration < rhsDuration
        }
        if lhs.date != rhs.date {
            return lhs.date > rhs.date
        }
        return lhs.workoutID < rhs.workoutID
    }

    private static func longestRunRecordIsPreferred(
        _ lhs: PersonalBestEffortRecord,
        _ rhs: PersonalBestEffortRecord
    ) -> Bool {
        if lhs.distanceMeters != rhs.distanceMeters {
            return lhs.distanceMeters > rhs.distanceMeters
        }
        if lhs.date != rhs.date {
            return lhs.date > rhs.date
        }
        return lhs.workoutID < rhs.workoutID
    }

    private static func distanceSourceCaveats(
        for workout: CanonicalWorkout,
        evidence: WorkoutEvidence?
    ) -> [PersonalBestEffortCaveat] {
        if workout.environment == .indoor {
            return [.indoorDeviceDerivedDistance]
        }
        if evidence?.series[.distance] != nil,
           (!workout.routeAvailable || evidence?.route.isEmpty != false) {
            return [.routeMissing]
        }
        return []
    }

    private static func qualityCaveats(
        bucket: PersonalBestEffortBucket,
        startSampleIndex: Int,
        endSampleIndex: Int,
        end: Date,
        timeline: DistanceTimeline
    ) -> [PersonalBestEffortCaveat] {
        var caveats: [PersonalBestEffortCaveat] = []
        if bucket.isShortSegmentBucket,
           timeline.rawSampleCount(
               startSampleIndex: startSampleIndex,
               endSampleIndex: endSampleIndex,
               end: end
           ) < 4 {
            caveats.append(.shortBucketDensityLimited)
        }

        // Phase 1 uses a flat 30s standard-bucket threshold. If ultra buckets are added later, make this distance-scaled.
        let maxGapSeconds: TimeInterval = bucket.isShortSegmentBucket ? 10 : 30
        if timeline.maximumRawSampleGapSeconds(
            startSampleIndex: startSampleIndex,
            endSampleIndex: endSampleIndex,
            end: end
        ) > maxGapSeconds {
            caveats.append(.sampleGap)
        }
        return caveats
    }

    private static func isUnrealisticSegment(durationSeconds: Double, distanceMeters: Double) -> Bool {
        guard durationSeconds.isFinite, distanceMeters > 0 else { return true }
        let paceSecondsPerKm = durationSeconds / (distanceMeters / 1_000)
        return paceSecondsPerKm < 90
    }

    private static func pauseIntervals(
        in events: [WorkoutEvidenceEvent],
        workoutStart: Date,
        workoutEnd: Date
    ) -> [DateInterval] {
        var intervals: [DateInterval] = []
        var pauseStart: Date?
        for event in events.sorted(by: { $0.startDate < $1.startDate }) {
            guard event.startDate >= workoutStart, event.startDate <= workoutEnd else { continue }
            switch pauseEventKind(for: event) {
            case .pause:
                if pauseStart == nil {
                    pauseStart = event.startDate
                }
            case .resume:
                if let start = pauseStart, event.startDate > start {
                    intervals.append(DateInterval(start: start, end: event.startDate))
                }
                pauseStart = nil
            case .toggle:
                if let start = pauseStart {
                    if event.startDate > start {
                        intervals.append(DateInterval(start: start, end: event.startDate))
                    }
                    pauseStart = nil
                } else {
                    pauseStart = event.startDate
                }
            case nil:
                continue
            }
        }
        if let pauseStart, workoutEnd > pauseStart {
            intervals.append(DateInterval(start: pauseStart, end: workoutEnd))
        }
        return intervals
    }

    private enum PauseEventKind {
        case pause
        case resume
        case toggle
    }

    private static func pauseEventKind(for event: WorkoutEvidenceEvent) -> PauseEventKind? {
        let text = "\(event.type) \(event.label ?? "")"
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "_", with: "")
            .lowercased()
        if text.contains("pauseorresumerequest") { return .toggle }
        if text.contains("motionpaused") { return .pause }
        if text.contains("motionresumed") { return .resume }
        if text.contains("resume") || text.contains("rawvalue:2") { return .resume }
        if text.contains("pause") || text.contains("rawvalue:1") { return .pause }
        return nil
    }

    private static func overlaps(_ interval: DateInterval, start: Date, end: Date) -> Bool {
        max(interval.start, start) < min(interval.end, end)
    }

    private static func orderedUnique(_ caveats: [PersonalBestEffortCaveat]) -> [PersonalBestEffortCaveat] {
        var seen: Set<PersonalBestEffortCaveat> = []
        var result: [PersonalBestEffortCaveat] = []
        for caveat in caveats where seen.insert(caveat).inserted {
            result.append(caveat)
        }
        return result
    }
}

private struct RankedRecordKey: Hashable {
    var bucket: PersonalBestEffortBucket
    var workoutID: String
}

private struct SegmentWindow {
    var startDate: Date
    var endDate: Date
    var durationSeconds: Double
    var caveats: [PersonalBestEffortCaveat]
}

private struct DistanceSample {
    var index: Int
    var date: Date
    var cumulativeDistance: Double
}

private struct DistanceTimeline {
    var samples: [DistanceSample]
    private var gapMaximumLevels: [[TimeInterval]]

    init?(series: WorkoutMetricSeries, workoutStart: Date) {
        guard series.points.count > 1 else { return nil }
        var samples = [DistanceSample(index: 0, date: workoutStart, cumulativeDistance: 0)]
        var total = 0.0
        for point in series.points {
            guard point.value >= 0 else { return nil }
            total += point.value
            guard total >= (samples.last?.cumulativeDistance ?? 0) else { return nil }
            samples.append(DistanceSample(index: samples.count, date: point.date, cumulativeDistance: total))
        }
        guard total > 0 else { return nil }
        self.samples = samples
        var gaps = Array(repeating: 0.0, count: samples.count)
        for index in 1..<samples.count {
            gaps[index] = samples[index].date.timeIntervalSince(samples[index - 1].date)
        }
        var levels = [gaps]
        var width = 2
        while width <= samples.count {
            let half = width / 2
            let previous = levels[levels.count - 1]
            var next = previous
            for index in 0...(samples.count - width) {
                next[index] = max(previous[index], previous[index + half])
            }
            levels.append(next)
            width *= 2
        }
        self.gapMaximumLevels = levels
    }

    func interpolatedDate(targetDistance: Double, lowerSampleIndex: Int, upperSampleIndex: Int) -> Date {
        let lower = samples[max(0, min(lowerSampleIndex, samples.count - 1))]
        let upper = samples[max(0, min(upperSampleIndex, samples.count - 1))]
        let distanceDelta = upper.cumulativeDistance - lower.cumulativeDistance
        guard distanceDelta > 0 else { return upper.date }
        let ratio = min(max((targetDistance - lower.cumulativeDistance) / distanceDelta, 0), 1)
        return lower.date.addingTimeInterval(upper.date.timeIntervalSince(lower.date) * ratio)
    }

    func rawSampleCount(startSampleIndex: Int, endSampleIndex: Int, end: Date) -> Int {
        let bounds = rawSampleBounds(
            startSampleIndex: startSampleIndex,
            endSampleIndex: endSampleIndex,
            end: end
        )
        guard bounds.first <= bounds.last else { return 0 }
        return bounds.last - bounds.first + 1
    }

    func maximumRawSampleGapSeconds(
        startSampleIndex: Int,
        endSampleIndex: Int,
        end: Date
    ) -> TimeInterval {
        let start = samples[startSampleIndex].date
        let bounds = rawSampleBounds(
            startSampleIndex: startSampleIndex,
            endSampleIndex: endSampleIndex,
            end: end
        )
        guard bounds.first <= bounds.last else {
            return end.timeIntervalSince(start)
        }

        let leadingGap = samples[bounds.first].date.timeIntervalSince(start)
        let trailingGap = end.timeIntervalSince(samples[bounds.last].date)
        let internalGap = maximumGap(from: bounds.first + 1, through: bounds.last)
        return max(leadingGap, trailingGap, internalGap)
    }

    private func rawSampleBounds(
        startSampleIndex: Int,
        endSampleIndex: Int,
        end: Date
    ) -> (first: Int, last: Int) {
        let first = max(startSampleIndex, 1)
        let includesUpperSample = samples[endSampleIndex].date <= end
        let last = includesUpperSample ? endSampleIndex : endSampleIndex - 1
        return (first, last)
    }

    private func maximumGap(from lowerIndex: Int, through upperIndex: Int) -> TimeInterval {
        guard lowerIndex <= upperIndex else { return 0 }
        let length = upperIndex - lowerIndex + 1
        let level = Int.bitWidth - 1 - length.leadingZeroBitCount
        let width = 1 << level
        return max(
            gapMaximumLevels[level][lowerIndex],
            gapMaximumLevels[level][upperIndex - width + 1]
        )
    }
}
