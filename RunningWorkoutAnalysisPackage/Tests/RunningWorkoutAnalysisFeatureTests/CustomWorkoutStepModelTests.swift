import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func customWorkoutStepModelPreservesSimpleWarmupWorkCooldownOrder() {
    let model = CustomWorkoutStepModel(
        warmupStep: CustomWorkoutPlanStep(
            originalStepIndex: 1,
            role: .warmup,
            goalType: .time,
            goalValue: 300
        ),
        blocks: [
            CustomWorkoutRepeatBlock(
                blockIndex: 1,
                iterationCount: 1,
                steps: [
                    CustomWorkoutPlanStep(
                        originalStepIndex: 1,
                        role: .work,
                        goalType: .distance,
                        goalValue: 1_000
                    )
                ]
            )
        ],
        cooldownStep: CustomWorkoutPlanStep(
            originalStepIndex: 1,
            role: .cooldown,
            goalType: .open
        )
    )

    let expanded = model.expandedSteps

    #expect(expanded.map(\.role) == [.warmup, .work, .cooldown])
    #expect(expanded.map(\.expandedStepIndex) == [1, 2, 3])
    #expect(expanded[0].blockIndex == nil)
    #expect(expanded[2].repeatIteration == nil)
}

@Test func customWorkoutStepModelExpandsRepeatBlocksInExecutionOrder() {
    let model = CustomWorkoutStepModel(
        blocks: [
            CustomWorkoutRepeatBlock(
                blockIndex: 1,
                iterationCount: 3,
                steps: [
                    CustomWorkoutPlanStep(
                        originalStepIndex: 1,
                        role: .work,
                        goalType: .distance,
                        goalValue: 400
                    ),
                    CustomWorkoutPlanStep(
                        originalStepIndex: 2,
                        role: .recovery,
                        goalType: .time,
                        goalValue: 90
                    )
                ]
            )
        ]
    )

    let expanded = model.expandedSteps

    #expect(expanded.map(\.role) == [.work, .recovery, .work, .recovery, .work, .recovery])
    #expect(expanded.map(\.expandedStepIndex) == [1, 2, 3, 4, 5, 6])
    #expect(expanded.map(\.repeatIteration) == [1, 1, 2, 2, 3, 3])
    #expect(expanded.map(\.originalStepIndex) == [1, 2, 1, 2, 1, 2])
}

@Test func customWorkoutStepModelRetainsRepeatMetadata() {
    let model = CustomWorkoutStepModel(
        blocks: [
            CustomWorkoutRepeatBlock(
                blockIndex: 2,
                iterationCount: 2,
                steps: [
                    CustomWorkoutPlanStep(
                        originalStepIndex: 4,
                        role: .recovery,
                        goalType: .time,
                        goalValue: 120,
                        source: .healthKit
                    )
                ]
            )
        ]
    )

    let expanded = model.expandedSteps

    #expect(expanded.count == 2)
    #expect(expanded[0].blockIndex == 2)
    #expect(expanded[0].repeatIteration == 1)
    #expect(expanded[1].blockIndex == 2)
    #expect(expanded[1].repeatIteration == 2)
    #expect(expanded[1].originalStepIndex == 4)
    #expect(expanded[1].source == .healthKit)
}

@Test func customWorkoutStepModelPreservesInvalidRepeatBlockWithoutExpandingRows() {
    let step = CustomWorkoutPlanStep(
        originalStepIndex: 1,
        role: .work,
        goalType: .distance,
        goalValue: 1_000
    )
    let model = CustomWorkoutStepModel(
        blocks: [
            CustomWorkoutRepeatBlock(blockIndex: 1, iterationCount: 0, steps: [step]),
            CustomWorkoutRepeatBlock(blockIndex: 2, iterationCount: -2, steps: [step])
        ]
    )

    #expect(model.blocks.count == 2)
    #expect(model.blocks[0].iterationCount == 0)
    #expect(model.blocks[0].steps == [step])
    #expect(model.blocks[1].iterationCount == -2)
    #expect(model.blocks[1].steps == [step])
    #expect(model.expandedSteps.isEmpty)
}

