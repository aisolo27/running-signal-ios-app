import Foundation

public enum HeartRateZoneMethod: String, Codable, CaseIterable, Identifiable, Sendable {
    case automaticHeartRateReserve
    case percentMaximum
    case manual

    public var id: String { rawValue }

    public var label: String {
        switch self {
        case .automaticHeartRateReserve: "Automatic HRR"
        case .percentMaximum: "% Maximum HR"
        case .manual: "Manual"
        }
    }

    public var detail: String {
        switch self {
        case .automaticHeartRateReserve:
            "Uses the latest resting heart rate and the highest credible running heart rate from the previous six months."
        case .percentMaximum:
            "Uses percentages of the highest credible running heart rate from the previous six months."
        case .manual:
            "Uses four boundaries that define where Zones 2 through 5 begin."
        }
    }
}

public struct HeartRateZoneRange: Identifiable, Equatable, Sendable {
    public var id: Int { zone }
    public let zone: Int
    public let lowerBound: Int?
    public let upperBound: Int?

    public func contains(_ beatsPerMinute: Double) -> Bool {
        if let lowerBound, beatsPerMinute < Double(lowerBound) { return false }
        if let upperBound, beatsPerMinute > Double(upperBound) { return false }
        return true
    }

    public var displayRange: String {
        switch (lowerBound, upperBound) {
        case (nil, let upper?): "≤\(upper) bpm"
        case (let lower?, nil): "\(lower)+ bpm"
        case (let lower?, let upper?): "\(lower)–\(upper) bpm"
        case (nil, nil): "Unavailable"
        }
    }
}

public struct ManualHeartRateZoneBoundaries: Equatable, Sendable {
    public static let defaultLowerBounds = [136, 150, 165, 179]

    public private(set) var zoneLowerBounds: [Int]

    public init(zoneLowerBounds: [Int] = Self.defaultLowerBounds) {
        self.zoneLowerBounds = Self.isValid(zoneLowerBounds)
            ? zoneLowerBounds
            : Self.defaultLowerBounds
    }

    public var ranges: [HeartRateZoneRange] {
        [
            HeartRateZoneRange(zone: 1, lowerBound: nil, upperBound: zoneLowerBounds[0] - 1),
            HeartRateZoneRange(zone: 2, lowerBound: zoneLowerBounds[0], upperBound: zoneLowerBounds[1] - 1),
            HeartRateZoneRange(zone: 3, lowerBound: zoneLowerBounds[1], upperBound: zoneLowerBounds[2] - 1),
            HeartRateZoneRange(zone: 4, lowerBound: zoneLowerBounds[2], upperBound: zoneLowerBounds[3] - 1),
            HeartRateZoneRange(zone: 5, lowerBound: zoneLowerBounds[3], upperBound: nil)
        ]
    }

    public func lowerLimit(for zone: Int) -> Int? {
        guard (2...5).contains(zone) else { return nil }
        return zoneLowerBounds[zone - 2]
    }

    public func upperLimit(for zone: Int) -> Int? {
        guard (1...4).contains(zone) else { return nil }
        return zoneLowerBounds[zone - 1] - 1
    }

    public mutating func setLowerLimit(_ beatsPerMinute: Int, for zone: Int) {
        guard (2...5).contains(zone) else { return }
        setBoundary(at: zone - 2, to: beatsPerMinute)
    }

    public mutating func setUpperLimit(_ beatsPerMinute: Int, for zone: Int) {
        guard (1...4).contains(zone) else { return }
        setBoundary(at: zone - 1, to: beatsPerMinute + 1)
    }

    private mutating func setBoundary(at index: Int, to value: Int) {
        let minimum = index == 0 ? 31 : zoneLowerBounds[index - 1] + 1
        let maximum = index == zoneLowerBounds.count - 1 ? 230 : zoneLowerBounds[index + 1] - 1
        zoneLowerBounds[index] = min(max(value, minimum), maximum)
    }

