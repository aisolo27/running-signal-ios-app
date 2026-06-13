# Custom Workout Balanced Evidence Collection Plan

Status: docs-only evidence plan. Do not implement Phase 3 from this document.

This plan turns the March-June 2026 custom workout shape audit into a practical collection plan. The goal is to collect evidence that reflects the real training program: easy fixed-goal runs, Friday tempo variants, Wednesday interval repeat blocks, fixed-cooldown tails, and real pause/timer behavior.

## Current Coverage Summary

| Coverage item | Current count | Interpretation |
| --- | ---: | --- |
| Matched running workouts | 87 | Full March-June matched running set currently available to the docs/debug scorecards. |
| Gate A simple Work/Open easy runs | 50 | Mostly easy fixed-goal runs. These are not Gate B, but they are real custom workout coverage. |
| Gate B structured/special workouts | 25 | Warmup/work/cooldown, tempo-like, repeat-block, and tail-rule candidates. |
| Excluded/no-plan/duplicate/unknown | 12 | Missing plan evidence, same-day extras, or drift/guard unknowns. Keep out of approval scoring until evidence improves. |
| Paired pause/resume workouts | 13 | Real-world pause evidence. Useful for future timer handling, not bad data. |
| Timer-drift evidence workouts | 7 | Candidate rows match FIT elapsed duration while FIT timer duration subtracts pause intervals. Keep excluded from narrow clean fixtures. |

The narrow warmup/work/open-cooldown scorecard found only 4 exact rows because it intentionally requires exactly `Warmup(2 km) > one fixed Work step > Cooldown(Open)`, exactly 3 rows across plan/current/candidate/FIT evidence, no recovery rows, no fixed cooldown tail, and no unresolved timer drift. That narrow class is useful, but it does not represent the training program by itself.

## Recommended Collection Split

| Class | Minimum useful | Better target | Why collect it |
| --- | ---: | ---: | --- |
| Easy fixed-goal runs | 3 | 5-6 | Confirms Gate A Work/Open remains stable across common easy goals. |
| Tempo warmup/work/cooldown runs | 3 | 5 | Expands the no-tail Gate B discussion beyond the current 2 supported rows. |
| Tempo runs with recovery rows | 2 | 4 | Captures Friday tempo variants that are not the exact narrow shape. |
| Structured interval repeat-block runs | 4 | 8 | Needed before any repeat-block subclass can be discussed. Include short and longer reps. |
| Fixed cooldown plus Open/Extra tail cases | 2 | 4 | Needed before an explicit tail rule can be considered. |
| Intentionally paused workouts | 3 | 5 | Keeps pause/timer handling first-class. Include at least one tempo and two interval examples. |
| Clean no-pause workouts | 5 | 8 | Provides control fixtures for each main shape without timer ambiguity. |

A later debug-only Phase 3 subclass discussion should require at least one balanced set: 5 clean easy Work/Open, 5 clean no-tail tempo rows, 6 repeat-block interval rows with mixed distances/times, 3 fixed-cooldown tail rows, and 5 paused rows with visible elapsed-vs-timer evidence. This is a discussion threshold only, not production approval.

## Apple Watch Workout Templates To Run

Use scheduled Apple Watch custom running workouts. Record whether the run was intentionally no-pause or intentionally paused.

| Template | Version to collect | Target count | Notes |
| --- | --- | ---: | --- |
| `Work(5 km) > Open` | no-pause | 2 | Easy fixed-goal baseline. |
| `Work(8 km) > Open` | no-pause | 2 | Matches common Monday easy distance. |
| `Work(5 km) > Open` or `Work(8 km) > Open` | paused | 1-2 | Optional Gate A pause/timer control. |
| `Warmup(2 km) > Work(20 min) > Cooldown(Open)` | no-pause and paused | 2 each | Fixed-time tempo; compare elapsed/timer behavior. |
| `Warmup(2 km) > Work(3 km) > Cooldown(Open)` | no-pause and paused | 2 each | Current timer-drift outlier shape has a paused version. Add clean controls. |
| `Warmup(2 km) > Work(4 km) > Cooldown(Open)` | no-pause | 2 | Current supported narrow class has one 4 km row; collect more. |
| `Warmup(2 km) > Work/Recovery repeats > Cooldown(Open)` | no-pause and paused | 3 each | Main Wednesday interval shape. Include 400 m, 800 m, and 1 km work variants if the program naturally schedules them. |
| `Warmup(2 km) > Work/Recovery repeats > Cooldown(fixed distance)` | no-pause and paused if feasible | 2 each | Tail-rule and repeat-rule interaction. |
| `Warmup(2 km) > Work(fixed distance) > Cooldown(fixed distance)` | no-pause | 2 | Fixed cooldown plus Open/Extra tail class. |

Do not create abnormal workouts just to satisfy the table. If the program naturally schedules a close equivalent, keep the real program workout and note the exact template.

