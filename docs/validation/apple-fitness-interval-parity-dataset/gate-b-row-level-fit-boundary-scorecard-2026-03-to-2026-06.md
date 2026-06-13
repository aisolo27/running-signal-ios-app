# Gate B Row-Level FIT Boundary Scorecard: March-June 2026

Generated: 2026-06-13T12:01:10.116166Z

## Executive Summary

Gate B remains blocked for broad custom workout promotion. This pass adds row-level FIT lap/workout_step extraction and compares each Gate B workout against RunSignal current rows, HKWorkoutActivity candidate rows, and expanded WorkoutKit planned rows.

FIT remains an offline validation oracle only. Runtime source remains HealthKit/WorkoutKit. Swift source and production behavior are unchanged.

Do not implement a Swift prototype from this Gate B result. Some narrow shapes are now candidates for future prototype design, but broad custom workout promotion is not approved.

## Score Summary

| Bucket | Count |
| --- | ---: |
| candidate_row_level_supported | 2 |
| open_tail_needs_rule | 4 |
| repeat_block_needs_rule | 17 |
| row_level_inconclusive | 2 |

## Class Findings

| Class | Total | Equivalent | Candidate | Current | Inconclusive | Repeat rule | Open tail rule | Label rule |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Structured intervals | 20 | 0 | 0 | 0 | 0 | 17 | 3 | 0 |
| Warmup/work/cooldown | 5 | 0 | 2 | 0 | 2 | 0 | 1 | 0 |

## Required Answers

1. Warmup/work/cooldown currently reconstructed correctly? partially; no-tail three-step warmup/work/cooldown rows have row-level support, but fixed cooldown plus Open / Extra tail remains rule-blocked
2. Structured intervals currently reconstructed correctly? partially; row timings/distances are close in many cases, but repeat-block expansion and tail rules block broad approval
3. Does HKWorkoutActivity improve Gate B or only Gate A? HKWorkoutActivity strongly improves Gate A; for Gate B it is often equivalent to current rows and does not remove repeat/tail/label rule work
4. Does current reconstruction already work for some custom workout shapes? yes, especially no-tail warmup/work/cooldown and many planned structured rows, but only within the exact row-level evidence represented here
5. Safe custom workout shapes: future prototype candidate only: 2 three-step warmup/work/cooldown rows where every planned row is within 5 s and 10 m of FIT laps
6. Blocked custom workout shapes: structured interval repeat-block workouts where FIT workout_step rows are unexpanded, structured intervals with Open / Extra tail after planned rows, warmup/work/cooldown workouts with fixed cooldown followed by Open / Extra tail, any custom workout whose row labels or row errors exceed Gate B tolerances
7. Label mapping rules needed: map rows from expanded WorkoutKit planned step order, preserve Warmup, numbered Work, numbered Recovery, and Cooldown labels, use Open / Extra only after planned fixed steps are exhausted
8. Repeat-block rules needed: treat FIT workout_step rows as unexpanded plan evidence, compare FIT lap rows against expanded WorkoutKit planned rows, do not approve repeat-block classes from count alignment alone
9. Open/Extra tail rules needed: if a final Cooldown goal is open, keep Cooldown through workout end, if a fixed Cooldown completes and running continues, classify the remainder as Open / Extra, score Open / Extra against FIT session-minus-lap tail when FIT has no explicit tail lap
10. Next before Swift implementation: keep Gate B docs/debug-only, review row-level scorecard outliers by exact workout shape, do not implement Gate A or Gate B Swift prototype from this Gate B pass

## Workout Rows

