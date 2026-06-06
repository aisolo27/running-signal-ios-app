import Foundation

public enum WebRunReviewCategory: String, Codable, CaseIterable, Sendable {
    case easyRun = "easy_run"
    case longRun = "long_run"
    case intervalRun = "interval_run"
    case thresholdRun = "threshold_run"
    case race
    case warmupCooldown = "warmup_cooldown"
    case other

    public var runType: RunType {
        switch self {
        case .easyRun: .easy
        case .longRun: .longRun
        case .intervalRun: .interval
        case .thresholdRun: .threshold
        case .race: .race
        case .warmupCooldown: .recovery
        case .other: .unknown
        }
    }

    public var label: String {
        switch self {
        case .easyRun: "Easy Run"
        case .longRun: "Long Run"
        case .intervalRun: "Interval Run"
        case .thresholdRun: "Threshold Run"
        case .race: "Race"
        case .warmupCooldown: "Warm-up/Cool-down"
        case .other: "Other"
        }
    }
}

public struct ReviewedRunTypeRecord: Identifiable, Codable, Equatable, Sendable {
    public var id: String
    public var sourceWorkoutID: String?
    public var localDate: String
    public var localStartTime: String?
    public var distanceMeters: Double?
    public var durationSeconds: Double?
    public var category: WebRunReviewCategory
    public var notes: String?

    public init(
        id: String,
        sourceWorkoutID: String? = nil,
        localDate: String,
        localStartTime: String? = nil,
        distanceMeters: Double? = nil,
        durationSeconds: Double? = nil,
        category: WebRunReviewCategory,
        notes: String? = nil
    ) {
        self.id = id
        self.sourceWorkoutID = sourceWorkoutID
        self.localDate = localDate
        self.localStartTime = localStartTime
        self.distanceMeters = distanceMeters
        self.durationSeconds = durationSeconds
        self.category = category
        self.notes = notes
    }
}

public enum RunTypeReconciliationStatus: String, Codable, Sendable {
    case matched
    case weak
    case conflict
    case webOnly
    case phoneOnly
}

public struct RunTypeReconciliationRow: Identifiable, Equatable, Sendable {
    public var id: String
    public var status: RunTypeReconciliationStatus
    public var review: ReviewedRunTypeRecord?
    public var workoutID: String?
    public var workoutDate: Date?
    public var matchedRunType: RunType?
    public var confidence: ConfidenceLevel
    public var reason: String
}

public struct RunTypeReconciliationSummary: Equatable, Sendable {
    public var importedCount: Int
    public var matchedCount: Int
    public var weakCount: Int
    public var conflictCount: Int
    public var webOnlyCount: Int
    public var phoneOnlyCount: Int
    public var rows: [RunTypeReconciliationRow]

    public static let empty = RunTypeReconciliationSummary(
        importedCount: 0,
        matchedCount: 0,
        weakCount: 0,
        conflictCount: 0,
        webOnlyCount: 0,
        phoneOnlyCount: 0,
        rows: []
    )
}

public enum RunTypeReviewBridge {
    public static func reconcile(
        reviews: [ReviewedRunTypeRecord],
        workouts: [CanonicalWorkout],
        calendar: Calendar = .current
    ) -> RunTypeReconciliationSummary {
        let includedWorkouts = workouts.filter { !$0.isDuplicate }
        var usedWorkoutIDs = Set<String>()
        var rows: [RunTypeReconciliationRow] = []

        for review in reviews {
            let candidates = candidateMatches(review: review, workouts: includedWorkouts, calendar: calendar)
                .filter { !usedWorkoutIDs.contains($0.workout.id) }
                .sorted { $0.score < $1.score }

            guard let best = candidates.first else {
                rows.append(
                    RunTypeReconciliationRow(
                        id: "web-\(review.id)",
                        status: .webOnly,
                        review: review,
                        workoutID: nil,
                        workoutDate: nil,
                        matchedRunType: review.category.runType,
                        confidence: .unavailable,
                        reason: "No same-date HealthKit workout matched this reviewed web run."
                    )
                )
                continue
            }

            let expectedRunType = review.category.runType
            let status: RunTypeReconciliationStatus
            let confidence: ConfidenceLevel
            let reason: String

            if let manual = best.workout.manualRunType, manual != expectedRunType {
                status = .conflict
                confidence = .limited
                reason = "HealthKit workout already has a different manual label."
            } else if best.isConfident {
                status = .matched
                confidence = .strong
                reason = "Matched by date, distance, duration, and available start-time evidence."
                usedWorkoutIDs.insert(best.workout.id)
            } else {
                status = .weak
                confidence = .limited
                reason = best.reason
            }

            rows.append(
                RunTypeReconciliationRow(
                    id: "review-\(review.id)-\(best.workout.id)",
                    status: status,
                    review: review,
                    workoutID: best.workout.id,
                    workoutDate: best.workout.startDate,
                    matchedRunType: expectedRunType,
                    confidence: confidence,
                    reason: reason
                )
            )
        }

        let reviewedWorkoutIDs = Set(rows.compactMap(\.workoutID))
        for workout in includedWorkouts where !reviewedWorkoutIDs.contains(workout.id) {
            rows.append(
                RunTypeReconciliationRow(
                    id: "phone-\(workout.id)",
                    status: .phoneOnly,
                    review: nil,
                    workoutID: workout.id,
                    workoutDate: workout.startDate,
                    matchedRunType: workout.effectiveRunType,
                    confidence: .limited,
                    reason: "HealthKit has no imported reviewed category for this workout."
                )
            )
        }

        return RunTypeReconciliationSummary(
            importedCount: reviews.count,
            matchedCount: rows.filter { $0.status == .matched }.count,
            weakCount: rows.filter { $0.status == .weak }.count,
            conflictCount: rows.filter { $0.status == .conflict }.count,
            webOnlyCount: rows.filter { $0.status == .webOnly }.count,
            phoneOnlyCount: rows.filter { $0.status == .phoneOnly }.count,
            rows: rows
        )
    }