    private static func isValid(_ values: [Int]) -> Bool {
        values.count == 4
            && values.allSatisfy { (31...230).contains($0) }
            && zip(values, values.dropFirst()).allSatisfy(<)
    }
}

public struct HeartRateZoneProfile: Codable, Equatable, Identifiable, Sendable {
    public let id: String
    public let effectiveDate: Date
    public let createdAt: Date
    public let method: HeartRateZoneMethod
    public let restingHeartRate: Int?
    public let maximumHeartRate: Int?
    public let maximumHeartRateIsUserOverride: Bool
    public let zoneLowerBounds: [Int]
    public let lookbackMonths: Int?
    public let sourceDetail: String
    public let isHistoricalBackfill: Bool

    private enum CodingKeys: String, CodingKey {
        case id
        case effectiveDate
        case createdAt
        case method
        case restingHeartRate
        case maximumHeartRate
        case maximumHeartRateIsUserOverride
        case zoneLowerBounds
        case lookbackMonths
        case sourceDetail
        case isHistoricalBackfill
    }

    public init(
        id: String = UUID().uuidString,
        effectiveDate: Date,
        createdAt: Date,
        method: HeartRateZoneMethod,
        restingHeartRate: Int?,
        maximumHeartRate: Int?,
        maximumHeartRateIsUserOverride: Bool = false,
        zoneLowerBounds: [Int],
        lookbackMonths: Int?,
        sourceDetail: String,
        isHistoricalBackfill: Bool = false
    ) {
        self.id = id
        self.effectiveDate = effectiveDate
        self.createdAt = createdAt
        self.method = method
        self.restingHeartRate = restingHeartRate
        self.maximumHeartRate = maximumHeartRate
        self.maximumHeartRateIsUserOverride = maximumHeartRateIsUserOverride
        self.zoneLowerBounds = zoneLowerBounds
        self.lookbackMonths = lookbackMonths
        self.sourceDetail = sourceDetail
        self.isHistoricalBackfill = isHistoricalBackfill
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        effectiveDate = try container.decode(Date.self, forKey: .effectiveDate)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        method = try container.decode(HeartRateZoneMethod.self, forKey: .method)
        restingHeartRate = try container.decodeIfPresent(Int.self, forKey: .restingHeartRate)
        maximumHeartRate = try container.decodeIfPresent(Int.self, forKey: .maximumHeartRate)
        maximumHeartRateIsUserOverride = try container.decodeIfPresent(
            Bool.self,
            forKey: .maximumHeartRateIsUserOverride
        ) ?? false
        zoneLowerBounds = try container.decode([Int].self, forKey: .zoneLowerBounds)
        lookbackMonths = try container.decodeIfPresent(Int.self, forKey: .lookbackMonths)
        sourceDetail = try container.decode(String.self, forKey: .sourceDetail)
        isHistoricalBackfill = try container.decodeIfPresent(Bool.self, forKey: .isHistoricalBackfill) ?? false
    }

    public var isValid: Bool {
        zoneLowerBounds.count == 4
            && zip(zoneLowerBounds, zoneLowerBounds.dropFirst()).allSatisfy(<)
    }

    public var ranges: [HeartRateZoneRange] {
        guard isValid else { return [] }
        return [
            HeartRateZoneRange(zone: 1, lowerBound: nil, upperBound: zoneLowerBounds[0] - 1),
            HeartRateZoneRange(zone: 2, lowerBound: zoneLowerBounds[0], upperBound: zoneLowerBounds[1] - 1),
            HeartRateZoneRange(zone: 3, lowerBound: zoneLowerBounds[1], upperBound: zoneLowerBounds[2] - 1),
            HeartRateZoneRange(zone: 4, lowerBound: zoneLowerBounds[2], upperBound: zoneLowerBounds[3] - 1),
            HeartRateZoneRange(zone: 5, lowerBound: zoneLowerBounds[3], upperBound: nil)
        ]
    }

