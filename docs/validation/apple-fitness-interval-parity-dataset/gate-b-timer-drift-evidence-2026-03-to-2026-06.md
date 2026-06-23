# Gate B Timer Drift Evidence: March-June 2026

Generated: 2026-06-23T21:07:11.556083Z

## Executive Summary

The known timer-drift outliers should stay excluded from any narrow Phase 3 candidate. In each primary outlier, the largest candidate timing error is explained by FIT elapsed duration diverging from FIT timer duration. Existing HealthKit debug packets also expose pause/resume markers whose paired pause interval overlaps match the elapsed-minus-timer deltas.

This is docs/debug validation only. FIT remains an offline validation oracle. Runtime source remains HealthKit/WorkoutKit. No production interval behavior, normal workout UI, `HKWorkoutActivity` promotion, or runtime FIT usage changed.

## Summary

| Metric | Value |
| --- | ---: |
| Outliers reviewed | 7 |
| Excluded from narrow Phase 3 candidate | 7 |
| Material timer policy | pause-explained drift is not a material boundary error |

## Classification Counts

| Classification | Count |
| --- | ---: |
| likely_timer_time_drift | 7 |

## Material Timer Status Counts

| Material timer status | Count |
| --- | ---: |
| pause_explained_not_material_boundary_error | 7 |

## Outlier Rows

| Start | Gate B decision | Max drift row | FIT elapsed/timer | Candidate - elapsed | Candidate - timer | Pause overlap | Pause markers | Decision | Material timer status |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | --- | --- |
| 2026-05-29T11:49:28Z | row_level_inconclusive | 3 Cooldown | 1118.9s / 960.0s | 0.0s | 158.9s | 159.0s | 3 | likely_timer_time_drift | pause_explained_not_material_boundary_error |
| 2026-03-10T13:49:08Z | repeat_block_needs_rule | 10 Recovery 4 | 270.5s / 119.2s | 0.0s | 151.3s | 151.2s | 3 | likely_timer_time_drift | pause_explained_not_material_boundary_error |
| 2026-04-22T11:39:58Z | repeat_block_needs_rule | 7 Recovery 3 | 219.7s / 119.9s | 0.0s | 99.8s | 99.7s | 5 | likely_timer_time_drift | pause_explained_not_material_boundary_error |
| 2026-04-29T11:49:02Z | repeat_block_needs_rule | 9 Recovery 4 | 229.1s / 119.0s | 0.0s | 110.1s | 110.0s | 5 | likely_timer_time_drift | pause_explained_not_material_boundary_error |
| 2026-05-06T12:02:13Z | repeat_block_needs_rule | 1 Warmup | 900.9s / 774.5s | 0.0s | 126.4s | 126.4s | 5 | likely_timer_time_drift | pause_explained_not_material_boundary_error |
| 2026-05-13T11:52:06Z | repeat_block_needs_rule | 15 Recovery 7 | 172.0s / 119.4s | 0.0s | 52.6s | 52.6s | 3 | likely_timer_time_drift | pause_explained_not_material_boundary_error |
| 2026-05-27T11:45:47Z | repeat_block_needs_rule | 17 Recovery 8 | 150.0s / 89.2s | 0.0s | 60.8s | 60.8s | 3 | likely_timer_time_drift | pause_explained_not_material_boundary_error |

## Per-Workout Notes

### 2026-05-29T11:49:28Z

- Shape: `Warmup(2 km) > Work 1(3 km) > Cooldown(Open)`
- Gate B decision: `row_level_inconclusive`.
- Drift classification: `likely_timer_time_drift`.
- Material timer status: `pause_explained_not_material_boundary_error`.
- Max timer-drift row: 3 Cooldown.
- FIT elapsed/timer: 1118.9s / 960.0s.
- Candidate duration minus FIT elapsed: 0.0s.
- Candidate duration minus FIT timer: 158.9s.
- Pause overlap in FIT elapsed row window: 159.0s.
- Pause/resume markers: 3 markers, 1 paired intervals.
- Reasons: candidate duration matches FIT elapsed but not FIT timer, paired HealthKit pause/resume overlap matches elapsed-minus-timer delta.
- Recommendation: keep excluded from any narrow Phase 3 candidate.

