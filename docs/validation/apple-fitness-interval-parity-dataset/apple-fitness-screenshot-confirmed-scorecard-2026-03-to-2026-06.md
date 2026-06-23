# Apple Fitness Screenshot-Confirmed Custom Workout Scorecard

Generated: 2026-06-23T17:04:57.415924Z

This scorecard compares manually typed Apple Fitness screenshot rows against existing docs/debug evidence: RunSignal current rows, `HKWorkoutActivity` candidate rows, WorkoutKit planned rows, FIT lap rows, and pause-drift evidence.

It is validation-only. Screenshots and FIT are not runtime inputs, and this does not approve production interval reconstruction.

## Summary

| Metric | Value |
| --- | ---: |
| Screenshot fixture workouts | 13 |
| Apple expanded repeat-block examples | 8 |
| WorkoutKit planned rows with repeat expansion | 13 |
| Apple Open-tail examples | 3 |
| Pause-drift screenshots | 7 |
| Pause-drift screenshot/debug matches | 6 |

## Decision Counts

| Decision | Count |
| --- | ---: |
| open_tail_screenshot_supported | 2 |
| open_tail_supported_pause_debug_missing | 1 |
| screenshot_candidate_supported | 4 |
| structure_supported_metric_drift_needs_review | 6 |

## Workout Rows

| Start | Class | Rows Apple/Plan/Candidate/FIT | Candidate max dt/dd | Open tail | Pause screenshot/debug | Decision |
| --- | --- | ---: | ---: | --- | --- | --- |
| 2026-03-05T14:37:43Z | narrow_warmup_work_open_cooldown | 3/3/3/3 | 0.8s / 7.5m | no | n/a / n/a | screenshot_candidate_supported |
| 2026-04-22T11:39:58Z | paused_repeat_block | 12/12/12/12 | 99.7s / 8.1m | no | 178.0s / 178.0s | structure_supported_metric_drift_needs_review |
| 2026-04-24T12:02:30Z | narrow_warmup_work_open_cooldown | 3/3/3/3 | 0.4s / 6.7m | no | n/a / n/a | screenshot_candidate_supported |
| 2026-04-29T11:49:02Z | paused_repeat_block | 12/12/12/12 | 109.1s / 7.6m | no | 173.0s / 173.0s | structure_supported_metric_drift_needs_review |
| 2026-05-01T12:07:44Z | fixed_cooldown_open_tail | 5/4/5/4 | 141.4s / 9.1m | yes | 233.0s / n/a | open_tail_supported_pause_debug_missing |
| 2026-05-06T12:02:13Z | paused_repeat_block | 14/14/14/14 | 126.9s / 8.1m | no | 126.0s / 126.4s | structure_supported_metric_drift_needs_review |
| 2026-05-13T11:52:06Z | paused_repeat_block | 18/18/18/18 | 52.0s / 11.2m | no | 53.0s / 52.6s | structure_supported_metric_drift_needs_review |
| 2026-05-20T11:43:00Z | clean_repeat_block | 10/10/10/10 | 1.0s / 8.7m | no | n/a / n/a | screenshot_candidate_supported |
| 2026-05-27T11:45:47Z | paused_repeat_block | 22/22/22/22 | 60.0s / 11.4m | no | 61.0s / 60.8s | structure_supported_metric_drift_needs_review |
| 2026-05-29T11:49:28Z | paused_warmup_work_open_cooldown | 3/3/3/3 | 158.9s / 9.1m | no | 159.0s / 159.0s | structure_supported_metric_drift_needs_review |
| 2026-06-03T11:45:08Z | clean_repeat_block | 8/8/8/8 | 1.0s / 8.6m | no | n/a / n/a | screenshot_candidate_supported |
| 2026-06-05T11:53:53Z | fixed_cooldown_open_tail | 4/3/4/3 | 0.5s / 6.6m | yes | n/a / n/a | open_tail_screenshot_supported |
| 2026-06-10T11:27:51Z | repeat_block_fixed_cooldown_open_tail | 11/10/11/10 | 0.9s / 8.9m | yes | n/a / n/a | open_tail_screenshot_supported |

## Screenshot-Supported Rules

- Apple Fitness presents expanded Work/Recovery rows for repeat blocks.
- Apple Fitness labels post-fixed-step residual movement as Open when fixed planned steps are exhausted.
- Apple Fitness overview distinguishes workout time from elapsed time for paused workouts.
- Paused row duration must be checked against active timer time and cannot be collapsed to wall-clock elapsed time.

## Recommendation

Keep this as a debug-only validation fixture. The next implementation discussion should use these screenshot-confirmed rows plus parity packets/monthly diagnostics to score any proposed rule before touching the normal workout UI.

## Explicit No-Production-Change Statement

This scorecard is docs/debug validation only. It does not change Swift, production interval behavior, normal workout UI, HKWorkoutActivity promotion, FIT import/runtime usage, HealthFit dependency status, or Phase 3 implementation.
