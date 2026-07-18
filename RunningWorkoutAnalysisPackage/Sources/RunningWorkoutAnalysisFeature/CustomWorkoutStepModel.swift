import Foundation

enum CustomWorkoutStepRole: String, Codable, Equatable, Sendable {
    case warmup
    case work
    case recovery
    case cooldown
    case open
    case extra
    case unknown
}

enum CustomWorkoutStepSource: String, Codable, Equatable, Sendable {
    case workoutKit
    case healthKit
    case fitReferenceOnly
}

struct CustomWorkoutPlanStep: Codable, Equatable, Sendable {
    var originalStepIndex: Int
    var role: CustomWorkoutStepRole
    var goalType: PlannedWorkoutGoalType
    var goalValue: Double?
    var distancePrescription: PlannedDistancePrescription?
    var source: CustomWorkoutStepSource

    init(
        originalStepIndex: Int,
        role: CustomWorkoutStepRole,
        goalType: PlannedWorkoutGoalType,
        goalValue: Double? = nil,
        distancePrescription: PlannedDistancePrescription? = nil,
        source: CustomWorkoutStepSource = .workoutKit
    ) {
        self.originalStepIndex = originalStepIndex
        self.role = role
        self.goalType = goalType
        self.goalValue = goalValue
        self.distancePrescription = distancePrescription
        self.source = source
    }
}

struct CustomWorkoutRepeatBlock: Codable, Equatable, Sendable {
    var blockIndex: Int
    var iterationCount: Int
    var steps: [CustomWorkoutPlanStep]

    init(blockIndex: Int, iterationCount: Int, steps: [CustomWorkoutPlanStep]) {
        self.blockIndex = blockIndex
        self.iterationCount = iterationCount
        self.steps = steps
    }
}

struct ExpandedCustomWorkoutPlanStep: Codable, Equatable, Sendable {
    var originalStepIndex: Int
    var expandedStepIndex: Int
    var blockIndex: Int?
    var repeatIteration: Int?
    var role: CustomWorkoutStepRole
    var goalType: PlannedWorkoutGoalType
    var goalValue: Double?
    var distancePrescription: PlannedDistancePrescription?
    var source: CustomWorkoutStepSource
}

struct CustomWorkoutStepModel: Codable, Equatable, Sendable {
    var warmupStep: CustomWorkoutPlanStep?
    var blocks: [CustomWorkoutRepeatBlock]
    var cooldownStep: CustomWorkoutPlanStep?

    init(
        warmupStep: CustomWorkoutPlanStep? = nil,
        blocks: [CustomWorkoutRepeatBlock] = [],
        cooldownStep: CustomWorkoutPlanStep? = nil
    ) {
        self.warmupStep = warmupStep
        self.blocks = blocks
        self.cooldownStep = cooldownStep
    }

    var expandedSteps: [ExpandedCustomWorkoutPlanStep] {
        var steps: [ExpandedCustomWorkoutPlanStep] = []

        if let warmupStep {
            steps.append(expandedStep(from: warmupStep, expandedStepIndex: steps.count + 1))
        }

        for block in blocks {
            // Invalid repeat counts are preserved on the unexpanded block so Phase 2 can classify
            // comparison/fallback behavior instead of guessing one valid execution iteration.
            guard block.iterationCount >= 1 else { continue }

            for repeatIteration in 1...block.iterationCount {
                for step in block.steps {
                    steps.append(
                        expandedStep(
                            from: step,
                            expandedStepIndex: steps.count + 1,
                            blockIndex: block.blockIndex,
                            repeatIteration: repeatIteration
                        )
                    )
                }
            }
        }

        if let cooldownStep {
            steps.append(expandedStep(from: cooldownStep, expandedStepIndex: steps.count + 1))
        }

        return steps
    }

    var plannedStepsPreservingCurrentAuditShape: [PlannedWorkoutStep] {
        expandedSteps.map { step in
            PlannedWorkoutStep(
                index: step.expandedStepIndex,
                label: plannedStepLabel(for: step),
                stepType: step.role.derivedIntervalLabel,
                repeatBlockIndex: step.blockIndex,
                repeatIndex: step.repeatIteration,
                plannedGoalType: step.goalType,
                plannedGoalValue: step.goalValue,
                plannedDistancePrescription: step.distancePrescription,
                plannedGoalDisplayText: plannedGoalDisplayText(
                    type: step.goalType,
                    value: step.goalValue,
                    distancePrescription: step.distancePrescription
                )
            )
        }
    }

    private func expandedStep(
        from step: CustomWorkoutPlanStep,
        expandedStepIndex: Int,
        blockIndex: Int? = nil,
        repeatIteration: Int? = nil
    ) -> ExpandedCustomWorkoutPlanStep {
        ExpandedCustomWorkoutPlanStep(
            originalStepIndex: step.originalStepIndex,
            expandedStepIndex: expandedStepIndex,
            blockIndex: blockIndex,
            repeatIteration: repeatIteration,
            role: step.role,
            goalType: step.goalType,
            goalValue: step.goalValue,
            distancePrescription: step.distancePrescription,
            source: step.source
        )
    }

    private func plannedStepLabel(for step: ExpandedCustomWorkoutPlanStep) -> String {
        switch step.role {
        case .warmup:
            "Warmup"
        case .work:
            "Work \(step.repeatIteration ?? 1)"
        case .recovery:
            "Recovery \(step.repeatIteration ?? 1)"
        case .cooldown:
            "Cooldown"
        case .open:
            "Open"
        case .extra:
            "Extra"
        case .unknown:
            "Unknown"
        }
    }

    private func plannedGoalDisplayText(
        type: PlannedWorkoutGoalType,
        value: Double?,
        distancePrescription: PlannedDistancePrescription?
    ) -> String {
        switch type {
        case .distance:
            if let distancePrescription {
                return distancePrescription.displayText
            }
            guard let value else { return "Distance unavailable" }
            return distanceDisplay(meters: value)
        case .time:
            guard let value else { return "Time unavailable" }
            return "\(Int(value.rounded())) s"
        case .open:
            return "Open"
        case .energy:
            guard let value else { return "Energy unavailable" }
            return "\(numberLabel(value)) kcal"
        case .unavailable:
            return "Unavailable"
        }
    }

    private func distanceDisplay(meters: Double) -> String {
        if meters >= 1_000 {
            return "\(numberLabel(meters / 1_000)) km"
        }
        return "\(numberLabel(meters)) m"
    }

    private func numberLabel(_ value: Double) -> String {
        if abs(value.rounded() - value) < 0.01 {
            return String(Int(value.rounded()))
        }
        return String(format: "%.2f", value)
    }
}

private extension CustomWorkoutStepRole {
    var derivedIntervalLabel: DerivedIntervalLabel {
        switch self {
        case .warmup:
            .warmup
        case .work:
            .work
        case .recovery:
            .recovery
        case .cooldown:
            .cooldown
        case .open, .extra:
            .open
        case .unknown:
            .unknown
        }
    }
}
