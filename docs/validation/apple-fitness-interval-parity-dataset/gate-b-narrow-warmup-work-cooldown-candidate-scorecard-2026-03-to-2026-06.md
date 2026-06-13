# Gate B Narrow Warmup/Work/Open-Cooldown Candidate Scorecard: March-June 2026

Generated: 2026-06-13T13:33:41.060735Z

## Executive Summary

Only two warmup/work/open-cooldown workouts meet the narrow debug-candidate evidence checks. This supports a future discussion only; it does not approve Phase 3, production interval behavior, normal workout UI changes, or `HKWorkoutActivity` promotion.

FIT remains offline validation only. Runtime source remains HealthKit/WorkoutKit.

## Summary

| Metric | Value |
| --- | ---: |
| Exact shape rows | 4 |
| Supported rows | 2 |
| Excluded rows | 2 |

## Required Checks

- Warmup fixed 2 km, one Work step fixed time or fixed distance, final Cooldown open.
- Exactly 3 planned rows, 3 current rows, 3 activity candidate rows, 3 FIT laps, and 3 FIT workout_step rows.
- No recovery rows and no fixed-cooldown tail.
- Candidate labels map from expanded WorkoutKit order with zero mismatches.
- Candidate timing error <= 5 s and distance error <= 10 m for every row.
- Fallback first: missing evidence, ambiguous tail, repeat rows, or row-level drift excludes the workout.

## Rows

| Start | Shape | Rows current/candidate/FIT/plan/FIT step | Candidate max err | Tail class | Decision |
| --- | --- | --- | ---: | --- | --- |
| 2026-03-05T14:37:43Z | Warmup(2 km) > Work 1(900 s) > Cooldown(Open) | 3/3/3/3/3 | 0.0s / 7.5m | open_cooldown_absorbs_tail_residual | narrow_debug_candidate_supported |
| 2026-03-19T16:51:00Z | Warmup(2 km) > Work 1(1500 s) > Cooldown(Open) | 3/3/3/3/3 | 0.0s / 24.0m | no_tail_evidence | excluded_from_narrow_candidate |
| 2026-04-24T12:02:30Z | Warmup(2 km) > Work 1(4 km) > Cooldown(Open) | 3/3/3/3/3 | 0.0s / 6.7m | open_cooldown_absorbs_tail_residual | narrow_debug_candidate_supported |
| 2026-05-29T11:49:28Z | Warmup(2 km) > Work 1(3 km) > Cooldown(Open) | 3/3/3/3/3 | 158.9s / 6.6m | open_cooldown_absorbs_tail_residual | excluded_from_narrow_candidate |

## No-Production-Change Statement

This scorecard is docs/debug validation only. It identifies a future narrow discussion candidate and does not implement or approve Phase 3.
