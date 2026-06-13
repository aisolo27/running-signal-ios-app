# Custom Workout Implementation Plan

Last updated: 2026-06-13

## Scope

This is a future implementation plan only. Do not implement these phases until a later task explicitly approves Swift changes. Runtime source remains HealthKit/WorkoutKit. FIT remains offline validation only. Production behavior and normal workout UI remain unchanged.

## Phase 1: Internal Expanded-Step Model

Add internal model types for custom workout reconstruction. These should be debug/internal first and should not change production interval behavior.

Required model fields:

- `originalStepIndex`: original step position in warmup/block/cooldown context.
- `expandedStepIndex`: execution-order index after expanding repeats.
- `blockIndex`: block number for block-derived rows.
- `repeatIteration`: repeat number for block-derived rows.
- `role`: `warmup`, `work`, `recovery`, `cooldown`, `open`, `extra`, `unknown`.
- `goalType`: `time`, `distance`, `open`, `energy`, `unavailable`.
- `goalValue`: seconds for time, meters for distance, nil for open.
- `source`: `WorkoutKit`, `HealthKit`, or `FIT-reference-only`.

Also preserve original unexpanded structure:

- warmup step
- block list
- block iteration count
- block step list
- cooldown step

Success criteria:

- Existing `WorkoutPlanAudit.plannedSteps` behavior remains unchanged.
- New model can reproduce the existing expanded planned row order.
- Repeat metadata includes enough information to map FIT unexpanded `workout_step` rows to expanded planned rows during validation.

## Phase 2: Debug-Only Reconstruction Comparison

Add a debug-only comparison model that can show:

- current RunSignal rows
- `HKWorkoutActivity` candidate rows
- expanded planned rows
- row-level boundary confidence
- fallback reason

The comparison should classify each workout row or workout as:

- supported
- equivalent
- inconclusive
- repeat-block-needs-rule
- open-tail-needs-rule
- label-mapping-needs-rule
- missing-required-evidence

Success criteria:

- No normal workout UI change.
- No production interval behavior change.
- Debug exports include row-level confidence and fallback reason.
- FIT values remain excluded from runtime and appear only in docs/offline validation scripts.

## Phase 3: Narrow Custom Workout Prototype Gate

Prototype custom workout reconstruction only when all of these are true:

- expanded planned steps exist
- `HKWorkoutActivity` rows reconcile with expanded planned rows
- labels reconcile from expanded WorkoutKit order
- no Open/Extra ambiguity exists
- workout is not duplicate
- workout is not no-plan
- workout is not summary-only
- row-level Gate B evidence supports the subclass

This phase should still be feature-flagged or debug-only until explicitly promoted.

Success criteria:

- Prototype emits fallback reasons for rejected workouts.
- Prototype preserves current reconstruction when candidate rows are missing or ambiguous.
- No broad custom workout promotion.

## Phase 4: Structured Interval Repeat-Block Prototype

Start only after Gate B row-level evidence passes for structured intervals.

Required rules:

- expand blocks by iteration in execution order
- label Work and Recovery rows by repeat iteration
- treat FIT `workout_step` rows as unexpanded validation evidence
- compare FIT laps against expanded planned rows
- map `HKWorkoutActivity` rows to expanded planned rows only when counts, contiguity, labels, and stats reconcile
- keep raw segment markers debug-only

Blocked until:

- repeat-block row-level timing and distance errors are inside tolerance
- label mapping is stable across multiple repeat shapes
- Open/Extra tails after repeat blocks have an explicit rule

## Phase 5: Warmup/Work/Cooldown Plus Open Tail Prototype

Start only after the Open/Extra tail rule passes.

Required rules:

- warmup maps to Warmup
- single work step maps to Work
- cooldown maps to Cooldown
- open cooldown remains Cooldown through workout end unless a reliable transition proves otherwise
- fixed cooldown followed by continued running becomes Open/Extra only after the cooldown boundary
- if FIT lacks an explicit tail lap, validation may use session-minus-lap as offline reference

Blocked until:

- inconclusive warmup/work/cooldown outliers are reviewed
- fixed cooldown plus Open/Extra tail has row-level support
- fallback behavior is defined for missing activity rows and ambiguous tail evidence

## Do Not Touch Yet

- Gate A simple Work/Open Swift prototype.
- Production interval reconstruction.
- Normal workout UI.
- `HKWorkoutActivity` promotion.
- FIT import or HealthFit dependency.
- Runtime FIT usage.
- Coaching, readiness, race prediction, training load, recovery, or VDOT.

## Validation Before Any Future Swift Prototype

Before any future implementation task, rerun:

```bash
python3 docs/validation/apple-fitness-interval-parity-dataset/score_fit_backed_two_gate_validation.py
python3 docs/validation/apple-fitness-interval-parity-dataset/score_gate_b_custom_workout_fit.py
python3 docs/validation/apple-fitness-interval-parity-dataset/extract_gate_b_row_level_fit_boundaries.py
python3 docs/validation/apple-fitness-interval-parity-dataset/validate_interval_parity.py
python3 docs/validation/apple-fitness-interval-parity-dataset/score_candidate_boundary_strategies.py
git diff --check
```

If any row-level result changes, update the plan before changing Swift.
