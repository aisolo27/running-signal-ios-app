# Custom Workout Production Readiness Plan

Last updated: 2026-06-15

## Scope

This plan defines the path from debug-only Parity Lab candidate rows toward normal workout detail UI. It does not approve Swift changes, production interval reconstruction, normal workout UI changes, `HKWorkoutActivity` promotion, FIT import, HealthFit dependency, or runtime FIT usage.

Runtime source remains HealthKit plus WorkoutKit. FIT remains an offline validation oracle only.

Analytics work is blocked behind workout-structure correctness. Do not add deeper interval analytics, run-type conclusions, coaching-style labels, or structure-specific execution claims until supported custom, stopped-early, repeat-block, Open/Extra-tail, paused, and plain open-run controls are read correctly or explicitly fall back with stable reasons.

## Current Decision

Keep production interval behavior frozen.

The latest debug evidence is strong enough to keep Parity Lab active and to plan a narrow prototype gate, but not strong enough to replace normal workout detail intervals. Any implementation must pass through two separate approvals:

1. A debug-only prototype approval.
2. A later production UI promotion approval.

June 14, 2026 added one narrow normal-detail exception: a stopped-early single fixed-distance `Work` custom workout can display as a partial `Work` row when one complete HealthKit activity row maps to the single planned step and offline FIT evidence confirms the same one-lap/one-step shape. This does not approve broad simple Work/Open, repeat-block, Open/Extra tail, paused workout, or analytics promotion.

June 15, 2026 added a docs/debug-only paused repeat-block timer rule in `paused-repeat-block-timer-rule-2026-06-15.md`. It defines elapsed row windows plus active/timer duration from paired HealthKit pause overlap, but it does not approve normal workout detail UI, broad repeat-block promotion, or analytics.

June 15, 2026 also added a docs/debug-only recovery-containing Open/Extra separator rule in `recovery-containing-open-tail-rule-2026-06-15.md`. It keeps planned Recovery rows distinct from post-plan residual movement and requires fixed-step exhaustion before any Open/Extra tail. It does not approve normal workout detail UI or analytics.

June 15, 2026 also added a docs/debug-only ambiguous repeat-tail separator rule in `ambiguous-repeat-tail-rule-2026-06-15.md`. It requires repeat expansion, complete row mapping, fixed final-row exhaustion, and open-cooldown guard behavior before any repeat-block Open/Extra tail. It does not approve broader repeat-tail promotion.

June 15, 2026 also added the Gate A simple Work/Open prototype boundary in `simple-work-open-prototype-decision-2026-06-15.md`. It limits any future prototype discussion to exactly one fixed-distance Work step, one complete activity row, and a positive Open/Extra tail. It does not approve normal workout detail UI.

## Safest Narrow Path

Start with the smallest subclass only:

- `Warmup(2 km fixed distance) > one Work step fixed time or fixed distance > Cooldown(Open)`
- no recovery rows
- no repeat blocks
- no fixed cooldown followed by Open/Extra tail
- not duplicate, no-plan, summary-only, or guard-unknown
- expanded WorkoutKit planned rows, HealthKit activity candidate rows, FIT laps, and current debug candidate rows all reconcile at row level

Current supported examples:

| Start | Shape | Current status |
| --- | --- | --- |
| `2026-03-05T14:37:43Z` | `Warmup(2 km) > Work(900 s) > Cooldown(Open)` | candidate row-level supported |
| `2026-04-24T12:02:30Z` | `Warmup(2 km) > Work(4 km) > Cooldown(Open)` | candidate row-level supported |

This subclass is suitable for a future debug-only discussion, not production promotion.

## Debug Prototype Acceptance Criteria

A later task may approve a debug-only prototype only if all of these are true:

- The task explicitly approves debug-only Swift work.
- Package validation scripts are rerun and row-level results still support the subclass.
- The prototype is feature-flagged or confined to Raw HealthKit Debug / Parity Lab output.
- Existing normal workout detail intervals remain unchanged.
- Missing plan, missing activity rows, non-contiguous activity rows, count mismatch, duplicate/no-plan/summary-only status, Open/Extra ambiguity, and timer-drift outliers all fall back to current behavior.
- Debug output includes row-level confidence and fallback reason.
- Elapsed duration, active/timer duration, pause overlap, distance, and label mapping remain visible.
- Paused repeat-block rows follow the docs/debug timer rule only when paired HealthKit pause/resume evidence can be assigned to exact row windows; unpaired or ambiguous pause evidence falls back.
- Recovery-containing Open/Extra rows follow the docs/debug separator rule only when planned Recovery maps cleanly and the tail starts after all fixed planned rows are exhausted.
- Ambiguous repeat-tail rows follow the docs/debug separator rule only when repeat expansion, final fixed-row exhaustion, tail thresholding, and open-cooldown guards are all proven.
- Gate A simple Work/Open rows follow the docs/debug prototype boundary only when the workout has exactly one fixed-distance Work step, one complete HealthKit activity row, and a positive tail; all structured/special shapes fall back.
- FIT values stay outside runtime code and appear only in docs/offline validation scripts.