## Screenshot Checklist

For each target workout, capture screenshots or manually transcribe values visible in Apple Fitness:

- Apple Fitness workout overview.
- Custom workout interval rows.
- Elapsed time.
- Workout time or timer time if visible.
- Distance.
- Pause evidence if visible.
- Warmup, work, recovery, cooldown row details.
- Any final Open/Extra row or post-cooldown distance/time if visible.

Do not infer hidden values from screenshots. Type only values visible in Apple Fitness.

## Export Checklist

For each target workout:

- Export the FIT file through HealthFit for docs/debug validation only.
- Place running FIT files under `docs/validation/apple-fitness-interval-parity-dataset/exports/healthfit-fit/`.
- Exclude non-running FIT files such as strength workouts, even if the date matches.
- Refresh the relevant month from Raw HealthKit Debug using `Refresh Month Evidence`.
- Export `Monthly Diagnostics JSON` and `Monthly Diagnostics Summary`.
- Store month-scale exported files in the existing local collection area used by the rollup scripts: `/Users/adrielsolorzano/Documents/Personal OS/00_Inbox_To_Sort/RunSignal testing/`.
- Export a parity packet for each selected target workout.
- Store fixture-level parity packets as `runsignal-parity-packet-YYYY-MM-DD.json` in the matching dataset workout folder or diagnostics export folder used by the existing scripts.
- For ambiguous same-day runs, add a short note with original FIT filename, start time, duration, and why it matches the parity packet.
- Keep a manual note for whether the run was paused and approximately when.

Existing scripts expect generated scorecard inputs under `docs/validation/apple-fitness-interval-parity-dataset/` and monthly diagnostics JSON files in the local `RunSignal testing` export folder above. Do not add FIT import or runtime FIT usage to the app.

## Acceptance Criteria By Future Subclass

### Gate A Easy Fixed-Goal

- At least 5 clean no-pause Work/Open examples across 5 km, 8 km, and one longer distance.
- Current/candidate/FIT distance and elapsed timing remain inside existing Gate A tolerances.
- Paused examples are scored separately and do not weaken the clean no-pause baseline.
- Production remains parked unless a later task explicitly approves a feature-flagged prototype.

### Narrow Warmup/Work/Open-Cooldown Tempo

- At least 5 clean no-pause rows matching `Warmup(2 km) > one fixed Work step > Cooldown(Open)`.
- Exactly 3 planned rows, 3 current rows, 3 activity candidate rows, 3 FIT laps, and 3 FIT workout_step rows.
- No recovery rows, no fixed cooldown, and no material tail ambiguity.
- Candidate labels map from expanded WorkoutKit order with zero mismatches.
- Row timing error <= 5 s and row distance error <= 10 m.

### Repeat-Block Structured Interval

- At least 6 no-pause repeat-block workouts with mixed 400 m, 800 m, 1 km, and time-based work where naturally scheduled.
- Include at least 3 paused repeat-block workouts for timer semantics, scored separately.
- FIT workout_step rows may stay unexpanded; comparison must use expanded WorkoutKit rows against FIT laps.
- Fallback on missing activity rows, count mismatch, non-contiguity, tail ambiguity, label mismatch, or high row error.

### Fixed Cooldown Plus Open/Extra Tail

- At least 3 fixed-cooldown examples with session-minus-lap tail evidence.
- Confirm fixed planned steps are exhausted before classifying a tail.
- Confirm whether FIT has an explicit tail lap; current evidence has session-minus-lap tail evidence only.
- Fallback when fixed-step exhaustion is ambiguous or FIT session totals conflict with lap sums.

### Pause/Timer Handling

- At least 5 intentionally preserved paused workouts across tempo and interval classes.
- Capture paired pause/resume markers, elapsed duration, timer duration if visible, and per-row elapsed-vs-timer deltas where available.
- Treat pauses as first-class product behavior, not abnormal data.
- Keep paused rows excluded from clean narrow fixtures until elapsed-vs-timer rules are explicit.

## What Stays Blocked

- Broad custom workout reconstruction.
- Production promotion of `HKWorkoutActivity` rows.
- Normal workout UI interval promotion for Gate B rows.
- Runtime FIT use, FIT import, HealthFit dependency, or file-based workout ingestion.
- Repeat-block production behavior until an explicit expanded WorkoutKit-to-FIT-lap rule is validated.
- Fixed cooldown plus Open/Extra tail behavior until the tail rule is explicit and validated.
- Timer-drift outliers until elapsed-vs-timer and pause semantics are explicit.
- Phase 3 prototype work until a later task explicitly approves a debug-only subclass scope.

## Explicit No-Production-Change Statement

This is a docs-only collection plan. It does not change Swift, production interval behavior, normal workout UI, `HKWorkoutActivity` promotion status, FIT import behavior, HealthFit dependency status, runtime FIT usage, Phase 3 implementation status, or production custom workout reconstruction behavior.
