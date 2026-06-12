# Apple Fitness Interval Parity Analysis Summary

Analysis date: 2026-06-11
Updated: 2026-06-12

## Evidence Reviewed

| Date | Workout | Apple Fitness evidence | RunSignal evidence | Validation usefulness |
|---|---|---|---|---|
| 2026-04-28 | Easy run | `IMG_6982.PNG`, `IMG_6983.PNG` | `exports/runsignal-diagnostics/runsignal-raw-healthkit-debug-2026-04-28.md`, `exports/runsignal-diagnostics/runsignal-parity-packet-2026-04-28.json` | Fresh physical-device evidence recovered; temporary pass candidate |
| 2026-05-26 | Easy run | `IMG_6980.PNG`, `IMG_6981.PNG` | `exports/runsignal-diagnostics/text-6D5CCBA82A13-1.txt` | Useful boundary-research sample, blocked |
| 2026-06-01 | Easy run | `IMG_6968.PNG`, `IMG_6969.PNG` | `exports/runsignal-diagnostics/new text-795E821D968D-1.txt` plus older copied export | Useful, but blocked |
| 2026-06-02 | Easy run | `IMG_6970.PNG`, `IMG_6971.PNG` | `screenshots/runsignal-raw-healthkit-debug/text-B1E5770683EF-1.txt` | Pass |
| 2026-06-03 | Interval workout | `IMG_6972.PNG`, `IMG_6973.PNG` | `exports/runsignal-diagnostics/text-340B7765A007-1.txt` plus older screenshot export | Strongest structured sample, temporary pass after targeted code refinement |
| 2026-06-04 | Easy/recovery run | `IMG_6974.PNG`, `IMG_6975.PNG` | `screenshots/runsignal-raw-healthkit-debug/text-43A9773F2CFB-1.txt` | Pass |
| 2026-06-05 | Tempo/threshold run | `IMG_6976.PNG`, `IMG_6977.PNG` | `screenshots/runsignal-raw-healthkit-debug/text-CF0A7AF3AD53-1.txt` | Useful, temporary pass |
| 2026-06-12 | Easy run | `IMG_6999.PNG` | `exports/runsignal-diagnostics/text-973BFDCDC777-1.txt` | Useful boundary-research sample, blocked |

## Main Findings

- The screenshots are enough to validate visible Apple Fitness interval rows for the reviewed workouts. No manual typing is needed for this pass.
- Most RunSignal raw debug export files are parseable and contain the needed WorkoutKit reconstructed interval rows.
- 2026-04-28 is no longer evidence unavailable. Physical-device force re-enrich recovered the WorkoutKit plan `Tuesday Easy 7.25km`, rich HealthKit samples, route data, reconstructed Work/Open rows, and boundary diagnostics.
- HealthKit Segment Markers are present in the exports, but the debug source states they are not used as Apple Fitness interval rows.
- Apple documentation confirms the public WorkoutKit and HealthKit model shape, but does not confirm Apple Fitness's exact row-boundary or row-label rendering algorithm.
- Current evidence contract: WorkoutKit is the planned structure source, HealthKit samples are the measured stats source, Apple Fitness screenshots are the visual parity reference, RunSignal Raw HealthKit Debug exports are RunSignal evidence, and HealthKit Segment Markers remain raw/debug-only.
- 2026-06-02 and 2026-06-04 validate the simple distance-goal Work plus Open tail pattern well.
- 2026-06-03 validates most interval rows well: Work and Recovery rows are close, recovery times are exact, and recovery distances are within tolerance.
- 2026-06-01 still has a roughly 6-second boundary mismatch: RunSignal Work ends early and Open / Extra becomes too long. The fresh export now shows the 6.45 km crossing sample end is at 42:38.318, while the final distance sample is at 42:43.464 and the workout ends at 42:50.972.
- 2026-05-26 repeats the same drift direction as June 1: Apple Fitness Work is 42:11, RunSignal Work is 42:07, and Open / Extra becomes about 4 seconds too long.
- 2026-06-12 repeats the same drift direction at a 5.00 km goal: Apple Fitness Work is 32:03, RunSignal Work is 31:59, and Open / Extra becomes about 5 seconds too long.
- 2026-06-01 human context: the Apple Fitness Open row is real because the runner completed the 6.45 km Work goal and kept running briefly before stopping the watch. Open / Extra after a fixed-distance Work goal is not automatically wrong, and June 1 Open should not be hidden or merged into Work.
- June 1, May 26, and June 12 should stay blocked. The diagnostics show RunSignal's boundary is internally consistent in all three usable drift cases, so the evidence supports research scoring but still does not approve a deterministic production rule.
- 2026-06-03 label/structure blocker is resolved by the targeted open-cooldown rule: if WorkoutKit exposes a final planned `Cooldown` step with goal `open`, RunSignal keeps the planned `Cooldown` label and extends that row to workout end.
- The June 3 fix is not evidence that post-cooldown activity should always merge into `Cooldown`. Fixed distance/time cooldowns that complete and are followed by continued running should still create `Open / Extra`.
- 2026-06-05 is close overall, but warmup/cooldown boundaries are still temporary passes rather than preferred passes. The displayed cooldown distance differs by roughly 18 m.

