# Custom Workout Evidence Collection Tracker

Status: active docs-only tracker for the next custom workout validation cycle. Do not implement Phase 3 from this tracker.

## Current Goal

Collect a balanced custom-workout evidence set that reflects real training coverage: easy fixed-goal runs, tempo variants, structured interval repeat blocks, fixed-cooldown tail cases, intentionally paused runs, and clean no-pause controls. Each completed target should pair visible Apple Fitness evidence with FIT export availability, refreshed Raw HealthKit Debug monthly diagnostics, and a parity packet export so future docs/debug scoring can separate real bugs from missing evidence.

This tracker does not change Swift, production interval behavior, normal workout UI, `HKWorkoutActivity` promotion status, FIT import behavior, HealthFit dependency status, runtime FIT usage, Phase 3 implementation status, or production custom-workout reconstruction behavior.

## Target Workout Templates

| Target class | Apple Watch template | Planned pause status | Target count | Completed count | Apple Fitness screenshots collected | FIT exported | Monthly diagnostics refreshed | Parity packet exported | Notes |
| --- | --- | --- | ---: | ---: | --- | --- | --- | --- | --- |
| Easy fixed-goal baseline | `Work(5 km) > Open` | no-pause | 2 | 0 | 0/2 | 0/2 | 0/2 | 0/2 | Gate A control for common easy runs. |
| Easy fixed-goal baseline | `Work(8 km) > Open` | no-pause | 2 | 0 | 0/2 | 0/2 | 0/2 | 0/2 | Matches common Monday easy distance. |
| Easy fixed-goal pause control | `Work(5 km) > Open` or `Work(8 km) > Open` | paused | 2 | 0 | 0/2 | 0/2 | 0/2 | 0/2 | Optional Gate A elapsed-vs-timer control. |
| Tempo fixed-time no-tail | `Warmup(2 km) > Work(20 min) > Cooldown(Open)` | no-pause | 2 | 0 | 0/2 | 0/2 | 0/2 | 0/2 | Clean warmup/work/open-cooldown evidence. |
| Tempo fixed-time pause control | `Warmup(2 km) > Work(20 min) > Cooldown(Open)` | paused | 2 | 0 | 0/2 | 0/2 | 0/2 | 0/2 | Compare elapsed time against timer time if visible. |
| Tempo fixed-distance no-tail | `Warmup(2 km) > Work(3 km) > Cooldown(Open)` | no-pause | 2 | 0 | 0/2 | 0/2 | 0/2 | 0/2 | Clean control for the current paused timer-drift shape. |
| Tempo fixed-distance pause control | `Warmup(2 km) > Work(3 km) > Cooldown(Open)` | paused | 2 | 0 | 0/2 | 0/2 | 0/2 | 0/2 | Preserve pause timing notes. |
| Tempo fixed-distance no-tail | `Warmup(2 km) > Work(4 km) > Cooldown(Open)` | no-pause | 2 | 0 | 0/2 | 0/2 | 0/2 | 0/2 | Adds coverage to the current supported narrow class. |
| Structured interval repeat block | `Warmup(2 km) > Work/Recovery repeats > Cooldown(Open)` | no-pause | 3 | 0 | 0/3 | 0/3 | 0/3 | 0/3 | Include 400 m, 800 m, and 1 km work variants if naturally scheduled. |
| Structured interval repeat block | `Warmup(2 km) > Work/Recovery repeats > Cooldown(Open)` | paused | 3 | 0 | 0/3 | 0/3 | 0/3 | 0/3 | Main pause/timer evidence for Wednesday intervals. |
| Repeat block plus fixed cooldown tail | `Warmup(2 km) > Work/Recovery repeats > Cooldown(fixed distance)` | no-pause | 2 | 0 | 0/2 | 0/2 | 0/2 | 0/2 | Tail-rule and repeat-rule interaction. |
| Repeat block plus fixed cooldown tail | `Warmup(2 km) > Work/Recovery repeats > Cooldown(fixed distance)` | paused | 2 | 0 | 0/2 | 0/2 | 0/2 | 0/2 | Collect only if naturally scheduled. |
| Fixed cooldown plus Open/Extra tail | `Warmup(2 km) > Work(fixed distance) > Cooldown(fixed distance)` | no-pause | 2 | 0 | 0/2 | 0/2 | 0/2 | 0/2 | Needed before an explicit tail rule can be considered. |

Use real scheduled Apple Watch custom running workouts. Do not create abnormal workouts only to fill this table; if the program schedules a close equivalent, keep the exact real template in the notes.

## Completed Workout Checklist

