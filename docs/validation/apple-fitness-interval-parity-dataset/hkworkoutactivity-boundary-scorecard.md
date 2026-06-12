# HKWorkoutActivity Boundary Scorecard

Generated: 2026-06-12

## Executive Summary

`hkworkoutactivity_boundary` improves the May 26, June 1, and June 12 drift fixtures. It preserves/improves June 2, but June 4 drops from the current preferred pass to a temporary pass on the Work row, so guard preservation is not fully proven. It handles the structured June 3 interval fixture by planned-step order but regresses three rows by status/error score, and it handles the June 5 Warmup/Work/Cooldown rows plus inferred final Open tail. April 28 is included only as an evidence-recovery/single-tail reference. The extra June 3 short run is excluded from production approval scoring.

Production behavior remains unchanged. This scorecard is docs/debug-only and does not use FIT or Apple Fitness/manual rows as runtime logic.

Implementation follow-up: Raw HealthKit Debug and parity packet exports now include the same candidate as diagnostics/export-only fields: `activityBoundaryCandidateSummary` and `activityBoundaryCandidateIntervals`. These fields sit beside current `reconstructedIntervals`, report mapping status and count/order reconciliation, include direct activity rows and inferred final Open / Extra tails, and repeat that the rows are not production UI.

## Activity-Boundary Strategy Definition

- Strategy id: `hkworkoutactivity_boundary`.
- Map `HKWorkout.workoutActivities` rows to `WorkoutKit` planned step order only when activity count and fixture row order reconcile with the planned steps.
- For mapped planned rows, score the public activity duration and `DistanceWalkingRunning` statistic.
- For a final Open / Extra tail, infer distance and time from workout total minus the mapped planned activities and final activity end.
- Missing activities, count mismatch, out-of-order windows, incompatible labels, or negative inferred tails are marked not scoreable; no silent fallback is used for this score.
- FIT rows and Apple Fitness/manual rows are comparison references only, never runtime inputs.

## Summary Table By Fixture

| Date       | Class             | Scoreable | Pass | Temp | Fail | Improved | Preserved | Regressed | Read      |
| ---------- | ----------------- | --------- | ---- | ---- | ---- | -------- | --------- | --------- | --------- |
| 2026-04-28 | evidence recovery | 2/2       | 1    | 1    | 0    | 2        | 0         | 0         | scoreable |
| 2026-05-26 | drift             | 2/2       | 1    | 1    | 0    | 2        | 0         | 0         | scoreable |
| 2026-06-01 | drift             | 2/2       | 1    | 1    | 0    | 2        | 0         | 0         | scoreable |
| 2026-06-02 | guard             | 2/2       | 2    | 0    | 0    | 2        | 0         | 0         | scoreable |
| 2026-06-03 | special           | 8/8       | 5    | 3    | 0    | 5        | 0         | 3         | scoreable |
| 2026-06-04 | guard             | 2/2       | 1    | 1    | 0    | 1        | 0         | 1         | scoreable |
| 2026-06-05 | special           | 4/4       | 3    | 1    | 0    | 4        | 0         | 0         | scoreable |
| 2026-06-12 | drift             | 2/2       | 1    | 1    | 0    | 2        | 0         | 0         | scoreable |

## Drift-Case Results

