# FIT Lap Boundary Source Investigation

Status: docs/debug investigation. No production behavior changed.

FIT files remain research evidence only. HealthKit/WorkoutKit remain RunSignal production truth, Apple Fitness/manual rows remain the visual compatibility reference, and HealthFit/FIT must not become runtime truth or a production dependency.

## Executive Summary

The FIT comparison pilot shows that HealthFit FIT `lap` rows often align with Apple Fitness/manual row timing more closely than RunSignal's current public HealthKit distance-sample crossing boundary. This investigation checked whether those FIT lap boundaries can be traced to public evidence already available in the archived RunSignal diagnostics.

Current answer: inconclusive, leaning not proven accessible from the existing RunSignal evidence. A new public-API lead, `HKWorkout.workoutActivities` / `HKWorkoutActivity`, is now exported for debug review but has not yet been evaluated on regenerated physical-device fixture exports.

- FIT `session` records match RunSignal whole-workout totals to rounding.
- FIT `lap` records map cleanly to planned WorkoutKit step order for simple Work rows and structured Warmup/Work/Recovery/Cooldown rows.
- FIT `event` records in this pilot only expose timer start and session stop. They do not expose the step boundary transitions that explain Apple Fitness row timing.
- Existing regenerated RunSignal exports contain raw HealthKit workout event timestamp inventory, but not the newly added `HKWorkoutActivity` inventory. Regenerate exports before reassessing source equivalence for activities.
- Saved Raw HealthKit Debug exports include derived HealthKit segment marker windows, but those segment markers do not cleanly or consistently align with FIT lap boundaries.
- FIT lap boundaries are often close to the next HealthKit distance sample end, but not consistently enough to explain Apple Fitness/FIT row timing or approve a boundary strategy.
- Public `HKWorkoutActivity` rows may expose additional sub-activity date windows, nested events, and per-activity statistics. This is a debug-only lead; it does not change the current production boundary rule.

This creates a worthwhile debug-only hypothesis: FIT laps may represent Apple Watch/HealthFit exported step-completion lap boundaries that are closer to Apple Fitness presentation timing than RunSignal's current sample-crossing reconstruction. It does not prove that RunSignal can access the same boundary timing from public APIs today.

No production boundary change is justified now.

## FIT Records Used

The pilot used these FIT record classes:

| FIT record | Used for | Finding |
|---|---|---|
| `session` | Whole-workout duration, distance, HR, cadence, power, and final total. | Matches RunSignal totals to rounding. |
| `lap` | Planned step rows: Work, Warmup, Recovery, Cooldown. | Main source of FIT/Apple row-timing agreement. |
| `workout_step` | Planned step definitions and order. | Maps to WorkoutKit planned step order, but not to actual boundary dates by itself. |
| `event` | Start/stop events. | Only timer start and session stop were observed; no useful step-boundary events. |
| `record` | Per-record samples present in FIT. | Not used for row-boundary decisions in this report. |
| `unknown_216` | HealthFit/FIT developer or unknown message. | Not interpreted; treated as transformed/export-specific. |

Record counts:

| Date | session | lap | workout_step | event | record | Other notable |
|---|---:|---:|---:|---:|---:|---|
| 2026-04-28 | 1 | 1 | 1 | 2 | 2792 | `unknown_216` |
| 2026-05-26 | 1 | 1 | 1 | 2 | 2573 | `unknown_216` |
| 2026-06-01 | 1 | 1 | 1 | 2 | 2571 | `unknown_216` |
| 2026-06-02 | 1 | 1 | 1 | 2 | 2203 | `unknown_216` |
| 2026-06-03 | 1 | 8 | 5 | 2 | 2337 | `unknown_216` |
| 2026-06-04 | 1 | 1 | 1 | 2 | 2217 | `unknown_216` |
| 2026-06-05 | 1 | 3 | 3 | 2 | 2297 | `unknown_216` |
| 2026-06-12 | 1 | 1 | 1 | 2 | 1941 | `unknown_216` |

