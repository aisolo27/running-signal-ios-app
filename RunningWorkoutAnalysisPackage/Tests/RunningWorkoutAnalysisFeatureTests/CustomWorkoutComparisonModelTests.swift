import Foundation
import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func debugCustomWorkoutComparisonMissingPlannedRowsReturnsMissingRequiredEvidence() {
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plan: nil,
        activityRows: [activityRow()]
    )

    #expect(comparison.status == .missingRequiredEvidence)
    #expect(comparison.fallbackReasons.contains(.missingPlannedSteps))
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonInvalidRepeatCountKeepsFallbackReason() {
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plan: CustomWorkoutStepModel(
            blocks: [
                CustomWorkoutRepeatBlock(blockIndex: 1, iterationCount: 0, steps: [planStep()])
            ]
        ),
        activityRows: [activityRow()]
    )

    #expect(comparison.status == .missingRequiredEvidence)
    #expect(comparison.fallbackReasons.contains(.invalidRepeatCount))
    #expect(comparison.fallbackReasons.contains(.missingPlannedSteps))
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonEqualPlannedAndActivityCountsWithoutRowLevelSupportIsNotSupported() {
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plan: singleWorkPlan(),
        currentRows: [currentRow()],
        activityRows: [activityRow()]
    )

    #expect(comparison.status == .inconclusive)
    #expect(comparison.status != .supported)
    #expect(comparison.rows.count == 1)
    #expect(comparison.rows[0].confidence == .inconclusive)
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonEqualPlannedAndActivityCountsWithRowLevelSupportCanBeSupported() {
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plan: singleWorkPlan(),
        currentRows: [currentRow()],
        activityRows: [activityRow()],
        rowLevelSupport: true
    )

    #expect(comparison.status == .supported)
    #expect(comparison.rows.count == 1)
    #expect(comparison.rows[0].confidence == .supported)
    #expect(comparison.rows[0].plannedRow?.role == .work)
    #expect(comparison.rows[0].currentRunSignalRow?.role == .work)
    #expect(comparison.rows[0].activityCandidateRow?.role == .work)
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonMissingEvidenceWinsOverRowLevelSupport() {
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plan: singleWorkPlan(),
        activityRows: [],
        rowLevelSupport: true,
        rowsAreDebugEquivalent: true
    )

    #expect(comparison.status == .missingRequiredEvidence)
    #expect(comparison.fallbackReasons.contains(.missingActivityRows))
    #expect(comparison.rows.allSatisfy { $0.confidence == .missingEvidence })
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonEqualPlannedAndActivityCountsCanBeEquivalentWithoutApproval() {
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plan: singleWorkPlan(),
        currentRows: [currentRow()],
        activityRows: [activityRow()],
        rowsAreDebugEquivalent: true
    )

    #expect(comparison.status == .equivalent)
    #expect(comparison.rows[0].confidence == .equivalent)
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonTailAmbiguityBlocksRowLevelSupport() {
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plan: singleWorkPlan(),
        activityRows: [activityRow()],
        rowLevelSupport: true,
        tailAmbiguity: .ambiguous
    )

    #expect(comparison.status == .openTailNeedsRule)
    #expect(comparison.fallbackReasons.contains(.openExtraTailAmbiguous))
    #expect(comparison.rows[0].confidence == .needsRule)
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonActivityCountMismatchCanBeOpenTailNeedsRule() {
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plan: singleWorkPlan(),
        activityRows: [
            activityRow(index: 1, role: .work),
            activityRow(index: 2, role: .extra)
        ],
        tailAmbiguity: .postPlanActivityCandidate
    )

    #expect(comparison.status == .openTailNeedsRule)
    #expect(comparison.tailAmbiguity == .postPlanActivityCandidate)
    #expect(comparison.fallbackReasons.contains(.activityCountMismatch))
    #expect(comparison.fallbackReasons.contains(.openExtraTailAmbiguous))
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonRepeatBlockNeedsRuleEvenWithRowLevelSupport() {
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plan: repeatBlockPlan(),
        activityRows: [
            activityRow(index: 1, role: .work),
            activityRow(index: 2, role: .recovery),
            activityRow(index: 3, role: .work),
            activityRow(index: 4, role: .recovery)
        ],
        rowLevelSupport: true
    )

    #expect(comparison.status == .repeatBlockNeedsRule)
    #expect(comparison.rows.allSatisfy { $0.confidence == .needsRule })
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonRepeatBlockCanBeSupportedOnlyWhenRuleApproved() {
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plan: repeatBlockPlan(),
        activityRows: [
            activityRow(index: 1, role: .work),
            activityRow(index: 2, role: .recovery),
            activityRow(index: 3, role: .work),
            activityRow(index: 4, role: .recovery)
        ],
        rowLevelSupport: true,
        repeatBlockRuleApproved: true
    )

    #expect(comparison.status == .supported)
    #expect(comparison.rows.allSatisfy { $0.confidence == .supported })
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonLabelAmbiguityProducesLabelMappingNeedsRule() {
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plan: singleWorkPlan(),
        activityRows: [activityRow(role: .unknown)],
        labelsAreAmbiguous: true
    )

    #expect(comparison.status == .labelMappingNeedsRule)
    #expect(comparison.fallbackReasons.contains(.labelMappingAmbiguous))
    #expect(comparison.rows[0].confidence == .needsRule)
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonLabelAmbiguityDoesNotHideMissingRequiredEvidence() {
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plan: nil,
        activityRows: [],
        labelsAreAmbiguous: true
    )

    #expect(comparison.status == .missingRequiredEvidence)
    #expect(comparison.fallbackReasons.contains(.missingPlannedSteps))
    #expect(comparison.fallbackReasons.contains(.missingActivityRows))
    #expect(comparison.fallbackReasons.contains(.labelMappingAmbiguous))
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonRepeatBlockProducesRepeatBlockNeedsRule() {
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plan: repeatBlockPlan(),
        activityRows: [
            activityRow(index: 1, role: .work),
            activityRow(index: 2, role: .recovery),
            activityRow(index: 3, role: .work),
            activityRow(index: 4, role: .recovery)
        ]
    )

    #expect(comparison.status == .repeatBlockNeedsRule)
    #expect(comparison.rows.count == 4)
    #expect(comparison.rows.map { $0.plannedRow?.repeatIteration } == [1, 1, 2, 2])
    #expect(comparison.rows.allSatisfy { $0.confidence == .needsRule })
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonRepeatBlockWithMissingActivityRowsReturnsMissingRequiredEvidence() {
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plan: repeatBlockPlan(),
        activityRows: []
    )

    #expect(comparison.status == .missingRequiredEvidence)
    #expect(comparison.fallbackReasons.contains(.missingActivityRows))
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonOpenExtraTailProducesOpenTailNeedsRule() {
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plan: CustomWorkoutStepModel(
            blocks: [
                CustomWorkoutRepeatBlock(blockIndex: 1, iterationCount: 1, steps: [planStep()])
            ],
            cooldownStep: CustomWorkoutPlanStep(
                originalStepIndex: 1,
                role: .cooldown,
                goalType: .distance,
                goalValue: 400
            )
        ),
        activityRows: [
            activityRow(index: 1, role: .work),
            activityRow(index: 2, role: .cooldown),
            activityRow(index: 3, role: .open)
        ],
        tailAmbiguity: .fixedCooldownFollowedByPossibleOpenExtraTail
    )

    #expect(comparison.status == .openTailNeedsRule)
    #expect(comparison.tailAmbiguity == .fixedCooldownFollowedByPossibleOpenExtraTail)
    #expect(comparison.fallbackReasons.contains(.openExtraTailAmbiguous))
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonOpenExtraTailAmbiguityWithMissingEvidenceReturnsMissingRequiredEvidence() {
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plan: singleWorkPlan(),
        activityRows: [],
        tailAmbiguity: .fixedCooldownFollowedByPossibleOpenExtraTail
    )

    #expect(comparison.status == .missingRequiredEvidence)
    #expect(comparison.fallbackReasons.contains(.missingActivityRows))
    #expect(comparison.fallbackReasons.contains(.openExtraTailAmbiguous))
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonBridgeSupportsSimplePlannedActivityRows() {
    let start = Date(timeIntervalSince1970: 1_797_000_000)
    let workout = bridgeWorkout(start: start, distanceMeters: 3_000, durationSeconds: 1_200)
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plannedSteps: [
            plannedStep(index: 1, label: "Warmup", stepType: .warmup, goalType: .distance, goalValue: 2_000),
            plannedStep(index: 2, label: "Work", stepType: .work, repeatBlockIndex: 1, repeatIndex: 1, goalType: .time, goalValue: 900),
            plannedStep(index: 3, label: "Cooldown", stepType: .cooldown, goalType: .open)
        ],
        activities: [
            evidenceActivity(index: 1, start: start, end: start.addingTimeInterval(700), distance: 2_000),
            evidenceActivity(index: 2, start: start.addingTimeInterval(700), end: start.addingTimeInterval(1_000), distance: 900),
            evidenceActivity(index: 3, start: start.addingTimeInterval(1_000), end: start.addingTimeInterval(1_200), distance: 100)
        ],
        workout: workout
    )

    #expect(comparison.status == .supported)
    #expect(comparison.fallbackReasons.isEmpty)
    #expect(comparison.tailAmbiguity == .plannedOpenCooldownContinuesToWorkoutEnd)
    #expect(comparison.rows.allSatisfy { $0.confidence == .supported })
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonBridgeKeepsRepeatBlocksBehindRule() {
    let start = Date(timeIntervalSince1970: 1_797_000_000)
    let workout = bridgeWorkout(start: start, distanceMeters: 1_000, durationSeconds: 360)
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plannedSteps: [
            plannedStep(index: 1, label: "Work 1", stepType: .work, repeatBlockIndex: 1, repeatIndex: 1, goalType: .distance, goalValue: 400),
            plannedStep(index: 2, label: "Recovery 1", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 1, goalType: .time, goalValue: 60),
            plannedStep(index: 3, label: "Work 2", stepType: .work, repeatBlockIndex: 1, repeatIndex: 2, goalType: .distance, goalValue: 400),
            plannedStep(index: 4, label: "Recovery 2", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 2, goalType: .time, goalValue: 60)
        ],
        activities: [
            evidenceActivity(index: 1, start: start, end: start.addingTimeInterval(120), distance: 400),
            evidenceActivity(index: 2, start: start.addingTimeInterval(120), end: start.addingTimeInterval(180), distance: 100),
            evidenceActivity(index: 3, start: start.addingTimeInterval(180), end: start.addingTimeInterval(300), distance: 400),
            evidenceActivity(index: 4, start: start.addingTimeInterval(300), end: start.addingTimeInterval(360), distance: 100)
        ],
        workout: workout
    )

    #expect(comparison.status == .repeatBlockNeedsRule)
    #expect(comparison.rows.allSatisfy { $0.confidence == .needsRule })
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonBridgeSupportsRepeatBlocksOnlyAfterRuleApproval() {
    let start = Date(timeIntervalSince1970: 1_797_000_000)
    let workout = bridgeWorkout(start: start, distanceMeters: 1_000, durationSeconds: 360)
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plannedSteps: [
            plannedStep(index: 1, label: "Work 1", stepType: .work, repeatBlockIndex: 1, repeatIndex: 1, goalType: .distance, goalValue: 400),
            plannedStep(index: 2, label: "Recovery 1", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 1, goalType: .time, goalValue: 60),
            plannedStep(index: 3, label: "Work 2", stepType: .work, repeatBlockIndex: 1, repeatIndex: 2, goalType: .distance, goalValue: 400),
            plannedStep(index: 4, label: "Recovery 2", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 2, goalType: .time, goalValue: 60)
        ],
        activities: [
            evidenceActivity(index: 1, start: start, end: start.addingTimeInterval(120), distance: 400),
            evidenceActivity(index: 2, start: start.addingTimeInterval(120), end: start.addingTimeInterval(180), distance: 100),
            evidenceActivity(index: 3, start: start.addingTimeInterval(180), end: start.addingTimeInterval(300), distance: 400),
            evidenceActivity(index: 4, start: start.addingTimeInterval(300), end: start.addingTimeInterval(360), distance: 100)
        ],
        workout: workout,
        repeatBlockRuleApproved: true
    )

    #expect(comparison.status == .supported)
    #expect(comparison.fallbackReasons.isEmpty)
    #expect(comparison.rows.allSatisfy { $0.confidence == .supported })
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonBridgeBlocksOpenTailRule() {
    let start = Date(timeIntervalSince1970: 1_797_000_000)
    let workout = bridgeWorkout(start: start, distanceMeters: 1_050, durationSeconds: 360)
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plannedSteps: [
            plannedStep(index: 1, label: "Work", stepType: .work, goalType: .distance, goalValue: 1_000)
        ],
        activities: [
            evidenceActivity(index: 1, start: start, end: start.addingTimeInterval(300), distance: 1_000)
        ],
        workout: workout
    )

    #expect(comparison.status == .openTailNeedsRule)
    #expect(comparison.fallbackReasons.contains(.openExtraTailAmbiguous))
    #expect(comparison.rows.allSatisfy { $0.confidence == .needsRule })
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonBridgeSupportsSimpleWorkOpenOnlyAfterGateAApproval() {
    let start = Date(timeIntervalSince1970: 1_797_000_000)
    let workout = bridgeWorkout(start: start, distanceMeters: 1_050, durationSeconds: 360)
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plannedSteps: [
            plannedStep(index: 1, label: "Work", stepType: .work, goalType: .distance, goalValue: 1_000)
        ],
        activities: [
            evidenceActivity(index: 1, start: start, end: start.addingTimeInterval(300), distance: 1_000)
        ],
        workout: workout,
        simpleWorkOpenRuleApproved: true
    )

    #expect(comparison.status == .supported)
    #expect(comparison.fallbackReasons.isEmpty)
    #expect(comparison.tailAmbiguity == .fixedCooldownFollowedByPossibleOpenExtraTail)
    #expect(comparison.rows.allSatisfy { $0.confidence == .supported })
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonBridgeDoesNotApplySimpleWorkOpenGateToSpecialWorkout() {
    let start = Date(timeIntervalSince1970: 1_797_000_000)
    let workout = bridgeWorkout(start: start, distanceMeters: 3_050, durationSeconds: 1_260)
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plannedSteps: [
            plannedStep(index: 1, label: "Warmup", stepType: .warmup, goalType: .distance, goalValue: 2_000),
            plannedStep(index: 2, label: "Work", stepType: .work, goalType: .distance, goalValue: 1_000)
        ],
        activities: [
            evidenceActivity(index: 1, start: start, end: start.addingTimeInterval(800), distance: 2_000),
            evidenceActivity(index: 2, start: start.addingTimeInterval(800), end: start.addingTimeInterval(1_200), distance: 1_000)
        ],
        workout: workout,
        simpleWorkOpenRuleApproved: true
    )

    #expect(comparison.status == .openTailNeedsRule)
    #expect(comparison.fallbackReasons.contains(.openExtraTailAmbiguous))
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonBridgeSupportsOpenTailOnlyAfterRuleApproval() {
    let start = Date(timeIntervalSince1970: 1_797_000_000)
    let workout = bridgeWorkout(start: start, distanceMeters: 4_500, durationSeconds: 1_800)
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plannedSteps: [
            plannedStep(index: 1, label: "Warmup", stepType: .warmup, goalType: .distance, goalValue: 2_000),
            plannedStep(index: 2, label: "Work 1", stepType: .work, repeatBlockIndex: 1, repeatIndex: 1, goalType: .distance, goalValue: 1_000),
            plannedStep(index: 3, label: "Cooldown", stepType: .cooldown, goalType: .distance, goalValue: 1_000)
        ],
        activities: [
            evidenceActivity(index: 1, start: start, end: start.addingTimeInterval(800), distance: 2_000),
            evidenceActivity(index: 2, start: start.addingTimeInterval(800), end: start.addingTimeInterval(1_100), distance: 1_000),
            evidenceActivity(index: 3, start: start.addingTimeInterval(1_100), end: start.addingTimeInterval(1_600), distance: 1_000)
        ],
        workout: workout,
        openTailRuleApproved: true
    )

    #expect(comparison.status == .supported)
    #expect(comparison.fallbackReasons.isEmpty)
    #expect(comparison.tailAmbiguity == .fixedCooldownFollowedByPossibleOpenExtraTail)
    #expect(comparison.rows.allSatisfy { $0.confidence == .supported })
    expectDebugOnly(comparison)
}