| Date       | Row  | Class | Current RunSignal | Activity candidate | Apple/manual     | FIT/debug                         | Delta vs Apple | Delta vs FIT  | Change vs current | Status         | Scoreability                                     | Effect   |
| ---------- | ---- | ----- | ----------------- | ------------------ | ---------------- | --------------------------------- | -------------- | ------------- | ----------------- | -------------- | ------------------------------------------------ | -------- |
| 2026-05-26 | Work | drift | 6.454 km / 42:07  | 6.457 km / 42:11   | 6.450 km / 42:11 | 6.457 km / 42:11 (FIT lap)        | +7.4m / +0.3s  | +0.4m / +0.3s | +3.2m / +3.8s     | temporary pass | activity count/order reconciled to planned steps | improves |
| 2026-05-26 | Open | drift | 97.2 m / 0:45     | 94.0 m / 0:41      | 94.0 m / 0:41    | 94.0 m / 0:41 (FIT inferred tail) | +0.0m / +0.4s  | +0.0m / +0.4s | -3.2m / -3.8s     | pass           | activity count/order reconciled to planned steps | improves |
| 2026-06-01 | Work | drift | 6.451 km / 42:38  | 6.458 km / 42:44   | 6.450 km / 42:44 | 6.458 km / 42:44 (FIT lap)        | +7.8m / -0.5s  | -0.2m / -0.5s | +7.2m / +5.2s     | temporary pass | activity count/order reconciled to planned steps | improves |
| 2026-06-01 | Open | drift | 12.3 m / 0:13     | 5.1 m / 0:07       | 5.0 m / 0:07     | 5.1 m / 0:07 (FIT inferred tail)  | +0.1m / +0.4s  | +0.0m / +0.4s | -7.2m / -5.2s     | pass           | activity count/order reconciled to planned steps | improves |
| 2026-06-12 | Work | drift | 5.002 km / 31:59  | 5.008 km / 32:03   | 5.000 km / 32:03 | 5.008 km / 32:03 (FIT lap)        | +7.9m / +0.4s  | -0.1m / +0.4s | +6.4m / +4.8s     | temporary pass | activity count/order reconciled to planned steps | improves |
| 2026-06-12 | Open | drift | 43.2 m / 0:22     | 36.9 m / 0:17      | 36.0 m / 0:17    | 36.9 m / 0:17 (FIT inferred tail) | +0.9m / +0.4s  | +0.0m / +0.4s | -6.4m / -4.8s     | pass           | activity count/order reconciled to planned steps | improves |

## Guard-Case Results

| Date       | Row  | Class | Current RunSignal | Activity candidate | Apple/manual     | FIT/debug                         | Delta vs Apple | Delta vs FIT  | Change vs current | Status         | Scoreability                                     | Effect    |
| ---------- | ---- | ----- | ----------------- | ------------------ | ---------------- | --------------------------------- | -------------- | ------------- | ----------------- | -------------- | ------------------------------------------------ | --------- |
| 2026-06-02 | Work | guard | 5.652 km / 36:13  | 5.651 km / 36:15   | 5.650 km / 36:15 | 5.651 km / 36:15 (FIT lap)        | +1.2m / -0.2s  | +0.2m / -0.2s | -0.7m / +2.2s     | pass           | activity count/order reconciled to planned steps | improves  |
| 2026-06-02 | Open | guard | 57.0 m / 0:30     | 57.7 m / 0:28      | 57.0 m / 0:28    | 57.7 m / 0:28 (FIT inferred tail) | +0.7m / -0.2s  | +0.0m / -0.2s | +0.7m / -2.2s     | pass           | activity count/order reconciled to planned steps | improves  |
| 2026-06-04 | Work | guard | 5.653 km / 36:34  | 5.657 km / 36:36   | 5.650 km / 36:36 | 5.657 km / 36:36 (FIT lap)        | +7.2m / -0.4s  | +0.2m / -0.4s | +4.3m / +1.3s     | temporary pass | activity count/order reconciled to planned steps | regresses |
| 2026-06-04 | Open | guard | 42.0 m / 0:22     | 44.8 m / 0:21      | 44.0 m / 0:21    | 44.8 m / 0:21 (FIT inferred tail) | +0.8m / -0.1s  | +0.0m / -0.1s | +2.8m / -1.3s     | pass           | activity count/order reconciled to planned steps | improves  |

## Special Fixture Results

June 3 is scored as an eight-row structured workout, not as a simple Work + Open case. June 5 maps three activity rows to Warmup, Work, and Cooldown, then infers final Open from workout end.