## FIT vs Apple Fitness vs RunSignal Timing

Open rows are not explicit FIT lap rows in the simple Work/Open fixtures. For those rows, FIT tail evidence is inferred as:

```text
FIT session total - sum(FIT lap rows)
```

| Date | Row | Apple Fitness/manual | FIT lap or inferred tail | RunSignal current | FIT vs Apple | FIT vs RunSignal |
|---|---:|---|---|---|---:|---:|
| 2026-04-28 | 1 | Work 7.250 km / 46:12 | active 7.258 km / 46:12 | Work 1 7.256 km / 46:09 | -0.1s / +7.8m | +3.1s / +1.5m |
| 2026-04-28 | 2 | Open 46.0 m / 0:20 | inferred tail 46.8 m / 0:20 | Open / Extra 48.3 m / 0:23 | -0.1s / +0.8m | -3.1s / -1.5m |
| 2026-05-26 | 1 | Work 6.450 km / 42:11 | active 6.457 km / 42:11 | Work 1 6.454 km / 42:07 | +0.3s / +7.4m | +3.8s / +3.2m |
| 2026-05-26 | 2 | Open 94.0 m / 0:41 | inferred tail 94.0 m / 0:41 | Open / Extra 97.2 m / 0:45 | +0.4s / +0.0m | -3.8s / -3.2m |
| 2026-06-01 | 1 | Work 6.450 km / 42:44 | active 6.458 km / 42:44 | Work 1 6.451 km / 42:38 | -0.4s / +7.8m | +5.2s / +7.2m |
| 2026-06-01 | 2 | Open 5.0 m / 0:07 | inferred tail 5.1 m / 0:07 | Open / Extra 12.3 m / 0:13 | +0.4s / +0.1m | -5.2s / -7.2m |
| 2026-06-02 | 1 | Work 5.650 km / 36:15 | active 5.651 km / 36:15 | Work 1 5.652 km / 36:13 | -0.2s / +1.2m | +2.2s / -0.7m |
| 2026-06-02 | 2 | Open 57.0 m / 0:28 | inferred tail 57.7 m / 0:28 | Open / Extra 57.0 m / 0:30 | -0.2s / +0.7m | -2.2s / +0.7m |
| 2026-06-03 | 1 | Warmup 2.000 km / 12:47 | warmup 2.000 km / 12:47 | Warmup 2.001 km / 12:42 | +0.3s / +0.0m | +4.9s / -1.5m |
| 2026-06-03 | 2 | Work 1.000 km / 4:12 | active 1.000 km / 4:12 | Work 1 1.002 km / 4:12 | -0.2s / +0.0m | -0.3s / -1.9m |
| 2026-06-03 | 3 | Recovery 209.0 m / 2:30 | recovery 209.5 m / 2:29 | Recovery 1 218.1 m / 2:30 | -1.0s / +0.5m | -1.0s / -8.5m |
| 2026-06-03 | 4 | Work 1.000 km / 4:06 | active 1.000 km / 4:06 | Work 2 1.002 km / 4:06 | +0.2s / +0.0m | +0.0s / -1.7m |
| 2026-06-03 | 5 | Recovery 207.0 m / 2:30 | recovery 207.3 m / 2:30 | Recovery 2 210.2 m / 2:30 | -0.1s / +0.3m | -0.1s / -2.8m |
| 2026-06-03 | 6 | Work 1.000 km / 4:00 | active 1.000 km / 4:00 | Work 3 1.004 km / 4:01 | +0.5s / +0.0m | -0.5s / -4.0m |
| 2026-06-03 | 7 | Recovery 197.0 m / 2:30 | recovery 197.1 m / 2:30 | Recovery 3 199.1 m / 2:30 | -0.2s / +0.1m | -0.2s / -2.0m |
| 2026-06-03 | 8 | Cooldown 1.030 km / 6:22 | cooldown 1.031 km / 6:22 | Cooldown 1.032 km / 6:25 | +0.1s / +1.2m | -2.9s / -0.4m |
| 2026-06-04 | 1 | Work 5.650 km / 36:36 | active 5.657 km / 36:36 | Work 1 5.653 km / 36:34 | -0.4s / +7.2m | +1.3s / +4.3m |
| 2026-06-04 | 2 | Open 44.0 m / 0:21 | inferred tail 44.8 m / 0:21 | Open / Extra 42.0 m / 0:22 | -0.1s / +0.8m | -1.3s / +2.8m |
| 2026-06-05 | 1 | Warmup 2.000 km / 12:30 | warmup 2.000 km / 12:30 | Warmup 2.006 km / 12:27 | +0.1s / +0.0m | +3.5s / -5.5m |
| 2026-06-05 | 2 | Work 2.000 km / 8:30 | active 2.000 km / 8:30 | Work 1 2.009 km / 8:32 | +0.5s / +0.0m | -1.5s / -8.6m |
| 2026-06-05 | 3 | Cooldown 2.490 km / 14:36 | cooldown 2.497 km / 14:36 | Cooldown 2.508 km / 14:40 | -0.1s / +6.6m | -3.9s / -11.1m |
| 2026-06-05 | 4 | Open 453.0 m / 2:40 | inferred tail 465.2 m / 2:40 | Open / Extra 440.0 m / 2:38 | -0.3s / +12.2m | +2.0s / +25.2m |
| 2026-06-12 | 1 | Work 5.000 km / 32:03 | active 5.008 km / 32:03 | Work 1 5.002 km / 31:59 | +0.4s / +7.9m | +4.8s / +6.4m |
| 2026-06-12 | 2 | Open 36.0 m / 0:17 | inferred tail 36.9 m / 0:17 | Open / Extra 43.2 m / 0:22 | +0.4s / +0.9m | -4.8s / -6.4m |

