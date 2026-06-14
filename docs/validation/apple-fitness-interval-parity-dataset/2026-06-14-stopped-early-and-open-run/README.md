# June 14 Stopped-Early Custom Run And Open Run Evidence

Status: docs/evidence capture only. Do not change Swift or production interval behavior from this note alone.

## Scope

This folder captures two June 14, 2026 outdoor runs from the physical iPhone export path:

- A custom Apple Watch workout named `Test Race Day 5k` that planned one `Work` step with a `5 km` distance goal and `4:00 /km` pace alert, then was manually stopped after about `3 km`.
- A plain open outdoor run started directly from Apple Watch with no custom workout rows.

FIT files were found in the saved external HealthFit FIT archive folder recorded in `balanced-evidence-batch-review-2026-06-13.md`: `https://drive.google.com/drive/u/0/folders/1QUo6CaiRIBtgV0sk37Uc4wOhFmINyQyf`. Direct Drive filename search did not find these files, so future work should list that folder first.

## Source Files

### RunSignal Exports

- `exports/runsignal-diagnostics/runsignal-raw-healthkit-debug-2026-06-14-stopped-early-custom.md`
- `exports/runsignal-diagnostics/runsignal-raw-healthkit-debug-2026-06-14-stopped-early-custom.json`
- `exports/runsignal-diagnostics/runsignal-raw-healthkit-debug-2026-06-14-open-run.md`
- `exports/runsignal-diagnostics/runsignal-raw-healthkit-debug-2026-06-14-open-run.json`

### Apple Fitness Screenshots

- `screenshots/apple-fitness/june-14-stopped-early-custom-overview.png`
- `screenshots/apple-fitness/june-14-stopped-early-custom-intervals.png`
- `screenshots/apple-fitness/june-14-open-run-overview.png`
- `screenshots/apple-fitness/june-14-open-run-splits.png`

### HealthFit FIT Files

- Stopped-early custom run: `2026-06-14-075237-Outdoor Running-Adriel’s Apple Watch.fit`
  - Drive file: `https://drive.google.com/file/d/1FZfC_Yi7pRnjjLZjUdvo-tlwXgpq9K_r/view?usp=drivesdk`
  - Parent folder: `https://drive.google.com/drive/u/0/folders/1QUo6CaiRIBtgV0sk37Uc4wOhFmINyQyf`
  - Local copy: `exports/healthfit-fit/2026-06-14-075237-Outdoor Running-Adriels Apple Watch.fit`
- Plain open run: `2026-06-14-081105-Outdoor Running-Adriel’s Apple Watch.fit`
  - Drive file: `https://drive.google.com/file/d/1RmFtvZ4Mb5SUcR5h105atQKf0CjTNkBF/view?usp=drivesdk`
  - Parent folder: `https://drive.google.com/drive/u/0/folders/1QUo6CaiRIBtgV0sk37Uc4wOhFmINyQyf`
  - Local copy: `exports/healthfit-fit/2026-06-14-081105-Outdoor Running-Adriels Apple Watch.fit`

## FIT Decode Result

Decoded locally on 2026-06-14 with the repo's FIT row-level parser from `extract_gate_b_row_level_fit_boundaries.py`.

| Case | FIT laps | FIT workout steps | FIT session | Decision |
| --- | ---: | ---: | --- | --- |
| Stopped-early custom | 1 lap: `3026.0 m / 733.8 s` | 1 step: distance target `5000.0 m`, active intensity | `3026.0 m / 733.8 s timer` | Supports a narrow partial-Work rule when one fixed-distance Work step maps to one complete HealthKit activity row and the activity distance is short of the planned goal. |
| Plain open run | 3 laps: `1000.0 m / 386.3 s`, `1000.0 m / 658.4 s`, `199.8 m / 151.8 s` | 0 steps | `2199.8 m / 1199.5 s timer` | Supports the open-run control: read workout data and splits, but do not invent custom interval rows. |

The FIT session elapsed field decodes as `0.0 s` for these HealthFit files through the current lightweight parser, so scoring uses FIT timer duration plus lap rows for this pass.

## Workout 1: Stopped-Early Custom `Test Race Day 5k`