## Missing Or Misplaced Items

- No Apple Fitness screenshots are missing for this set.
- No RunSignal exports are missing for this set.
- 2026-04-28 retains the older zero-evidence export for history, but the current physical-device raw debug export and parity packet contain usable WorkoutKit, sample, interval, route, and boundary evidence.
- The 2026-06-01 RunSignal export was originally misplaced under `screenshots/runsignal-workout-detail/`. It has now been copied into `exports/runsignal-diagnostics/` for a consistent dataset layout; the original remains in place.
- The exported text files are easier to analyze than screenshots and should remain the preferred RunSignal evidence format.

## Blocker Table

| Date | Workout Type | Current Status | Blocker | Next Action |
|---|---|---|---|---|
| 2026-04-28 | Easy run | temporary pass | Physical-device force re-enrich recovered rich HealthKit evidence and WorkoutKit plan data. RunSignal Work is about 3.2 seconds earlier than Apple Fitness, and Open / Extra is about 3.0 seconds longer. | Keep as evidence-recovery and fresh-query/cache-invalidation fixture. Do not use as a main repeated-interval boundary tuning fixture. |
| 2026-05-26 | Easy run | blocked | RunSignal Work ends about 4 seconds earlier than Apple Fitness, and Open / Extra becomes about 4 seconds too long. This repeats the June 1 drift direction for fixed-distance Work plus real Open tail. | Keep as boundary-research evidence. Do not add a deterministic rule yet; collect more examples and protect existing pass/temporary-pass fixtures. |
| 2026-06-01 | Easy run | blocked | RunSignal Work ends about 5.7 seconds earlier than Apple Fitness, and Open / Extra becomes about 5.7 seconds too long. Fresh diagnostics show Apple Fitness may be using a later private/sensor-end boundary near the final distance sample, not the exact 6.45 km crossing. The Apple Fitness Open row is real post-goal running, so the blocker is boundary timing, not the existence of Open. There is not enough evidence for a deterministic rule. | Do not add a deterministic boundary rule yet. Collect more fixed-distance Work + real Open tail examples before considering any final-sample or tail-shrink rule. |
| 2026-06-02 | Easy run | pass | None. Simple Work + Open tail parity holds. | Keep as a regression fixture. |
| 2026-06-03 | Interval workout | temporary pass | Label/structure blocker resolved and fresh export confirms the final row is `Cooldown`. Warmup remains about 5 seconds early, and the final planned open cooldown is about 3 seconds longer than Apple Fitness. | Keep as a regression fixture for planned open cooldown behavior. |
| 2026-06-04 | Easy/recovery run | pass | None. Simple Work + Open tail parity holds. | Keep as a regression fixture. |
| 2026-06-05 | Tempo/threshold run | temporary pass | Warmup/cooldown are close but not preferred; cooldown displayed distance differs by about 18 m. | Preserve as a temporary pass and investigate whether the difference is rounding, boundary strategy, display formatting, sample granularity, or unavailable Apple Fitness-private handling. |
| 2026-06-12 | Easy run | blocked | RunSignal Work ends about 4 seconds earlier than Apple Fitness, and Open / Extra becomes about 5 seconds too long. This repeats the same drift direction at a 5.00 km goal. | Keep as boundary-research evidence. Score candidate strategies with June 12 included, but do not change production logic yet. |

