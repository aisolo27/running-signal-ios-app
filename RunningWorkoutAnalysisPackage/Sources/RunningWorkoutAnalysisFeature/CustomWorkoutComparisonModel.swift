import Foundation

enum CustomWorkoutComparisonStatus: String, Codable, Equatable, Sendable {
    case supported
    case equivalent
    case inconclusive
    case repeatBlockNeedsRule = "repeat-block-needs-rule"
    case openTailNeedsRule = "open-tail-needs-rule"
    case labelMappingNeedsRule = "label-mapping-needs-rule"
    case missingRequiredEvidence = "missing-required-evidence"
}

enum CustomWorkoutFallbackReason: String, Codable, Equatable, Sendable {
    case missingPlannedSteps
    case missingActivityRows
    case invalidRepeatCount
    case activityCountMismatch
    case nonContiguousActivityRows
    case missingEndBoundary
    case labelMappingAmbiguous
    case openExtraTailAmbiguous
    case noRowLevelEvidence
}

enum CustomWorkoutTailAmbiguity: String, Codable, Equatable, Sendable {
    case none
    case plannedOpenCooldownContinuesToWorkoutEnd
    case fixedCooldownFollowedByPossibleOpenExtraTail
    case postPlanActivityCandidate
    case ambiguous
}

enum CustomWorkoutRowConfidence: String, Codable, Equatable, Sendable {
    case supported
    case equivalent
    case inconclusive
    case needsRule
    case missingEvidence
}

struct DebugCustomWorkoutCurrentRow: Codable, Equatable, Sendable {
    var index: Int
    var role: CustomWorkoutStepRole
    var startOffsetSeconds: Double?
    var endOffsetSeconds: Double?

    init(index: Int, role: CustomWorkoutStepRole, startOffsetSeconds: Double? = nil, endOffsetSeconds: Double? = nil) {
        self.index = index
        self.role = role
        self.startOffsetSeconds = startOffsetSeconds
        self.endOffsetSeconds = endOffsetSeconds
    }
}

struct DebugCustomWorkoutActivityCandidateRow: Codable, Equatable, Sendable {
    var index: Int
    var role: CustomWorkoutStepRole
    var startOffsetSeconds: Double?
    var endOffsetSeconds: Double?

    init(index: Int, role: CustomWorkoutStepRole, startOffsetSeconds: Double? = nil, endOffsetSeconds: Double? = nil) {
        self.index = index
        self.role = role
        self.startOffsetSeconds = startOffsetSeconds
        self.endOffsetSeconds = endOffsetSeconds
    }
}

struct DebugCustomWorkoutComparisonRow: Codable, Equatable, Sendable {
    var index: Int
    var plannedRow: ExpandedCustomWorkoutPlanStep?
    var currentRunSignalRow: DebugCustomWorkoutCurrentRow?
    var activityCandidateRow: DebugCustomWorkoutActivityCandidateRow?
    var confidence: CustomWorkoutRowConfidence
    var fallbackReason: CustomWorkoutFallbackReason?
}

struct DebugCustomWorkoutComparison: Codable, Equatable, Sendable {
    var status: CustomWorkoutComparisonStatus
    var rows: [DebugCustomWorkoutComparisonRow]
    var fallbackReasons: [CustomWorkoutFallbackReason]
    var tailAmbiguity: CustomWorkoutTailAmbiguity
    var promotesProductionBehavior: Bool

    init(
        status: CustomWorkoutComparisonStatus,
        rows: [DebugCustomWorkoutComparisonRow],
        fallbackReasons: [CustomWorkoutFallbackReason] = [],
        tailAmbiguity: CustomWorkoutTailAmbiguity = .none,
        promotesProductionBehavior: Bool = false
    ) {
        self.status = status
        self.rows = rows
        self.fallbackReasons = fallbackReasons
        self.tailAmbiguity = tailAmbiguity
        self.promotesProductionBehavior = promotesProductionBehavior
    }
}

