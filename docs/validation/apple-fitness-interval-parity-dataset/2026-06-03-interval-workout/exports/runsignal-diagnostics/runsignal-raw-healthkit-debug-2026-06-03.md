# RunSignal Raw HealthKit Debug Export

Generated: 2026-06-12T22:24:03Z

## Workout

| Field | Value |
|---|---|
| Workout ID | F6D47A51-9510-4C7A-9186-6BAFE3C128C9 |
| Source | Adriel’s Apple Watch |
| Source ID | F6D47A51-9510-4C7A-9186-6BAFE3C128C9 |
| Device | Apple Watch Apple Inc. Watch |
| Start | Jun 3, 2026 |
| End | Jun 3, 2026 |
| Duration | 38:57 |
| Elapsed | 38:57 |
| Distance | 6.67 km |
| Avg pace | 5:50 /km |
| Avg HR | 150 bpm |
| Max HR | 185 bpm |
| Cadence | 167 spm |
| Power | 204 W |

## Evidence Counts

| Metric | Count |
|---|---:|
| Heart rate | 466 |
| Speed | 903 |
| Distance | 905 |
| Active energy | 908 |
| Power | 900 |
| Cadence | 903 |
| Step count | 903 |
| Stride length | 334 |
| Vertical oscillation | 338 |
| Ground contact | 333 |
| Route points | 2333 |
| Events | 13 |
| Workout activities | 8 |

## WorkoutKit Plan Audit

- Status: Available
- Plan type: Custom workout
- Plan ID: 77EBFFFA-254C-4E57-B567-DF975A19415A
- Display name: Wednesday Interval (7.5km)
- Activity: HKWorkoutActivityType(rawValue: 37)
- Warmup: goal 2 km, alert pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current
- Block 1: 3x, 2 step(s)
- Block 1 step 1: Work - goal 1 km, alert pace 4:00 /km, speed 4.17 m/s, metric current
- Block 1 step 2: Recovery - goal 150 s, alert none
- Cooldown: goal open, alert pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current

## Raw HKWorkoutEvent Inventory

Debug-only inventory of public `HKWorkoutEvent` date windows and metadata keys. These rows are not Apple Fitness interval truth.

| Row | Event Type | Label | Start Offset | End Offset | Duration | Metadata Keys | Rendered Marker Window | Marker Distance | Marker Kind | Used By Segment Rendering | Excluded / Filtered Reason | Debug-Only Reason |
|---:|---|---|---:|---:|---:|---|---:|---:|---|---|---|---|
| 1 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 6:20 | 379.9 s | Unavailable | 0:00-6:20 | 1.01 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 2 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 10:15 | 614.9 s | Unavailable | 0:00-10:15 | 1.62 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 3 | HKWorkoutEventType(rawValue: 7) | Unavailable | 6:20 | 12:44 | 384.3 s | Unavailable | 6:20-12:44 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 4 | HKWorkoutEventType(rawValue: 7) | Unavailable | 10:15 | 19:25 | 550.4 s | Unavailable | 10:15-19:25 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 5 | HKWorkoutEventType(rawValue: 7) | Unavailable | 12:44 | 16:56 | 251.8 s | Unavailable | 12:44-16:56 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 6 | HKWorkoutEventType(rawValue: 7) | Unavailable | 16:56 | 22:40 | 343.4 s | Unavailable | 16:56-22:40 | 1.00 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 7 | HKWorkoutEventType(rawValue: 7) | Unavailable | 19:25 | 27:41 | 495.4 s | Unavailable | 19:25-27:41 | 1.62 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 8 | HKWorkoutEventType(rawValue: 7) | Unavailable | 22:40 | 28:22 | 342.6 s | Unavailable | 22:40-28:22 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 9 | HKWorkoutEventType(rawValue: 7) | Unavailable | 27:41 | 37:33 | 591.9 s | Unavailable | 27:41-37:33 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 10 | HKWorkoutEventType(rawValue: 7) | Unavailable | 28:22 | 34:53 | 390.9 s | Unavailable | 28:22-34:53 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 11 | HKWorkoutEventType(rawValue: 7) | Unavailable | 34:53 | 38:54 | 241.2 s | Unavailable | 34:53-38:54 | 0.66 km | Raw segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 12 | HKWorkoutEventType(rawValue: 7) | Unavailable | 37:33 | 38:54 | 81.6 s | Unavailable | 37:33-38:54 | 0.22 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 13 | HKWorkoutEventType(rawValue: 1) | Unavailable | 38:57 | 38:57 | 0.0 s | Unavailable | Unavailable | Unavailable | Unavailable | No | Excluded from segment rendering: zero or negative duration. | No rendered segment marker candidate. |

## HKWorkoutActivity Inventory

Debug-only inventory of public `HKWorkout.workoutActivities` rows. These rows are not used for production interval reconstruction.

| Activity | Type | Start Date | End Date | Start Offset | End Offset | Duration | Metadata Keys | Nested Events | Statistics | Aligns Planned Step | Aligned Planned Step | Nearest Reconstructed Row | Row End Delta | Apple Fitness/manual | FIT Lap | Raw Event Start | Raw Start Delta | Raw Event End | Raw End Delta | Segment Start | Segment Start Delta | Segment End | Segment End Delta | Previous Sample End | Crossing Sample End | Next Sample End |
|---:|---|---|---|---:|---:|---:|---|---|---|---|---|---|---:|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | HKWorkoutActivityType(rawValue: 37) | 2026-06-03T11:45:08Z | 2026-06-03T11:57:56Z | 0.0 s | 767.3 s | 767.3 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 5 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 120.8 kcal; BasalEnergyBurned: sum 18.8 kcal; DistanceWalkingRunning: sum 2008.6 m; HeartRate: avg 126.2 bpm, min 83.0 bpm, max 144.0 bpm | No | Unavailable | Warmup | -4.9 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 0.0 s | 0.0 s | 764.3 s | -3.0 s | 0.0 s | 0.0 s | 764.3 s | -3.0 s | 759.8 s | 762.4 s | 764.9 s |
| 2 | HKWorkoutActivityType(rawValue: 37) | 2026-06-03T11:57:56Z | 2026-06-03T12:02:07Z | 767.3 s | 1019.1 s | 251.8 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 3 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 62.9 kcal; BasalEnergyBurned: sum 6.2 kcal; DistanceWalkingRunning: sum 1005.1 m; HeartRate: avg 165.7 bpm, min 144.0 bpm, max 174.0 bpm | No | Unavailable | Work 1 | -4.7 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 764.3 s | -3.0 s | 1016.1 s | -3.0 s | 764.3 s | -3.0 s | 1016.1 s | -3.0 s | 1011.9 s | 1014.5 s | 1017.0 s |
| 3 | HKWorkoutActivityType(rawValue: 37) | 2026-06-03T12:02:07Z | 2026-06-03T12:04:36Z | 1019.1 s | 1168.2 s | 149.0 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 3 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 11.9 kcal; BasalEnergyBurned: sum 3.6 kcal; DistanceWalkingRunning: sum 209.5 m; HeartRate: avg 146.9 bpm, min 128.0 bpm, max 174.0 bpm | No | Unavailable | Recovery 1 | -3.7 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1016.1 s | -3.0 s | 1165.4 s | -2.8 s | 1016.1 s | -3.0 s | 1165.4 s | -2.8 s | Unavailable | Unavailable | Unavailable |
| 4 | HKWorkoutActivityType(rawValue: 37) | 2026-06-03T12:04:36Z | 2026-06-03T12:08:43Z | 1168.2 s | 1414.4 s | 246.2 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 3 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 62.2 kcal; BasalEnergyBurned: sum 6.0 kcal; DistanceWalkingRunning: sum 1005.2 m; HeartRate: avg 166.0 bpm, min 126.0 bpm, max 180.0 bpm | No | Unavailable | Work 2 | -3.7 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1165.4 s | -2.8 s | 1359.5 s | -54.8 s | 1165.4 s | -2.8 s | 1359.5 s | -54.8 s | 1408.1 s | 1410.6 s | 1413.2 s |
| 5 | HKWorkoutActivityType(rawValue: 37) | 2026-06-03T12:08:43Z | 2026-06-03T12:11:13Z | 1414.4 s | 1564.3 s | 149.9 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 2 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 12.3 kcal; BasalEnergyBurned: sum 3.7 kcal; DistanceWalkingRunning: sum 207.3 m; HeartRate: avg 152.7 bpm, min 127.0 bpm, max 180.0 bpm | No | Unavailable | Recovery 2 | -3.6 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1359.5 s | -54.8 s | 1660.7 s | 96.5 s | 1359.5 s | -54.8 s | 1660.7 s | 96.5 s | Unavailable | Unavailable | Unavailable |
| 6 | HKWorkoutActivityType(rawValue: 37) | 2026-06-03T12:11:13Z | 2026-06-03T12:15:13Z | 1564.3 s | 1804.8 s | 240.5 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 4 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 62.4 kcal; BasalEnergyBurned: sum 5.9 kcal; DistanceWalkingRunning: sum 1003.9 m; HeartRate: avg 170.8 bpm, min 130.0 bpm, max 185.0 bpm | No | Unavailable | Work 3 | -3.1 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1660.7 s | 96.5 s | 1702.1 s | -102.6 s | 1660.7 s | 96.5 s | 1702.1 s | -102.6 s | 1799.1 s | 1801.7 s | 1804.2 s |
| 7 | HKWorkoutActivityType(rawValue: 37) | 2026-06-03T12:15:13Z | 2026-06-03T12:17:43Z | 1804.8 s | 1954.6 s | 149.8 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 2 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 12.2 kcal; BasalEnergyBurned: sum 3.7 kcal; DistanceWalkingRunning: sum 197.1 m; HeartRate: avg 160.1 bpm, min 138.0 bpm, max 185.0 bpm | Yes | Recovery 3 | Recovery 3 | -2.9 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1702.1 s | -102.6 s | 2093.0 s | 138.5 s | 1702.1 s | -102.6 s | 2093.0 s | 138.5 s | Unavailable | Unavailable | Unavailable |
| 8 | HKWorkoutActivityType(rawValue: 37) | 2026-06-03T12:17:43Z | 2026-06-03T12:24:05Z | 1954.6 s | 2336.7 s | 382.1 s | HKElevationAscended, WOIntervalStepKeyPath | 5 event(s): HKWorkoutEventType(rawValue: 1), HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 72.7 kcal; BasalEnergyBurned: sum 9.3 kcal; DistanceWalkingRunning: sum 1031.2 m; HeartRate: avg 155.3 bpm, min 133.0 bpm, max 166.0 bpm | Yes | Cooldown | Cooldown | 0.0 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 2093.0 s | 138.5 s | 2334.2 s | -2.5 s | 2093.0 s | 138.5 s | 2334.2 s | -2.5 s | Unavailable | Unavailable | Unavailable |

## WorkoutKit Reconstructed Intervals

Planned structure source: WorkoutKit when available. Measured stats source: HealthKit samples.

| Row | Label | Goal | Target | Distance | Time | Pace | Avg HR | Max HR | Power | Start Offset | End Offset | Boundary Strategy | Boundary Adjustment | Overshoot | Confidence | Notes |
|---:|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---:|---:|---|---|
| 1 | Warmup | 2 km | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 2.00 km | 12:42 | 6:21 /km | 126 bpm | 144 bpm | 190 W | 0:00 | 12:42 | crossing sample end | 0.6 s | 1.5 m | High | Distance-goal boundary: crossing sample end, adjustment +0.6s, overshoot 1.5 m |
| 2 | Work 1 | 1 km | pace 4:00 /km, speed 4.17 m/s, metric current | 1.00 km | 4:12 | 4:12 /km | 166 bpm | 174 bpm | 285 W | 12:42 | 16:54 | crossing sample end | 0.5 s | 1.9 m | High | Distance-goal boundary: crossing sample end, adjustment +0.5s, overshoot 1.9 m |
| 3 | Recovery 1 | 150 s | Target unavailable | 0.22 km | 2:30 | 11:28 /km | 147 bpm | 174 bpm | 94 W | 16:54 | 19:24 |  |  |  | High | Time-goal window reconstructed from WorkoutKit duration; TODO pause-adjusted active duration |
| 4 | Work 2 | 1 km | pace 4:00 /km, speed 4.17 m/s, metric current | 1.00 km | 4:06 | 4:06 /km | 167 bpm | 180 bpm | 290 W | 19:24 | 23:31 | crossing sample end | 0.4 s | 1.7 m | High | Distance-goal boundary: crossing sample end, adjustment +0.4s, overshoot 1.7 m |
| 5 | Recovery 2 | 150 s | Target unavailable | 0.21 km | 2:30 | 11:54 /km | 154 bpm | 180 bpm | 94 W | 23:31 | 26:01 |  |  |  | High | Time-goal window reconstructed from WorkoutKit duration; TODO pause-adjusted active duration |
| 6 | Work 3 | 1 km | pace 4:00 /km, speed 4.17 m/s, metric current | 1.00 km | 4:01 | 4:00 /km | 172 bpm | 185 bpm | 295 W | 26:01 | 30:02 | crossing sample end | 0.9 s | 4.0 m | High | Distance-goal boundary: crossing sample end, adjustment +0.9s, overshoot 4.0 m |
| 7 | Recovery 3 | 150 s | Target unavailable | 0.20 km | 2:30 | 12:33 /km | 161 bpm | 185 bpm | 98 W | 30:02 | 32:32 |  |  |  | High | Time-goal window reconstructed from WorkoutKit duration; TODO pause-adjusted active duration |
| 8 | Cooldown | Open | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 1.03 km | 6:25 | 6:13 /km | 156 bpm | 166 bpm | 194 W | 32:32 | 38:57 |  |  |  | Medium | Planned open cooldown extended to workout end |