### 2026-03-10T13:49:08Z

- Shape: `Warmup(2 km) > Recovery 1(60 s) > Work 1(1 km) > Recovery 1(120 s) > Work 2(1 km) > Recovery 2(120 s) > Work 3(1 km) > Recovery 3(120 s) > Work 4(1 km) > Recovery 4(120 s) > Work 5(1 km) > Recovery 5(120 s) > Cooldown(Open)`
- Gate B decision: `repeat_block_needs_rule`.
- Drift classification: `likely_timer_time_drift`.
- Material timer status: `pause_explained_not_material_boundary_error`.
- Max timer-drift row: 10 Recovery 4.
- FIT elapsed/timer: 270.5s / 119.2s.
- Candidate duration minus FIT elapsed: 0.0s.
- Candidate duration minus FIT timer: 151.3s.
- Pause overlap in FIT elapsed row window: 151.2s.
- Pause/resume markers: 3 markers, 1 paired intervals.
- Reasons: repeat-block rule is still required, candidate duration matches FIT elapsed but not FIT timer, paired HealthKit pause/resume overlap matches elapsed-minus-timer delta.
- Recommendation: keep excluded from any narrow Phase 3 candidate.

### 2026-04-22T11:39:58Z

- Shape: `Warmup(2 km) > Work 1(800 m) > Recovery 1(120 s) > Work 2(800 m) > Recovery 2(120 s) > Work 3(800 m) > Recovery 3(120 s) > Work 4(800 m) > Recovery 4(120 s) > Work 5(800 m) > Recovery 5(120 s) > Cooldown(Open)`
- Gate B decision: `repeat_block_needs_rule`.
- Drift classification: `likely_timer_time_drift`.
- Material timer status: `pause_explained_not_material_boundary_error`.
- Max timer-drift row: 7 Recovery 3.
- FIT elapsed/timer: 219.7s / 119.9s.
- Candidate duration minus FIT elapsed: 0.0s.
- Candidate duration minus FIT timer: 99.8s.
- Pause overlap in FIT elapsed row window: 99.7s.
- Pause/resume markers: 5 markers, 2 paired intervals.
- Reasons: repeat-block rule is still required, candidate duration matches FIT elapsed but not FIT timer, paired HealthKit pause/resume overlap matches elapsed-minus-timer delta.
- Recommendation: keep excluded from any narrow Phase 3 candidate.

### 2026-04-29T11:49:02Z

- Shape: `Warmup(2 km) > Work 1(800 m) > Recovery 1(120 s) > Work 2(800 m) > Recovery 2(120 s) > Work 3(800 m) > Recovery 3(120 s) > Work 4(800 m) > Recovery 4(120 s) > Work 5(800 m) > Recovery 5(120 s) > Cooldown(Open)`
- Gate B decision: `repeat_block_needs_rule`.
- Drift classification: `likely_timer_time_drift`.
- Material timer status: `pause_explained_not_material_boundary_error`.
- Max timer-drift row: 9 Recovery 4.
- FIT elapsed/timer: 229.1s / 119.0s.
- Candidate duration minus FIT elapsed: 0.0s.
- Candidate duration minus FIT timer: 110.1s.
- Pause overlap in FIT elapsed row window: 110.0s.
- Pause/resume markers: 5 markers, 2 paired intervals.
- Reasons: repeat-block rule is still required, candidate duration matches FIT elapsed but not FIT timer, paired HealthKit pause/resume overlap matches elapsed-minus-timer delta.
- Recommendation: keep excluded from any narrow Phase 3 candidate.

### 2026-05-06T12:02:13Z

- Shape: `Warmup(2 km) > Work 1(1 km) > Recovery 1(165 s) > Work 2(1 km) > Recovery 2(165 s) > Work 1(800 m) > Recovery 1(165 s) > Work 2(800 m) > Recovery 2(165 s) > Work 1(600 m) > Recovery 1(165 s) > Work 2(600 m) > Recovery 2(165 s) > Cooldown(Open)`
- Gate B decision: `repeat_block_needs_rule`.
- Drift classification: `likely_timer_time_drift`.
- Material timer status: `pause_explained_not_material_boundary_error`.
- Max timer-drift row: 1 Warmup.
- FIT elapsed/timer: 900.9s / 774.5s.
- Candidate duration minus FIT elapsed: 0.0s.
- Candidate duration minus FIT timer: 126.4s.
- Pause overlap in FIT elapsed row window: 126.4s.
- Pause/resume markers: 5 markers, 2 paired intervals.
- Reasons: repeat-block rule is still required, candidate duration matches FIT elapsed but not FIT timer, paired HealthKit pause/resume overlap matches elapsed-minus-timer delta.
- Recommendation: keep excluded from any narrow Phase 3 candidate.

