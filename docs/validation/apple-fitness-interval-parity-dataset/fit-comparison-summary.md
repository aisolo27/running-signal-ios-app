# HealthFit FIT Comparison Pilot Summary

Status: docs/debug pilot complete for the packet-backed running fixture set.

FIT files are research evidence only. They are not production truth, not an app import path, not a HealthFit dependency, and not a replacement for Apple Fitness screenshots/manual rows as the visual compatibility reference.

## Sources

- RunSignal parity packets: public HealthKit/WorkoutKit evidence and current RunSignal reconstruction.
- Apple Fitness/manual rows: visible Apple Fitness compatibility reference typed from screenshots.
- HealthFit FIT exports: transformed third-party export used only as a debugging microscope.

Parsing note: this pilot used a one-off local `fitparse` read from an existing cache outside this repo. No FIT parser script, package dependency, Swift source, app runtime logic, or production import path was added.

## Matched FIT Files

All eight packet-backed fixture dates have a matching `Outdoor Running` FIT archive.

| Date | Fixture folder | Archived FIT | Original HealthFit filename | Match basis |
|---|---|---|---|---|
| 2026-04-28 | `2026-04-28-easy-run/` | `exports/healthfit-fit/healthfit-2026-04-28.fit` | `2026-04-28-074452-Outdoor Running-Adriel's Apple Watch.fit` | Date, UTC start `11:44:52`, duration `46:32`, distance `7.305 km`, plan `Tuesday Easy 7.25km`. |
| 2026-05-26 | `2026-05-26-easy-run/` | `exports/healthfit-fit/healthfit-2026-05-26.fit` | `2026-05-26-073621-Outdoor Running-Adriel's Apple Watch.fit` | Date, UTC start `11:36:21`, duration `42:53`, distance `6.551 km`, plan `Tuesday Easy 6.45km`. |
| 2026-06-01 | `2026-06-01-easy-run/` | `exports/healthfit-fit/healthfit-2026-06-01.fit` | `2026-06-01-075129-Outdoor Running-Adriel's Apple Watch.fit` | Date, UTC start `11:51:29`, duration `42:51`, distance `6.463 km`, plan `Monday easy 6.45km`. |
| 2026-06-02 | `2026-06-02-easy-run/` | `exports/healthfit-fit/healthfit-2026-06-02.fit` | `2026-06-02-075150-Outdoor Running-Adriel's Apple Watch.fit` | Date, UTC start `11:51:50`, duration `36:43`, distance `5.709 km`, plan `Tuesday Easy 5.65km`. |
| 2026-06-03 | `2026-06-03-interval-workout/` | `exports/healthfit-fit/healthfit-2026-06-03.fit` | `2026-06-03-074508-Outdoor Running-Adriel's Apple Watch.fit` | Date, UTC start `11:45:08`, duration `38:57`, distance `6.668 km`, plan `Wednesday Interval (7.5km)`, eight FIT laps matching the structured workout. |
| 2026-06-04 | `2026-06-04-easy-recovery-run/` | `exports/healthfit-fit/healthfit-2026-06-04.fit` | `2026-06-04-074706-Outdoor Running-Adriel's Apple Watch.fit` | Date, UTC start `11:47:06`, duration `36:57`, distance `5.702 km`, plan `Thursday Recovery 5.65k`. |
| 2026-06-05 | `2026-06-05-tempo-threshold-run/` | `exports/healthfit-fit/healthfit-2026-06-05.fit` | `2026-06-05-075353-Outdoor Running-Adriel's Apple Watch.fit` | Date, UTC start `11:53:53`, duration `38:16`, distance `6.962 km`, plan `Friday Tempo 6.5km`. |
| 2026-06-12 | `2026-06-12-easy-run/` | `exports/healthfit-fit/healthfit-2026-06-12.fit` | `2026-06-12-074954-Outdoor Running-Adriel's Apple Watch.fit` | Date, UTC start `11:49:54`, duration `32:21`, distance `5.045 km`, plan `Friday Easy 5km`. |

## Unmatched Or Excluded FIT Files

| File | Action | Reason |
|---|---|---|
| `2026-06-03-082505-Outdoor Running-Adriel's Apple Watch.fit` | Archived as `2026-06-03-interval-workout/exports/healthfit-fit/healthfit-2026-06-03-candidate-2.fit`. | Same date but does not match the fixture: UTC start `12:25:05`, duration `6:29`, distance `1.015 km`, no workout steps. Treat as unmatched candidate evidence only. |
| `2026-05-26-142229-Strength Training-Strong.fit` | Excluded. | Same fixture date but not a running workout. |
| `2026-06-04-132440-Strength Training-Strong.fit` | Excluded. | Same fixture date but not a running workout. |
| `2026-06-05-131119-Strength Training-Strong.fit` | Excluded. | Same fixture date but not a running workout. |