@Test func customWorkoutStepModelPreservesOriginalUnexpandedStructure() {
    let warmup = CustomWorkoutPlanStep(
        originalStepIndex: 1,
        role: .warmup,
        goalType: .open
    )
    let work = CustomWorkoutPlanStep(
        originalStepIndex: 1,
        role: .work,
        goalType: .distance,
        goalValue: 800
    )
    let recovery = CustomWorkoutPlanStep(
        originalStepIndex: 2,
        role: .recovery,
        goalType: .time,
        goalValue: 60
    )
    let cooldown = CustomWorkoutPlanStep(
        originalStepIndex: 1,
        role: .cooldown,
        goalType: .time,
        goalValue: 300
    )
    let model = CustomWorkoutStepModel(
        warmupStep: warmup,
        blocks: [
            CustomWorkoutRepeatBlock(blockIndex: 1, iterationCount: 4, steps: [work, recovery])
        ],
        cooldownStep: cooldown
    )

    #expect(model.warmupStep == warmup)
    #expect(model.blocks.count == 1)
    #expect(model.blocks[0].iterationCount == 4)
    #expect(model.blocks[0].steps == [work, recovery])
    #expect(model.cooldownStep == cooldown)
}

@Test func customWorkoutStepModelPreservesExistingPlannedStepOutputShape() {
    let model = CustomWorkoutStepModel(
        warmupStep: CustomWorkoutPlanStep(
            originalStepIndex: 1,
            role: .warmup,
            goalType: .time,
            goalValue: 300
        ),
        blocks: [
            CustomWorkoutRepeatBlock(
                blockIndex: 1,
                iterationCount: 2,
                steps: [
                    CustomWorkoutPlanStep(
                        originalStepIndex: 1,
                        role: .work,
                        goalType: .distance,
                        goalValue: 1_000
                    ),
                    CustomWorkoutPlanStep(
                        originalStepIndex: 2,
                        role: .recovery,
                        goalType: .time,
                        goalValue: 60
                    )
                ]
            )
        ],
        cooldownStep: CustomWorkoutPlanStep(
            originalStepIndex: 1,
            role: .cooldown,
            goalType: .open
        )
    )

    let plannedSteps = model.plannedStepsPreservingCurrentAuditShape

    #expect(plannedSteps == [
        PlannedWorkoutStep(
            index: 1,
            label: "Warmup",
            stepType: .warmup,
            plannedGoalType: .time,
            plannedGoalValue: 300,
            plannedGoalDisplayText: "300 s"
        ),
        PlannedWorkoutStep(
            index: 2,
            label: "Work 1",
            stepType: .work,
            repeatBlockIndex: 1,
            repeatIndex: 1,
            plannedGoalType: .distance,
            plannedGoalValue: 1_000,
            plannedGoalDisplayText: "1 km"
        ),
        PlannedWorkoutStep(
            index: 3,
            label: "Recovery 1",
            stepType: .recovery,
            repeatBlockIndex: 1,
            repeatIndex: 1,
            plannedGoalType: .time,
            plannedGoalValue: 60,
            plannedGoalDisplayText: "60 s"
        ),
        PlannedWorkoutStep(
            index: 4,
            label: "Work 2",
            stepType: .work,
            repeatBlockIndex: 1,
            repeatIndex: 2,
            plannedGoalType: .distance,
            plannedGoalValue: 1_000,
            plannedGoalDisplayText: "1 km"
        ),
        PlannedWorkoutStep(
            index: 5,
            label: "Recovery 2",
            stepType: .recovery,
            repeatBlockIndex: 1,
            repeatIndex: 2,
            plannedGoalType: .time,
            plannedGoalValue: 60,
            plannedGoalDisplayText: "60 s"
        ),
        PlannedWorkoutStep(
            index: 6,
            label: "Cooldown",
            stepType: .cooldown,
            plannedGoalType: .open,
            plannedGoalDisplayText: "Open"
        )
    ])
}