    public func zone(for beatsPerMinute: Double) -> Int? {
        ranges.first { $0.contains(beatsPerMinute) }?.zone
    }
}

public struct AutomaticHeartRateZoneInputs: Equatable, Sendable {
    public let restingHeartRate: Int
    public let maximumHeartRate: Int
    public let maximumHeartRateDate: Date?
    public let lookbackMonths: Int
}

public struct MaximumHeartRateLookbackResult: Equatable, Sendable {
    public let maximumHeartRate: Int
    public let maximumHeartRateDate: Date?
    public let lookbackMonths: Int
}

public enum HeartRateZoneProfileFactory {
    public static let automaticLookbackMonths = 6

    public static func automaticInputs(
        workouts: [CanonicalWorkout],
        healthContext: HealthContext,
        now: Date = Date(),
        calendar: Calendar = .current
    ) -> AutomaticHeartRateZoneInputs? {
        guard let restingValue = healthContext.restingHeartRate,
              restingValue >= 30,
              restingValue <= 120 else { return nil }
        guard let maximumInput = maximumHeartRateInput(
            workouts: workouts,
            now: now,
            calendar: calendar
        ) else { return nil }
        let resting = Int(restingValue.rounded())
        guard maximumInput.maximumHeartRate >= resting + 20 else { return nil }
        return AutomaticHeartRateZoneInputs(
            restingHeartRate: resting,
            maximumHeartRate: maximumInput.maximumHeartRate,
            maximumHeartRateDate: maximumInput.maximumHeartRateDate,
            lookbackMonths: maximumInput.lookbackMonths
        )
    }

    public static func maximumHeartRateInput(
        workouts: [CanonicalWorkout],
        now: Date = Date(),
        calendar: Calendar = .current
    ) -> MaximumHeartRateLookbackResult? {
        let cutoff = calendar.date(
            byAdding: .month,
            value: -automaticLookbackMonths,
            to: now
        ) ?? now.addingTimeInterval(-182 * 86_400)
        let candidate = workouts
            .filter {
                !$0.isDuplicate
                    && $0.dataSourceLabel == "real HealthKit"
                    && $0.startDate >= cutoff
                    && $0.startDate <= now.addingTimeInterval(300)
            }
            .compactMap { workout -> (CanonicalWorkout, Double)? in
                guard let maximum = workout.maxHeartRate, maximum >= 80, maximum <= 230 else { return nil }
                return (workout, maximum)
            }
            .max { $0.1 < $1.1 }
        guard let candidate else { return nil }
        let maximum = Int(candidate.1.rounded())
        return MaximumHeartRateLookbackResult(
            maximumHeartRate: maximum,
            maximumHeartRateDate: candidate.0.startDate,
            lookbackMonths: automaticLookbackMonths
        )
    }

    public static func automaticProfile(
        inputs: AutomaticHeartRateZoneInputs,
        effectiveDate: Date,
        createdAt: Date,
        isHistoricalBackfill: Bool = false,
        maximumHeartRateIsUserOverride: Bool = false
    ) -> HeartRateZoneProfile {
        let reserve = inputs.maximumHeartRate - inputs.restingHeartRate
        let bounds = [0.60, 0.70, 0.80, 0.90].map { percentage in
            Int(floor(Double(inputs.restingHeartRate) + (Double(reserve) * percentage)))
        }
        return HeartRateZoneProfile(
            effectiveDate: effectiveDate,
            createdAt: createdAt,
            method: .automaticHeartRateReserve,
            restingHeartRate: inputs.restingHeartRate,
            maximumHeartRate: inputs.maximumHeartRate,
            maximumHeartRateIsUserOverride: maximumHeartRateIsUserOverride,
            zoneLowerBounds: bounds,
            lookbackMonths: inputs.lookbackMonths,
            sourceDetail: maximumHeartRateIsUserOverride
                ? "Latest Apple Health resting HR + user-confirmed maximum HR"
                : "Latest Apple Health resting HR + six-month running max",
            isHistoricalBackfill: isHistoricalBackfill
        )
    }