| Date       | Row      | Class   | Current RunSignal | Activity candidate | Apple/manual     | FIT/debug                          | Delta vs Apple | Delta vs FIT   | Change vs current | Status         | Scoreability                                     | Effect    |
| ---------- | -------- | ------- | ----------------- | ------------------ | ---------------- | ---------------------------------- | -------------- | -------------- | ----------------- | -------------- | ------------------------------------------------ | --------- |
| 2026-06-03 | Warmup   | special | 2.001 km / 12:42  | 2.009 km / 12:47   | 2.000 km / 12:47 | 2.000 km / 12:47 (FIT lap)         | +8.6m / +0.3s  | +8.6m / +0.3s  | +7.1m / +4.9s     | temporary pass | activity count/order reconciled to planned steps | regresses |
| 2026-06-03 | Work     | special | 1.002 km / 4:12   | 1.005 km / 4:12    | 1.000 km / 4:12  | 1.000 km / 4:12 (FIT lap)          | +5.1m / -0.2s  | +5.1m / -0.2s  | +3.2m / -0.3s     | temporary pass | activity count/order reconciled to planned steps | regresses |
| 2026-06-03 | Recovery | special | 218.1 m / 2:30    | 209.5 m / 2:29     | 209.0 m / 2:30   | 210.0 m / 2:29 (FIT lap)           | +0.5m / -1.0s  | -0.5m / +0.0s  | -8.5m / -1.0s     | pass           | activity count/order reconciled to planned steps | improves  |
| 2026-06-03 | Work     | special | 1.002 km / 4:06   | 1.005 km / 4:06    | 1.000 km / 4:06  | 1.000 km / 4:06 (FIT lap)          | +5.2m / +0.2s  | +5.2m / +0.2s  | +3.6m / +0.0s     | temporary pass | activity count/order reconciled to planned steps | regresses |
| 2026-06-03 | Recovery | special | 210.2 m / 2:30    | 207.3 m / 2:30     | 207.0 m / 2:30   | 207.0 m / 2:30 (FIT lap)           | +0.3m / -0.1s  | +0.3m / -0.1s  | -2.8m / -0.1s     | pass           | activity count/order reconciled to planned steps | improves  |
| 2026-06-03 | Work     | special | 1.004 km / 4:01   | 1.004 km / 4:00    | 1.000 km / 4:00  | 1.000 km / 4:00 (FIT lap)          | +3.9m / +0.5s  | +3.9m / +0.5s  | -0.1m / -0.5s     | pass           | activity count/order reconciled to planned steps | improves  |
| 2026-06-03 | Recovery | special | 199.1 m / 2:30    | 197.1 m / 2:30     | 197.0 m / 2:30   | 197.0 m / 2:30 (FIT lap)           | +0.1m / -0.2s  | +0.1m / -0.2s  | -2.0m / -0.2s     | pass           | activity count/order reconciled to planned steps | improves  |
| 2026-06-03 | Cooldown | special | 1.032 km / 6:25   | 1.031 km / 6:22    | 1.030 km / 6:22  | 1.031 km / 6:22 (FIT lap)          | +1.2m / +0.1s  | +0.2m / +0.1s  | -0.5m / -2.9s     | pass           | activity count/order reconciled to planned steps | improves  |
| 2026-06-05 | Warmup   | special | 2.006 km / 12:27  | 2.007 km / 12:30   | 2.000 km / 12:30 | 2.000 km / 12:30 (FIT lap)         | +6.6m / +0.1s  | +6.6m / +0.1s  | +1.0m / +3.5s     | temporary pass | activity count/order reconciled to planned steps | improves  |
| 2026-06-05 | Work     | special | 2.009 km / 8:32   | 2.005 km / 8:30    | 2.000 km / 8:30  | 2.000 km / 8:30 (FIT lap)          | +5.1m / +0.5s  | +5.1m / +0.5s  | -3.4m / -1.5s     | pass           | activity count/order reconciled to planned steps | improves  |
| 2026-06-05 | Cooldown | special | 2.508 km / 14:40  | 2.497 km / 14:36   | 2.490 km / 14:36 | 2.497 km / 14:36 (FIT lap)         | +6.6m / -0.1s  | -0.4m / -0.1s  | -11.1m / -3.9s    | pass           | activity count/order reconciled to planned steps | improves  |
| 2026-06-05 | Open     | special | 440.0 m / 2:38    | 453.5 m / 2:40     | 453.0 m / 2:40   | 465.2 m / 2:40 (FIT inferred tail) | +0.5m / -0.3s  | -11.7m / -0.3s | +13.5m / +2.0s    | pass           | activity count/order reconciled to planned steps | improves  |

## April 28 Evidence-Recovery Note

April 28 is excluded from production approval scoring. It remains useful as a recovered-evidence, single-tail reference showing one activity mapped to Work and an inferred final Open tail.

