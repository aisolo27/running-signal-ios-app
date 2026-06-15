# Simple Work/Open Prototype Decision

Last updated: 2026-06-15

## Goal

Define the narrow Gate A prototype boundary for simple fixed-distance `Work + Open` workouts.

This is docs/debug validation only. It does not approve Swift changes, normal workout detail interval promotion, broad `HKWorkoutActivity` promotion, FIT runtime usage, HealthFit dependency, file import, or interval-row analytics.

## Decision

Gate A is approved for a future narrow debug-only prototype discussion, not production UI promotion.

The prototype shape is:

`one fixed-distance Work step > real Open tail`

The prototype may use public `HKWorkoutActivity` rows as the candidate runtime boundary source only when every eligibility rule below passes. FIT remains offline validation only.

## Evidence Summary

`fit-backed-two-gate-validation-plan-2026-03-to-2026-06.md` found:

| Metric | Value |
| --- | ---: |
| Simple fixed-distance Work/Open candidates | 50 |
| FIT supports `HKWorkoutActivity` candidate | 50 |
| FIT supports current reconstruction | 0 |
| Large-shift candidates | 10 |
| Large-shift FIT supports candidate | 10 |
| FIT-inconclusive simple cases | 0 |

That supports a narrow prototype.

`hkworkoutactivity-boundary-scorecard.md` adds an important caution: `hkworkoutactivity_boundary` improves drift fixtures and mostly preserves guards, but June 4 drops from current preferred pass to temporary pass and structured/special workouts regress when treated too broadly. Therefore the prototype must be debug-only, feature-flagged, and strictly limited to Gate A.

## Eligibility Rules

A workout is eligible for the simple Work/Open debug prototype only when all of these are true:

- WorkoutKit plan is available.
- Expanded planned step count is exactly `1`.
- The only planned step is `Work`.
- The planned Work goal is fixed distance.
- The workout has exactly one complete HealthKit activity row for the planned Work step.
- A positive residual remains after the mapped Work activity row.
- Candidate rows are exactly `Work` and `Open / Extra`.
- No Warmup, Recovery, Cooldown, repeat block, structured interval, or special-workout rows are present.
- The workout is not duplicate, same-day extra, no-plan, summary-only, drift/guard-unknown, or otherwise excluded from scoring.
- The activity row has distance evidence.
- The tail has duration or distance above the small-tail threshold.
- FIT offline evidence supports the activity-boundary candidate when a matched FIT file exists.
- Current reconstruction is not better than the activity-boundary candidate in the relevant offline score.

## Required Fallbacks

Fallback to current behavior when any of these are true:

- missing WorkoutKit plan
- planned step count is not exactly `1`
- planned step is not `Work`
- Work goal is not fixed distance
- missing HealthKit activity rows
- activity row count is not exactly `1`
- activity row is incomplete, non-contiguous, or missing distance evidence
- residual tail is zero, negative, below threshold, or ambiguous
- candidate would produce anything other than `Work` plus `Open / Extra`
- workout contains Warmup, Recovery, Cooldown, repeat blocks, or structured interval rows
- workout is duplicate, no-plan, same-day extra, summary-only, or guard-unknown
- FIT/offline scoring is missing or contradicts the candidate
- current reconstruction scores better than the candidate

Fallback reason examples:

- `gate-a-plan-not-single-work`
- `gate-a-work-goal-not-fixed-distance`
- `gate-a-activity-count-mismatch`
- `gate-a-tail-below-threshold`
- `gate-a-unsupported-structure`
- `gate-a-fit-not-supportive`
- `gate-a-current-better`

## Prototype Acceptance Criteria

A future debug-only Swift prototype may be implemented only when all of these are true:

- The task explicitly approves debug-only Swift work.
- The prototype is confined to Raw HealthKit Debug / Parity Lab or a feature flag.
- Existing normal workout detail intervals remain unchanged.
- Debug output shows candidate rows beside current rows.
- Debug output includes row count, planned step count, activity count, row labels, elapsed duration, distance, tail threshold status, and fallback reason.
- FIT values are not read at runtime.
- Plain open Watch runs remain plain open runs.
- Stopped-early single Work remains governed by its separate partial-Work rule.
- Structured intervals, warmup/work/cooldown, repeat blocks, paused workouts, recovery-containing tails, and ambiguous repeat tails all continue to fall back unless their own gate explicitly supports them.

## Current Status

Simple fixed-distance Work/Open moves from `validated but parked` to `debug prototype boundary defined`.

It remains blocked from normal workout detail UI until a later debug prototype exists, is validated, and a separate production UI promotion decision is made.