## Whole Workout Totals

FIT session totals agree with the RunSignal parity packet totals to rounding. This supports RunSignal's HealthKit summary math for start time, duration, distance, average/max heart rate, cadence, and power.

| Date | Plan | FIT total | RunSignal total | Distance delta | Duration delta | FIT avg/max HR | RunSignal avg/max HR | FIT cadence/power | RunSignal cadence/power |
|---|---|---|---|---:|---:|---|---|---|---|
| 2026-04-28 | Tuesday Easy 7.25km | 7.305 km / 46:32 / 6:22/km | 7.305 km / 46:32 / 6:22/km | -0.01 m | -0.001 s | 133/145 | 133.3/145 | 174.6 spm / 192 W | 175.0 spm / 191.8 W |
| 2026-05-26 | Tuesday Easy 6.45km | 6.551 km / 42:53 / 6:33/km | 6.551 km / 42:53 / 6:33/km | -0.00 m | -0.000 s | 132/142 | 131.5/142 | 176.0 spm / 186 W | 176.1 spm / 186.0 W |
| 2026-06-01 | Monday easy 6.45km | 6.463 km / 42:51 / 6:38/km | 6.463 km / 42:51 / 6:38/km | -0.00 m | -0.000 s | 129/144 | 128.7/144 | 174.0 spm / 183 W | 174.1 spm / 183.3 W |
| 2026-06-02 | Tuesday Easy 5.65km | 5.709 km / 36:43 / 6:26/km | 5.709 km / 36:43 / 6:26/km | -0.00 m | -0.001 s | 131/147 | 131.3/147 | 175.5 spm / 189 W | 175.6 spm / 188.7 W |
| 2026-06-03 | Wednesday Interval (7.5km) | 6.668 km / 38:57 / 5:50/km | 6.668 km / 38:57 / 5:50/km | -0.01 m | -0.001 s | 150/185 | 150.0/185 | 165.8 spm / 204 W | 166.7 spm / 204.1 W |
| 2026-06-04 | Thursday Recovery 5.65k | 5.702 km / 36:57 / 6:29/km | 5.702 km / 36:57 / 6:29/km | -0.00 m | -0.000 s | 127/141 | 126.7/141 | 176.7 spm / 187 W | 176.6 spm / 187.4 W |
| 2026-06-05 | Friday Tempo 6.5km | 6.962 km / 38:16 / 5:30/km | 6.962 km / 38:16 / 5:30/km | -0.00 m | -0.001 s | 151/178 | 151.3/178 | 182.5 spm / 218 W | 182.6 spm / 218.3 W |
| 2026-06-12 | Friday Easy 5km | 5.045 km / 32:21 / 6:25/km | 5.045 km / 32:21 / 6:25/km | -0.01 m | -0.001 s | 127/139 | 127.2/139 | 174.3 spm / 187 W | 174.5 spm / 187.4 W |

## FIT Lap And Interval Evidence

FIT exposes `workout_step` and `lap` messages for the planned workout steps. It does not expose explicit Apple Fitness-style Open rows in this pilot. Open tails are visible only by subtracting the sum of FIT lap distances/times from FIT session totals.

| Date | FIT lap messages | FIT step messages | FIT event messages | Open/tail exposure |
|---|---:|---:|---:|---|
| 2026-04-28 | 1 | 1 | 2 | No explicit Open lap; session-minus-lap tail is 46.81 m / 0:20. |
| 2026-05-26 | 1 | 1 | 2 | No explicit Open lap; session-minus-lap tail is 94.01 m / 0:41. |
| 2026-06-01 | 1 | 1 | 2 | No explicit Open lap; session-minus-lap tail is 5.14 m / 0:07. |
| 2026-06-02 | 1 | 1 | 2 | No explicit Open lap; session-minus-lap tail is 57.71 m / 0:28. |
| 2026-06-03 | 8 | 5 | 2 | FIT laps cover Warmup, three Work rows, three Recovery rows, and planned open Cooldown. No separate Open row. |
| 2026-06-04 | 1 | 1 | 2 | No explicit Open lap; session-minus-lap tail is 44.78 m / 0:21. |
| 2026-06-05 | 3 | 3 | 2 | No explicit Open lap; session-minus-lap tail is 465.24 m / 2:40. |
| 2026-06-12 | 1 | 1 | 2 | No explicit Open lap; session-minus-lap tail is 36.87 m / 0:17. |