Required validation before prototype work:

```bash
python3 docs/validation/apple-fitness-interval-parity-dataset/score_fit_backed_two_gate_validation.py
python3 docs/validation/apple-fitness-interval-parity-dataset/score_gate_b_custom_workout_fit.py
python3 docs/validation/apple-fitness-interval-parity-dataset/extract_gate_b_row_level_fit_boundaries.py
python3 docs/validation/apple-fitness-interval-parity-dataset/validate_interval_parity.py
python3 docs/validation/apple-fitness-interval-parity-dataset/score_candidate_boundary_strategies.py
git diff --check
```

## Production UI Promotion Criteria

Normal workout detail UI promotion requires a separate later approval after a debug prototype exists. Minimum criteria:

- Analytics must remain confidence-gated until row correctness is stable across the full target workout-style matrix, not just one run style.
- Debug prototype has been validated on physical iPhone with real HealthKit data.
- A balanced evidence set covers easy Work/Open, no-tail tempo-like warmup/work/cooldown, repeat-block intervals, fixed-cooldown Open/Extra tails, paused workouts, and clean no-pause workouts.
- Evidence includes stopped-early single-step custom workouts and plain open Watch runs as controls.
- The promoted subclass has explicit acceptance thresholds for row count, label mapping, timing, distance, pause overlap, and tail behavior.
- The UI has clear fallback wording for unsupported custom workouts.
- Unsupported workouts keep the current production reconstruction rather than showing partially trusted candidate rows.
- No production path depends on FIT, HealthFit, screenshots, file imports, or private Apple behavior.
- Package tests and a Simulator smoke check pass before any commit/push.
- Physical-iPhone proof is reported separately from Simulator proof.

## Fallback Behavior

Use current production behavior unless all required evidence is present.

Fallback reasons should be explicit and stable:

- missing WorkoutKit plan
- missing HealthKit activity rows
- activity row count mismatch without an approved tail rule
- non-contiguous activity rows
- duplicate/no-plan/summary-only workout
- repeat-block rule not approved
- Open/Extra tail rule not approved
- Recovery row cannot be separated from Open/Extra tail
- repeat-tail separation ambiguous
- Gate A simple Work/Open eligibility failed
- row timing outside tolerance
- row distance outside tolerance
- label mapping ambiguous
- pause/timer drift unresolved
- pause events unpaired or pause overlap ambiguous
- unsupported workout shape

Fallback must not silently promote count-aligned rows.

## Still Blocked

These remain blocked for normal workout detail UI:

- repeat-block structured intervals
- paused repeat-block structured intervals without a debug prototype and guard proof
- recovery-containing Open/Extra tails without a debug prototype and guard proof
- ambiguous repeat-tail cases without a debug prototype and guard proof
- fixed cooldown followed by Open/Extra tail
- warmup/work/cooldown outliers with unresolved timing or distance drift
- broad `HKWorkoutActivity` promotion
- Gate A simple Work/Open production promotion
- deeper interval analytics or structure-specific execution claims before the workout-style matrix is stable

The blocked state can change only after a later task approves the relevant rule and validation shows row-level support.

## Next Review

Before any prototype discussion, review:

- `gate-b-phase-3-readiness-review.md`
- `custom-workout-candidate-reconstruction-rule-scorecard-2026-03-to-2026-06.md`
- `custom-workout-swift-gap-analysis.md`
- `custom-workout-implementation-plan.md`

Manual review targets before broadening scope:

- `2026-03-19T16:51:00Z`
- `2026-05-29T11:49:28Z`
- `2026-06-05T11:53:53Z`
- `2026-05-01T12:07:44Z`

## Explicit No-Production-Change Statement

This plan is documentation only. It does not approve Phase 3, production interval reconstruction, normal workout UI changes, `HKWorkoutActivity` promotion, FIT import, HealthFit dependency, runtime FIT usage, coaching, readiness, VDOT, training load, recovery, or race prediction.
