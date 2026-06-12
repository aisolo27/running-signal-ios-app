# HKWorkoutActivity Boundary Investigation

Status: docs/debug investigation. No production behavior changed.

Regenerated physical-device Raw HealthKit Debug markdown and parity packet JSON are archived for the active fixture set after adding debug-only `HKWorkout.workoutActivities` export fields.

## Executive Summary

`HKWorkoutActivity` is now the strongest public-API boundary lead in the current evidence set.

Across the active packet-backed fixtures, activity end offsets align with FIT lap or Apple Fitness/manual row timing within about half a second for the known planned-step boundaries. This includes the May 26, June 1, and June 12 drift cases where RunSignal's current distance-sample crossing boundary ends several seconds early.

This does not approve a production change. The activity rows expose public date windows and statistics, but the exported activity type is still generic (`HKWorkoutActivityType(rawValue: 37)`) and labels must be mapped from WorkoutKit planned-step order. The docs/debug scorer now shows the candidate improves drift cases, but June 4 regresses from preferred pass to temporary pass and June 3 has three special-fixture regressions.

## Fixture Read

| Date | Row(s) | Activity boundary read | Activity vs FIT/Apple | Read |
|---|---|---|---:|---|
| 2026-04-28 | Work boundary | 46:11.9 | -0.1s | Single activity ends at Work/FIT boundary; Open tail is inferred from workout end. |
| 2026-05-26 | Work boundary | 42:11.3 | +0.3s | Single activity ends at Work/FIT boundary; Open tail is inferred from workout end. |
| 2026-06-01 | Work boundary | 42:43.5 | -0.5s | Single activity ends at Work/FIT boundary; Open tail is inferred from workout end. |
| 2026-06-02 | Work boundary | 36:14.8 | -0.2s | Single activity ends at Work/FIT boundary; Open tail is inferred from workout end. |
| 2026-06-03 | 8 activity rows | 12:47.3 ... 38:56.7 | max 0.4s | Activity rows follow planned step order for the interval fixture. |
| 2026-06-04 | Work boundary | 36:35.6 | -0.4s | Single activity ends at Work/FIT boundary; Open tail is inferred from workout end. |
| 2026-06-05 | 3 activity rows | 12:30.1 ... 35:36.4 | max 0.5s | Activity rows follow planned Warmup, Work, and Cooldown order; final Open tail is inferred. |
| 2026-06-12 | Work boundary | 32:03.4 | +0.4s | Single activity ends at Work/FIT boundary; Open tail is inferred from workout end. |

## Interpretation

- `HKWorkoutActivity` explains the drift cases better than raw `HKWorkoutEvent` rows, rendered segment markers, crossing distance sample ends, or next distance sample ends.
- The simple Work plus Open fixtures usually export one activity ending at the planned Work/FIT boundary, not one activity spanning the whole workout.
- The structured June 3 interval fixture exports eight activities, matching the eight planned/Apple Fitness rows by order and timing.
- The June 5 tempo/threshold fixture exports three activities matching Warmup, Work, and Cooldown. The final Open tail is not a separate activity row, so it must be inferred from workout end if activity-based reconstruction is ever tested.
- The extra June 3 short run is archived separately under `_nonfixture-exports/2026-06-03-short-run/`; it has one activity and zero reconstructed WorkoutKit rows, so it should not be used for active fixture scoring.

## Production Boundary

Do not change production interval reconstruction from this note alone.

The next safe step is more guard-case collection and, if useful, a docs/debug-only activity-boundary prototype that:

- Uses `HKWorkoutActivity` boundaries only when activity count and order can be reconciled with the WorkoutKit planned steps.
- Infers a final Open / Extra tail only when workout end is later than the last mapped activity end.
- Falls back to the current reconstruction when activities are missing, unlabeled, out of order, or incompatible with plan shape.
- Scores the active fixtures and future guard examples before any normal UI or production boundary change.

## Scorer Result

`score_candidate_boundary_strategies.py` now writes `hkworkoutactivity-boundary-scorecard.md` and `hkworkoutactivity-boundary-scorecard.json`.

Current result:

- Drift cases May 26, June 1, and June 12 improve.
- June 2 improves and remains pass.
- June 4 remains within temporary tolerance, but it regresses from the current preferred pass on the Work row.
- June 3 is scoreable as an eight-row structured fixture, but three rows regress by status/error score.
- June 5 is scoreable, including inferred final Open, and improves all rows.
- April 28 is scoreable only as evidence-recovery/single-tail reference.
- The extra June 3 short run remains excluded as nonfixture evidence.

Production assessment: no production experiment is justified yet.
