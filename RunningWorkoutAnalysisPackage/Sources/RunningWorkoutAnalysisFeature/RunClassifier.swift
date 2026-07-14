import Foundation

public struct RunTypeSuggestion: Equatable, Sendable {
    public var runType: RunType
    public var confidence: ConfidenceLevel
    public var reasons: [String]

    public init(runType: RunType, confidence: ConfidenceLevel, reasons: [String]) {
        self.runType = runType.visibleCategory
        self.confidence = confidence
        self.reasons = reasons
    }

    public var detail: String {
        reasons.joined(separator: " · ")
    }
}

public enum RunClassifier {
    public static func inferRunType(for workout: CanonicalWorkout) -> RunType {
        suggestion(for: workout, history: [], maxHeartRate: nil).runType
    }

    public static func inferRunType(
        for workout: CanonicalWorkout,
        officialIntervalRows: [ReconstructedWorkoutInterval]
    ) -> RunType {
        if isStructuredIntervalWorkout(officialIntervalRows) {
            return .interval
        }
        return .unknown
    }

    public static func isStructuredIntervalWorkout(_ rows: [ReconstructedWorkoutInterval]) -> Bool {
        let officialRows = rows.filter { $0.planSource == .workoutKit }
        let workCount = officialRows.filter { $0.stepType == .work }.count
        let hasRecovery = officialRows.contains { $0.stepType == .recovery }
        return workCount >= 2 || (workCount == 1 && hasRecovery)
    }

    public static func suggestion(
        for workout: CanonicalWorkout,
        history: [CanonicalWorkout],
        maxHeartRate: Double?
    ) -> RunTypeSuggestion {
        let rows = officialIntervalRows(for: workout)
        let plan = workout.evidence?.workoutPlanAudit
        let title = (plan?.displayName ?? workout.workoutPlanName)?.lowercased() ?? ""
        let steps = plan?.plannedSteps ?? []
        let targetText = steps.compactMap(\.plannedTargetDisplayText).joined(separator: " ").lowercased()

        if containsAny(title, ["race", "5k", "10k", "half marathon", "marathon"]) && title.contains("race") {
            return RunTypeSuggestion(runType: .race, confidence: .strong, reasons: ["Workout plan explicitly identifies a race"])
        }
        if containsAny(title, ["long run", "longrun", "long "]) {
            return RunTypeSuggestion(runType: .longRun, confidence: .strong, reasons: ["Workout plan identifies a long run"])
        }
        if containsAny(title, ["threshold", "tempo"]) {
            return RunTypeSuggestion(runType: .threshold, confidence: .strong, reasons: ["Workout plan identifies threshold work"])
        }
        if containsAny(title, ["interval", "repeats", "speed workout", "track workout"])
            || isStructuredIntervalWorkout(rows)
            || isStructuredIntervalPlan(steps) {
            return RunTypeSuggestion(runType: .interval, confidence: title.isEmpty ? .moderate : .strong, reasons: ["Workout plan contains repeated Work and Recovery structure"])
        }

        if containsAny(title, ["easy", "recovery"]) {
            var reasons = ["Workout plan identifies an easy run"]
            if containsEasyZone(targetText) {
                reasons.append("Planned target is Heart Rate Zone 1–2")
            }
            return RunTypeSuggestion(runType: .easy, confidence: .strong, reasons: reasons)
        }

        let baseline = classificationBaseline(for: workout, history: history)
        if isLongRelativeToBaseline(workout, baseline: baseline) {
            return RunTypeSuggestion(
                runType: .longRun,
                confidence: .moderate,
                reasons: ["Duration or distance is substantially longer than the recent personal baseline"]
            )
        }

        if containsEasyZone(targetText) {
            return RunTypeSuggestion(runType: .easy, confidence: .moderate, reasons: ["Planned target is Heart Rate Zone 1–2"])
        }
        if isSustainedThresholdPlan(steps: steps, targetText: targetText) {
            return RunTypeSuggestion(runType: .threshold, confidence: .moderate, reasons: ["One sustained Work block targets a threshold-like heart-rate zone"])
        }
        if let maxHeartRate,
           maxHeartRate > 0,
           let averageHeartRate = workout.averageHeartRate,
           averageHeartRate / maxHeartRate <= 0.78,
           workout.durationSeconds >= 20 * 60 {
            return RunTypeSuggestion(runType: .easy, confidence: .moderate, reasons: ["Average heart rate is within an easy-intensity range for the available personal context"])
        }

        return RunTypeSuggestion(
            runType: .unknown,
            confidence: .limited,
            reasons: ["No explicit plan purpose or strong personal-baseline signal was available"]
        )
    }

