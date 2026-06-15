# Recovery-Containing Open/Extra Tail Rule

Last updated: 2026-06-15

## Goal

Define the docs/debug separator rule for custom workouts that contain a planned `Recovery` row and later continue into an `Open / Extra` tail after fixed planned steps are exhausted.

This is docs/debug validation only. It does not approve Swift changes, normal workout detail interval promotion, broad `HKWorkoutActivity` promotion, FIT runtime usage, HealthFit dependency, file import, or interval-row analytics.

## Decision

Recovery-containing Open/Extra tails now have a docs/debug separator rule:

1. Expand WorkoutKit planned rows in execution order.
2. Preserve planned `Recovery` rows as Recovery. Do not relabel recovery distance or time as Open/Extra.
3. Map every fixed planned row to one complete contiguous HealthKit activity row.
4. Resolve each fixed row's boundary before considering a tail.
5. Create `Open / Extra` only after all fixed planned rows are exhausted.
6. The tail must start at the end of the final mapped planned activity row and end at the workout end.
7. The tail must have positive measured HealthKit duration or distance above the small-tail threshold.
8. FIT can validate session-minus-lap residuals offline, but runtime tail distance/time must come from HealthKit workout/activity totals and activity boundaries.

The rule is supported for docs/debug scoring by the May 1 evidence shape:

`Warmup(2 km) > Recovery(120 s) > Work(5 km) > Cooldown(2 km) > Open / Extra`

It does not approve normal workout detail UI. It only defines how a future debug prototype should separate planned Recovery from post-plan Open/Extra.

## Evidence Summary

May 1, 2026 is the key fixture:

| Field | Value |
| --- | --- |
| Start | `2026-05-01T12:07:44Z` |
| Apple Fitness rows | Warmup, Recovery, Work, Cooldown, Open |
| Planned steps | 4 |
| HealthKit activity rows | 4 |
| Debug candidate rows | 5 |
| Tail | `16.6 m / 9.9 s` |
| Paired pause overlap | `232.8 s` |
| Status | docs/debug separator supported; normal UI still blocked |

The activity-boundary candidate maps:

| Row | Planned/debug label | Evidence role |
| ---: | --- | --- |
| 1 | Warmup | fixed planned row |
| 2 | Recovery | fixed planned row; must not become Open/Extra |
| 3 | Work | fixed planned row |
| 4 | Cooldown | fixed planned row |
| 5 | Open / Extra | post-plan residual after fixed Cooldown |

The May 1 screenshots show Apple Fitness `Recovery 194 m / 2:00` and `Open 16 m / 0:10`. Fresh HealthKit activity-boundary evidence matches those rows within tolerance, and the FIT export independently confirms four planned step/lap rows plus pause-subtracted timer durations. FIT does not provide an explicit Open tail lap, so the tail remains validated by HealthKit activity-boundary evidence plus Apple Fitness screenshots, with FIT session-minus-lap residuals used only as offline sanity evidence.

## Separator Criteria

A future debug prototype may classify a recovery-containing Open/Extra tail only when all of these are true:

- WorkoutKit planned rows are available.
- Expanded planned rows include at least one `Recovery` row before the final fixed planned step.
- The final planned step is fixed time or fixed distance, not an open cooldown.
- Each fixed planned row maps one-to-one to a complete HealthKit activity row.
- Activity rows are contiguous and ordered.
- Activity rows have distance evidence.
- Planned Recovery rows map to Recovery labels from the expanded plan.
- Open/Extra starts only after the final mapped fixed planned row.
- Tail duration or distance is positive and above the small-tail threshold.
- Active/timer duration is used for paused planned rows when paired HealthKit pause events overlap row windows.
- FIT is used only for offline validation, not runtime reconstruction.
- At least one guard case proves an open cooldown remains `Cooldown` through workout end and does not become Open/Extra.

## Required Fallbacks

Keep the workout blocked or debug-only when any of these are true:

- missing WorkoutKit plan
- missing HealthKit activity rows
- activity row count mismatch before an approved tail rule is applied
- non-contiguous activity rows
- missing distance evidence
- Recovery row cannot be mapped from expanded WorkoutKit order
- final planned step is an open cooldown
- final fixed planned step does not have a resolved end boundary
- inferred tail is negative, zero, below threshold, or only a reconstruction artifact
- tail overlaps a planned Recovery row
- pause/resume evidence is unpaired or ambiguous for a paused planned row
- FIT session-minus-lap totals are internally ambiguous
- label mapping is ambiguous
- duplicate, no-plan, same-day extra, summary-only, or guard-unknown status applies

Fallback reason examples:

- `recovery-row-unmapped`
- `tail-overlaps-planned-recovery`
- `final-step-open-cooldown`
- `fixed-step-exhaustion-ambiguous`
- `tail-below-threshold`
- `tail-distance-ambiguous`

## Current Status

Recovery-containing Open/Extra tails move from `separator undefined` to `separator defined for docs/debug scoring`.

They remain blocked from normal workout detail UI until a later task explicitly approves debug-only prototype work and the prototype proves row count, labels, elapsed duration, active/timer duration, pause overlap, distance, Open/Extra separation, open-cooldown guard behavior, and unsupported fallbacks.