| Start | Class | Rows current/candidate/FIT/plan | Decision | Max current err | Max candidate err | Tail |
| --- | --- | --- | --- | ---: | ---: | --- |
| 2026-03-03T13:39:37Z | structured interval workout | 18/18/18/18 | repeat_block_needs_rule | 7.5s / 10.5m | 0.0s / 15.3m | yes |
| 2026-03-05T14:37:43Z | warmup/work/cooldown special | 3/3/3/3 | candidate_row_level_supported | 3.2s / 6.0m | 0.0s / 7.5m | yes |
| 2026-03-10T13:49:08Z | structured interval workout | 13/13/13/13 | repeat_block_needs_rule | 141.9s / 21.8m | 151.3s / 7.3m | yes |
| 2026-03-12T13:41:02Z | structured interval workout | 8/8/8/8 | repeat_block_needs_rule | 3.5s / 5.4m | 0.0s / 7.6m | yes |
| 2026-03-17T12:29:37Z | structured interval workout | 18/18/18/18 | repeat_block_needs_rule | 5.3s / 15.3m | 0.0s / 9.4m | yes |
| 2026-03-19T16:51:00Z | warmup/work/cooldown special | 3/3/3/3 | row_level_inconclusive | 5.6s / 19.5m | 0.0s / 24.0m | no |
| 2026-03-25T14:47:56Z | structured interval workout | 14/14/14/14 | repeat_block_needs_rule | 3.8s / 9.6m | 0.0s / 13.0m | yes |
| 2026-03-27T12:59:26Z | structured interval workout | 8/8/8/8 | repeat_block_needs_rule | 3.5s / 5.2m | 0.0s / 9.0m | yes |
| 2026-03-31T15:26:28Z | structured interval workout | 10/10/10/10 | repeat_block_needs_rule | 1.5s / 6.4m | 0.0s / 8.0m | yes |
| 2026-04-12T16:01:33Z | structured interval workout | 3/3/2/2 | open_tail_needs_rule | 4.1s / 5.6m | 0.0s / 8.7m | yes |
| 2026-04-22T11:39:58Z | structured interval workout | 12/12/12/12 | repeat_block_needs_rule | 88.1s / 47.0m | 99.8s / 8.1m | yes |
| 2026-04-24T12:02:30Z | warmup/work/cooldown special | 3/3/3/3 | candidate_row_level_supported | 5.0s / 8.4m | 0.0s / 6.7m | yes |
| 2026-04-29T11:49:02Z | structured interval workout | 12/12/12/12 | repeat_block_needs_rule | 108.4s / 63.0m | 110.1s / 7.6m | yes |
| 2026-05-01T12:07:44Z | structured interval workout | 5/5/4/4 | open_tail_needs_rule | 139.6s / 5.6m | 141.0s / 9.1m | yes |
| 2026-05-06T12:02:13Z | structured interval workout | 14/14/14/14 | repeat_block_needs_rule | 122.5s / 9.1m | 126.4s / 8.1m | yes |
| 2026-05-08T11:55:07Z | structured interval workout | 6/6/6/6 | repeat_block_needs_rule | 3.6s / 7.3m | 0.0s / 7.4m | yes |
| 2026-05-13T11:52:06Z | structured interval workout | 18/18/18/18 | repeat_block_needs_rule | 35.6s / 66.4m | 52.6s / 11.2m | yes |
| 2026-05-15T12:00:12Z | structured interval workout | 8/8/8/8 | repeat_block_needs_rule | 5.5s / 8.1m | 0.0s / 9.8m | yes |
| 2026-05-20T11:43:00Z | structured interval workout | 10/10/10/10 | repeat_block_needs_rule | 4.3s / 8.2m | 0.0s / 8.7m | yes |
| 2026-05-22T11:55:11Z | structured interval workout | 6/6/6/6 | repeat_block_needs_rule | 3.6s / 6.1m | 0.0s / 7.2m | yes |
| 2026-05-27T11:45:47Z | structured interval workout | 22/22/22/22 | repeat_block_needs_rule | 55.2s / 22.4m | 60.8s / 11.4m | yes |
| 2026-05-29T11:49:28Z | warmup/work/cooldown special | 3/3/3/3 | row_level_inconclusive | 161.1s / 11.5m | 158.9s / 6.6m | yes |
| 2026-06-03T11:45:08Z | structured interval workout | 8/8/8/8 | repeat_block_needs_rule | 4.9s / 8.6m | 0.0s / 8.6m | yes |
| 2026-06-05T11:53:53Z | warmup/work/cooldown special | 4/4/3/3 | open_tail_needs_rule | 3.9s / 11.1m | 0.0s / 6.6m | yes |
| 2026-06-10T11:27:51Z | structured interval workout | 11/11/10/10 | open_tail_needs_rule | 3.6s / 8.4m | 0.0s / 8.9m | yes |

## Recommendation

- Gate B remains blocked for broad production promotion.
- No Swift prototype is recommended now.
- Keep Gate A separate; this Gate B row-level work does not change the existing Gate A prototype decision.
- Use this row-level JSON to inspect exact workout subclasses before approving any future narrow Swift experiment.