| Field | Evidence |
| --- | --- |
| RunSignal workout ID | `D57BFD29-EEF1-453D-9A98-4BE0E4159C8E` |
| Start | `2026-06-14T11:52:37Z` |
| End | `2026-06-14T12:04:50Z` |
| Apple Fitness local time | `7:52 AM-8:04 AM` |
| RunSignal duration | `12:14` |
| RunSignal distance | `3.03 km` |
| Apple Fitness overview | `12:13`, `3.02 km`, `4'03"/km`, `172 bpm`, `294 W`, `188 spm` |
| Apple Fitness interval row | `Work`, `3.02 km`, `12:14`, `4'03"/km`, `172 bpm` |
| WorkoutKit plan | Custom workout, `Test Race Day 5k`, `Work 1`, goal `5 km`, pace alert `4:00 /km`, no warmup, no cooldown |
| HealthKit activity rows | One `HKWorkoutActivity` row from `0.0 s` to `733.8 s`, `3026.0 m` |
| Debug candidate status | `supported`, one `Work 1` row, `mappedByPlannedStepOrder`, no paired pauses, no tail ambiguity |
| Current reconstructed interval output | One `Open / Extra` row for `3.03 km / 12:14`, with note `Could not reconstruct Work 1; missing usable distance evidence` |

### Interpretation

Apple Fitness treats the manually stopped workout as a completed partial `Work` row, not as an `Open / Extra` tail. The debug-only activity-boundary and custom candidate scorer also map the single HealthKit activity row to `Work 1` and mark the structured comparison as `supported`.

This is a useful bug/plan signal for a later implementation discussion: a one-step fixed-distance custom workout can be stopped before reaching its planned distance and still represent a valid partial `Work` row. The current production reconstruction path appears too strict for this shape because it falls back to `Open / Extra` after failing to find completion of the full `5 km` goal. Do not promote this broadly until FIT or additional HealthKit-backed examples confirm the intended rule.

## Workout 2: Plain Open Outdoor Run

| Field | Evidence |
| --- | --- |
| RunSignal workout ID | `4FBA60D5-9E2D-4FC3-A5F5-E5C1262FFB0D` |
| Start | `2026-06-14T12:11:05Z` |
| End | `2026-06-14T12:31:04Z` |
| Apple Fitness local time | `8:11 AM-8:31 AM` |
| RunSignal duration | `19:59` |
| RunSignal distance | `2.20 km` |
| Apple Fitness overview | `19:59`, `2.19 km`, `9'05"/km`, `139 bpm`, `122 W`, `137 spm` |
| Apple Fitness splits | `1 km 6:26`, `1 km 10:58`, remaining `0.20 km 2:32` |
| WorkoutKit plan | Available, plan type `Single goal workout`, goal `open`, zero planned steps |
| HealthKit activity rows | One `HKWorkoutActivity` row from `0.0 s` to `1199.5 s`, `2199.9 m` |
| Debug candidate status | `missing-required-evidence`, fallback `missingPlannedSteps, noRowLevelEvidence` |
| Current reconstructed interval output | Unavailable, with message that custom intervals require WorkoutKit plan and HealthKit distance/time evidence |

### Interpretation

This plain open run appears to be handled correctly for interval purposes: RunSignal has the summary, samples, route, events, power, cadence, and activity row evidence, but it does not invent custom workout intervals when there are no planned steps. The Apple Fitness screenshot shows normal splits, not custom intervals.

This case should stay as an open-run control. Future app behavior should keep plain open runs readable as workouts while leaving custom interval reconstruction absent or clearly unavailable.

## Evidence Status

| Evidence type | Stopped-early custom | Plain open run |
| --- | --- | --- |
| Apple Fitness overview screenshot | Collected | Collected |
| Apple Fitness interval/split screenshot | Collected | Collected |
| RunSignal Raw HealthKit Debug export | Collected | Collected |
| RunSignal JSON payload | Collected | Collected |
| FIT export | Found in Drive archive and copied locally: `2026-06-14-075237-Outdoor Running-Adriels Apple Watch.fit` | Found in Drive archive and copied locally: `2026-06-14-081105-Outdoor Running-Adriels Apple Watch.fit` |
| Monthly diagnostics refresh | Not done in this pass | Not done in this pass |
| App behavior change | Narrow normal-detail gate added for one stopped-early fixed-distance Work row only | No custom interval behavior change |

## Follow-Up Plan

1. Continue collecting additional stopped-early custom examples before broadening the rule beyond the single fixed-distance Work shape.
2. Keep the stopped-early rule separate from broad simple Work/Open promotion, repeat-block promotion, and Open/Extra tail promotion.
3. Keep plain open Watch runs as readable workouts with splits and analysis, but no custom interval reconstruction when WorkoutKit exposes zero planned steps.
4. Treat deeper interval analytics as blocked until supported workout structures are read correctly across custom, stopped-early, repeat-block, tail, paused, and open-run controls.
