# Ambiguous Repeat-Tail Rule

Last updated: 2026-06-23

## Goal

Define the docs/debug separator rule for repeat-block workouts where a possible final residual row could be either post-plan `Open / Extra` or an unresolved planned repeat/cooldown boundary.

This document separates an already-approved clean repeat-tail gate from unresolved ambiguous repeat-tail cases. The unresolved-case rule below is docs/debug validation only; it does not approve new Swift changes, additional normal workout detail interval promotion, broad `HKWorkoutActivity` promotion, FIT runtime usage, HealthFit dependency, file import, or interval-row analytics.

## Current Taxonomy

`Repeat-tail` now has two separate meanings in project routing:

1. Clean no-pause fixed-cooldown repeat tail. This is approved for normal detail when the exact shape is `Warmup(2 km) > repeated Work/Recovery rows > fixed final Cooldown > inferred Open / Extra`, every expanded WorkoutKit row maps to one complete contiguous distance-backed HealthKit activity row, the final fixed Cooldown boundary is resolved, no pause/timer rule is needed, and only the post-Cooldown residual becomes `Open / Extra`. June 10 is the proof fixture for this approved clean shape.
2. Ambiguous repeat-tail cases. These remain blocked from normal detail when repeat expansion, row mapping, final fixed-row exhaustion, tail threshold, pause/timer assignment, or source evidence is unresolved.

Approved repeat-block tail classes:

| Shape | Proof | Normal Detail Status |
|---|---|---|
| `Warmup(2 km) > repeated Work/Recovery rows > Cooldown(Open)` | May 20 and June 3 physical proof | Approved; final open cooldown remains `Cooldown`, no `Open / Extra` row |
| `Warmup(2 km) > repeated Work/Recovery rows > fixed final Cooldown > inferred Open / Extra` | June 10 physical proof | Approved only for the clean no-pause fixed-cooldown tail shape |

Still-blocked ambiguous repeat-tail classes:

- Paused repeat blocks with a true `Open / Extra` tail after a fixed final row.
- Repeat blocks where a final `Cooldown(Open)` is followed by apparent residual movement; the open cooldown should continue as `Cooldown`, not become `Open / Extra`.
- Repeat tails with missing, count-mismatched, non-contiguous, or distance-missing HealthKit activity rows.
- Repeat tails where the final fixed planned row has no resolved end boundary.
- Residual movement that overlaps planned Work, Recovery, or Cooldown rows.
- Residual movement that is negative, zero, below threshold, or only a reconstruction artifact.
- Unpaired pause/resume events, cross-row pause overlap, or pause overlap that cannot be assigned to an exact row window.
- FIT lap/session residual conflicts with mapped HealthKit activity rows.
- Duplicate, no-plan, same-day extra, summary-only, or guard-unknown workouts.

## Decision

Unresolved ambiguous repeat-tail cases remain blocked from normal workout detail UI, but they now have a docs/debug rule:

1. Expand every WorkoutKit repeat block by actual iteration in execution order.
2. Map every expanded Work/Recovery row to one complete contiguous HealthKit activity row.
3. Preserve numbered Work and Recovery labels from expanded WorkoutKit order.
4. Resolve the final planned row before considering any residual tail.
5. Keep a final open cooldown labeled `Cooldown` through workout end.
6. Create `Open / Extra` only when the final planned row is fixed time or fixed distance, the fixed goal is exhausted, and measured residual movement starts after the final mapped planned activity row.
7. Treat FIT `workout_step` rows as unexpanded planned-structure validation evidence, not as expanded row count evidence.
8. Use FIT laps only as offline row-level validation against expanded planned rows and measured HealthKit activity rows.
9. Fallback when repeat expansion, activity mapping, fixed-step exhaustion, tail threshold, label order, or FIT/session residual evidence is ambiguous.

This rule preserves the already proven clean June 10 subclass:

`Warmup(2 km) > repeated Work/Recovery rows > fixed Cooldown > inferred Open / Extra tail`

It does not approve broader repeat-tail promotion.

## Evidence Summary