## FIT Boundary vs HealthKit Segment Markers

The nearest saved HealthKit segment marker was found from Raw HealthKit Debug export JSON when available. Segment markers are raw/debug-only and do not expose Apple Fitness labels.

| Date | FIT boundary | FIT offset | Nearest HealthKit segment marker end | Delta | Marker kind/source | Marker window | Read |
|---|---|---:|---:|---:|---|---|---|
| 2026-04-28 | lap 1 active | 46:12 | 46:29 | +17.5s | overlappingSegmentMarker / healthKitSegmentPattern | 41:01-46:29, 860.3 m | Not aligned. |
| 2026-05-26 | lap 1 active | 42:11 | 42:04 | -7.7s | overlappingSegmentMarker / healthKitSegmentPattern | 31:29-42:04, 1.609 km | Not aligned. |
| 2026-06-01 | lap 1 active | 42:44 | 42:46 | +2.5s | rawSegmentMarker / healthKitSegmentPattern | 39:43-42:46, 456.8 m | Near, but marker is a raw tail-ish segment and not a clean planned-step boundary. |
| 2026-06-02 | lap 1 active | 36:15 | 36:38 | +23.5s | overlappingSegmentMarker / healthKitSegmentPattern | 30:49-36:38, 874.5 m | Not aligned. |
| 2026-06-03 | lap 1 warmup | 12:47 | 12:44 | -3.0s | overlappingSegmentMarker / healthKitSegmentPattern | 6:20-12:44, 1.001 km | Near sample range, but not clean. |
| 2026-06-03 | lap 2 active | 16:59 | 16:56 | -3.0s | overlappingSegmentMarker / healthKitSegmentPattern | 12:44-16:56, 1.004 km | Near sample range, but not clean. |
| 2026-06-03 | lap 3 recovery | 19:28 | 19:25 | -2.8s | overlappingSegmentMarker / healthKitSegmentPattern | 10:15-19:25, 1.608 km | Near sample range, but not clean. |
| 2026-06-03 | lap 4 active | 23:34 | 22:40 | -54.8s | splitMarker / healthKitSegmentPattern | 16:56-22:40, 998.4 m | Not aligned. |
| 2026-06-03 | lap 5 recovery | 26:04 | 27:41 | +96.5s | overlappingSegmentMarker / healthKitSegmentPattern | 19:25-27:41, 1.616 km | Not aligned. |
| 2026-06-03 | lap 6 active | 30:05 | 28:22 | -102.6s | overlappingSegmentMarker / healthKitSegmentPattern | 22:40-28:22, 1.001 km | Not aligned. |
| 2026-06-03 | lap 7 recovery | 32:35 | 34:53 | +138.5s | overlappingSegmentMarker / healthKitSegmentPattern | 28:22-34:53, 996.8 m | Not aligned. |
| 2026-06-03 | lap 8 cooldown | 38:57 | 38:54 | -2.5s | rawSegmentMarker / healthKitSegmentPattern | 34:53-38:54, 660.2 m | Near sample range, but not a clean planned open cooldown boundary. |
| 2026-06-04 | lap 1 active | 36:36 | 36:52 | +16.7s | overlappingSegmentMarker / healthKitSegmentPattern | 31:12-36:52, 867.3 m | Not aligned. |
| 2026-06-05 | lap 1 warmup | 12:30 | 12:27 | -3.4s | overlappingSegmentMarker / healthKitSegmentPattern | 6:10-12:27, 998.2 m | Near sample range, but not clean. |
| 2026-06-05 | lap 2 active | 21:01 | 20:58 | -2.8s | splitMarker / healthKitSegmentPattern | 16:43-20:58, 1.001 km | Near sample range, but not clean. |
| 2026-06-05 | lap 3 cooldown | 35:36 | 35:13 | -23.9s | overlappingSegmentMarker / healthKitSegmentPattern | 25:57-35:13, 1.610 km | Not aligned. |
| 2026-06-12 | lap 1 active | 32:03 | 32:01 | -2.9s | overlappingSegmentMarker / healthKitSegmentPattern | 25:31-32:01, 1000.0 m | Near sample range, but not a clean Work/Open boundary. |

