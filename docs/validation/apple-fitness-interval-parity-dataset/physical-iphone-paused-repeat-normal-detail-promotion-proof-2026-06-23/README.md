# Paused Repeat Normal-Detail Promotion Proof

Date archived: 2026-06-23

This folder archives the physical-iPhone proof packet for the narrow paused repeat-block normal-detail promotion:

`Warmup(2 km) > repeated Work/Recovery rows > Cooldown(Open)`

The proof uses HealthKit/WorkoutKit-derived RunSignal raw debug and parity exports as app-side evidence, with Apple Fitness screenshots as visual comparison evidence. FIT remains offline validation evidence only and is not part of this runtime proof.

## Artifact Inventory

### RunSignal Exports

All source files were copied from:

`/Users/adrielsolorzano/Documents/Personal OS/00_Inbox_To_Sort/RunSignal testing/indivudal runs txt files`

| Workout | Raw HealthKit Debug | Parity Packet |
|---|---|---|
| Apr 22, 2026 | `raw-exports/2026-04-22-raw-healthkit-debug.txt` | `raw-exports/2026-04-22-parity-packet.txt` |
| Apr 29, 2026 | `raw-exports/2026-04-29-raw-healthkit-debug.txt` | `raw-exports/2026-04-29-parity-packet.txt` |
| May 6, 2026 | `raw-exports/2026-05-06-raw-healthkit-debug.txt` | `raw-exports/2026-05-06-parity-packet.txt` |
| May 13, 2026 | `raw-exports/2026-05-13-raw-healthkit-debug.txt` | `raw-exports/2026-05-13-parity-packet.txt` |
| May 27, 2026 | `raw-exports/2026-05-27-raw-healthkit-debug.txt` | `raw-exports/2026-05-27-parity-packet.txt` |

### Apple Fitness Screenshots

Apr 22, Apr 29, May 6, and May 13 screenshots were copied from the existing repository screenshot archive:

`docs/validation/apple-fitness-interval-parity-dataset/apple-fitness-screenshot-archive-2026-06-13/`

May 27 screenshots were copied from:

`/Users/adrielsolorzano/Documents/Personal OS/00_Inbox_To_Sort/RunSignal testing/Images`

| Workout | Summary/detail screenshot | Interval-row screenshot(s) |
|---|---|---|
| Apr 22, 2026 | `apple-fitness-screenshots/2026-04-22-apple-fitness-summary.PNG` | `apple-fitness-screenshots/2026-04-22-apple-fitness-intervals.PNG` |
| Apr 29, 2026 | `apple-fitness-screenshots/2026-04-29-apple-fitness-summary.PNG` | `apple-fitness-screenshots/2026-04-29-apple-fitness-intervals.PNG` |
| May 6, 2026 | `apple-fitness-screenshots/2026-05-06-apple-fitness-summary.PNG` | `apple-fitness-screenshots/2026-05-06-apple-fitness-intervals.PNG` |
| May 13, 2026 | `apple-fitness-screenshots/2026-05-13-apple-fitness-summary.PNG` | `apple-fitness-screenshots/2026-05-13-apple-fitness-intervals-top.PNG`, `apple-fitness-screenshots/2026-05-13-apple-fitness-intervals-bottom.jpg` |
| May 27, 2026 | `apple-fitness-screenshots/2026-05-27-apple-fitness-summary.PNG` | `apple-fitness-screenshots/2026-05-27-apple-fitness-intervals-top.PNG`, `apple-fitness-screenshots/2026-05-27-apple-fitness-intervals-bottom.PNG` |

`apple-fitness-manual-rows-2026-05-27.json` records the May 27 screenshot rows in machine-readable form because May 27 was not present in the previous screenshot-confirmed row index.

## RunSignal Parity Summary

The relevant proof section in each parity packet is `customWorkoutComparisonSummary` plus `customWorkoutCandidateRuleSummary` / `customWorkoutCandidateRuleRows`. Top-level `reconstructedIntervals` are the generic reconstruction payload and are not the paused-repeat proof source for this packet.

| Workout | Structured status | Fallback reasons | Tail ambiguity | Candidate rows | Open tail rows | Paired pauses | Paired pause total |
|---|---:|---:|---|---:|---:|---:|---:|
| Apr 22, 2026 | supported | 0 | plannedOpenCooldownContinuesToWorkoutEnd | 12 | 0 | 2 | 178.1 s |
| Apr 29, 2026 | supported | 0 | plannedOpenCooldownContinuesToWorkoutEnd | 12 | 0 | 2 | 173.0 s |
| May 6, 2026 | supported | 0 | plannedOpenCooldownContinuesToWorkoutEnd | 14 | 0 | 2 | 126.4 s |
| May 13, 2026 | supported | 0 | plannedOpenCooldownContinuesToWorkoutEnd | 18 | 0 | 1 | 52.6 s |
| May 27, 2026 | supported | 0 | plannedOpenCooldownContinuesToWorkoutEnd | 22 | 0 | 1 | 60.8 s |

## May 27 Row Check

May 27 was the missing Apple Fitness screenshot proof. The new screenshots show:

- Apple Fitness summary/detail: Wed, May 27, Outdoor Run, Wednesday Interval (8.5km), workout time `0:52:41`, elapsed time `0:53:42`, distance `8.51 km`, average pace `6:11/km`.
- Apple Fitness intervals: Warmup, ten Work rows, ten Recovery rows, and Cooldown. There is no true `Open / Extra` tail.
- RunSignal parity packet: `customWorkoutComparisonSummary.status == supported`, no fallback reasons, `tailAmbiguity == plannedOpenCooldownContinuesToWorkoutEnd`, `openTailRowCount == 0`, one paired pause totaling `60.8 s`.
- RunSignal candidate row 17 preserves elapsed row-window duration `150.0 s`, subtracts paired pause overlap `60.8 s`, and yields active/timer duration `89.2 s`, matching Apple Fitness's displayed `Recovery` row time of `1:30` after rounding.

## Conclusion

The five paused repeat-block proof workouts match the narrow promotion shape and remain inside the approved constraints:

- WorkoutKit planned rows are present and expanded.
- HealthKit activity-backed candidate rows are complete, count-aligned, and scoreable.
- Pauses are paired.
- Each proof case has `plannedOpenCooldownContinuesToWorkoutEnd`.
- Each proof case has `openTailRowCount == 0`.
- Apple Fitness screenshots show the same row counts and no true Open/Extra tail.

This evidence supports the narrow paused-repeat open-cooldown normal-detail promotion only. It does not approve recovery-containing tails, ambiguous repeat tails, true Open/Extra paused-repeat tails, unpaired pauses, missing rows, broad repeat behavior, or interval-row analytics.