Relevant evidence:

| Evidence | Finding |
| --- | --- |
| `gate-b-row-level-fit-boundary-scorecard-2026-03-to-2026-06.md` | Structured intervals remain blocked broadly. Repeat-block rows can be close, but count alignment is not enough. |
| `gate-b-repeat-block-evidence-2026-03-to-2026-06.md` | FIT `workout_step` rows are unexpanded plan evidence; FIT laps and WorkoutKit planned rows are expanded. |
| `gate-b-open-tail-evidence-2026-03-to-2026-06.md` | Open/Extra tail evidence uses FIT session-minus-lap residuals when explicit FIT tail laps are absent. |
| `physical-iphone-repeat-block-proof-2026-06-14/README.md` | May 20 and June 3 prove clean repeat blocks with final open Cooldown and no Open/Extra tail. June 10 proves the approved clean no-pause fixed-cooldown repeat-block tail with final `Open / Extra`. |

Current controlled cases:

| Start | Shape | Current status |
| --- | --- | --- |
| `2026-05-20T11:43:00Z` | repeat block ending in `Cooldown(Open)` | approved narrow normal-detail gate; no Open/Extra tail |
| `2026-06-03T11:45:08Z` | repeat block ending in `Cooldown(Open)` | approved narrow normal-detail gate; no Open/Extra tail |
| `2026-06-10T11:27:51Z` | repeat block ending in fixed Cooldown plus residual movement | approved narrow normal-detail gate; final `Open / Extra` row |

The rule protects the distinction between those shapes: open cooldown absorbs the rest of the workout, while fixed cooldown can leave a tail only after the fixed planned row has a resolved end boundary.

## Separator Criteria

A future debug prototype may classify a repeat-block Open/Extra tail only when all of these are true:

- WorkoutKit planned rows are available.
- Repeat blocks are expanded by actual iteration count.
- Expanded planned rows map one-to-one to complete HealthKit activity rows before any tail is inferred.
- Activity rows are contiguous and ordered.
- Activity rows have distance evidence.
- Work and Recovery labels map from expanded plan order.
- The final planned row is fixed time or fixed distance.
- The final fixed planned row has a resolved end boundary.
- Residual movement starts after the final mapped planned row.
- Residual duration or distance is positive and above the small-tail threshold.
- A final open cooldown guard proves that open cooldown shapes stay labeled `Cooldown` through workout end.
- FIT lap rows, when available, match expanded rows within tolerance.
- FIT session-minus-lap residuals, when used, remain offline validation only and do not define runtime tail distance/time.

## Required Fallbacks

Keep the workout blocked or debug-only when any of these are true:

- missing WorkoutKit plan
- repeat block iteration count cannot be expanded
- expanded row count does not reconcile with HealthKit activity rows
- activity rows are missing, incomplete, non-contiguous, or missing distance evidence
- Work/Recovery label order is ambiguous
- final planned row is an open cooldown
- final fixed planned row has no resolved end boundary
- residual movement overlaps a planned Work, Recovery, or Cooldown row
- residual movement is negative, zero, below threshold, or only a reconstruction artifact
- FIT lap count or session residual conflicts with mapped HealthKit activity rows
- paused rows lack an approved timer rule or paired pause evidence
- duplicate, no-plan, same-day extra, summary-only, or guard-unknown status applies

Fallback reason examples:

- `repeat-expansion-unresolved`
- `repeat-tail-ambiguous`
- `final-row-open-cooldown`
- `final-fixed-row-unresolved`
- `tail-overlaps-planned-row`
- `tail-below-threshold`
- `fit-tail-residual-conflict`

## Current Status

Unresolved ambiguous repeat-tail cases move from `tail rule undefined` to `tail rule defined for docs/debug scoring`.

They remain blocked from normal workout detail UI until a later task explicitly approves a candidate gate or fallback hardening and proves repeat expansion, row mapping, labels, elapsed duration, active/timer duration when paused, distance, final fixed-row exhaustion, Open/Extra thresholding, open-cooldown guard behavior, and unsupported fallbacks.
