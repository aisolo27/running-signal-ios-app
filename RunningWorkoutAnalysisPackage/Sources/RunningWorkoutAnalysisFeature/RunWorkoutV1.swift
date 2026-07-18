import Foundation

public struct RunWorkout: Identifiable, Equatable, Sendable {
    public var id: String { workout.id }
    public var workout: CanonicalWorkout

    public init(workout: CanonicalWorkout) {
        self.workout = workout
    }

    public var displayName: String {
        if workout.environment == .outdoor {
            return "Outdoor Run"
        }
        if workout.environment == .indoor {
            return "Indoor Run"
        }
        return "Running Workout"
    }

    public var customWorkoutName: String? {
        let storedName = workout.workoutPlanName?.trimmingCharacters(in: .whitespacesAndNewlines)
        if let storedName, !storedName.isEmpty {
            return storedName
        }
        let evidenceName = workout.evidence?.workoutPlanAudit?.displayName?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        if let evidenceName, !evidenceName.isEmpty {
            return evidenceName
        }
        return nil
    }

    public var runnerFacingTitle: String {
        if let customWorkoutName {
            guard workout.environment != .unknown else { return customWorkoutName }
            return "\(customWorkoutName) (\(workout.environment.label))"
        }

        let categoryTitle: String? = switch workout.effectiveRunType.visibleCategory {
        case .easy: "Easy Run"
        case .longRun: "Long Run"
        case .interval: "Interval Run"
        case .threshold: "Threshold Run"
        case .race: "Race"
        default: nil
        }
        guard let categoryTitle else { return displayName }
        guard workout.environment != .unknown else { return categoryTitle }
        return "\(categoryTitle) (\(workout.environment.label))"
    }

    public var categoryLabel: String {
        workout.effectiveRunType.visibleCategory.label
    }
}

enum PlannedWorkoutTargetPresentation {
    static func runnerText(
        _ rawText: String?,
        policy: RunDisplayPolicy = .kilometersOnly
    ) -> String? {
        guard let rawText else { return nil }
        let trimmed = rawText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        guard let legacyPace = LegacyPace.parse(trimmed) else { return rawText }

        guard let upperSecondsPerKm = legacyPace.upperSecondsPerKm else {
            return RunFormatters.pace(legacyPace.lowerSecondsPerKm, policy: policy)
        }
        return runnerPaceRange(
            lowerSecondsPerKm: legacyPace.lowerSecondsPerKm,
            upperSecondsPerKm: upperSecondsPerKm,
            policy: policy
        )
    }

    static func runnerPaceRange(
        lowerSecondsPerKm: Double,
        upperSecondsPerKm: Double,
        policy: RunDisplayPolicy
    ) -> String {
        let suffix = policy.primaryUnit.paceSuffix
        let lower = RunFormatters.pace(lowerSecondsPerKm, policy: policy)
        let upper = RunFormatters.pace(upperSecondsPerKm, policy: policy)
        let compactLower = lower.hasSuffix(suffix)
            ? String(lower.dropLast(suffix.count))
            : lower
        return "\(compactLower)–\(upper)"
    }

    private struct LegacyPace {
        let lowerSecondsPerKm: Double
        let upperSecondsPerKm: Double?

        static func parse(_ text: String) -> Self? {
            if let values = captures(in: text, using: rangePattern),
               values.count == 5,
               let lower = seconds(minutes: values[0], seconds: values[1]),
               let upper = seconds(minutes: values[2], seconds: values[3]),
               let unit = unit(values[4]) {
                return LegacyPace(
                    lowerSecondsPerKm: canonicalSecondsPerKm(lower, sourceUnit: unit),
                    upperSecondsPerKm: canonicalSecondsPerKm(upper, sourceUnit: unit)
                )
            }

            if let values = captures(in: text, using: singlePattern),
               values.count == 3,
               let value = seconds(minutes: values[0], seconds: values[1]),
               let unit = unit(values[2]) {
                return LegacyPace(
                    lowerSecondsPerKm: canonicalSecondsPerKm(value, sourceUnit: unit),
                    upperSecondsPerKm: nil
                )
            }

            return nil
        }

        private static let auditSuffix = #"(?:,\s*speed\s+[^,]+(?:,\s*metric\s+.+)?)?"#
        private static let rangePattern = try! NSRegularExpression(
            pattern: #"^(?:pace\s+range\s+)?(\d{1,3}):([0-5]\d)\s*[-–—]\s*(\d{1,3}):([0-5]\d)\s*/\s*(km|mi)\s*"#
                + auditSuffix
                + #"$"#,
            options: [.caseInsensitive]
        )
        private static let singlePattern = try! NSRegularExpression(
            pattern: #"^(?:pace\s+)?(\d{1,3}):([0-5]\d)\s*/\s*(km|mi)\s*"#
                + auditSuffix
                + #"$"#,
            options: [.caseInsensitive]
        )

        private static func captures(
            in text: String,
            using expression: NSRegularExpression
        ) -> [String]? {
            let fullRange = NSRange(text.startIndex..<text.endIndex, in: text)
            guard let match = expression.firstMatch(in: text, range: fullRange),
                  match.range == fullRange else { return nil }
            return (1..<match.numberOfRanges).compactMap { index in
                guard let range = Range(match.range(at: index), in: text) else { return nil }
                return String(text[range])
            }
        }

        private static func seconds(minutes: String, seconds: String) -> Double? {
            guard let minutes = Double(minutes), let seconds = Double(seconds) else { return nil }
            return minutes * 60 + seconds
        }

        private static func unit(_ rawValue: String) -> RunningDistanceUnit? {
            switch rawValue.lowercased() {
            case "km": .kilometers
            case "mi": .miles
            default: nil
            }
        }