Notes: Plan source: WorkoutKit · Window source: Plan-derived from HealthKit distance/time samples · Stats source: HealthKit samples · HealthKit segment markers: not used

## HKWorkoutActivity Boundary Candidate Intervals

Debug-only alternate reconstruction for Parity Lab exports. These rows are not production interval logic and are not shown in the normal workout UI.

| Field | Value |
|---|---|
| Mapping status | mappedByPlannedStepOrder |
| Activity count | 8 |
| Planned step count | 8 |
| Scoreable | Yes |
| Not scoreable reason | n/a |
| Production UI warning | HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI. |

| Row | Label | Goal | Mapping | Activity | Start Offset | End Offset | Distance | Time | Candidate Confidence | Reason If Not Scoreable | Caveats |
|---:|---|---|---|---:|---:|---:|---:|---:|---|---|---|
| 1 | Warmup | 2 km | mappedByPlannedStepOrder | 1 | 0.0 s | 767.3 s | 2008.6 m | 767.3 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 2 | Work 1 | 1 km | mappedByPlannedStepOrder | 2 | 767.3 s | 1019.1 s | 1005.1 m | 251.8 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 3 | Recovery 1 | 150 s | mappedByPlannedStepOrder | 3 | 1019.1 s | 1168.2 s | 209.5 m | 149.0 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 4 | Work 2 | 1 km | mappedByPlannedStepOrder | 4 | 1168.2 s | 1414.4 s | 1005.2 m | 246.2 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 5 | Recovery 2 | 150 s | mappedByPlannedStepOrder | 5 | 1414.4 s | 1564.3 s | 207.3 m | 149.9 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 6 | Work 3 | 1 km | mappedByPlannedStepOrder | 6 | 1564.3 s | 1804.8 s | 1003.9 m | 240.5 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 7 | Recovery 3 | 150 s | mappedByPlannedStepOrder | 7 | 1804.8 s | 1954.6 s | 197.1 m | 149.8 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 8 | Cooldown | Open | mappedByPlannedStepOrder | 8 | 1954.6 s | 2336.7 s | 1031.2 m | 382.1 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |

Caveats: debug-only, not promoted · not production interval logic · not shown in normal workout UI · FIT and Apple Fitness/manual rows are not runtime inputs · Activities are generic HealthKit activity windows and labels are mapped from WorkoutKit planned step order. · Missing or ambiguous activity rows must not replace current reconstruction.

## WorkoutKit Boundary Diagnostics

### Row 1: Warmup

| Field | Value |
|---|---:|
| Target distance | 2000.0 m |
| Start offset | 0:00 |
| End offset | 12:42 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 0.6 s |
| Overshoot | 1.5 m |
| Cumulative distance at start | 0.0 m |
| Cumulative distance at end | 2001.5 m |
| Interpolation fraction | 0.747 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 12:37 | 12:40 | 1988.5 m | 1995.6 m |
| Crossing | 12:40 | 12:42 | 1995.6 m | 2001.5 m |
| Next | 12:42 | 12:45 | 2001.5 m | 2009.2 m |

### Row 2: Work 1

| Field | Value |
|---|---:|
| Target distance | 1000.0 m |
| Start offset | 12:42 |
| End offset | 16:54 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 0.5 s |
| Overshoot | 1.9 m |
| Cumulative distance at start | 2001.5 m |
| Cumulative distance at end | 3003.4 m |
| Interpolation fraction | 0.793 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 16:49 | 16:52 | 2984.3 m | 2994.1 m |
| Crossing | 16:52 | 16:54 | 2994.1 m | 3003.4 m |
| Next | 16:54 | 16:57 | 3003.4 m | 3016.1 m |

### Row 4: Work 2

| Field | Value |
|---|---:|
| Target distance | 1000.0 m |
| Start offset | 19:24 |
| End offset | 23:31 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 0.4 s |
| Overshoot | 1.7 m |
| Cumulative distance at start | 3221.5 m |
| Cumulative distance at end | 4223.1 m |
| Interpolation fraction | 0.843 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 23:25 | 23:28 | 4202.0 m | 4212.5 m |
| Crossing | 23:28 | 23:31 | 4212.5 m | 4223.1 m |
| Next | 23:31 | 23:33 | 4223.1 m | 4235.2 m |

### Row 6: Work 3

| Field | Value |
|---|---:|
| Target distance | 1000.0 m |
| Start offset | 26:01 |
| End offset | 30:02 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 0.9 s |
| Overshoot | 4.0 m |
| Cumulative distance at start | 4433.3 m |
| Cumulative distance at end | 5437.3 m |
| Interpolation fraction | 0.638 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 29:57 | 29:59 | 5414.2 m | 5426.2 m |
| Crossing | 29:59 | 30:02 | 5426.2 m | 5437.3 m |
| Next | 30:02 | 30:04 | 5437.3 m | 5449.5 m |

## HealthKit Segment Markers

Raw debug only. HealthKit Segment Markers must not be promoted as Apple Fitness interval rows.

| Row | Label | Marker Kind | Source | Distance | Time | Pace | Avg HR | Start Offset | End Offset | Confidence | Caveats |
|---:|---|---|---|---:|---:|---:|---:|---:|---:|---|---|
| 1 | Unknown | Split marker | HealthKit segment pattern | 1.01 km | 6:20 | 6:17 /km | 119 bpm | 0:00 | 6:20 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. |
| 2 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.62 km | 10:15 | 6:21 /km | 124 bpm | 0:00 | 10:15 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 3 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:24 | 6:24 /km | 134 bpm | 6:20 | 12:44 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 4 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 9:10 | 5:42 /km | 154 bpm | 10:15 | 19:25 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 5 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 4:12 | 4:11 /km | 166 bpm | 12:44 | 16:56 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 6 | Unknown | Split marker | HealthKit segment pattern | 1.00 km | 5:43 | 5:44 /km | 157 bpm | 16:56 | 22:40 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. |
| 7 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.62 km | 8:15 | 5:07 /km | 162 bpm | 19:25 | 27:41 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 8 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 5:43 | 5:42 /km | 162 bpm | 22:40 | 28:22 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 9 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 9:52 | 6:09 /km | 162 bpm | 27:41 | 37:33 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 10 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:31 | 6:32 /km | 161 bpm | 28:22 | 34:53 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 11 | Unknown | Raw segment marker | HealthKit segment pattern | 0.66 km | 4:01 | 6:05 /km | 161 bpm | 34:53 | 38:54 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event is a raw HealthKit marker until interval parity is proven. |
| 12 | Unknown | Overlapping segment marker | HealthKit segment pattern | 0.22 km | 1:22 | 6:05 /km | 164 bpm | 37:33 | 38:54 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |

## Planned Step Boundary Comparison

Debug-only comparison helper for FIT/Apple boundary investigation. The FIT lap end offset is intentionally a manual placeholder; RunSignal does not read FIT at runtime.

| Row | Planned Step | Goal | RunSignal End | FIT Lap End | Nearest Raw Event End | Event Delta | Nearest Activity End | Activity Delta | Activity Type | Nearest Segment End | Segment Delta | Previous Sample End | Crossing Sample End | Next Sample End | Warning |
|---:|---|---|---:|---:|---:|---:|---:|---:|---|---:|---:|---:|---:|---:|---|
| 1 | Warmup | 2 km | 762.4 s | Manual FIT placeholder | 764.3 s | 1.9 s | 767.3 s | 4.9 s | HKWorkoutActivityType(rawValue: 37) | 764.3 s | 1.9 s | 759.8 s | 762.4 s | 764.9 s |  |
| 2 | Work 1 | 1 km | 1014.5 s | Manual FIT placeholder | 1016.1 s | 1.6 s | 1019.1 s | 4.7 s | HKWorkoutActivityType(rawValue: 37) | 1016.1 s | 1.6 s | 1011.9 s | 1014.5 s | 1017.0 s |  |
| 3 | Recovery 1 | 150 s | 1164.5 s | Manual FIT placeholder | 1165.4 s | 0.9 s | 1168.2 s | 3.7 s | HKWorkoutActivityType(rawValue: 37) | 1165.4 s | 0.9 s | Unavailable | Unavailable | Unavailable |  |
| 4 | Work 2 | 1 km | 1410.6 s | Manual FIT placeholder | 1359.5 s | -51.1 s | 1414.4 s | 3.7 s | HKWorkoutActivityType(rawValue: 37) | 1359.5 s | -51.1 s | 1408.1 s | 1410.6 s | 1413.2 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 5 | Recovery 2 | 150 s | 1560.6 s | Manual FIT placeholder | 1660.7 s | 100.1 s | 1564.3 s | 3.6 s | HKWorkoutActivityType(rawValue: 37) | 1660.7 s | 100.1 s | Unavailable | Unavailable | Unavailable | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 6 | Work 3 | 1 km | 1801.7 s | Manual FIT placeholder | 1702.1 s | -99.6 s | 1804.8 s | 3.1 s | HKWorkoutActivityType(rawValue: 37) | 1702.1 s | -99.6 s | 1799.1 s | 1801.7 s | 1804.2 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 7 | Recovery 3 | 150 s | 1951.7 s | Manual FIT placeholder | 2093.0 s | 141.4 s | 1954.6 s | 2.9 s | HKWorkoutActivityType(rawValue: 37) | 2093.0 s | 141.4 s | Unavailable | Unavailable | Unavailable | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 8 | Cooldown | Open | 2336.7 s | Manual FIT placeholder | 2334.2 s | -2.5 s | 2336.7 s | 0.0 s | HKWorkoutActivityType(rawValue: 37) | 2334.2 s | -2.5 s | Unavailable | Unavailable | Unavailable |  |

## Boundary Source Warnings

- One or more raw HKWorkoutEvent records have unavailable metadata keys.
- One or more HKWorkoutActivity end boundaries are more than 3 seconds from reconstructed planned-step row ends.
- FIT lap end offsets are not read by RunSignal; compare them manually after physical-device export.
- Apple Fitness/manual row offsets are not read by RunSignal; compare HKWorkoutActivity timing manually after physical-device export.

## Evidence Caveats

- None

## JSON Payload