enum DebugCustomWorkoutComparisonBuilder {
    static func comparison(
        plannedSteps: [PlannedWorkoutStep],
        activities: [WorkoutEvidenceActivity],
        workout: CanonicalWorkout,
        hasRowLevelEvidence: Bool = true,
        repeatBlockRuleApproved: Bool = false,
        openTailRuleApproved: Bool = false,
        simpleWorkOpenRuleApproved: Bool = false,
        pausedRepeatBlockRuleApproved: Bool = false,
        pairedPauseCount: Int = 0
    ) -> DebugCustomWorkoutComparison {
        let sortedSteps = plannedSteps.sorted { $0.index < $1.index }
        let sortedActivities = activities.sorted { $0.startDate < $1.startDate }
        let plan = CustomWorkoutStepModel(plannedSteps: sortedSteps)
        let activityRows = sortedActivities.enumerated().map { offset, activity in
            DebugCustomWorkoutActivityCandidateRow(
                index: offset + 1,
                role: sortedSteps[safe: offset]?.stepType.customWorkoutStepRole ?? .unknown,
                startOffsetSeconds: activity.startDate.timeIntervalSince(workout.startDate),
                endOffsetSeconds: activity.endDate?.timeIntervalSince(workout.startDate)
            )
        }
        let tailAmbiguity = tailAmbiguity(plannedSteps: sortedSteps, activities: sortedActivities, workout: workout)
        let hasCoreRowEvidence = !sortedSteps.isEmpty
            && sortedSteps.count == sortedActivities.count
            && !sortedActivities.isEmpty
            && activityRows.allSatisfy { $0.endOffsetSeconds != nil }
            && sortedActivities.allSatisfy { activityDistanceMeters($0) != nil }
            && activityRowsAreContiguous(sortedActivities)
        let hasRepeatBlock = sortedSteps.contains { ($0.repeatIndex ?? 1) > 1 }
        let pausedRepeatBlockRuleIsScoreable = pausedRepeatBlockRuleApproved
            && hasRepeatBlock
            && pairedPauseCount > 0
        let repeatBlockIsScoreable = !hasRepeatBlock
            || repeatBlockRuleApproved
            || pausedRepeatBlockRuleIsScoreable
        let simpleWorkOpenRuleIsScoreable = simpleWorkOpenRuleApproved
            && isSimpleWorkOpenPrototypeCandidate(
                plannedSteps: sortedSteps,
                activities: sortedActivities,
                workout: workout
            )
        let openTailIsScoreable = !tailAmbiguity.needsOpenTailRule
            || openTailRuleApproved
            || simpleWorkOpenRuleIsScoreable
        let rowsAreScoreable = hasCoreRowEvidence
            && openTailIsScoreable
            && repeatBlockIsScoreable

        return comparison(
            plan: plan,
            activityRows: activityRows,
            hasRowLevelEvidence: hasRowLevelEvidence && hasCoreRowEvidence,
            rowLevelSupport: rowsAreScoreable,
            rowsAreDebugEquivalent: rowsAreScoreable,
            activityRowsAreContiguous: activityRowsAreContiguous(sortedActivities),
            labelsAreAmbiguous: sortedSteps.contains { $0.stepType == .unknown },
            tailAmbiguity: tailAmbiguity,
            repeatBlockRuleApproved: repeatBlockRuleApproved,
            openTailRuleApproved: openTailRuleApproved,
            simpleWorkOpenRuleApproved: simpleWorkOpenRuleIsScoreable,
            pausedRepeatBlockRuleApproved: pausedRepeatBlockRuleIsScoreable,
            repeatBlockNeedsRule: hasRepeatBlock
        )
    }