Conclusion: existing segment marker windows do not map cleanly to FIT lap rows. Some are near a FIT boundary by a few seconds, but the pattern is inconsistent and many nearest markers are overlapping split-like windows rather than planned-step transitions.

## FIT Boundary vs Distance Sample Diagnostics

The parity packets do include public HealthKit distance-sample boundary diagnostics for distance-goal rows.

| Date | Row | FIT boundary | RunSignal crossing sample end | Next distance sample end | FIT vs crossing | FIT vs next |
|---|---:|---:|---:|---:|---:|---:|
| 2026-04-28 | 1 | 46:12 | 46:09 | 46:11 | +3.1s | +0.5s |
| 2026-05-26 | 1 | 42:11 | 42:07 | 42:10 | +3.8s | +1.3s |
| 2026-06-01 | 1 | 42:44 | 42:38 | 42:41 | +5.2s | +2.7s |
| 2026-06-02 | 1 | 36:15 | 36:13 | 36:15 | +2.2s | -0.3s |
| 2026-06-03 | 1 | 12:47 | 12:42 | 12:45 | +4.9s | +2.4s |
| 2026-06-03 | 2 | 16:59 | 16:54 | 16:57 | +4.7s | +2.1s |
| 2026-06-03 | 4 | 23:34 | 23:31 | 23:33 | +3.7s | +1.1s |
| 2026-06-03 | 6 | 30:05 | 30:02 | 30:04 | +3.1s | +0.5s |
| 2026-06-04 | 1 | 36:36 | 36:34 | 36:37 | +1.3s | -1.2s |
| 2026-06-05 | 1 | 12:30 | 12:27 | 12:29 | +3.5s | +0.9s |
| 2026-06-05 | 2 | 21:01 | 20:59 | 21:01 | +2.0s | -0.6s |
| 2026-06-05 | 3 | 35:36 | 35:38 | 35:41 | -2.0s | -4.5s |
| 2026-06-12 | 1 | 32:03 | 31:59 | 32:01 | +4.8s | +2.3s |

