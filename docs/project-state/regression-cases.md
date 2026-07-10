# Canonical Regression Cases

Last updated: 2026-07-09

This catalog preserves behaviors learned from real workouts without keeping every historical export. It is engineering evidence, not a user-facing per-rep tagging model.

## Retention Rule

- Keep one representative real-device packet for each behavior public Apple APIs do not fully specify.
- Automated tests are the primary regression guard; retained exports/screenshots document the observed device behavior behind those tests.
- Do not add a new evidence folder when an existing case and generalized resolver rule already cover the behavior.
- `doNotRecollect` means the existing packet is sufficient unless a new OS or app build contradicts it.

## Cases

### `clean-repeat-fixed-tail`

- Behavior: clean ten-repeat custom workout with fixed cooldown followed by `Open / Extra`.
- Expected: expanded Work/Recovery rows, fixed Cooldown, then deterministic extra tail.
- Evidence: `docs/validation/regression-evidence/clean-repeat-fixed-tail/`.
- Tests: `debugCustomWorkoutComparisonBridgeSupportsJune30TenRepeatFixedCooldownTail`, `normalDetailGateSupportsCleanRepeatBlockFixedCooldownOpenTail`, `normalDetailGateSupportsSixRepeatFixedCooldownOpenTailRecordingShapeWithTerminalPauseMarker`.
- `doNotRecollect`: false; one fresh current-build re-export remains useful for visible/export status agreement.

### `paused-repeat-fixed-tail`

- Behavior: repeated Work/Recovery rows with paired pauses, fixed cooldown, and deterministic `Open / Extra`.
- Expected: paused rows use active/timer duration while elapsed duration and pause overlap remain available; cross-row or unpaired pauses block.
- Evidence: `docs/validation/regression-evidence/paused-repeat-fixed-tail/`.
- Tests: `normalDetailGateSupportsPausedRepeatBlockFixedCooldownOpenTailWithActiveTiming` and the `debugCustomWorkoutComparisonBridgeBlocksPausedRepeatFixedTail...` guard family.
- `doNotRecollect`: true.

### `planned-open-cooldown`

- Behavior: final WorkoutKit cooldown has an open goal.
- Expected: it remains `Cooldown` through workout end and never becomes `Open / Extra`.
- Evidence: `docs/validation/regression-evidence/planned-open-cooldown/`.
- Test: `finalPlannedOpenCooldownExtendsToWorkoutEndWithoutOpenExtraTail`.
- `doNotRecollect`: true.

### `priority-5-paused-manual-skip-2026-06-29`

- Behavior: Warmup followed by a paused/resumed 2,000 m Work manually skipped at 1,211.8 m, then Cooldown and Open tail.
- Failure guarded: plan-derived reconstruction kept chasing 2,000 m and absorbed later evidence into Work.
- Expected Work: 1.21 km; active duration 460.5 s (`07:40`); elapsed duration 568.7 s; pause overlap 108.2 s; measured pace about 380.58 s/km (`6'20"/km`).
- Planned pace target: `6:00–6:30/km`; completion `shortened`; measurement basis `shortenedMeasured`; target result `onTarget`.
- Evidence: `docs/validation/regression-evidence/manual-skip-shortened-work/`.
- Tests: `archivedSkippedTwoKilometerWorkUsesMeasuredDistanceAndActiveTime`, `targetEvaluationIsPauseAwareAndSeparatesShortenedRows`, `intervalGoalMeasuredItemsUseMeasuredStatsForShortenedDistanceWork`, `resolvedRowsAddShortenedDistanceDiagnosticWithoutBlocking`, `rawDebugExportShowsCandidateCooldownAndOpenTailWhenLegacyReconstructionWouldCollapseRows`.
- `doNotRecollect`: true.

### `stopped-early-fixed-work`

- Behavior: a fixed-distance Work is stopped before its planned goal.
- Expected: publish the complete partial HealthKit activity row only; do not invent completion or a tail.
- Evidence: `docs/validation/regression-evidence/stopped-early-work/`.
- Tests: `stoppedEarlySingleFixedDistanceWorkUsesActivityBoundaryInNormalDetail`, `stoppedEarlyMultiStepWorkoutUsesCompletedActivityPrefix`.
- `doNotRecollect`: true.

### `blocked-distance-drift`

- Behavior: activity/plan alignment appears plausible but measured boundary drift is materially unsafe.
- Expected: keep custom intervals blocked and retain whole-run detail.
- Evidence: `docs/validation/regression-evidence/blocked-distance-drift/`.
- Tests: generalized missing/incomplete/non-contiguous activity and fallback guards in `RunningWorkoutAnalysisFeatureTests` and `CustomWorkoutComparisonModelTests`.
- `doNotRecollect`: true unless new real evidence resolves the drift.

### `plain-open-run`

- Behavior: ordinary Watch outdoor run without a WorkoutKit plan.
- Expected: category defaults to Other; show whole-run analytics and splits; do not invent custom intervals.
- Evidence: code fixture only; public contract is sufficient.
- Tests: `openRunWithoutPlannedStepsDoesNotInventCustomIntervals`, `intervalLibraryExcludesNoPlanAndNoWorkRows`, `runClassifierRequiresOfficialStructuredRowsForInterval`.

### `missing-or-malformed-evidence`

- Behavior: missing plan/activity rows, excess/non-contiguous rows, incomplete repeats, ambiguous tails, or malformed pauses.
- Expected: whole-run fallback with an explicit reason; no product reconstruction.
- Evidence: code fixtures only.
- Tests: the negative resolver families in `CustomWorkoutComparisonModelTests` and `RunningWorkoutAnalysisFeatureTests`.

### `dynamic-pace-targets`

- Behavior: variable distance goals, exact pace ranges, one-sided thresholds, paused rows, shortened rows, and time/open goals.
- Expected: completion and target status remain separate; shortened rows use measured distance and active time; one-sided thresholds are not presented as exact ranges.
- Evidence: Priority 5 plus code fixtures.
- Tests: `targetEvaluationSupportsDynamicDistanceGoals`, `targetEvaluationIncludesRangeBoundariesAndClassifiesFastSlow`, `oneSidedPaceThresholdIsNotPresentedAsAnExactRange`, `targetEvaluationUsesMeasuredBasisForTimeAndOpenGoals`.
