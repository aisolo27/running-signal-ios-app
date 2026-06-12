# HealthFit FIT Comparison Research Plan

Status: docs-only pilot plan. FIT files are a research cross-check only.

This plan defines a small pilot for comparing RunSignal parity packets, Apple Fitness/manual rows, and HealthFit-exported FIT files for the same Apple Watch running workouts. The goal is to learn whether FIT exports provide useful evidence for debugging totals, splits, samples, or interval reconstruction without changing app behavior or production data sources.

## Source Roles

- HealthKit and WorkoutKit: RunSignal production truth. HealthKit remains read-only, WorkoutKit remains the planned-structure source when available, and HealthKit samples remain the measured-stats source.
- Apple Fitness screenshots and manual rows: visual compatibility target. Apple Fitness remains the reference for what RunSignal is trying to resemble visually, not runtime logic.
- HealthFit FIT exports: research cross-check only. FIT may help inspect exported laps, splits, events, and summary fields, but it is a transformed third-party export and must not become an app dependency or production truth.

## Pilot Workout Set

Start with the existing packet-backed fixture dates:

| Date | Dataset folder | HealthFit FIT file to gather from Drive | Notes |
|---|---|---|---|
| 2026-04-28 | `2026-04-28-easy-run/` | `healthfit-2026-04-28.fit` | Needed. Not confirmed in the current Drive listing pass. Match by running workout date/start time if present elsewhere. |
| 2026-05-26 | `2026-05-26-easy-run/` | `2026-05-26-073621-Outdoor Running-Adriel's Apple Watch.fit` | Exclude same-day `Strength Training` file. |
| 2026-06-01 | `2026-06-01-easy-run/` | `2026-06-01-075129-Outdoor Running-Adriel's Apple Watch.fit` | Running FIT export observed in Drive listing. |
| 2026-06-02 | `2026-06-02-easy-run/` | `2026-06-02-075150-Outdoor Running-Adriel's Apple Watch.fit` | Running FIT export observed in Drive listing. |
| 2026-06-03 | `2026-06-03-interval-workout/` | `2026-06-03-074508-Outdoor Running-Adriel's Apple Watch.fit` and `2026-06-03-082505-Outdoor Running-Adriel's Apple Watch.fit` | Two running FIT files exist for this date; keep both until one is matched to the parity packet by start time/duration. |
| 2026-06-04 | `2026-06-04-easy-recovery-run/` | `2026-06-04-074706-Outdoor Running-Adriel's Apple Watch.fit` | Exclude same-day `Strength Training` file. |
| 2026-06-05 | `2026-06-05-tempo-threshold-run/` | `2026-06-05-075353-Outdoor Running-Adriel's Apple Watch.fit` | Exclude same-day `Strength Training` file. |
| 2026-06-12 | `2026-06-12-easy-run/` | `2026-06-12-074954-Outdoor Running-Adriel's Apple Watch.fit` | Running FIT export observed in Drive listing. |

Use only files whose HealthFit title indicates `Outdoor Running` or `Indoor Running`. Do not use `Strength Training` FIT files for this pilot, even when the date matches a fixture.

When saving into the repo, use the existing workout folders:

```text
docs/validation/apple-fitness-interval-parity-dataset/YYYY-MM-DD-<workout-slug>/exports/healthfit-fit/
```

Suggested normalized filename:

```text
healthfit-YYYY-MM-DD.fit
```

For ambiguous same-day runs, keep a small note beside the file that records the original Drive filename, start time, and why it matches the RunSignal parity packet.

## Data Requirements

For each workout, collect:

- RunSignal parity packet JSON from `exports/runsignal-diagnostics/runsignal-parity-packet-YYYY-MM-DD.json`.
- RunSignal Raw HealthKit Debug export when available.
- Apple Fitness screenshots or manually typed rows from `expected_apple_fitness_intervals.md`.
- HealthFit FIT file for the same running workout.
- Workout date, source device, source app, and plan name when visible.
- Notes about pauses, GPS issues, treadmill/manual edits, continued running after a fixed-distance goal, duplicate same-day runs, or other matching ambiguity.

## What To Compare

Compare these fields when FIT exposes them:

- Workout start, end, elapsed duration, and moving/timer duration.
- Total distance.
- Active energy/calories, if available.
- Average and max heart rate.
- Average pace.
- Cadence and power, if available.
- FIT laps and splits.
- FIT events, lap markers, timer events, pause/resume events, and workout/session markers.
- Any FIT rows that resemble Work/Open interval structure.
- RunSignal reconstructed rows from the parity packet and observed interval docs.
- Apple Fitness/manual interval or split rows.

Keep comparison units explicit. Record whether a value comes from FIT summary, lap records, session records, event records, or derived calculations.

## Interpretation Rules

- If FIT agrees with RunSignal while Apple Fitness differs, that supports public-API reconstruction and suggests Apple Fitness may be applying private presentation logic.
- If FIT agrees with Apple Fitness while RunSignal differs, investigate RunSignal math, evidence selection, labeling, sample interpolation, totals, or interval reconstruction.
- If FIT disagrees with both RunSignal and Apple Fitness, treat FIT as a transformed HealthFit export, not an oracle.
- If FIT exposes only splits/laps and not WorkoutKit Work/Open rows, do not use it as interval parity truth.
- If FIT reveals useful sample timing, lap, event, pause, or marker evidence, document it as research-only evidence and decide whether the corresponding public HealthKit/WorkoutKit evidence already exists in RunSignal.
- If a FIT field appears to be generated by HealthFit rather than directly exported from Apple Health or Apple Watch, label it as transformed.

## Pilot Output

Do not build a production importer. A future docs/debug script may be useful after the files are collected and manually inspected.

Recommended future report path:

```text
docs/validation/apple-fitness-interval-parity-dataset/fit-comparison-summary.md
```

Optional later machine-readable output:

```text
docs/validation/apple-fitness-interval-parity-dataset/fit-comparison-summary.json
```

The first report should classify each mismatch as one of:

- RunSignal bug.
- Apple Fitness presentation delta.
- HealthFit/FIT export transformation.
- Missing evidence.
- Inconclusive.

## Guardrails

- Do not add production FIT import.
- Do not add a HealthFit dependency.
- Do not change app runtime behavior.
- Do not change boundary logic.
- Do not change normal workout UI.
- Do not approve any candidate boundary strategy from FIT alone.
- Do not use FIT as a runtime Apple Fitness replacement.
- Do not use Apple Fitness/manual expected values as runtime logic.
- Keep FIT findings in docs, debug notes, or offline validation artifacts only.

## Decision Criteria

FIT comparison is useful if it helps classify mismatches between RunSignal and Apple Fitness into clear buckets: RunSignal bug, Apple Fitness presentation delta, HealthFit/FIT export transformation, missing evidence, or inconclusive.

Keep the FIT pilot low priority or abandon it if:

- FIT lacks the interval, lap, event, or sample detail needed for the boundary problem.
- FIT rows do not map to WorkoutKit Work/Open structure.
- FIT introduces more ambiguity than clarity.
- Matching same-day running workouts to parity packets is unreliable.

The expected outcome is a better debugging microscope, not a new product data source.