    static func comparison(
        plan: CustomWorkoutStepModel?,
        currentRows: [DebugCustomWorkoutCurrentRow] = [],
        activityRows: [DebugCustomWorkoutActivityCandidateRow] = [],
        hasRowLevelEvidence: Bool = true,
        rowLevelSupport: Bool = false,
        rowsAreDebugEquivalent: Bool = false,
        activityRowsAreContiguous: Bool = true,
        labelsAreAmbiguous: Bool = false,
        tailAmbiguity: CustomWorkoutTailAmbiguity = .none,
        repeatBlockRuleApproved: Bool = false,
        openTailRuleApproved: Bool = false,
        simpleWorkOpenRuleApproved: Bool = false,
        pausedRepeatBlockRuleApproved: Bool = false,
        repeatBlockNeedsRule: Bool? = nil
    ) -> DebugCustomWorkoutComparison {
        let plannedRows = plan?.expandedSteps ?? []
        let fallbackReasons = fallbackReasons(
            plan: plan,
            plannedRows: plannedRows,
            activityRows: activityRows,
            hasRowLevelEvidence: hasRowLevelEvidence,
            activityRowsAreContiguous: activityRowsAreContiguous,
            labelsAreAmbiguous: labelsAreAmbiguous,
            tailAmbiguity: tailAmbiguity,
            openTailRuleApproved: openTailRuleApproved,
            simpleWorkOpenRuleApproved: simpleWorkOpenRuleApproved
        )
        let status = status(
            plan: plan,
            plannedRows: plannedRows,
            activityRows: activityRows,
            fallbackReasons: fallbackReasons,
            rowLevelSupport: rowLevelSupport,
            rowsAreDebugEquivalent: rowsAreDebugEquivalent,
            tailAmbiguity: tailAmbiguity,
            repeatBlockRuleApproved: repeatBlockRuleApproved,
            openTailRuleApproved: openTailRuleApproved,
            simpleWorkOpenRuleApproved: simpleWorkOpenRuleApproved,
            pausedRepeatBlockRuleApproved: pausedRepeatBlockRuleApproved,
            repeatBlockNeedsRule: repeatBlockNeedsRule ?? (plan?.blocks.contains(where: { $0.iterationCount > 1 }) == true)
        )

        return DebugCustomWorkoutComparison(
            status: status,
            rows: comparisonRows(
                plannedRows: plannedRows,
                currentRows: currentRows,
                activityRows: activityRows,
                status: status,
                primaryFallbackReason: fallbackReasons.first
            ),
            fallbackReasons: fallbackReasons,
            tailAmbiguity: tailAmbiguity
        )
    }

    private static func fallbackReasons(
        plan: CustomWorkoutStepModel?,
        plannedRows: [ExpandedCustomWorkoutPlanStep],
        activityRows: [DebugCustomWorkoutActivityCandidateRow],
        hasRowLevelEvidence: Bool,
        activityRowsAreContiguous: Bool,
        labelsAreAmbiguous: Bool,
        tailAmbiguity: CustomWorkoutTailAmbiguity,
        openTailRuleApproved: Bool,
        simpleWorkOpenRuleApproved: Bool
    ) -> [CustomWorkoutFallbackReason] {
        var reasons: [CustomWorkoutFallbackReason] = []

        if plan == nil || plannedRows.isEmpty {
            reasons.append(.missingPlannedSteps)
        }
        if plan?.blocks.contains(where: { $0.iterationCount < 1 }) == true {
            reasons.append(.invalidRepeatCount)
        }
        if activityRows.isEmpty {
            reasons.append(.missingActivityRows)
        }
        if !hasRowLevelEvidence {
            reasons.append(.noRowLevelEvidence)
        }
        if !activityRowsAreContiguous {
            reasons.append(.nonContiguousActivityRows)
        }
        if activityRows.contains(where: { $0.endOffsetSeconds == nil }) {
            reasons.append(.missingEndBoundary)
        }
        if labelsAreAmbiguous {
            reasons.append(.labelMappingAmbiguous)
        }
        if tailAmbiguity.needsOpenTailRule && !openTailRuleApproved && !simpleWorkOpenRuleApproved {
            reasons.append(.openExtraTailAmbiguous)
        }
        if !plannedRows.isEmpty,
           !activityRows.isEmpty,
           plannedRows.count != activityRows.count {
            reasons.append(.activityCountMismatch)
        }

        return unique(reasons)
    }

