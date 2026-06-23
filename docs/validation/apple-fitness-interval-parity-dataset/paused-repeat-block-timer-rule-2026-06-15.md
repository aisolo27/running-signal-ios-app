# Paused Repeat-Block Timer Rule

Last updated: 2026-06-15

## Goal

Define the paused repeat-block timer rule required by `Custom Workout Correctness Lock v1` before any debug prototype or normal-detail promotion.

This is docs/debug validation only. It does not approve Swift changes, normal workout detail interval promotion, `HKWorkoutActivity` broad promotion, FIT runtime usage, HealthFit dependency, file import, or interval-row analytics.

## Decision

The narrow open-cooldown paused-repeat shape is now promoted into normal workout detail after separate interval-timing and physical proof. Broader paused-repeat tails remain blocked, but this docs/debug timer rule remains the reference for scorer/prototype work:

1. Use expanded WorkoutKit planned rows for row order and labels.
2. Use complete contiguous HealthKit activity rows as elapsed wall-clock row windows.
3. Preserve both row elapsed duration and row active/timer duration.
4. Compute row active/timer duration as:

   `row active duration = row elapsed duration - paired pause overlap inside that row window`

5. Compare paused time-goal rows against active/timer duration, not elapsed duration alone.
6. Keep elapsed duration visible because FIT elapsed rows and HealthKit activity windows include pauses.
7. Keep FIT offline-only: FIT can validate elapsed/timer agreement, but runtime code must derive pause overlap from HealthKit event evidence.

This rule explains the known paused repeat-block evidence, but it is not enough by itself to approve production UI. Repeat mapping, labels, distance, contiguity, and unsupported guard behavior must also pass.

## Evidence Summary

`gate-b-timer-drift-evidence-2026-03-to-2026-06.md` reviewed seven timer-drift outliers. In each case:

- candidate row duration matched FIT elapsed duration
- candidate row duration did not match FIT timer duration
- the difference between elapsed and timer duration matched paired HealthKit pause overlap
- the row still stayed excluded because repeat-block or shape-specific rules were not approved

The paused repeat-block rows were:

| Start | Shape summary | Max drift row | FIT elapsed/timer | Pause overlap | Decision |
| --- | --- | --- | ---: | ---: | --- |
| `2026-03-10T13:49:08Z` | Warmup, five Work rows, five Recovery rows, Cooldown(Open) | Recovery 4 | `270.5s / 119.2s` | `151.2s` | timer rule supported; repeat rule still required |
| `2026-04-22T11:39:58Z` | Warmup, five 800 m Work rows, five 120 s Recovery rows, Cooldown(Open) | Recovery 3 | `219.7s / 119.9s` | `99.7s` | timer rule supported; repeat rule still required |
| `2026-04-29T11:49:02Z` | Warmup, five 800 m Work rows, five 120 s Recovery rows, Cooldown(Open) | Recovery 4 | `229.1s / 119.0s` | `110.0s` | timer rule supported; repeat rule still required |
| `2026-05-06T12:02:13Z` | Warmup, mixed 1 km/800 m/600 m repeat rows, Cooldown(Open) | Warmup | `900.9s / 774.5s` | `126.4s` | timer rule supported; repeat rule still required |
| `2026-05-13T11:52:06Z` | Warmup, eight 400 m Work rows, eight 120 s Recovery rows, Cooldown(Open) | Recovery 7 | `172.0s / 119.4s` | `52.6s` | timer rule supported; repeat rule still required |
| `2026-05-27T11:45:47Z` | Warmup, ten 400 m Work rows, ten 90 s Recovery rows, Cooldown(Open) | Recovery 8 | `150.0s / 89.2s` | `60.8s` | timer rule supported; repeat rule still required |

`custom-workout-candidate-reconstruction-rule-scorecard-2026-03-to-2026-06.md` then scored screenshot-confirmed fixtures and found the active/timer duration rule matched the paused repeat-block fixtures within tolerance while preserving elapsed duration separately.

## Acceptance Criteria For A Future Debug Prototype

A paused repeat-block debug prototype can be discussed only when all of these are true:

- The task explicitly approves debug-only Swift/prototype work.
- Expanded WorkoutKit rows and HealthKit activity rows have the same count after any approved tail rule.
- Activity rows are complete and contiguous.
- Each mapped activity row has distance evidence.
- Work and Recovery labels map from expanded WorkoutKit planned rows in execution order.
- Paired HealthKit pause/resume events are available.
- Every pause overlap used in a row is assigned from paired events, not inferred from FIT.
- Row elapsed duration remains visible in debug output.
- Row active/timer duration remains visible in debug output.
- Row active/timer duration matches the planned time goal, FIT timer duration, or Apple Fitness screenshot row duration within the working tolerance when those references exist.
- Row elapsed duration matches FIT elapsed duration within tolerance when FIT evidence exists.
- Distance error stays within tolerance.
- Unsupported guard cases still produce stable fallback reasons.

## Required Fallbacks

Keep the workout blocked or debug-only when any of these are true:

- missing WorkoutKit plan
- missing HealthKit activity rows
- activity row count mismatch without an approved tail rule
- non-contiguous activity rows
- missing row distance statistics
- unpaired or incomplete pause/resume events
- pause overlap cannot be assigned to a specific row window
- row active/timer duration is outside tolerance
- row elapsed duration is outside tolerance when FIT elapsed evidence exists
- label mapping is ambiguous
- distance error is outside tolerance
- Open/Extra tail behavior is present but not covered by an approved tail rule
- recovery-containing tail behavior is present
- ambiguous repeat-tail behavior is present
- duplicate, no-plan, same-day extra, summary-only, or guard-unknown status applies

Fallback must preserve current production behavior and include an explicit reason such as `pause-events-unpaired`, `pause-overlap-ambiguous`, `active-duration-out-of-tolerance`, or `repeat-block-rule-not-approved`.

## Implementation Notes For Later

The future implementation should not derive row active duration from FIT. Runtime calculation should use HealthKit workout events:

1. Pair pause and resume markers in chronological order.
2. Ignore incomplete pause intervals and mark the row unsupported.
3. Intersect each paired pause interval with each activity row window.
4. Sum the overlap inside the row.
5. Subtract the overlap from elapsed row duration.
6. Report both elapsed and active/timer duration in Parity Lab.

Do not collapse the two durations into one field. The evidence depends on keeping both visible.

## Current Status

Paused repeat blocks move from `timer rule undefined` to `timer rule defined for docs/debug scoring`.

The exact open-cooldown paused-repeat shape is no longer blocked from normal workout detail UI. True Open/Extra paused-repeat tails, ambiguous paused tails, unpaired pauses, missing rows, non-contiguous rows, and cross-row pause overlaps remain blocked until a later task explicitly proves row count, labels, elapsed duration, active/timer duration, pause overlap, distance, tail behavior, and guard fallbacks for a narrower shape.