Distance samples explain part of the FIT/Apple timing, especially in guard cases where the next sample end is close. They do not fully explain the drift cases:

- May 26 FIT/Apple Work is still about 1.3 seconds after the next sample end.
- June 1 FIT/Apple Work is about 2.7 seconds after the next sample end.
- June 12 FIT/Apple Work is about 2.3 seconds after the next sample end.

This means "next distance sample end" remains an interesting debug-only candidate, but it is not the same thing as the FIT lap boundary.

## Drift Cases

May 26, June 1, and June 12 are the main drift cases where FIT aligns closely with Apple Fitness and differs from RunSignal.

| Date | FIT/Apple alignment | FIT vs RunSignal | Public evidence read |
|---|---|---|---|
| 2026-05-26 | FIT Work is +0.3s from Apple; FIT inferred Open is +0.4s from Apple. | FIT Work is +3.8s later than RunSignal; FIT tail is 3.8s shorter. | Nearest segment marker ends 7.7s before FIT. Next distance sample ends 1.3s before FIT. No clean public boundary source found. |
| 2026-06-01 | FIT Work is -0.4s from Apple; FIT inferred Open is +0.4s from Apple. | FIT Work is +5.2s later than RunSignal; FIT tail is 5.2s shorter. | Nearest segment marker ends 2.5s after FIT; next distance sample ends 2.7s before FIT. No clean public boundary source found. |
| 2026-06-12 | FIT Work is +0.4s from Apple; FIT inferred Open is +0.4s from Apple. | FIT Work is +4.8s later than RunSignal; FIT tail is 4.8s shorter. | Nearest segment marker ends 2.9s before FIT; next distance sample ends 2.3s before FIT. No clean public boundary source found. |

These cases support the observation that FIT lap rows carry step-boundary timing closer to Apple Fitness than RunSignal currently reconstructs. They do not prove the timing comes from a public HealthKit event or WorkoutKit completion timestamp available to RunSignal.

## Guard Cases

June 2 and June 4 are important because RunSignal is already close to Apple Fitness, yet FIT still nudges the boundary later.

| Date | FIT vs Apple | FIT vs RunSignal | Guard read |
|---|---|---|---|
| 2026-06-02 | FIT Work is -0.2s from Apple; FIT inferred Open is -0.2s from Apple. | FIT Work is +2.2s later than RunSignal; FIT tail is 2.2s shorter. | FIT suggests RunSignal is early, but RunSignal remains within temporary-pass tolerance. Next sample end is only 0.3s after FIT. |
| 2026-06-04 | FIT Work is -0.4s from Apple; FIT inferred Open is -0.1s from Apple. | FIT Work is +1.3s later than RunSignal; FIT tail is 1.3s shorter. | FIT suggests RunSignal is slightly early, but RunSignal remains pass/close. Next sample end is 1.2s after FIT. |

This weakens any simple drift-only rule. If a later boundary strategy is applied broadly, it may improve drift cases while still perturbing guard/pass cases.

## June 3 Same-Date FIT Candidate

The matched fixture FIT is:

```text
2026-06-03-074508-Outdoor Running-Adriel's Apple Watch.fit
```

It matches the RunSignal parity packet by date, UTC start `11:45:08`, duration `38:57`, distance `6.668 km`, plan name `Wednesday Interval (7.5km)`, and eight FIT lap records corresponding to Warmup, Work, Recovery, and Cooldown rows.

The other same-date running FIT was archived as an unmatched candidate:

```text
2026-06-03-082505-Outdoor Running-Adriel's Apple Watch.fit
```

It starts at `12:25:05`, lasts `6:29`, covers `1.015 km`, has two laps, and has no workout steps. It is not the interval fixture and must not be used for fixture boundary conclusions.

## Mapping Assessment