    private static func status(
        plan: CustomWorkoutStepModel?,
        plannedRows: [ExpandedCustomWorkoutPlanStep],
        activityRows: [DebugCustomWorkoutActivityCandidateRow],
        fallbackReasons: [CustomWorkoutFallbackReason],
        rowLevelSupport: Bool,
        rowsAreDebugEquivalent: Bool,
        tailAmbiguity: CustomWorkoutTailAmbiguity,
        repeatBlockRuleApproved: Bool,
        openTailRuleApproved: Bool,
        simpleWorkOpenRuleApproved: Bool,
        pausedRepeatBlockRuleApproved: Bool,
        repeatBlockNeedsRule: Bool
    ) -> CustomWorkoutComparisonStatus {
        if fallbackReasons.contains(.missingPlannedSteps)
            || fallbackReasons.contains(.missingActivityRows)
            || fallbackReasons.contains(.noRowLevelEvidence) {
            return .missingRequiredEvidence
        }
        if fallbackReasons.contains(.invalidRepeatCount)
            || fallbackReasons.contains(.nonContiguousActivityRows)
            || fallbackReasons.contains(.missingEndBoundary) {
            return .inconclusive
        }
        if fallbackReasons.contains(.labelMappingAmbiguous) {
            return .labelMappingNeedsRule
        }
        if tailAmbiguity.needsOpenTailRule && !openTailRuleApproved && !simpleWorkOpenRuleApproved {
            return .openTailNeedsRule
        }
        if repeatBlockNeedsRule {
            if !repeatBlockRuleApproved && !pausedRepeatBlockRuleApproved {
                return .repeatBlockNeedsRule
            }
        }
        if rowLevelSupport {
            return .supported
        }
        if rowsAreDebugEquivalent {
            return .equivalent
        }
        if fallbackReasons.contains(.nonContiguousActivityRows)
            || fallbackReasons.contains(.missingEndBoundary)
            || fallbackReasons.contains(.activityCountMismatch) {
            return .inconclusive
        }
        _ = plannedRows
        _ = activityRows
        return .inconclusive
    }

    private static func comparisonRows(
        plannedRows: [ExpandedCustomWorkoutPlanStep],
        currentRows: [DebugCustomWorkoutCurrentRow],
        activityRows: [DebugCustomWorkoutActivityCandidateRow],
        status: CustomWorkoutComparisonStatus,
        primaryFallbackReason: CustomWorkoutFallbackReason?
    ) -> [DebugCustomWorkoutComparisonRow] {
        let rowCount = max(plannedRows.count, currentRows.count, activityRows.count)
        guard rowCount > 0 else { return [] }

        return (0..<rowCount).map { offset in
            DebugCustomWorkoutComparisonRow(
                index: offset + 1,
                plannedRow: plannedRows[safe: offset],
                currentRunSignalRow: currentRows[safe: offset],
                activityCandidateRow: activityRows[safe: offset],
                confidence: rowConfidence(for: status),
                fallbackReason: primaryFallbackReason
            )
        }
    }

    private static func rowConfidence(for status: CustomWorkoutComparisonStatus) -> CustomWorkoutRowConfidence {
        switch status {
        case .supported:
            .supported
        case .equivalent:
            .equivalent
        case .inconclusive:
            .inconclusive
        case .repeatBlockNeedsRule, .openTailNeedsRule, .labelMappingNeedsRule:
            .needsRule
        case .missingRequiredEvidence:
            .missingEvidence
        }
    }

    private static func unique(_ reasons: [CustomWorkoutFallbackReason]) -> [CustomWorkoutFallbackReason] {
        var seen: Set<CustomWorkoutFallbackReason> = []
        return reasons.filter { seen.insert($0).inserted }
    }