| Date       | Row  | Class             | Current RunSignal | Activity candidate | Apple/manual     | FIT/debug                         | Delta vs Apple | Delta vs FIT  | Change vs current | Status         | Scoreability                                     | Effect   |
| ---------- | ---- | ----------------- | ----------------- | ------------------ | ---------------- | --------------------------------- | -------------- | ------------- | ----------------- | -------------- | ------------------------------------------------ | -------- |
| 2026-04-28 | Work | evidence recovery | 7.256 km / 46:09  | 7.258 km / 46:12   | 7.250 km / 46:12 | 7.258 km / 46:12 (FIT lap)        | +7.8m / -0.1s  | -0.2m / -0.1s | +1.5m / +3.1s     | temporary pass | activity count/order reconciled to planned steps | improves |
| 2026-04-28 | Open | evidence recovery | 48.3 m / 0:23     | 46.8 m / 0:20      | 46.0 m / 0:20    | 46.8 m / 0:20 (FIT inferred tail) | +0.8m / -0.1s  | +0.0m / -0.1s | -1.5m / -3.1s     | pass           | activity count/order reconciled to planned steps | improves |

## Nonfixture June 3 Short-Run Note

`_nonfixture-exports/2026-06-03-short-run/` remains excluded. It is a second June 3 short run with no active fixture rows or production approval role, so this scorer does not include it in the scorecard.

## Comparison Against Existing Scorecard Strategies

The existing scorecard still blocks previous candidates: `next_sample_end` improves drift rows but regresses guard rows, `tail_shrink_to_expected_open` uses manual Apple Fitness expected Open as an oracle, and pause-adjusted scoring is unavailable from the packets. `hkworkoutactivity_boundary` is the strongest public-API lead because it uses public `HKWorkoutActivity` windows and does not require FIT or Apple Fitness/manual values at runtime.

| Strategy                       | Scoreable | Pass | Temp | Fail | Drift improved | Guard regressed | Special regressed | Production assessment                                                                       |
| ------------------------------ | --------- | ---- | ---- | ---- | -------------- | --------------- | ----------------- | ------------------------------------------------------------------------------------------- |
| current_baseline               | 24        | 8    | 10   | 6    | 0              | 0               | 0                 | not production-safe from this scorecard                                                     |
| hkworkoutactivity_boundary     | 24        | 15   | 9    | 0    | 6              | 1               | 3                 | debug-only lead; not production-safe until more guard data and fallback rules are validated |
| interpolated_crossing          | 20        | 6    | 4    | 10   | 3              | 3               | 2                 | not production-safe from this scorecard                                                     |
| previous_sample_end            | 20        | 3    | 5    | 12   | 0              | 4               | 5                 | not production-safe from this scorecard                                                     |
| next_sample_end                | 20        | 3    | 11   | 6    | 6              | 3               | 8                 | not production-safe from this scorecard                                                     |
| final_distance_sample_anchored | 14        | 1    | 1    | 12   | 2              | 4               | 2                 | not production-safe from this scorecard                                                     |
| tail_shrink_to_expected_open   | 14        | 10   | 4    | 0    | 6              | 0               | 0                 | not production-safe because it uses Apple Fitness/manual expected Open as an oracle         |
| pause_adjusted                 | 0         | 0    | 0    | 0    | 0              | 0               | 0                 | not scoreable from current packet data                                                      |

## Production Assessment

Production experiment justified: no. The candidate improved drift fixtures (improved; statuses: pass, temporary pass; improved; statuses: pass, temporary pass; improved; statuses: pass, temporary pass) and preserved/improved June 2, but June 4 regressed from current pass to temporary pass (regressed; statuses: pass, temporary pass). June 3 also has three status/error-score regressions. The safest next step is a debug-only prototype or more guard collection, not production boundary replacement.

Scorecard assessment for `hkworkoutactivity_boundary`: debug-only lead; not production-safe until more guard data and fallback rules are validated.

Export prototype assessment: useful for future physical-device evidence review only. It does not change current reconstruction, fixed-distance boundary logic, normal workout UI, or production approval status.

## Explicit Risks And Rollback Notes

- Activity labels are generic and must be mapped from WorkoutKit planned-step order; ambiguous mapping remains a production blocker.
- Current guard coverage is only June 2 and June 4 for simple fixed-distance Work + Open tails; collect more pass/guard examples before any production experiment.
- Activity statistics may not be available for every workout or OS/export path; missing or count-mismatched activities must fall back to current app behavior in any future prototype.
- FIT and Apple Fitness/manual values stay docs/debug comparison references only.
- Rollback: remove this scoring branch/report generation; production app behavior is unaffected because no Swift or reconstruction logic changed.

