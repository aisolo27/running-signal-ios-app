import Foundation

public enum PersonalBestEffortBucket: String, Codable, CaseIterable, Sendable {
    case fourHundredMeters
    case halfMile
    case oneKilometer
    case oneMile
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

public struct PersonalBestEffortSummary: Codable, Equatable, Sendable {
    public var allTime: [PersonalBestEffortRecord]
}

public enum PersonalBestEffortEngine {
    public static func summarize(
        workouts: [CanonicalWorkout]
    ) -> PersonalBestEffortSummary {
        let included = workouts.filter { !$0.isDuplicate }
        let records = included.flatMap(records(for:))

        return PersonalBestEffortSummary(
            allTime: bestRecords(from: records)
        )
    }

    public static func records(for workout: CanonicalWorkout) -> [PersonalBestEffortRecord] {
        guard let workoutDistance = workout.distanceMeters, workoutDistance > 0 else { return [] }

        var records = PersonalBestEffortBucket.allCases
            .filter(\.isSegmentBucket)
            .compactMap { record(for: $0, workout: workout, workoutDistance: workoutDistance) }

        records.append(longestRunRecord(for: workout, workoutDistance: workoutDistance))
        return records
    }

    private static func record(
        for bucket: PersonalBestEffortBucket,
        workout: CanonicalWorkout,
        workoutDistance: Double
    ) -> PersonalBestEffortRecord? {
        guard let target = bucket.distanceMeters, workoutDistance >= target else { return nil }
        let sourceCaveats = distanceSourceCaveats(for: workout, evidence: workout.evidence)

        if let series = workout.evidence?.series[.distance] {
            let exact = exactSegmentRecord(
                bucket: bucket,
                workout: workout,
                target: target,
                series: series,
                sourceCaveats: sourceCaveats
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
        series: WorkoutMetricSeries,
        sourceCaveats: [PersonalBestEffortCaveat]
    ) -> (record: PersonalBestEffortRecord?, fallbackCaveats: [PersonalBestEffortCaveat]) {
        guard let timeline = DistanceTimeline(series: series, workoutStart: workout.startDate) else {
            return (nil, [.distanceSeriesUnusable])
        }

        let pauseIntervals = pauseIntervals(in: workout.evidence?.events ?? [], workoutStart: workout.startDate, workoutEnd: workout.endDate)
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
                start: startSample.date,
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

    private static func bestRecords(from records: [PersonalBestEffortRecord]) -> [PersonalBestEffortRecord] {
        PersonalBestEffortBucket.allCases.compactMap { bucket in
            let bucketRecords = records.filter { $0.bucket == bucket }
            guard !bucketRecords.isEmpty else { return nil }
            if bucket == .longestRun {
                return bucketRecords.max(by: longestRunLessPreferred)
            }
            let evidenceBackedRecords = bucketRecords.filter { $0.confidence != .estimated }
            guard !evidenceBackedRecords.isEmpty else { return nil }
            return evidenceBackedRecords.min(by: segmentLessPreferred)
        }
    }

    private static func segmentLessPreferred(_ lhs: PersonalBestEffortRecord, _ rhs: PersonalBestEffortRecord) -> Bool {
        let lhsRank = confidenceRank(lhs.confidence)
        let rhsRank = confidenceRank(rhs.confidence)
        if lhsRank != rhsRank {
            return lhsRank > rhsRank
        }
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

    private static func longestRunLessPreferred(_ lhs: PersonalBestEffortRecord, _ rhs: PersonalBestEffortRecord) -> Bool {
        if lhs.distanceMeters != rhs.distanceMeters {
            return lhs.distanceMeters < rhs.distanceMeters
        }
        if lhs.date != rhs.date {
            return lhs.date < rhs.date
        }
        return lhs.workoutID > rhs.workoutID
    }

    private static func confidenceRank(_ confidence: PersonalBestEffortConfidence) -> Int {
        switch confidence {
        case .exactTotal: 3
        case .exact: 2
        case .estimated: 1
        case .unavailable: 0
        }
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
        start: Date,
        end: Date,
        timeline: DistanceTimeline
    ) -> [PersonalBestEffortCaveat] {
        var caveats: [PersonalBestEffortCaveat] = []
        let rawSamples = timeline.rawSamples(in: start...end)
        if bucket.isShortSegmentBucket, rawSamples.count < 4 {
            caveats.append(.shortBucketDensityLimited)
        }

        // Phase 1 uses a flat 30s standard-bucket threshold. If ultra buckets are added later, make this distance-scaled.
        let maxGapSeconds: TimeInterval = bucket.isShortSegmentBucket ? 10 : 30
        if timeline.maximumRawSampleGapSeconds(start: start, end: end) > maxGapSeconds {
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
    }

    func interpolatedDate(targetDistance: Double, lowerSampleIndex: Int, upperSampleIndex: Int) -> Date {
        let lower = samples[max(0, min(lowerSampleIndex, samples.count - 1))]
        let upper = samples[max(0, min(upperSampleIndex, samples.count - 1))]
        let distanceDelta = upper.cumulativeDistance - lower.cumulativeDistance
        guard distanceDelta > 0 else { return upper.date }
        let ratio = min(max((targetDistance - lower.cumulativeDistance) / distanceDelta, 0), 1)
        return lower.date.addingTimeInterval(upper.date.timeIntervalSince(lower.date) * ratio)
    }

    func rawSamples(in range: ClosedRange<Date>) -> [DistanceSample] {
        samples.dropFirst().filter { range.contains($0.date) }
    }

    func maximumRawSampleGapSeconds(start: Date, end: Date) -> TimeInterval {
        let dates = [start] + rawSamples(in: start...end).map(\.date) + [end]
        guard dates.count > 1 else { return end.timeIntervalSince(start) }
        return zip(dates, dates.dropFirst())
            .map { $1.timeIntervalSince($0) }
            .max() ?? 0
    }
}