    private static func tailAmbiguity(
        plannedSteps: [PlannedWorkoutStep],
        activities: [WorkoutEvidenceActivity],
        workout: CanonicalWorkout
    ) -> CustomWorkoutTailAmbiguity {
        guard !plannedSteps.isEmpty, let lastStep = plannedSteps.last else { return .none }
        if lastStep.plannedGoalType == .open, lastStep.stepType == .cooldown {
            return .plannedOpenCooldownContinuesToWorkoutEnd
        }
        guard let lastActivityEnd = activities.last?.endDate else { return .none }
        let mappedDistance = activities.compactMap(activityDistanceMeters).reduce(0, +)
        let remainingSeconds = workout.endDate.timeIntervalSince(lastActivityEnd)
        let remainingMeters = workout.distanceMeters.map { max(0, $0 - mappedDistance) } ?? 0
        if remainingSeconds > 0.5 || remainingMeters > 0.5 {
            return .fixedCooldownFollowedByPossibleOpenExtraTail
        }
        return .none
    }

    private static func isSimpleWorkOpenPrototypeCandidate(
        plannedSteps: [PlannedWorkoutStep],
        activities: [WorkoutEvidenceActivity],
        workout: CanonicalWorkout
    ) -> Bool {
        guard plannedSteps.count == 1,
              let step = plannedSteps.first,
              step.stepType == .work,
              step.plannedGoalType == .distance,
              (step.plannedGoalValue ?? 0) > 0,
              (step.repeatIndex ?? 1) == 1,
              activities.count == 1,
              let activity = activities.first,
              let activityEnd = activity.endDate,
              activityEnd > activity.startDate,
              activityDistanceMeters(activity) != nil else {
            return false
        }

        let mappedDistance = activities.compactMap(activityDistanceMeters).reduce(0, +)
        let remainingSeconds = workout.endDate.timeIntervalSince(activityEnd)
        let remainingMeters = workout.distanceMeters.map { max(0, $0 - mappedDistance) } ?? 0
        return remainingSeconds > 0.5 || remainingMeters > 0.5
    }

    private static func activityRowsAreContiguous(_ activities: [WorkoutEvidenceActivity]) -> Bool {
        guard activities.count > 1 else { return true }
        for index in activities.indices.dropFirst() {
            guard let previousEnd = activities[index - 1].endDate else { return false }
            if abs(activities[index].startDate.timeIntervalSince(previousEnd)) > 1 {
                return false
            }
        }
        return true
    }

    private static func activityDistanceMeters(_ activity: WorkoutEvidenceActivity) -> Double? {
        activity.statistics.first {
            $0.quantityType == "HKQuantityTypeIdentifierDistanceWalkingRunning"
        }?.sum
    }
}

private extension CustomWorkoutTailAmbiguity {
    var needsOpenTailRule: Bool {
        switch self {
        case .none, .plannedOpenCooldownContinuesToWorkoutEnd:
            false
        case .fixedCooldownFollowedByPossibleOpenExtraTail, .postPlanActivityCandidate, .ambiguous:
            true
        }
    }
}

private extension CustomWorkoutStepModel {
    init(plannedSteps: [PlannedWorkoutStep]) {
        self.init(
            blocks: [
                CustomWorkoutRepeatBlock(
                    blockIndex: 1,
                    iterationCount: 1,
                    steps: plannedSteps.map(CustomWorkoutPlanStep.init(step:))
                )
            ]
        )
    }
}

private extension CustomWorkoutPlanStep {
    init(step: PlannedWorkoutStep) {
        self.init(
            originalStepIndex: step.index,
            role: step.stepType.customWorkoutStepRole,
            goalType: step.plannedGoalType,
            goalValue: step.plannedGoalValue
        )
    }
}

private extension DerivedIntervalLabel {
    var customWorkoutStepRole: CustomWorkoutStepRole {
        switch self {
        case .warmup:
            .warmup
        case .work:
            .work
        case .recovery:
            .recovery
        case .cooldown:
            .cooldown
        case .open:
            .open
        case .unknown:
            .unknown
        }
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