@Test func debugCustomWorkoutComparisonBridgeStillBlocksRepeatOpenTailWithoutRepeatRuleApproval() {
    let start = Date(timeIntervalSince1970: 1_797_000_000)
    let workout = bridgeWorkout(start: start, distanceMeters: 1_100, durationSeconds: 420)
    let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
        plannedSteps: [
            plannedStep(index: 1, label: "Work 1", stepType: .work, repeatBlockIndex: 1, repeatIndex: 1, goalType: .distance, goalValue: 400),
            plannedStep(index: 2, label: "Recovery 1", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 1, goalType: .time, goalValue: 60),
            plannedStep(index: 3, label: "Work 2", stepType: .work, repeatBlockIndex: 1, repeatIndex: 2, goalType: .distance, goalValue: 400),
            plannedStep(index: 4, label: "Cooldown", stepType: .cooldown, goalType: .distance, goalValue: 100)
        ],
        activities: [
            evidenceActivity(index: 1, start: start, end: start.addingTimeInterval(120), distance: 400),
            evidenceActivity(index: 2, start: start.addingTimeInterval(120), end: start.addingTimeInterval(180), distance: 100),
            evidenceActivity(index: 3, start: start.addingTimeInterval(180), end: start.addingTimeInterval(300), distance: 400),
            evidenceActivity(index: 4, start: start.addingTimeInterval(300), end: start.addingTimeInterval(360), distance: 100)
        ],
        workout: workout,
        openTailRuleApproved: true
    )

    #expect(comparison.status == .repeatBlockNeedsRule)
    #expect(comparison.tailAmbiguity == .fixedCooldownFollowedByPossibleOpenExtraTail)
    #expect(comparison.rows.allSatisfy { $0.confidence == .needsRule })
    expectDebugOnly(comparison)
}