    private static func officialIntervalRows(for workout: CanonicalWorkout) -> [ReconstructedWorkoutInterval] {
        guard let evidence = workout.evidence,
              let result = CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence)
        else {
            return []
        }
        return result.intervals
    }

    private static func containsAny(_ text: String, _ candidates: [String]) -> Bool {
        candidates.contains { text.contains($0) }
    }

    private static func isStructuredIntervalPlan(_ steps: [PlannedWorkoutStep]) -> Bool {
        let workCount = steps.filter { $0.stepType == .work }.count
        return workCount >= 2 || (workCount == 1 && steps.contains { $0.stepType == .recovery })
    }

    private static func containsEasyZone(_ text: String) -> Bool {
        containsAny(text, ["zone 1", "zone 2", "zone one", "zone two"])
    }

    private static func isSustainedThresholdPlan(steps: [PlannedWorkoutStep], targetText: String) -> Bool {
        guard steps.filter({ $0.stepType == .work }).count == 1,
              !steps.contains(where: { $0.stepType == .recovery }) else { return false }
        return containsAny(targetText, ["threshold", "zone 3", "zone 4", "zone three", "zone four"])
    }

    private static func classificationBaseline(
        for workout: CanonicalWorkout,
        history: [CanonicalWorkout]
    ) -> (duration: Double?, distance: Double?) {
        let cutoff = workout.startDate.addingTimeInterval(-42 * 86_400)
        let candidates = history.filter {
            $0.id != workout.id
                && !$0.isDuplicate
                && $0.startDate >= cutoff
                && $0.startDate < workout.startDate
                && $0.durationSeconds >= 15 * 60
        }
        return (
            median(candidates.map(\.durationSeconds)),
            median(candidates.compactMap(\.distanceMeters))
        )
    }

    private static func isLongRelativeToBaseline(
        _ workout: CanonicalWorkout,
        baseline: (duration: Double?, distance: Double?)
    ) -> Bool {
        let durationThreshold = max(60 * 60, (baseline.duration ?? 45 * 60) * 1.4)
        let distanceThreshold = max(10_000, (baseline.distance ?? 7_000) * 1.4)
        return workout.durationSeconds >= durationThreshold
            || (workout.distanceMeters ?? 0) >= distanceThreshold
    }

    private static func median(_ values: [Double]) -> Double? {
        let sorted = values.filter { $0.isFinite && $0 > 0 }.sorted()
        guard !sorted.isEmpty else { return nil }
        let middle = sorted.count / 2
        if sorted.count.isMultiple(of: 2) {
            return (sorted[middle - 1] + sorted[middle]) / 2
        }
        return sorted[middle]
    }
}

public enum DuplicateDetector {
    public static func markDuplicates(_ workouts: [CanonicalWorkout]) -> [CanonicalWorkout] {
        let sorted = workouts.sorted { $0.startDate < $1.startDate }
        var activeGroups: [[CanonicalWorkout]] = []
        var completedGroups: [[CanonicalWorkout]] = []

        for candidate in sorted {
            var stillActive: [[CanonicalWorkout]] = []
            stillActive.reserveCapacity(activeGroups.count)
            for group in activeGroups {
                guard let latestStart = group.last?.startDate,
                      candidate.startDate.timeIntervalSince(latestStart) <= 90 else {
                    completedGroups.append(group)
                    continue
                }
                stillActive.append(group)
            }
            activeGroups = stillActive

            if let index = activeGroups.firstIndex(where: { group in
                group.contains { isLikelyDuplicate($0, candidate) }
            }) {
                activeGroups[index].append(candidate)
            } else {
                activeGroups.append([candidate])
            }
        }

        completedGroups.append(contentsOf: activeGroups)
        return completedGroups
            .flatMap(markDuplicateGroup)
            .sorted { $0.startDate > $1.startDate }
    }

    public static func isLikelyDuplicate(_ first: CanonicalWorkout, _ second: CanonicalWorkout) -> Bool {
        let startDelta = abs(first.startDate.timeIntervalSince(second.startDate))
        guard startDelta <= 90 else { return false }

        let durationDelta = abs(first.durationSeconds - second.durationSeconds)
        let durationClose = durationDelta <= max(60, min(first.durationSeconds, second.durationSeconds) * 0.05)

        let distanceClose: Bool
        if let firstDistance = first.distanceMeters, let secondDistance = second.distanceMeters {
            distanceClose = abs(firstDistance - secondDistance) <= max(80, min(firstDistance, secondDistance) * 0.03)
        } else {
            distanceClose = true
        }

        return durationClose && distanceClose
    }

    private static func markDuplicateGroup(_ group: [CanonicalWorkout]) -> [CanonicalWorkout] {
        guard group.count > 1 else {
            return group.map { workout in
                var included = workout
                included.isDuplicate = false
                included.duplicateOfID = nil
                return included
            }
        }

        let preferred = group.max { lhs, rhs in
            preferredScore(lhs) < preferredScore(rhs)
        }
        let preferredID = preferred?.id

        return group.map { workout in
            var marked = workout
            marked.isDuplicate = workout.id != preferredID
            marked.duplicateOfID = marked.isDuplicate ? preferredID : nil
            return marked
        }
    }

    private static func preferredScore(_ workout: CanonicalWorkout) -> Int {
        let sourceText = "\(workout.sourceName) \(workout.deviceName ?? "")".lowercased()
        let appleWatchScore = sourceText.contains("apple watch") || sourceText.contains("apple fitness") ? 10_000 : 0
        let evidenceScore = workout.seriesSampleCount
            + workout.routePointCount
            + workout.heartRateSampleCount
            + workout.runningSpeedSampleCount
            + workout.distanceSampleCount
            + workout.runningPowerSampleCount
            + workout.cadenceSampleCount
            + workout.stepCountSampleCount
        let summaryScore = (workout.distanceMeters == nil ? 0 : 100)
            + (workout.activeEnergyKilocalories == nil ? 0 : 25)
            + (workout.averageHeartRate == nil ? 0 : 25)
        return appleWatchScore + evidenceScore + summaryScore
    }
}