| Question | Current answer |
|---|---|
| Do FIT lap rows map cleanly to WorkoutKit planned steps? | Yes for structure/order. FIT `workout_step` and `lap` rows align with planned steps for the archived running fixtures. |
| Do FIT lap rows map cleanly to HealthKit segment/lap events? | No. Existing segment marker windows are split-like, overlapping, unlabeled, and inconsistent relative to FIT lap endings. |
| Do FIT event records expose step boundary timestamps? | No. The observed FIT `event` records are timer start and session stop only. |
| Do parity packet boundary diagnostics explain FIT lap timing? | Partly. FIT is often later than the RunSignal crossing sample end and sometimes near the next sample end, but drift cases remain 1-3 seconds later than next sample end. |
| Is FIT likely exposing public evidence RunSignal already captures? | Not proven. Existing packets and raw exports do not contain a clean matching public boundary source. |
| Is FIT likely HealthFit/export-specific transformation or inaccessible Apple Watch lap evidence? | Plausible, but still not proven without raw HealthKit event date export. |

## Added Debug Diagnostics

The archived artifacts are not enough to prove source equivalence. RunSignal now adds the smallest debug-only export enhancement needed for the next physical-device pass. Per selected workout, Raw HealthKit Debug and parity packet exports can show:

- Raw `HKWorkoutEvent` entries with type, start/end date offsets, duration, metadata keys when safely printable, whether the event was used by segment-marker rendering, and an exclusion/filter reason when it was not.
- Public `HKWorkoutActivity` entries with activity type, start/end date offsets, duration, metadata keys, nested events, public `allStatistics` summaries, nearest reconstructed row, planned-step alignment, nearest raw event and segment marker boundaries, and nearest distance-sample boundary references.
- Segment marker candidate context through nearest rendered marker start/end offsets and marker kind.
- Planned-step boundary comparison rows containing WorkoutKit planned step order, current RunSignal reconstructed row end, nearest raw HKWorkoutEvent start/end, nearest HKWorkoutActivity start/end, nearest segment marker start/end, previous/crossing/next distance sample ends, and a manual placeholder for later FIT lap end offsets.
- Warnings when no raw events or activities exist, metadata/statistics are unavailable, events do not produce segment marker candidates, activity ends do not align with reconstructed planned rows, or the export still cannot explain FIT/Apple timing.

This stays Raw HealthKit Debug / parity packet evidence only. It does not change normal UI or production reconstruction.

## Regenerated Export Pass

Status: regenerated physical-device Raw HealthKit Debug markdown and parity packet JSON are archived for April 28, May 26, June 1, June 2, June 3, June 4, June 5, and June 12.

These regenerated exports prove the raw HKWorkoutEvent inventory path, but they predate the `HKWorkoutActivity` inventory enhancement. Regenerate the same fixture set before updating the source-equivalence conclusion for workout activities.

The new export fields improve observability, but they do not prove that FIT/Apple lap timing is available as a clean public HealthKit/WorkoutKit boundary source:

- Raw `HKWorkoutEvent` rows exist for every fixture.
- The exported event type is `HKWorkoutEventType(rawValue: 7)` for the segment-like rows; it does not expose a stable planned-step label.
- Event metadata keys are unavailable in these regenerated exports.
- Segment marker rendering can use the raw event windows, but the windows remain split-like or overlapping marker candidates, not Apple Fitness interval truth.
- Planned-step boundary comparison rows show the nearest raw event or segment marker end relative to the current RunSignal reconstructed row end, not a FIT lap end match.

