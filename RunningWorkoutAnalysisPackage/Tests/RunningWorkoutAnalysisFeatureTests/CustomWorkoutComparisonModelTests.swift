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