    public static func percentMaximumProfile(
        maximumInput: MaximumHeartRateLookbackResult,
        effectiveDate: Date,
        createdAt: Date,
        maximumHeartRateIsUserOverride: Bool = false
    ) -> HeartRateZoneProfile {
        let bounds = [0.60, 0.70, 0.80, 0.90].map { percentage in
            Int(floor(Double(maximumInput.maximumHeartRate) * percentage))
        }
        return HeartRateZoneProfile(
            effectiveDate: effectiveDate,
            createdAt: createdAt,
            method: .percentMaximum,
            restingHeartRate: nil,
            maximumHeartRate: maximumInput.maximumHeartRate,
            maximumHeartRateIsUserOverride: maximumHeartRateIsUserOverride,
            zoneLowerBounds: bounds,
            lookbackMonths: maximumInput.lookbackMonths,
            sourceDetail: maximumHeartRateIsUserOverride ? "User-confirmed maximum HR" : "Six-month running max",
            isHistoricalBackfill: false
        )
    }

    public static func manualProfile(
        zoneLowerBounds: [Int],
        effectiveDate: Date,
        createdAt: Date
    ) -> HeartRateZoneProfile? {
        let profile = HeartRateZoneProfile(
            effectiveDate: effectiveDate,
            createdAt: createdAt,
            method: .manual,
            restingHeartRate: nil,
            maximumHeartRate: nil,
            maximumHeartRateIsUserOverride: false,
            zoneLowerBounds: zoneLowerBounds,
            lookbackMonths: nil,
            sourceDetail: "RunSignal manual zones",
            isHistoricalBackfill: false
        )
        return profile.isValid ? profile : nil
    }
}

public enum HeartRateZoneProfilePersistence {
    public static let defaultsKey = "RunSignal.HeartRateZoneProfiles.v1"

    public static func load(defaults: UserDefaults = .standard) -> [HeartRateZoneProfile] {
        guard let data = defaults.data(forKey: defaultsKey),
              let profiles = try? JSONDecoder().decode([HeartRateZoneProfile].self, from: data) else {
            return []
        }
        return profiles.filter(\.isValid).sorted { $0.effectiveDate < $1.effectiveDate }
    }

    public static func save(_ profiles: [HeartRateZoneProfile], defaults: UserDefaults = .standard) {
        guard let data = try? JSONEncoder().encode(profiles.sorted { $0.effectiveDate < $1.effectiveDate }) else { return }
        defaults.set(data, forKey: defaultsKey)
    }
}

public enum HeartRateZoneProfileTimeline {
    public static func profile(
        for workoutDate: Date,
        profiles: [HeartRateZoneProfile]
    ) -> HeartRateZoneProfile? {
        profiles
            .filter { $0.effectiveDate <= workoutDate }
            .max { $0.effectiveDate < $1.effectiveDate }
    }
}

public struct HeartRateZoneDuration: Identifiable, Equatable, Sendable {
    public var id: Int { zone }
    public let zone: Int
    public var durationSeconds: Double
}

public struct HeartRateZoneSample: Identifiable, Equatable, Sendable {
    public var id: Date { date }
    public let date: Date
    public let offsetSeconds: Double
    public let beatsPerMinute: Double
    public let zone: Int
}

public struct HeartRateZoneAnalysis: Identifiable, Equatable, Sendable {
    public var id: String { "\(workoutID)|\(profile.id)" }
    public let workoutID: String
    public let profile: HeartRateZoneProfile
    public let durations: [HeartRateZoneDuration]
    public let samples: [HeartRateZoneSample]
    public let classifiedDurationSeconds: Double
    public let unclassifiedDurationSeconds: Double
    public let caveat: String?
}