| Date | Rows | Raw events | Work RunSignal end | Nearest raw event end | Raw event vs RunSignal | Next distance sample end | Read |
|---|---:|---:|---:|---:|---:|---:|---|
| 2026-04-28 | 2 | 14 | 46:08.8 | 46:29.4 | +20.6s | 46:11.3 | Raw event is much later than current Work and later than FIT/Apple Work. Not a clean boundary source. |
| 2026-05-26 | 2 | 13 | 42:07.5 | 42:03.6 | -3.9s | 42:10.0 | Drift case. Raw event is earlier than RunSignal and farther from FIT/Apple Work; next sample is closer but still not exact. |
| 2026-06-01 | 2 | 13 | 42:38.3 | 42:35.5 | -2.8s | 42:40.9 | Drift case. Raw event does not explain FIT/Apple Work at about 42:44; next sample remains closer but short. |
| 2026-06-02 | 2 | 11 | 36:12.6 | 36:38.3 | +25.7s | 36:15.2 | Guard case. Raw event is much later; next sample is close to FIT/Apple timing. |
| 2026-06-03 | 8 | 13 | 12:42.4 | 12:44.3 | +1.9s | 12:44.9 | Structured case. Some early rows are near raw marker ends, but later rows diverge badly. |
| 2026-06-04 | 2 | 11 | 36:34.3 | 36:52.3 | +18.0s | 36:36.9 | Guard/pass case. Raw event is much later; next sample is close to FIT/Apple timing. |
| 2026-06-05 | 4 | 13 | 12:26.6 | 12:26.7 | +0.1s | 12:29.2 | Structured case. Warmup and Work are near raw events, but Cooldown diverges by about 25.8s. |
| 2026-06-12 | 2 | 11 | 31:58.5 | 32:00.5 | +2.0s | 32:01.1 | Drift case. Raw event is closer than current RunSignal but still short of FIT/Apple Work at about 32:03. |

Drift-case read:

| Date | FIT/Apple direction | New raw-event read |
|---|---|---|
| 2026-05-26 | FIT/Apple Work ends about 3.8s later than RunSignal. | Nearest raw event ends about 3.9s before RunSignal, so it points the wrong way. |
| 2026-06-01 | FIT/Apple Work ends about 5.2s later than RunSignal. | Nearest raw event ends about 2.8s before RunSignal, so it does not explain the later FIT/Apple boundary. |
| 2026-06-12 | FIT/Apple Work ends about 4.8s later than RunSignal. | Nearest raw event ends about 2.0s after RunSignal, closer but still about 2-3s short of FIT/Apple timing. |

Guard-case read:

| Date | Existing guard status | New raw-event read |
|---|---|---|
| 2026-06-02 | Temporary pass; FIT/Apple suggests RunSignal is only slightly early. | Nearest raw event ends about 25.7s after RunSignal and about 23.5s after FIT/Apple, so it would be a bad production boundary. |
| 2026-06-04 | Pass/close; FIT/Apple suggests RunSignal is only slightly early. | Nearest raw event ends about 18.0s after RunSignal and about 16.7s after FIT/Apple, so it would regress a passing guard case. |

Conclusion from regenerated exports: raw HealthKit events are useful evidence to archive, but they still do not map cleanly to FIT lap ends or Apple Fitness Work/Open row timing. The answer remains inconclusive, with stronger evidence against treating raw segment event ends as a production boundary source.

## Debug-Only Candidate Strategy

This investigation justifies a debug-only hypothesis to score later:

```text
lap-end-like boundary = compare Apple/FIT row timing against current crossing, next sample end, and any raw HKWorkoutEvent boundary candidate that appears within a small tolerance.
```

It does not justify a production strategy yet, because:

- FIT itself cannot be runtime truth.
- Existing public evidence does not provide a clean boundary timestamp.
- Segment markers are not Apple Fitness interval rows.
- Next-sample-end improves drift cases but can regress guard cases.
- Apple Fitness/manual rows cannot be used as runtime expected values.

## Conclusion

FIT lap boundaries are valuable observational evidence. They show that another export of the same Apple Watch workouts contains planned-step row timing close to Apple Fitness display timing. The current archived RunSignal diagnostics do not prove that this timing is available through public HealthKit/WorkoutKit evidence that RunSignal already captures. The new debug/export fields are intended to test that question on regenerated physical-device exports.

Production interval reconstruction, fixed-distance boundary logic, and normal workout UI remain unchanged. Swift changes are limited to diagnostics/export fields.