## Tail Labeling Policy

WorkoutKit planned steps define the planned structure.

If the final planned step is `Cooldown` and its WorkoutKit goal is `open`, the cooldown has no fixed goal to complete. RunSignal should keep the planned `Cooldown` label and extend that row to workout end instead of creating a generic `Open / Extra` tail.

If a planned Cooldown has a distance or time goal and that goal is completed, any meaningful remaining activity after that completed cooldown should be labeled `Open / Extra`. Do not merge post-cooldown activity into `Cooldown` by default.

Only hide or merge a final tail when it is clearly just a tiny reconstruction artifact below threshold, Apple Fitness does not show a separate `Open` row, and hiding or merging improves parity across the dataset.

If Apple Fitness shows a separate `Open` row, RunSignal should show `Open / Extra`.

If Apple Fitness shows `Cooldown`, investigate whether RunSignal ended the cooldown boundary too early or whether the WorkoutKit plan contains an open cooldown step. Do not assume the fix is relabeling `Open / Extra` as `Cooldown`.

If uncertain, keep `Open / Extra` in debug, add a diagnostic reason, and do not promote the behavior into the normal UI.

## Focused Diagnostics

### 2026-06-01 Boundary Investigation

| Diagnostic | Current evidence |
|---|---|
| Planned Work goal | WorkoutKit `Work - goal 6.45 km`, heart rate zone 2 |
| Apple Fitness Work time | 42:44 |
| RunSignal Work time | 42:38.318 |
| Apple Fitness Open time | 0:07 |
| RunSignal Open / Extra time | 12.654 s |
| Boundary strategy used | crossing sample end |
| Boundary adjustment seconds | +0.248 s from interpolated crossing |
| Overshoot meters | 0.635 m |
| Distance sample count | 997 |
| Previous distance sample before boundary | 42:33-42:36, 6438.0 m to 6444.0 m cumulative |
| Crossing distance sample | 42:36-42:38, 6444.0 m to 6450.6 m cumulative |
| Next distance sample after boundary | 42:38-42:41, 6450.6 m to 6457.7 m cumulative |
| Final distance sample timing | 42:43.464, 6463.0 m cumulative |
| Last HR/power/cadence sample timing | HR 42:46.725; power 42:48.609; cadence 42:48.609 |
| Remaining tail seconds/meters | 12.654 s / 12.346 m |

Current interpretation: the issue is not label policy and not the existence of Open. It is a boundary placement difference on a long distance-goal Work row. Because overshoot is tiny and crossing sample end only adds 0.248 s, RunSignal's current 6.45 km boundary is internally consistent. Apple Fitness's 42:44 Work / 0:07 Open split lines up more closely with the final distance sample timing and workout end than with the exact 6.45 km crossing. That may reflect custom workout step-transition timing, final sample timing, private workout-session timing, sensor-end behavior, smoothing, or sample granularity unavailable through current public WorkoutKit/HealthKit samples. Do not add a deterministic boundary rule from this single workout unless it preserves June 2 and June 4.

## Distance-goal Boundary Drift Research

### Current Drift Samples

| Date | Apple Work | RunSignal Work | Drift | Current read |
|---|---:|---:|---:|---|
| 2026-06-01 | 42:44 | about 42:38 | about 5-6s | Blocked; RunSignal exact crossing is internally consistent but earlier than Apple Fitness. |
| 2026-05-26 | 42:11 | 42:07 | about 4s | Blocked; repeats the same drift direction as June 1. |
| 2026-06-12 | 32:03 | 31:59 | about 4s | Blocked; repeats the same drift direction at a 5.00 km goal. |