private func singleWorkPlan() -> CustomWorkoutStepModel {
    CustomWorkoutStepModel(
        blocks: [
            CustomWorkoutRepeatBlock(blockIndex: 1, iterationCount: 1, steps: [planStep()])
        ]
    )
}

private func repeatBlockPlan() -> CustomWorkoutStepModel {
    CustomWorkoutStepModel(
        blocks: [
            CustomWorkoutRepeatBlock(
                blockIndex: 1,
                iterationCount: 2,
                steps: [
                    planStep(role: .work, goalType: .distance, goalValue: 400),
                    planStep(originalStepIndex: 2, role: .recovery, goalType: .time, goalValue: 90)
                ]
            )
        ]
    )
}

private func planStep(
    originalStepIndex: Int = 1,
    role: CustomWorkoutStepRole = .work,
    goalType: PlannedWorkoutGoalType = .distance,
    goalValue: Double? = 1_000
) -> CustomWorkoutPlanStep {
    CustomWorkoutPlanStep(
        originalStepIndex: originalStepIndex,
        role: role,
        goalType: goalType,
        goalValue: goalValue
    )
}

private func currentRow(
    index: Int = 1,
    role: CustomWorkoutStepRole = .work
) -> DebugCustomWorkoutCurrentRow {
    DebugCustomWorkoutCurrentRow(
        index: index,
        role: role,
        startOffsetSeconds: Double(index - 1) * 60,
        endOffsetSeconds: Double(index) * 60
    )
}