```json
{
  "activityBoundaryCandidateIntervals" : [
    {
      "activityIndex" : 1,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 2008.615227742627,
      "durationSeconds" : 767.306872844696,
      "endOffsetSeconds" : 767.306872844696,
      "index" : 1,
      "label" : "Warmup",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "2 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 2000,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 0,
      "stepType" : "warmup"
    },
    {
      "activityIndex" : 2,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 1005.1297732402121,
      "durationSeconds" : 251.829061627388,
      "endOffsetSeconds" : 1019.135934472084,
      "index" : 2,
      "label" : "Work 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "1 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 1000,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 767.306872844696,
      "stepType" : "work"
    },
    {
      "activityIndex" : 3,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 209.53992788358676,
      "durationSeconds" : 149.04158008098602,
      "endOffsetSeconds" : 1168.17751455307,
      "index" : 3,
      "label" : "Recovery 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "150 s",
      "plannedGoalType" : "time",
      "plannedGoalValue" : 150,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1019.135934472084,
      "stepType" : "recovery"
    },
    {
      "activityIndex" : 4,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 1005.2347047854886,
      "durationSeconds" : 246.18645083904266,
      "endOffsetSeconds" : 1414.3639653921127,
      "index" : 4,
      "label" : "Work 2",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "1 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 1000,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1168.17751455307,
      "stepType" : "work"
    },
    {
      "activityIndex" : 5,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 207.3144335633505,
      "durationSeconds" : 149.89954495429993,
      "endOffsetSeconds" : 1564.2635103464127,
      "index" : 5,
      "label" : "Recovery 2",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "150 s",
      "plannedGoalType" : "time",
      "plannedGoalValue" : 150,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1414.3639653921127,
      "stepType" : "recovery"
    },
    {
      "activityIndex" : 6,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 1003.8789472024649,
      "durationSeconds" : 240.49814558029175,
      "endOffsetSeconds" : 1804.7616559267044,
      "index" : 6,
      "label" : "Work 3",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "1 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 1000,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1564.2635103464127,
      "stepType" : "work"
    },
    {
      "activityIndex" : 7,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 197.1376849863985,
      "durationSeconds" : 149.83583295345306,
      "endOffsetSeconds" : 1954.5974888801575,
      "index" : 7,
      "label" : "Recovery 3",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "150 s",
      "plannedGoalType" : "time",
      "plannedGoalValue" : 150,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1804.7616559267044,
      "stepType" : "recovery"
    },
    {
      "activityIndex" : 8,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 1031.2081285578995,
      "durationSeconds" : 382.12721705436707,
      "endOffsetSeconds" : 2336.7247059345245,
      "index" : 8,
      "label" : "Cooldown",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "Open",
      "plannedGoalType" : "open",
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1954.5974888801575,
      "stepType" : "cooldown"
    }
  ],
  "activityBoundaryCandidateSummary" : {
    "activityCount" : 8,
    "boundaryLogicChanged" : false,
    "candidateConfidence" : "activity boundary direct",
    "caveats" : [
      "debug-only, not promoted",
      "not production interval logic",
      "not shown in normal workout UI",
      "FIT and Apple Fitness\/manual rows are not runtime inputs",
      "Activities are generic HealthKit activity windows and labels are mapped from WorkoutKit planned step order.",
      "Missing or ambiguous activity rows must not replace current reconstruction."
    ],
    "isScoreable" : true,
    "mappingStatus" : "mappedByPlannedStepOrder",
    "normalWorkoutUIChanged" : false,
    "plannedStepCount" : 8,
    "productionIntervalBehaviorChanged" : false,
    "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
    "scope" : "debug\/export-only",
    "strategyID" : "hkworkoutactivity_boundary",
    "usesAppleFitnessManualRuntimeLogic" : false,
    "usesFITRuntimeTruth" : false
  },
  "boundaryDiagnostics" : [
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 2001.4803571118973,
          "endDate" : "2026-06-03T11:57:51Z",
          "endOffsetSeconds" : 762.3678689002991,
          "startCumulativeDistanceMeters" : 1995.6178373540752,
          "startDate" : "2026-06-03T11:57:48Z",
          "startOffsetSeconds" : 759.7953763008118
        },
        "cumulativeDistanceAtEndMeters" : 2001.4803571118973,
        "cumulativeDistanceAtStartMeters" : 0,
        "interpolationFraction" : 0.7474879108216002,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2009.2362459553406,
          "endDate" : "2026-06-03T11:57:53Z",
          "endOffsetSeconds" : 764.9403622150421,
          "startCumulativeDistanceMeters" : 2001.4803571118973,
          "startDate" : "2026-06-03T11:57:51Z",
          "startOffsetSeconds" : 762.3678689002991
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 1995.6178373540752,
          "endDate" : "2026-06-03T11:57:48Z",
          "endOffsetSeconds" : 759.7953763008118,
          "startCumulativeDistanceMeters" : 1988.46186853759,
          "startDate" : "2026-06-03T11:57:45Z",
          "startOffsetSeconds" : 757.2228845357895
        },
        "targetDistanceMeters" : 2000
      },
      "index" : 1,
      "label" : "Warmup"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3003.3969073158223,
          "endDate" : "2026-06-03T12:02:03Z",
          "endOffsetSeconds" : 1014.4723151922226,
          "startCumulativeDistanceMeters" : 2994.1328706021886,
          "startDate" : "2026-06-03T12:02:00Z",
          "startOffsetSeconds" : 1011.8998090028763
        },
        "cumulativeDistanceAtEndMeters" : 3003.3969073158223,
        "cumulativeDistanceAtStartMeters" : 2001.4803571118973,
        "interpolationFraction" : 0.7931193211805333,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3016.1272426524665,
          "endDate" : "2026-06-03T12:02:05Z",
          "endOffsetSeconds" : 1017.0448224544525,
          "startCumulativeDistanceMeters" : 3003.3969073158223,
          "startDate" : "2026-06-03T12:02:03Z",
          "startOffsetSeconds" : 1014.4723151922226
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 2994.1328706021886,
          "endDate" : "2026-06-03T12:02:00Z",
          "endOffsetSeconds" : 1011.8998090028763,
          "startCumulativeDistanceMeters" : 2984.2827832160983,
          "startDate" : "2026-06-03T12:01:58Z",
          "startOffsetSeconds" : 1009.3273077011108
        },
        "targetDistanceMeters" : 1000
      },
      "index" : 2,
      "label" : "Work 1"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 4223.137398585677,
          "endDate" : "2026-06-03T12:08:39Z",
          "endOffsetSeconds" : 1410.6429206132889,
          "startCumulativeDistanceMeters" : 4212.537871825043,
          "startDate" : "2026-06-03T12:08:36Z",
          "startOffsetSeconds" : 1408.070372581482
        },
        "cumulativeDistanceAtEndMeters" : 4223.137398585677,
        "cumulativeDistanceAtStartMeters" : 3221.474886546045,
        "interpolationFraction" : 0.843152239040852,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 4235.193161340198,
          "endDate" : "2026-06-03T12:08:41Z",
          "endOffsetSeconds" : 1413.2154661417007,
          "startCumulativeDistanceMeters" : 4223.137398585677,
          "startDate" : "2026-06-03T12:08:39Z",
          "startOffsetSeconds" : 1410.6429206132889
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 4212.537871825043,
          "endDate" : "2026-06-03T12:08:36Z",
          "endOffsetSeconds" : 1408.070372581482,
          "startCumulativeDistanceMeters" : 4202.032815427519,
          "startDate" : "2026-06-03T12:08:34Z",
          "startOffsetSeconds" : 1405.4978235960007
        },
        "targetDistanceMeters" : 1000
      },
      "index" : 4,
      "label" : "Work 2"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 5437.282878906932,
          "endDate" : "2026-06-03T12:15:10Z",
          "endOffsetSeconds" : 1801.6756726503372,
          "startCumulativeDistanceMeters" : 5426.2463395795785,
          "startDate" : "2026-06-03T12:15:07Z",
          "startOffsetSeconds" : 1799.1030902862549
        },
        "cumulativeDistanceAtEndMeters" : 5437.282878906932,
        "cumulativeDistanceAtStartMeters" : 4433.290152249623,
        "interpolationFraction" : 0.6382265727615432,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 5449.459950007498,
          "endDate" : "2026-06-03T12:15:13Z",
          "endOffsetSeconds" : 1804.2482550144196,
          "startCumulativeDistanceMeters" : 5437.282878906932,
          "startDate" : "2026-06-03T12:15:10Z",
          "startOffsetSeconds" : 1801.6756726503372
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 5426.2463395795785,
          "endDate" : "2026-06-03T12:15:07Z",
          "endOffsetSeconds" : 1799.1030902862549,
          "startCumulativeDistanceMeters" : 5414.2246238014195,
          "startDate" : "2026-06-03T12:15:05Z",
          "startOffsetSeconds" : 1796.5305081605911
        },
        "targetDistanceMeters" : 1000
      },
      "index" : 6,
      "label" : "Work 3"
    }
  ],
  "boundarySourceWarnings" : [
    "One or more raw HKWorkoutEvent records have unavailable metadata keys.",
    "One or more HKWorkoutActivity end boundaries are more than 3 seconds from reconstructed planned-step row ends.",
    "FIT lap end offsets are not read by RunSignal; compare them manually after physical-device export.",
    "Apple Fitness\/manual row offsets are not read by RunSignal; compare HKWorkoutActivity timing manually after physical-device export."
  ],
  "caveats" : [

  ],
  "evidenceCounts" : {
    "activeEnergy" : 908,
    "activities" : 8,
    "cadence" : 903,
    "distance" : 905,
    "events" : 13,
    "groundContact" : 333,
    "heartRate" : 466,
    "power" : 900,
    "routePoints" : 2333,
    "speed" : 903,
    "stepCount" : 903,
    "strideLength" : 334,
    "verticalOscillation" : 338
  },
  "generatedAt" : "2026-06-12T22:24:03Z",
  "plannedStepBoundaryComparisons" : [
    {
      "crossingDistanceSampleEndOffsetSeconds" : 762.3678689002991,
      "index" : 1,
      "nearestRawEventEndDeltaSeconds" : 1.9229077100753784,
      "nearestRawEventEndOffsetSeconds" : 764.2907766103745,
      "nearestRawEventStartOffsetSeconds" : 379.9435975551605,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 1.9229077100753784,
      "nearestSegmentMarkerEndOffsetSeconds" : 764.2907766103745,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 379.9435975551605,
      "nearestWorkoutActivityEndDeltaSeconds" : 4.939003944396973,
      "nearestWorkoutActivityEndOffsetSeconds" : 767.306872844696,
      "nearestWorkoutActivityStartOffsetSeconds" : 0,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 764.9403622150421,
      "plannedGoalDisplayText" : "2 km",
      "plannedStepLabel" : "Warmup",
      "previousDistanceSampleEndOffsetSeconds" : 759.7953763008118,
      "reconstructedEndOffsetSeconds" : 762.3678689002991,
      "reconstructedLabel" : "Warmup"
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1014.4723151922226,
      "index" : 2,
      "nearestRawEventEndDeltaSeconds" : 1.6292285919189453,
      "nearestRawEventEndOffsetSeconds" : 1016.1015437841415,
      "nearestRawEventStartOffsetSeconds" : 764.2907766103745,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 1.6292285919189453,
      "nearestSegmentMarkerEndOffsetSeconds" : 1016.1015437841415,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 764.2907766103745,
      "nearestWorkoutActivityEndDeltaSeconds" : 4.66361927986145,
      "nearestWorkoutActivityEndOffsetSeconds" : 1019.135934472084,
      "nearestWorkoutActivityStartOffsetSeconds" : 767.306872844696,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1017.0448224544525,
      "plannedGoalDisplayText" : "1 km",
      "plannedStepLabel" : "Work 1",
      "previousDistanceSampleEndOffsetSeconds" : 1011.8998090028763,
      "reconstructedEndOffsetSeconds" : 1014.4723151922226,
      "reconstructedLabel" : "Work 1"
    },
    {
      "index" : 3,
      "nearestRawEventEndDeltaSeconds" : 0.8924858570098877,
      "nearestRawEventEndOffsetSeconds" : 1165.3648010492325,
      "nearestRawEventStartOffsetSeconds" : 614.9445925951004,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 0.8924858570098877,
      "nearestSegmentMarkerEndOffsetSeconds" : 1165.3648010492325,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 614.9445925951004,
      "nearestWorkoutActivityEndDeltaSeconds" : 3.705199360847473,
      "nearestWorkoutActivityEndOffsetSeconds" : 1168.17751455307,
      "nearestWorkoutActivityStartOffsetSeconds" : 1019.135934472084,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "plannedGoalDisplayText" : "150 s",
      "plannedStepLabel" : "Recovery 1",
      "reconstructedEndOffsetSeconds" : 1164.4723151922226,
      "reconstructedLabel" : "Recovery 1"
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1410.6429206132889,
      "index" : 4,
      "nearestRawEventEndDeltaSeconds" : -51.10607695579529,
      "nearestRawEventEndOffsetSeconds" : 1359.5368436574936,
      "nearestRawEventStartOffsetSeconds" : 1016.1015437841415,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -51.10607695579529,
      "nearestSegmentMarkerEndOffsetSeconds" : 1359.5368436574936,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1016.1015437841415,
      "nearestWorkoutActivityEndDeltaSeconds" : 3.7210447788238525,
      "nearestWorkoutActivityEndOffsetSeconds" : 1414.3639653921127,
      "nearestWorkoutActivityStartOffsetSeconds" : 1168.17751455307,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1413.2154661417007,
      "plannedGoalDisplayText" : "1 km",
      "plannedStepLabel" : "Work 2",
      "previousDistanceSampleEndOffsetSeconds" : 1408.070372581482,
      "reconstructedEndOffsetSeconds" : 1410.6429206132889,
      "reconstructedLabel" : "Work 2",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "index" : 5,
      "nearestRawEventEndDeltaSeconds" : 100.09397101402283,
      "nearestRawEventEndOffsetSeconds" : 1660.7368916273117,
      "nearestRawEventStartOffsetSeconds" : 1165.3648010492325,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 100.09397101402283,
      "nearestSegmentMarkerEndOffsetSeconds" : 1660.7368916273117,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1165.3648010492325,
      "nearestWorkoutActivityEndDeltaSeconds" : 3.6205897331237793,
      "nearestWorkoutActivityEndOffsetSeconds" : 1564.2635103464127,
      "nearestWorkoutActivityStartOffsetSeconds" : 1414.3639653921127,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "plannedGoalDisplayText" : "150 s",
      "plannedStepLabel" : "Recovery 2",
      "reconstructedEndOffsetSeconds" : 1560.6429206132889,
      "reconstructedLabel" : "Recovery 2",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1801.6756726503372,
      "index" : 6,
      "nearestRawEventEndDeltaSeconds" : -99.55753684043884,
      "nearestRawEventEndOffsetSeconds" : 1702.1181358098984,
      "nearestRawEventStartOffsetSeconds" : 1359.5368436574936,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -99.55753684043884,
      "nearestSegmentMarkerEndOffsetSeconds" : 1702.1181358098984,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1359.5368436574936,
      "nearestWorkoutActivityEndDeltaSeconds" : 3.0859832763671875,
      "nearestWorkoutActivityEndOffsetSeconds" : 1804.7616559267044,
      "nearestWorkoutActivityStartOffsetSeconds" : 1564.2635103464127,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1804.2482550144196,
      "plannedGoalDisplayText" : "1 km",
      "plannedStepLabel" : "Work 3",
      "previousDistanceSampleEndOffsetSeconds" : 1799.1030902862549,
      "reconstructedEndOffsetSeconds" : 1801.6756726503372,
      "reconstructedLabel" : "Work 3",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "index" : 7,
      "nearestRawEventEndDeltaSeconds" : 141.3724683523178,
      "nearestRawEventEndOffsetSeconds" : 2093.048141002655,
      "nearestRawEventStartOffsetSeconds" : 1702.1181358098984,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 141.3724683523178,
      "nearestSegmentMarkerEndOffsetSeconds" : 2093.048141002655,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1702.1181358098984,
      "nearestWorkoutActivityEndDeltaSeconds" : 2.9218162298202515,
      "nearestWorkoutActivityEndOffsetSeconds" : 1954.5974888801575,
      "nearestWorkoutActivityStartOffsetSeconds" : 1804.7616559267044,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "plannedGoalDisplayText" : "150 s",
      "plannedStepLabel" : "Recovery 3",
      "reconstructedEndOffsetSeconds" : 1951.6756726503372,
      "reconstructedLabel" : "Recovery 3",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "index" : 8,
      "nearestRawEventEndDeltaSeconds" : -2.5116504430770874,
      "nearestRawEventEndOffsetSeconds" : 2334.2130554914474,
      "nearestRawEventStartOffsetSeconds" : 2093.048141002655,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -2.5116504430770874,
      "nearestSegmentMarkerEndOffsetSeconds" : 2334.2130554914474,
      "nearestSegmentMarkerKind" : "rawSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 2093.048141002655,
      "nearestWorkoutActivityEndDeltaSeconds" : 0,
      "nearestWorkoutActivityEndOffsetSeconds" : 2336.7247059345245,
      "nearestWorkoutActivityStartOffsetSeconds" : 1954.5974888801575,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "plannedGoalDisplayText" : "Open",
      "plannedStepLabel" : "Cooldown",
      "reconstructedEndOffsetSeconds" : 2336.7247059345245,
      "reconstructedLabel" : "Cooldown"
    }
  ],
  "rawWorkoutEvents" : [
    {
      "durationSeconds" : 379.9435975551605,
      "endDate" : "2026-06-03T11:51:28Z",
      "endOffsetSeconds" : 379.9435975551605,
      "index" : 1,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1006.55604171569,
      "renderedSegmentMarkerDurationSeconds" : 379.9435975551605,
      "renderedSegmentMarkerEndOffsetSeconds" : 379.9435975551605,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-03T11:45:08Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 614.9445925951004,
      "endDate" : "2026-06-03T11:55:23Z",
      "endOffsetSeconds" : 614.9445925951004,
      "index" : 2,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1615.06681563449,
      "renderedSegmentMarkerDurationSeconds" : 614.9445925951004,
      "renderedSegmentMarkerEndOffsetSeconds" : 614.9445925951004,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-03T11:45:08Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 384.3471790552139,
      "endDate" : "2026-06-03T11:57:53Z",
      "endOffsetSeconds" : 764.2907766103745,
      "index" : 3,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1000.7217487151096,
      "renderedSegmentMarkerDurationSeconds" : 384.3471790552139,
      "renderedSegmentMarkerEndOffsetSeconds" : 764.2907766103745,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 379.9435975551605,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-03T11:51:28Z",
      "startOffsetSeconds" : 379.9435975551605,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 550.4202084541321,
      "endDate" : "2026-06-03T12:04:34Z",
      "endOffsetSeconds" : 1165.3648010492325,
      "index" : 4,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1607.8343176178269,
      "renderedSegmentMarkerDurationSeconds" : 550.4202084541321,
      "renderedSegmentMarkerEndOffsetSeconds" : 1165.3648010492325,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 614.9445925951004,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-03T11:55:23Z",
      "startOffsetSeconds" : 614.9445925951004,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 251.8107671737671,
      "endDate" : "2026-06-03T12:02:04Z",
      "endOffsetSeconds" : 1016.1015437841415,
      "index" : 5,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1004.1815338972874,
      "renderedSegmentMarkerDurationSeconds" : 251.8107671737671,
      "renderedSegmentMarkerEndOffsetSeconds" : 1016.1015437841415,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 764.2907766103745,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-03T11:57:53Z",
      "startOffsetSeconds" : 764.2907766103745,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 343.43529987335205,
      "endDate" : "2026-06-03T12:07:48Z",
      "endOffsetSeconds" : 1359.5368436574936,
      "index" : 6,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 998.4019999002603,
      "renderedSegmentMarkerDurationSeconds" : 343.43529987335205,
      "renderedSegmentMarkerEndOffsetSeconds" : 1359.5368436574936,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1016.1015437841415,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-03T12:02:04Z",
      "startOffsetSeconds" : 1016.1015437841415,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 495.3720905780792,
      "endDate" : "2026-06-03T12:12:49Z",
      "endOffsetSeconds" : 1660.7368916273117,
      "index" : 7,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1616.2196370192896,
      "renderedSegmentMarkerDurationSeconds" : 495.3720905780792,
      "renderedSegmentMarkerEndOffsetSeconds" : 1660.7368916273117,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1165.3648010492325,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-03T12:04:34Z",
      "startOffsetSeconds" : 1165.3648010492325,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 342.5812921524048,
      "endDate" : "2026-06-03T12:13:30Z",
      "endOffsetSeconds" : 1702.1181358098984,
      "index" : 8,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1001.2390912663413,
      "renderedSegmentMarkerDurationSeconds" : 342.5812921524048,
      "renderedSegmentMarkerEndOffsetSeconds" : 1702.1181358098984,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1359.5368436574936,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-03T12:07:48Z",
      "startOffsetSeconds" : 1359.5368436574936,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 591.8765020370483,
      "endDate" : "2026-06-03T12:22:41Z",
      "endOffsetSeconds" : 2252.61339366436,
      "index" : 9,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1605.1676232716436,
      "renderedSegmentMarkerDurationSeconds" : 591.8765020370483,
      "renderedSegmentMarkerEndOffsetSeconds" : 2252.61339366436,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1660.7368916273117,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-03T12:12:49Z",
      "startOffsetSeconds" : 1660.7368916273117,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 390.93000519275665,
      "endDate" : "2026-06-03T12:20:01Z",
      "endOffsetSeconds" : 2093.048141002655,
      "index" : 10,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 996.8050733037735,
      "renderedSegmentMarkerDurationSeconds" : 390.93000519275665,
      "renderedSegmentMarkerEndOffsetSeconds" : 2093.048141002655,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1702.1181358098984,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-03T12:13:30Z",
      "startOffsetSeconds" : 1702.1181358098984,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 241.16491448879242,
      "endDate" : "2026-06-03T12:24:02Z",
      "endOffsetSeconds" : 2334.2130554914474,
      "index" : 11,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 660.1533391635658,
      "renderedSegmentMarkerDurationSeconds" : 241.16491448879242,
      "renderedSegmentMarkerEndOffsetSeconds" : 2334.2130554914474,
      "renderedSegmentMarkerKind" : "rawSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 2093.048141002655,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-03T12:20:01Z",
      "startOffsetSeconds" : 2093.048141002655,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 81.5996618270874,
      "endDate" : "2026-06-03T12:24:02Z",
      "endOffsetSeconds" : 2334.2130554914474,
      "index" : 12,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 223.77043441877777,
      "renderedSegmentMarkerDurationSeconds" : 81.5996618270874,
      "renderedSegmentMarkerEndOffsetSeconds" : 2334.2130554914474,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 2252.61339366436,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-03T12:22:41Z",
      "startOffsetSeconds" : 2252.61339366436,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 0,
      "endDate" : "2026-06-03T12:24:05Z",
      "endOffsetSeconds" : 2336.7247059345245,
      "excludedOrFilteredReason" : "zeroOrNegativeDuration",
      "index" : 13,
      "metadataKeys" : [

      ],
      "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
      "startDate" : "2026-06-03T12:24:05Z",
      "startOffsetSeconds" : 2336.7247059345245,
      "type" : "HKWorkoutEventType(rawValue: 1)",
      "usedBySegmentMarkerRendering" : false
    }
  ],
  "reconstructedIntervals" : [
    {
      "averageHeartRateBpm" : 126.49342105263158,
      "averagePower" : 190.22108843537416,
      "boundaryAdjustmentSeconds" : 0.649585485458374,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 2001.4803571118973,
          "endDate" : "2026-06-03T11:57:51Z",
          "endOffsetSeconds" : 762.3678689002991,
          "startCumulativeDistanceMeters" : 1995.6178373540752,
          "startDate" : "2026-06-03T11:57:48Z",
          "startOffsetSeconds" : 759.7953763008118
        },
        "cumulativeDistanceAtEndMeters" : 2001.4803571118973,
        "cumulativeDistanceAtStartMeters" : 0,
        "interpolationFraction" : 0.7474879108216002,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2009.2362459553406,
          "endDate" : "2026-06-03T11:57:53Z",
          "endOffsetSeconds" : 764.9403622150421,
          "startCumulativeDistanceMeters" : 2001.4803571118973,
          "startDate" : "2026-06-03T11:57:51Z",
          "startOffsetSeconds" : 762.3678689002991
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 1995.6178373540752,
          "endDate" : "2026-06-03T11:57:48Z",
          "endOffsetSeconds" : 759.7953763008118,
          "startCumulativeDistanceMeters" : 1988.46186853759,
          "startDate" : "2026-06-03T11:57:45Z",
          "startOffsetSeconds" : 757.2228845357895
        },
        "targetDistanceMeters" : 2000
      },
      "boundaryOvershootMeters" : 1.4803571118973196,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "distanceMeters" : 2001.4803571118973,
      "durationSeconds" : 762.3678689002991,
      "endOffsetSeconds" : 762.3678689002991,
      "index" : 1,
      "label" : "Warmup",
      "maxHeartRateBpm" : 144,
      "paceSecondsPerKm" : 380.9019989586024,
      "plannedGoalDisplayText" : "2 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 2000,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +0.6s, overshoot 1.5 m",
      "startOffsetSeconds" : 0,
      "stepType" : "warmup"
    },
    {
      "averageHeartRateBpm" : 166.23529411764707,
      "averagePower" : 284.83838383838383,
      "boundaryAdjustmentSeconds" : 0.532201886177063,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3003.3969073158223,
          "endDate" : "2026-06-03T12:02:03Z",
          "endOffsetSeconds" : 1014.4723151922226,
          "startCumulativeDistanceMeters" : 2994.1328706021886,
          "startDate" : "2026-06-03T12:02:00Z",
          "startOffsetSeconds" : 1011.8998090028763
        },
        "cumulativeDistanceAtEndMeters" : 3003.3969073158223,
        "cumulativeDistanceAtStartMeters" : 2001.4803571118973,
        "interpolationFraction" : 0.7931193211805333,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3016.1272426524665,
          "endDate" : "2026-06-03T12:02:05Z",
          "endOffsetSeconds" : 1017.0448224544525,
          "startCumulativeDistanceMeters" : 3003.3969073158223,
          "startDate" : "2026-06-03T12:02:03Z",
          "startOffsetSeconds" : 1014.4723151922226
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 2994.1328706021886,
          "endDate" : "2026-06-03T12:02:00Z",
          "endOffsetSeconds" : 1011.8998090028763,
          "startCumulativeDistanceMeters" : 2984.2827832160983,
          "startDate" : "2026-06-03T12:01:58Z",
          "startOffsetSeconds" : 1009.3273077011108
        },
        "targetDistanceMeters" : 1000
      },
      "boundaryOvershootMeters" : 1.9165502039249986,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "distanceMeters" : 1001.916550203925,
      "durationSeconds" : 252.10444629192352,
      "endOffsetSeconds" : 1014.4723151922226,
      "index" : 2,
      "label" : "Work 1",
      "maxHeartRateBpm" : 174,
      "paceSecondsPerKm" : 251.6221997137501,
      "plannedGoalDisplayText" : "1 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 1000,
      "plannedTargetDisplayText" : "pace 4:00 \/km, speed 4.17 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +0.5s, overshoot 1.9 m",
      "startOffsetSeconds" : 762.3678689002991,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 146.56666666666666,
      "averagePower" : 93.83050847457628,
      "confidence" : "high",
      "distanceMeters" : 218.0779792302228,
      "durationSeconds" : 150,
      "endOffsetSeconds" : 1164.4723151922226,
      "index" : 3,
      "label" : "Recovery 1",
      "maxHeartRateBpm" : 174,
      "paceSecondsPerKm" : 687.827356661474,
      "plannedGoalDisplayText" : "150 s",
      "plannedGoalType" : "time",
      "plannedGoalValue" : 150,
      "sourceNote" : "Time-goal window reconstructed from WorkoutKit duration; TODO pause-adjusted active duration",
      "startOffsetSeconds" : 1014.4723151922226,
      "stepType" : "recovery"
    },
    {
      "averageHeartRateBpm" : 167.44897959183675,
      "averagePower" : 289.6914893617021,
      "boundaryAdjustmentSeconds" : 0.40349841117858887,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 4223.137398585677,
          "endDate" : "2026-06-03T12:08:39Z",
          "endOffsetSeconds" : 1410.6429206132889,
          "startCumulativeDistanceMeters" : 4212.537871825043,
          "startDate" : "2026-06-03T12:08:36Z",
          "startOffsetSeconds" : 1408.070372581482
        },
        "cumulativeDistanceAtEndMeters" : 4223.137398585677,
        "cumulativeDistanceAtStartMeters" : 3221.474886546045,
        "interpolationFraction" : 0.843152239040852,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 4235.193161340198,
          "endDate" : "2026-06-03T12:08:41Z",
          "endOffsetSeconds" : 1413.2154661417007,
          "startCumulativeDistanceMeters" : 4223.137398585677,
          "startDate" : "2026-06-03T12:08:39Z",
          "startOffsetSeconds" : 1410.6429206132889
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 4212.537871825043,
          "endDate" : "2026-06-03T12:08:36Z",
          "endOffsetSeconds" : 1408.070372581482,
          "startCumulativeDistanceMeters" : 4202.032815427519,
          "startDate" : "2026-06-03T12:08:34Z",
          "startOffsetSeconds" : 1405.4978235960007
        },
        "targetDistanceMeters" : 1000
      },
      "boundaryOvershootMeters" : 1.6625120396320199,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "distanceMeters" : 1001.662512039632,
      "durationSeconds" : 246.17060542106628,
      "endOffsetSeconds" : 1410.6429206132889,
      "index" : 4,
      "label" : "Work 2",
      "maxHeartRateBpm" : 180,
      "paceSecondsPerKm" : 245.76202309878022,
      "plannedGoalDisplayText" : "1 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 1000,
      "plannedTargetDisplayText" : "pace 4:00 \/km, speed 4.17 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +0.4s, overshoot 1.7 m",
      "startOffsetSeconds" : 1164.4723151922226,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 153.86666666666667,
      "averagePower" : 94.32203389830508,
      "confidence" : "high",
      "distanceMeters" : 210.152753663946,
      "durationSeconds" : 150,
      "endOffsetSeconds" : 1560.6429206132889,
      "index" : 5,
      "label" : "Recovery 2",
      "maxHeartRateBpm" : 180,
      "paceSecondsPerKm" : 713.7665216600687,
      "plannedGoalDisplayText" : "150 s",
      "plannedGoalType" : "time",
      "plannedGoalValue" : 150,
      "sourceNote" : "Time-goal window reconstructed from WorkoutKit duration; TODO pause-adjusted active duration",
      "startOffsetSeconds" : 1410.6429206132889,
      "stepType" : "recovery"
    },
    {
      "averageHeartRateBpm" : 172.0212765957447,
      "averagePower" : 294.5425531914894,
      "boundaryAdjustmentSeconds" : 0.9306919574737549,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 5437.282878906932,
          "endDate" : "2026-06-03T12:15:10Z",
          "endOffsetSeconds" : 1801.6756726503372,
          "startCumulativeDistanceMeters" : 5426.2463395795785,
          "startDate" : "2026-06-03T12:15:07Z",
          "startOffsetSeconds" : 1799.1030902862549
        },
        "cumulativeDistanceAtEndMeters" : 5437.282878906932,
        "cumulativeDistanceAtStartMeters" : 4433.290152249623,
        "interpolationFraction" : 0.6382265727615432,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 5449.459950007498,
          "endDate" : "2026-06-03T12:15:13Z",
          "endOffsetSeconds" : 1804.2482550144196,
          "startCumulativeDistanceMeters" : 5437.282878906932,
          "startDate" : "2026-06-03T12:15:10Z",
          "startOffsetSeconds" : 1801.6756726503372
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 5426.2463395795785,
          "endDate" : "2026-06-03T12:15:07Z",
          "endOffsetSeconds" : 1799.1030902862549,
          "startCumulativeDistanceMeters" : 5414.2246238014195,
          "startDate" : "2026-06-03T12:15:05Z",
          "startOffsetSeconds" : 1796.5305081605911
        },
        "targetDistanceMeters" : 1000
      },
      "boundaryOvershootMeters" : 3.9927266573085944,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "distanceMeters" : 1003.9927266573086,
      "durationSeconds" : 241.03275203704834,
      "endOffsetSeconds" : 1801.6756726503372,
      "index" : 6,
      "label" : "Work 3",
      "maxHeartRateBpm" : 185,
      "paceSecondsPerKm" : 240.07420137349234,
      "plannedGoalDisplayText" : "1 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 1000,
      "plannedTargetDisplayText" : "pace 4:00 \/km, speed 4.17 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +0.9s, overshoot 4.0 m",
      "startOffsetSeconds" : 1560.6429206132889,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 160.56666666666666,
      "averagePower" : 98.34545454545454,
      "confidence" : "high",
      "distanceMeters" : 199.11763657189385,
      "durationSeconds" : 150,
      "endOffsetSeconds" : 1951.6756726503372,
      "index" : 7,
      "label" : "Recovery 3",
      "maxHeartRateBpm" : 185,
      "paceSecondsPerKm" : 753.323525642796,
      "plannedGoalDisplayText" : "150 s",
      "plannedGoalType" : "time",
      "plannedGoalValue" : 150,
      "sourceNote" : "Time-goal window reconstructed from WorkoutKit duration; TODO pause-adjusted active duration",
      "startOffsetSeconds" : 1801.6756726503372,
      "stepType" : "recovery"
    },
    {
      "averageHeartRateBpm" : 155.88311688311688,
      "averagePower" : 194.28859060402684,
      "confidence" : "medium",
      "distanceMeters" : 1031.6583124832023,
      "durationSeconds" : 385.0490332841873,
      "endOffsetSeconds" : 2336.7247059345245,
      "index" : 8,
      "label" : "Cooldown",
      "maxHeartRateBpm" : 166,
      "paceSecondsPerKm" : 373.2331030778727,
      "plannedGoalDisplayText" : "Open",
      "plannedGoalType" : "open",
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Planned open cooldown extended to workout end",
      "startOffsetSeconds" : 1951.6756726503372,
      "stepType" : "cooldown"
    }
  ],
  "segmentMarkers" : [
    {
      "averageHeartRateBpm" : 119.2987012987013,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1006.55604171569,
      "durationSeconds" : 379.9435975551605,
      "endOffsetSeconds" : 379.9435975551605,
      "index" : 1,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 377.4688957283897,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 123.67479674796748,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1615.06681563449,
      "durationSeconds" : 614.9445925951004,
      "endOffsetSeconds" : 614.9445925951004,
      "index" : 2,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 380.7548930125935,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 133.88,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1000.7217487151096,
      "durationSeconds" : 384.3471790552139,
      "endOffsetSeconds" : 764.2907766103745,
      "index" : 3,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 384.0699770427711,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 379.9435975551605
    },
    {
      "averageHeartRateBpm" : 153.54545454545453,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1607.8343176178269,
      "durationSeconds" : 550.4202084541321,
      "endOffsetSeconds" : 1165.3648010492325,
      "index" : 4,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 342.3363977388147,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 614.9445925951004
    },
    {
      "averageHeartRateBpm" : 166.23529411764707,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1004.1815338972874,
      "durationSeconds" : 251.8107671737671,
      "endOffsetSeconds" : 1016.1015437841415,
      "index" : 5,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 250.76219654874026,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 764.2907766103745
    },
    {
      "averageHeartRateBpm" : 156.66666666666666,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row."
      ],
      "confidence" : "limited",
      "distanceMeters" : 998.4019999002603,
      "durationSeconds" : 343.43529987335205,
      "endOffsetSeconds" : 1359.5368436574936,
      "index" : 6,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 343.98498791835453,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1016.1015437841415
    },
    {
      "averageHeartRateBpm" : 161.6060606060606,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1616.2196370192896,
      "durationSeconds" : 495.3720905780792,
      "endOffsetSeconds" : 1660.7368916273117,
      "index" : 7,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 306.50047755369957,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1165.3648010492325
    },
    {
      "averageHeartRateBpm" : 162.05882352941177,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1001.2390912663413,
      "durationSeconds" : 342.5812921524048,
      "endOffsetSeconds" : 1702.1181358098984,
      "index" : 8,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 342.15732799557077,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1359.5368436574936
    },
    {
      "averageHeartRateBpm" : 161.92307692307693,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1605.1676232716436,
      "durationSeconds" : 591.8765020370483,
      "endOffsetSeconds" : 2252.61339366436,
      "index" : 9,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 368.73189656709434,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1660.7368916273117
    },
    {
      "averageHeartRateBpm" : 161.0909090909091,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 996.8050733037735,
      "durationSeconds" : 390.93000519275665,
      "endOffsetSeconds" : 2093.048141002655,
      "index" : 10,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 392.1830011328823,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1702.1181358098984
    },
    {
      "averageHeartRateBpm" : 161,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event is a raw HealthKit marker until interval parity is proven."
      ],
      "confidence" : "limited",
      "distanceMeters" : 660.1533391635658,
      "durationSeconds" : 241.16491448879242,
      "endOffsetSeconds" : 2334.2130554914474,
      "index" : 11,
      "label" : "unknown",
      "markerKind" : "rawSegmentMarker",
      "paceSecondsPerKm" : 365.3165108493667,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 2093.048141002655
    },
    {
      "averageHeartRateBpm" : 163.64705882352942,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 223.77043441877777,
      "durationSeconds" : 81.5996618270874,
      "endOffsetSeconds" : 2334.2130554914474,
      "index" : 12,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 364.65792292460213,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 2252.61339366436
    }
  ],
  "sourceNotes" : [
    "Plan source: WorkoutKit",
    "Window source: Plan-derived from HealthKit distance\/time samples",
    "Stats source: HealthKit samples",
    "HealthKit segment markers: not used"
  ],
  "workout" : {
    "averageHeartRate" : 149.99652484267872,
    "averagePower" : 204.13222222222223,
    "cadenceSpm" : 166.72247990323976,
    "deviceName" : "Apple Watch Apple Inc. Watch",
    "distanceMeters" : 6668.058827962028,
    "durationSeconds" : 2336.7247059345245,
    "elapsedSeconds" : 2336.7247059345245,
    "endDate" : "2026-06-03T12:24:05Z",
    "id" : "F6D47A51-9510-4C7A-9186-6BAFE3C128C9",
    "maxHeartRate" : 185,
    "paceSecondsPerKm" : 350.4355264737072,
    "sourceID" : "F6D47A51-9510-4C7A-9186-6BAFE3C128C9",
    "sourceName" : "Adriel’s Apple Watch",
    "startDate" : "2026-06-03T11:45:08Z"
  },
  "workoutActivities" : [
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 762.3678689002991,
      "durationSeconds" : 767.306872844696,
      "endDate" : "2026-06-03T11:57:56Z",
      "endOffsetSeconds" : 767.306872844696,
      "events" : [
        {
          "durationSeconds" : 379.9435975551605,
          "endDate" : "2026-06-03T11:51:28Z",
          "endOffsetSeconds" : 379.9435975551605,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1006.55604171569,
          "renderedSegmentMarkerDurationSeconds" : 379.9435975551605,
          "renderedSegmentMarkerEndOffsetSeconds" : 379.9435975551605,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T11:45:08Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 614.9445925951004,
          "endDate" : "2026-06-03T11:55:23Z",
          "endOffsetSeconds" : 614.9445925951004,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1615.06681563449,
          "renderedSegmentMarkerDurationSeconds" : 614.9445925951004,
          "renderedSegmentMarkerEndOffsetSeconds" : 614.9445925951004,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T11:45:08Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 384.3471790552139,
          "endDate" : "2026-06-03T11:57:53Z",
          "endOffsetSeconds" : 764.2907766103745,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1000.7217487151096,
          "renderedSegmentMarkerDurationSeconds" : 384.3471790552139,
          "renderedSegmentMarkerEndOffsetSeconds" : 764.2907766103745,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 379.9435975551605,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T11:51:28Z",
          "startOffsetSeconds" : 379.9435975551605,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 550.4202084541321,
          "endDate" : "2026-06-03T12:04:34Z",
          "endOffsetSeconds" : 1165.3648010492325,
          "index" : 4,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1607.8343176178269,
          "renderedSegmentMarkerDurationSeconds" : 550.4202084541321,
          "renderedSegmentMarkerEndOffsetSeconds" : 1165.3648010492325,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 614.9445925951004,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T11:55:23Z",
          "startOffsetSeconds" : 614.9445925951004,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 251.8107671737671,
          "endDate" : "2026-06-03T12:02:04Z",
          "endOffsetSeconds" : 1016.1015437841415,
          "index" : 5,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1004.1815338972874,
          "renderedSegmentMarkerDurationSeconds" : 251.8107671737671,
          "renderedSegmentMarkerEndOffsetSeconds" : 1016.1015437841415,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 764.2907766103745,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T11:57:53Z",
          "startOffsetSeconds" : 764.2907766103745,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "5 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "AFC8AC6D-6FA8-4AEC-9F97-EE5CC113BF48",
      "index" : 1,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -3.0160962343215942,
      "nearestRawEventEndOffsetSeconds" : 764.2907766103745,
      "nearestRawEventStartDeltaSeconds" : 0,
      "nearestRawEventStartOffsetSeconds" : 0,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -4.939003944396973,
      "nearestReconstructedIntervalEndOffsetSeconds" : 762.3678689002991,
      "nearestReconstructedIntervalIndex" : 1,
      "nearestReconstructedIntervalLabel" : "Warmup",
      "nearestSegmentMarkerEndDeltaSeconds" : -3.0160962343215942,
      "nearestSegmentMarkerEndOffsetSeconds" : 764.2907766103745,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : 0,
      "nearestSegmentMarkerStartOffsetSeconds" : 0,
      "nextDistanceSampleEndOffsetSeconds" : 764.9403622150421,
      "previousDistanceSampleEndOffsetSeconds" : 759.7953763008118,
      "startDate" : "2026-06-03T11:45:08Z",
      "startOffsetSeconds" : 0,
      "statistics" : [
        {
          "endDate" : "2026-06-03T11:57:56Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T11:45:08Z",
          "sum" : 120.84981947026402,
          "summary" : "ActiveEnergyBurned: sum 120.8 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-03T11:57:56Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T11:45:08Z",
          "sum" : 18.790997320650025,
          "summary" : "BasalEnergyBurned: sum 18.8 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-03T11:57:56Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T11:45:08Z",
          "sum" : 2008.615227742627,
          "summary" : "DistanceWalkingRunning: sum 2008.6 m",
          "unit" : "m"
        },
        {
          "average" : 126.15123972003038,
          "endDate" : "2026-06-03T11:57:56Z",
          "maximum" : 144,
          "minimum" : 83,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T11:45:08Z",
          "summary" : "HeartRate: avg 126.2 bpm, min 83.0 bpm, max 144.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 265.5620437956203,
          "endDate" : "2026-06-03T11:57:56Z",
          "maximum" : 292,
          "minimum" : 244,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T11:45:08Z",
          "summary" : "RunningGroundContactTime: avg 265.6 ms, min 244.0 ms, max 292.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 190.2203389830508,
          "endDate" : "2026-06-03T11:57:56Z",
          "maximum" : 207,
          "minimum" : 176,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T11:45:08Z",
          "summary" : "RunningPower: avg 190.2 W, min 176.0 W, max 207.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.68003706269524,
          "endDate" : "2026-06-03T11:57:56Z",
          "maximum" : 2.979107518909111,
          "minimum" : 1.642800047426931,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T11:45:08Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 1.6 m\/s, max 3.0 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9018248175182482,
          "endDate" : "2026-06-03T11:57:56Z",
          "maximum" : 0.97,
          "minimum" : 0.85,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T11:45:08Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.8 m, max 1.0 m",
          "unit" : "m"
        },
        {
          "average" : 7.828985507246376,
          "endDate" : "2026-06-03T11:57:56Z",
          "maximum" : 8.1,
          "minimum" : 7.3999999999999995,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T11:45:08Z",
          "summary" : "RunningVerticalOscillation: avg 7.8 cm, min 7.4 cm, max 8.1 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-03T11:57:56Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T11:45:08Z",
          "sum" : 2266.3594356750086,
          "summary" : "StepCount: sum 2266.4 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 120.8 kcal; BasalEnergyBurned: sum 18.8 kcal; DistanceWalkingRunning: sum 2008.6 m; HeartRate: avg 126.2 bpm, min 83.0 bpm, max 144.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1014.4723151922226,
      "durationSeconds" : 251.829061627388,
      "endDate" : "2026-06-03T12:02:07Z",
      "endOffsetSeconds" : 1019.135934472084,
      "events" : [
        {
          "durationSeconds" : 550.4202084541321,
          "endDate" : "2026-06-03T12:04:34Z",
          "endOffsetSeconds" : 1165.3648010492325,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1607.8343176178269,
          "renderedSegmentMarkerDurationSeconds" : 550.4202084541321,
          "renderedSegmentMarkerEndOffsetSeconds" : 1165.3648010492325,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 614.9445925951004,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T11:55:23Z",
          "startOffsetSeconds" : 614.9445925951004,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 251.8107671737671,
          "endDate" : "2026-06-03T12:02:04Z",
          "endOffsetSeconds" : 1016.1015437841415,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1004.1815338972874,
          "renderedSegmentMarkerDurationSeconds" : 251.8107671737671,
          "renderedSegmentMarkerEndOffsetSeconds" : 1016.1015437841415,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 764.2907766103745,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T11:57:53Z",
          "startOffsetSeconds" : 764.2907766103745,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 343.43529987335205,
          "endDate" : "2026-06-03T12:07:48Z",
          "endOffsetSeconds" : 1359.5368436574936,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 998.4019999002603,
          "renderedSegmentMarkerDurationSeconds" : 343.43529987335205,
          "renderedSegmentMarkerEndOffsetSeconds" : 1359.5368436574936,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1016.1015437841415,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T12:02:04Z",
          "startOffsetSeconds" : 1016.1015437841415,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "3 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "0E1C18CB-38FE-4BC1-9A71-F32087C147A9",
      "index" : 2,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -3.034390687942505,
      "nearestRawEventEndOffsetSeconds" : 1016.1015437841415,
      "nearestRawEventStartDeltaSeconds" : -3.0160962343215942,
      "nearestRawEventStartOffsetSeconds" : 764.2907766103745,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -4.66361927986145,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1014.4723151922226,
      "nearestReconstructedIntervalIndex" : 2,
      "nearestReconstructedIntervalLabel" : "Work 1",
      "nearestSegmentMarkerEndDeltaSeconds" : -3.034390687942505,
      "nearestSegmentMarkerEndOffsetSeconds" : 1016.1015437841415,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -3.0160962343215942,
      "nearestSegmentMarkerStartOffsetSeconds" : 764.2907766103745,
      "nextDistanceSampleEndOffsetSeconds" : 1017.0448224544525,
      "previousDistanceSampleEndOffsetSeconds" : 1011.8998090028763,
      "startDate" : "2026-06-03T11:57:56Z",
      "startOffsetSeconds" : 767.306872844696,
      "statistics" : [
        {
          "endDate" : "2026-06-03T12:02:07Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T11:57:56Z",
          "sum" : 62.90116763981276,
          "summary" : "ActiveEnergyBurned: sum 62.9 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-03T12:02:07Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T11:57:56Z",
          "sum" : 6.167255187059584,
          "summary" : "BasalEnergyBurned: sum 6.2 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-03T12:02:07Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T11:57:56Z",
          "sum" : 1005.1297732402121,
          "summary" : "DistanceWalkingRunning: sum 1005.1 m",
          "unit" : "m"
        },
        {
          "average" : 165.67356904988713,
          "endDate" : "2026-06-03T12:02:07Z",
          "maximum" : 174,
          "minimum" : 144,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T11:57:56Z",
          "summary" : "HeartRate: avg 165.7 bpm, min 144.0 bpm, max 174.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 221.59090909090907,
          "endDate" : "2026-06-03T12:02:07Z",
          "maximum" : 265,
          "minimum" : 201,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T11:57:56Z",
          "summary" : "RunningGroundContactTime: avg 221.6 ms, min 201.0 ms, max 265.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 286.7653061224491,
          "endDate" : "2026-06-03T12:02:07Z",
          "maximum" : 304,
          "minimum" : 192,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T11:57:56Z",
          "summary" : "RunningPower: avg 286.8 W, min 192.0 W, max 304.0 W",
          "unit" : "W"
        },
        {
          "average" : 4.070054452328594,
          "endDate" : "2026-06-03T12:02:07Z",
          "maximum" : 4.328489476098541,
          "minimum" : 2.6915182450512427,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T11:57:56Z",
          "summary" : "RunningSpeed: avg 4.1 m\/s, min 2.7 m\/s, max 4.3 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 1.2254545454545458,
          "endDate" : "2026-06-03T12:02:07Z",
          "maximum" : 1.4,
          "minimum" : 0.91,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T11:57:56Z",
          "summary" : "RunningStrideLength: avg 1.2 m, min 0.9 m, max 1.4 m",
          "unit" : "m"
        },
        {
          "average" : 7.777777777777777,
          "endDate" : "2026-06-03T12:02:07Z",
          "maximum" : 8.1,
          "minimum" : 7.3999999999999995,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T11:57:56Z",
          "summary" : "RunningVerticalOscillation: avg 7.8 cm, min 7.4 cm, max 8.1 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-03T12:02:07Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T11:57:56Z",
          "sum" : 789.9563844145902,
          "summary" : "StepCount: sum 790.0 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 62.9 kcal; BasalEnergyBurned: sum 6.2 kcal; DistanceWalkingRunning: sum 1005.1 m; HeartRate: avg 165.7 bpm, min 144.0 bpm, max 174.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "durationSeconds" : 149.04158008098602,
      "endDate" : "2026-06-03T12:04:36Z",
      "endOffsetSeconds" : 1168.17751455307,
      "events" : [
        {
          "durationSeconds" : 550.4202084541321,
          "endDate" : "2026-06-03T12:04:34Z",
          "endOffsetSeconds" : 1165.3648010492325,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1607.8343176178269,
          "renderedSegmentMarkerDurationSeconds" : 550.4202084541321,
          "renderedSegmentMarkerEndOffsetSeconds" : 1165.3648010492325,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 614.9445925951004,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T11:55:23Z",
          "startOffsetSeconds" : 614.9445925951004,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 343.43529987335205,
          "endDate" : "2026-06-03T12:07:48Z",
          "endOffsetSeconds" : 1359.5368436574936,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 998.4019999002603,
          "renderedSegmentMarkerDurationSeconds" : 343.43529987335205,
          "renderedSegmentMarkerEndOffsetSeconds" : 1359.5368436574936,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1016.1015437841415,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T12:02:04Z",
          "startOffsetSeconds" : 1016.1015437841415,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 495.3720905780792,
          "endDate" : "2026-06-03T12:12:49Z",
          "endOffsetSeconds" : 1660.7368916273117,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1616.2196370192896,
          "renderedSegmentMarkerDurationSeconds" : 495.3720905780792,
          "renderedSegmentMarkerEndOffsetSeconds" : 1660.7368916273117,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1165.3648010492325,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T12:04:34Z",
          "startOffsetSeconds" : 1165.3648010492325,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "3 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "AFDCD7A9-88F5-4BD6-9162-C2138EBE690B",
      "index" : 3,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -2.8127135038375854,
      "nearestRawEventEndOffsetSeconds" : 1165.3648010492325,
      "nearestRawEventStartDeltaSeconds" : -3.034390687942505,
      "nearestRawEventStartOffsetSeconds" : 1016.1015437841415,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -3.705199360847473,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1164.4723151922226,
      "nearestReconstructedIntervalIndex" : 3,
      "nearestReconstructedIntervalLabel" : "Recovery 1",
      "nearestSegmentMarkerEndDeltaSeconds" : -2.8127135038375854,
      "nearestSegmentMarkerEndOffsetSeconds" : 1165.3648010492325,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -3.034390687942505,
      "nearestSegmentMarkerStartOffsetSeconds" : 1016.1015437841415,
      "startDate" : "2026-06-03T12:02:07Z",
      "startOffsetSeconds" : 1019.135934472084,
      "statistics" : [
        {
          "endDate" : "2026-06-03T12:04:36Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:02:07Z",
          "sum" : 11.910048057663793,
          "summary" : "ActiveEnergyBurned: sum 11.9 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-03T12:04:36Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:02:07Z",
          "sum" : 3.6499694085466072,
          "summary" : "BasalEnergyBurned: sum 3.6 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-03T12:04:36Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:02:07Z",
          "sum" : 209.53992788358676,
          "summary" : "DistanceWalkingRunning: sum 209.5 m",
          "unit" : "m"
        },
        {
          "average" : 146.94610165476823,
          "endDate" : "2026-06-03T12:04:36Z",
          "maximum" : 174,
          "minimum" : 128,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:02:07Z",
          "summary" : "HeartRate: avg 146.9 bpm, min 128.0 bpm, max 174.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 264,
          "endDate" : "2026-06-03T12:04:36Z",
          "maximum" : 318,
          "minimum" : 210,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:02:07Z",
          "summary" : "RunningGroundContactTime: avg 264.0 ms, min 210.0 ms, max 318.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 86.93103448275863,
          "endDate" : "2026-06-03T12:04:36Z",
          "maximum" : 293,
          "minimum" : 56,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:02:07Z",
          "summary" : "RunningPower: avg 86.9 W, min 56.0 W, max 293.0 W",
          "unit" : "W"
        },
        {
          "average" : 1.4108153858173786,
          "endDate" : "2026-06-03T12:04:36Z",
          "maximum" : 4.161892572203379,
          "minimum" : 0.7146634757747599,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:02:07Z",
          "summary" : "RunningSpeed: avg 1.4 m\/s, min 0.7 m\/s, max 4.2 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 1.32,
          "endDate" : "2026-06-03T12:04:36Z",
          "maximum" : 1.32,
          "minimum" : 1.32,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:02:07Z",
          "summary" : "RunningStrideLength: avg 1.3 m, min 1.3 m, max 1.3 m",
          "unit" : "m"
        },
        {
          "average" : 8.45,
          "endDate" : "2026-06-03T12:04:36Z",
          "maximum" : 8.6,
          "minimum" : 8.3,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:02:07Z",
          "summary" : "RunningVerticalOscillation: avg 8.4 cm, min 8.3 cm, max 8.6 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-03T12:04:36Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:02:07Z",
          "sum" : 250.68417991040124,
          "summary" : "StepCount: sum 250.7 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 11.9 kcal; BasalEnergyBurned: sum 3.6 kcal; DistanceWalkingRunning: sum 209.5 m; HeartRate: avg 146.9 bpm, min 128.0 bpm, max 174.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1410.6429206132889,
      "durationSeconds" : 246.18645083904266,
      "endDate" : "2026-06-03T12:08:43Z",
      "endOffsetSeconds" : 1414.3639653921127,
      "events" : [
        {
          "durationSeconds" : 343.43529987335205,
          "endDate" : "2026-06-03T12:07:48Z",
          "endOffsetSeconds" : 1359.5368436574936,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 998.4019999002603,
          "renderedSegmentMarkerDurationSeconds" : 343.43529987335205,
          "renderedSegmentMarkerEndOffsetSeconds" : 1359.5368436574936,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1016.1015437841415,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T12:02:04Z",
          "startOffsetSeconds" : 1016.1015437841415,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 495.3720905780792,
          "endDate" : "2026-06-03T12:12:49Z",
          "endOffsetSeconds" : 1660.7368916273117,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1616.2196370192896,
          "renderedSegmentMarkerDurationSeconds" : 495.3720905780792,
          "renderedSegmentMarkerEndOffsetSeconds" : 1660.7368916273117,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1165.3648010492325,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T12:04:34Z",
          "startOffsetSeconds" : 1165.3648010492325,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 342.5812921524048,
          "endDate" : "2026-06-03T12:13:30Z",
          "endOffsetSeconds" : 1702.1181358098984,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1001.2390912663413,
          "renderedSegmentMarkerDurationSeconds" : 342.5812921524048,
          "renderedSegmentMarkerEndOffsetSeconds" : 1702.1181358098984,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1359.5368436574936,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T12:07:48Z",
          "startOffsetSeconds" : 1359.5368436574936,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "3 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "F92484A7-BC29-4CFE-9A0A-5794D4D61CB2",
      "index" : 4,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -54.82712173461914,
      "nearestRawEventEndOffsetSeconds" : 1359.5368436574936,
      "nearestRawEventStartDeltaSeconds" : -2.8127135038375854,
      "nearestRawEventStartOffsetSeconds" : 1165.3648010492325,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -3.7210447788238525,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1410.6429206132889,
      "nearestReconstructedIntervalIndex" : 4,
      "nearestReconstructedIntervalLabel" : "Work 2",
      "nearestSegmentMarkerEndDeltaSeconds" : -54.82712173461914,
      "nearestSegmentMarkerEndOffsetSeconds" : 1359.5368436574936,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -2.8127135038375854,
      "nearestSegmentMarkerStartOffsetSeconds" : 1165.3648010492325,
      "nextDistanceSampleEndOffsetSeconds" : 1413.2154661417007,
      "previousDistanceSampleEndOffsetSeconds" : 1408.070372581482,
      "startDate" : "2026-06-03T12:04:36Z",
      "startOffsetSeconds" : 1168.17751455307,
      "statistics" : [
        {
          "endDate" : "2026-06-03T12:08:43Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:04:36Z",
          "sum" : 62.1937954750463,
          "summary" : "ActiveEnergyBurned: sum 62.2 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-03T12:08:43Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:04:36Z",
          "sum" : 6.028945883783872,
          "summary" : "BasalEnergyBurned: sum 6.0 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-03T12:08:43Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:04:36Z",
          "sum" : 1005.2347047854886,
          "summary" : "DistanceWalkingRunning: sum 1005.2 m",
          "unit" : "m"
        },
        {
          "average" : 165.98958333333334,
          "endDate" : "2026-06-03T12:08:43Z",
          "maximum" : 180,
          "minimum" : 126,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:04:36Z",
          "summary" : "HeartRate: avg 166.0 bpm, min 126.0 bpm, max 180.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 207.65000000000003,
          "endDate" : "2026-06-03T12:08:43Z",
          "maximum" : 217,
          "minimum" : 198,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:04:36Z",
          "summary" : "RunningGroundContactTime: avg 207.7 ms, min 198.0 ms, max 217.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 292.1684210526315,
          "endDate" : "2026-06-03T12:08:43Z",
          "maximum" : 330,
          "minimum" : 100,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:04:36Z",
          "summary" : "RunningPower: avg 292.2 W, min 100.0 W, max 330.0 W",
          "unit" : "W"
        },
        {
          "average" : 4.148885996139765,
          "endDate" : "2026-06-03T12:08:43Z",
          "maximum" : 4.695551217520088,
          "minimum" : 1.6348984760458027,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:04:36Z",
          "summary" : "RunningSpeed: avg 4.1 m\/s, min 1.6 m\/s, max 4.7 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 1.27953488372093,
          "endDate" : "2026-06-03T12:08:43Z",
          "maximum" : 1.38,
          "minimum" : 1.14,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:04:36Z",
          "summary" : "RunningStrideLength: avg 1.3 m, min 1.1 m, max 1.4 m",
          "unit" : "m"
        },
        {
          "average" : 7.943902439024391,
          "endDate" : "2026-06-03T12:08:43Z",
          "maximum" : 8.4,
          "minimum" : 7.3,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:04:36Z",
          "summary" : "RunningVerticalOscillation: avg 7.9 cm, min 7.3 cm, max 8.4 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-03T12:08:43Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:04:36Z",
          "sum" : 766.0180050472519,
          "summary" : "StepCount: sum 766.0 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 62.2 kcal; BasalEnergyBurned: sum 6.0 kcal; DistanceWalkingRunning: sum 1005.2 m; HeartRate: avg 166.0 bpm, min 126.0 bpm, max 180.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "durationSeconds" : 149.89954495429993,
      "endDate" : "2026-06-03T12:11:13Z",
      "endOffsetSeconds" : 1564.2635103464127,
      "events" : [
        {
          "durationSeconds" : 495.3720905780792,
          "endDate" : "2026-06-03T12:12:49Z",
          "endOffsetSeconds" : 1660.7368916273117,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1616.2196370192896,
          "renderedSegmentMarkerDurationSeconds" : 495.3720905780792,
          "renderedSegmentMarkerEndOffsetSeconds" : 1660.7368916273117,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1165.3648010492325,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T12:04:34Z",
          "startOffsetSeconds" : 1165.3648010492325,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 342.5812921524048,
          "endDate" : "2026-06-03T12:13:30Z",
          "endOffsetSeconds" : 1702.1181358098984,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1001.2390912663413,
          "renderedSegmentMarkerDurationSeconds" : 342.5812921524048,
          "renderedSegmentMarkerEndOffsetSeconds" : 1702.1181358098984,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1359.5368436574936,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T12:07:48Z",
          "startOffsetSeconds" : 1359.5368436574936,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "2 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "C767303E-F8C3-45B0-89DD-E0A4C62C5BB6",
      "index" : 5,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : 96.47338128089905,
      "nearestRawEventEndOffsetSeconds" : 1660.7368916273117,
      "nearestRawEventStartDeltaSeconds" : -54.82712173461914,
      "nearestRawEventStartOffsetSeconds" : 1359.5368436574936,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -3.6205897331237793,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1560.6429206132889,
      "nearestReconstructedIntervalIndex" : 5,
      "nearestReconstructedIntervalLabel" : "Recovery 2",
      "nearestSegmentMarkerEndDeltaSeconds" : 96.47338128089905,
      "nearestSegmentMarkerEndOffsetSeconds" : 1660.7368916273117,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -54.82712173461914,
      "nearestSegmentMarkerStartOffsetSeconds" : 1359.5368436574936,
      "startDate" : "2026-06-03T12:08:43Z",
      "startOffsetSeconds" : 1414.3639653921127,
      "statistics" : [
        {
          "endDate" : "2026-06-03T12:11:13Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:08:43Z",
          "sum" : 12.309380240244788,
          "summary" : "ActiveEnergyBurned: sum 12.3 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-03T12:11:13Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:08:43Z",
          "sum" : 3.670911166682317,
          "summary" : "BasalEnergyBurned: sum 3.7 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-03T12:11:13Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:08:43Z",
          "sum" : 207.3144335633505,
          "summary" : "DistanceWalkingRunning: sum 207.3 m",
          "unit" : "m"
        },
        {
          "average" : 152.7231182795699,
          "endDate" : "2026-06-03T12:11:13Z",
          "maximum" : 180,
          "minimum" : 127,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:08:43Z",
          "summary" : "HeartRate: avg 152.7 bpm, min 127.0 bpm, max 180.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 204,
          "endDate" : "2026-06-03T12:11:13Z",
          "maximum" : 204,
          "minimum" : 204,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:08:43Z",
          "summary" : "RunningGroundContactTime: avg 204.0 ms, min 204.0 ms, max 204.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 86.81034482758619,
          "endDate" : "2026-06-03T12:11:13Z",
          "maximum" : 307,
          "minimum" : 68,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:08:43Z",
          "summary" : "RunningPower: avg 86.8 W, min 68.0 W, max 307.0 W",
          "unit" : "W"
        },
        {
          "average" : 1.44029074563819,
          "endDate" : "2026-06-03T12:11:13Z",
          "maximum" : 4.361875942660202,
          "minimum" : 1.094241805603148,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:08:43Z",
          "summary" : "RunningSpeed: avg 1.4 m\/s, min 1.1 m\/s, max 4.4 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 1.33,
          "endDate" : "2026-06-03T12:11:13Z",
          "maximum" : 1.33,
          "minimum" : 1.33,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:08:43Z",
          "summary" : "RunningStrideLength: avg 1.3 m, min 1.3 m, max 1.3 m",
          "unit" : "m"
        },
        {
          "average" : 8,
          "endDate" : "2026-06-03T12:11:13Z",
          "maximum" : 8.1,
          "minimum" : 7.9,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:08:43Z",
          "summary" : "RunningVerticalOscillation: avg 8.0 cm, min 7.9 cm, max 8.1 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-03T12:11:13Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:08:43Z",
          "sum" : 245.98612850975667,
          "summary" : "StepCount: sum 246.0 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 12.3 kcal; BasalEnergyBurned: sum 3.7 kcal; DistanceWalkingRunning: sum 207.3 m; HeartRate: avg 152.7 bpm, min 127.0 bpm, max 180.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1801.6756726503372,
      "durationSeconds" : 240.49814558029175,
      "endDate" : "2026-06-03T12:15:13Z",
      "endOffsetSeconds" : 1804.7616559267044,
      "events" : [
        {
          "durationSeconds" : 495.3720905780792,
          "endDate" : "2026-06-03T12:12:49Z",
          "endOffsetSeconds" : 1660.7368916273117,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1616.2196370192896,
          "renderedSegmentMarkerDurationSeconds" : 495.3720905780792,
          "renderedSegmentMarkerEndOffsetSeconds" : 1660.7368916273117,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1165.3648010492325,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T12:04:34Z",
          "startOffsetSeconds" : 1165.3648010492325,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 342.5812921524048,
          "endDate" : "2026-06-03T12:13:30Z",
          "endOffsetSeconds" : 1702.1181358098984,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1001.2390912663413,
          "renderedSegmentMarkerDurationSeconds" : 342.5812921524048,
          "renderedSegmentMarkerEndOffsetSeconds" : 1702.1181358098984,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1359.5368436574936,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T12:07:48Z",
          "startOffsetSeconds" : 1359.5368436574936,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 591.8765020370483,
          "endDate" : "2026-06-03T12:22:41Z",
          "endOffsetSeconds" : 2252.61339366436,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1605.1676232716436,
          "renderedSegmentMarkerDurationSeconds" : 591.8765020370483,
          "renderedSegmentMarkerEndOffsetSeconds" : 2252.61339366436,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1660.7368916273117,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T12:12:49Z",
          "startOffsetSeconds" : 1660.7368916273117,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 390.93000519275665,
          "endDate" : "2026-06-03T12:20:01Z",
          "endOffsetSeconds" : 2093.048141002655,
          "index" : 4,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 996.8050733037735,
          "renderedSegmentMarkerDurationSeconds" : 390.93000519275665,
          "renderedSegmentMarkerEndOffsetSeconds" : 2093.048141002655,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1702.1181358098984,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T12:13:30Z",
          "startOffsetSeconds" : 1702.1181358098984,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "4 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "A90594AA-D89F-403C-8381-8525DE6BF948",
      "index" : 6,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -102.64352011680603,
      "nearestRawEventEndOffsetSeconds" : 1702.1181358098984,
      "nearestRawEventStartDeltaSeconds" : 96.47338128089905,
      "nearestRawEventStartOffsetSeconds" : 1660.7368916273117,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -3.0859832763671875,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1801.6756726503372,
      "nearestReconstructedIntervalIndex" : 6,
      "nearestReconstructedIntervalLabel" : "Work 3",
      "nearestSegmentMarkerEndDeltaSeconds" : -102.64352011680603,
      "nearestSegmentMarkerEndOffsetSeconds" : 1702.1181358098984,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : 96.47338128089905,
      "nearestSegmentMarkerStartOffsetSeconds" : 1660.7368916273117,
      "nextDistanceSampleEndOffsetSeconds" : 1804.2482550144196,
      "previousDistanceSampleEndOffsetSeconds" : 1799.1030902862549,
      "startDate" : "2026-06-03T12:11:13Z",
      "startOffsetSeconds" : 1564.2635103464127,
      "statistics" : [
        {
          "endDate" : "2026-06-03T12:15:13Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:11:13Z",
          "sum" : 62.43613503545694,
          "summary" : "ActiveEnergyBurned: sum 62.4 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-03T12:15:13Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:11:13Z",
          "sum" : 5.889535490087531,
          "summary" : "BasalEnergyBurned: sum 5.9 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-03T12:15:13Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:11:13Z",
          "sum" : 1003.8789472024649,
          "summary" : "DistanceWalkingRunning: sum 1003.9 m",
          "unit" : "m"
        },
        {
          "average" : 170.78976343975017,
          "endDate" : "2026-06-03T12:15:13Z",
          "maximum" : 185,
          "minimum" : 130,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:11:13Z",
          "summary" : "HeartRate: avg 170.8 bpm, min 130.0 bpm, max 185.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 204.2380952380952,
          "endDate" : "2026-06-03T12:15:13Z",
          "maximum" : 219,
          "minimum" : 191,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:11:13Z",
          "summary" : "RunningGroundContactTime: avg 204.2 ms, min 191.0 ms, max 219.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 297.0106382978723,
          "endDate" : "2026-06-03T12:15:13Z",
          "maximum" : 352,
          "minimum" : 84,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:11:13Z",
          "summary" : "RunningPower: avg 297.0 W, min 84.0 W, max 352.0 W",
          "unit" : "W"
        },
        {
          "average" : 4.208883085901556,
          "endDate" : "2026-06-03T12:15:13Z",
          "maximum" : 5.012626527767866,
          "minimum" : 1.4128039939277424,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:11:13Z",
          "summary" : "RunningSpeed: avg 4.2 m\/s, min 1.4 m\/s, max 5.0 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 1.347857142857143,
          "endDate" : "2026-06-03T12:15:13Z",
          "maximum" : 1.57,
          "minimum" : 1.29,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:11:13Z",
          "summary" : "RunningStrideLength: avg 1.3 m, min 1.3 m, max 1.6 m",
          "unit" : "m"
        },
        {
          "average" : 7.981395348837207,
          "endDate" : "2026-06-03T12:15:13Z",
          "maximum" : 8.3,
          "minimum" : 7.3,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:11:13Z",
          "summary" : "RunningVerticalOscillation: avg 8.0 cm, min 7.3 cm, max 8.3 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-03T12:15:13Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:11:13Z",
          "sum" : 760.7919649806903,
          "summary" : "StepCount: sum 760.8 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 62.4 kcal; BasalEnergyBurned: sum 5.9 kcal; DistanceWalkingRunning: sum 1003.9 m; HeartRate: avg 170.8 bpm, min 130.0 bpm, max 185.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 7,
      "alignedPlannedStepLabel" : "Recovery 3",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "durationSeconds" : 149.83583295345306,
      "endDate" : "2026-06-03T12:17:43Z",
      "endOffsetSeconds" : 1954.5974888801575,
      "events" : [
        {
          "durationSeconds" : 591.8765020370483,
          "endDate" : "2026-06-03T12:22:41Z",
          "endOffsetSeconds" : 2252.61339366436,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1605.1676232716436,
          "renderedSegmentMarkerDurationSeconds" : 591.8765020370483,
          "renderedSegmentMarkerEndOffsetSeconds" : 2252.61339366436,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1660.7368916273117,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T12:12:49Z",
          "startOffsetSeconds" : 1660.7368916273117,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 390.93000519275665,
          "endDate" : "2026-06-03T12:20:01Z",
          "endOffsetSeconds" : 2093.048141002655,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 996.8050733037735,
          "renderedSegmentMarkerDurationSeconds" : 390.93000519275665,
          "renderedSegmentMarkerEndOffsetSeconds" : 2093.048141002655,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1702.1181358098984,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T12:13:30Z",
          "startOffsetSeconds" : 1702.1181358098984,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "2 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "04B1697E-8CB9-4A62-9547-19F4038E9525",
      "index" : 7,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : 138.45065212249756,
      "nearestRawEventEndOffsetSeconds" : 2093.048141002655,
      "nearestRawEventStartDeltaSeconds" : -102.64352011680603,
      "nearestRawEventStartOffsetSeconds" : 1702.1181358098984,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -2.9218162298202515,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1951.6756726503372,
      "nearestReconstructedIntervalIndex" : 7,
      "nearestReconstructedIntervalLabel" : "Recovery 3",
      "nearestSegmentMarkerEndDeltaSeconds" : 138.45065212249756,
      "nearestSegmentMarkerEndOffsetSeconds" : 2093.048141002655,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -102.64352011680603,
      "nearestSegmentMarkerStartOffsetSeconds" : 1702.1181358098984,
      "startDate" : "2026-06-03T12:15:13Z",
      "startOffsetSeconds" : 1804.7616559267044,
      "statistics" : [
        {
          "endDate" : "2026-06-03T12:17:43Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:15:13Z",
          "sum" : 12.230833447174268,
          "summary" : "ActiveEnergyBurned: sum 12.2 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-03T12:17:43Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:15:13Z",
          "sum" : 3.669288912085762,
          "summary" : "BasalEnergyBurned: sum 3.7 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-03T12:17:43Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:15:13Z",
          "sum" : 197.1376849863985,
          "summary" : "DistanceWalkingRunning: sum 197.1 m",
          "unit" : "m"
        },
        {
          "average" : 160.10327885454524,
          "endDate" : "2026-06-03T12:17:43Z",
          "maximum" : 185,
          "minimum" : 138,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:15:13Z",
          "summary" : "HeartRate: avg 160.1 bpm, min 138.0 bpm, max 185.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 204,
          "endDate" : "2026-06-03T12:17:43Z",
          "maximum" : 204,
          "minimum" : 204,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:15:13Z",
          "summary" : "RunningGroundContactTime: avg 204.0 ms, min 204.0 ms, max 204.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 90.31481481481478,
          "endDate" : "2026-06-03T12:17:43Z",
          "maximum" : 307,
          "minimum" : 61,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:15:13Z",
          "summary" : "RunningPower: avg 90.3 W, min 61.0 W, max 307.0 W",
          "unit" : "W"
        },
        {
          "average" : 1.4580694862492771,
          "endDate" : "2026-06-03T12:17:43Z",
          "maximum" : 4.404411159453091,
          "minimum" : 0.9822443635957179,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:15:13Z",
          "summary" : "RunningSpeed: avg 1.5 m\/s, min 1.0 m\/s, max 4.4 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 1.33,
          "endDate" : "2026-06-03T12:17:43Z",
          "maximum" : 1.33,
          "minimum" : 1.33,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:15:13Z",
          "summary" : "RunningStrideLength: avg 1.3 m, min 1.3 m, max 1.3 m",
          "unit" : "m"
        },
        {
          "average" : 8.2,
          "endDate" : "2026-06-03T12:17:43Z",
          "maximum" : 8.3,
          "minimum" : 8.1,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:15:13Z",
          "summary" : "RunningVerticalOscillation: avg 8.2 cm, min 8.1 cm, max 8.3 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-03T12:17:43Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:15:13Z",
          "sum" : 239.53064451879504,
          "summary" : "StepCount: sum 239.5 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 12.2 kcal; BasalEnergyBurned: sum 3.7 kcal; DistanceWalkingRunning: sum 197.1 m; HeartRate: avg 160.1 bpm, min 138.0 bpm, max 185.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 8,
      "alignedPlannedStepLabel" : "Cooldown",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "durationSeconds" : 382.12721705436707,
      "endDate" : "2026-06-03T12:24:05Z",
      "endOffsetSeconds" : 2336.7247059345245,
      "events" : [
        {
          "durationSeconds" : 591.8765020370483,
          "endDate" : "2026-06-03T12:22:41Z",
          "endOffsetSeconds" : 2252.61339366436,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1605.1676232716436,
          "renderedSegmentMarkerDurationSeconds" : 591.8765020370483,
          "renderedSegmentMarkerEndOffsetSeconds" : 2252.61339366436,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1660.7368916273117,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T12:12:49Z",
          "startOffsetSeconds" : 1660.7368916273117,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 390.93000519275665,
          "endDate" : "2026-06-03T12:20:01Z",
          "endOffsetSeconds" : 2093.048141002655,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 996.8050733037735,
          "renderedSegmentMarkerDurationSeconds" : 390.93000519275665,
          "renderedSegmentMarkerEndOffsetSeconds" : 2093.048141002655,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1702.1181358098984,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T12:13:30Z",
          "startOffsetSeconds" : 1702.1181358098984,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 241.16491448879242,
          "endDate" : "2026-06-03T12:24:02Z",
          "endOffsetSeconds" : 2334.2130554914474,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 660.1533391635658,
          "renderedSegmentMarkerDurationSeconds" : 241.16491448879242,
          "renderedSegmentMarkerEndOffsetSeconds" : 2334.2130554914474,
          "renderedSegmentMarkerKind" : "rawSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 2093.048141002655,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T12:20:01Z",
          "startOffsetSeconds" : 2093.048141002655,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 81.5996618270874,
          "endDate" : "2026-06-03T12:24:02Z",
          "endOffsetSeconds" : 2334.2130554914474,
          "index" : 4,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 223.77043441877777,
          "renderedSegmentMarkerDurationSeconds" : 81.5996618270874,
          "renderedSegmentMarkerEndOffsetSeconds" : 2334.2130554914474,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 2252.61339366436,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T12:22:41Z",
          "startOffsetSeconds" : 2252.61339366436,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 0,
          "endDate" : "2026-06-03T12:24:05Z",
          "endOffsetSeconds" : 2336.7247059345245,
          "excludedOrFilteredReason" : "zeroOrNegativeDuration",
          "index" : 5,
          "metadataKeys" : [

          ],
          "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
          "startDate" : "2026-06-03T12:24:05Z",
          "startOffsetSeconds" : 2336.7247059345245,
          "type" : "HKWorkoutEventType(rawValue: 1)",
          "usedBySegmentMarkerRendering" : false
        }
      ],
      "eventsSummary" : "5 event(s): HKWorkoutEventType(rawValue: 1), HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "1B3CE26D-61FE-447E-BE52-38D56B7A701D",
      "index" : 8,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath"
      ],
      "nearestRawEventEndDeltaSeconds" : -2.5116504430770874,
      "nearestRawEventEndOffsetSeconds" : 2334.2130554914474,
      "nearestRawEventStartDeltaSeconds" : 138.45065212249756,
      "nearestRawEventStartOffsetSeconds" : 2093.048141002655,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : 0,
      "nearestReconstructedIntervalEndOffsetSeconds" : 2336.7247059345245,
      "nearestReconstructedIntervalIndex" : 8,
      "nearestReconstructedIntervalLabel" : "Cooldown",
      "nearestSegmentMarkerEndDeltaSeconds" : -2.5116504430770874,
      "nearestSegmentMarkerEndOffsetSeconds" : 2334.2130554914474,
      "nearestSegmentMarkerKind" : "rawSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : 138.45065212249756,
      "nearestSegmentMarkerStartOffsetSeconds" : 2093.048141002655,
      "startDate" : "2026-06-03T12:17:43Z",
      "startOffsetSeconds" : 1954.5974888801575,
      "statistics" : [
        {
          "endDate" : "2026-06-03T12:24:05Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:17:43Z",
          "sum" : 72.72206867355388,
          "summary" : "ActiveEnergyBurned: sum 72.7 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-03T12:24:05Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:17:43Z",
          "sum" : 9.296138395813626,
          "summary" : "BasalEnergyBurned: sum 9.3 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-03T12:24:05Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:17:43Z",
          "sum" : 1031.2081285578995,
          "summary" : "DistanceWalkingRunning: sum 1031.2 m",
          "unit" : "m"
        },
        {
          "average" : 155.2755611305677,
          "endDate" : "2026-06-03T12:24:05Z",
          "maximum" : 166,
          "minimum" : 133,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:17:43Z",
          "summary" : "HeartRate: avg 155.3 bpm, min 133.0 bpm, max 166.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 250.90769230769232,
          "endDate" : "2026-06-03T12:24:05Z",
          "maximum" : 276,
          "minimum" : 234,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:17:43Z",
          "summary" : "RunningGroundContactTime: avg 250.9 ms, min 234.0 ms, max 276.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 195.081081081081,
          "endDate" : "2026-06-03T12:24:05Z",
          "maximum" : 212,
          "minimum" : 76,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:17:43Z",
          "summary" : "RunningPower: avg 195.1 W, min 76.0 W, max 212.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.7573646461626784,
          "endDate" : "2026-06-03T12:24:05Z",
          "maximum" : 2.973999549463391,
          "minimum" : 1.2797662538784167,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:17:43Z",
          "summary" : "RunningSpeed: avg 2.8 m\/s, min 1.3 m\/s, max 3.0 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9172307692307693,
          "endDate" : "2026-06-03T12:24:05Z",
          "maximum" : 0.96,
          "minimum" : 0.86,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:17:43Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 1.0 m",
          "unit" : "m"
        },
        {
          "average" : 7.8353846153846165,
          "endDate" : "2026-06-03T12:24:05Z",
          "maximum" : 8.3,
          "minimum" : 7.6,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:17:43Z",
          "summary" : "RunningVerticalOscillation: avg 7.8 cm, min 7.6 cm, max 8.3 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-03T12:24:05Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:17:43Z",
          "sum" : 1135.6732569435062,
          "summary" : "StepCount: sum 1135.7 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 72.7 kcal; BasalEnergyBurned: sum 9.3 kcal; DistanceWalkingRunning: sum 1031.2 m; HeartRate: avg 155.3 bpm, min 133.0 bpm, max 166.0 bpm"
    }
  ],
  "workoutKitPlanAudit" : {
    "displayName" : "Wednesday Interval (7.5km)",
    "planID" : "77EBFFFA-254C-4E57-B567-DF975A19415A",
    "planType" : "Custom workout",
    "plannedSteps" : [
      {
        "index" : 1,
        "label" : "Warmup",
        "plannedGoalDisplayText" : "2 km",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 2000,
        "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
        "stepType" : "warmup"
      },
      {
        "index" : 2,
        "label" : "Work 1",
        "plannedGoalDisplayText" : "1 km",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 1000,
        "plannedTargetDisplayText" : "pace 4:00 \/km, speed 4.17 m\/s, metric current",
        "repeatBlockIndex" : 1,
        "repeatIndex" : 1,
        "stepType" : "work"
      },
      {
        "index" : 3,
        "label" : "Recovery 1",
        "plannedGoalDisplayText" : "150 s",
        "plannedGoalType" : "time",
        "plannedGoalValue" : 150,
        "repeatBlockIndex" : 1,
        "repeatIndex" : 1,
        "stepType" : "recovery"
      },
      {
        "index" : 4,
        "label" : "Work 2",
        "plannedGoalDisplayText" : "1 km",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 1000,
        "plannedTargetDisplayText" : "pace 4:00 \/km, speed 4.17 m\/s, metric current",
        "repeatBlockIndex" : 1,
        "repeatIndex" : 2,
        "stepType" : "work"
      },
      {
        "index" : 5,
        "label" : "Recovery 2",
        "plannedGoalDisplayText" : "150 s",
        "plannedGoalType" : "time",
        "plannedGoalValue" : 150,
        "repeatBlockIndex" : 1,
        "repeatIndex" : 2,
        "stepType" : "recovery"
      },
      {
        "index" : 6,
        "label" : "Work 3",
        "plannedGoalDisplayText" : "1 km",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 1000,
        "plannedTargetDisplayText" : "pace 4:00 \/km, speed 4.17 m\/s, metric current",
        "repeatBlockIndex" : 1,
        "repeatIndex" : 3,
        "stepType" : "work"
      },
      {
        "index" : 7,
        "label" : "Recovery 3",
        "plannedGoalDisplayText" : "150 s",
        "plannedGoalType" : "time",
        "plannedGoalValue" : 150,
        "repeatBlockIndex" : 1,
        "repeatIndex" : 3,
        "stepType" : "recovery"
      },
      {
        "index" : 8,
        "label" : "Cooldown",
        "plannedGoalDisplayText" : "Open",
        "plannedGoalType" : "open",
        "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
        "stepType" : "cooldown"
      }
    ],
    "status" : "available",
    "summaryLines" : [
      "Activity: HKWorkoutActivityType(rawValue: 37)",
      "Warmup: goal 2 km, alert pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "Block 1: 3x, 2 step(s)",
      "Block 1 step 1: Work - goal 1 km, alert pace 4:00 \/km, speed 4.17 m\/s, metric current",
      "Block 1 step 2: Recovery - goal 150 s, alert none",
      "Cooldown: goal open, alert pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current"
    ]
  }
}
```