Fixed-distance Work plus real Open tail now repeats the same boundary drift direction across at least two goal distances: 6.45 km and 5.00 km. Apple Fitness may be using a later step-completion boundary than RunSignal's public HealthKit cumulative-distance crossing. Do not hide or merge Open: these Open rows are real post-goal running. More evidence and pass-case diagnostics are needed before changing app logic.

The research-only analyzer in `analyze_fixed_distance_boundaries.py` currently shows next-sample-end improves June 1, May 26, and June 12 but does not fully explain Apple Fitness. Apple-visible Open alignment fits by definition and is not production-safe. Final-distance-sample anchoring appears overfit and does not explain May 26 or June 12. Segment markers remain diagnostic-only and are not a production interval source.

### June 1 Exact Diagnostics

| Diagnostic | Value |
|---|---|
| Planned Work goal | 6.45 km |
| RunSignal boundary | 42:38.318 |
| RunSignal boundary strategy | crossing sample end |
| RunSignal boundary adjustment | +0.248 s from interpolated crossing |
| RunSignal overshoot | 0.635 m |
| Apple Fitness Work row | 42:44 / 6.45 km |
| Apple Fitness Open row | 0:07 / 5 m |
| RunSignal Open / Extra row | 12.654 s / 12.346 m |
| Final distance sample | 42:43.464 / 6463.0 m cumulative |
| Workout end | 42:50.972 |
| Last HR sample | 42:46.725 |
| Last power/cadence sample | 42:48.609 |

RunSignal's interpolation/crossing logic appears internally valid for this workout. The crossing sample covers 42:36-42:38 and moves from 6444.0 m to 6450.6 m cumulative. The planned 6450 m target falls inside that sample, and choosing the crossing sample end creates only 0.635 m of overshoot. That is a small, coherent distance-goal boundary rather than evidence of a simple off-by-one sample or tail-label bug.

Apple Fitness appears to place the visible Work/Open split later than the public distance crossing. Its 42:44 Work row is closer to the final distance sample at 42:43.464, while the 0:07 Open row is closer to the remaining time from that area to the 42:50.972 workout end. This may mean Apple Fitness uses private workout-session timing, final distance sample timing, sensor-end behavior, smoothing, or display rules that are not exposed directly through public WorkoutKit or HealthKit samples.

Do not tune RunSignal from this one workout. A final-sample, sensor-end, or tail-shrink rule could make June 1 look better while regressing June 2 and June 4, which already pass for simple fixed-distance Work + Open tail workouts. June 1 should remain a blocked research case until repeated examples show the same drift pattern and the rule can be tested against the rest of the fixture.

Future examples needed:

- Fixed-distance Work step.
- Visible Apple Fitness Work row.
- Visible Apple Fitness Open row.
- Goal completed and runner continued briefly before stopping.
- RunSignal Raw HealthKit Debug export with boundary diagnostics.
- Preferably multiple distances, such as 5K Work, 6.45K Work, 2K Work, or 400 m / 800 m reps with an Open tail.

### May 26 Exact Diagnostics

| Diagnostic | Value |
|---|---|
| Planned Work goal | 6.45 km |
| RunSignal boundary | 42:07.467 |
| RunSignal boundary strategy | crossing sample end |
| RunSignal boundary adjustment | +1.5 s |
| RunSignal overshoot | 4.2 m |
| Apple Fitness Work row | 42:11 / 6.45 km |
| Apple Fitness Open row | 0:41 / 94 m |
| RunSignal Open / Extra row | 45.215 s / 97.228 m |
| Final distance sample | 42:46.057 / 6551.5 m cumulative |
| Workout end | 42:52.682 |

May 26 supports the boundary drift research because it repeats the same direction as June 1. It still should not drive a rule by itself.

### June 12 Exact Diagnostics

| Diagnostic | Value |
|---|---|
| Planned Work goal | 5.00 km |
| RunSignal boundary | 31:58.547 |
| RunSignal boundary strategy | crossing sample end |
| RunSignal boundary adjustment | +0.606 s |
| RunSignal overshoot | 1.584 m |
| Apple Fitness Work row | 32:03 / 5.00 km |
| Apple Fitness Open row | 0:17 / 36 m |
| RunSignal Open / Extra row | 22.210 s / 43.233 m |
| Final distance sample | 32:13.983 / 5044.8 m cumulative |
| Workout end | 32:20.757 |
| Last HR sample | 32:20.133 |
| Last power sample | 32:16.555 |
| Last cadence sample | 32:19.128 |

