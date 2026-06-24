# Paused Repeat Open/Extra Tail Rule

Last updated: 2026-06-23

## Decision

True paused repeat fixed-tail `Open / Extra` cases remain blocked from normal-detail interval promotion.

The approved paused-repeat normal-detail gate is still limited to:

`Warmup(2 km) > repeated Work/Recovery rows > Cooldown(Open)`

That gate keeps the final open cooldown as `Cooldown` through the workout end and only uses paired HealthKit pause overlap to display active/timer duration for rows whose pause windows are reliable.

## Required Future Gate

A paused repeat fixed-tail `Open / Extra` shape can move from blocked to debug/export prototype only when all of these are true:

- WorkoutKit planned rows expand into ordered `Warmup`, repeated `Work`/`Recovery`, and a fixed final `Cooldown`.
- Every fixed planned row maps to a complete, contiguous HealthKit activity row with distance evidence.
- The final fixed planned row has a resolved end boundary before workout end.
- Residual movement after the final fixed row is positive and above the existing `Open / Extra` threshold.
- HealthKit pause events resolve into paired, row-assignable pause windows.
- Pause overlap does not cross planned-row boundaries.
- Open-cooldown controls still block `Open / Extra` inference.

## Blocked Cases

Keep normal detail blocked when:

- The final planned row is `Cooldown(Open)`.
- Residual movement overlaps planned `Work`, `Recovery`, or `Cooldown` rows.
- Pause/resume events are unpaired, duplicated, dangling, or otherwise caveated.
- A pause interval crosses row boundaries or cannot be assigned to one row.
- Activity rows are missing, non-contiguous, count-mismatched, or lack distance statistics.
- FIT lap/session residual conflicts with mapped HealthKit activity rows.
- Duplicate, no-plan, same-day extra, summary-only, or guard-unknown status applies.

## Current Product Behavior

Normal detail may show paused repeat rows only for the proofed open-cooldown shape. True paused repeat fixed-tail `Open / Extra` cases must fall back with stable blocked reasons until a later task approves a debug-only prototype and separately approves normal-detail promotion after proof.

## Validation Notes

Future work should pair this rule with:

- `paused-repeat-block-timer-rule-2026-06-15.md`
- `ambiguous-repeat-tail-rule-2026-06-15.md`
- `custom-workout-correctness-lock-v1.md`
- physical proof folder for the paused-repeat open-cooldown gate

Do not collect new physical evidence unless the workout has paired pauses, a fixed final planned row, and an unambiguous post-final-row tail.