        private static func canonicalSecondsPerKm(
            _ secondsPerSourceUnit: Double,
            sourceUnit: RunningDistanceUnit
        ) -> Double {
            secondsPerSourceUnit / (sourceUnit.metersPerUnit / 1_000)
        }
    }
}

public struct RunWorkoutSegments: Equatable, Sendable {
    public var workoutID: String
    public var kilometerSplits: [DerivedSplitEstimate]
    public var splitSource: DerivedSplitSource
    public var splitUnavailableReason: String?
    public var mileSplits: [DerivedSplitEstimate]
    public var mileSplitSource: DerivedSplitSource
    public var mileSplitUnavailableReason: String?
    public var events: [WorkoutEvidenceEvent]
    public var eventSummary: WorkoutEventSummary

    public init(workout: CanonicalWorkout, analysis: DerivedWorkoutAnalysis?) {
        workoutID = workout.id
        let derivedSplits = analysis?.splitEstimates ?? []
        kilometerSplits = derivedSplits
        splitSource = analysis?.splitSource ?? {
            guard let confidence = derivedSplits.first?.confidence else { return .unavailable }
            return confidence == .strong ? .validatedSegmentEvents : .distanceSampleWindows
        }()
        splitUnavailableReason = analysis?.splitUnavailableReason
        let derivedMileSplits = analysis?.mileSplitEstimates ?? []
        mileSplits = derivedMileSplits
        mileSplitSource = analysis?.mileSplitSource ?? {
            guard let confidence = derivedMileSplits.first?.confidence else { return .unavailable }
            return confidence == .strong ? .validatedSegmentEvents : .distanceSampleWindows
        }()
        mileSplitUnavailableReason = analysis?.mileSplitUnavailableReason
        events = workout.evidence?.events ?? []
        eventSummary = WorkoutEventSummary(events: events)
    }

    public func splits(for unit: RunningDistanceUnit) -> [DerivedSplitEstimate] {
        switch unit {
        case .kilometers: kilometerSplits
        case .miles: mileSplits
        }
    }

    public func splitSource(for unit: RunningDistanceUnit) -> DerivedSplitSource {
        switch unit {
        case .kilometers: splitSource
        case .miles: mileSplitSource
        }
    }

    public func splitUnavailableReason(for unit: RunningDistanceUnit) -> String? {
        switch unit {
        case .kilometers: splitUnavailableReason
        case .miles: mileSplitUnavailableReason
        }
    }
}

public struct WorkoutEventSummary: Equatable, Sendable {
    public var totalCount: Int
    public var segmentCount: Int
    public var lapCount: Int
    public var pauseCount: Int
    public var resumeCount: Int
    public var labeledIntervalCount: Int

    public init(events: [WorkoutEvidenceEvent]) {
        totalCount = events.count
        segmentCount = events.filter { $0.displayLabel == "Segment" }.count
        lapCount = events.filter { $0.displayLabel == "Lap" }.count
        pauseCount = events.filter { $0.displayLabel.contains("Pause") || $0.displayLabel == "Motion paused" }.count
        resumeCount = events.filter { $0.displayLabel == "Resume" || $0.displayLabel == "Motion resumed" }.count
        labeledIntervalCount = events.filter { event in
            guard let label = event.label?.lowercased() else { return false }
            return ["warmup", "work", "recovery", "cooldown", "open"].contains { label.contains($0) }
        }.count
    }

    public var hasEvents: Bool {
        totalCount > 0
    }

    public var healthKitSummary: String {
        guard hasEvents else {
            return "HealthKit did not return workout events for this run."
        }

        var parts: [String] = []
        if segmentCount > 0 { parts.append("\(segmentCount) segment markers") }
        if lapCount > 0 { parts.append("\(lapCount) laps") }
        if pauseCount > 0 { parts.append("\(pauseCount) pause markers") }
        if resumeCount > 0 { parts.append("\(resumeCount) resume markers") }
        let knownCount = segmentCount + lapCount + pauseCount + resumeCount
        if totalCount > knownCount { parts.append("\(totalCount - knownCount) other events") }
        return parts.isEmpty ? "\(totalCount) workout events" : parts.joined(separator: ", ")
    }
}

public enum V1WorkoutFilters {
    public static func completedRuns(from workouts: [CanonicalWorkout]) -> [CanonicalWorkout] {
        workouts
            .filter { !$0.isDuplicate }
            .filter { $0.durationSeconds > 0 }
            .sorted { lhs, rhs in
                if lhs.startDate == rhs.startDate {
                    return preferredSourceScore(lhs) > preferredSourceScore(rhs)
                }
                return lhs.startDate > rhs.startDate
            }
    }

    public static func recentOutdoorAppleWatchRuns(from workouts: [CanonicalWorkout], limit: Int = 12) -> [CanonicalWorkout] {
        completedRuns(from: workouts)
            .filter { $0.environment == .outdoor }
            .sorted { lhs, rhs in
                let lhsScore = preferredSourceScore(lhs)
                let rhsScore = preferredSourceScore(rhs)
                if lhsScore != rhsScore {
                    return lhsScore > rhsScore
                }
                return lhs.startDate > rhs.startDate
            }
            .prefix(limit)
            .map { $0 }
    }

    private static func preferredSourceScore(_ workout: CanonicalWorkout) -> Int {
        let haystack = [workout.sourceName, workout.deviceName, workout.sourceID]
            .compactMap { $0?.lowercased() }
            .joined(separator: " ")
        var score = 0
        if haystack.contains("apple watch") { score += 5 }
        if haystack.contains("watch") { score += 3 }
        if haystack.contains("fitness") { score += 2 }
        if haystack.contains("health") { score += 1 }
        return score
    }
}
