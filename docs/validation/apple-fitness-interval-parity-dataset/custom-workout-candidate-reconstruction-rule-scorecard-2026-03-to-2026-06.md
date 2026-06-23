# Custom Workout Candidate Reconstruction Rule Scorecard

Generated: 2026-06-23T17:04:57.462023Z

Status: docs/debug validation only. This does not change Swift, production interval behavior, normal workout UI, `HKWorkoutActivity` promotion, FIT runtime use, HealthFit dependency status, or Phase 3 implementation.

## Goal

Score the smallest candidate reconstruction rules against the existing screenshot-confirmed Apple Fitness fixtures, row-level FIT evidence, HealthKit debug pause evidence, and parity packet candidate rows. The purpose is to avoid overfitting May 1 before any Swift prototype discussion.

## Candidate Rules Scored

- Use expanded WorkoutKit planned rows for expected row order and repeat-block labels.
- Use debug HKWorkoutActivity candidate rows for measured row boundaries and distances.
- Use active/timer duration for planned rows when FIT/debug pause evidence shows elapsed includes pauses.
- Keep elapsed wall-clock duration separate from active/timer duration.
- Infer Open/Extra only after fixed planned steps are exhausted, using the measured candidate tail row.

## Summary

| Metric | Value |
| --- | ---: |
| Workout fixtures scored | 13 |
| Rows within tolerance | 13 |
| Open-tail rules supported | 3 |
| Pause overview gaps supported | 7 |
| Repeat expansions supported | 13 |

## Decision Counts

| Decision | Count |
| --- | ---: |
| supported_open_tail | 2 |
| supported_open_tail_and_pause | 1 |
| supported_pause | 6 |
| supported_repeat_expansion | 4 |

## Workout Scores

| Start | Class | Rows Apple/Candidate/FIT | Max dt/dd | Open tail | Pause gap | Decision |
| --- | --- | ---: | ---: | --- | --- | --- |
| 2026-03-05T14:37:43Z | narrow_warmup_work_open_cooldown | 3/3/3 | 0.8s / 7.5m | no | n/a / n/a | supported_repeat_expansion |
| 2026-04-22T11:39:58Z | paused_repeat_block | 12/12/12 | 0.6s / 8.1m | no | 178.0s / 178.0s | supported_pause |
| 2026-04-24T12:02:30Z | narrow_warmup_work_open_cooldown | 3/3/3 | 0.4s / 6.7m | no | n/a / n/a | supported_repeat_expansion |
| 2026-04-29T11:49:02Z | paused_repeat_block | 12/12/12 | 1.0s / 7.6m | no | 173.0s / 173.0s | supported_pause |
| 2026-05-01T12:07:44Z | fixed_cooldown_open_tail | 5/5/4 | 0.5s / 9.1m | yes | 233.0s / 232.8s | supported_open_tail_and_pause |
| 2026-05-06T12:02:13Z | paused_repeat_block | 14/14/14 | 0.9s / 8.1m | no | 126.0s / 126.4s | supported_pause |
| 2026-05-13T11:52:06Z | paused_repeat_block | 18/18/18 | 0.8s / 11.2m | no | 53.0s / 52.6s | supported_pause |
| 2026-05-20T11:43:00Z | clean_repeat_block | 10/10/10 | 1.0s / 8.7m | no | n/a / n/a | supported_repeat_expansion |
| 2026-05-27T11:45:47Z | paused_repeat_block | 22/22/22 | 0.9s / 11.4m | no | 61.0s / 60.8s | supported_pause |
| 2026-05-29T11:49:28Z | paused_warmup_work_open_cooldown | 3/3/3 | 0.2s / 9.1m | no | 159.0s / 159.0s | supported_pause |
| 2026-06-03T11:45:08Z | clean_repeat_block | 8/8/8 | 1.0s / 8.6m | no | n/a / n/a | supported_repeat_expansion |
| 2026-06-05T11:53:53Z | fixed_cooldown_open_tail | 4/4/3 | 0.5s / 6.6m | yes | n/a / n/a | supported_open_tail |
| 2026-06-10T11:27:51Z | repeat_block_fixed_cooldown_open_tail | 11/11/10 | 0.9s / 8.9m | yes | n/a / n/a | supported_open_tail |

## Interpretation

- The candidate rule set matches 13 of 13 screenshot-confirmed fixtures within the current row tolerances.
- May 1 no longer stands alone: the same active/timer duration rule also resolves the paused repeat-block and paused warmup/work/cooldown fixtures.
- The Open/Extra tail rule is supported for the three screenshot-confirmed Open-tail fixtures: May 1, Jun 5, and Jun 10.
- Repeat-block expansion remains supported as a presentation rule, but production promotion is still blocked until a later explicit prototype gate.

## Risks And Fallbacks

- This pass validates rule behavior against screenshot-confirmed fixtures; it does not prove Apple private UI rules.
- FIT is an offline validation oracle only. Runtime reconstruction must derive active time from HealthKit pause/event evidence or other public HealthKit data, not FIT.
- May 1's exact Open 16 m tail is supported by Apple Fitness plus HealthKit activity-boundary evidence; FIT alone is not precise enough for that tail distance.
- Do not promote these rules into the normal workout detail UI until a later task explicitly approves a debug-only Swift prototype and then a separate production gate.

## Smallest Safe Swift Slice After Scoring

If a later task approves Swift work, start with a debug-only Parity Lab scorer that displays candidate active durations, elapsed durations, pause overlap, and Open/Extra tail rows for selected workouts. Do not replace the production workout detail interval UI in that slice.

## Explicit No-Production-Change Statement

This scorecard is docs/debug validation only. It does not change Swift, production interval behavior, normal workout UI, HKWorkoutActivity promotion, FIT import/runtime usage, HealthFit dependency status, or Phase 3 implementation.