The only FIT event messages observed for the matched files were workout start and session stop. The useful boundary evidence is in `lap` records, not in separate pause/resume or boundary event records.

## Row-Level Comparison

FIT lap rows align more closely with Apple Fitness/manual rows than RunSignal's current public cumulative-distance crossing boundary in several known drift cases. Because FIT is a transformed HealthFit export, this is evidence to investigate, not production truth.

| Date | Row | Apple/manual | RunSignal | FIT lap or inferred tail | FIT read |
|---|---:|---|---|---|---|
| 2026-04-28 | 1 | Work 7.25 km / 46:12 | Work 7.256 km / 46:09 | FIT lap 7.258 km / 46:12 | FIT is within 0.1 s of Apple and 3.1 s later than RunSignal. |
| 2026-04-28 | 2 | Open 46 m / 0:20 | Open 48 m / 0:23 | FIT inferred tail 46.81 m / 0:20 | FIT inferred tail matches Apple more closely. |
| 2026-05-26 | 1 | Work 6.45 km / 42:11 | Work 6.454 km / 42:07 | FIT lap 6.457 km / 42:11 | FIT is within 0.3 s of Apple and 3.8 s later than RunSignal. |
| 2026-05-26 | 2 | Open 94 m / 0:41 | Open 97 m / 0:45 | FIT inferred tail 94.01 m / 0:41 | FIT inferred tail matches Apple more closely. |
| 2026-06-01 | 1 | Work 6.45 km / 42:44 | Work 6.451 km / 42:38 | FIT lap 6.458 km / 42:44 | FIT is within 0.4 s of Apple and 5.2 s later than RunSignal. |
| 2026-06-01 | 2 | Open 5 m / 0:07 | Open 12 m / 0:13 | FIT inferred tail 5.14 m / 0:07 | FIT inferred tail matches Apple more closely. |
| 2026-06-02 | 1 | Work 5.65 km / 36:15 | Work 5.652 km / 36:13 | FIT lap 5.651 km / 36:15 | FIT is within 0.2 s of Apple and 2.2 s later than RunSignal. |
| 2026-06-02 | 2 | Open 57 m / 0:28 | Open 57 m / 0:30 | FIT inferred tail 57.71 m / 0:28 | FIT inferred tail matches Apple more closely, while RunSignal remains inside temporary tolerance. |
| 2026-06-03 | 1 | Warmup 2.00 km / 12:47 | Warmup 2.001 km / 12:42 | FIT lap 2.000 km / 12:47 | FIT is within 0.3 s of Apple and 4.9 s later than RunSignal. |
| 2026-06-03 | 2 | Work 1.00 km / 4:12 | Work 1.002 km / 4:12 | FIT lap 1.000 km / 4:12 | FIT, Apple, and RunSignal are all close. |
| 2026-06-03 | 3 | Recovery 209 m / 2:30 | Recovery 218 m / 2:30 | FIT lap 210 m / 2:29 | FIT is close to Apple distance and one second shorter than both Apple and RunSignal. |
| 2026-06-03 | 4 | Work 1.00 km / 4:06 | Work 1.002 km / 4:06 | FIT lap 1.000 km / 4:06 | FIT, Apple, and RunSignal are all close. |
| 2026-06-03 | 5 | Recovery 207 m / 2:30 | Recovery 210 m / 2:30 | FIT lap 207 m / 2:30 | FIT is close to Apple. |
| 2026-06-03 | 6 | Work 1.00 km / 4:00 | Work 1.004 km / 4:01 | FIT lap 1.000 km / 4:00 | FIT is close to Apple. |
| 2026-06-03 | 7 | Recovery 197 m / 2:30 | Recovery 199 m / 2:30 | FIT lap 197 m / 2:30 | FIT is close to Apple. |
| 2026-06-03 | 8 | Cooldown 1.03 km / 6:22 | Cooldown 1.032 km / 6:25 | FIT lap 1.031 km / 6:22 | FIT is close to Apple. |
| 2026-06-04 | 1 | Work 5.65 km / 36:36 | Work 5.653 km / 36:34 | FIT lap 5.657 km / 36:36 | FIT is within 0.4 s of Apple and 1.3 s later than RunSignal. |
| 2026-06-04 | 2 | Open 44 m / 0:21 | Open 42 m / 0:22 | FIT inferred tail 44.78 m / 0:21 | FIT inferred tail matches Apple more closely, while RunSignal remains close. |
| 2026-06-05 | 1 | Warmup 2.00 km / 12:30 | Warmup 2.006 km / 12:27 | FIT lap 2.000 km / 12:30 | FIT is within 0.1 s of Apple and 3.5 s later than RunSignal. |
| 2026-06-05 | 2 | Work 2.00 km / 8:30 | Work 2.009 km / 8:32 | FIT lap 2.000 km / 8:30 | FIT is within 0.5 s of Apple and 1.5 s earlier than RunSignal. |
| 2026-06-05 | 3 | Cooldown 2.49 km / 14:36 | Cooldown 2.508 km / 14:40 | FIT lap 2.497 km / 14:36 | FIT is close to Apple time and between Apple and RunSignal distance. |
| 2026-06-05 | 4 | Open 453 m / 2:40 | Open 440 m / 2:38 | FIT inferred tail 465.24 m / 2:40 | FIT time matches Apple; distance is higher than both Apple and RunSignal. |
| 2026-06-12 | 1 | Work 5.00 km / 32:03 | Work 5.002 km / 31:59 | FIT lap 5.008 km / 32:03 | FIT is within 0.4 s of Apple and 4.8 s later than RunSignal. |
| 2026-06-12 | 2 | Open 36 m / 0:17 | Open 43 m / 0:22 | FIT inferred tail 36.87 m / 0:17 | FIT inferred tail matches Apple more closely. |

