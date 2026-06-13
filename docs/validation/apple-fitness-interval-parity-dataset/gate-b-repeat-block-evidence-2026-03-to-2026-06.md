# Gate B Repeat-Block Evidence: March-June 2026

Generated: 2026-06-13T13:33:41.060455Z

## Executive Summary

Repeat-block workouts remain blocked. FIT `workout_step` rows are unexpanded planned-structure evidence, while FIT laps and WorkoutKit planned rows are expanded. Several rows are close, but count alignment and low errors are not enough without an explicit repeat mapping rule.

FIT remains offline validation only. No production interval behavior, normal workout UI, or runtime data source changed.

## Summary

| Metric | Value |
| --- | ---: |
| Repeat-block rows | 17 |
| Candidate within row tolerance | 9 |
| Candidate distance closer but time worse | 6 |

## Rule Needed

- Use expanded WorkoutKit planned rows as label/order source.
- Treat FIT workout_step rows as unexpanded planned-structure evidence.
- Compare FIT laps against expanded planned rows.
- Require row-level timing, distance, and label tolerance before support.
- Fallback on missing activities, count mismatch, non-contiguity, tail ambiguity, or high row error.

## Rows

| Start | Rows current/candidate/FIT/plan/FIT step | Candidate ok | Current ok | Candidate worse time | Current max err | Candidate max err | Decision |
| --- | --- | ---: | ---: | ---: | ---: | ---: | --- |
| 2026-03-03T13:39:37Z | 18/18/18/18/5 | False | False | False | 7.5s / 10.5m | 0.0s / 15.3m | excluded_until_timing_or_distance_drift_explained |
| 2026-03-10T13:49:08Z | 13/13/13/13/6 | False | False | True | 141.9s / 21.8m | 151.3s / 7.3m | excluded_until_timing_or_distance_drift_explained |
| 2026-03-12T13:41:02Z | 8/8/8/8/5 | True | True | False | 3.5s / 5.4m | 0.0s / 7.6m | close_but_repeat_rule_required |
| 2026-03-17T12:29:37Z | 18/18/18/18/5 | True | False | False | 5.3s / 15.3m | 0.0s / 9.4m | close_but_repeat_rule_required |
| 2026-03-25T14:47:56Z | 14/14/14/14/5 | False | True | False | 3.8s / 9.6m | 0.0s / 13.0m | excluded_until_timing_or_distance_drift_explained |
| 2026-03-27T12:59:26Z | 8/8/8/8/5 | True | True | False | 3.5s / 5.2m | 0.0s / 9.0m | close_but_repeat_rule_required |
| 2026-03-31T15:26:28Z | 10/10/10/10/5 | True | True | False | 1.5s / 6.4m | 0.0s / 8.0m | close_but_repeat_rule_required |
| 2026-04-22T11:39:58Z | 12/12/12/12/5 | False | False | True | 88.1s / 47.0m | 99.8s / 8.1m | excluded_until_timing_or_distance_drift_explained |
| 2026-04-29T11:49:02Z | 12/12/12/12/5 | False | False | True | 108.4s / 63.0m | 110.1s / 7.6m | excluded_until_timing_or_distance_drift_explained |
| 2026-05-06T12:02:13Z | 14/14/14/14/11 | False | False | True | 122.5s / 9.1m | 126.4s / 8.1m | excluded_until_timing_or_distance_drift_explained |
| 2026-05-08T11:55:07Z | 6/6/6/6/5 | True | True | False | 3.6s / 7.3m | 0.0s / 7.4m | close_but_repeat_rule_required |
| 2026-05-13T11:52:06Z | 18/18/18/18/5 | False | False | True | 35.6s / 66.4m | 52.6s / 11.2m | excluded_until_timing_or_distance_drift_explained |
| 2026-05-15T12:00:12Z | 8/8/8/8/5 | True | False | False | 5.5s / 8.1m | 0.0s / 9.8m | close_but_repeat_rule_required |
| 2026-05-20T11:43:00Z | 10/10/10/10/5 | True | True | False | 4.3s / 8.2m | 0.0s / 8.7m | close_but_repeat_rule_required |
| 2026-05-22T11:55:11Z | 6/6/6/6/5 | True | True | False | 3.6s / 6.1m | 0.0s / 7.2m | close_but_repeat_rule_required |
| 2026-05-27T11:45:47Z | 22/22/22/22/5 | False | False | True | 55.2s / 22.4m | 60.8s / 11.4m | excluded_until_timing_or_distance_drift_explained |
| 2026-06-03T11:45:08Z | 8/8/8/8/5 | True | True | False | 4.9s / 8.6m | 0.0s / 8.6m | close_but_repeat_rule_required |

## No-Production-Change Statement

This scorecard is docs/debug validation only. It does not approve repeat-block production reconstruction or `HKWorkoutActivity` promotion.