Copy one checklist per completed target workout and fill only visible or exported evidence. Do not infer hidden Apple Fitness values.

### Workout: `<start-date-time>`

- [ ] Apple Fitness overview screenshot.
- [ ] Interval/custom workout rows screenshot.
- [ ] Elapsed time screenshot or note.
- [ ] Workout/timer time screenshot or note if visible.
- [ ] Distance screenshot or note.
- [ ] Pause evidence if visible.
- [ ] FIT export through HealthFit for docs/debug validation only.
- [ ] Raw HealthKit Debug monthly refresh.
- [ ] Parity packet export.
- [ ] Notes include planned pause status, exact Apple Watch template, original FIT filename when needed, and any same-day matching details.

## Existing Workouts Where Screenshots Would Help

These workouts already appear in the March-June evidence set, but Apple Fitness screenshots would strengthen human review and future row-level comparisons:

| Start | Why screenshots would help | Needed evidence |
| --- | --- | --- |
| `2026-03-05T14:37:43Z` | Supported tempo candidate in the narrow no-tail warmup/work/open-cooldown class. | Collected in screenshot fixture. |
| `2026-04-24T12:02:30Z` | Supported tempo candidate with `Warmup(2 km) > Work(4 km) > Cooldown(Open)`. | Collected in screenshot fixture. |
| `2026-03-19T16:51:00Z` | Tempo candidate currently excluded for distance drift. | Screenshot collected but not yet scored because the current screenshot fixture focused on Gate B rule examples. Add a tighter manual row if exact Work distance is needed. |
| `2026-05-29T11:49:28Z` | Tempo candidate currently excluded for pause/timer drift. | Collected in screenshot fixture; overview workout-vs-elapsed delta matches debug pause evidence. |

## Screenshot Fixture Scorecard

Apple Fitness screenshot-confirmed rows are tracked in `apple-fitness-screenshot-confirmed-rows-2026-03-to-2026-06.json` and scored by `score_screenshot_confirmed_custom_workouts.py`.

Latest generated scorecard: `apple-fitness-screenshot-confirmed-scorecard-2026-03-to-2026-06.md`.

Current screenshot-confirmed findings:

- 12 custom-workout screenshot fixtures are typed from Apple Fitness rows.
- 7 repeat-block workouts confirm Apple Fitness presents expanded Work/Recovery rows.
- 3 fixed-step tail examples confirm Apple Fitness labels post-fixed-step residual movement as `Open`.
- 5 of 6 paused screenshots with overview elapsed-vs-workout time match total paired pause duration in debug evidence.
- `2026-05-01T12:07:44Z` now has fresh paired pause-debug evidence and a matching HealthFit FIT export. Two paired HealthKit pause intervals totaling `232.8 s` match the Apple Fitness `233 s` elapsed-vs-workout-time gap, and FIT lap timer-vs-elapsed deltas independently match those pause intervals.
- This scorecard is docs/debug validation only and does not approve production interval reconstruction, normal workout UI changes, `HKWorkoutActivity` promotion, FIT runtime use, HealthFit dependency changes, or Phase 3.

## Smallest Next Evidence Batch

Goal: close the smallest remaining evidence gaps needed to move from screenshot-confirmed behavior toward data-source-confirmed reconstruction rules. Keep this docs/debug-only. Do not change Swift, production interval behavior, normal workout UI, `HKWorkoutActivity` promotion, FIT runtime use, HealthFit dependency status, or Phase 3 implementation.

### Priority 1: Required

| Priority | Start | Why it is needed | Apple Fitness screenshots | HealthFit FIT export | Raw HealthKit Debug monthly refresh/export | RunSignal parity packet/export | Manual row confirmation |
| ---: | --- | --- | --- | --- | --- | --- | --- |
| 1 | `2026-05-01T12:07:44Z` | Completed for the targeted pause-debug gap. Apple Fitness confirms fixed cooldown followed by `Open 16 m`, and fresh HealthKit debug evidence now explains the `233 s` elapsed-vs-workout-time gap with `232.8 s` of paired pause intervals. | Collected: `updated may 1 v1.PNG`, `updated may 1 v2.PNG`. | Collected: `2026-05-01-080744-Outdoor Running-Adriel Apple Watch.fit`; FIT confirms four workout steps, four lap rows, and `232.8 s` of timer-vs-elapsed pause subtraction across Work and Cooldown. | Completed: May 2026 monthly diagnostics JSON and summary exported from fresh refresh. | Completed: selected-workout parity packet exported for May 1. | Confirmed: `Warmup 2.00 km / 12:52`, `Recovery 194 m / 2:00`, `Work 5.00 km / 21:44`, `Cooldown 1.99 km / 12:22`, `Open 16 m / 0:10`. |

