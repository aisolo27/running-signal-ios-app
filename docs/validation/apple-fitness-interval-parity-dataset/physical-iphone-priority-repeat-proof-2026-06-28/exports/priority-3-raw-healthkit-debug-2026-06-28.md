# RunSignal Raw HealthKit Debug Export

Generated: 2026-06-28T19:37:38Z

## Review Packet Scope

This packet bundles Raw HealthKit Debug, WorkoutKit plan audit, HealthKit activity rows, Parity Lab candidate rows, structured comparison, fallback labels, pause/tail diagnostics, source metadata, and boundary warnings. It is debug/export-only and does not approve normal workout detail behavior.

Whole-run stats remain usable when custom interval rows are blocked. External HealthFit/FIT archives stay offline validation evidence; attach or reference them separately and do not treat FIT as app input or runtime truth.

Blocked custom interval diagnostics are review aids only. A supported Parity Lab status, readable fallback label, or exported candidate row does not change normal workout detail unless the exact ledger row separately reaches the normal-detail promotion rung.

## Workout

| Field | Value |
|---|---|
| Workout ID | 8B07CF82-0778-4A83-B862-486275CCA923 |
| Source | Adriel’s Apple Watch |
| Source ID | 8B07CF82-0778-4A83-B862-486275CCA923 |
| Device | Apple Watch Apple Inc. Watch |
| Start | Jun 28, 2026 |
| End | Jun 28, 2026 |
| Duration | 35:19 |
| Elapsed | 35:19 |
| Distance | 4.95 km |
| Avg pace | 7:08 /km |
| Avg HR | 147 bpm |
| Max HR | 160 bpm |
| Cadence | 163 spm |
| Power | 169 W |

## Evidence Counts

| Metric | Count |
|---|---:|
| Heart rate | 419 |
| Speed | 808 |
| Distance | 810 |
| Active energy | 823 |
| Power | 807 |
| Cadence | 811 |
| Step count | 811 |
| Stride length | 316 |
| Vertical oscillation | 320 |
| Ground contact | 316 |
| Route points | 2116 |
| Events | 10 |
| Workout activities | 10 |

## WorkoutKit Plan Audit

- Status: Available
- Plan type: Custom workout
- Plan ID: 106CC9CA-B6CB-424C-95A3-384E5861C7F5
- Display name: Priority 3 (no pause, open cooldown)
- Activity: HKWorkoutActivityType(rawValue: 37)
- Warmup: goal 2 km, alert pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current
- Block 1: 4x, 2 step(s)
- Block 1 step 1: Work - goal 400 m, alert pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current
- Block 1 step 2: Recovery - goal 200 m, alert pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current
- Cooldown: goal open, alert pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current

## Raw HKWorkoutEvent Inventory

Debug-only inventory of public `HKWorkoutEvent` date windows and metadata keys. These rows are not Apple Fitness interval truth.

| Row | Event Type | Label | Start Offset | End Offset | Duration | Metadata Keys | Rendered Marker Window | Marker Distance | Marker Kind | Used By Segment Rendering | Excluded / Filtered Reason | Debug-Only Reason |
|---:|---|---|---:|---:|---:|---|---:|---:|---|---|---|---|
| 1 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 6:34 | 394.1 s | Unavailable | 0:00-6:34 | 1.01 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 2 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 10:29 | 628.7 s | Unavailable | 0:00-10:29 | 1.62 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 3 | HKWorkoutEventType(rawValue: 7) | Unavailable | 6:34 | 12:59 | 384.4 s | Unavailable | 6:34-12:59 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 4 | HKWorkoutEventType(rawValue: 7) | Unavailable | 10:29 | 20:48 | 619.3 s | Unavailable | 10:29-20:48 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 5 | HKWorkoutEventType(rawValue: 7) | Unavailable | 12:59 | 19:25 | 386.7 s | Unavailable | 12:59-19:25 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 6 | HKWorkoutEventType(rawValue: 7) | Unavailable | 19:25 | 25:49 | 383.3 s | Unavailable | 19:25-25:49 | 1.00 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 7 | HKWorkoutEventType(rawValue: 7) | Unavailable | 20:48 | 33:14 | 746.4 s | Unavailable | 20:48-33:14 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 8 | HKWorkoutEventType(rawValue: 7) | Unavailable | 25:49 | 35:19 | 570.7 s | Unavailable | 25:49-35:19 | 0.95 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 9 | HKWorkoutEventType(rawValue: 7) | Unavailable | 33:14 | 35:19 | 124.8 s | Unavailable | 33:14-35:19 | 0.12 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 10 | HKWorkoutEventType(rawValue: 1) | Unavailable | 35:19 | 35:19 | 0.0 s | Unavailable | Unavailable | Unavailable | Unavailable | No | Excluded from segment rendering: zero or negative duration. | No rendered segment marker candidate. |

## HKWorkoutActivity Inventory

Debug-only inventory of public `HKWorkout.workoutActivities` rows. These rows are not used for production interval reconstruction.

| Activity | Type | Start Date | End Date | Start Offset | End Offset | Duration | Metadata Keys | Nested Events | Statistics | Aligns Planned Step | Aligned Planned Step | Nearest Reconstructed Row | Row End Delta | Apple Fitness/manual | FIT Lap | Raw Event Start | Raw Start Delta | Raw Event End | Raw End Delta | Segment Start | Segment Start Delta | Segment End | Segment End Delta | Previous Sample End | Crossing Sample End | Next Sample End |
|---:|---|---|---|---:|---:|---:|---|---|---|---|---|---|---:|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T13:27:33Z | 2026-06-28T13:40:34Z | 0.0 s | 781.4 s | 781.4 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 5 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 146.3 kcal; BasalEnergyBurned: sum 19.1 kcal; DistanceWalkingRunning: sum 2006.6 m; HeartRate: avg 147.9 bpm, min 117.0 bpm, max 156.0 bpm | No | Unavailable | Warmup | -4.6 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 0.0 s | 0.0 s | 778.5 s | -2.9 s | 0.0 s | 0.0 s | 778.5 s | -2.9 s | 774.2 s | 776.8 s | 779.3 s |
| 2 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T13:40:34Z | 2026-06-28T13:43:11Z | 781.4 s | 938.0 s | 156.6 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 2 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 30.5 kcal; BasalEnergyBurned: sum 3.8 kcal; DistanceWalkingRunning: sum 401.0 m; HeartRate: avg 152.3 bpm, min 148.0 bpm, max 155.0 bpm | No | Unavailable | Work 1 | -4.3 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 778.5 s | -2.9 s | 778.5 s | -159.5 s | 778.5 s | -2.9 s | 778.5 s | -159.5 s | 931.1 s | 933.7 s | 936.3 s |
| 3 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T13:43:11Z | 2026-06-28T13:44:29Z | 938.0 s | 1016.4 s | 78.4 s | WOIntervalStepKeyPath, WOIntervalStepSuccessful | 2 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 15.1 kcal; BasalEnergyBurned: sum 1.9 kcal; DistanceWalkingRunning: sum 200.2 m; HeartRate: avg 150.7 bpm, min 149.0 bpm, max 154.0 bpm | No | Unavailable | Recovery 1 | -4.3 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 778.5 s | -159.5 s | 1165.2 s | 148.8 s | 778.5 s | -159.5 s | 1165.2 s | 148.8 s | 1010.9 s | 1013.5 s | 1016.0 s |
| 4 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T13:44:29Z | 2026-06-28T13:47:01Z | 1016.4 s | 1168.2 s | 151.8 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 3 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 29.5 kcal; BasalEnergyBurned: sum 3.7 kcal; DistanceWalkingRunning: sum 401.2 m; HeartRate: avg 152.2 bpm, min 148.0 bpm, max 155.0 bpm | No | Unavailable | Work 2 | -4.5 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1165.2 s | 148.8 s | 1165.2 s | -3.0 s | 1165.2 s | 148.8 s | 1165.2 s | -3.0 s | 1162.7 s | 1165.2 s | 1167.8 s |
| 5 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T13:47:01Z | 2026-06-28T13:48:14Z | 1168.2 s | 1241.3 s | 73.2 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 2 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 14.4 kcal; BasalEnergyBurned: sum 1.8 kcal; DistanceWalkingRunning: sum 192.6 m; HeartRate: avg 153.4 bpm, min 152.0 bpm, max 156.0 bpm | Yes | Recovery 2 | Recovery 2 | -1.5 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1165.2 s | -3.0 s | 1248.0 s | 6.7 s | 1165.2 s | -3.0 s | 1248.0 s | 6.7 s | 1237.3 s | 1239.9 s | 1242.4 s |
| 6 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T13:48:14Z | 2026-06-28T13:50:55Z | 1241.3 s | 1401.5 s | 160.1 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 3 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 31.3 kcal; BasalEnergyBurned: sum 3.9 kcal; DistanceWalkingRunning: sum 406.7 m; HeartRate: avg 153.2 bpm, min 146.0 bpm, max 156.0 bpm | No | Unavailable | Work 3 | -4.2 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1248.0 s | 6.7 s | 1548.5 s | 147.0 s | 1248.0 s | 6.7 s | 1548.5 s | 147.0 s | 1396.8 s | 1399.4 s | 1401.9 s |
| 7 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T13:50:55Z | 2026-06-28T13:52:10Z | 1401.5 s | 1476.7 s | 75.2 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 2 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 14.9 kcal; BasalEnergyBurned: sum 1.8 kcal; DistanceWalkingRunning: sum 199.5 m; HeartRate: avg 154.5 bpm, min 152.0 bpm, max 157.0 bpm | No | Unavailable | Recovery 3 | -3.7 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1548.5 s | 147.0 s | 1548.5 s | 71.8 s | 1548.5 s | 147.0 s | 1548.5 s | 71.8 s | 1471.4 s | 1474.0 s | 1476.5 s |
| 8 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T13:52:10Z | 2026-06-28T13:54:41Z | 1476.7 s | 1628.3 s | 151.6 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 3 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 30.7 kcal; BasalEnergyBurned: sum 3.7 kcal; DistanceWalkingRunning: sum 399.5 m; HeartRate: avg 156.5 bpm, min 154.0 bpm, max 159.0 bpm | Yes | Work 4 | Work 4 | -2.5 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1548.5 s | 71.8 s | 1548.5 s | -79.8 s | 1548.5 s | 71.8 s | 1548.5 s | -79.8 s | 1623.2 s | 1625.8 s | 1628.3 s |
| 9 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T13:54:41Z | 2026-06-28T13:55:56Z | 1628.3 s | 1702.7 s | 74.5 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 2 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 14.9 kcal; BasalEnergyBurned: sum 1.8 kcal; DistanceWalkingRunning: sum 200.9 m; HeartRate: avg 155.9 bpm, min 151.0 bpm, max 158.0 bpm | Yes | Recovery 4 | Recovery 4 | -2.3 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1548.5 s | -79.8 s | 1548.5 s | -154.2 s | 1548.5 s | -79.8 s | 1548.5 s | -154.2 s | 1697.8 s | 1700.4 s | 1702.9 s |
| 10 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T13:55:56Z | 2026-06-28T14:02:52Z | 1702.7 s | 2119.2 s | 416.4 s | HKElevationAscended, WOIntervalStepKeyPath | 4 event(s): HKWorkoutEventType(rawValue: 1), HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 33.8 kcal; BasalEnergyBurned: sum 10.1 kcal; DistanceWalkingRunning: sum 544.6 m; HeartRate: avg 134.4 bpm, min 104.0 bpm, max 160.0 bpm | Yes | Cooldown | Cooldown | 0.0 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1548.5 s | -154.2 s | 2119.2 s | 0.0 s | 1548.5 s | -154.2 s | 2119.2 s | 0.0 s | Unavailable | Unavailable | Unavailable |

## WorkoutKit Reconstructed Intervals

Planned structure source: WorkoutKit when available. Measured stats source: HealthKit samples.

| Row | Label | Goal | Target | Distance | Elapsed | Pause overlap | Active time | Display time | Duration rule | Pace | Avg HR | Max HR | Power | Start Offset | End Offset | Boundary Strategy | Boundary Adjustment | Overshoot | Confidence | Notes |
|---:|---|---|---|---:|---:|---:|---:|---:|---|---:|---:|---:|---:|---:|---:|---|---:|---:|---|---|
| 1 | Warmup | 2 km | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 2.00 km | 12:57 |  | Unavailable | 12:57 | elapsedRowWindow | 6:28 /km | 148 bpm | 156 bpm | 184 W | 0:00 | 12:57 | crossing sample end | 0.8 s | 2.2 m | High | Distance-goal boundary: crossing sample end, adjustment +0.8s, overshoot 2.2 m |
| 2 | Work 1 | 400 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.40 km | 2:37 |  | Unavailable | 2:37 | elapsedRowWindow | 6:32 /km | 152 bpm | 155 bpm | 185 W | 12:57 | 15:34 | crossing sample end | 0.4 s | 0.8 m | High | Distance-goal boundary: crossing sample end, adjustment +0.4s, overshoot 0.8 m |
| 3 | Recovery 1 | 200 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.20 km | 1:18 |  | Unavailable | 1:18 | elapsedRowWindow | 6:32 /km | 151 bpm | 154 bpm | 186 W | 15:34 | 16:52 | interpolated crossing | 0.0 s | 3.8 m | High | Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 3.8 m |
| 4 | Work 2 | 400 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.40 km | 2:32 |  | Unavailable | 2:32 | elapsedRowWindow | 6:19 /km | 152 bpm | 155 bpm | 187 W | 16:52 | 19:24 | interpolated crossing | 0.0 s | 4.9 m | High | Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 4.9 m |
| 5 | Recovery 2 | 200 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.20 km | 1:16 |  | Unavailable | 1:16 | elapsedRowWindow | 6:19 /km | 153 bpm | 156 bpm | 188 W | 19:24 | 20:40 | crossing sample end | 0.4 s | 1.1 m | High | Distance-goal boundary: crossing sample end, adjustment +0.4s, overshoot 1.1 m |
| 6 | Work 3 | 400 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.40 km | 2:37 |  | Unavailable | 2:37 | elapsedRowWindow | 6:34 /km | 153 bpm | 156 bpm | 185 W | 20:40 | 23:17 | interpolated crossing | 0.0 s | 5.1 m | High | Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 5.1 m |
| 7 | Recovery 3 | 200 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.20 km | 1:16 |  | Unavailable | 1:16 | elapsedRowWindow | 6:18 /km | 154 bpm | 157 bpm | 188 W | 23:17 | 24:33 | interpolated crossing | 0.0 s | 3.1 m | High | Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 3.1 m |
| 8 | Work 4 | 400 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.40 km | 2:33 |  | Unavailable | 2:33 | elapsedRowWindow | 6:19 /km | 157 bpm | 159 bpm | 196 W | 24:33 | 27:06 | crossing sample end | 1.3 s | 3.2 m | High | Distance-goal boundary: crossing sample end, adjustment +1.3s, overshoot 3.2 m |
| 9 | Recovery 4 | 200 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.20 km | 1:15 |  | Unavailable | 1:15 | elapsedRowWindow | 6:11 /km | 156 bpm | 158 bpm | 191 W | 27:06 | 28:20 | crossing sample end | 0.5 s | 1.3 m | High | Distance-goal boundary: crossing sample end, adjustment +0.5s, overshoot 1.3 m |
| 10 | Cooldown | Open | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.54 km | 6:59 |  | Unavailable | 6:59 | elapsedRowWindow | 12:49 /km | 134 bpm | 160 bpm | 91 W | 28:20 | 35:19 |  |  |  | Medium | Planned open cooldown extended to workout end |

Notes: Plan source: WorkoutKit · Window source: Plan-derived from HealthKit distance/time samples · Stats source: HealthKit samples · HealthKit segment markers: not used

## HKWorkoutActivity Boundary Candidate Intervals

Debug-only alternate reconstruction for Parity Lab exports. These rows are not production interval logic and are not shown in the normal workout UI.

| Field | Value |
|---|---|
| Mapping status | mappedByPlannedStepOrder |
| Activity count | 10 |
| Planned step count | 10 |
| Scoreable | Yes |
| Not scoreable reason | n/a |
| Production UI warning | HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI. |

| Row | Label | Goal | Mapping | Activity | Start Offset | End Offset | Distance | Time | Candidate Confidence | Reason If Not Scoreable | Caveats |
|---:|---|---|---|---:|---:|---:|---:|---:|---|---|---|
| 1 | Warmup | 2 km | mappedByPlannedStepOrder | 1 | 0.0 s | 781.4 s | 2006.6 m | 781.4 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 2 | Work 1 | 400 m | mappedByPlannedStepOrder | 2 | 781.4 s | 938.0 s | 401.0 m | 156.6 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 3 | Recovery 1 | 200 m | mappedByPlannedStepOrder | 3 | 938.0 s | 1016.4 s | 200.2 m | 78.4 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 4 | Work 2 | 400 m | mappedByPlannedStepOrder | 4 | 1016.4 s | 1168.2 s | 401.2 m | 151.8 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 5 | Recovery 2 | 200 m | mappedByPlannedStepOrder | 5 | 1168.2 s | 1241.3 s | 192.6 m | 73.2 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 6 | Work 3 | 400 m | mappedByPlannedStepOrder | 6 | 1241.3 s | 1401.5 s | 406.7 m | 160.1 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 7 | Recovery 3 | 200 m | mappedByPlannedStepOrder | 7 | 1401.5 s | 1476.7 s | 199.5 m | 75.2 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 8 | Work 4 | 400 m | mappedByPlannedStepOrder | 8 | 1476.7 s | 1628.3 s | 399.5 m | 151.6 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 9 | Recovery 4 | 200 m | mappedByPlannedStepOrder | 9 | 1628.3 s | 1702.7 s | 200.9 m | 74.5 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 10 | Cooldown | Open | mappedByPlannedStepOrder | 10 | 1702.7 s | 2119.2 s | 544.6 m | 416.4 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |

Caveats: debug-only, not promoted · not production interval logic · not shown in normal workout UI · FIT and Apple Fitness/manual rows are not runtime inputs · Activities are generic HealthKit activity windows and labels are mapped from WorkoutKit planned step order. · Missing or ambiguous activity rows must not replace current reconstruction.

## Custom Workout Candidate Rule Scorer

Debug-only Parity Lab scorer for active-time duration, pause overlap, and Open / Extra tail rows. These rows are not production interval logic, are not shown in the normal workout UI, and do not approve a normal-detail gate.

| Field | Value |
|---|---|
| Strategy | custom_workout_candidate_rule_active_time |
| Rule status | candidate-rule-scoreable |
| Candidate row count | 10 |
| Planned expanded row count | 10 |
| Open tail row count | 0 |
| Paired pause count | 0 |
| Total paired pause | 0.0 s |
| Fixed row exhaustion | fixed-rows-mapped-no-tail |
| Tail status | open-extra-tail-absent |
| Tail duration | Unavailable |
| Tail distance | Unavailable |
| Fallback reasons |  |
| Safety flags | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. |
| FIT validation | offline-evidence-only-not-runtime-truth |
| Scoreable | Yes |
| Not scoreable reason | n/a |
| Production UI warning | Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI. |

| Row | Label | Mapping | Start offset | End offset | Elapsed | Pause overlap | Active time | Distance | Display rule | Duration rule | Confidence | Caveats |
|---:|---|---|---:|---:|---:|---:|---:|---:|---|---|---|---|
| 1 | Warmup | mappedByPlannedStepOrder | 0.0 s | 781.4 s | 781.4 s | 0.0 s | 781.4 s | 2006.6 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 2 | Work 1 | mappedByPlannedStepOrder | 781.4 s | 938.0 s | 156.6 s | 0.0 s | 156.6 s | 401.0 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 3 | Recovery 1 | mappedByPlannedStepOrder | 938.0 s | 1016.4 s | 78.4 s | 0.0 s | 78.4 s | 200.2 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 4 | Work 2 | mappedByPlannedStepOrder | 1016.4 s | 1168.2 s | 151.8 s | 0.0 s | 151.8 s | 401.2 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 5 | Recovery 2 | mappedByPlannedStepOrder | 1168.2 s | 1241.3 s | 73.2 s | 0.0 s | 73.2 s | 192.6 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 6 | Work 3 | mappedByPlannedStepOrder | 1241.3 s | 1401.5 s | 160.1 s | 0.0 s | 160.1 s | 406.7 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 7 | Recovery 3 | mappedByPlannedStepOrder | 1401.5 s | 1476.7 s | 75.2 s | 0.0 s | 75.2 s | 199.5 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 8 | Work 4 | mappedByPlannedStepOrder | 1476.7 s | 1628.3 s | 151.6 s | 0.0 s | 151.6 s | 399.5 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 9 | Recovery 4 | mappedByPlannedStepOrder | 1628.3 s | 1702.7 s | 74.5 s | 0.0 s | 74.5 s | 200.9 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 10 | Cooldown | mappedByPlannedStepOrder | 1702.7 s | 2119.2 s | 416.4 s | 0.0 s | 416.4 s | 544.6 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |

Caveats: debug-only, not promoted · not production interval logic · not shown in normal workout UI · FIT and Apple Fitness/manual rows are not runtime inputs · Active duration subtracts paired HealthKit pause/resume overlap when available.

## Custom Workout Structured Comparison

Debug-only structured status and fallback taxonomy for Parity Lab rows. This status is not production interval logic, is not shown in the normal workout UI, and does not approve a normal-detail gate by itself.

| Field | Value |
|---|---|
| Status | repeat-block-needs-rule |
| Status label | Repeat-block rows need an approved rule. |
| Fallback reasons | None |
| Primary fallback | None |
| Row count | 10 |
| Row confidences | needsRule, needsRule, needsRule, needsRule, needsRule, needsRule, needsRule, needsRule, needsRule, needsRule |
| Tail ambiguity | plannedOpenCooldownContinuesToWorkoutEnd |
| Promotes production behavior | No |
| Scope | debug/export-only |
| Normal workout UI changed | No |
| Uses FIT runtime truth | No |

## WorkoutKit Boundary Diagnostics

### Row 1: Warmup

| Field | Value |
|---|---:|
| Target distance | 2000.0 m |
| Start offset | 0:00 |
| End offset | 12:57 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 0.8 s |
| Overshoot | 2.2 m |
| Cumulative distance at start | 0.0 m |
| Cumulative distance at end | 2002.2 m |
| Interpolation fraction | 0.676 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 12:52 | 12:54 | 1988.1 m | 1995.4 m |
| Crossing | 12:54 | 12:57 | 1995.4 m | 2002.2 m |
| Next | 12:57 | 12:59 | 2002.2 m | 2007.7 m |

### Row 2: Work 1

| Field | Value |
|---|---:|
| Target distance | 400.0 m |
| Start offset | 12:57 |
| End offset | 15:34 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 0.4 s |
| Overshoot | 0.8 m |
| Cumulative distance at start | 2002.2 m |
| Cumulative distance at end | 2403.1 m |
| Interpolation fraction | 0.857 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 15:29 | 15:31 | 2390.3 m | 2397.2 m |
| Crossing | 15:31 | 15:34 | 2397.2 m | 2403.1 m |
| Next | 15:34 | 15:36 | 2403.1 m | 2409.8 m |

### Row 3: Recovery 1

| Field | Value |
|---|---:|
| Target distance | 200.0 m |
| Start offset | 15:34 |
| End offset | 16:52 |
| Boundary strategy | interpolated crossing |
| Boundary adjustment | 0.0 s |
| Overshoot | 3.8 m |
| Cumulative distance at start | 2403.1 m |
| Cumulative distance at end | 2606.8 m |
| Interpolation fraction | 0.456 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 16:48 | 16:51 | 2593.4 m | 2599.9 m |
| Crossing | 16:51 | 16:53 | 2599.9 m | 2606.8 m |
| Next | 16:53 | 16:56 | 2606.8 m | 2613.9 m |

### Row 4: Work 2

| Field | Value |
|---|---:|
| Target distance | 400.0 m |
| Start offset | 16:52 |
| End offset | 19:24 |
| Boundary strategy | interpolated crossing |
| Boundary adjustment | 0.0 s |
| Overshoot | 4.9 m |
| Cumulative distance at start | 2603.1 m |
| Cumulative distance at end | 3007.9 m |
| Interpolation fraction | 0.373 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 19:20 | 19:23 | 2994.4 m | 3000.1 m |
| Crossing | 19:23 | 19:25 | 3000.1 m | 3007.9 m |
| Next | 19:25 | 19:28 | 3007.9 m | 3015.1 m |

### Row 5: Recovery 2

| Field | Value |
|---|---:|
| Target distance | 200.0 m |
| Start offset | 19:24 |
| End offset | 20:40 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 0.4 s |
| Overshoot | 1.1 m |
| Cumulative distance at start | 3003.1 m |
| Cumulative distance at end | 3204.1 m |
| Interpolation fraction | 0.835 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 20:35 | 20:37 | 3190.9 m | 3197.7 m |
| Crossing | 20:37 | 20:40 | 3197.7 m | 3204.1 m |
| Next | 20:40 | 20:42 | 3204.1 m | 3209.0 m |

### Row 6: Work 3

| Field | Value |
|---|---:|
| Target distance | 400.0 m |
| Start offset | 20:40 |
| End offset | 23:17 |
| Boundary strategy | interpolated crossing |
| Boundary adjustment | 0.0 s |
| Overshoot | 5.1 m |
| Cumulative distance at start | 3204.1 m |
| Cumulative distance at end | 3609.2 m |
| Interpolation fraction | 0.211 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 23:14 | 23:17 | 3595.6 m | 3602.7 m |
| Crossing | 23:17 | 23:19 | 3602.7 m | 3609.2 m |
| Next | 23:19 | 23:22 | 3609.2 m | 3615.9 m |

### Row 7: Recovery 3

| Field | Value |
|---|---:|
| Target distance | 200.0 m |
| Start offset | 23:17 |
| End offset | 24:33 |
| Boundary strategy | interpolated crossing |
| Boundary adjustment | 0.0 s |
| Overshoot | 3.1 m |
| Cumulative distance at start | 3604.1 m |
| Cumulative distance at end | 3807.2 m |
| Interpolation fraction | 0.593 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 24:29 | 24:31 | 3793.2 m | 3799.6 m |
| Crossing | 24:31 | 24:34 | 3799.6 m | 3807.2 m |
| Next | 24:34 | 24:37 | 3807.2 m | 3814.9 m |

### Row 8: Work 4

| Field | Value |
|---|---:|
| Target distance | 400.0 m |
| Start offset | 24:33 |
| End offset | 27:06 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 1.3 s |
| Overshoot | 3.2 m |
| Cumulative distance at start | 3804.1 m |
| Cumulative distance at end | 4207.3 m |
| Interpolation fraction | 0.481 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 27:01 | 27:03 | 4195.9 m | 4201.2 m |
| Crossing | 27:03 | 27:06 | 4201.2 m | 4207.3 m |
| Next | 27:06 | 27:08 | 4207.3 m | 4213.8 m |

### Row 9: Recovery 4

| Field | Value |
|---|---:|
| Target distance | 200.0 m |
| Start offset | 27:06 |
| End offset | 28:20 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 0.5 s |
| Overshoot | 1.3 m |
| Cumulative distance at start | 4207.3 m |
| Cumulative distance at end | 4408.6 m |
| Interpolation fraction | 0.798 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 28:15 | 28:18 | 4395.1 m | 4402.1 m |
| Crossing | 28:18 | 28:20 | 4402.1 m | 4408.6 m |
| Next | 28:20 | 28:23 | 4408.6 m | 4417.0 m |

## HealthKit Segment Markers

Raw debug only. HealthKit Segment Markers must not be promoted as Apple Fitness interval rows.

| Row | Label | Marker Kind | Source | Distance | Time | Pace | Avg HR | Start Offset | End Offset | Confidence | Caveats |
|---:|---|---|---|---:|---:|---:|---:|---:|---:|---|---|
| 1 | Unknown | Split marker | HealthKit segment pattern | 1.01 km | 6:34 | 6:31 /km | 145 bpm | 0:00 | 6:34 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 2 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.62 km | 10:29 | 6:29 /km | 147 bpm | 0:00 | 10:29 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 3 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:24 | 6:25 /km | 152 bpm | 6:34 | 12:59 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 4 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 10:19 | 6:25 /km | 153 bpm | 10:29 | 20:48 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 5 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:27 | 6:26 /km | 152 bpm | 12:59 | 19:25 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 6 | Unknown | Split marker | HealthKit segment pattern | 1.00 km | 6:23 | 6:24 /km | 154 bpm | 19:25 | 25:49 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 7 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 12:26 | 7:45 /km | 148 bpm | 20:48 | 33:14 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 8 | Unknown | Overlapping segment marker | HealthKit segment pattern | 0.95 km | 9:31 | 10:03 /km | 140 bpm | 25:49 | 35:19 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 9 | Unknown | Overlapping segment marker | HealthKit segment pattern | 0.12 km | 2:05 | 17:09 /km | 124 bpm | 33:14 | 35:19 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |

## Planned Step Boundary Comparison

Debug-only comparison helper for FIT/Apple boundary investigation. The FIT lap end offset is intentionally a manual placeholder; RunSignal does not read FIT at runtime.

