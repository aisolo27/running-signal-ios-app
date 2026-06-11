import Foundation

public enum PhysicalVerificationKind: String, CaseIterable, Sendable {
    case easyOutdoor
    case treadmill
    case intervalOrStructured
    case longRun
    case raceOrTimeTrial
    case olderHistorical

    var title: String {
        switch self {
        case .easyOutdoor: "Easy outdoor run"
        case .treadmill: "Treadmill run"
        case .intervalOrStructured: "Interval or structured workout"
        case .longRun: "Long run"
        case .raceOrTimeTrial: "Race or time trial"
        case .olderHistorical: "Older historical run"
        }
    }
}

public struct PhysicalVerificationRow: Identifiable, Equatable, Sendable {
    public var id: String { kind.rawValue }
    public var kind: PhysicalVerificationKind
    public var workout: CanonicalWorkout?
    public var decision: ConfidenceLevel
    public var notes: [String]

    public init(kind: PhysicalVerificationKind, workout: CanonicalWorkout?, decision: ConfidenceLevel, notes: [String]) {
        self.kind = kind
        self.workout = workout
        self.decision = decision
        self.notes = notes
    }
}

public enum PhysicalVerificationReport {
    public static func rows(for workouts: [CanonicalWorkout]) -> [PhysicalVerificationRow] {
        let included = workouts
            .filter { !$0.isDuplicate }
            .sorted { $0.startDate > $1.startDate }

        return PhysicalVerificationKind.allCases.map { kind in
            let workout = representativeWorkout(kind: kind, workouts: included)
            return PhysicalVerificationRow(
                kind: kind,
                workout: workout,
                decision: decision(for: workout),
                notes: notes(for: workout)
            )
        }
    }

    public static func markdown(workouts: [CanonicalWorkout], generatedAt: Date = Date()) -> String {
        let rows = rows(for: workouts)
        let rowText = rows.map(markdownRow).joined(separator: "\n")
        let pendingCount = rows.filter { $0.workout == nil }.count

        return """
        # Physical iPhone HealthKit Verification

        Generated: \(RunFormatters.date.string(from: generatedAt))

        This report selects representative non-duplicate workouts from the currently loaded iPhone HealthKit data. It is only valid as physical-device evidence after the app is run on the iPhone and HealthKit workouts have been loaded or synced there.

        ## Representative Runs

        | Required run | Candidate | Decision | Evidence notes |
        | --- | --- | --- | --- |
        \(rowText)

        ## Gate

        \(pendingCount == 0 ? "All representative slots have candidates. Review the field notes before marking Step 6 complete." : "\(pendingCount) representative slots are still missing candidates. Do not mark Step 6 complete.")
        """
    }

    private static func representativeWorkout(kind: PhysicalVerificationKind, workouts: [CanonicalWorkout]) -> CanonicalWorkout? {
        switch kind {
        case .easyOutdoor:
            workouts.first { $0.environment == .outdoor && [.easy, .recovery].contains($0.effectiveRunType) }
        case .treadmill:
            workouts.first { $0.environment == .indoor }
        case .intervalOrStructured:
            workouts.first { $0.intervalCount > 0 || [.interval, .threshold, .tempo].contains($0.effectiveRunType) }
        case .longRun:
            workouts.first { $0.effectiveRunType == .longRun || ($0.distanceMeters ?? 0) >= 10_000 || $0.durationSeconds >= 5_400 }
        case .raceOrTimeTrial:
            workouts.first { $0.effectiveRunType == .race || textSuggestsBenchmark($0.notes) }
        case .olderHistorical:
            workouts.last
        }
    }

    private static func decision(for workout: CanonicalWorkout?) -> ConfidenceLevel {
        guard let workout else { return .unavailable }
        let hasSeries = workout.heartRateSampleCount > 0 || workout.runningSpeedSampleCount > 0 || workout.distanceSampleCount > 0
        let hasSummary = workout.distanceMeters != nil && workout.durationSeconds > 0
        if hasSeries && (workout.routePointCount > 0 || workout.intervalCount > 0) {
            return .moderate
        }
        if hasSeries || hasSummary {
            return .limited
        }
        return .unavailable
    }

    private static func notes(for workout: CanonicalWorkout?) -> [String] {
        guard let workout else {
            return ["No representative non-duplicate workout is loaded for this archetype."]
        }

        var notes: [String] = [
            "Source \(workout.sourceName), \(RunFormatters.distance(workout.distanceMeters)), \(RunFormatters.duration(workout.durationSeconds)).",
            "Direct samples: HR \(workout.heartRateSampleCount), speed \(workout.runningSpeedSampleCount), distance \(workout.distanceSampleCount), active energy \(workout.activeEnergySampleCount).",
            "Route: \(workout.routePointCount > 0 ? "\(workout.routePointCount) points" : workout.routeAvailable ? "object without points" : "missing").",
            "Events/laps/segments: \(workout.intervalCount > 0 ? "\(workout.intervalCount)" : "missing").",
            "Mechanics samples: power \(workout.runningPowerSampleCount), cadence/steps \(workout.cadenceSampleCount + workout.stepCountSampleCount), stride \(workout.strideLengthSampleCount), vertical oscillation \(workout.verticalOscillationSampleCount), ground contact \(workout.groundContactTimeSampleCount)."
        ]

        if workout.runTypeTrust.kind == .suggested || workout.runTypeTrust.kind == .needsReview {
            notes.append("Run type is \(workout.runTypeTrust.kind.label.lowercased()); source/date overmatching risk still needs review.")
        }
        if workout.heartRateSampleCount == 0 || (workout.runningSpeedSampleCount == 0 && workout.distanceSampleCount == 0) {
            notes.append("Detailed analyzer confidence remains limited until associated HR and speed/distance samples are present.")
        }
        return notes
    }

    private static func markdownRow(_ row: PhysicalVerificationRow) -> String {
        let candidate: String
        if let workout = row.workout {
            candidate = "\(RunFormatters.date.string(from: workout.startDate)) \(workout.effectiveRunType.label)"
        } else {
            candidate = "Missing"
        }

        let notes = row.notes.joined(separator: " ")
        return "| \(row.kind.title) | \(candidate) | \(row.decision.label) | \(notes) |"
    }

    private static func textSuggestsBenchmark(_ text: String) -> Bool {
        let lowered = text.lowercased()
        return lowered.contains("race") || lowered.contains("time trial") || lowered.contains("benchmark")
    }
}