## Interpretation

- Whole workout totals: FIT agrees with RunSignal. This supports RunSignal's public HealthKit workout summary math and does not reveal a total-distance, total-duration, average-HR, max-HR, cadence, or power bug.
- Planned Work/Open rows: FIT lap rows and inferred tails usually agree more closely with Apple Fitness/manual rows than with RunSignal's current public cumulative-distance crossing boundary.
- Laps/splits: FIT exposes useful planned-step lap records with `wkt_step_index`, intensity, distance/time, cadence, power, calories, and step UUID-like developer fields. This is useful debugging evidence.
- Events: FIT did not expose extra boundary events in this pilot beyond timer start and session stop. The useful evidence came from lap rows.
- Open rows: FIT did not expose Open tails as explicit interval rows for the single-step or tempo examples. Open evidence is inferred from session-minus-lap totals and must not be treated as an oracle.
- Apple Fitness private/presentation logic: FIT's close agreement with Apple row timing suggests HealthFit is exporting Apple Watch/Apple Health lap or workout-step boundaries that are closer to Apple Fitness display timing than RunSignal's current public distance-sample crossing. This supports further investigation, but does not prove a public API feature that RunSignal can safely use at runtime.
- RunSignal bugs: no new RunSignal bug is proven. The pilot strengthens the existing boundary-timing research question and confirms that RunSignal whole-workout totals are correct.
- Future validation usefulness: FIT is useful enough to keep as a docs/debug cross-check for archived fixture analysis, especially for step lap timing. It remains low-priority for production because it is transformed export evidence and not a product data source.

## Classification

| Mismatch type | Pilot classification |
|---|---|
| RunSignal totals vs FIT totals | No bug found; values match to rounding. |
| RunSignal row boundaries vs Apple Fitness | Existing boundary mismatch remains; FIT often sides with Apple row timing. |
| RunSignal Work/Open tail split vs FIT | FIT suggests a later planned-step lap boundary and a shorter inferred Open tail in drift cases. |
| Apple Fitness presentation/private logic | Plausible; FIT likely reflects Apple Watch/HealthFit transformed lap boundaries, but it cannot identify a production-safe public API separator. |
| HealthFit/FIT export transformation | Always possible; do not treat FIT as an oracle. |
| Missing evidence | Still missing a production-safe public-API feature that separates drift cases from guard cases. |
| Production action | None approved. |

## Guardrails

- Do not add production FIT import.
- Do not add HealthFit as a dependency.
- Do not change app runtime behavior.
- Do not change fixed-distance boundary logic from FIT alone.
- Do not promote reconstructed intervals into normal UI from FIT alone.
- Do not use FIT as runtime truth.
- Do not replace Apple Fitness/manual rows as the visual compatibility reference.
- Do not approve a candidate boundary strategy from this pilot.