| Row | Planned Step | Goal | RunSignal End | FIT Lap End | Nearest Raw Event End | Event Delta | Nearest Activity End | Activity Delta | Activity Type | Nearest Segment End | Segment Delta | Previous Sample End | Crossing Sample End | Next Sample End | Warning |
|---:|---|---|---:|---:|---:|---:|---:|---:|---|---:|---:|---:|---:|---:|---|
| 1 | Warmup | 2 km | 776.8 s | Manual FIT placeholder | 778.5 s | 1.7 s | 781.4 s | 4.6 s | HKWorkoutActivityType(rawValue: 37) | 778.5 s | 1.7 s | 774.2 s | 776.8 s | 779.3 s |  |
| 2 | Work 1 | 400 m | 933.7 s | Manual FIT placeholder | 778.5 s | -155.2 s | 938.0 s | 4.3 s | HKWorkoutActivityType(rawValue: 37) | 778.5 s | -155.2 s | 931.1 s | 933.7 s | 936.3 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 3 | Recovery 1 | 200 m | 1012.1 s | Manual FIT placeholder | 1165.2 s | 153.1 s | 1016.4 s | 4.3 s | HKWorkoutActivityType(rawValue: 37) | 1165.2 s | 153.1 s | 1010.9 s | 1013.5 s | 1016.0 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 4 | Work 2 | 400 m | 1163.6 s | Manual FIT placeholder | 1165.2 s | 1.5 s | 1168.2 s | 4.5 s | HKWorkoutActivityType(rawValue: 37) | 1165.2 s | 1.5 s | 1162.7 s | 1165.2 s | 1167.8 s |  |
| 5 | Recovery 2 | 200 m | 1239.9 s | Manual FIT placeholder | 1248.0 s | 8.2 s | 1241.3 s | 1.5 s | HKWorkoutActivityType(rawValue: 37) | 1248.0 s | 8.2 s | 1237.3 s | 1239.9 s | 1242.4 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 6 | Work 3 | 400 m | 1397.3 s | Manual FIT placeholder | 1248.0 s | -149.3 s | 1401.5 s | 4.2 s | HKWorkoutActivityType(rawValue: 37) | 1248.0 s | -149.3 s | 1396.8 s | 1399.4 s | 1401.9 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 7 | Recovery 3 | 200 m | 1472.9 s | Manual FIT placeholder | 1548.5 s | 75.6 s | 1476.7 s | 3.7 s | HKWorkoutActivityType(rawValue: 37) | 1548.5 s | 75.6 s | 1471.4 s | 1474.0 s | 1476.5 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 8 | Work 4 | 400 m | 1625.8 s | Manual FIT placeholder | 1548.5 s | -77.3 s | 1628.3 s | 2.5 s | HKWorkoutActivityType(rawValue: 37) | 1548.5 s | -77.3 s | 1623.2 s | 1625.8 s | 1628.3 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 9 | Recovery 4 | 200 m | 1700.4 s | Manual FIT placeholder | 1548.5 s | -151.9 s | 1702.7 s | 2.3 s | HKWorkoutActivityType(rawValue: 37) | 1548.5 s | -151.9 s | 1697.8 s | 1700.4 s | 1702.9 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 10 | Cooldown | Open | 2119.2 s | Manual FIT placeholder | 2119.2 s | 0.0 s | 2119.2 s | 0.0 s | HKWorkoutActivityType(rawValue: 37) | 2119.2 s | 0.0 s | Unavailable | Unavailable | Unavailable |  |

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
      "distanceMeters" : 2006.5606011425712,
      "durationSeconds" : 781.3651436567307,
      "endOffsetSeconds" : 781.3651436567307,
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
      "distanceMeters" : 400.9813783508975,
      "durationSeconds" : 156.6173858642578,
      "endOffsetSeconds" : 937.9825295209885,
      "index" : 2,
      "label" : "Work 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 781.3651436567307,
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
      "distanceMeters" : 200.16539026583965,
      "durationSeconds" : 78.37372076511383,
      "endOffsetSeconds" : 1016.3562502861023,
      "index" : 3,
      "label" : "Recovery 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 937.9825295209885,
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
      "distanceMeters" : 401.16246219600134,
      "durationSeconds" : 151.801367521286,
      "endOffsetSeconds" : 1168.1576178073883,
      "index" : 4,
      "label" : "Work 2",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1016.3562502861023,
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
      "distanceMeters" : 192.56169746480634,
      "durationSeconds" : 73.19225466251373,
      "endOffsetSeconds" : 1241.349872469902,
      "index" : 5,
      "label" : "Recovery 2",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1168.1576178073883,
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
      "distanceMeters" : 406.69700443798337,
      "durationSeconds" : 160.14925742149353,
      "endOffsetSeconds" : 1401.4991298913956,
      "index" : 6,
      "label" : "Work 3",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1241.349872469902,
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
      "distanceMeters" : 199.48747433100573,
      "durationSeconds" : 75.1772050857544,
      "endOffsetSeconds" : 1476.67633497715,
      "index" : 7,
      "label" : "Recovery 3",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1401.4991298913956,
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
      "distanceMeters" : 399.46498203676595,
      "durationSeconds" : 151.57985281944275,
      "endOffsetSeconds" : 1628.2561877965927,
      "index" : 8,
      "label" : "Work 4",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1476.67633497715,
      "stepType" : "work"
    },
    {
      "activityIndex" : 9,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 200.9143884127897,
      "durationSeconds" : 74.45893740653992,
      "endOffsetSeconds" : 1702.7151252031326,
      "index" : 9,
      "label" : "Recovery 4",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1628.2561877965927,
      "stepType" : "recovery"
    },
    {
      "activityIndex" : 10,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 544.5697051345086,
      "durationSeconds" : 416.4484438896179,
      "endOffsetSeconds" : 2119.1635690927505,
      "index" : 10,
      "label" : "Cooldown",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "Open",
      "plannedGoalType" : "open",
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1702.7151252031326,
      "stepType" : "cooldown"
    }
  ],
  "activityBoundaryCandidateSummary" : {
    "activityCount" : 10,
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
    "plannedStepCount" : 10,
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
          "endCumulativeDistanceMeters" : 2002.2131059132516,
          "endDate" : "2026-06-28T13:40:30Z",
          "endOffsetSeconds" : 776.7699873447418,
          "startCumulativeDistanceMeters" : 1995.385013777297,
          "startDate" : "2026-06-28T13:40:27Z",
          "startOffsetSeconds" : 774.1972812414169
        },
        "cumulativeDistanceAtEndMeters" : 2002.2131059132516,
        "cumulativeDistanceAtStartMeters" : 0,
        "interpolationFraction" : 0.6758822421862033,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2007.743434186792,
          "endDate" : "2026-06-28T13:40:32Z",
          "endOffsetSeconds" : 779.3426913022995,
          "startCumulativeDistanceMeters" : 2002.2131059132516,
          "startDate" : "2026-06-28T13:40:30Z",
          "startOffsetSeconds" : 776.7699873447418
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 1995.385013777297,
          "endDate" : "2026-06-28T13:40:27Z",
          "endOffsetSeconds" : 774.1972812414169,
          "startCumulativeDistanceMeters" : 1988.076349098701,
          "startDate" : "2026-06-28T13:40:25Z",
          "startOffsetSeconds" : 771.6245757341385
        },
        "targetDistanceMeters" : 2000
      },
      "index" : 1,
      "label" : "Warmup"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 2403.0570614926983,
          "endDate" : "2026-06-28T13:43:07Z",
          "endOffsetSeconds" : 933.7055633068085,
          "startCumulativeDistanceMeters" : 2397.1757821482606,
          "startDate" : "2026-06-28T13:43:04Z",
          "startOffsetSeconds" : 931.132847070694
        },
        "cumulativeDistanceAtEndMeters" : 2403.0570614926983,
        "cumulativeDistanceAtStartMeters" : 2002.2131059132516,
        "interpolationFraction" : 0.8565013613500915,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2409.82744419761,
          "endDate" : "2026-06-28T13:43:09Z",
          "endOffsetSeconds" : 936.2782797813416,
          "startCumulativeDistanceMeters" : 2403.0570614926983,
          "startDate" : "2026-06-28T13:43:07Z",
          "startOffsetSeconds" : 933.7055633068085
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 2397.1757821482606,
          "endDate" : "2026-06-28T13:43:04Z",
          "endOffsetSeconds" : 931.132847070694,
          "startCumulativeDistanceMeters" : 2390.3421120757703,
          "startDate" : "2026-06-28T13:43:02Z",
          "startOffsetSeconds" : 928.5601317882538
        },
        "targetDistanceMeters" : 400
      },
      "index" : 2,
      "label" : "Work 1"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 2606.812860094011,
          "endDate" : "2026-06-28T13:44:27Z",
          "endOffsetSeconds" : 1013.4594565629959,
          "startCumulativeDistanceMeters" : 2599.911580650136,
          "startDate" : "2026-06-28T13:44:24Z",
          "startOffsetSeconds" : 1010.8867678642273
        },
        "cumulativeDistanceAtEndMeters" : 2606.812860094011,
        "cumulativeDistanceAtStartMeters" : 2403.0570614926983,
        "interpolationFraction" : 0.4557822745975138,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2613.9133286462165,
          "endDate" : "2026-06-28T13:44:29Z",
          "endOffsetSeconds" : 1016.0321459770203,
          "startCumulativeDistanceMeters" : 2606.812860094011,
          "startDate" : "2026-06-28T13:44:27Z",
          "startOffsetSeconds" : 1013.4594565629959
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 2599.911580650136,
          "endDate" : "2026-06-28T13:44:24Z",
          "endOffsetSeconds" : 1010.8867678642273,
          "startCumulativeDistanceMeters" : 2593.369129783241,
          "startDate" : "2026-06-28T13:44:21Z",
          "startOffsetSeconds" : 1008.3140759468079
        },
        "targetDistanceMeters" : 200
      },
      "index" : 3,
      "label" : "Recovery 1"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3007.9372017562855,
          "endDate" : "2026-06-28T13:46:58Z",
          "endOffsetSeconds" : 1165.2480442523956,
          "startCumulativeDistanceMeters" : 3000.1497976274695,
          "startDate" : "2026-06-28T13:46:56Z",
          "startOffsetSeconds" : 1162.6753495931625
        },
        "cumulativeDistanceAtEndMeters" : 3007.9372017562855,
        "cumulativeDistanceAtStartMeters" : 2603.0570616462637,
        "interpolationFraction" : 0.373329028608693,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3015.059570188867,
          "endDate" : "2026-06-28T13:47:01Z",
          "endOffsetSeconds" : 1167.8207392692566,
          "startCumulativeDistanceMeters" : 3007.9372017562855,
          "startDate" : "2026-06-28T13:46:58Z",
          "startOffsetSeconds" : 1165.2480442523956
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3000.1497976274695,
          "endDate" : "2026-06-28T13:46:56Z",
          "endOffsetSeconds" : 1162.6753495931625,
          "startCumulativeDistanceMeters" : 2994.428426153958,
          "startDate" : "2026-06-28T13:46:53Z",
          "startOffsetSeconds" : 1160.1026536226273
        },
        "targetDistanceMeters" : 400
      },
      "index" : 4,
      "label" : "Work 2"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3204.108878453495,
          "endDate" : "2026-06-28T13:48:13Z",
          "endOffsetSeconds" : 1239.8565549850464,
          "startCumulativeDistanceMeters" : 3197.7274956044275,
          "startDate" : "2026-06-28T13:48:10Z",
          "startOffsetSeconds" : 1237.2838398218155
        },
        "cumulativeDistanceAtEndMeters" : 3204.108878453495,
        "cumulativeDistanceAtStartMeters" : 3003.0570617021954,
        "interpolationFraction" : 0.8351741658231147,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3209.005804701941,
          "endDate" : "2026-06-28T13:48:15Z",
          "endOffsetSeconds" : 1242.4292719364166,
          "startCumulativeDistanceMeters" : 3204.108878453495,
          "startDate" : "2026-06-28T13:48:13Z",
          "startOffsetSeconds" : 1239.8565549850464
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3197.7274956044275,
          "endDate" : "2026-06-28T13:48:10Z",
          "endOffsetSeconds" : 1237.2838398218155,
          "startCumulativeDistanceMeters" : 3190.8818325109314,
          "startDate" : "2026-06-28T13:48:08Z",
          "startOffsetSeconds" : 1234.7111214399338
        },
        "targetDistanceMeters" : 200
      },
      "index" : 5,
      "label" : "Recovery 2"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3609.2374582188204,
          "endDate" : "2026-06-28T13:50:52Z",
          "endOffsetSeconds" : 1399.3653082847595,
          "startCumulativeDistanceMeters" : 3602.7373317782767,
          "startDate" : "2026-06-28T13:50:50Z",
          "startOffsetSeconds" : 1396.7925775051117
        },
        "cumulativeDistanceAtEndMeters" : 3609.2374582188204,
        "cumulativeDistanceAtStartMeters" : 3204.108878453495,
        "interpolationFraction" : 0.21100307628839768,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3615.852383462712,
          "endDate" : "2026-06-28T13:50:55Z",
          "endOffsetSeconds" : 1401.9380388259888,
          "startCumulativeDistanceMeters" : 3609.2374582188204,
          "startDate" : "2026-06-28T13:50:52Z",
          "startOffsetSeconds" : 1399.3653082847595
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3602.7373317782767,
          "endDate" : "2026-06-28T13:50:50Z",
          "endOffsetSeconds" : 1396.7925775051117,
          "startCumulativeDistanceMeters" : 3595.557614436373,
          "startDate" : "2026-06-28T13:50:47Z",
          "startOffsetSeconds" : 1394.2198458909988
        },
        "targetDistanceMeters" : 400
      },
      "index" : 6,
      "label" : "Work 3"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3807.2341863522306,
          "endDate" : "2026-06-28T13:52:07Z",
          "endOffsetSeconds" : 1473.9747830629349,
          "startCumulativeDistanceMeters" : 3799.5630353342276,
          "startDate" : "2026-06-28T13:52:04Z",
          "startOffsetSeconds" : 1471.4020429849625
        },
        "cumulativeDistanceAtEndMeters" : 3807.2341863522306,
        "cumulativeDistanceAtStartMeters" : 3604.108878356718,
        "interpolationFraction" : 0.592589431732204,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3814.8601341913454,
          "endDate" : "2026-06-28T13:52:10Z",
          "endOffsetSeconds" : 1476.5475208759308,
          "startCumulativeDistanceMeters" : 3807.2341863522306,
          "startDate" : "2026-06-28T13:52:07Z",
          "startOffsetSeconds" : 1473.9747830629349
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3799.5630353342276,
          "endDate" : "2026-06-28T13:52:04Z",
          "endOffsetSeconds" : 1471.4020429849625,
          "startCumulativeDistanceMeters" : 3793.222932334058,
          "startDate" : "2026-06-28T13:52:02Z",
          "startOffsetSeconds" : 1468.82930123806
        },
        "targetDistanceMeters" : 200
      },
      "index" : 7,
      "label" : "Recovery 3"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 4207.277328390162,
          "endDate" : "2026-06-28T13:54:39Z",
          "endOffsetSeconds" : 1625.7661781311035,
          "startCumulativeDistanceMeters" : 4201.170129553182,
          "startDate" : "2026-06-28T13:54:36Z",
          "startOffsetSeconds" : 1623.1934596300125
        },
        "cumulativeDistanceAtEndMeters" : 4207.277328390162,
        "cumulativeDistanceAtStartMeters" : 3804.108878328449,
        "interpolationFraction" : 0.4811942191028324,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 4213.841023430694,
          "endDate" : "2026-06-28T13:54:41Z",
          "endOffsetSeconds" : 1628.338897228241,
          "startCumulativeDistanceMeters" : 4207.277328390162,
          "startDate" : "2026-06-28T13:54:39Z",
          "startOffsetSeconds" : 1625.7661781311035
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 4201.170129553182,
          "endDate" : "2026-06-28T13:54:36Z",
          "endOffsetSeconds" : 1623.1934596300125,
          "startCumulativeDistanceMeters" : 4195.915777387563,
          "startDate" : "2026-06-28T13:54:34Z",
          "startOffsetSeconds" : 1620.6207423210144
        },
        "targetDistanceMeters" : 400
      },
      "index" : 8,
      "label" : "Work 4"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 4408.579290623544,
          "endDate" : "2026-06-28T13:55:53Z",
          "endOffsetSeconds" : 1700.3753020763397,
          "startCumulativeDistanceMeters" : 4402.129316491308,
          "startDate" : "2026-06-28T13:55:51Z",
          "startOffsetSeconds" : 1697.8025727272034
        },
        "cumulativeDistanceAtEndMeters" : 4408.579290623544,
        "cumulativeDistanceAtStartMeters" : 4207.277328390162,
        "interpolationFraction" : 0.7981445806310578,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 4416.950829650974,
          "endDate" : "2026-06-28T13:55:56Z",
          "endOffsetSeconds" : 1702.9480328559875,
          "startCumulativeDistanceMeters" : 4408.579290623544,
          "startDate" : "2026-06-28T13:55:53Z",
          "startOffsetSeconds" : 1700.3753020763397
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 4402.129316491308,
          "endDate" : "2026-06-28T13:55:51Z",
          "endOffsetSeconds" : 1697.8025727272034,
          "startCumulativeDistanceMeters" : 4395.130951468367,
          "startDate" : "2026-06-28T13:55:48Z",
          "startOffsetSeconds" : 1695.2298456430435
        },
        "targetDistanceMeters" : 200
      },
      "index" : 9,
      "label" : "Recovery 4"
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
  "customWorkoutCandidateRuleRows" : [
    {
      "activeDurationSeconds" : 781.3651436567307,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Active duration subtracts paired HealthKit pause\/resume overlap when available.",
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 2006.5606011425712,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 781.3651436567307,
      "endOffsetSeconds" : 781.3651436567307,
      "index" : 1,
      "isOpenTail" : false,
      "label" : "Warmup",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 0,
      "stepType" : "warmup"
    },
    {
      "activeDurationSeconds" : 156.6173858642578,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Active duration subtracts paired HealthKit pause\/resume overlap when available.",
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 400.9813783508975,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 156.6173858642578,
      "endOffsetSeconds" : 937.9825295209885,
      "index" : 2,
      "isOpenTail" : false,
      "label" : "Work 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 781.3651436567307,
      "stepType" : "work"
    },
    {
      "activeDurationSeconds" : 78.37372076511383,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Active duration subtracts paired HealthKit pause\/resume overlap when available.",
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 200.16539026583965,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 78.37372076511383,
      "endOffsetSeconds" : 1016.3562502861023,
      "index" : 3,
      "isOpenTail" : false,
      "label" : "Recovery 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 937.9825295209885,
      "stepType" : "recovery"
    },
    {
      "activeDurationSeconds" : 151.801367521286,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Active duration subtracts paired HealthKit pause\/resume overlap when available.",
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 401.16246219600134,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 151.801367521286,
      "endOffsetSeconds" : 1168.1576178073883,
      "index" : 4,
      "isOpenTail" : false,
      "label" : "Work 2",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1016.3562502861023,
      "stepType" : "work"
    },
    {
      "activeDurationSeconds" : 73.19225466251373,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Active duration subtracts paired HealthKit pause\/resume overlap when available.",
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 192.56169746480634,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 73.19225466251373,
      "endOffsetSeconds" : 1241.349872469902,
      "index" : 5,
      "isOpenTail" : false,
      "label" : "Recovery 2",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1168.1576178073883,
      "stepType" : "recovery"
    },
    {
      "activeDurationSeconds" : 160.14925742149353,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Active duration subtracts paired HealthKit pause\/resume overlap when available.",
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 406.69700443798337,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 160.14925742149353,
      "endOffsetSeconds" : 1401.4991298913956,
      "index" : 6,
      "isOpenTail" : false,
      "label" : "Work 3",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1241.349872469902,
      "stepType" : "work"
    },
    {
      "activeDurationSeconds" : 75.1772050857544,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Active duration subtracts paired HealthKit pause\/resume overlap when available.",
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 199.48747433100573,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 75.1772050857544,
      "endOffsetSeconds" : 1476.67633497715,
      "index" : 7,
      "isOpenTail" : false,
      "label" : "Recovery 3",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1401.4991298913956,
      "stepType" : "recovery"
    },
    {
      "activeDurationSeconds" : 151.57985281944275,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Active duration subtracts paired HealthKit pause\/resume overlap when available.",
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 399.46498203676595,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 151.57985281944275,
      "endOffsetSeconds" : 1628.2561877965927,
      "index" : 8,
      "isOpenTail" : false,
      "label" : "Work 4",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1476.67633497715,
      "stepType" : "work"
    },
    {
      "activeDurationSeconds" : 74.45893740653992,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Active duration subtracts paired HealthKit pause\/resume overlap when available.",
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 200.9143884127897,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 74.45893740653992,
      "endOffsetSeconds" : 1702.7151252031326,
      "index" : 9,
      "isOpenTail" : false,
      "label" : "Recovery 4",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1628.2561877965927,
      "stepType" : "recovery"
    },
    {
      "activeDurationSeconds" : 416.4484438896179,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Active duration subtracts paired HealthKit pause\/resume overlap when available.",
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 544.5697051345086,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 416.4484438896179,
      "endOffsetSeconds" : 2119.1635690927505,
      "index" : 10,
      "isOpenTail" : false,
      "label" : "Cooldown",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1702.7151252031326,
      "stepType" : "cooldown"
    }
  ],
  "customWorkoutCandidateRuleSummary" : {
    "boundaryLogicChanged" : false,
    "candidateRowCount" : 10,
    "caveats" : [
      "debug-only, not promoted",
      "not production interval logic",
      "not shown in normal workout UI",
      "FIT and Apple Fitness\/manual rows are not runtime inputs",
      "Active duration subtracts paired HealthKit pause\/resume overlap when available."
    ],
    "fallbackReasons" : [

    ],
    "fitValidationStatus" : "offline-evidence-only-not-runtime-truth",
    "fixedRowExhaustionStatus" : "fixed-rows-mapped-no-tail",
    "isScoreable" : true,
    "normalWorkoutUIChanged" : false,
    "openTailRowCount" : 0,
    "pairedPauseCount" : 0,
    "plannedExpandedRowCount" : 10,
    "productionIntervalBehaviorChanged" : false,
    "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
    "ruleStatus" : "candidate-rule-scoreable",
    "safetyFlags" : [
      "debug-only, not promoted",
      "not production interval logic",
      "not shown in normal workout UI",
      "FIT and Apple Fitness\/manual rows are not runtime inputs",
      "Active duration subtracts paired HealthKit pause\/resume overlap when available."
    ],
    "scope" : "debug\/export-only",
    "strategyID" : "custom_workout_candidate_rule_active_time",
    "tailStatus" : "open-extra-tail-absent",
    "totalPairedPauseSeconds" : 0,
    "usesAppleFitnessManualRuntimeLogic" : false,
    "usesFITRuntimeTruth" : false
  },
  "customWorkoutComparisonSummary" : {
    "fallbackReasonLabels" : [

    ],
    "fallbackReasons" : [

    ],
    "normalWorkoutUIChanged" : false,
    "productionIntervalBehaviorChanged" : false,
    "promotesProductionBehavior" : false,
    "rowConfidences" : [
      "needsRule",
      "needsRule",
      "needsRule",
      "needsRule",
      "needsRule",
      "needsRule",
      "needsRule",
      "needsRule",
      "needsRule",
      "needsRule"
    ],
    "rowCount" : 10,
    "scope" : "debug\/export-only",
    "status" : "repeat-block-needs-rule",
    "statusLabel" : "Repeat-block rows need an approved rule.",
    "tailAmbiguity" : "plannedOpenCooldownContinuesToWorkoutEnd",
    "usesFITRuntimeTruth" : false
  },
  "evidenceCounts" : {
    "activeEnergy" : 823,
    "activities" : 10,
    "cadence" : 811,
    "distance" : 810,
    "events" : 10,
    "groundContact" : 316,
    "heartRate" : 419,
    "power" : 807,
    "routePoints" : 2116,
    "speed" : 808,
    "stepCount" : 811,
    "strideLength" : 316,
    "verticalOscillation" : 320
  },
  "generatedAt" : "2026-06-28T19:37:38Z",
  "plannedStepBoundaryComparisons" : [
    {
      "crossingDistanceSampleEndOffsetSeconds" : 776.7699873447418,
      "index" : 1,
      "nearestRawEventEndDeltaSeconds" : 1.738844871520996,
      "nearestRawEventEndOffsetSeconds" : 778.5088322162628,
      "nearestRawEventStartOffsetSeconds" : 394.09315156936646,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 1.738844871520996,
      "nearestSegmentMarkerEndOffsetSeconds" : 778.5088322162628,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 394.09315156936646,
      "nearestWorkoutActivityEndDeltaSeconds" : 4.595156311988831,
      "nearestWorkoutActivityEndOffsetSeconds" : 781.3651436567307,
      "nearestWorkoutActivityStartOffsetSeconds" : 0,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 779.3426913022995,
      "plannedGoalDisplayText" : "2 km",
      "plannedStepLabel" : "Warmup",
      "previousDistanceSampleEndOffsetSeconds" : 774.1972812414169,
      "reconstructedEndOffsetSeconds" : 776.7699873447418,
      "reconstructedLabel" : "Warmup"
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 933.7055633068085,
      "index" : 2,
      "nearestRawEventEndDeltaSeconds" : -155.19673109054565,
      "nearestRawEventEndOffsetSeconds" : 778.5088322162628,
      "nearestRawEventStartOffsetSeconds" : 394.09315156936646,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -155.19673109054565,
      "nearestSegmentMarkerEndOffsetSeconds" : 778.5088322162628,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 394.09315156936646,
      "nearestWorkoutActivityEndDeltaSeconds" : 4.276966214179993,
      "nearestWorkoutActivityEndOffsetSeconds" : 937.9825295209885,
      "nearestWorkoutActivityStartOffsetSeconds" : 781.3651436567307,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 936.2782797813416,
      "plannedGoalDisplayText" : "400 m",
      "plannedStepLabel" : "Work 1",
      "previousDistanceSampleEndOffsetSeconds" : 931.132847070694,
      "reconstructedEndOffsetSeconds" : 933.7055633068085,
      "reconstructedLabel" : "Work 1",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1013.4594565629959,
      "index" : 3,
      "nearestRawEventEndDeltaSeconds" : 153.12133181095123,
      "nearestRawEventEndOffsetSeconds" : 1165.1806856393814,
      "nearestRawEventStartOffsetSeconds" : 778.5088322162628,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 153.12133181095123,
      "nearestSegmentMarkerEndOffsetSeconds" : 1165.1806856393814,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 778.5088322162628,
      "nearestWorkoutActivityEndDeltaSeconds" : 4.296896457672119,
      "nearestWorkoutActivityEndOffsetSeconds" : 1016.3562502861023,
      "nearestWorkoutActivityStartOffsetSeconds" : 937.9825295209885,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1016.0321459770203,
      "plannedGoalDisplayText" : "200 m",
      "plannedStepLabel" : "Recovery 1",
      "previousDistanceSampleEndOffsetSeconds" : 1010.8867678642273,
      "reconstructedEndOffsetSeconds" : 1012.0593538284302,
      "reconstructedLabel" : "Recovery 1",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1165.2480442523956,
      "index" : 4,
      "nearestRawEventEndDeltaSeconds" : 1.5448744297027588,
      "nearestRawEventEndOffsetSeconds" : 1165.1806856393814,
      "nearestRawEventStartOffsetSeconds" : 778.5088322162628,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 1.5448744297027588,
      "nearestSegmentMarkerEndOffsetSeconds" : 1165.1806856393814,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 778.5088322162628,
      "nearestWorkoutActivityEndDeltaSeconds" : 4.521806597709656,
      "nearestWorkoutActivityEndOffsetSeconds" : 1168.1576178073883,
      "nearestWorkoutActivityStartOffsetSeconds" : 1016.3562502861023,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1167.8207392692566,
      "plannedGoalDisplayText" : "400 m",
      "plannedStepLabel" : "Work 2",
      "previousDistanceSampleEndOffsetSeconds" : 1162.6753495931625,
      "reconstructedEndOffsetSeconds" : 1163.6358112096786,
      "reconstructedLabel" : "Work 2"
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1239.8565549850464,
      "index" : 5,
      "nearestRawEventEndDeltaSeconds" : 8.159025192260742,
      "nearestRawEventEndOffsetSeconds" : 1248.0155801773071,
      "nearestRawEventStartOffsetSeconds" : 628.6849510669708,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 8.159025192260742,
      "nearestSegmentMarkerEndOffsetSeconds" : 1248.0155801773071,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 628.6849510669708,
      "nearestWorkoutActivityEndDeltaSeconds" : 1.4933174848556519,
      "nearestWorkoutActivityEndOffsetSeconds" : 1241.349872469902,
      "nearestWorkoutActivityStartOffsetSeconds" : 1168.1576178073883,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1242.4292719364166,
      "plannedGoalDisplayText" : "200 m",
      "plannedStepLabel" : "Recovery 2",
      "previousDistanceSampleEndOffsetSeconds" : 1237.2838398218155,
      "reconstructedEndOffsetSeconds" : 1239.8565549850464,
      "reconstructedLabel" : "Recovery 2",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1399.3653082847595,
      "index" : 6,
      "nearestRawEventEndDeltaSeconds" : -149.31985139846802,
      "nearestRawEventEndOffsetSeconds" : 1248.0155801773071,
      "nearestRawEventStartOffsetSeconds" : 628.6849510669708,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -149.31985139846802,
      "nearestSegmentMarkerEndOffsetSeconds" : 1248.0155801773071,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 628.6849510669708,
      "nearestWorkoutActivityEndDeltaSeconds" : 4.163698315620422,
      "nearestWorkoutActivityEndOffsetSeconds" : 1401.4991298913956,
      "nearestWorkoutActivityStartOffsetSeconds" : 1241.349872469902,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1401.9380388259888,
      "plannedGoalDisplayText" : "400 m",
      "plannedStepLabel" : "Work 3",
      "previousDistanceSampleEndOffsetSeconds" : 1396.7925775051117,
      "reconstructedEndOffsetSeconds" : 1397.3354315757751,
      "reconstructedLabel" : "Work 3",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1473.9747830629349,
      "index" : 7,
      "nearestRawEventEndDeltaSeconds" : 75.57799518108368,
      "nearestRawEventEndOffsetSeconds" : 1548.5046167373657,
      "nearestRawEventStartOffsetSeconds" : 1165.1806856393814,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 75.57799518108368,
      "nearestSegmentMarkerEndOffsetSeconds" : 1548.5046167373657,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1165.1806856393814,
      "nearestWorkoutActivityEndDeltaSeconds" : 3.74971342086792,
      "nearestWorkoutActivityEndOffsetSeconds" : 1476.67633497715,
      "nearestWorkoutActivityStartOffsetSeconds" : 1401.4991298913956,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1476.5475208759308,
      "plannedGoalDisplayText" : "200 m",
      "plannedStepLabel" : "Recovery 3",
      "previousDistanceSampleEndOffsetSeconds" : 1471.4020429849625,
      "reconstructedEndOffsetSeconds" : 1472.926621556282,
      "reconstructedLabel" : "Recovery 3",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1625.7661781311035,
      "index" : 8,
      "nearestRawEventEndDeltaSeconds" : -77.2615613937378,
      "nearestRawEventEndOffsetSeconds" : 1548.5046167373657,
      "nearestRawEventStartOffsetSeconds" : 1165.1806856393814,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -77.2615613937378,
      "nearestSegmentMarkerEndOffsetSeconds" : 1548.5046167373657,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1165.1806856393814,
      "nearestWorkoutActivityEndDeltaSeconds" : 2.4900096654891968,
      "nearestWorkoutActivityEndOffsetSeconds" : 1628.2561877965927,
      "nearestWorkoutActivityStartOffsetSeconds" : 1476.67633497715,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1628.338897228241,
      "plannedGoalDisplayText" : "400 m",
      "plannedStepLabel" : "Work 4",
      "previousDistanceSampleEndOffsetSeconds" : 1623.1934596300125,
      "reconstructedEndOffsetSeconds" : 1625.7661781311035,
      "reconstructedLabel" : "Work 4",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1700.3753020763397,
      "index" : 9,
      "nearestRawEventEndDeltaSeconds" : -151.870685338974,
      "nearestRawEventEndOffsetSeconds" : 1548.5046167373657,
      "nearestRawEventStartOffsetSeconds" : 1165.1806856393814,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -151.870685338974,
      "nearestSegmentMarkerEndOffsetSeconds" : 1548.5046167373657,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1165.1806856393814,
      "nearestWorkoutActivityEndDeltaSeconds" : 2.3398231267929077,
      "nearestWorkoutActivityEndOffsetSeconds" : 1702.7151252031326,
      "nearestWorkoutActivityStartOffsetSeconds" : 1628.2561877965927,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1702.9480328559875,
      "plannedGoalDisplayText" : "200 m",
      "plannedStepLabel" : "Recovery 4",
      "previousDistanceSampleEndOffsetSeconds" : 1697.8025727272034,
      "reconstructedEndOffsetSeconds" : 1700.3753020763397,
      "reconstructedLabel" : "Recovery 4",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "index" : 10,
      "nearestRawEventEndDeltaSeconds" : 0,
      "nearestRawEventEndOffsetSeconds" : 2119.1635690927505,
      "nearestRawEventStartOffsetSeconds" : 1548.5046167373657,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 0,
      "nearestSegmentMarkerEndOffsetSeconds" : 2119.1635690927505,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1548.5046167373657,
      "nearestWorkoutActivityEndDeltaSeconds" : 0,
      "nearestWorkoutActivityEndOffsetSeconds" : 2119.1635690927505,
      "nearestWorkoutActivityStartOffsetSeconds" : 1702.7151252031326,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "plannedGoalDisplayText" : "Open",
      "plannedStepLabel" : "Cooldown",
      "reconstructedEndOffsetSeconds" : 2119.1635690927505,
      "reconstructedLabel" : "Cooldown"
    }
  ],
  "rawWorkoutEvents" : [
    {
      "durationSeconds" : 394.09315156936646,
      "endDate" : "2026-06-28T13:34:07Z",
      "endOffsetSeconds" : 394.09315156936646,
      "index" : 1,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1007.2479046507289,
      "renderedSegmentMarkerDurationSeconds" : 394.09315156936646,
      "renderedSegmentMarkerEndOffsetSeconds" : 394.09315156936646,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T13:27:33Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 628.6849510669708,
      "endDate" : "2026-06-28T13:38:02Z",
      "endOffsetSeconds" : 628.6849510669708,
      "index" : 2,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1616.1982395498335,
      "renderedSegmentMarkerDurationSeconds" : 628.6849510669708,
      "renderedSegmentMarkerEndOffsetSeconds" : 628.6849510669708,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T13:27:33Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 384.41568064689636,
      "endDate" : "2026-06-28T13:40:32Z",
      "endOffsetSeconds" : 778.5088322162628,
      "index" : 3,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 998.7030518333294,
      "renderedSegmentMarkerDurationSeconds" : 384.41568064689636,
      "renderedSegmentMarkerEndOffsetSeconds" : 778.5088322162628,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 394.09315156936646,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T13:34:07Z",
      "startOffsetSeconds" : 394.09315156936646,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 619.3306291103363,
      "endDate" : "2026-06-28T13:48:21Z",
      "endOffsetSeconds" : 1248.0155801773071,
      "index" : 4,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1609.4281180591456,
      "renderedSegmentMarkerDurationSeconds" : 619.3306291103363,
      "renderedSegmentMarkerEndOffsetSeconds" : 1248.0155801773071,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 628.6849510669708,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T13:38:02Z",
      "startOffsetSeconds" : 628.6849510669708,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 386.6718534231186,
      "endDate" : "2026-06-28T13:46:58Z",
      "endOffsetSeconds" : 1165.1806856393814,
      "index" : 5,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1001.7823544843268,
      "renderedSegmentMarkerDurationSeconds" : 386.6718534231186,
      "renderedSegmentMarkerEndOffsetSeconds" : 1165.1806856393814,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 778.5088322162628,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T13:40:32Z",
      "startOffsetSeconds" : 778.5088322162628,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 383.3239310979843,
      "endDate" : "2026-06-28T13:53:22Z",
      "endOffsetSeconds" : 1548.5046167373657,
      "index" : 6,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 999.4287956788139,
      "renderedSegmentMarkerDurationSeconds" : 383.3239310979843,
      "renderedSegmentMarkerEndOffsetSeconds" : 1548.5046167373657,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1165.1806856393814,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T13:46:58Z",
      "startOffsetSeconds" : 1165.1806856393814,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 746.3821996450424,
      "endDate" : "2026-06-28T14:00:47Z",
      "endOffsetSeconds" : 1994.3977798223495,
      "index" : 7,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1606.1756145284567,
      "renderedSegmentMarkerDurationSeconds" : 746.3821996450424,
      "renderedSegmentMarkerEndOffsetSeconds" : 1994.3977798223495,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1248.0155801773071,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T13:48:21Z",
      "startOffsetSeconds" : 1248.0155801773071,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 570.6589523553848,
      "endDate" : "2026-06-28T14:02:52Z",
      "endOffsetSeconds" : 2119.1635690927505,
      "index" : 8,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 945.9011766006743,
      "renderedSegmentMarkerDurationSeconds" : 570.6589523553848,
      "renderedSegmentMarkerEndOffsetSeconds" : 2119.1635690927505,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1548.5046167373657,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T13:53:22Z",
      "startOffsetSeconds" : 1548.5046167373657,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 124.765789270401,
      "endDate" : "2026-06-28T14:02:52Z",
      "endOffsetSeconds" : 2119.1635690927505,
      "index" : 9,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 121.26131111043742,
      "renderedSegmentMarkerDurationSeconds" : 124.765789270401,
      "renderedSegmentMarkerEndOffsetSeconds" : 2119.1635690927505,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1994.3977798223495,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T14:00:47Z",
      "startOffsetSeconds" : 1994.3977798223495,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 0,
      "endDate" : "2026-06-28T14:02:52Z",
      "endOffsetSeconds" : 2119.1635690927505,
      "excludedOrFilteredReason" : "zeroOrNegativeDuration",
      "index" : 10,
      "metadataKeys" : [

      ],
      "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
      "startDate" : "2026-06-28T14:02:52Z",
      "startOffsetSeconds" : 2119.1635690927505,
      "type" : "HKWorkoutEventType(rawValue: 1)",
      "usedBySegmentMarkerRendering" : false
    }
  ],
  "reconstructedIntervals" : [
    {
      "averageHeartRateBpm" : 148.4774193548387,
      "averagePower" : 183.734219269103,
      "boundaryAdjustmentSeconds" : 0.8338596820831299,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 2002.2131059132516,
          "endDate" : "2026-06-28T13:40:30Z",
          "endOffsetSeconds" : 776.7699873447418,
          "startCumulativeDistanceMeters" : 1995.385013777297,
          "startDate" : "2026-06-28T13:40:27Z",
          "startOffsetSeconds" : 774.1972812414169
        },
        "cumulativeDistanceAtEndMeters" : 2002.2131059132516,
        "cumulativeDistanceAtStartMeters" : 0,
        "interpolationFraction" : 0.6758822421862033,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2007.743434186792,
          "endDate" : "2026-06-28T13:40:32Z",
          "endOffsetSeconds" : 779.3426913022995,
          "startCumulativeDistanceMeters" : 2002.2131059132516,
          "startDate" : "2026-06-28T13:40:30Z",
          "startOffsetSeconds" : 776.7699873447418
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 1995.385013777297,
          "endDate" : "2026-06-28T13:40:27Z",
          "endOffsetSeconds" : 774.1972812414169,
          "startCumulativeDistanceMeters" : 1988.076349098701,
          "startDate" : "2026-06-28T13:40:25Z",
          "startOffsetSeconds" : 771.6245757341385
        },
        "targetDistanceMeters" : 2000
      },
      "boundaryOvershootMeters" : 2.2131059132516384,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "displayDurationSeconds" : 776.7699873447418,
      "distanceMeters" : 2002.2131059132516,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 776.7699873447418,
      "elapsedDurationSeconds" : 776.7699873447418,
      "endOffsetSeconds" : 776.7699873447418,
      "index" : 1,
      "label" : "Warmup",
      "maxHeartRateBpm" : 156,
      "paceSecondsPerKm" : 387.95570014533524,
      "plannedGoalDisplayText" : "2 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 2000,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +0.8s, overshoot 2.2 m",
      "startOffsetSeconds" : 0,
      "stepType" : "warmup"
    },
    {
      "averageHeartRateBpm" : 152.25806451612902,
      "averagePower" : 184.6,
      "boundaryAdjustmentSeconds" : 0.3691812753677368,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 2403.0570614926983,
          "endDate" : "2026-06-28T13:43:07Z",
          "endOffsetSeconds" : 933.7055633068085,
          "startCumulativeDistanceMeters" : 2397.1757821482606,
          "startDate" : "2026-06-28T13:43:04Z",
          "startOffsetSeconds" : 931.132847070694
        },
        "cumulativeDistanceAtEndMeters" : 2403.0570614926983,
        "cumulativeDistanceAtStartMeters" : 2002.2131059132516,
        "interpolationFraction" : 0.8565013613500915,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2409.82744419761,
          "endDate" : "2026-06-28T13:43:09Z",
          "endOffsetSeconds" : 936.2782797813416,
          "startCumulativeDistanceMeters" : 2403.0570614926983,
          "startDate" : "2026-06-28T13:43:07Z",
          "startOffsetSeconds" : 933.7055633068085
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 2397.1757821482606,
          "endDate" : "2026-06-28T13:43:04Z",
          "endOffsetSeconds" : 931.132847070694,
          "startCumulativeDistanceMeters" : 2390.3421120757703,
          "startDate" : "2026-06-28T13:43:02Z",
          "startOffsetSeconds" : 928.5601317882538
        },
        "targetDistanceMeters" : 400
      },
      "boundaryOvershootMeters" : 0.8439555794466287,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "displayDurationSeconds" : 156.93557596206665,
      "distanceMeters" : 400.84395557944663,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 156.93557596206665,
      "elapsedDurationSeconds" : 156.93557596206665,
      "endOffsetSeconds" : 933.7055633068085,
      "index" : 2,
      "label" : "Work 1",
      "maxHeartRateBpm" : 155,
      "paceSecondsPerKm" : 391.5128911828191,
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +0.4s, overshoot 0.8 m",
      "startOffsetSeconds" : 776.7699873447418,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 151.25,
      "averagePower" : 186,
      "boundaryAdjustmentSeconds" : 0,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 2606.812860094011,
          "endDate" : "2026-06-28T13:44:27Z",
          "endOffsetSeconds" : 1013.4594565629959,
          "startCumulativeDistanceMeters" : 2599.911580650136,
          "startDate" : "2026-06-28T13:44:24Z",
          "startOffsetSeconds" : 1010.8867678642273
        },
        "cumulativeDistanceAtEndMeters" : 2606.812860094011,
        "cumulativeDistanceAtStartMeters" : 2403.0570614926983,
        "interpolationFraction" : 0.4557822745975138,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2613.9133286462165,
          "endDate" : "2026-06-28T13:44:29Z",
          "endOffsetSeconds" : 1016.0321459770203,
          "startCumulativeDistanceMeters" : 2606.812860094011,
          "startDate" : "2026-06-28T13:44:27Z",
          "startOffsetSeconds" : 1013.4594565629959
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 2599.911580650136,
          "endDate" : "2026-06-28T13:44:24Z",
          "endOffsetSeconds" : 1010.8867678642273,
          "startCumulativeDistanceMeters" : 2593.369129783241,
          "startDate" : "2026-06-28T13:44:21Z",
          "startOffsetSeconds" : 1008.3140759468079
        },
        "targetDistanceMeters" : 200
      },
      "boundaryOvershootMeters" : 3.755798601312563,
      "boundaryStrategy" : "interpolatedCrossing",
      "confidence" : "high",
      "displayDurationSeconds" : 78.3537905216217,
      "distanceMeters" : 200.00000015356545,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 78.3537905216217,
      "elapsedDurationSeconds" : 78.3537905216217,
      "endOffsetSeconds" : 1012.0593538284302,
      "index" : 3,
      "label" : "Recovery 1",
      "maxHeartRateBpm" : 154,
      "paceSecondsPerKm" : 391.76895230729764,
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 3.8 m",
      "startOffsetSeconds" : 933.7055633068085,
      "stepType" : "recovery"
    },
    {
      "averageHeartRateBpm" : 152.03333333333333,
      "averagePower" : 186.91525423728814,
      "boundaryAdjustmentSeconds" : 0,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3007.9372017562855,
          "endDate" : "2026-06-28T13:46:58Z",
          "endOffsetSeconds" : 1165.2480442523956,
          "startCumulativeDistanceMeters" : 3000.1497976274695,
          "startDate" : "2026-06-28T13:46:56Z",
          "startOffsetSeconds" : 1162.6753495931625
        },
        "cumulativeDistanceAtEndMeters" : 3007.9372017562855,
        "cumulativeDistanceAtStartMeters" : 2603.0570616462637,
        "interpolationFraction" : 0.373329028608693,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3015.059570188867,
          "endDate" : "2026-06-28T13:47:01Z",
          "endOffsetSeconds" : 1167.8207392692566,
          "startCumulativeDistanceMeters" : 3007.9372017562855,
          "startDate" : "2026-06-28T13:46:58Z",
          "startOffsetSeconds" : 1165.2480442523956
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3000.1497976274695,
          "endDate" : "2026-06-28T13:46:56Z",
          "endOffsetSeconds" : 1162.6753495931625,
          "startCumulativeDistanceMeters" : 2994.428426153958,
          "startDate" : "2026-06-28T13:46:53Z",
          "startOffsetSeconds" : 1160.1026536226273
        },
        "targetDistanceMeters" : 400
      },
      "boundaryOvershootMeters" : 4.8801401100217845,
      "boundaryStrategy" : "interpolatedCrossing",
      "confidence" : "high",
      "displayDurationSeconds" : 151.57645738124847,
      "distanceMeters" : 400.00000005593165,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 151.57645738124847,
      "elapsedDurationSeconds" : 151.57645738124847,
      "endOffsetSeconds" : 1163.6358112096786,
      "index" : 4,
      "label" : "Work 2",
      "maxHeartRateBpm" : 155,
      "paceSecondsPerKm" : 378.94114340013414,
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 4.9 m",
      "startOffsetSeconds" : 1012.0593538284302,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 153.1875,
      "averagePower" : 187.76666666666668,
      "boundaryAdjustmentSeconds" : 0.424049973487854,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3204.108878453495,
          "endDate" : "2026-06-28T13:48:13Z",
          "endOffsetSeconds" : 1239.8565549850464,
          "startCumulativeDistanceMeters" : 3197.7274956044275,
          "startDate" : "2026-06-28T13:48:10Z",
          "startOffsetSeconds" : 1237.2838398218155
        },
        "cumulativeDistanceAtEndMeters" : 3204.108878453495,
        "cumulativeDistanceAtStartMeters" : 3003.0570617021954,
        "interpolationFraction" : 0.8351741658231147,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3209.005804701941,
          "endDate" : "2026-06-28T13:48:15Z",
          "endOffsetSeconds" : 1242.4292719364166,
          "startCumulativeDistanceMeters" : 3204.108878453495,
          "startDate" : "2026-06-28T13:48:13Z",
          "startOffsetSeconds" : 1239.8565549850464
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3197.7274956044275,
          "endDate" : "2026-06-28T13:48:10Z",
          "endOffsetSeconds" : 1237.2838398218155,
          "startCumulativeDistanceMeters" : 3190.8818325109314,
          "startDate" : "2026-06-28T13:48:08Z",
          "startOffsetSeconds" : 1234.7111214399338
        },
        "targetDistanceMeters" : 200
      },
      "boundaryOvershootMeters" : 1.0518167512996115,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "displayDurationSeconds" : 76.22074377536774,
      "distanceMeters" : 201.0518167512996,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 76.22074377536774,
      "elapsedDurationSeconds" : 76.22074377536774,
      "endOffsetSeconds" : 1239.8565549850464,
      "index" : 5,
      "label" : "Recovery 2",
      "maxHeartRateBpm" : 156,
      "paceSecondsPerKm" : 379.1099479078696,
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +0.4s, overshoot 1.1 m",
      "startOffsetSeconds" : 1163.6358112096786,
      "stepType" : "recovery"
    },
    {
      "averageHeartRateBpm" : 152.7,
      "averagePower" : 184.91935483870967,
      "boundaryAdjustmentSeconds" : 0,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3609.2374582188204,
          "endDate" : "2026-06-28T13:50:52Z",
          "endOffsetSeconds" : 1399.3653082847595,
          "startCumulativeDistanceMeters" : 3602.7373317782767,
          "startDate" : "2026-06-28T13:50:50Z",
          "startOffsetSeconds" : 1396.7925775051117
        },
        "cumulativeDistanceAtEndMeters" : 3609.2374582188204,
        "cumulativeDistanceAtStartMeters" : 3204.108878453495,
        "interpolationFraction" : 0.21100307628839768,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3615.852383462712,
          "endDate" : "2026-06-28T13:50:55Z",
          "endOffsetSeconds" : 1401.9380388259888,
          "startCumulativeDistanceMeters" : 3609.2374582188204,
          "startDate" : "2026-06-28T13:50:52Z",
          "startOffsetSeconds" : 1399.3653082847595
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3602.7373317782767,
          "endDate" : "2026-06-28T13:50:50Z",
          "endOffsetSeconds" : 1396.7925775051117,
          "startCumulativeDistanceMeters" : 3595.557614436373,
          "startDate" : "2026-06-28T13:50:47Z",
          "startOffsetSeconds" : 1394.2198458909988
        },
        "targetDistanceMeters" : 400
      },
      "boundaryOvershootMeters" : 5.128579765325412,
      "boundaryStrategy" : "interpolatedCrossing",
      "confidence" : "high",
      "displayDurationSeconds" : 157.47887659072876,
      "distanceMeters" : 399.99999990322294,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 157.47887659072876,
      "elapsedDurationSeconds" : 157.47887659072876,
      "endOffsetSeconds" : 1397.3354315757751,
      "index" : 6,
      "label" : "Work 3",
      "maxHeartRateBpm" : 156,
      "paceSecondsPerKm" : 393.697191572074,
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 5.1 m",
      "startOffsetSeconds" : 1239.8565549850464,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 154.125,
      "averagePower" : 188.41379310344828,
      "boundaryAdjustmentSeconds" : 0,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3807.2341863522306,
          "endDate" : "2026-06-28T13:52:07Z",
          "endOffsetSeconds" : 1473.9747830629349,
          "startCumulativeDistanceMeters" : 3799.5630353342276,
          "startDate" : "2026-06-28T13:52:04Z",
          "startOffsetSeconds" : 1471.4020429849625
        },
        "cumulativeDistanceAtEndMeters" : 3807.2341863522306,
        "cumulativeDistanceAtStartMeters" : 3604.108878356718,
        "interpolationFraction" : 0.592589431732204,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3814.8601341913454,
          "endDate" : "2026-06-28T13:52:10Z",
          "endOffsetSeconds" : 1476.5475208759308,
          "startCumulativeDistanceMeters" : 3807.2341863522306,
          "startDate" : "2026-06-28T13:52:07Z",
          "startOffsetSeconds" : 1473.9747830629349
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3799.5630353342276,
          "endDate" : "2026-06-28T13:52:04Z",
          "endOffsetSeconds" : 1471.4020429849625,
          "startCumulativeDistanceMeters" : 3793.222932334058,
          "startDate" : "2026-06-28T13:52:02Z",
          "startOffsetSeconds" : 1468.82930123806
        },
        "targetDistanceMeters" : 200
      },
      "boundaryOvershootMeters" : 3.125307995512685,
      "boundaryStrategy" : "interpolatedCrossing",
      "confidence" : "high",
      "displayDurationSeconds" : 75.5911899805069,
      "distanceMeters" : 199.99999997173109,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 75.5911899805069,
      "elapsedDurationSeconds" : 75.5911899805069,
      "endOffsetSeconds" : 1472.926621556282,
      "index" : 7,
      "label" : "Recovery 3",
      "maxHeartRateBpm" : 157,
      "paceSecondsPerKm" : 377.9559499559565,
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 3.1 m",
      "startOffsetSeconds" : 1397.3354315757751,
      "stepType" : "recovery"
    },
    {
      "averageHeartRateBpm" : 157.06666666666666,
      "averagePower" : 196.06666666666666,
      "boundaryAdjustmentSeconds" : 1.334741234779358,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 4207.277328390162,
          "endDate" : "2026-06-28T13:54:39Z",
          "endOffsetSeconds" : 1625.7661781311035,
          "startCumulativeDistanceMeters" : 4201.170129553182,
          "startDate" : "2026-06-28T13:54:36Z",
          "startOffsetSeconds" : 1623.1934596300125
        },
        "cumulativeDistanceAtEndMeters" : 4207.277328390162,
        "cumulativeDistanceAtStartMeters" : 3804.108878328449,
        "interpolationFraction" : 0.4811942191028324,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 4213.841023430694,
          "endDate" : "2026-06-28T13:54:41Z",
          "endOffsetSeconds" : 1628.338897228241,
          "startCumulativeDistanceMeters" : 4207.277328390162,
          "startDate" : "2026-06-28T13:54:39Z",
          "startOffsetSeconds" : 1625.7661781311035
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 4201.170129553182,
          "endDate" : "2026-06-28T13:54:36Z",
          "endOffsetSeconds" : 1623.1934596300125,
          "startCumulativeDistanceMeters" : 4195.915777387563,
          "startDate" : "2026-06-28T13:54:34Z",
          "startOffsetSeconds" : 1620.6207423210144
        },
        "targetDistanceMeters" : 400
      },
      "boundaryOvershootMeters" : 3.1684500617138838,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "displayDurationSeconds" : 152.83955657482147,
      "distanceMeters" : 403.16845006171343,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 152.83955657482147,
      "elapsedDurationSeconds" : 152.83955657482147,
      "endOffsetSeconds" : 1625.7661781311035,
      "index" : 8,
      "label" : "Work 4",
      "maxHeartRateBpm" : 159,
      "paceSecondsPerKm" : 379.0960243824291,
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +1.3s, overshoot 3.2 m",
      "startOffsetSeconds" : 1472.926621556282,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 155.53333333333333,
      "averagePower" : 191.13793103448276,
      "boundaryAdjustmentSeconds" : 0.5193194150924683,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 4408.579290623544,
          "endDate" : "2026-06-28T13:55:53Z",
          "endOffsetSeconds" : 1700.3753020763397,
          "startCumulativeDistanceMeters" : 4402.129316491308,
          "startDate" : "2026-06-28T13:55:51Z",
          "startOffsetSeconds" : 1697.8025727272034
        },
        "cumulativeDistanceAtEndMeters" : 4408.579290623544,
        "cumulativeDistanceAtStartMeters" : 4207.277328390162,
        "interpolationFraction" : 0.7981445806310578,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 4416.950829650974,
          "endDate" : "2026-06-28T13:55:56Z",
          "endOffsetSeconds" : 1702.9480328559875,
          "startCumulativeDistanceMeters" : 4408.579290623544,
          "startDate" : "2026-06-28T13:55:53Z",
          "startOffsetSeconds" : 1700.3753020763397
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 4402.129316491308,
          "endDate" : "2026-06-28T13:55:51Z",
          "endOffsetSeconds" : 1697.8025727272034,
          "startCumulativeDistanceMeters" : 4395.130951468367,
          "startDate" : "2026-06-28T13:55:48Z",
          "startOffsetSeconds" : 1695.2298456430435
        },
        "targetDistanceMeters" : 200
      },
      "boundaryOvershootMeters" : 1.3019622333813459,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "displayDurationSeconds" : 74.6091239452362,
      "distanceMeters" : 201.30196223338135,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 74.6091239452362,
      "elapsedDurationSeconds" : 74.6091239452362,
      "endOffsetSeconds" : 1700.3753020763397,
      "index" : 9,
      "label" : "Recovery 4",
      "maxHeartRateBpm" : 158,
      "paceSecondsPerKm" : 370.6328697319771,
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +0.5s, overshoot 1.3 m",
      "startOffsetSeconds" : 1625.7661781311035,
      "stepType" : "recovery"
    },
    {
      "averageHeartRateBpm" : 134.2,
      "averagePower" : 90.75,
      "confidence" : "medium",
      "displayDurationSeconds" : 418.7882670164108,
      "distanceMeters" : 544.4839926243294,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 418.7882670164108,
      "elapsedDurationSeconds" : 418.7882670164108,
      "endOffsetSeconds" : 2119.1635690927505,
      "index" : 10,
      "label" : "Cooldown",
      "maxHeartRateBpm" : 160,
      "paceSecondsPerKm" : 769.1470689485571,
      "plannedGoalDisplayText" : "Open",
      "plannedGoalType" : "open",
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Planned open cooldown extended to workout end",
      "startOffsetSeconds" : 1700.3753020763397,
      "stepType" : "cooldown"
    }
  ],
  "reviewPacket" : {
    "externalEvidencePolicy" : "External HealthFit\/FIT archives are offline validation evidence only. Reference or attach them separately; RunSignal does not import or use FIT as runtime truth.",
    "fitArchiveReference" : "external-reference-only",
    "includedArtifacts" : [
      "Raw HealthKit Debug",
      "WorkoutKit plan audit",
      "HealthKit workout activities",
      "Parity Lab candidate rows",
      "structured comparison summary",
      "fallback reason labels",
      "pause and tail diagnostics",
      "source metadata",
      "boundary source warnings",
      "blocked interval guardrails"
    ],
    "normalWorkoutUIChanged" : false,
    "scope" : "debug\/export-only",
    "usesFITRuntimeTruth" : false
  },
  "segmentMarkers" : [
    {
      "averageHeartRateBpm" : 144.62820512820514,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1007.2479046507289,
      "durationSeconds" : 394.09315156936646,
      "endOffsetSeconds" : 394.09315156936646,
      "index" : 1,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 391.25735556235423,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 147.24,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1616.1982395498335,
      "durationSeconds" : 628.6849510669708,
      "endOffsetSeconds" : 628.6849510669708,
      "index" : 2,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 388.9899986786776,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 152.37662337662337,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 998.7030518333294,
      "durationSeconds" : 384.41568064689636,
      "endOffsetSeconds" : 778.5088322162628,
      "index" : 3,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 384.914895314699,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 394.09315156936646
    },
    {
      "averageHeartRateBpm" : 152.53225806451613,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1609.4281180591456,
      "durationSeconds" : 619.3306291103363,
      "endOffsetSeconds" : 1248.0155801773071,
      "index" : 4,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 384.8140977288283,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 628.6849510669708
    },
    {
      "averageHeartRateBpm" : 151.96103896103895,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1001.7823544843268,
      "durationSeconds" : 386.6718534231186,
      "endOffsetSeconds" : 1165.1806856393814,
      "index" : 5,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 385.9838933000174,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 778.5088322162628
    },
    {
      "averageHeartRateBpm" : 154.01298701298703,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 999.4287956788139,
      "durationSeconds" : 383.3239310979843,
      "endOffsetSeconds" : 1548.5046167373657,
      "index" : 6,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 383.5430125240988,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1165.1806856393814
    },
    {
      "averageHeartRateBpm" : 148.19463087248323,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1606.1756145284567,
      "durationSeconds" : 746.3821996450424,
      "endOffsetSeconds" : 1994.3977798223495,
      "index" : 7,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 464.6952630171554,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1248.0155801773071
    },
    {
      "averageHeartRateBpm" : 140.1818181818182,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 945.9011766006743,
      "durationSeconds" : 570.6589523553848,
      "endOffsetSeconds" : 2119.1635690927505,
      "index" : 8,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 603.2965879228382,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1548.5046167373657
    },
    {
      "averageHeartRateBpm" : 123.52380952380952,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 121.26131111043742,
      "durationSeconds" : 124.765789270401,
      "endOffsetSeconds" : 2119.1635690927505,
      "index" : 9,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 1028.9002166302814,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1994.3977798223495
    }
  ],
  "sourceNotes" : [
    "Plan source: WorkoutKit",
    "Window source: Plan-derived from HealthKit distance\/time samples",
    "Stats source: HealthKit samples",
    "HealthKit segment markers: not used"
  ],
  "workout" : {
    "averageHeartRate" : 147.31069994819995,
    "averagePower" : 168.60470879801733,
    "cadenceSpm" : 162.50345705466412,
    "deviceName" : "Apple Watch Apple Inc. Watch",
    "distanceMeters" : 4952.565083773169,
    "durationSeconds" : 2119.1635690927505,
    "elapsedSeconds" : 2119.1635690927505,
    "endDate" : "2026-06-28T14:02:52Z",
    "id" : "8B07CF82-0778-4A83-B862-486275CCA923",
    "maxHeartRate" : 160,
    "paceSecondsPerKm" : 427.8921191840737,
    "sourceID" : "8B07CF82-0778-4A83-B862-486275CCA923",
    "sourceName" : "Adriel’s Apple Watch",
    "startDate" : "2026-06-28T13:27:33Z"
  },
  "workoutActivities" : [
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 776.7699873447418,
      "durationSeconds" : 781.3651436567307,
      "endDate" : "2026-06-28T13:40:34Z",
      "endOffsetSeconds" : 781.3651436567307,
      "events" : [
        {
          "durationSeconds" : 394.09315156936646,
          "endDate" : "2026-06-28T13:34:07Z",
          "endOffsetSeconds" : 394.09315156936646,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1007.2479046507289,
          "renderedSegmentMarkerDurationSeconds" : 394.09315156936646,
          "renderedSegmentMarkerEndOffsetSeconds" : 394.09315156936646,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:27:33Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 628.6849510669708,
          "endDate" : "2026-06-28T13:38:02Z",
          "endOffsetSeconds" : 628.6849510669708,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1616.1982395498335,
          "renderedSegmentMarkerDurationSeconds" : 628.6849510669708,
          "renderedSegmentMarkerEndOffsetSeconds" : 628.6849510669708,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:27:33Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 384.41568064689636,
          "endDate" : "2026-06-28T13:40:32Z",
          "endOffsetSeconds" : 778.5088322162628,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 998.7030518333294,
          "renderedSegmentMarkerDurationSeconds" : 384.41568064689636,
          "renderedSegmentMarkerEndOffsetSeconds" : 778.5088322162628,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 394.09315156936646,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:34:07Z",
          "startOffsetSeconds" : 394.09315156936646,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 619.3306291103363,
          "endDate" : "2026-06-28T13:48:21Z",
          "endOffsetSeconds" : 1248.0155801773071,
          "index" : 4,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1609.4281180591456,
          "renderedSegmentMarkerDurationSeconds" : 619.3306291103363,
          "renderedSegmentMarkerEndOffsetSeconds" : 1248.0155801773071,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 628.6849510669708,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:38:02Z",
          "startOffsetSeconds" : 628.6849510669708,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 386.6718534231186,
          "endDate" : "2026-06-28T13:46:58Z",
          "endOffsetSeconds" : 1165.1806856393814,
          "index" : 5,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1001.7823544843268,
          "renderedSegmentMarkerDurationSeconds" : 386.6718534231186,
          "renderedSegmentMarkerEndOffsetSeconds" : 1165.1806856393814,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 778.5088322162628,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:40:32Z",
          "startOffsetSeconds" : 778.5088322162628,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "5 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "7A055E04-DCC6-472B-AADD-F71530D797FA",
      "index" : 1,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -2.8563114404678345,
      "nearestRawEventEndOffsetSeconds" : 778.5088322162628,
      "nearestRawEventStartDeltaSeconds" : 0,
      "nearestRawEventStartOffsetSeconds" : 0,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -4.595156311988831,
      "nearestReconstructedIntervalEndOffsetSeconds" : 776.7699873447418,
      "nearestReconstructedIntervalIndex" : 1,
      "nearestReconstructedIntervalLabel" : "Warmup",
      "nearestSegmentMarkerEndDeltaSeconds" : -2.8563114404678345,
      "nearestSegmentMarkerEndOffsetSeconds" : 778.5088322162628,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : 0,
      "nearestSegmentMarkerStartOffsetSeconds" : 0,
      "nextDistanceSampleEndOffsetSeconds" : 779.3426913022995,
      "previousDistanceSampleEndOffsetSeconds" : 774.1972812414169,
      "startDate" : "2026-06-28T13:27:33Z",
      "startOffsetSeconds" : 0,
      "statistics" : [
        {
          "endDate" : "2026-06-28T13:40:34Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:27:33Z",
          "sum" : 146.27226464868318,
          "summary" : "ActiveEnergyBurned: sum 146.3 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:40:34Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:27:33Z",
          "sum" : 19.13397378564179,
          "summary" : "BasalEnergyBurned: sum 19.1 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:40:34Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:27:33Z",
          "sum" : 2006.5606011425712,
          "summary" : "DistanceWalkingRunning: sum 2006.6 m",
          "unit" : "m"
        },
        {
          "average" : 147.9066298469439,
          "endDate" : "2026-06-28T13:40:34Z",
          "maximum" : 156,
          "minimum" : 117,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:27:33Z",
          "summary" : "HeartRate: avg 147.9 bpm, min 117.0 bpm, max 156.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 285.64137931034486,
          "endDate" : "2026-06-28T13:40:34Z",
          "maximum" : 310,
          "minimum" : 264,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:27:33Z",
          "summary" : "RunningGroundContactTime: avg 285.6 ms, min 264.0 ms, max 310.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 183.74834437086076,
          "endDate" : "2026-06-28T13:40:34Z",
          "maximum" : 200,
          "minimum" : 92,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:27:33Z",
          "summary" : "RunningPower: avg 183.7 W, min 92.0 W, max 200.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.595405914803782,
          "endDate" : "2026-06-28T13:40:34Z",
          "maximum" : 2.7999429742706394,
          "minimum" : 1.2390471565538814,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:27:33Z",
          "summary" : "RunningSpeed: avg 2.6 m\/s, min 1.2 m\/s, max 2.8 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.8865517241379313,
          "endDate" : "2026-06-28T13:40:34Z",
          "maximum" : 0.95,
          "minimum" : 0.79,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:27:33Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.8 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 6.985616438356167,
          "endDate" : "2026-06-28T13:40:34Z",
          "maximum" : 8.3,
          "minimum" : 6.5,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:27:33Z",
          "summary" : "RunningVerticalOscillation: avg 7.0 cm, min 6.5 cm, max 8.3 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T13:40:34Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:27:33Z",
          "sum" : 2268.502831857349,
          "summary" : "StepCount: sum 2268.5 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 146.3 kcal; BasalEnergyBurned: sum 19.1 kcal; DistanceWalkingRunning: sum 2006.6 m; HeartRate: avg 147.9 bpm, min 117.0 bpm, max 156.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 933.7055633068085,
      "durationSeconds" : 156.6173858642578,
      "endDate" : "2026-06-28T13:43:11Z",
      "endOffsetSeconds" : 937.9825295209885,
      "events" : [
        {
          "durationSeconds" : 619.3306291103363,
          "endDate" : "2026-06-28T13:48:21Z",
          "endOffsetSeconds" : 1248.0155801773071,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1609.4281180591456,
          "renderedSegmentMarkerDurationSeconds" : 619.3306291103363,
          "renderedSegmentMarkerEndOffsetSeconds" : 1248.0155801773071,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 628.6849510669708,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:38:02Z",
          "startOffsetSeconds" : 628.6849510669708,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 386.6718534231186,
          "endDate" : "2026-06-28T13:46:58Z",
          "endOffsetSeconds" : 1165.1806856393814,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1001.7823544843268,
          "renderedSegmentMarkerDurationSeconds" : 386.6718534231186,
          "renderedSegmentMarkerEndOffsetSeconds" : 1165.1806856393814,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 778.5088322162628,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:40:32Z",
          "startOffsetSeconds" : 778.5088322162628,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "2 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "5C8E2E8C-B7BD-4FD7-B600-B20073828936",
      "index" : 2,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -159.47369730472565,
      "nearestRawEventEndOffsetSeconds" : 778.5088322162628,
      "nearestRawEventStartDeltaSeconds" : -2.8563114404678345,
      "nearestRawEventStartOffsetSeconds" : 778.5088322162628,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -4.276966214179993,
      "nearestReconstructedIntervalEndOffsetSeconds" : 933.7055633068085,
      "nearestReconstructedIntervalIndex" : 2,
      "nearestReconstructedIntervalLabel" : "Work 1",
      "nearestSegmentMarkerEndDeltaSeconds" : -159.47369730472565,
      "nearestSegmentMarkerEndOffsetSeconds" : 778.5088322162628,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -2.8563114404678345,
      "nearestSegmentMarkerStartOffsetSeconds" : 778.5088322162628,
      "nextDistanceSampleEndOffsetSeconds" : 936.2782797813416,
      "previousDistanceSampleEndOffsetSeconds" : 931.132847070694,
      "startDate" : "2026-06-28T13:40:34Z",
      "startOffsetSeconds" : 781.3651436567307,
      "statistics" : [
        {
          "endDate" : "2026-06-28T13:43:11Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:40:34Z",
          "sum" : 30.48890571316345,
          "summary" : "ActiveEnergyBurned: sum 30.5 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:43:11Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:40:34Z",
          "sum" : 3.8352077255447776,
          "summary" : "BasalEnergyBurned: sum 3.8 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:43:11Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:40:34Z",
          "sum" : 400.9813783508975,
          "summary" : "DistanceWalkingRunning: sum 401.0 m",
          "unit" : "m"
        },
        {
          "average" : 152.2636815920398,
          "endDate" : "2026-06-28T13:43:11Z",
          "maximum" : 155,
          "minimum" : 148,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:40:34Z",
          "summary" : "HeartRate: avg 152.3 bpm, min 148.0 bpm, max 155.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 284.5714285714286,
          "endDate" : "2026-06-28T13:43:11Z",
          "maximum" : 293,
          "minimum" : 269,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:40:34Z",
          "summary" : "RunningGroundContactTime: avg 284.6 ms, min 269.0 ms, max 293.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 184.62295081967216,
          "endDate" : "2026-06-28T13:43:11Z",
          "maximum" : 192,
          "minimum" : 178,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:40:34Z",
          "summary" : "RunningPower: avg 184.6 W, min 178.0 W, max 192.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.5903358309940665,
          "endDate" : "2026-06-28T13:43:11Z",
          "maximum" : 2.689793130679991,
          "minimum" : 2.5052294108833366,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:40:34Z",
          "summary" : "RunningSpeed: avg 2.6 m\/s, min 2.5 m\/s, max 2.7 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.8842857142857142,
          "endDate" : "2026-06-28T13:43:11Z",
          "maximum" : 0.9,
          "minimum" : 0.86,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:40:34Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 6.97241379310345,
          "endDate" : "2026-06-28T13:43:11Z",
          "maximum" : 7.3999999999999995,
          "minimum" : 6.7,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:40:34Z",
          "summary" : "RunningVerticalOscillation: avg 7.0 cm, min 6.7 cm, max 7.4 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T13:43:11Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:40:34Z",
          "sum" : 454.79662395925243,
          "summary" : "StepCount: sum 454.8 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 30.5 kcal; BasalEnergyBurned: sum 3.8 kcal; DistanceWalkingRunning: sum 401.0 m; HeartRate: avg 152.3 bpm, min 148.0 bpm, max 155.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1013.4594565629959,
      "durationSeconds" : 78.37372076511383,
      "endDate" : "2026-06-28T13:44:29Z",
      "endOffsetSeconds" : 1016.3562502861023,
      "events" : [
        {
          "durationSeconds" : 619.3306291103363,
          "endDate" : "2026-06-28T13:48:21Z",
          "endOffsetSeconds" : 1248.0155801773071,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1609.4281180591456,
          "renderedSegmentMarkerDurationSeconds" : 619.3306291103363,
          "renderedSegmentMarkerEndOffsetSeconds" : 1248.0155801773071,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 628.6849510669708,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:38:02Z",
          "startOffsetSeconds" : 628.6849510669708,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 386.6718534231186,
          "endDate" : "2026-06-28T13:46:58Z",
          "endOffsetSeconds" : 1165.1806856393814,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1001.7823544843268,
          "renderedSegmentMarkerDurationSeconds" : 386.6718534231186,
          "renderedSegmentMarkerEndOffsetSeconds" : 1165.1806856393814,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 778.5088322162628,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:40:32Z",
          "startOffsetSeconds" : 778.5088322162628,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "2 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "9857AB5F-4E27-4674-A3AB-4E7EB7821759",
      "index" : 3,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : 148.8244353532791,
      "nearestRawEventEndOffsetSeconds" : 1165.1806856393814,
      "nearestRawEventStartDeltaSeconds" : -159.47369730472565,
      "nearestRawEventStartOffsetSeconds" : 778.5088322162628,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -4.296896457672119,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1012.0593538284302,
      "nearestReconstructedIntervalIndex" : 3,
      "nearestReconstructedIntervalLabel" : "Recovery 1",
      "nearestSegmentMarkerEndDeltaSeconds" : 148.8244353532791,
      "nearestSegmentMarkerEndOffsetSeconds" : 1165.1806856393814,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -159.47369730472565,
      "nearestSegmentMarkerStartOffsetSeconds" : 778.5088322162628,
      "nextDistanceSampleEndOffsetSeconds" : 1016.0321459770203,
      "previousDistanceSampleEndOffsetSeconds" : 1010.8867678642273,
      "startDate" : "2026-06-28T13:43:11Z",
      "startOffsetSeconds" : 937.9825295209885,
      "statistics" : [
        {
          "endDate" : "2026-06-28T13:44:29Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:43:11Z",
          "sum" : 15.118105503117873,
          "summary" : "ActiveEnergyBurned: sum 15.1 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:44:29Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:43:11Z",
          "sum" : 1.9192034622993994,
          "summary" : "BasalEnergyBurned: sum 1.9 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:44:29Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:43:11Z",
          "sum" : 200.16539026583965,
          "summary" : "DistanceWalkingRunning: sum 200.2 m",
          "unit" : "m"
        },
        {
          "average" : 150.7212389380531,
          "endDate" : "2026-06-28T13:44:29Z",
          "maximum" : 154,
          "minimum" : 149,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:43:11Z",
          "summary" : "HeartRate: avg 150.7 bpm, min 149.0 bpm, max 154.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 285.1333333333333,
          "endDate" : "2026-06-28T13:44:29Z",
          "maximum" : 293,
          "minimum" : 280,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:43:11Z",
          "summary" : "RunningGroundContactTime: avg 285.1 ms, min 280.0 ms, max 293.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 185.93548387096772,
          "endDate" : "2026-06-28T13:44:29Z",
          "maximum" : 189,
          "minimum" : 182,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:43:11Z",
          "summary" : "RunningPower: avg 185.9 W, min 182.0 W, max 189.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.602969193252761,
          "endDate" : "2026-06-28T13:44:29Z",
          "maximum" : 2.6405358194573285,
          "minimum" : 2.5483575710622652,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:43:11Z",
          "summary" : "RunningSpeed: avg 2.6 m\/s, min 2.5 m\/s, max 2.6 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.8946666666666666,
          "endDate" : "2026-06-28T13:44:29Z",
          "maximum" : 0.94,
          "minimum" : 0.88,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:43:11Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 6.953333333333334,
          "endDate" : "2026-06-28T13:44:29Z",
          "maximum" : 7.5,
          "minimum" : 6.7,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:43:11Z",
          "summary" : "RunningVerticalOscillation: avg 7.0 cm, min 6.7 cm, max 7.5 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T13:44:29Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:43:11Z",
          "sum" : 225.70837588771,
          "summary" : "StepCount: sum 225.7 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 15.1 kcal; BasalEnergyBurned: sum 1.9 kcal; DistanceWalkingRunning: sum 200.2 m; HeartRate: avg 150.7 bpm, min 149.0 bpm, max 154.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1165.2480442523956,
      "durationSeconds" : 151.801367521286,
      "endDate" : "2026-06-28T13:47:01Z",
      "endOffsetSeconds" : 1168.1576178073883,
      "events" : [
        {
          "durationSeconds" : 619.3306291103363,
          "endDate" : "2026-06-28T13:48:21Z",
          "endOffsetSeconds" : 1248.0155801773071,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1609.4281180591456,
          "renderedSegmentMarkerDurationSeconds" : 619.3306291103363,
          "renderedSegmentMarkerEndOffsetSeconds" : 1248.0155801773071,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 628.6849510669708,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:38:02Z",
          "startOffsetSeconds" : 628.6849510669708,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 386.6718534231186,
          "endDate" : "2026-06-28T13:46:58Z",
          "endOffsetSeconds" : 1165.1806856393814,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1001.7823544843268,
          "renderedSegmentMarkerDurationSeconds" : 386.6718534231186,
          "renderedSegmentMarkerEndOffsetSeconds" : 1165.1806856393814,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 778.5088322162628,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:40:32Z",
          "startOffsetSeconds" : 778.5088322162628,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 383.3239310979843,
          "endDate" : "2026-06-28T13:53:22Z",
          "endOffsetSeconds" : 1548.5046167373657,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 999.4287956788139,
          "renderedSegmentMarkerDurationSeconds" : 383.3239310979843,
          "renderedSegmentMarkerEndOffsetSeconds" : 1548.5046167373657,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1165.1806856393814,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:46:58Z",
          "startOffsetSeconds" : 1165.1806856393814,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "3 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "48D23F84-0119-4EBA-8D3F-26460D51D44E",
      "index" : 4,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -2.976932168006897,
      "nearestRawEventEndOffsetSeconds" : 1165.1806856393814,
      "nearestRawEventStartDeltaSeconds" : 148.8244353532791,
      "nearestRawEventStartOffsetSeconds" : 1165.1806856393814,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -4.521806597709656,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1163.6358112096786,
      "nearestReconstructedIntervalIndex" : 4,
      "nearestReconstructedIntervalLabel" : "Work 2",
      "nearestSegmentMarkerEndDeltaSeconds" : -2.976932168006897,
      "nearestSegmentMarkerEndOffsetSeconds" : 1165.1806856393814,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : 148.8244353532791,
      "nearestSegmentMarkerStartOffsetSeconds" : 1165.1806856393814,
      "nextDistanceSampleEndOffsetSeconds" : 1167.8207392692566,
      "previousDistanceSampleEndOffsetSeconds" : 1162.6753495931625,
      "startDate" : "2026-06-28T13:44:29Z",
      "startOffsetSeconds" : 1016.3562502861023,
      "statistics" : [
        {
          "endDate" : "2026-06-28T13:47:01Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:44:29Z",
          "sum" : 29.50115986470291,
          "summary" : "ActiveEnergyBurned: sum 29.5 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:47:01Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:44:29Z",
          "sum" : 3.717312784797575,
          "summary" : "BasalEnergyBurned: sum 3.7 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:47:01Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:44:29Z",
          "sum" : 401.16246219600134,
          "summary" : "DistanceWalkingRunning: sum 401.2 m",
          "unit" : "m"
        },
        {
          "average" : 152.19430051813472,
          "endDate" : "2026-06-28T13:47:01Z",
          "maximum" : 155,
          "minimum" : 148,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:44:29Z",
          "summary" : "HeartRate: avg 152.2 bpm, min 148.0 bpm, max 155.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 282.5185185185186,
          "endDate" : "2026-06-28T13:47:01Z",
          "maximum" : 289,
          "minimum" : 273,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:44:29Z",
          "summary" : "RunningGroundContactTime: avg 282.5 ms, min 273.0 ms, max 289.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 187.00000000000003,
          "endDate" : "2026-06-28T13:47:01Z",
          "maximum" : 195,
          "minimum" : 179,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:44:29Z",
          "summary" : "RunningPower: avg 187.0 W, min 179.0 W, max 195.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.646471700239275,
          "endDate" : "2026-06-28T13:47:01Z",
          "maximum" : 2.7565081015479955,
          "minimum" : 2.530197769239116,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:44:29Z",
          "summary" : "RunningSpeed: avg 2.6 m\/s, min 2.5 m\/s, max 2.8 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.904814814814815,
          "endDate" : "2026-06-28T13:47:01Z",
          "maximum" : 0.94,
          "minimum" : 0.87,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:44:29Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 7.014814814814815,
          "endDate" : "2026-06-28T13:47:01Z",
          "maximum" : 7.6,
          "minimum" : 6.7,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:44:29Z",
          "summary" : "RunningVerticalOscillation: avg 7.0 cm, min 6.7 cm, max 7.6 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T13:47:01Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:44:29Z",
          "sum" : 439.9087751035173,
          "summary" : "StepCount: sum 439.9 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 29.5 kcal; BasalEnergyBurned: sum 3.7 kcal; DistanceWalkingRunning: sum 401.2 m; HeartRate: avg 152.2 bpm, min 148.0 bpm, max 155.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 5,
      "alignedPlannedStepLabel" : "Recovery 2",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1239.8565549850464,
      "durationSeconds" : 73.19225466251373,
      "endDate" : "2026-06-28T13:48:14Z",
      "endOffsetSeconds" : 1241.349872469902,
      "events" : [
        {
          "durationSeconds" : 619.3306291103363,
          "endDate" : "2026-06-28T13:48:21Z",
          "endOffsetSeconds" : 1248.0155801773071,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1609.4281180591456,
          "renderedSegmentMarkerDurationSeconds" : 619.3306291103363,
          "renderedSegmentMarkerEndOffsetSeconds" : 1248.0155801773071,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 628.6849510669708,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:38:02Z",
          "startOffsetSeconds" : 628.6849510669708,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 383.3239310979843,
          "endDate" : "2026-06-28T13:53:22Z",
          "endOffsetSeconds" : 1548.5046167373657,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 999.4287956788139,
          "renderedSegmentMarkerDurationSeconds" : 383.3239310979843,
          "renderedSegmentMarkerEndOffsetSeconds" : 1548.5046167373657,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1165.1806856393814,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:46:58Z",
          "startOffsetSeconds" : 1165.1806856393814,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "2 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "A41C0377-1E71-41AF-B26B-FA8A2C452A06",
      "index" : 5,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : 6.66570770740509,
      "nearestRawEventEndOffsetSeconds" : 1248.0155801773071,
      "nearestRawEventStartDeltaSeconds" : -2.976932168006897,
      "nearestRawEventStartOffsetSeconds" : 1165.1806856393814,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -1.4933174848556519,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1239.8565549850464,
      "nearestReconstructedIntervalIndex" : 5,
      "nearestReconstructedIntervalLabel" : "Recovery 2",
      "nearestSegmentMarkerEndDeltaSeconds" : 6.66570770740509,
      "nearestSegmentMarkerEndOffsetSeconds" : 1248.0155801773071,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -2.976932168006897,
      "nearestSegmentMarkerStartOffsetSeconds" : 1165.1806856393814,
      "nextDistanceSampleEndOffsetSeconds" : 1242.4292719364166,
      "previousDistanceSampleEndOffsetSeconds" : 1237.2838398218155,
      "startDate" : "2026-06-28T13:47:01Z",
      "startOffsetSeconds" : 1168.1576178073883,
      "statistics" : [
        {
          "endDate" : "2026-06-28T13:48:14Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:47:01Z",
          "sum" : 14.362702408362003,
          "summary" : "ActiveEnergyBurned: sum 14.4 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:48:14Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:47:01Z",
          "sum" : 1.7923184948400548,
          "summary" : "BasalEnergyBurned: sum 1.8 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:48:14Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:47:01Z",
          "sum" : 192.56169746480634,
          "summary" : "DistanceWalkingRunning: sum 192.6 m",
          "unit" : "m"
        },
        {
          "average" : 153.40990990990994,
          "endDate" : "2026-06-28T13:48:14Z",
          "maximum" : 156,
          "minimum" : 152,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:47:01Z",
          "summary" : "HeartRate: avg 153.4 bpm, min 152.0 bpm, max 156.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 284.7692307692308,
          "endDate" : "2026-06-28T13:48:14Z",
          "maximum" : 297,
          "minimum" : 273,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:47:01Z",
          "summary" : "RunningGroundContactTime: avg 284.8 ms, min 273.0 ms, max 297.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 187.71428571428572,
          "endDate" : "2026-06-28T13:48:14Z",
          "maximum" : 191,
          "minimum" : 183,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:47:01Z",
          "summary" : "RunningPower: avg 187.7 W, min 183.0 W, max 191.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.6514869754674746,
          "endDate" : "2026-06-28T13:48:14Z",
          "maximum" : 2.6974251568205325,
          "minimum" : 2.5939935991348757,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:47:01Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 2.6 m\/s, max 2.7 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9092307692307694,
          "endDate" : "2026-06-28T13:48:14Z",
          "maximum" : 0.92,
          "minimum" : 0.9,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:47:01Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 7.1230769230769235,
          "endDate" : "2026-06-28T13:48:14Z",
          "maximum" : 7.9,
          "minimum" : 6.800000000000001,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:47:01Z",
          "summary" : "RunningVerticalOscillation: avg 7.1 cm, min 6.8 cm, max 7.9 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T13:48:14Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:47:01Z",
          "sum" : 210.14649946914508,
          "summary" : "StepCount: sum 210.1 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 14.4 kcal; BasalEnergyBurned: sum 1.8 kcal; DistanceWalkingRunning: sum 192.6 m; HeartRate: avg 153.4 bpm, min 152.0 bpm, max 156.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1399.3653082847595,
      "durationSeconds" : 160.14925742149353,
      "endDate" : "2026-06-28T13:50:55Z",
      "endOffsetSeconds" : 1401.4991298913956,
      "events" : [
        {
          "durationSeconds" : 619.3306291103363,
          "endDate" : "2026-06-28T13:48:21Z",
          "endOffsetSeconds" : 1248.0155801773071,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1609.4281180591456,
          "renderedSegmentMarkerDurationSeconds" : 619.3306291103363,
          "renderedSegmentMarkerEndOffsetSeconds" : 1248.0155801773071,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 628.6849510669708,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:38:02Z",
          "startOffsetSeconds" : 628.6849510669708,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 383.3239310979843,
          "endDate" : "2026-06-28T13:53:22Z",
          "endOffsetSeconds" : 1548.5046167373657,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 999.4287956788139,
          "renderedSegmentMarkerDurationSeconds" : 383.3239310979843,
          "renderedSegmentMarkerEndOffsetSeconds" : 1548.5046167373657,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1165.1806856393814,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:46:58Z",
          "startOffsetSeconds" : 1165.1806856393814,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 746.3821996450424,
          "endDate" : "2026-06-28T14:00:47Z",
          "endOffsetSeconds" : 1994.3977798223495,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1606.1756145284567,
          "renderedSegmentMarkerDurationSeconds" : 746.3821996450424,
          "renderedSegmentMarkerEndOffsetSeconds" : 1994.3977798223495,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1248.0155801773071,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:48:21Z",
          "startOffsetSeconds" : 1248.0155801773071,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "3 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "99BC9A8D-ECA6-4193-BE34-E5B50BA5BE71",
      "index" : 6,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : 147.00548684597015,
      "nearestRawEventEndOffsetSeconds" : 1548.5046167373657,
      "nearestRawEventStartDeltaSeconds" : 6.66570770740509,
      "nearestRawEventStartOffsetSeconds" : 1248.0155801773071,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -4.163698315620422,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1397.3354315757751,
      "nearestReconstructedIntervalIndex" : 6,
      "nearestReconstructedIntervalLabel" : "Work 3",
      "nearestSegmentMarkerEndDeltaSeconds" : 147.00548684597015,
      "nearestSegmentMarkerEndOffsetSeconds" : 1548.5046167373657,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : 6.66570770740509,
      "nearestSegmentMarkerStartOffsetSeconds" : 1248.0155801773071,
      "nextDistanceSampleEndOffsetSeconds" : 1401.9380388259888,
      "previousDistanceSampleEndOffsetSeconds" : 1396.7925775051117,
      "startDate" : "2026-06-28T13:48:14Z",
      "startOffsetSeconds" : 1241.349872469902,
      "statistics" : [
        {
          "endDate" : "2026-06-28T13:50:55Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:48:14Z",
          "sum" : 31.27257768129941,
          "summary" : "ActiveEnergyBurned: sum 31.3 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:50:55Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:48:14Z",
          "sum" : 3.921684214045431,
          "summary" : "BasalEnergyBurned: sum 3.9 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:50:55Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:48:14Z",
          "sum" : 406.69700443798337,
          "summary" : "DistanceWalkingRunning: sum 406.7 m",
          "unit" : "m"
        },
        {
          "average" : 153.1938775510204,
          "endDate" : "2026-06-28T13:50:55Z",
          "maximum" : 156,
          "minimum" : 146,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:48:14Z",
          "summary" : "HeartRate: avg 153.2 bpm, min 146.0 bpm, max 156.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 280.46428571428567,
          "endDate" : "2026-06-28T13:50:55Z",
          "maximum" : 303,
          "minimum" : 271,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:48:14Z",
          "summary" : "RunningGroundContactTime: avg 280.5 ms, min 271.0 ms, max 303.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 184.75806451612905,
          "endDate" : "2026-06-28T13:50:55Z",
          "maximum" : 198,
          "minimum" : 157,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:48:14Z",
          "summary" : "RunningPower: avg 184.8 W, min 157.0 W, max 198.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.5999068299421477,
          "endDate" : "2026-06-28T13:50:55Z",
          "maximum" : 2.782978444055829,
          "minimum" : 2.1777956336202524,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:48:14Z",
          "summary" : "RunningSpeed: avg 2.6 m\/s, min 2.2 m\/s, max 2.8 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.8903571428571427,
          "endDate" : "2026-06-28T13:50:55Z",
          "maximum" : 0.94,
          "minimum" : 0.81,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:48:14Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.8 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 7.075862068965518,
          "endDate" : "2026-06-28T13:50:55Z",
          "maximum" : 7.6,
          "minimum" : 6.6000000000000005,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:48:14Z",
          "summary" : "RunningVerticalOscillation: avg 7.1 cm, min 6.6 cm, max 7.6 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T13:50:55Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:48:14Z",
          "sum" : 463.7426907185076,
          "summary" : "StepCount: sum 463.7 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 31.3 kcal; BasalEnergyBurned: sum 3.9 kcal; DistanceWalkingRunning: sum 406.7 m; HeartRate: avg 153.2 bpm, min 146.0 bpm, max 156.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1473.9747830629349,
      "durationSeconds" : 75.1772050857544,
      "endDate" : "2026-06-28T13:52:10Z",
      "endOffsetSeconds" : 1476.67633497715,
      "events" : [
        {
          "durationSeconds" : 383.3239310979843,
          "endDate" : "2026-06-28T13:53:22Z",
          "endOffsetSeconds" : 1548.5046167373657,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 999.4287956788139,
          "renderedSegmentMarkerDurationSeconds" : 383.3239310979843,
          "renderedSegmentMarkerEndOffsetSeconds" : 1548.5046167373657,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1165.1806856393814,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:46:58Z",
          "startOffsetSeconds" : 1165.1806856393814,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 746.3821996450424,
          "endDate" : "2026-06-28T14:00:47Z",
          "endOffsetSeconds" : 1994.3977798223495,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1606.1756145284567,
          "renderedSegmentMarkerDurationSeconds" : 746.3821996450424,
          "renderedSegmentMarkerEndOffsetSeconds" : 1994.3977798223495,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1248.0155801773071,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:48:21Z",
          "startOffsetSeconds" : 1248.0155801773071,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "2 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "4E1F5B49-9446-4BD3-BF08-B45F14ADAD4E",
      "index" : 7,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : 71.82828176021576,
      "nearestRawEventEndOffsetSeconds" : 1548.5046167373657,
      "nearestRawEventStartDeltaSeconds" : 147.00548684597015,
      "nearestRawEventStartOffsetSeconds" : 1548.5046167373657,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -3.74971342086792,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1472.926621556282,
      "nearestReconstructedIntervalIndex" : 7,
      "nearestReconstructedIntervalLabel" : "Recovery 3",
      "nearestSegmentMarkerEndDeltaSeconds" : 71.82828176021576,
      "nearestSegmentMarkerEndOffsetSeconds" : 1548.5046167373657,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : 147.00548684597015,
      "nearestSegmentMarkerStartOffsetSeconds" : 1548.5046167373657,
      "nextDistanceSampleEndOffsetSeconds" : 1476.5475208759308,
      "previousDistanceSampleEndOffsetSeconds" : 1471.4020429849625,
      "startDate" : "2026-06-28T13:50:55Z",
      "startOffsetSeconds" : 1401.4991298913956,
      "statistics" : [
        {
          "endDate" : "2026-06-28T13:52:10Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:50:55Z",
          "sum" : 14.851635377499157,
          "summary" : "ActiveEnergyBurned: sum 14.9 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:52:10Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:50:55Z",
          "sum" : 1.8409021620419102,
          "summary" : "BasalEnergyBurned: sum 1.8 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:52:10Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:50:55Z",
          "sum" : 199.48747433100573,
          "summary" : "DistanceWalkingRunning: sum 199.5 m",
          "unit" : "m"
        },
        {
          "average" : 154.49561403508775,
          "endDate" : "2026-06-28T13:52:10Z",
          "maximum" : 157,
          "minimum" : 152,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:50:55Z",
          "summary" : "HeartRate: avg 154.5 bpm, min 152.0 bpm, max 157.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 276.57142857142856,
          "endDate" : "2026-06-28T13:52:10Z",
          "maximum" : 283,
          "minimum" : 265,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:50:55Z",
          "summary" : "RunningGroundContactTime: avg 276.6 ms, min 265.0 ms, max 283.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 188.93333333333337,
          "endDate" : "2026-06-28T13:52:10Z",
          "maximum" : 197,
          "minimum" : 179,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:50:55Z",
          "summary" : "RunningPower: avg 188.9 W, min 179.0 W, max 197.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.677469999157175,
          "endDate" : "2026-06-28T13:52:10Z",
          "maximum" : 2.7763051234845313,
          "minimum" : 2.565281392918062,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:50:55Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 2.6 m\/s, max 2.8 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.8842857142857142,
          "endDate" : "2026-06-28T13:52:10Z",
          "maximum" : 0.93,
          "minimum" : 0.86,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:50:55Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 7.121428571428571,
          "endDate" : "2026-06-28T13:52:10Z",
          "maximum" : 7.3999999999999995,
          "minimum" : 6.9,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:50:55Z",
          "summary" : "RunningVerticalOscillation: avg 7.1 cm, min 6.9 cm, max 7.4 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T13:52:10Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:50:55Z",
          "sum" : 220.59475317342054,
          "summary" : "StepCount: sum 220.6 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 14.9 kcal; BasalEnergyBurned: sum 1.8 kcal; DistanceWalkingRunning: sum 199.5 m; HeartRate: avg 154.5 bpm, min 152.0 bpm, max 157.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 8,
      "alignedPlannedStepLabel" : "Work 4",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1625.7661781311035,
      "durationSeconds" : 151.57985281944275,
      "endDate" : "2026-06-28T13:54:41Z",
      "endOffsetSeconds" : 1628.2561877965927,
      "events" : [
        {
          "durationSeconds" : 383.3239310979843,
          "endDate" : "2026-06-28T13:53:22Z",
          "endOffsetSeconds" : 1548.5046167373657,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 999.4287956788139,
          "renderedSegmentMarkerDurationSeconds" : 383.3239310979843,
          "renderedSegmentMarkerEndOffsetSeconds" : 1548.5046167373657,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1165.1806856393814,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:46:58Z",
          "startOffsetSeconds" : 1165.1806856393814,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 746.3821996450424,
          "endDate" : "2026-06-28T14:00:47Z",
          "endOffsetSeconds" : 1994.3977798223495,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1606.1756145284567,
          "renderedSegmentMarkerDurationSeconds" : 746.3821996450424,
          "renderedSegmentMarkerEndOffsetSeconds" : 1994.3977798223495,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1248.0155801773071,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:48:21Z",
          "startOffsetSeconds" : 1248.0155801773071,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 570.6589523553848,
          "endDate" : "2026-06-28T14:02:52Z",
          "endOffsetSeconds" : 2119.1635690927505,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 945.9011766006743,
          "renderedSegmentMarkerDurationSeconds" : 570.6589523553848,
          "renderedSegmentMarkerEndOffsetSeconds" : 2119.1635690927505,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1548.5046167373657,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:53:22Z",
          "startOffsetSeconds" : 1548.5046167373657,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "3 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "EE76E355-26A2-42CA-915D-7F3BDD5F46F2",
      "index" : 8,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -79.75157105922699,
      "nearestRawEventEndOffsetSeconds" : 1548.5046167373657,
      "nearestRawEventStartDeltaSeconds" : 71.82828176021576,
      "nearestRawEventStartOffsetSeconds" : 1548.5046167373657,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -2.4900096654891968,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1625.7661781311035,
      "nearestReconstructedIntervalIndex" : 8,
      "nearestReconstructedIntervalLabel" : "Work 4",
      "nearestSegmentMarkerEndDeltaSeconds" : -79.75157105922699,
      "nearestSegmentMarkerEndOffsetSeconds" : 1548.5046167373657,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : 71.82828176021576,
      "nearestSegmentMarkerStartOffsetSeconds" : 1548.5046167373657,
      "nextDistanceSampleEndOffsetSeconds" : 1628.338897228241,
      "previousDistanceSampleEndOffsetSeconds" : 1623.1934596300125,
      "startDate" : "2026-06-28T13:52:10Z",
      "startOffsetSeconds" : 1476.67633497715,
      "statistics" : [
        {
          "endDate" : "2026-06-28T13:54:41Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:52:10Z",
          "sum" : 30.726072810411193,
          "summary" : "ActiveEnergyBurned: sum 30.7 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:54:41Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:52:10Z",
          "sum" : 3.711820302910344,
          "summary" : "BasalEnergyBurned: sum 3.7 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:54:41Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:52:10Z",
          "sum" : 399.46498203676595,
          "summary" : "DistanceWalkingRunning: sum 399.5 m",
          "unit" : "m"
        },
        {
          "average" : 156.54896907216494,
          "endDate" : "2026-06-28T13:54:41Z",
          "maximum" : 159,
          "minimum" : 154,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:52:10Z",
          "summary" : "HeartRate: avg 156.5 bpm, min 154.0 bpm, max 159.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 272.5769230769231,
          "endDate" : "2026-06-28T13:54:41Z",
          "maximum" : 287,
          "minimum" : 257,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:52:10Z",
          "summary" : "RunningGroundContactTime: avg 272.6 ms, min 257.0 ms, max 287.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 196.24137931034485,
          "endDate" : "2026-06-28T13:54:41Z",
          "maximum" : 207,
          "minimum" : 170,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:52:10Z",
          "summary" : "RunningPower: avg 196.2 W, min 170.0 W, max 207.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.7415883623300643,
          "endDate" : "2026-06-28T13:54:41Z",
          "maximum" : 2.9074266850719526,
          "minimum" : 2.3817233186455113,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:52:10Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 2.4 m\/s, max 2.9 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.921923076923077,
          "endDate" : "2026-06-28T13:54:41Z",
          "maximum" : 0.97,
          "minimum" : 0.89,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:52:10Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 1.0 m",
          "unit" : "m"
        },
        {
          "average" : 7.034615384615384,
          "endDate" : "2026-06-28T13:54:41Z",
          "maximum" : 7.3999999999999995,
          "minimum" : 6.5,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:52:10Z",
          "summary" : "RunningVerticalOscillation: avg 7.0 cm, min 6.5 cm, max 7.4 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T13:54:41Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:52:10Z",
          "sum" : 431.37440931960873,
          "summary" : "StepCount: sum 431.4 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 30.7 kcal; BasalEnergyBurned: sum 3.7 kcal; DistanceWalkingRunning: sum 399.5 m; HeartRate: avg 156.5 bpm, min 154.0 bpm, max 159.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 9,
      "alignedPlannedStepLabel" : "Recovery 4",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1700.3753020763397,
      "durationSeconds" : 74.45893740653992,
      "endDate" : "2026-06-28T13:55:56Z",
      "endOffsetSeconds" : 1702.7151252031326,
      "events" : [
        {
          "durationSeconds" : 746.3821996450424,
          "endDate" : "2026-06-28T14:00:47Z",
          "endOffsetSeconds" : 1994.3977798223495,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1606.1756145284567,
          "renderedSegmentMarkerDurationSeconds" : 746.3821996450424,
          "renderedSegmentMarkerEndOffsetSeconds" : 1994.3977798223495,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1248.0155801773071,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:48:21Z",
          "startOffsetSeconds" : 1248.0155801773071,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 570.6589523553848,
          "endDate" : "2026-06-28T14:02:52Z",
          "endOffsetSeconds" : 2119.1635690927505,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 945.9011766006743,
          "renderedSegmentMarkerDurationSeconds" : 570.6589523553848,
          "renderedSegmentMarkerEndOffsetSeconds" : 2119.1635690927505,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1548.5046167373657,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:53:22Z",
          "startOffsetSeconds" : 1548.5046167373657,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "2 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "1FFBB557-F220-4820-A78B-4F2272C58395",
      "index" : 9,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -154.2105084657669,
      "nearestRawEventEndOffsetSeconds" : 1548.5046167373657,
      "nearestRawEventStartDeltaSeconds" : -79.75157105922699,
      "nearestRawEventStartOffsetSeconds" : 1548.5046167373657,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -2.3398231267929077,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1700.3753020763397,
      "nearestReconstructedIntervalIndex" : 9,
      "nearestReconstructedIntervalLabel" : "Recovery 4",
      "nearestSegmentMarkerEndDeltaSeconds" : -154.2105084657669,
      "nearestSegmentMarkerEndOffsetSeconds" : 1548.5046167373657,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -79.75157105922699,
      "nearestSegmentMarkerStartOffsetSeconds" : 1548.5046167373657,
      "nextDistanceSampleEndOffsetSeconds" : 1702.9480328559875,
      "previousDistanceSampleEndOffsetSeconds" : 1697.8025727272034,
      "startDate" : "2026-06-28T13:54:41Z",
      "startOffsetSeconds" : 1628.2561877965927,
      "statistics" : [
        {
          "endDate" : "2026-06-28T13:55:56Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:54:41Z",
          "sum" : 14.906511696787902,
          "summary" : "ActiveEnergyBurned: sum 14.9 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:55:56Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:54:41Z",
          "sum" : 1.8233220152722633,
          "summary" : "BasalEnergyBurned: sum 1.8 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:55:56Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:54:41Z",
          "sum" : 200.9143884127897,
          "summary" : "DistanceWalkingRunning: sum 200.9 m",
          "unit" : "m"
        },
        {
          "average" : 155.9485981308411,
          "endDate" : "2026-06-28T13:55:56Z",
          "maximum" : 158,
          "minimum" : 151,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:54:41Z",
          "summary" : "HeartRate: avg 155.9 bpm, min 151.0 bpm, max 158.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 269.4615384615385,
          "endDate" : "2026-06-28T13:55:56Z",
          "maximum" : 275,
          "minimum" : 254,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:54:41Z",
          "summary" : "RunningGroundContactTime: avg 269.5 ms, min 254.0 ms, max 275.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 191.13793103448273,
          "endDate" : "2026-06-28T13:55:56Z",
          "maximum" : 241,
          "minimum" : 180,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:54:41Z",
          "summary" : "RunningPower: avg 191.1 W, min 180.0 W, max 241.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.7472473740085315,
          "endDate" : "2026-06-28T13:55:56Z",
          "maximum" : 3.482195446129799,
          "minimum" : 2.5638151234872906,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:54:41Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 2.6 m\/s, max 3.5 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9421428571428572,
          "endDate" : "2026-06-28T13:55:56Z",
          "maximum" : 1.11,
          "minimum" : 0.89,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:54:41Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 1.1 m",
          "unit" : "m"
        },
        {
          "average" : 7.092857142857142,
          "endDate" : "2026-06-28T13:55:56Z",
          "maximum" : 7.3999999999999995,
          "minimum" : 6.9,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:54:41Z",
          "summary" : "RunningVerticalOscillation: avg 7.1 cm, min 6.9 cm, max 7.4 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T13:55:56Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:54:41Z",
          "sum" : 215.59133504067904,
          "summary" : "StepCount: sum 215.6 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 14.9 kcal; BasalEnergyBurned: sum 1.8 kcal; DistanceWalkingRunning: sum 200.9 m; HeartRate: avg 155.9 bpm, min 151.0 bpm, max 158.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 10,
      "alignedPlannedStepLabel" : "Cooldown",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "durationSeconds" : 416.4484438896179,
      "endDate" : "2026-06-28T14:02:52Z",
      "endOffsetSeconds" : 2119.1635690927505,
      "events" : [
        {
          "durationSeconds" : 746.3821996450424,
          "endDate" : "2026-06-28T14:00:47Z",
          "endOffsetSeconds" : 1994.3977798223495,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1606.1756145284567,
          "renderedSegmentMarkerDurationSeconds" : 746.3821996450424,
          "renderedSegmentMarkerEndOffsetSeconds" : 1994.3977798223495,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1248.0155801773071,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:48:21Z",
          "startOffsetSeconds" : 1248.0155801773071,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 570.6589523553848,
          "endDate" : "2026-06-28T14:02:52Z",
          "endOffsetSeconds" : 2119.1635690927505,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 945.9011766006743,
          "renderedSegmentMarkerDurationSeconds" : 570.6589523553848,
          "renderedSegmentMarkerEndOffsetSeconds" : 2119.1635690927505,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1548.5046167373657,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:53:22Z",
          "startOffsetSeconds" : 1548.5046167373657,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 124.765789270401,
          "endDate" : "2026-06-28T14:02:52Z",
          "endOffsetSeconds" : 2119.1635690927505,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 121.26131111043742,
          "renderedSegmentMarkerDurationSeconds" : 124.765789270401,
          "renderedSegmentMarkerEndOffsetSeconds" : 2119.1635690927505,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1994.3977798223495,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T14:00:47Z",
          "startOffsetSeconds" : 1994.3977798223495,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 0,
          "endDate" : "2026-06-28T14:02:52Z",
          "endOffsetSeconds" : 2119.1635690927505,
          "excludedOrFilteredReason" : "zeroOrNegativeDuration",
          "index" : 4,
          "metadataKeys" : [

          ],
          "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
          "startDate" : "2026-06-28T14:02:52Z",
          "startOffsetSeconds" : 2119.1635690927505,
          "type" : "HKWorkoutEventType(rawValue: 1)",
          "usedBySegmentMarkerRendering" : false
        }
      ],
      "eventsSummary" : "4 event(s): HKWorkoutEventType(rawValue: 1), HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "A0BD1EFD-901F-4D45-A9D0-53AE2E47C9DB",
      "index" : 10,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath"
      ],
      "nearestRawEventEndDeltaSeconds" : 0,
      "nearestRawEventEndOffsetSeconds" : 2119.1635690927505,
      "nearestRawEventStartDeltaSeconds" : -154.2105084657669,
      "nearestRawEventStartOffsetSeconds" : 1548.5046167373657,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : 0,
      "nearestReconstructedIntervalEndOffsetSeconds" : 2119.1635690927505,
      "nearestReconstructedIntervalIndex" : 10,
      "nearestReconstructedIntervalLabel" : "Cooldown",
      "nearestSegmentMarkerEndDeltaSeconds" : 0,
      "nearestSegmentMarkerEndOffsetSeconds" : 2119.1635690927505,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -154.2105084657669,
      "nearestSegmentMarkerStartOffsetSeconds" : 1548.5046167373657,
      "startDate" : "2026-06-28T13:55:56Z",
      "startOffsetSeconds" : 1702.7151252031326,
      "statistics" : [
        {
          "endDate" : "2026-06-28T14:02:52Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:55:56Z",
          "sum" : 33.8309805570756,
          "summary" : "ActiveEnergyBurned: sum 33.8 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T14:02:52Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:55:56Z",
          "sum" : 10.148703349237298,
          "summary" : "BasalEnergyBurned: sum 10.1 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T14:02:52Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:55:56Z",
          "sum" : 544.5697051345086,
          "summary" : "DistanceWalkingRunning: sum 544.6 m",
          "unit" : "m"
        },
        {
          "average" : 134.38289072822366,
          "endDate" : "2026-06-28T14:02:52Z",
          "maximum" : 160,
          "minimum" : 104,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:55:56Z",
          "summary" : "HeartRate: avg 134.4 bpm, min 104.0 bpm, max 160.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 268.4285714285714,
          "endDate" : "2026-06-28T14:02:52Z",
          "maximum" : 275,
          "minimum" : 266,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:55:56Z",
          "summary" : "RunningGroundContactTime: avg 268.4 ms, min 266.0 ms, max 275.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 89.85714285714286,
          "endDate" : "2026-06-28T14:02:52Z",
          "maximum" : 197,
          "minimum" : 57,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:55:56Z",
          "summary" : "RunningPower: avg 89.9 W, min 57.0 W, max 197.0 W",
          "unit" : "W"
        },
        {
          "average" : 1.4739747350173638,
          "endDate" : "2026-06-28T14:02:52Z",
          "maximum" : 2.8263911437915286,
          "minimum" : 0.7946118480392091,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:55:56Z",
          "summary" : "RunningSpeed: avg 1.5 m\/s, min 0.8 m\/s, max 2.8 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.96,
          "endDate" : "2026-06-28T14:02:52Z",
          "maximum" : 0.98,
          "minimum" : 0.94,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:55:56Z",
          "summary" : "RunningStrideLength: avg 1.0 m, min 0.9 m, max 1.0 m",
          "unit" : "m"
        },
        {
          "average" : 7.6,
          "endDate" : "2026-06-28T14:02:52Z",
          "maximum" : 8.899999999999999,
          "minimum" : 6.9,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:55:56Z",
          "summary" : "RunningVerticalOscillation: avg 7.6 cm, min 6.9 cm, max 8.9 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T14:02:52Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:55:56Z",
          "sum" : 719.9552759672121,
          "summary" : "StepCount: sum 720.0 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 33.8 kcal; BasalEnergyBurned: sum 10.1 kcal; DistanceWalkingRunning: sum 544.6 m; HeartRate: avg 134.4 bpm, min 104.0 bpm, max 160.0 bpm"
    }
  ],
  "workoutKitPlanAudit" : {
    "displayName" : "Priority 3 (no pause, open cooldown)",
    "planID" : "106CC9CA-B6CB-424C-95A3-384E5861C7F5",
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
        "plannedGoalDisplayText" : "400 m",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 400,
        "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
        "repeatBlockIndex" : 1,
        "repeatIndex" : 1,
        "stepType" : "work"
      },
      {
        "index" : 3,
        "label" : "Recovery 1",
        "plannedGoalDisplayText" : "200 m",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 200,
        "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
        "repeatBlockIndex" : 1,
        "repeatIndex" : 1,
        "stepType" : "recovery"
      },
      {
        "index" : 4,
        "label" : "Work 2",
        "plannedGoalDisplayText" : "400 m",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 400,
        "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
        "repeatBlockIndex" : 1,
        "repeatIndex" : 2,
        "stepType" : "work"
      },
      {
        "index" : 5,
        "label" : "Recovery 2",
        "plannedGoalDisplayText" : "200 m",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 200,
        "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
        "repeatBlockIndex" : 1,
        "repeatIndex" : 2,
        "stepType" : "recovery"
      },
      {
        "index" : 6,
        "label" : "Work 3",
        "plannedGoalDisplayText" : "400 m",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 400,
        "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
        "repeatBlockIndex" : 1,
        "repeatIndex" : 3,
        "stepType" : "work"
      },
      {
        "index" : 7,
        "label" : "Recovery 3",
        "plannedGoalDisplayText" : "200 m",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 200,
        "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
        "repeatBlockIndex" : 1,
        "repeatIndex" : 3,
        "stepType" : "recovery"
      },
      {
        "index" : 8,
        "label" : "Work 4",
        "plannedGoalDisplayText" : "400 m",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 400,
        "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
        "repeatBlockIndex" : 1,
        "repeatIndex" : 4,
        "stepType" : "work"
      },
      {
        "index" : 9,
        "label" : "Recovery 4",
        "plannedGoalDisplayText" : "200 m",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 200,
        "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
        "repeatBlockIndex" : 1,
        "repeatIndex" : 4,
        "stepType" : "recovery"
      },
      {
        "index" : 10,
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
      "Block 1: 4x, 2 step(s)",
      "Block 1 step 1: Work - goal 400 m, alert pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "Block 1 step 2: Recovery - goal 200 m, alert pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "Cooldown: goal open, alert pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current"
    ]
  }
}
```