June 12 supports the boundary drift research because it repeats the same direction at a 5.00 km goal. It strengthens the case that the issue is not isolated to one 6.45 km workout, but it still should not drive a production rule without pass-case protection.

### April 28 Evidence Recovery Fixture

Apple Fitness shows Work 7.25 km / 46:12 and Open 46 m / 0:20. The physical-device force re-enrich on 2026-06-12 now produces a parity comparison.

Current RunSignal evidence:

- WorkoutKit plan status: available.
- WorkoutKit display name: `Tuesday Easy 7.25km`.
- Plan: no warmup, one 7.25 km Work step, pace target 6:00-6:30/km, no cooldown.
- Evidence counts: heart rate 554, speed 1083, distance 1082, active energy 1085, power 1083, cadence 1083, step count 1083, stride length 513, vertical oscillation 512, ground contact 512, route points 2792, top-level events 14.
- Force re-enrich result: authorized, invalidated cache, fresh query returned workout, no diagnostics warnings.
- Work 1: 7256.3 m / 46:09, crossing sample end, +2.2 s adjustment, 6.3 m overshoot.
- Open / Extra: 48.3 m / 0:23.

The previous April 28 failure was likely cache/enrichment/query-path related, but stale cache is not proven because `cacheWasPresent` was false during force re-enrich. The important conclusion is that the physical-device fresh query path retrieves the needed HealthKit samples, WorkoutKit plan, route data, and reconstructed rows.

Event count note: the top-level evidence count reports 14 raw attached events. The force re-enrich result reports 13 events because that result uses the summarized segment/lap `CanonicalWorkout.intervalCount`; the raw segment-marker table also renders 13 valid in-workout marker rows. This is expected diagnostics behavior, not a production interval behavior change.

### 2026-06-05 Warmup/Cooldown Investigation

| Diagnostic | Current evidence |
|---|---|
| Warmup | Apple 2.00 km / 12:30; RunSignal 2.006 km / 12:26.609; crossing sample end; +2.5 s adjustment; 5.5 m overshoot |
| Work | Apple 2.00 km / 8:30; RunSignal 2.009 km / 8:31.928; crossing sample end; +2.1 s adjustment; 8.6 m overshoot |
| Cooldown | Apple 2.49 km / 14:36; RunSignal 2.508 km / 14:39.837; crossing sample end; +2.5 s adjustment; 7.7 m overshoot |
| Open tail | Apple 453 m / 2:40; RunSignal 440.0 m / 2:37.762 |
| Distance sample count | 892 |

Current interpretation: this remains a temporary pass. The cooldown distance delta is mostly a displayed-distance mismatch at the planned cooldown boundary, while time remains within temporary tolerance. It may be Apple-style display rounding, boundary strategy, sample granularity, or a Fitness-private source. Do not tune only to June 5 if it harms June 1-4.

## Promotion Readiness

Do not promote WorkoutKit Reconstructed Intervals into the normal workout detail UI yet.

Before promotion, address or explicitly accept:

- 2026-06-01 distance-goal boundary drift of about 5.7 seconds.
- 2026-05-26 distance-goal boundary drift of about 4 seconds.
- 2026-06-12 distance-goal boundary drift of about 4 seconds.
- 2026-04-28 recovered evidence is a temporary pass candidate, but should remain an evidence-recovery fixture rather than a production boundary tuning fixture.
- 2026-06-05 warmup/cooldown temporary-pass boundaries, especially the cooldown displayed distance delta.
- Additional fixed-distance Work + real Open tail evidence before changing June 1 boundary logic.

The approach is directionally validated, and the June 3 planned-open-cooldown label blocker has a deterministic fix. Promotion should still wait because May 26, June 1, and June 12 remain blocked, while April 28 and June 5 remain temporary-pass or evidence-recovery fixtures rather than production tuning proof.