public enum HeartRateZoneAnalyzer {
    public static func analyze(
        workout: CanonicalWorkout,
        profile: HeartRateZoneProfile,
        maximumSampleGapSeconds: Double = 30
    ) -> HeartRateZoneAnalysis? {
        guard profile.isValid,
              let points = workout.evidence?.series[.heartRate]?.points,
              !points.isEmpty else { return nil }

        let pauseResolution = reliablePauseIntervals(
            events: workout.evidence?.events ?? [],
            workoutStart: workout.startDate,
            workoutEnd: workout.endDate
        )
        var durations = Dictionary(uniqueKeysWithValues: (1...5).map { ($0, 0.0) })
        var samples: [HeartRateZoneSample] = []

        for (index, point) in points.enumerated() {
            guard let zone = profile.zone(for: point.value) else { continue }
            let sampleStart = max(point.date, workout.startDate)
            let followingDate = index + 1 < points.count ? points[index + 1].date : workout.endDate
            let uncappedEnd = min(followingDate, workout.endDate)
            let sampleEnd = min(uncappedEnd, sampleStart.addingTimeInterval(maximumSampleGapSeconds))
            guard sampleEnd > sampleStart else { continue }
            var duration = sampleEnd.timeIntervalSince(sampleStart)
            for pause in pauseResolution.intervals {
                let overlapStart = max(sampleStart, pause.start)
                let overlapEnd = min(sampleEnd, pause.end)
                if overlapEnd > overlapStart {
                    duration -= overlapEnd.timeIntervalSince(overlapStart)
                }
            }
            if duration > 0 {
                durations[zone, default: 0] += duration
            }
            samples.append(
                HeartRateZoneSample(
                    date: point.date,
                    offsetSeconds: point.date.timeIntervalSince(workout.startDate),
                    beatsPerMinute: point.value,
                    zone: zone
                )
            )
        }

        let rows = (1...5).map { HeartRateZoneDuration(zone: $0, durationSeconds: durations[$0] ?? 0) }
        let classified = rows.map(\.durationSeconds).reduce(0, +)
        return HeartRateZoneAnalysis(
            workoutID: workout.id,
            profile: profile,
            durations: rows,
            samples: samples,
            classifiedDurationSeconds: classified,
            unclassifiedDurationSeconds: max(0, workout.durationSeconds - classified),
            caveat: pauseResolution.caveat
        )
    }

    private static func reliablePauseIntervals(
        events: [WorkoutEvidenceEvent],
        workoutStart: Date,
        workoutEnd: Date
    ) -> (intervals: [DateInterval], caveat: String?) {
        let normalizedEvents = events.compactMap { event -> PauseResolutionEvent? in
            let kind: PauseResolutionEventKind?
            switch event.kind {
            case .pause, .motionPaused: kind = .pause
            case .resume, .motionResumed: kind = .resume
            case .pauseOrResumeRequest: kind = .toggle
            case .lap, .marker, .segment, .unknown, .none:
                let display = event.displayLabel.lowercased()
                if display.contains("pause/resume") {
                    kind = .toggle
                } else if display.contains("resume") {
                    kind = .resume
                } else if display.contains("pause") {
                    kind = .pause
                } else {
                    kind = nil
                }
            }
            return kind.map { PauseResolutionEvent(timestamp: event.startDate, kind: $0) }
        }
        let resolution = PauseWindowResolver.resolve(
            events: normalizedEvents,
            workoutStart: workoutStart,
            workoutEnd: workoutEnd
        )
        guard resolution.isReliableForNormalDetail else {
            return (
                [],
                "Zone times use the heart-rate readings Apple Health recorded. Paused time may be included when Apple Health did not provide a clear pause window."
            )
        }
        return (resolution.intervals, nil)
    }
}
