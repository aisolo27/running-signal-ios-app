# Interval Analytics Readiness Handoff

Last updated: 2026-06-23

## Decision

Do not start interval-row analytics yet.

Implementation note: `DerivedAnalyticsEngine.intervalCandidates` currently reads raw HealthKit event windows directly, computes duration as elapsed `event.endDate - event.startDate`, and does not call `WorkoutIntervalReconstruction` or the pause-window resolver. Treat those rows as raw candidates only. They are not the pause-adjusted, normal-detail custom-workout reconstruction path and should not be used as Tier 3 interval analytics until this gate is reopened with explicit evidence and tests.

Current raw candidate outputs carry this caveat in each row: duration and pace use elapsed HealthKit event-window time, and pause overlap is not subtracted.

The custom-workout correctness lock now has eight frozen normal-detail gates and explicit blocked boundaries for ambiguous repeat tails, true paused repeat fixed-tail `Open / Extra`, and broad recovery-tail behavior. That is enough to keep current normal detail stable, but not enough to add per-row coaching or analysis across all custom workout styles.

## Ready Inputs

The following can be treated as stable inputs for later analytics planning:

- Plain open runs still use whole-workout stats, splits, route, and existing detail behavior.
- Stopped-early single fixed-distance `Work` has a narrow supported row.
- Simple fixed-distance `Work > Open / Extra` has a narrow supported row plus tail.
- `Warmup > one Work step > Cooldown(Open)` is supported only for the approved narrow shape.
- `Warmup > one Work step > fixed Cooldown > Open / Extra` is supported only for the approved narrow shape.
- Clean no-pause repeat open-cooldown and fixed-cooldown-tail shapes are supported only for the approved narrow shapes.
- Narrow paused repeat open-cooldown supports elapsed plus active/timer display from reliable paired pause overlap.
- Narrow May 1-style recovery-containing fixed-cooldown tail is supported only for the approved row order.

## Not Ready

Do not build analytics that depend on:

- Broad repeat-tail inference.
- True paused repeat fixed-tail `Open / Extra` inference.
- Broad recovery-tail inference.
- Recovery rows inside repeat blocks.
- Rows with missing, non-contiguous, count-mismatched, or distance-less HealthKit activities.
- Unpaired, duplicate, dangling, cross-row, or otherwise caveated pause streams.
- Raw `DerivedAnalyticsEngine.intervalCandidates` rows, unless they have been replaced or backed by the approved reconstruction path.
- FIT, HealthFit, screenshots, or file imports as runtime data.

## Open Follow-Up

Before any Tier 3 or interval-row analytics work starts, decide the fate of `DerivedAnalyticsEngine.intervalCandidates`:

- If it remains a raw debug/audit candidate path, keep elapsed-duration semantics explicit and do not use its pace or confidence as trusted custom-workout row analytics.
- If it becomes an analytics input, replace or back it with approved reconstructed rows, pause-window resolution, active/timer duration, caveats, and regression tests for paused, malformed, and no-pause streams.

This is separate from the `ReconstructedWorkoutInterval.activeDurationSeconds` fix. That fix improves diagnostics and the approved normal-detail reconstruction path, but it does not by itself clear the broader interval analytics gate.

## Analytics Gate

Before interval analytics starts, verify:

- Normal-detail rows and Raw HealthKit Debug/parity export rows agree on labels, row counts, elapsed duration, active duration, pause overlap, distance, tail status, and fallback reasons.
- Each workout style in `custom-workout-correctness-lock-v1.md` is either supported with evidence or intentionally blocked with stable fallback behavior.
- Unsupported shapes have regression fixtures that prove they stay blocked.
- Analytics UI states can show confidence or fallback reasons without inventing interval labels.

Until those checks pass, analytics should stay whole-workout-level only.