### 2026-05-13T11:52:06Z

- Shape: `Warmup(2 km) > Work 1(400 m) > Recovery 1(120 s) > Work 2(400 m) > Recovery 2(120 s) > Work 3(400 m) > Recovery 3(120 s) > Work 4(400 m) > Recovery 4(120 s) > Work 5(400 m) > Recovery 5(120 s) > Work 6(400 m) > Recovery 6(120 s) > Work 7(400 m) > Recovery 7(120 s) > Work 8(400 m) > Recovery 8(120 s) > Cooldown(Open)`
- Gate B decision: `repeat_block_needs_rule`.
- Drift classification: `likely_timer_time_drift`.
- Material timer status: `pause_explained_not_material_boundary_error`.
- Max timer-drift row: 15 Recovery 7.
- FIT elapsed/timer: 172.0s / 119.4s.
- Candidate duration minus FIT elapsed: 0.0s.
- Candidate duration minus FIT timer: 52.6s.
- Pause overlap in FIT elapsed row window: 52.6s.
- Pause/resume markers: 3 markers, 1 paired intervals.
- Reasons: repeat-block rule is still required, candidate duration matches FIT elapsed but not FIT timer, paired HealthKit pause/resume overlap matches elapsed-minus-timer delta.
- Recommendation: keep excluded from any narrow Phase 3 candidate.

### 2026-05-27T11:45:47Z

- Shape: `Warmup(2 km) > Work 1(400 m) > Recovery 1(90 s) > Work 2(400 m) > Recovery 2(90 s) > Work 3(400 m) > Recovery 3(90 s) > Work 4(400 m) > Recovery 4(90 s) > Work 5(400 m) > Recovery 5(90 s) > Work 6(400 m) > Recovery 6(90 s) > Work 7(400 m) > Recovery 7(90 s) > Work 8(400 m) > Recovery 8(90 s) > Work 9(400 m) > Recovery 9(90 s) > Work 10(400 m) > Recovery 10(90 s) > Cooldown(Open)`
- Gate B decision: `repeat_block_needs_rule`.
- Drift classification: `likely_timer_time_drift`.
- Material timer status: `pause_explained_not_material_boundary_error`.
- Max timer-drift row: 17 Recovery 8.
- FIT elapsed/timer: 150.0s / 89.2s.
- Candidate duration minus FIT elapsed: 0.0s.
- Candidate duration minus FIT timer: 60.8s.
- Pause overlap in FIT elapsed row window: 60.8s.
- Pause/resume markers: 3 markers, 1 paired intervals.
- Reasons: repeat-block rule is still required, candidate duration matches FIT elapsed but not FIT timer, paired HealthKit pause/resume overlap matches elapsed-minus-timer delta.
- Recommendation: keep excluded from any narrow Phase 3 candidate.

## Recommendation

Keep all timer-drift outliers excluded from any narrow Phase 3 candidate until elapsed-vs-timer semantics and repeat/tail rules are explicitly approved.

Material timer policy: a large candidate-vs-FIT-timer delta is not a material boundary error when candidate elapsed matches FIT elapsed, paired HealthKit pause overlap matches elapsed-minus-timer drift, and unresolved repeat/tail/shape blockers remain separately enforced.

Before any Phase 3 discussion, the scorer/debug export should keep both elapsed and timer duration visible by row and preserve pause/resume marker evidence. Repeat-block and tail rules remain separately blocked.

## Explicit No-Production-Change Statement

This artifact is docs/debug validation only. It does not change production interval behavior, normal workout UI, `HKWorkoutActivity` promotion status, FIT import behavior, HealthFit dependency status, runtime FIT usage, or custom workout reconstruction behavior.
