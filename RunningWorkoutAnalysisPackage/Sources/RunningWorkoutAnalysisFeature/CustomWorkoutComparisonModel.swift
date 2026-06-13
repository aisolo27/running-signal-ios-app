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
        plan: CustomWorkoutStepModel?,
        currentRows: [DebugCustomWorkoutCurrentRow] = [],
        activityRows: [DebugCustomWorkoutActivityCandidateRow] = [],
        hasRowLevelEvidence: Bool = true,
        rowLevelSupport: Bool = false,
        rowsAreDebugEquivalent: Bool = false,
        activityRowsAreContiguous: Bool = true,
        labelsAreAmbiguous: Bool = false,
        tailAmbiguity: CustomWorkoutTailAmbiguity = .none
    ) -> DebugCustomWorkoutComparison {
        let plannedRows = plan?.expandedSteps ?? []
        let fallbackReasons = fallbackReasons(
            plan: plan,
            plannedRows: plannedRows,
            activityRows: activityRows,
            hasRowLevelEvidence: hasRowLevelEvidence,
            activityRowsAreContiguous: activityRowsAreContiguous,
            labelsAreAmbiguous: labelsAreAmbiguous,
            tailAmbiguity: tailAmbiguity
        )
        let status = status(
            plan: plan,
            plannedRows: plannedRows,
            activityRows: activityRows,
            fallbackReasons: fallbackReasons,
            rowLevelSupport: rowLevelSupport,
            rowsAreDebugEquivalent: rowsAreDebugEquivalent,
            tailAmbiguity: tailAmbiguity
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
        tailAmbiguity: CustomWorkoutTailAmbiguity
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
        if tailAmbiguity.needsOpenTailRule {
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
        tailAmbiguity: CustomWorkoutTailAmbiguity
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
        if tailAmbiguity.needsOpenTailRule {
            return .openTailNeedsRule
        }
        if rowLevelSupport {
            return .supported
        }
        if plan?.blocks.contains(where: { $0.iterationCount > 1 }) == true {
            return .repeatBlockNeedsRule
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

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