private func activityRow(
    index: Int = 1,
    role: CustomWorkoutStepRole = .work
) -> DebugCustomWorkoutActivityCandidateRow {
    DebugCustomWorkoutActivityCandidateRow(
        index: index,
        role: role,
        startOffsetSeconds: Double(index - 1) * 60,
        endOffsetSeconds: Double(index) * 60
    )
}

private func expectDebugOnly(_ comparison: DebugCustomWorkoutComparison) {
    #expect(comparison.promotesProductionBehavior == false)
}

private func bridgeWorkout(
    start: Date,
    distanceMeters: Double,
    durationSeconds: TimeInterval
) -> CanonicalWorkout {
    CanonicalWorkout(
        id: "bridge-workout",
        sourceID: "watch",
        sourceName: "Apple Watch",
        startDate: start,
        endDate: start.addingTimeInterval(durationSeconds),
        environment: .outdoor,
        distanceMeters: distanceMeters,
        durationSeconds: durationSeconds
    )
}

private func plannedStep(
    index: Int,
    label: String,
    stepType: DerivedIntervalLabel,
    repeatBlockIndex: Int? = nil,
    repeatIndex: Int? = nil,
    goalType: PlannedWorkoutGoalType,
    goalValue: Double? = nil
) -> PlannedWorkoutStep {
    PlannedWorkoutStep(
        index: index,
        label: label,
        stepType: stepType,
        repeatBlockIndex: repeatBlockIndex,
        repeatIndex: repeatIndex,
        plannedGoalType: goalType,
        plannedGoalValue: goalValue,
        plannedGoalDisplayText: goalValue.map { "\($0)" } ?? "Open"
    )
}

private func evidenceActivity(
    index: Int,
    start: Date,
    end: Date,
    distance: Double
) -> WorkoutEvidenceActivity {
    WorkoutEvidenceActivity(
        id: "activity-\(index)",
        activityType: "HKWorkoutActivityTypeRunning",
        startDate: start,
        endDate: end,
        durationSeconds: end.timeIntervalSince(start),
        statistics: [
            WorkoutEvidenceActivityStatistic(
                quantityType: "HKQuantityTypeIdentifierDistanceWalkingRunning",
                unit: "m",
                startDate: start,
                endDate: end,
                sourceCount: 1,
                sum: distance,
                durationSeconds: end.timeIntervalSince(start)
            )
        ]
    )
}