Priority 1 result: May 1's `233 s` Apple Fitness elapsed-vs-workout-time delta matches `232.8 s` of paired HealthKit pause/resume intervals. See `may-1-open-tail-pause-evidence-2026-05-01.md`.

### Priority 2: Optional Manual Clarification

| Priority | Start | Why it is optional | Apple Fitness screenshots | HealthFit FIT export | Raw HealthKit Debug monthly refresh/export | RunSignal parity packet/export | Manual row confirmation |
| ---: | --- | --- | --- | --- | --- | --- | --- |
| 2 | `2026-03-19T16:51:00Z` | Screenshot exists, but the Work distance was visually uncertain, so it was not added to the scored screenshot fixture. This is useful only if we want to revisit the distance-drift exclusion with a manual Apple Fitness row. | Existing: `March 19 v1.PNG`, `March 19 v2.PNG`. Re-capture a tighter interval-row screenshot only if the Work distance is not readable from the original. | Not required for the smallest batch if the existing Gate B/FIT artifact remains usable. Re-export through HealthFit only if March 19 is promoted back into active scoring. | Not required for the smallest batch. Refresh March 2026 only if March 19 is promoted back into active scoring. | Not required for the smallest batch. Export a selected-workout parity packet only if the manual row changes the distance-drift review. | Manually type the exact Work row distance visible in Apple Fitness, plus Warmup, Work, and Cooldown times/distances. |

### Already Covered: Do Not Recollect Unless Needed

These screenshot fixtures already have enough evidence for the current docs/debug scorecard and should not be recollected unless a later scoring run exposes a specific mismatch or we intentionally build per-workout archive packets for every fixture:

| Start | Current evidence status | Reason to skip recollection |
| --- | --- | --- |
| `2026-03-05T14:37:43Z` | Screenshot-confirmed and candidate-supported. | Clean three-row tempo fixture already matches planned/candidate/FIT rows within current tolerance. |
| `2026-04-22T11:39:58Z` | Screenshot-confirmed repeat expansion and pause delta matched to debug paired-pause evidence. | Structure is supported; metric drift is already classified for timer handling. |
| `2026-04-24T12:02:30Z` | Screenshot-confirmed and candidate-supported. | Clean three-row tempo fixture already matches planned/candidate/FIT rows within current tolerance. |
| `2026-04-29T11:49:02Z` | Screenshot-confirmed repeat expansion and pause delta matched to debug paired-pause evidence. | Structure is supported; metric drift is already classified for timer handling. |
| `2026-05-06T12:02:13Z` | Screenshot-confirmed repeat expansion and pause delta matched to debug paired-pause evidence. | Structure is supported; metric drift is already classified for timer handling. |
| `2026-05-13T11:52:06Z` | Screenshot-confirmed repeat expansion and pause delta matched to debug paired-pause evidence. | Structure is supported; metric drift is already classified for timer handling. |
| `2026-05-20T11:43:00Z` | Screenshot-confirmed and candidate-supported. | Clean repeat-block fixture already matches planned/candidate/FIT rows within current tolerance. |
| `2026-05-29T11:49:28Z` | Screenshot-confirmed pause delta matched to debug paired-pause evidence. | Timer drift is already explained by paired pause evidence. |
| `2026-06-03T11:45:08Z` | Screenshot-confirmed and candidate-supported. | Clean repeat-block fixture already matches planned/candidate/FIT rows within current tolerance, and a per-workout parity packet already exists. |
| `2026-06-05T11:53:53Z` | Screenshot-confirmed Open-tail fixture. | Open-tail behavior is supported, and a per-workout parity packet already exists. |
| `2026-06-10T11:27:51Z` | Screenshot-confirmed repeat expansion plus Open-tail fixture. | Planned/candidate/FIT evidence supports the row shape; recollect only if future tail scoring needs a dedicated per-workout packet. |

## Balanced Collection Rule

Evidence collection should stay balanced across easy, tempo, interval, tail, paused, and clean no-pause cases. More narrow warmup/work/open-cooldown examples are useful, but they should not crowd out the real program shapes: easy Work/Open runs, Friday tempo variants, Wednesday repeat blocks, fixed-cooldown Open/Extra tails, intentionally paused hard workouts, and clean controls without pause ambiguity.

Keep paused workouts as first-class product evidence, not bad data. Score paused and clean no-pause cases separately until elapsed-vs-timer rules are explicit.
