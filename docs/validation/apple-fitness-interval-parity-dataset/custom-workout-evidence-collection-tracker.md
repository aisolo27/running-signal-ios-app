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
| `2026-03-05T14:37:43Z` | Supported tempo candidate in the narrow no-tail warmup/work/open-cooldown class. | Overview, interval rows, elapsed time, distance. |
| `2026-04-24T12:02:30Z` | Supported tempo candidate with `Warmup(2 km) > Work(4 km) > Cooldown(Open)`. | Overview, interval rows, elapsed time, distance. |
| `2026-03-19T16:51:00Z` | Tempo candidate currently excluded for distance drift. | Overview, interval rows, elapsed time, distance, any visible workout/timer time. |
| `2026-05-29T11:49:28Z` | Tempo candidate currently excluded for pause/timer drift. | Overview, interval rows, elapsed time, workout/timer time if visible, distance, pause evidence. |

## Balanced Collection Rule

Evidence collection should stay balanced across easy, tempo, interval, tail, paused, and clean no-pause cases. More narrow warmup/work/open-cooldown examples are useful, but they should not crowd out the real program shapes: easy Work/Open runs, Friday tempo variants, Wednesday repeat blocks, fixed-cooldown Open/Extra tails, intentionally paused hard workouts, and clean controls without pause ambiguity.

Keep paused workouts as first-class product evidence, not bad data. Score paused and clean no-pause cases separately until elapsed-vs-timer rules are explicit.