    public static func applyConfidentMatches(
        reviews: [ReviewedRunTypeRecord],
        to workouts: [CanonicalWorkout],
        calendar: Calendar = .current
    ) -> [CanonicalWorkout] {
        let summary = reconcile(reviews: reviews, workouts: workouts, calendar: calendar)
        let matchedTypes = Dictionary(
            uniqueKeysWithValues: summary.rows.compactMap { row -> (String, RunType)? in
                guard row.status == .matched, let workoutID = row.workoutID, let runType = row.matchedRunType else {
                    return nil
                }
                return (workoutID, runType)
            }
        )

        return workouts.map { workout in
            guard workout.manualRunType == nil, let runType = matchedTypes[workout.id] else {
                return workout
            }
            var updated = workout
            updated.manualRunType = runType
            return updated
        }
    }

    private static func candidateMatches(
        review: ReviewedRunTypeRecord,
        workouts: [CanonicalWorkout],
        calendar: Calendar
    ) -> [CandidateMatch] {
        workouts.compactMap { workout in
            if let sourceWorkoutID = review.sourceWorkoutID,
               sourceWorkoutID == workout.id || sourceWorkoutID == workout.sourceID {
                return CandidateMatch(workout: workout, score: 0, isConfident: true, reason: "Matched by source workout id.")
            }

            guard sameLocalDay(review.localDate, workout.startDate, calendar: calendar) else { return nil }

            let distanceScore = toleranceScore(
                reviewValue: review.distanceMeters,
                workoutValue: workout.distanceMeters,
                absoluteTolerance: 200,
                relativeTolerance: 0.05
            )
            let durationScore = toleranceScore(
                reviewValue: review.durationSeconds,
                workoutValue: workout.durationSeconds,
                absoluteTolerance: 90,
                relativeTolerance: 0.05
            )
            let timeScore = startTimeScore(review: review, workout: workout, calendar: calendar)
            let score = distanceScore.score + durationScore.score + timeScore.score
            let requiredEvidence = [review.distanceMeters, review.durationSeconds].contains { $0 != nil }
            let isConfident = requiredEvidence && distanceScore.inTolerance && durationScore.inTolerance && timeScore.inTolerance
            let reason = [
                distanceScore.reason("distance"),
                durationScore.reason("duration"),
                timeScore.reason
            ]
                .compactMap { $0 }
                .joined(separator: " ")

            return CandidateMatch(
                workout: workout,
                score: score,
                isConfident: isConfident,
                reason: reason.isEmpty ? "Only the local date matched." : reason
            )
        }
    }

    private static func sameLocalDay(_ localDate: String, _ date: Date, calendar: Calendar) -> Bool {
        guard let reviewDate = parseLocalDate(localDate) else { return false }
        return calendar.isDate(reviewDate, inSameDayAs: date)
    }

    private static func parseLocalDate(_ value: String) -> Date? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: value)
    }

    private static func toleranceScore(
        reviewValue: Double?,
        workoutValue: Double?,
        absoluteTolerance: Double,
        relativeTolerance: Double
    ) -> ToleranceScore {
        guard let reviewValue, let workoutValue, reviewValue > 0, workoutValue > 0 else {
            return ToleranceScore(score: 25, inTolerance: true, reasonBuilder: { "\($0) missing from one side." })
        }
        let delta = abs(reviewValue - workoutValue)
        let tolerance = max(absoluteTolerance, max(reviewValue, workoutValue) * relativeTolerance)
        return ToleranceScore(
            score: delta / tolerance,
            inTolerance: delta <= tolerance,
            reasonBuilder: { label in
                delta <= tolerance ? nil : "\(label.capitalized) differs beyond tolerance."
            }
        )
    }

    private static func startTimeScore(
        review: ReviewedRunTypeRecord,
        workout: CanonicalWorkout,
        calendar: Calendar
    ) -> TimeScore {
        guard let localStartTime = review.localStartTime,
              let reviewDate = parseLocalDate(review.localDate),
              let reviewTime = parseTime(localStartTime, on: reviewDate, calendar: calendar)
        else {
            return TimeScore(score: 10, inTolerance: true, reason: nil)
        }

        let delta = abs(workout.startDate.timeIntervalSince(reviewTime))
        let tolerance: TimeInterval = 90 * 60
        return TimeScore(
            score: delta / tolerance,
            inTolerance: delta <= tolerance,
            reason: delta <= tolerance ? nil : "Start time differs beyond tolerance."
        )
    }

    private static func parseTime(_ value: String, on date: Date, calendar: Calendar) -> Date? {
        let parts = value.split(separator: ":").compactMap { Int($0) }
        guard parts.count >= 2 else { return nil }
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = parts[0]
        components.minute = parts[1]
        components.second = parts.count > 2 ? parts[2] : 0
        return calendar.date(from: components)
    }
}

private struct CandidateMatch {
    var workout: CanonicalWorkout
    var score: Double
    var isConfident: Bool
    var reason: String
}

private struct ToleranceScore {
    var score: Double
    var inTolerance: Bool
    var reasonBuilder: (String) -> String?

    func reason(_ label: String) -> String? {
        reasonBuilder(label)
    }
}

private struct TimeScore {
    var score: Double
    var inTolerance: Bool
    var reason: String?
}
