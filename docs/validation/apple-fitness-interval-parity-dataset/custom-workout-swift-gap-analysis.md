# Custom Workout Swift Gap Analysis

Last updated: 2026-06-13

## Scope

This report compares the ideal custom workout reconstruction rules against the current Swift implementation. It is documentation only. Swift source, production interval behavior, normal workout UI, and runtime data sources remain unchanged.

## Files Inspected

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/WorkoutEvidenceService.swift`
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/WorkoutIntervalReconstruction.swift`
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/WorkoutEvidence.swift`
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/DiagnosticsExport.swift`

## Direct Answers

1. Where does RunSignal currently read WorkoutKit planned structure?

RunSignal reads `HKWorkout.workoutPlan` in `WorkoutEvidenceService.workoutPlanAudit(for:)`. `WorkoutKitPlanAuditFormatter` converts custom workouts into `WorkoutPlanAudit.plannedSteps`.

2. Does RunSignal retrieve the completed workout composition from HKWorkout if available?

Yes. `workoutPlanAudit(for:)` calls `try await workout.workoutPlan` for completed `HKWorkout` instances when WorkoutKit is available. The result is saved in `WorkoutEvidence.workoutPlanAudit`.

3. Does RunSignal expand repeat blocks correctly?

Mostly yes for the current debug model. `customWorkoutSteps(_:)` appends warmup, then expands each block by `block.iterations`, then appends cooldown. It labels repeated work/recovery rows by repeat iteration and stores `repeatBlockIndex` and `repeatIndex`.

Gap: it does not preserve a separate original unexpanded structure model with original block step index. The expanded rows are useful, but the original structure is only retained in summary lines and partial repeat metadata.

4. Does RunSignal distinguish work vs recovery vs warmup vs cooldown?

Yes. Warmup and cooldown are explicit planned rows. Block steps map `intervalStep.purpose == .work` to `.work`; every other block purpose currently maps to `.recovery`.

Gap: recovery/rest nuance is collapsed to Recovery. Unknown or future block purposes do not get a distinct Unknown role.

5. Does RunSignal know when each step ends?

Partially. `WorkoutIntervalReconstructionEngine` ends distance goals from HealthKit distance samples, time goals by adding planned seconds to the cursor, and open cooldowns at workout end.

Gaps:

- time goals do not yet model active/timer time or pause-adjusted duration
- open non-cooldown goals are not reconstructable without a public/manual transition
- distance-goal boundaries are still a debug/research rule and not approved for all custom workout shapes
- current reconstruction can differ from FIT/Apple row timing on some repeat-block workouts

6. Does RunSignal detect Open/Extra tail only after planned steps are exhausted?

Yes in the current reconstruction engine. It appends `Open / Extra` only after iterating planned steps and only when remaining time or distance exceeds threshold.

Gap: the rule is not yet formalized as an approved Gate B production rule, and tail validation still has blocked cases.

7. Does RunSignal incorrectly fold Open/Extra tail into cooldown or final planned rows?

For planned open cooldowns, RunSignal intentionally extends Cooldown to workout end. That is correct under the new rule. For fixed cooldowns, the engine can create Open/Extra after planned rows are exhausted.

Gap: row-level Gate B still found Open/Extra tail cases that need explicit approval rules before production behavior changes. The current activity candidate also infers a tail from workout end minus final activity boundary, but that remains debug-only.

8. Does RunSignal use HKWorkoutActivity rows for candidate boundaries?

Yes, but only in diagnostics. `DiagnosticsExport.activityBoundaryCandidate(...)` maps `WorkoutEvidence.activities` to planned steps and exports `activityBoundaryCandidateSummary` plus `activityBoundaryCandidateIntervals`. The caveats explicitly say these rows are debug-only, not production interval logic, and not normal UI.

9. Does RunSignal have enough data to map HKWorkoutActivity rows to expanded WorkoutKit steps?

Often yes when activity count equals expanded planned step count and activities are contiguous. The current candidate mapper requires planned steps, activity rows, equal counts, positive end boundaries, and contiguity before mapping by planned step order.

Gaps:

- equal count is too strict for planned rows followed by Open/Extra tails
- no standalone model captures reconciliation status, fallback reason, or row-level confidence
- mapping is order-based and does not yet encode the repeat-block and tail rules as reusable domain logic

10. What existing logic should be kept?

- `HKWorkout.workoutPlan` retrieval from completed workouts.
- Expanded planned-step generation from warmup, repeated blocks, and cooldown.
- HealthKit-only runtime source.
- FIT and Apple Fitness/manual rows as offline/debug references only.
- Raw HealthKit segment markers as debug evidence only.
- Debug-only `HKWorkoutActivity` candidate export.
- Fallback behavior when plan or activities are missing.
- Open cooldown extending to workout end.

11. What existing logic is wrong or incomplete?

- No durable internal model for original unexpanded structure plus expanded rows.
- No explicit `originalStepIndex`, `blockIndex`, `repeatIteration`, role, goal, and source model for future scoring.
- Repeat-block rules are implicit in expansion but not formalized for validation/prototype approval.
- Activity candidate mapping rejects count mismatches before evaluating whether the mismatch is a valid Open/Extra tail.
- Time-goal reconstruction uses simple elapsed seconds and still notes pause-adjusted active duration as TODO.
- Open non-cooldown steps cannot be resolved without a reliable manual transition and should stay uncertain.
- Recovery/rest/unknown block purposes are not fully differentiated.
- Gate B row-level confidence is not represented as a first-class Swift model.

12. What should not be touched yet?

- Do not implement Gate A simple Work/Open prototype.
- Do not implement Gate B custom workout reconstruction.
- Do not promote `HKWorkoutActivity` rows.
- Do not change production interval behavior.
- Do not change normal workout UI.
- Do not add FIT import, HealthFit dependency, or runtime FIT usage.
- Do not add coaching, readiness, race prediction, training load, recovery, or VDOT features.

## Current Correct Behavior

RunSignal already has the right data-source split: WorkoutKit supplies planned structure and HealthKit supplies completed workout stats. It already expands blocks into ordered planned rows, calculates debug reconstructed intervals from HealthKit samples, exports debug-only activity candidates, and keeps segment markers out of production interval UI.

## Missing Model

The main missing piece is not raw access to the data. It is an explicit custom workout reconstruction model that separates:

- original planned structure
- expanded planned timeline
- current reconstruction rows
- `HKWorkoutActivity` candidate rows
- row-level boundary confidence
- fallback reason
- tail ambiguity state

Without that model, Gate B stays a collection of debug exports rather than a production-ready rule set.

## Gate B Read

The current Swift implementation supports further validation work, but it should not be promoted. The row-level Gate B scorecard found 25 workouts: 20 structured intervals and 5 warmup/work/cooldown specials. Structured intervals remain blocked mostly by repeat-block rules. Warmup/work/cooldown has 2 candidate-supported rows, 2 inconclusive rows, and 1 Open/Extra tail-rule case.

## Recommendation

Keep the existing logic in place and add no Swift behavior yet. The next Swift work, when explicitly approved later, should start with internal model types and debug-only comparison surfaces, not production interval changes.
