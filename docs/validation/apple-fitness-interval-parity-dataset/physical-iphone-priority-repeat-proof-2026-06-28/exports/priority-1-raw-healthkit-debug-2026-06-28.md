# RunSignal Raw HealthKit Debug Export

Generated: 2026-06-28T19:36:44Z

## Review Packet Scope

This packet bundles Raw HealthKit Debug, WorkoutKit plan audit, HealthKit activity rows, Parity Lab candidate rows, structured comparison, fallback labels, pause/tail diagnostics, source metadata, and boundary warnings. It is debug/export-only and does not approve normal workout detail behavior.

Whole-run stats remain usable when custom interval rows are blocked. External HealthFit/FIT archives stay offline validation evidence; attach or reference them separately and do not treat FIT as app input or runtime truth.

Blocked custom interval diagnostics are review aids only. A supported Parity Lab status, readable fallback label, or exported candidate row does not change normal workout detail unless the exact ledger row separately reaches the normal-detail promotion rung.

## Workout

| Field | Value |
|---|---|
| Workout ID | C75E6F78-0762-450A-94F6-72878DA8EC55 |
| Source | Adriel’s Apple Watch |
| Source ID | C75E6F78-0762-450A-94F6-72878DA8EC55 |
| Device | Apple Watch Apple Inc. Watch |
| Start | Jun 28, 2026 |
| End | Jun 28, 2026 |
| Duration | 38:39 |
| Elapsed | 43:32 |
| Distance | 6.03 km |
| Avg pace | 6:24 /km |
| Avg HR | 134 bpm |
| Max HR | 146 bpm |
| Cadence | 175 spm |
| Power | 188 W |

## Evidence Counts

| Metric | Count |
|---|---:|
| Heart rate | 453 |
| Speed | 894 |
| Distance | 895 |
| Active energy | 902 |
| Power | 893 |
| Cadence | 900 |
| Step count | 900 |
| Stride length | 414 |
| Vertical oscillation | 415 |
| Ground contact | 412 |
| Route points | 2317 |
| Events | 18 |
| Workout activities | 10 |

## WorkoutKit Plan Audit

- Status: Available
- Plan type: Custom workout
- Plan ID: 6CF7534F-0CD0-47EA-97C5-788B27D4E049
- Display name: Priority 1 (pause work2,recovery3, cooldow
- Activity: HKWorkoutActivityType(rawValue: 37)
- Warmup: goal 2 km, alert pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current
- Block 1: 4x, 2 step(s)
- Block 1 step 1: Work - goal 400 m, alert pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current
- Block 1 step 2: Recovery - goal 200 m, alert pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current
- Cooldown: goal 1 km, alert pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current

## Raw HKWorkoutEvent Inventory

Debug-only inventory of public `HKWorkoutEvent` date windows and metadata keys. These rows are not Apple Fitness interval truth.

| Row | Event Type | Label | Start Offset | End Offset | Duration | Metadata Keys | Rendered Marker Window | Marker Distance | Marker Kind | Used By Segment Rendering | Excluded / Filtered Reason | Debug-Only Reason |
|---:|---|---|---:|---:|---:|---|---:|---:|---|---|---|---|
| 1 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 6:21 | 381.1 s | Unavailable | 0:00-6:21 | 1.01 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 2 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 10:13 | 612.7 s | Unavailable | 0:00-10:13 | 1.62 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 3 | HKWorkoutEventType(rawValue: 7) | Unavailable | 6:21 | 12:39 | 378.0 s | Unavailable | 6:21-12:39 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 4 | HKWorkoutEventType(rawValue: 7) | Unavailable | 10:13 | 22:11 | 718.7 s | Unavailable | 10:13-22:11 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 5 | HKWorkoutEventType(rawValue: 7) | Unavailable | 12:39 | 20:48 | 488.9 s | Unavailable | 12:39-20:48 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 6 | HKWorkoutEventType(rawValue: 1) | Unavailable | 18:00 | 18:00 | 0.0 s | Unavailable | Unavailable | Unavailable | Unavailable | No | Excluded from segment rendering: zero or negative duration. | No rendered segment marker candidate. |
| 7 | HKWorkoutEventType(rawValue: 2) | Unavailable | 19:42 | 19:42 | 0.0 s | Unavailable | Unavailable | Unavailable | Unavailable | No | Excluded from segment rendering: zero or negative duration. | No rendered segment marker candidate. |
| 8 | HKWorkoutEventType(rawValue: 7) | Unavailable | 20:48 | 28:45 | 477.3 s | Unavailable | 20:48-28:45 | 1.00 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 9 | HKWorkoutEventType(rawValue: 7) | Unavailable | 22:11 | 34:01 | 709.9 s | Unavailable | 22:11-34:01 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 10 | HKWorkoutEventType(rawValue: 1) | Unavailable | 25:14 | 25:14 | 0.0 s | Unavailable | Unavailable | Unavailable | Unavailable | No | Excluded from segment rendering: zero or negative duration. | No rendered segment marker candidate. |
| 11 | HKWorkoutEventType(rawValue: 2) | Unavailable | 26:47 | 26:47 | 0.0 s | Unavailable | Unavailable | Unavailable | Unavailable | No | Excluded from segment rendering: zero or negative duration. | No rendered segment marker candidate. |
| 12 | HKWorkoutEventType(rawValue: 7) | Unavailable | 28:45 | 36:48 | 482.4 s | Unavailable | 28:45-36:48 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 13 | HKWorkoutEventType(rawValue: 7) | Unavailable | 34:01 | 43:29 | 567.4 s | Unavailable | 34:01-43:29 | 1.20 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 14 | HKWorkoutEventType(rawValue: 1) | Unavailable | 34:05 | 34:05 | 0.0 s | Unavailable | Unavailable | Unavailable | Unavailable | No | Excluded from segment rendering: zero or negative duration. | No rendered segment marker candidate. |
| 15 | HKWorkoutEventType(rawValue: 2) | Unavailable | 35:44 | 35:44 | 0.0 s | Unavailable | Unavailable | Unavailable | Unavailable | No | Excluded from segment rendering: zero or negative duration. | No rendered segment marker candidate. |
| 16 | HKWorkoutEventType(rawValue: 7) | Unavailable | 36:48 | 43:16 | 388.5 s | Unavailable | 36:48-43:16 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 17 | HKWorkoutEventType(rawValue: 7) | Unavailable | 43:16 | 43:29 | 12.5 s | Unavailable | 43:16-43:29 | 0.03 km | Raw segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 18 | HKWorkoutEventType(rawValue: 1) | Unavailable | 43:32 | 43:32 | 0.0 s | Unavailable | Unavailable | Unavailable | Unavailable | No | Excluded from segment rendering: zero or negative duration. | No rendered segment marker candidate. |

## HKWorkoutActivity Inventory

Debug-only inventory of public `HKWorkout.workoutActivities` rows. These rows are not used for production interval reconstruction.

| Activity | Type | Start Date | End Date | Start Offset | End Offset | Duration | Metadata Keys | Nested Events | Statistics | Aligns Planned Step | Aligned Planned Step | Nearest Reconstructed Row | Row End Delta | Apple Fitness/manual | FIT Lap | Raw Event Start | Raw Start Delta | Raw Event End | Raw End Delta | Segment Start | Segment Start Delta | Segment End | Segment End Delta | Previous Sample End | Crossing Sample End | Next Sample End |
|---:|---|---|---|---:|---:|---:|---|---|---|---|---|---|---:|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T11:56:08Z | 2026-06-28T12:08:50Z | 0.0 s | 762.1 s | 762.1 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 5 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 118.6 kcal; BasalEnergyBurned: sum 18.7 kcal; DistanceWalkingRunning: sum 2007.6 m; HeartRate: avg 125.8 bpm, min 101.0 bpm, max 135.0 bpm | No | Unavailable | Warmup | -3.1 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 0.0 s | 0.0 s | 759.1 s | -2.9 s | 0.0 s | 0.0 s | 759.1 s | -2.9 s | 756.4 s | 759.0 s | 761.6 s |
| 2 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T12:08:50Z | 2026-06-28T12:11:24Z | 762.1 s | 916.1 s | 154.0 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 2 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 24.7 kcal; BasalEnergyBurned: sum 3.8 kcal; DistanceWalkingRunning: sum 399.5 m; HeartRate: avg 135.6 bpm, min 132.0 bpm, max 140.0 bpm | Yes | Work 1 | Work 1 | -2.7 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 759.1 s | -2.9 s | 759.1 s | -156.9 s | 759.1 s | -2.9 s | 759.1 s | -156.9 s | 910.8 s | 913.3 s | 915.9 s |
| 3 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T12:11:24Z | 2026-06-28T12:12:44Z | 916.1 s | 996.6 s | 80.5 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 2 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 13.5 kcal; BasalEnergyBurned: sum 2.0 kcal; DistanceWalkingRunning: sum 200.6 m; HeartRate: avg 135.7 bpm, min 134.0 bpm, max 139.0 bpm | Yes | Recovery 1 | Recovery 1 | -2.9 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 759.1 s | -156.9 s | 759.1 s | -237.5 s | 759.1 s | -156.9 s | 759.1 s | -237.5 s | 993.1 s | 995.7 s | 998.2 s |
| 4 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T12:12:44Z | 2026-06-28T12:16:59Z | 996.6 s | 1250.9 s | 152.3 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 5 event(s): HKWorkoutEventType(rawValue: 1), HKWorkoutEventType(rawValue: 2), HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 24.6 kcal; BasalEnergyBurned: sum 3.7 kcal; DistanceWalkingRunning: sum 399.9 m; HeartRate: avg 131.6 bpm, min 112.0 bpm, max 143.0 bpm | No | Unavailable | Work 2 | -3.1 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1080.0 s | 83.4 s | 1248.1 s | -2.9 s | 759.1 s | -237.5 s | 1248.1 s | -2.9 s | 1245.2 s | 1247.8 s | 1250.4 s |
| 5 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T12:16:59Z | 2026-06-28T12:18:15Z | 1250.9 s | 1326.9 s | 76.0 s | WOIntervalStepKeyPath, WOIntervalStepSuccessful | 2 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 12.4 kcal; BasalEnergyBurned: sum 1.9 kcal; DistanceWalkingRunning: sum 198.9 m; HeartRate: avg 136.8 bpm, min 131.0 bpm, max 140.0 bpm | Yes | Recovery 2 | Recovery 2 | -2.0 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1248.1 s | -2.9 s | 1331.4 s | 4.5 s | 1248.1 s | -2.9 s | 1331.4 s | 4.5 s | 1322.4 s | 1325.0 s | 1327.5 s |
| 6 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T12:18:15Z | 2026-06-28T12:20:49Z | 1326.9 s | 1481.3 s | 154.4 s | WOIntervalStepKeyPath, WOIntervalStepSuccessful | 3 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 24.5 kcal; BasalEnergyBurned: sum 3.8 kcal; DistanceWalkingRunning: sum 399.7 m; HeartRate: avg 138.2 bpm, min 133.0 bpm, max 142.0 bpm | Yes | Work 3 | Work 3 | -1.9 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1331.4 s | 4.5 s | 1331.4 s | -149.9 s | 1331.4 s | 4.5 s | 1331.4 s | -149.9 s | 1479.3 s | 1481.9 s | 1484.5 s |
| 7 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T12:20:49Z | 2026-06-28T12:23:40Z | 1481.3 s | 1652.3 s | 77.8 s | WOIntervalStepKeyPath, WOIntervalStepSuccessful | 4 event(s): HKWorkoutEventType(rawValue: 1), HKWorkoutEventType(rawValue: 2), HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 12.6 kcal; BasalEnergyBurned: sum 2.0 kcal; DistanceWalkingRunning: sum 201.7 m; HeartRate: avg 131.6 bpm, min 116.0 bpm, max 142.0 bpm | Yes | Recovery 3 | Recovery 3 | -2.6 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1514.1 s | 32.7 s | 1725.3 s | 73.0 s | 1331.4 s | -149.9 s | 1725.3 s | 73.0 s | 1649.1 s | 1651.7 s | 1654.3 s |
| 8 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T12:23:40Z | 2026-06-28T12:26:11Z | 1652.3 s | 1803.5 s | 151.2 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 3 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 24.2 kcal; BasalEnergyBurned: sum 3.7 kcal; DistanceWalkingRunning: sum 399.8 m; HeartRate: avg 135.2 bpm, min 130.0 bpm, max 139.0 bpm | Yes | Work 4 | Work 4 | -2.6 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1607.2 s | -45.1 s | 1725.3 s | -78.2 s | 1725.3 s | 73.0 s | 1725.3 s | -78.2 s | 1800.9 s | 1803.5 s | 1806.1 s |
| 9 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T12:26:11Z | 2026-06-28T12:27:27Z | 1803.5 s | 1879.3 s | 75.8 s | WOIntervalStepKeyPath, WOIntervalStepSuccessful | 2 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 12.2 kcal; BasalEnergyBurned: sum 1.9 kcal; DistanceWalkingRunning: sum 199.5 m; HeartRate: avg 137.9 bpm, min 136.0 bpm, max 140.0 bpm | Yes | Recovery 4 | Recovery 4 | -2.4 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1725.3 s | -78.2 s | 1725.3 s | -153.9 s | 1725.3 s | -78.2 s | 1725.3 s | -153.9 s | 1875.5 s | 1878.1 s | 1880.7 s |
| 10 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T12:27:27Z | 2026-06-28T12:35:29Z | 1879.3 s | 2361.2 s | 383.8 s | HKElevationAscended, WOIntervalStepKeyPath | 6 event(s): HKWorkoutEventType(rawValue: 1), HKWorkoutEventType(rawValue: 2), HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 64.5 kcal; BasalEnergyBurned: sum 9.4 kcal; DistanceWalkingRunning: sum 994.0 m; HeartRate: avg 137.0 bpm, min 114.0 bpm, max 144.0 bpm | Yes | Cooldown | Cooldown | 0.5 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1725.3 s | -153.9 s | 2207.7 s | -153.5 s | 1725.3 s | -153.9 s | 2207.7 s | -153.5 s | 2359.2 s | 2361.8 s | 2364.3 s |

## WorkoutKit Reconstructed Intervals

Planned structure source: WorkoutKit when available. Measured stats source: HealthKit samples.

| Row | Label | Goal | Target | Distance | Elapsed | Pause overlap | Active time | Display time | Duration rule | Pace | Avg HR | Max HR | Power | Start Offset | End Offset | Boundary Strategy | Boundary Adjustment | Overshoot | Confidence | Notes |
|---:|---|---|---|---:|---:|---:|---:|---:|---|---:|---:|---:|---:|---:|---:|---|---:|---:|---|---|
| 1 | Warmup | 2 km | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 2.01 km | 12:39 |  | Unavailable | 12:39 | elapsedRowWindow | 6:18 /km | 127 bpm | 135 bpm | 188 W | 0:00 | 12:39 | crossing sample end | 2.4 s | 6.1 m | High | Distance-goal boundary: crossing sample end, adjustment +2.4s, overshoot 6.1 m |
| 2 | Work 1 | 400 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.40 km | 2:34 |  | Unavailable | 2:34 | elapsedRowWindow | 6:25 /km | 136 bpm | 140 bpm | 187 W | 12:39 | 15:13 | crossing sample end | 0.3 s | 0.6 m | High | Distance-goal boundary: crossing sample end, adjustment +0.3s, overshoot 0.6 m |
| 3 | Recovery 1 | 200 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.20 km | 1:20 |  | Unavailable | 1:20 | elapsedRowWindow | 6:42 /km | 137 bpm | 139 bpm | 182 W | 15:13 | 16:34 | interpolated crossing | 0.0 s | 5.3 m | High | Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 5.3 m |
| 4 | Work 2 | 400 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.40 km | 4:14 |  | Unavailable | 4:14 | elapsedRowWindow | 10:32 /km | 133 bpm | 143 bpm | 192 W | 16:34 | 20:48 | crossing sample end | 0.8 s | 2.2 m | High | Distance-goal boundary: crossing sample end, adjustment +0.8s, overshoot 2.2 m |
| 5 | Recovery 2 | 200 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.20 km | 1:17 |  | Unavailable | 1:17 | elapsedRowWindow | 6:23 /km | 137 bpm | 140 bpm | 188 W | 20:48 | 22:05 | crossing sample end | 0.8 s | 1.7 m | High | Distance-goal boundary: crossing sample end, adjustment +0.8s, overshoot 1.7 m |
| 6 | Work 3 | 400 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.40 km | 2:34 |  | Unavailable | 2:34 | elapsedRowWindow | 6:26 /km | 138 bpm | 142 bpm | 189 W | 22:05 | 24:39 | interpolated crossing | 0.0 s | 6.8 m | High | Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 6.8 m |
| 7 | Recovery 3 | 200 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.20 km | 2:50 |  | Unavailable | 2:50 | elapsedRowWindow | 14:11 /km | 131 bpm | 142 bpm | 185 W | 24:39 | 27:30 | interpolated crossing | 0.0 s | 5.8 m | High | Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 5.8 m |
| 8 | Work 4 | 400 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.40 km | 2:31 |  | Unavailable | 2:31 | elapsedRowWindow | 6:18 /km | 135 bpm | 139 bpm | 193 W | 27:30 | 30:01 | interpolated crossing | 0.0 s | 6.3 m | High | Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 6.3 m |
| 9 | Recovery 4 | 200 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.20 km | 1:16 |  | Unavailable | 1:16 | elapsedRowWindow | 6:20 /km | 138 bpm | 140 bpm | 193 W | 30:01 | 31:17 | interpolated crossing | 0.0 s | 2.8 m | High | Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 2.8 m |
| 10 | Cooldown | 1 km | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 1.00 km | 8:05 |  | Unavailable | 8:05 | elapsedRowWindow | 8:04 /km | 138 bpm | 144 bpm | 188 W | 31:17 | 39:22 | crossing sample end | 0.6 s | 1.7 m | High | Distance-goal boundary: crossing sample end, adjustment +0.6s, overshoot 1.7 m |
| 11 | Open / Extra | Open | Target unavailable | 0.62 km | 4:11 |  | Unavailable | 4:11 | elapsedRowWindow | 6:43 /km | 143 bpm | 146 bpm | 185 W | 39:22 | 43:32 |  |  |  | Medium | Extra tail after planned WorkoutKit steps |

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
| 1 | Warmup | 2 km | mappedByPlannedStepOrder | 1 | 0.0 s | 762.1 s | 2007.6 m | 762.1 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 2 | Work 1 | 400 m | mappedByPlannedStepOrder | 2 | 762.1 s | 916.1 s | 399.5 m | 154.0 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 3 | Recovery 1 | 200 m | mappedByPlannedStepOrder | 3 | 916.1 s | 996.6 s | 200.6 m | 80.5 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 4 | Work 2 | 400 m | mappedByPlannedStepOrder | 4 | 996.6 s | 1250.9 s | 399.9 m | 254.3 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 5 | Recovery 2 | 200 m | mappedByPlannedStepOrder | 5 | 1250.9 s | 1326.9 s | 198.9 m | 76.0 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 6 | Work 3 | 400 m | mappedByPlannedStepOrder | 6 | 1326.9 s | 1481.3 s | 399.7 m | 154.4 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 7 | Recovery 3 | 200 m | mappedByPlannedStepOrder | 7 | 1481.3 s | 1652.3 s | 201.7 m | 171.0 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 8 | Work 4 | 400 m | mappedByPlannedStepOrder | 8 | 1652.3 s | 1803.5 s | 399.8 m | 151.2 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 9 | Recovery 4 | 200 m | mappedByPlannedStepOrder | 9 | 1803.5 s | 1879.3 s | 199.5 m | 75.8 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 10 | Cooldown | 1 km | mappedByPlannedStepOrder | 10 | 1879.3 s | 2361.2 s | 994.0 m | 482.0 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 11 | Open / Extra | Open | inferredOpenTailFromWorkoutEnd | Inferred | 2361.2 s | 2612.4 s | 630.8 m | 251.2 s | activity boundary inferred tail |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Inferred from workout end minus final mapped activity boundary. No separate HKWorkoutActivity row represented this tail. |

Caveats: debug-only, not promoted · not production interval logic · not shown in normal workout UI · FIT and Apple Fitness/manual rows are not runtime inputs · Activities are generic HealthKit activity windows and labels are mapped from WorkoutKit planned step order. · Missing or ambiguous activity rows must not replace current reconstruction.

## Custom Workout Candidate Rule Scorer

Debug-only Parity Lab scorer for active-time duration, pause overlap, and Open / Extra tail rows. These rows are not production interval logic, are not shown in the normal workout UI, and do not approve a normal-detail gate.

| Field | Value |
|---|---|
| Strategy | custom_workout_candidate_rule_active_time |
| Rule status | candidate-rule-scoreable |
| Candidate row count | 11 |
| Planned expanded row count | 10 |
| Open tail row count | 1 |
| Paired pause count | 3 |
| Total paired pause | 293.4 s |
| Fixed row exhaustion | fixed-rows-exhausted-before-tail |
| Tail status | open-extra-tail-present |
| Tail duration | 251.2 s |
| Tail distance | 630.8 m |
| Fallback reasons |  |
| Safety flags | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. |
| FIT validation | offline-evidence-only-not-runtime-truth |
| Scoreable | Yes |
| Not scoreable reason | n/a |
| Production UI warning | Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI. |

| Row | Label | Mapping | Start offset | End offset | Elapsed | Pause overlap | Active time | Distance | Display rule | Duration rule | Confidence | Caveats |
|---:|---|---|---:|---:|---:|---:|---:|---:|---|---|---|---|
| 1 | Warmup | mappedByPlannedStepOrder | 0.0 s | 762.1 s | 762.1 s | 0.0 s | 762.1 s | 2007.6 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 2 | Work 1 | mappedByPlannedStepOrder | 762.1 s | 916.1 s | 154.0 s | 0.0 s | 154.0 s | 399.5 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 3 | Recovery 1 | mappedByPlannedStepOrder | 916.1 s | 996.6 s | 80.5 s | 0.0 s | 80.5 s | 200.6 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 4 | Work 2 | mappedByPlannedStepOrder | 996.6 s | 1250.9 s | 254.3 s | 102.0 s | 152.3 s | 399.9 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 5 | Recovery 2 | mappedByPlannedStepOrder | 1250.9 s | 1326.9 s | 76.0 s | 0.0 s | 76.0 s | 198.9 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 6 | Work 3 | mappedByPlannedStepOrder | 1326.9 s | 1481.3 s | 154.4 s | 0.0 s | 154.4 s | 399.7 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 7 | Recovery 3 | mappedByPlannedStepOrder | 1481.3 s | 1652.3 s | 171.0 s | 93.1 s | 77.8 s | 201.7 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 8 | Work 4 | mappedByPlannedStepOrder | 1652.3 s | 1803.5 s | 151.2 s | 0.0 s | 151.2 s | 399.8 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 9 | Recovery 4 | mappedByPlannedStepOrder | 1803.5 s | 1879.3 s | 75.8 s | 0.0 s | 75.8 s | 199.5 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 10 | Cooldown | mappedByPlannedStepOrder | 1879.3 s | 2361.2 s | 482.0 s | 98.2 s | 383.8 s | 994.0 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 11 | Open / Extra | inferredOpenTailFromWorkoutEnd | 2361.2 s | 2612.4 s | 251.2 s | 0.0 s | 251.2 s | 630.8 m | open-tail-measured-duration | open-tail-measured-duration | activity boundary inferred tail | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Inferred from workout end minus final mapped activity boundary. No separate HKWorkoutActivity row represented this tail. |

Caveats: debug-only, not promoted · not production interval logic · not shown in normal workout UI · FIT and Apple Fitness/manual rows are not runtime inputs · Active duration subtracts paired HealthKit pause/resume overlap when available.

## Custom Workout Structured Comparison

Debug-only structured status and fallback taxonomy for Parity Lab rows. This status is not production interval logic, is not shown in the normal workout UI, and does not approve a normal-detail gate by itself.

| Field | Value |
|---|---|
| Status | supported |
| Status label | Structured comparison is supported. |
| Fallback reasons | None |
| Primary fallback | None |
| Row count | 10 |
| Row confidences | supported, supported, supported, supported, supported, supported, supported, supported, supported, supported |
| Tail ambiguity | fixedCooldownFollowedByPossibleOpenExtraTail |
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
| End offset | 12:39 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 2.4 s |
| Overshoot | 6.1 m |
| Cumulative distance at start | 0.0 m |
| Cumulative distance at end | 2006.1 m |
| Interpolation fraction | 0.062 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 12:34 | 12:36 | 1993.6 m | 1999.6 m |
| Crossing | 12:36 | 12:39 | 1999.6 m | 2006.1 m |
| Next | 12:39 | 12:42 | 2006.1 m | 2013.7 m |

### Row 2: Work 1

| Field | Value |
|---|---:|
| Target distance | 400.0 m |
| Start offset | 12:39 |
| End offset | 15:13 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 0.3 s |
| Overshoot | 0.6 m |
| Cumulative distance at start | 2006.1 m |
| Cumulative distance at end | 2406.7 m |
| Interpolation fraction | 0.898 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 15:08 | 15:11 | 2393.3 m | 2400.5 m |
| Crossing | 15:11 | 15:13 | 2400.5 m | 2406.7 m |
| Next | 15:13 | 15:16 | 2406.7 m | 2412.3 m |

### Row 3: Recovery 1

| Field | Value |
|---|---:|
| Target distance | 200.0 m |
| Start offset | 15:13 |
| End offset | 16:34 |
| Boundary strategy | interpolated crossing |
| Boundary adjustment | 0.0 s |
| Overshoot | 5.3 m |
| Cumulative distance at start | 2406.7 m |
| Cumulative distance at end | 2612.0 m |
| Interpolation fraction | 0.221 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 16:31 | 16:33 | 2599.6 m | 2605.2 m |
| Crossing | 16:33 | 16:36 | 2605.2 m | 2612.0 m |
| Next | 16:36 | 16:38 | 2612.0 m | 2617.3 m |

### Row 4: Work 2

| Field | Value |
|---|---:|
| Target distance | 400.0 m |
| Start offset | 16:34 |
| End offset | 20:48 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 0.8 s |
| Overshoot | 2.2 m |
| Cumulative distance at start | 2606.7 m |
| Cumulative distance at end | 3009.0 m |
| Interpolation fraction | 0.672 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 20:43 | 20:45 | 2995.8 m | 3002.2 m |
| Crossing | 20:45 | 20:48 | 3002.2 m | 3009.0 m |
| Next | 20:48 | 20:50 | 3009.0 m | 3016.0 m |

### Row 5: Recovery 2

| Field | Value |
|---|---:|
| Target distance | 200.0 m |
| Start offset | 20:48 |
| End offset | 22:05 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 0.8 s |
| Overshoot | 1.7 m |
| Cumulative distance at start | 3009.0 m |
| Cumulative distance at end | 3210.6 m |
| Interpolation fraction | 0.697 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 22:00 | 22:02 | 3197.7 m | 3205.1 m |
| Crossing | 22:02 | 22:05 | 3205.1 m | 3210.6 m |
| Next | 22:05 | 22:08 | 3210.6 m | 3218.3 m |

### Row 6: Work 3

| Field | Value |
|---|---:|
| Target distance | 400.0 m |
| Start offset | 22:05 |
| End offset | 24:39 |
| Boundary strategy | interpolated crossing |
| Boundary adjustment | 0.0 s |
| Overshoot | 6.8 m |
| Cumulative distance at start | 3210.6 m |
| Cumulative distance at end | 3617.5 m |
| Interpolation fraction | 0.054 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 24:37 | 24:39 | 3605.2 m | 3610.3 m |
| Crossing | 24:39 | 24:42 | 3610.3 m | 3617.5 m |
| Next | 24:42 | 24:44 | 3617.5 m | 3625.0 m |

### Row 7: Recovery 3

| Field | Value |
|---|---:|
| Target distance | 200.0 m |
| Start offset | 24:39 |
| End offset | 27:30 |
| Boundary strategy | interpolated crossing |
| Boundary adjustment | 0.0 s |
| Overshoot | 5.8 m |
| Cumulative distance at start | 3610.6 m |
| Cumulative distance at end | 3816.4 m |
| Interpolation fraction | 0.204 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 27:27 | 27:29 | 3801.9 m | 3809.2 m |
| Crossing | 27:29 | 27:32 | 3809.2 m | 3816.4 m |
| Next | 27:32 | 27:34 | 3816.4 m | 3822.2 m |

### Row 8: Work 4

| Field | Value |
|---|---:|
| Target distance | 400.0 m |
| Start offset | 27:30 |
| End offset | 30:01 |
| Boundary strategy | interpolated crossing |
| Boundary adjustment | 0.0 s |
| Overshoot | 6.3 m |
| Cumulative distance at start | 3810.6 m |
| Cumulative distance at end | 4216.9 m |
| Interpolation fraction | 0.011 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 29:58 | 30:01 | 4202.8 m | 4210.6 m |
| Crossing | 30:01 | 30:03 | 4210.6 m | 4216.9 m |
| Next | 30:03 | 30:06 | 4216.9 m | 4224.9 m |

### Row 9: Recovery 4

| Field | Value |
|---|---:|
| Target distance | 200.0 m |
| Start offset | 30:01 |
| End offset | 31:17 |
| Boundary strategy | interpolated crossing |
| Boundary adjustment | 0.0 s |
| Overshoot | 2.8 m |
| Cumulative distance at start | 4210.6 m |
| Cumulative distance at end | 4413.5 m |
| Interpolation fraction | 0.536 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 31:13 | 31:16 | 4400.5 m | 4407.4 m |
| Crossing | 31:16 | 31:18 | 4407.4 m | 4413.5 m |
| Next | 31:18 | 31:21 | 4413.5 m | 4420.5 m |

### Row 10: Cooldown

| Field | Value |
|---|---:|
| Target distance | 1000.0 m |
| Start offset | 31:17 |
| End offset | 39:22 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 0.6 s |
| Overshoot | 1.7 m |
| Cumulative distance at start | 4410.6 m |
| Cumulative distance at end | 5412.3 m |
| Interpolation fraction | 0.760 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 39:17 | 39:19 | 5399.5 m | 5405.4 m |
| Crossing | 39:19 | 39:22 | 5405.4 m | 5412.3 m |
| Next | 39:22 | 39:24 | 5412.3 m | 5419.0 m |

### Row 11: Open / Extra Tail

| Field | Value |
|---|---:|
| Planned final step end offset | 39:22 |
| Workout end offset | 43:32 |
| Remaining seconds | 250.6 s |
| Remaining meters | 622.6 m |
| Final distance sample offset | 43:26 |
| Final distance sample cumulative | 6035.0 m |
| Last HR sample offset | 43:29 |
| Last power sample offset | 43:29 |
| Last cadence sample offset | 43:31 |
| Reason | Remaining workout time or distance exceeded Open / Extra threshold after planned WorkoutKit steps. |

## HealthKit Segment Markers

Raw debug only. HealthKit Segment Markers must not be promoted as Apple Fitness interval rows.

| Row | Label | Marker Kind | Source | Distance | Time | Pace | Avg HR | Start Offset | End Offset | Confidence | Caveats |
|---:|---|---|---|---:|---:|---:|---:|---:|---:|---|---|
| 1 | Unknown | Split marker | HealthKit segment pattern | 1.01 km | 6:21 | 6:18 /km | 124 bpm | 0:00 | 6:21 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 2 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.62 km | 10:13 | 6:19 /km | 126 bpm | 0:00 | 10:13 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 3 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:18 | 6:18 /km | 130 bpm | 6:21 | 12:39 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 4 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 11:59 | 7:25 /km | 135 bpm | 10:13 | 22:11 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 5 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 8:09 | 8:07 /km | 135 bpm | 12:39 | 20:48 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 6 | Unknown | Split marker | HealthKit segment pattern | 1.00 km | 7:57 | 7:57 /km | 135 bpm | 20:48 | 28:45 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 7 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 11:50 | 7:22 /km | 137 bpm | 22:11 | 34:01 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 8 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 8:02 | 8:02 /km | 137 bpm | 28:45 | 36:48 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 9 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.20 km | 9:27 | 7:52 /km | 140 bpm | 34:01 | 43:29 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 10 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:29 | 6:29 /km | 142 bpm | 36:48 | 43:16 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 11 | Unknown | Raw segment marker | HealthKit segment pattern | 0.03 km | 0:13 | 8:19 /km | 141 bpm | 43:16 | 43:29 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event is a raw HealthKit marker until interval parity is proven. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |

## Planned Step Boundary Comparison

Debug-only comparison helper for FIT/Apple boundary investigation. The FIT lap end offset is intentionally a manual placeholder; RunSignal does not read FIT at runtime.

| Row | Planned Step | Goal | RunSignal End | FIT Lap End | Nearest Raw Event End | Event Delta | Nearest Activity End | Activity Delta | Activity Type | Nearest Segment End | Segment Delta | Previous Sample End | Crossing Sample End | Next Sample End | Warning |
|---:|---|---|---:|---:|---:|---:|---:|---:|---|---:|---:|---:|---:|---:|---|
| 1 | Warmup | 2 km | 759.0 s | Manual FIT placeholder | 759.1 s | 0.2 s | 762.1 s | 3.1 s | HKWorkoutActivityType(rawValue: 37) | 759.1 s | 0.2 s | 756.4 s | 759.0 s | 761.6 s |  |
| 2 | Work 1 | 400 m | 913.3 s | Manual FIT placeholder | 759.1 s | -154.2 s | 916.1 s | 2.7 s | HKWorkoutActivityType(rawValue: 37) | 759.1 s | -154.2 s | 910.8 s | 913.3 s | 915.9 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 3 | Recovery 1 | 200 m | 993.7 s | Manual FIT placeholder | 759.1 s | -234.5 s | 996.6 s | 2.9 s | HKWorkoutActivityType(rawValue: 37) | 759.1 s | -234.5 s | 993.1 s | 995.7 s | 998.2 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 4 | Work 2 | 400 m | 1247.8 s | Manual FIT placeholder | 1248.1 s | 0.3 s | 1250.9 s | 3.1 s | HKWorkoutActivityType(rawValue: 37) | 1248.1 s | 0.3 s | 1245.2 s | 1247.8 s | 1250.4 s |  |
| 5 | Recovery 2 | 200 m | 1325.0 s | Manual FIT placeholder | 1331.4 s | 6.5 s | 1326.9 s | 2.0 s | HKWorkoutActivityType(rawValue: 37) | 1331.4 s | 6.5 s | 1322.4 s | 1325.0 s | 1327.5 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 6 | Work 3 | 400 m | 1479.5 s | Manual FIT placeholder | 1331.4 s | -148.0 s | 1481.3 s | 1.9 s | HKWorkoutActivityType(rawValue: 37) | 1331.4 s | -148.0 s | 1479.3 s | 1481.9 s | 1484.5 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 7 | Recovery 3 | 200 m | 1649.7 s | Manual FIT placeholder | 1725.3 s | 75.7 s | 1652.3 s | 2.6 s | HKWorkoutActivityType(rawValue: 37) | 1725.3 s | 75.7 s | 1649.1 s | 1651.7 s | 1654.3 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 8 | Work 4 | 400 m | 1800.9 s | Manual FIT placeholder | 1725.3 s | -75.6 s | 1803.5 s | 2.6 s | HKWorkoutActivityType(rawValue: 37) | 1725.3 s | -75.6 s | 1800.9 s | 1803.5 s | 1806.1 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 9 | Recovery 4 | 200 m | 1876.9 s | Manual FIT placeholder | 1725.3 s | -151.6 s | 1879.3 s | 2.4 s | HKWorkoutActivityType(rawValue: 37) | 1725.3 s | -151.6 s | 1875.5 s | 1878.1 s | 1880.7 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 10 | Cooldown | 1 km | 2361.8 s | Manual FIT placeholder | 2207.7 s | -154.0 s | 2361.2 s | -0.5 s | HKWorkoutActivityType(rawValue: 37) | 2207.7 s | -154.0 s | 2359.2 s | 2361.8 s | 2364.3 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 11 | Open / Extra | Open | 2612.4 s | Manual FIT placeholder | 2608.7 s | -3.6 s | 2361.2 s | -251.2 s | HKWorkoutActivityType(rawValue: 37) | 2608.7 s | -3.6 s | Unavailable | Unavailable | Unavailable | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |

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
      "distanceMeters" : 2007.5993398607307,
      "durationSeconds" : 762.0643080472946,
      "endOffsetSeconds" : 762.0643080472946,
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
      "distanceMeters" : 399.4827774724778,
      "durationSeconds" : 154.01560759544373,
      "endOffsetSeconds" : 916.0799156427383,
      "index" : 2,
      "label" : "Work 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 762.0643080472946,
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
      "distanceMeters" : 200.63646509495607,
      "durationSeconds" : 80.5305939912796,
      "endOffsetSeconds" : 996.610509634018,
      "index" : 3,
      "label" : "Recovery 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 916.0799156427383,
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
      "distanceMeters" : 399.8873653672717,
      "durationSeconds" : 254.3058317899704,
      "endOffsetSeconds" : 1250.9163414239883,
      "index" : 4,
      "label" : "Work 2",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 996.610509634018,
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
      "distanceMeters" : 198.88731493982795,
      "durationSeconds" : 76.03076446056366,
      "endOffsetSeconds" : 1326.947105884552,
      "index" : 5,
      "label" : "Recovery 2",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1250.9163414239883,
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
      "distanceMeters" : 399.7435025745493,
      "durationSeconds" : 154.37865257263184,
      "endOffsetSeconds" : 1481.3257584571838,
      "index" : 6,
      "label" : "Work 3",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1326.947105884552,
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
      "distanceMeters" : 201.70141390102268,
      "durationSeconds" : 170.9587321281433,
      "endOffsetSeconds" : 1652.2844905853271,
      "index" : 7,
      "label" : "Recovery 3",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1481.3257584571838,
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
      "distanceMeters" : 399.7990128031827,
      "durationSeconds" : 151.21675550937653,
      "endOffsetSeconds" : 1803.5012460947037,
      "index" : 8,
      "label" : "Work 4",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1652.2844905853271,
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
      "distanceMeters" : 199.53063031146732,
      "durationSeconds" : 75.76058650016785,
      "endOffsetSeconds" : 1879.2618325948715,
      "index" : 9,
      "label" : "Recovery 4",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1803.5012460947037,
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
      "distanceMeters" : 994.0000370784959,
      "durationSeconds" : 481.96231603622437,
      "endOffsetSeconds" : 2361.224148631096,
      "index" : 10,
      "label" : "Cooldown",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "1 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 1000,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1879.2618325948715,
      "stepType" : "cooldown"
    },
    {
      "candidateConfidence" : "activity boundary inferred tail",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Inferred from workout end minus final mapped activity boundary.",
        "No separate HKWorkoutActivity row represented this tail."
      ],
      "distanceMeters" : 630.8152821822068,
      "durationSeconds" : 251.1624344587326,
      "endOffsetSeconds" : 2612.3865830898285,
      "index" : 11,
      "label" : "Open \/ Extra",
      "mappingStatus" : "inferredOpenTailFromWorkoutEnd",
      "plannedGoalDisplayText" : "Open",
      "plannedGoalType" : "open",
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 2361.224148631096,
      "stepType" : "open"
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
          "endCumulativeDistanceMeters" : 2006.1073712971993,
          "endDate" : "2026-06-28T12:08:47Z",
          "endOffsetSeconds" : 758.989070057869,
          "startCumulativeDistanceMeters" : 1999.5949212925043,
          "startDate" : "2026-06-28T12:08:44Z",
          "startOffsetSeconds" : 756.4163969755173
        },
        "cumulativeDistanceAtEndMeters" : 2006.1073712971993,
        "cumulativeDistanceAtStartMeters" : 0,
        "interpolationFraction" : 0.062200662915442455,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2013.7448886979837,
          "endDate" : "2026-06-28T12:08:49Z",
          "endOffsetSeconds" : 761.5617439746857,
          "startCumulativeDistanceMeters" : 2006.1073712971993,
          "startDate" : "2026-06-28T12:08:47Z",
          "startOffsetSeconds" : 758.989070057869
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 1999.5949212925043,
          "endDate" : "2026-06-28T12:08:44Z",
          "endOffsetSeconds" : 756.4163969755173,
          "startCumulativeDistanceMeters" : 1993.6199414327275,
          "startDate" : "2026-06-28T12:08:42Z",
          "startOffsetSeconds" : 753.843722820282
        },
        "targetDistanceMeters" : 2000
      },
      "index" : 1,
      "label" : "Warmup"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 2406.741575623164,
          "endDate" : "2026-06-28T12:11:21Z",
          "endOffsetSeconds" : 913.3488698005676,
          "startCumulativeDistanceMeters" : 2400.530716588488,
          "startDate" : "2026-06-28T12:11:18Z",
          "startOffsetSeconds" : 910.7762155532837
        },
        "cumulativeDistanceAtEndMeters" : 2406.741575623164,
        "cumulativeDistanceAtStartMeters" : 2006.1073712971993,
        "interpolationFraction" : 0.8978878247881941,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2412.2726773144677,
          "endDate" : "2026-06-28T12:11:24Z",
          "endOffsetSeconds" : 915.9215213060379,
          "startCumulativeDistanceMeters" : 2406.741575623164,
          "startDate" : "2026-06-28T12:11:21Z",
          "startOffsetSeconds" : 913.3488698005676
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 2400.530716588488,
          "endDate" : "2026-06-28T12:11:18Z",
          "endOffsetSeconds" : 910.7762155532837,
          "startCumulativeDistanceMeters" : 2393.338969130302,
          "startDate" : "2026-06-28T12:11:16Z",
          "startOffsetSeconds" : 908.203558921814
        },
        "targetDistanceMeters" : 400
      },
      "index" : 2,
      "label" : "Work 1"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 2612.0403475156054,
          "endDate" : "2026-06-28T12:12:43Z",
          "endOffsetSeconds" : 995.6732603311539,
          "startCumulativeDistanceMeters" : 2605.241739425808,
          "startDate" : "2026-06-28T12:12:41Z",
          "startOffsetSeconds" : 993.100634932518
        },
        "cumulativeDistanceAtEndMeters" : 2612.0403475156054,
        "cumulativeDistanceAtStartMeters" : 2406.741575623164,
        "interpolationFraction" : 0.2206093037789007,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2617.255957011599,
          "endDate" : "2026-06-28T12:12:46Z",
          "endOffsetSeconds" : 998.2458863258362,
          "startCumulativeDistanceMeters" : 2612.0403475156054,
          "startDate" : "2026-06-28T12:12:43Z",
          "startOffsetSeconds" : 995.6732603311539
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 2605.241739425808,
          "endDate" : "2026-06-28T12:12:41Z",
          "endOffsetSeconds" : 993.100634932518,
          "startCumulativeDistanceMeters" : 2599.6086467213463,
          "startDate" : "2026-06-28T12:12:38Z",
          "startOffsetSeconds" : 990.5280088186264
        },
        "targetDistanceMeters" : 200
      },
      "index" : 3,
      "label" : "Recovery 1"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3008.972686202731,
          "endDate" : "2026-06-28T12:16:55Z",
          "endOffsetSeconds" : 1247.792739391327,
          "startCumulativeDistanceMeters" : 3002.1666004285216,
          "startDate" : "2026-06-28T12:16:53Z",
          "startOffsetSeconds" : 1245.220088005066
        },
        "cumulativeDistanceAtEndMeters" : 3008.972686202731,
        "cumulativeDistanceAtStartMeters" : 2606.741575512875,
        "interpolationFraction" : 0.6721888668652315,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3015.980726758251,
          "endDate" : "2026-06-28T12:16:58Z",
          "endOffsetSeconds" : 1250.3653898239136,
          "startCumulativeDistanceMeters" : 3008.972686202731,
          "startDate" : "2026-06-28T12:16:55Z",
          "startOffsetSeconds" : 1247.792739391327
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3002.1666004285216,
          "endDate" : "2026-06-28T12:16:53Z",
          "endOffsetSeconds" : 1245.220088005066,
          "startCumulativeDistanceMeters" : 2995.8075044613797,
          "startDate" : "2026-06-28T12:16:50Z",
          "startOffsetSeconds" : 1242.64743745327
        },
        "targetDistanceMeters" : 400
      },
      "index" : 4,
      "label" : "Work 2"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3210.6465108818375,
          "endDate" : "2026-06-28T12:18:13Z",
          "endOffsetSeconds" : 1324.9725812673569,
          "startCumulativeDistanceMeters" : 3205.116585821379,
          "startDate" : "2026-06-28T12:18:10Z",
          "startOffsetSeconds" : 1322.399922132492
        },
        "cumulativeDistanceAtEndMeters" : 3210.6465108818375,
        "cumulativeDistanceAtStartMeters" : 3008.972686202731,
        "interpolationFraction" : 0.6973151243811433,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3218.291202292079,
          "endDate" : "2026-06-28T12:18:15Z",
          "endOffsetSeconds" : 1327.5452395677567,
          "startCumulativeDistanceMeters" : 3210.6465108818375,
          "startDate" : "2026-06-28T12:18:13Z",
          "startOffsetSeconds" : 1324.9725812673569
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3205.116585821379,
          "endDate" : "2026-06-28T12:18:10Z",
          "endOffsetSeconds" : 1322.399922132492,
          "startCumulativeDistanceMeters" : 3197.732171587879,
          "startDate" : "2026-06-28T12:18:08Z",
          "startOffsetSeconds" : 1319.8272610902786
        },
        "targetDistanceMeters" : 200
      },
      "index" : 5,
      "label" : "Recovery 2"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3617.4849921695422,
          "endDate" : "2026-06-28T12:20:50Z",
          "endOffsetSeconds" : 1481.9051848649979,
          "startCumulativeDistanceMeters" : 3610.253568961518,
          "startDate" : "2026-06-28T12:20:47Z",
          "startOffsetSeconds" : 1479.3325083255768
        },
        "cumulativeDistanceAtEndMeters" : 3617.4849921695422,
        "cumulativeDistanceAtStartMeters" : 3210.6465108818375,
        "interpolationFraction" : 0.0543381169952194,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3624.960858784383,
          "endDate" : "2026-06-28T12:20:52Z",
          "endOffsetSeconds" : 1484.4778615236282,
          "startCumulativeDistanceMeters" : 3617.4849921695422,
          "startDate" : "2026-06-28T12:20:50Z",
          "startOffsetSeconds" : 1481.9051848649979
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3610.253568961518,
          "endDate" : "2026-06-28T12:20:47Z",
          "endOffsetSeconds" : 1479.3325083255768,
          "startCumulativeDistanceMeters" : 3605.1508841284085,
          "startDate" : "2026-06-28T12:20:44Z",
          "startOffsetSeconds" : 1476.7598305940628
        },
        "targetDistanceMeters" : 400
      },
      "index" : 6,
      "label" : "Work 3"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3816.4216885545757,
          "endDate" : "2026-06-28T12:23:39Z",
          "endOffsetSeconds" : 1651.7022296190262,
          "startCumulativeDistanceMeters" : 3809.162908170838,
          "startDate" : "2026-06-28T12:23:37Z",
          "startOffsetSeconds" : 1649.1295337677002
        },
        "cumulativeDistanceAtEndMeters" : 3816.4216885545757,
        "cumulativeDistanceAtStartMeters" : 3610.64651074377,
        "interpolationFraction" : 0.20438730675137687,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3822.170322339749,
          "endDate" : "2026-06-28T12:23:42Z",
          "endOffsetSeconds" : 1654.2749242782593,
          "startCumulativeDistanceMeters" : 3816.4216885545757,
          "startDate" : "2026-06-28T12:23:39Z",
          "startOffsetSeconds" : 1651.7022296190262
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3809.162908170838,
          "endDate" : "2026-06-28T12:23:37Z",
          "endOffsetSeconds" : 1649.1295337677002,
          "startCumulativeDistanceMeters" : 3801.872482735431,
          "startDate" : "2026-06-28T12:23:34Z",
          "startOffsetSeconds" : 1646.5568379163742
        },
        "targetDistanceMeters" : 200
      },
      "index" : 7,
      "label" : "Recovery 3"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 4216.947955140844,
          "endDate" : "2026-06-28T12:26:11Z",
          "endOffsetSeconds" : 1803.4901200532913,
          "startCumulativeDistanceMeters" : 4210.577201077016,
          "startDate" : "2026-06-28T12:26:09Z",
          "startOffsetSeconds" : 1800.917450428009
        },
        "cumulativeDistanceAtEndMeters" : 4216.947955140844,
        "cumulativeDistanceAtStartMeters" : 3810.6465106275546,
        "interpolationFraction" : 0.010879332312013087,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 4224.853167099878,
          "endDate" : "2026-06-28T12:26:14Z",
          "endOffsetSeconds" : 1806.0627888441086,
          "startCumulativeDistanceMeters" : 4216.947955140844,
          "startDate" : "2026-06-28T12:26:11Z",
          "startOffsetSeconds" : 1803.4901200532913
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 4210.577201077016,
          "endDate" : "2026-06-28T12:26:09Z",
          "endOffsetSeconds" : 1800.917450428009,
          "startCumulativeDistanceMeters" : 4202.831100488547,
          "startDate" : "2026-06-28T12:26:06Z",
          "startOffsetSeconds" : 1798.3447815179825
        },
        "targetDistanceMeters" : 400
      },
      "index" : 8,
      "label" : "Work 4"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 4413.469541205093,
          "endDate" : "2026-06-28T12:27:26Z",
          "endOffsetSeconds" : 1878.0977107286453,
          "startCumulativeDistanceMeters" : 4407.379815821536,
          "startDate" : "2026-06-28T12:27:23Z",
          "startOffsetSeconds" : 1875.5250316858292
        },
        "cumulativeDistanceAtEndMeters" : 4413.469541205093,
        "cumulativeDistanceAtStartMeters" : 4210.646510585191,
        "interpolationFraction" : 0.5364272701812783,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 4420.479328559944,
          "endDate" : "2026-06-28T12:27:28Z",
          "endOffsetSeconds" : 1880.6703870296478,
          "startCumulativeDistanceMeters" : 4413.469541205093,
          "startDate" : "2026-06-28T12:27:26Z",
          "startOffsetSeconds" : 1878.0977107286453
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 4407.379815821536,
          "endDate" : "2026-06-28T12:27:23Z",
          "endOffsetSeconds" : 1875.5250316858292,
          "startCumulativeDistanceMeters" : 4400.469880877528,
          "startDate" : "2026-06-28T12:27:21Z",
          "startOffsetSeconds" : 1872.9523557424545
        },
        "targetDistanceMeters" : 200
      },
      "index" : 9,
      "label" : "Recovery 4"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 5412.3129852188285,
          "endDate" : "2026-06-28T12:35:29Z",
          "endOffsetSeconds" : 2361.763771176338,
          "startCumulativeDistanceMeters" : 5405.3635165004525,
          "startDate" : "2026-06-28T12:35:27Z",
          "startOffsetSeconds" : 2359.1910477876663
        },
        "cumulativeDistanceAtEndMeters" : 5412.3129852188285,
        "cumulativeDistanceAtStartMeters" : 4410.646510568959,
        "interpolationFraction" : 0.7602011437991727,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 5418.960445047356,
          "endDate" : "2026-06-28T12:35:32Z",
          "endOffsetSeconds" : 2364.336494088173,
          "startCumulativeDistanceMeters" : 5412.3129852188285,
          "startDate" : "2026-06-28T12:35:29Z",
          "startOffsetSeconds" : 2361.763771176338
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 5405.3635165004525,
          "endDate" : "2026-06-28T12:35:27Z",
          "endOffsetSeconds" : 2359.1910477876663,
          "startCumulativeDistanceMeters" : 5399.508401080035,
          "startDate" : "2026-06-28T12:35:24Z",
          "startOffsetSeconds" : 2356.618324279785
        },
        "targetDistanceMeters" : 1000
      },
      "index" : 10,
      "label" : "Cooldown"
    },
    {
      "index" : 11,
      "label" : "Open \/ Extra",
      "tail" : {
        "creationReason" : "Remaining workout time or distance exceeded Open \/ Extra threshold after planned WorkoutKit steps.",
        "finalDistanceSampleCumulativeDistanceMeters" : 6034.950702300528,
        "finalDistanceSampleOffsetSeconds" : 2606.173961162567,
        "lastCadenceSampleOffsetSeconds" : 2611.3194534778595,
        "lastHeartRateSampleOffsetSeconds" : 2609.373922944069,
        "lastPowerSampleOffsetSeconds" : 2608.746708512306,
        "plannedFinalStepEndOffsetSeconds" : 2361.763771176338,
        "remainingMeters" : 622.6377170816995,
        "remainingSeconds" : 250.6228119134903,
        "workoutEndOffsetSeconds" : 2612.3865830898285
      }
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
      "activeDurationSeconds" : 762.0643080472946,
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
      "distanceMeters" : 2007.5993398607307,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 762.0643080472946,
      "endOffsetSeconds" : 762.0643080472946,
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
      "activeDurationSeconds" : 154.01560759544373,
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
      "distanceMeters" : 399.4827774724778,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 154.01560759544373,
      "endOffsetSeconds" : 916.0799156427383,
      "index" : 2,
      "isOpenTail" : false,
      "label" : "Work 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 762.0643080472946,
      "stepType" : "work"
    },
    {
      "activeDurationSeconds" : 80.5305939912796,
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
      "distanceMeters" : 200.63646509495607,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 80.5305939912796,
      "endOffsetSeconds" : 996.610509634018,
      "index" : 3,
      "isOpenTail" : false,
      "label" : "Recovery 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 916.0799156427383,
      "stepType" : "recovery"
    },
    {
      "activeDurationSeconds" : 152.26964581012726,
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
      "distanceMeters" : 399.8873653672717,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 254.3058317899704,
      "endOffsetSeconds" : 1250.9163414239883,
      "index" : 4,
      "isOpenTail" : false,
      "label" : "Work 2",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 102.03618597984314,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 996.610509634018,
      "stepType" : "work"
    },
    {
      "activeDurationSeconds" : 76.03076446056366,
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
      "distanceMeters" : 198.88731493982795,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 76.03076446056366,
      "endOffsetSeconds" : 1326.947105884552,
      "index" : 5,
      "isOpenTail" : false,
      "label" : "Recovery 2",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1250.9163414239883,
      "stepType" : "recovery"
    },
    {
      "activeDurationSeconds" : 154.37865257263184,
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
      "distanceMeters" : 399.7435025745493,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 154.37865257263184,
      "endOffsetSeconds" : 1481.3257584571838,
      "index" : 6,
      "isOpenTail" : false,
      "label" : "Work 3",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1326.947105884552,
      "stepType" : "work"
    },
    {
      "activeDurationSeconds" : 77.81419610977173,
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
      "distanceMeters" : 201.70141390102268,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 170.9587321281433,
      "endOffsetSeconds" : 1652.2844905853271,
      "index" : 7,
      "isOpenTail" : false,
      "label" : "Recovery 3",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 93.14453601837158,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1481.3257584571838,
      "stepType" : "recovery"
    },
    {
      "activeDurationSeconds" : 151.21675550937653,
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
      "distanceMeters" : 399.7990128031827,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 151.21675550937653,
      "endOffsetSeconds" : 1803.5012460947037,
      "index" : 8,
      "isOpenTail" : false,
      "label" : "Work 4",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1652.2844905853271,
      "stepType" : "work"
    },
    {
      "activeDurationSeconds" : 75.76058650016785,
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
      "distanceMeters" : 199.53063031146732,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 75.76058650016785,
      "endOffsetSeconds" : 1879.2618325948715,
      "index" : 9,
      "isOpenTail" : false,
      "label" : "Recovery 4",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1803.5012460947037,
      "stepType" : "recovery"
    },
    {
      "activeDurationSeconds" : 383.7713840007782,
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
      "distanceMeters" : 994.0000370784959,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 481.96231603622437,
      "endOffsetSeconds" : 2361.224148631096,
      "index" : 10,
      "isOpenTail" : false,
      "label" : "Cooldown",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 98.19093203544617,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1879.2618325948715,
      "stepType" : "cooldown"
    },
    {
      "activeDurationSeconds" : 251.1624344587326,
      "candidateConfidence" : "activity boundary inferred tail",
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
        "Inferred from workout end minus final mapped activity boundary.",
        "No separate HKWorkoutActivity row represented this tail."
      ],
      "distanceMeters" : 630.8152821822068,
      "durationDisplayRule" : "open-tail-measured-duration",
      "durationRule" : "open-tail-measured-duration",
      "elapsedDurationSeconds" : 251.1624344587326,
      "endOffsetSeconds" : 2612.3865830898285,
      "index" : 11,
      "isOpenTail" : true,
      "label" : "Open \/ Extra",
      "mappingStatus" : "inferredOpenTailFromWorkoutEnd",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 2361.224148631096,
      "stepType" : "open"
    }
  ],
  "customWorkoutCandidateRuleSummary" : {
    "boundaryLogicChanged" : false,
    "candidateRowCount" : 11,
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
    "fixedRowExhaustionStatus" : "fixed-rows-exhausted-before-tail",
    "isScoreable" : true,
    "normalWorkoutUIChanged" : false,
    "openTailRowCount" : 1,
    "pairedPauseCount" : 3,
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
    "tailDistanceMeters" : 630.8152821822068,
    "tailElapsedDurationSeconds" : 251.1624344587326,
    "tailStatus" : "open-extra-tail-present",
    "totalPairedPauseSeconds" : 293.3716540336609,
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
      "supported",
      "supported",
      "supported",
      "supported",
      "supported",
      "supported",
      "supported",
      "supported",
      "supported",
      "supported"
    ],
    "rowCount" : 10,
    "scope" : "debug\/export-only",
    "status" : "supported",
    "statusLabel" : "Structured comparison is supported.",
    "tailAmbiguity" : "fixedCooldownFollowedByPossibleOpenExtraTail",
    "usesFITRuntimeTruth" : false
  },
  "evidenceCounts" : {
    "activeEnergy" : 902,
    "activities" : 10,
    "cadence" : 900,
    "distance" : 895,
    "events" : 18,
    "groundContact" : 412,
    "heartRate" : 453,
    "power" : 893,
    "routePoints" : 2317,
    "speed" : 894,
    "stepCount" : 900,
    "strideLength" : 414,
    "verticalOscillation" : 415
  },
  "generatedAt" : "2026-06-28T19:36:44Z",
  "plannedStepBoundaryComparisons" : [
    {
      "crossingDistanceSampleEndOffsetSeconds" : 758.989070057869,
      "index" : 1,
      "nearestRawEventEndDeltaSeconds" : 0.16002202033996582,
      "nearestRawEventEndOffsetSeconds" : 759.1490920782089,
      "nearestRawEventStartOffsetSeconds" : 381.1363214254379,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 0.16002202033996582,
      "nearestSegmentMarkerEndOffsetSeconds" : 759.1490920782089,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 381.1363214254379,
      "nearestWorkoutActivityEndDeltaSeconds" : 3.075237989425659,
      "nearestWorkoutActivityEndOffsetSeconds" : 762.0643080472946,
      "nearestWorkoutActivityStartOffsetSeconds" : 0,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 761.5617439746857,
      "plannedGoalDisplayText" : "2 km",
      "plannedStepLabel" : "Warmup",
      "previousDistanceSampleEndOffsetSeconds" : 756.4163969755173,
      "reconstructedEndOffsetSeconds" : 758.989070057869,
      "reconstructedLabel" : "Warmup"
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 913.3488698005676,
      "index" : 2,
      "nearestRawEventEndDeltaSeconds" : -154.1997777223587,
      "nearestRawEventEndOffsetSeconds" : 759.1490920782089,
      "nearestRawEventStartOffsetSeconds" : 381.1363214254379,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -154.1997777223587,
      "nearestSegmentMarkerEndOffsetSeconds" : 759.1490920782089,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 381.1363214254379,
      "nearestWorkoutActivityEndDeltaSeconds" : 2.7310458421707153,
      "nearestWorkoutActivityEndOffsetSeconds" : 916.0799156427383,
      "nearestWorkoutActivityStartOffsetSeconds" : 762.0643080472946,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 915.9215213060379,
      "plannedGoalDisplayText" : "400 m",
      "plannedStepLabel" : "Work 1",
      "previousDistanceSampleEndOffsetSeconds" : 910.7762155532837,
      "reconstructedEndOffsetSeconds" : 913.3488698005676,
      "reconstructedLabel" : "Work 1",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 995.6732603311539,
      "index" : 3,
      "nearestRawEventEndDeltaSeconds" : -234.51908791065216,
      "nearestRawEventEndOffsetSeconds" : 759.1490920782089,
      "nearestRawEventStartOffsetSeconds" : 381.1363214254379,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -234.51908791065216,
      "nearestSegmentMarkerEndOffsetSeconds" : 759.1490920782089,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 381.1363214254379,
      "nearestWorkoutActivityEndDeltaSeconds" : 2.9423296451568604,
      "nearestWorkoutActivityEndOffsetSeconds" : 996.610509634018,
      "nearestWorkoutActivityStartOffsetSeconds" : 916.0799156427383,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 998.2458863258362,
      "plannedGoalDisplayText" : "200 m",
      "plannedStepLabel" : "Recovery 1",
      "previousDistanceSampleEndOffsetSeconds" : 993.100634932518,
      "reconstructedEndOffsetSeconds" : 993.6681799888611,
      "reconstructedLabel" : "Recovery 1",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1247.792739391327,
      "index" : 4,
      "nearestRawEventEndDeltaSeconds" : 0.2649577856063843,
      "nearestRawEventEndOffsetSeconds" : 1248.0576971769333,
      "nearestRawEventStartOffsetSeconds" : 759.1490920782089,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 0.2649577856063843,
      "nearestSegmentMarkerEndOffsetSeconds" : 1248.0576971769333,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 759.1490920782089,
      "nearestWorkoutActivityEndDeltaSeconds" : 3.123602032661438,
      "nearestWorkoutActivityEndOffsetSeconds" : 1250.9163414239883,
      "nearestWorkoutActivityStartOffsetSeconds" : 996.610509634018,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1250.3653898239136,
      "plannedGoalDisplayText" : "400 m",
      "plannedStepLabel" : "Work 2",
      "previousDistanceSampleEndOffsetSeconds" : 1245.220088005066,
      "reconstructedEndOffsetSeconds" : 1247.792739391327,
      "reconstructedLabel" : "Work 2"
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1324.9725812673569,
      "index" : 5,
      "nearestRawEventEndDeltaSeconds" : 6.452776074409485,
      "nearestRawEventEndOffsetSeconds" : 1331.4253573417664,
      "nearestRawEventStartOffsetSeconds" : 612.6977468729019,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 6.452776074409485,
      "nearestSegmentMarkerEndOffsetSeconds" : 1331.4253573417664,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 612.6977468729019,
      "nearestWorkoutActivityEndDeltaSeconds" : 1.9745246171951294,
      "nearestWorkoutActivityEndOffsetSeconds" : 1326.947105884552,
      "nearestWorkoutActivityStartOffsetSeconds" : 1250.9163414239883,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1327.5452395677567,
      "plannedGoalDisplayText" : "200 m",
      "plannedStepLabel" : "Recovery 2",
      "previousDistanceSampleEndOffsetSeconds" : 1322.399922132492,
      "reconstructedEndOffsetSeconds" : 1324.9725812673569,
      "reconstructedLabel" : "Recovery 2",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1481.9051848649979,
      "index" : 6,
      "nearestRawEventEndDeltaSeconds" : -148.04694533348083,
      "nearestRawEventEndOffsetSeconds" : 1331.4253573417664,
      "nearestRawEventStartOffsetSeconds" : 612.6977468729019,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -148.04694533348083,
      "nearestSegmentMarkerEndOffsetSeconds" : 1331.4253573417664,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 612.6977468729019,
      "nearestWorkoutActivityEndDeltaSeconds" : 1.8534557819366455,
      "nearestWorkoutActivityEndOffsetSeconds" : 1481.3257584571838,
      "nearestWorkoutActivityStartOffsetSeconds" : 1326.947105884552,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1484.4778615236282,
      "plannedGoalDisplayText" : "400 m",
      "plannedStepLabel" : "Work 3",
      "previousDistanceSampleEndOffsetSeconds" : 1479.3325083255768,
      "reconstructedEndOffsetSeconds" : 1479.4723026752472,
      "reconstructedLabel" : "Work 3",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1651.7022296190262,
      "index" : 7,
      "nearestRawEventEndDeltaSeconds" : 75.6630187034607,
      "nearestRawEventEndOffsetSeconds" : 1725.3183788061142,
      "nearestRawEventStartOffsetSeconds" : 1248.0576971769333,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 75.6630187034607,
      "nearestSegmentMarkerEndOffsetSeconds" : 1725.3183788061142,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1248.0576971769333,
      "nearestWorkoutActivityEndDeltaSeconds" : 2.629130482673645,
      "nearestWorkoutActivityEndOffsetSeconds" : 1652.2844905853271,
      "nearestWorkoutActivityStartOffsetSeconds" : 1481.3257584571838,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1654.2749242782593,
      "plannedGoalDisplayText" : "200 m",
      "plannedStepLabel" : "Recovery 3",
      "previousDistanceSampleEndOffsetSeconds" : 1649.1295337677002,
      "reconstructedEndOffsetSeconds" : 1649.6553601026535,
      "reconstructedLabel" : "Recovery 3",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1803.4901200532913,
      "index" : 8,
      "nearestRawEventEndDeltaSeconds" : -75.62706053256989,
      "nearestRawEventEndOffsetSeconds" : 1725.3183788061142,
      "nearestRawEventStartOffsetSeconds" : 1248.0576971769333,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -75.62706053256989,
      "nearestSegmentMarkerEndOffsetSeconds" : 1725.3183788061142,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1248.0576971769333,
      "nearestWorkoutActivityEndDeltaSeconds" : 2.5558067560195923,
      "nearestWorkoutActivityEndOffsetSeconds" : 1803.5012460947037,
      "nearestWorkoutActivityStartOffsetSeconds" : 1652.2844905853271,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1806.0627888441086,
      "plannedGoalDisplayText" : "400 m",
      "plannedStepLabel" : "Work 4",
      "previousDistanceSampleEndOffsetSeconds" : 1800.917450428009,
      "reconstructedEndOffsetSeconds" : 1800.945439338684,
      "reconstructedLabel" : "Work 4",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1878.0977107286453,
      "index" : 9,
      "nearestRawEventEndDeltaSeconds" : -151.58670806884766,
      "nearestRawEventEndOffsetSeconds" : 1725.3183788061142,
      "nearestRawEventStartOffsetSeconds" : 1248.0576971769333,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -151.58670806884766,
      "nearestSegmentMarkerEndOffsetSeconds" : 1725.3183788061142,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1248.0576971769333,
      "nearestWorkoutActivityEndDeltaSeconds" : 2.356745719909668,
      "nearestWorkoutActivityEndOffsetSeconds" : 1879.2618325948715,
      "nearestWorkoutActivityStartOffsetSeconds" : 1803.5012460947037,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1880.6703870296478,
      "plannedGoalDisplayText" : "200 m",
      "plannedStepLabel" : "Recovery 4",
      "previousDistanceSampleEndOffsetSeconds" : 1875.5250316858292,
      "reconstructedEndOffsetSeconds" : 1876.9050868749619,
      "reconstructedLabel" : "Recovery 4",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 2361.763771176338,
      "index" : 10,
      "nearestRawEventEndDeltaSeconds" : -154.0405534505844,
      "nearestRawEventEndOffsetSeconds" : 2207.723217725754,
      "nearestRawEventStartOffsetSeconds" : 1725.3183788061142,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -154.0405534505844,
      "nearestSegmentMarkerEndOffsetSeconds" : 2207.723217725754,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1725.3183788061142,
      "nearestWorkoutActivityEndDeltaSeconds" : -0.5396225452423096,
      "nearestWorkoutActivityEndOffsetSeconds" : 2361.224148631096,
      "nearestWorkoutActivityStartOffsetSeconds" : 1879.2618325948715,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 2364.336494088173,
      "plannedGoalDisplayText" : "1 km",
      "plannedStepLabel" : "Cooldown",
      "previousDistanceSampleEndOffsetSeconds" : 2359.1910477876663,
      "reconstructedEndOffsetSeconds" : 2361.763771176338,
      "reconstructedLabel" : "Cooldown",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "index" : 11,
      "nearestRawEventEndDeltaSeconds" : -3.639874577522278,
      "nearestRawEventEndOffsetSeconds" : 2608.746708512306,
      "nearestRawEventStartOffsetSeconds" : 2041.354376077652,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -3.639874577522278,
      "nearestSegmentMarkerEndOffsetSeconds" : 2608.746708512306,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 2041.354376077652,
      "nearestWorkoutActivityEndDeltaSeconds" : -251.1624344587326,
      "nearestWorkoutActivityEndOffsetSeconds" : 2361.224148631096,
      "nearestWorkoutActivityStartOffsetSeconds" : 1879.2618325948715,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "plannedGoalDisplayText" : "Open",
      "reconstructedEndOffsetSeconds" : 2612.3865830898285,
      "reconstructedLabel" : "Open \/ Extra",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    }
  ],
  "rawWorkoutEvents" : [
    {
      "durationSeconds" : 381.1363214254379,
      "endDate" : "2026-06-28T12:02:29Z",
      "endOffsetSeconds" : 381.1363214254379,
      "index" : 1,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1007.4891590430527,
      "renderedSegmentMarkerDurationSeconds" : 381.1363214254379,
      "renderedSegmentMarkerEndOffsetSeconds" : 381.1363214254379,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T11:56:08Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 612.6977468729019,
      "endDate" : "2026-06-28T12:06:20Z",
      "endOffsetSeconds" : 612.6977468729019,
      "index" : 2,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1615.5672539270272,
      "renderedSegmentMarkerDurationSeconds" : 612.6977468729019,
      "renderedSegmentMarkerEndOffsetSeconds" : 612.6977468729019,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T11:56:08Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 378.012770652771,
      "endDate" : "2026-06-28T12:08:47Z",
      "endOffsetSeconds" : 759.1490920782089,
      "index" : 3,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 999.0932708913358,
      "renderedSegmentMarkerDurationSeconds" : 378.012770652771,
      "renderedSegmentMarkerEndOffsetSeconds" : 759.1490920782089,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 381.1363214254379,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T12:02:29Z",
      "startOffsetSeconds" : 381.1363214254379,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 718.7276104688644,
      "endDate" : "2026-06-28T12:18:19Z",
      "endOffsetSeconds" : 1331.4253573417664,
      "index" : 4,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1613.3145518476822,
      "renderedSegmentMarkerDurationSeconds" : 718.7276104688644,
      "renderedSegmentMarkerEndOffsetSeconds" : 1331.4253573417664,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 612.6977468729019,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T12:06:20Z",
      "startOffsetSeconds" : 612.6977468729019,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 488.90860509872437,
      "endDate" : "2026-06-28T12:16:56Z",
      "endOffsetSeconds" : 1248.0576971769333,
      "index" : 5,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1003.1120157750015,
      "renderedSegmentMarkerDurationSeconds" : 488.90860509872437,
      "renderedSegmentMarkerEndOffsetSeconds" : 1248.0576971769333,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 759.1490920782089,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T12:08:47Z",
      "startOffsetSeconds" : 759.1490920782089,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 0,
      "endDate" : "2026-06-28T12:14:08Z",
      "endOffsetSeconds" : 1079.9637800455093,
      "excludedOrFilteredReason" : "zeroOrNegativeDuration",
      "index" : 6,
      "metadataKeys" : [

      ],
      "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
      "startDate" : "2026-06-28T12:14:08Z",
      "startOffsetSeconds" : 1079.9637800455093,
      "type" : "HKWorkoutEventType(rawValue: 1)",
      "usedBySegmentMarkerRendering" : false
    },
    {
      "durationSeconds" : 0,
      "endDate" : "2026-06-28T12:15:50Z",
      "endOffsetSeconds" : 1181.9999660253525,
      "excludedOrFilteredReason" : "zeroOrNegativeDuration",
      "index" : 7,
      "metadataKeys" : [

      ],
      "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
      "startDate" : "2026-06-28T12:15:50Z",
      "startOffsetSeconds" : 1181.9999660253525,
      "type" : "HKWorkoutEventType(rawValue: 2)",
      "usedBySegmentMarkerRendering" : false
    },
    {
      "durationSeconds" : 477.2606816291809,
      "endDate" : "2026-06-28T12:24:53Z",
      "endOffsetSeconds" : 1725.3183788061142,
      "index" : 8,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1000.4094793633872,
      "renderedSegmentMarkerDurationSeconds" : 477.2606816291809,
      "renderedSegmentMarkerEndOffsetSeconds" : 1725.3183788061142,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1248.0576971769333,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T12:16:56Z",
      "startOffsetSeconds" : 1248.0576971769333,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 709.9290187358856,
      "endDate" : "2026-06-28T12:30:09Z",
      "endOffsetSeconds" : 2041.354376077652,
      "index" : 9,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1605.1607813299452,
      "renderedSegmentMarkerDurationSeconds" : 709.9290187358856,
      "renderedSegmentMarkerEndOffsetSeconds" : 2041.354376077652,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1331.4253573417664,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T12:18:19Z",
      "startOffsetSeconds" : 1331.4253573417664,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 0,
      "endDate" : "2026-06-28T12:21:22Z",
      "endOffsetSeconds" : 1514.0749130249023,
      "excludedOrFilteredReason" : "zeroOrNegativeDuration",
      "index" : 10,
      "metadataKeys" : [

      ],
      "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
      "startDate" : "2026-06-28T12:21:22Z",
      "startOffsetSeconds" : 1514.0749130249023,
      "type" : "HKWorkoutEventType(rawValue: 1)",
      "usedBySegmentMarkerRendering" : false
    },
    {
      "durationSeconds" : 0,
      "endDate" : "2026-06-28T12:22:55Z",
      "endOffsetSeconds" : 1607.219449043274,
      "excludedOrFilteredReason" : "zeroOrNegativeDuration",
      "index" : 11,
      "metadataKeys" : [

      ],
      "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
      "startDate" : "2026-06-28T12:22:55Z",
      "startOffsetSeconds" : 1607.219449043274,
      "type" : "HKWorkoutEventType(rawValue: 2)",
      "usedBySegmentMarkerRendering" : false
    },
    {
      "durationSeconds" : 482.4048389196396,
      "endDate" : "2026-06-28T12:32:55Z",
      "endOffsetSeconds" : 2207.723217725754,
      "index" : 12,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1001.0184087067182,
      "renderedSegmentMarkerDurationSeconds" : 482.4048389196396,
      "renderedSegmentMarkerEndOffsetSeconds" : 2207.723217725754,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1725.3183788061142,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T12:24:53Z",
      "startOffsetSeconds" : 1725.3183788061142,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 567.3923324346542,
      "endDate" : "2026-06-28T12:39:36Z",
      "endOffsetSeconds" : 2608.746708512306,
      "index" : 13,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1200.9081151958735,
      "renderedSegmentMarkerDurationSeconds" : 567.3923324346542,
      "renderedSegmentMarkerEndOffsetSeconds" : 2608.746708512306,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 2041.354376077652,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T12:30:09Z",
      "startOffsetSeconds" : 2041.354376077652,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 0,
      "endDate" : "2026-06-28T12:30:13Z",
      "endOffsetSeconds" : 2045.4134089946747,
      "excludedOrFilteredReason" : "zeroOrNegativeDuration",
      "index" : 14,
      "metadataKeys" : [

      ],
      "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
      "startDate" : "2026-06-28T12:30:13Z",
      "startOffsetSeconds" : 2045.4134089946747,
      "type" : "HKWorkoutEventType(rawValue: 1)",
      "usedBySegmentMarkerRendering" : false
    },
    {
      "durationSeconds" : 0,
      "endDate" : "2026-06-28T12:31:51Z",
      "endOffsetSeconds" : 2143.604341030121,
      "excludedOrFilteredReason" : "zeroOrNegativeDuration",
      "index" : 15,
      "metadataKeys" : [

      ],
      "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
      "startDate" : "2026-06-28T12:31:51Z",
      "startOffsetSeconds" : 2143.604341030121,
      "type" : "HKWorkoutEventType(rawValue: 2)",
      "usedBySegmentMarkerRendering" : false
    },
    {
      "durationSeconds" : 388.50510430336,
      "endDate" : "2026-06-28T12:39:24Z",
      "endOffsetSeconds" : 2596.2283220291138,
      "index" : 16,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 998.7594388601501,
      "renderedSegmentMarkerDurationSeconds" : 388.50510430336,
      "renderedSegmentMarkerEndOffsetSeconds" : 2596.2283220291138,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 2207.723217725754,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T12:32:55Z",
      "startOffsetSeconds" : 2207.723217725754,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 12.518386483192444,
      "endDate" : "2026-06-28T12:39:36Z",
      "endOffsetSeconds" : 2608.746708512306,
      "index" : 17,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 25.06892966088253,
      "renderedSegmentMarkerDurationSeconds" : 12.518386483192444,
      "renderedSegmentMarkerEndOffsetSeconds" : 2608.746708512306,
      "renderedSegmentMarkerKind" : "rawSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 2596.2283220291138,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T12:39:24Z",
      "startOffsetSeconds" : 2596.2283220291138,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 0,
      "endDate" : "2026-06-28T12:39:40Z",
      "endOffsetSeconds" : 2612.3865830898285,
      "excludedOrFilteredReason" : "zeroOrNegativeDuration",
      "index" : 18,
      "metadataKeys" : [

      ],
      "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
      "startDate" : "2026-06-28T12:39:40Z",
      "startOffsetSeconds" : 2612.3865830898285,
      "type" : "HKWorkoutEventType(rawValue: 1)",
      "usedBySegmentMarkerRendering" : false
    }
  ],
  "reconstructedIntervals" : [
    {
      "averageHeartRateBpm" : 127.1063829787234,
      "averagePower" : 187.85374149659864,
      "boundaryAdjustmentSeconds" : 2.4126510620117188,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 2006.1073712971993,
          "endDate" : "2026-06-28T12:08:47Z",
          "endOffsetSeconds" : 758.989070057869,
          "startCumulativeDistanceMeters" : 1999.5949212925043,
          "startDate" : "2026-06-28T12:08:44Z",
          "startOffsetSeconds" : 756.4163969755173
        },
        "cumulativeDistanceAtEndMeters" : 2006.1073712971993,
        "cumulativeDistanceAtStartMeters" : 0,
        "interpolationFraction" : 0.062200662915442455,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2013.7448886979837,
          "endDate" : "2026-06-28T12:08:49Z",
          "endOffsetSeconds" : 761.5617439746857,
          "startCumulativeDistanceMeters" : 2006.1073712971993,
          "startDate" : "2026-06-28T12:08:47Z",
          "startOffsetSeconds" : 758.989070057869
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 1999.5949212925043,
          "endDate" : "2026-06-28T12:08:44Z",
          "endOffsetSeconds" : 756.4163969755173,
          "startCumulativeDistanceMeters" : 1993.6199414327275,
          "startDate" : "2026-06-28T12:08:42Z",
          "startOffsetSeconds" : 753.843722820282
        },
        "targetDistanceMeters" : 2000
      },
      "boundaryOvershootMeters" : 6.107371297199279,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "displayDurationSeconds" : 758.989070057869,
      "distanceMeters" : 2006.1073712971993,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 758.989070057869,
      "elapsedDurationSeconds" : 758.989070057869,
      "endOffsetSeconds" : 758.989070057869,
      "index" : 1,
      "label" : "Warmup",
      "maxHeartRateBpm" : 135,
      "paceSecondsPerKm" : 378.33920602519277,
      "plannedGoalDisplayText" : "2 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 2000,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +2.4s, overshoot 6.1 m",
      "startOffsetSeconds" : 0,
      "stepType" : "warmup"
    },
    {
      "averageHeartRateBpm" : 135.56666666666666,
      "averagePower" : 186.95081967213116,
      "boundaryAdjustmentSeconds" : 0.2626993656158447,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 2406.741575623164,
          "endDate" : "2026-06-28T12:11:21Z",
          "endOffsetSeconds" : 913.3488698005676,
          "startCumulativeDistanceMeters" : 2400.530716588488,
          "startDate" : "2026-06-28T12:11:18Z",
          "startOffsetSeconds" : 910.7762155532837
        },
        "cumulativeDistanceAtEndMeters" : 2406.741575623164,
        "cumulativeDistanceAtStartMeters" : 2006.1073712971993,
        "interpolationFraction" : 0.8978878247881941,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2412.2726773144677,
          "endDate" : "2026-06-28T12:11:24Z",
          "endOffsetSeconds" : 915.9215213060379,
          "startCumulativeDistanceMeters" : 2406.741575623164,
          "startDate" : "2026-06-28T12:11:21Z",
          "startOffsetSeconds" : 913.3488698005676
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 2400.530716588488,
          "endDate" : "2026-06-28T12:11:18Z",
          "endOffsetSeconds" : 910.7762155532837,
          "startCumulativeDistanceMeters" : 2393.338969130302,
          "startDate" : "2026-06-28T12:11:16Z",
          "startOffsetSeconds" : 908.203558921814
        },
        "targetDistanceMeters" : 400
      },
      "boundaryOvershootMeters" : 0.6342043259646744,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "displayDurationSeconds" : 154.35979974269867,
      "distanceMeters" : 400.6342043259647,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 154.35979974269867,
      "elapsedDurationSeconds" : 154.35979974269867,
      "endOffsetSeconds" : 913.3488698005676,
      "index" : 2,
      "label" : "Work 1",
      "maxHeartRateBpm" : 140,
      "paceSecondsPerKm" : 385.2886200827431,
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +0.3s, overshoot 0.6 m",
      "startOffsetSeconds" : 758.989070057869,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 136.625,
      "averagePower" : 182.40625,
      "boundaryAdjustmentSeconds" : 0,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 2612.0403475156054,
          "endDate" : "2026-06-28T12:12:43Z",
          "endOffsetSeconds" : 995.6732603311539,
          "startCumulativeDistanceMeters" : 2605.241739425808,
          "startDate" : "2026-06-28T12:12:41Z",
          "startOffsetSeconds" : 993.100634932518
        },
        "cumulativeDistanceAtEndMeters" : 2612.0403475156054,
        "cumulativeDistanceAtStartMeters" : 2406.741575623164,
        "interpolationFraction" : 0.2206093037789007,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2617.255957011599,
          "endDate" : "2026-06-28T12:12:46Z",
          "endOffsetSeconds" : 998.2458863258362,
          "startCumulativeDistanceMeters" : 2612.0403475156054,
          "startDate" : "2026-06-28T12:12:43Z",
          "startOffsetSeconds" : 995.6732603311539
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 2605.241739425808,
          "endDate" : "2026-06-28T12:12:41Z",
          "endOffsetSeconds" : 993.100634932518,
          "startCumulativeDistanceMeters" : 2599.6086467213463,
          "startDate" : "2026-06-28T12:12:38Z",
          "startOffsetSeconds" : 990.5280088186264
        },
        "targetDistanceMeters" : 200
      },
      "boundaryOvershootMeters" : 5.298771892441437,
      "boundaryStrategy" : "interpolatedCrossing",
      "confidence" : "high",
      "displayDurationSeconds" : 80.31931018829346,
      "distanceMeters" : 199.99999988971103,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 80.31931018829346,
      "elapsedDurationSeconds" : 80.31931018829346,
      "endOffsetSeconds" : 993.6681799888611,
      "index" : 3,
      "label" : "Recovery 1",
      "maxHeartRateBpm" : 139,
      "paceSecondsPerKm" : 401.5965511629256,
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 5.3 m",
      "startOffsetSeconds" : 913.3488698005676,
      "stepType" : "recovery"
    },
    {
      "averageHeartRateBpm" : 132.82758620689654,
      "averagePower" : 191.71428571428572,
      "boundaryAdjustmentSeconds" : 0.8433437347412109,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3008.972686202731,
          "endDate" : "2026-06-28T12:16:55Z",
          "endOffsetSeconds" : 1247.792739391327,
          "startCumulativeDistanceMeters" : 3002.1666004285216,
          "startDate" : "2026-06-28T12:16:53Z",
          "startOffsetSeconds" : 1245.220088005066
        },
        "cumulativeDistanceAtEndMeters" : 3008.972686202731,
        "cumulativeDistanceAtStartMeters" : 2606.741575512875,
        "interpolationFraction" : 0.6721888668652315,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3015.980726758251,
          "endDate" : "2026-06-28T12:16:58Z",
          "endOffsetSeconds" : 1250.3653898239136,
          "startCumulativeDistanceMeters" : 3008.972686202731,
          "startDate" : "2026-06-28T12:16:55Z",
          "startOffsetSeconds" : 1247.792739391327
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3002.1666004285216,
          "endDate" : "2026-06-28T12:16:53Z",
          "endOffsetSeconds" : 1245.220088005066,
          "startCumulativeDistanceMeters" : 2995.8075044613797,
          "startDate" : "2026-06-28T12:16:50Z",
          "startOffsetSeconds" : 1242.64743745327
        },
        "targetDistanceMeters" : 400
      },
      "boundaryOvershootMeters" : 2.2311106898559956,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "displayDurationSeconds" : 254.12455940246582,
      "distanceMeters" : 402.231110689856,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 254.12455940246582,
      "elapsedDurationSeconds" : 254.12455940246582,
      "endOffsetSeconds" : 1247.792739391327,
      "index" : 4,
      "label" : "Work 2",
      "maxHeartRateBpm" : 143,
      "paceSecondsPerKm" : 631.7874292881609,
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +0.8s, overshoot 2.2 m",
      "startOffsetSeconds" : 993.6681799888611,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 137.06666666666666,
      "averagePower" : 187.9,
      "boundaryAdjustmentSeconds" : 0.7787050008773804,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3210.6465108818375,
          "endDate" : "2026-06-28T12:18:13Z",
          "endOffsetSeconds" : 1324.9725812673569,
          "startCumulativeDistanceMeters" : 3205.116585821379,
          "startDate" : "2026-06-28T12:18:10Z",
          "startOffsetSeconds" : 1322.399922132492
        },
        "cumulativeDistanceAtEndMeters" : 3210.6465108818375,
        "cumulativeDistanceAtStartMeters" : 3008.972686202731,
        "interpolationFraction" : 0.6973151243811433,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3218.291202292079,
          "endDate" : "2026-06-28T12:18:15Z",
          "endOffsetSeconds" : 1327.5452395677567,
          "startCumulativeDistanceMeters" : 3210.6465108818375,
          "startDate" : "2026-06-28T12:18:13Z",
          "startOffsetSeconds" : 1324.9725812673569
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3205.116585821379,
          "endDate" : "2026-06-28T12:18:10Z",
          "endOffsetSeconds" : 1322.399922132492,
          "startCumulativeDistanceMeters" : 3197.732171587879,
          "startDate" : "2026-06-28T12:18:08Z",
          "startOffsetSeconds" : 1319.8272610902786
        },
        "targetDistanceMeters" : 200
      },
      "boundaryOvershootMeters" : 1.673824679106474,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "displayDurationSeconds" : 77.17984187602997,
      "distanceMeters" : 201.67382467910647,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 77.17984187602997,
      "elapsedDurationSeconds" : 77.17984187602997,
      "endOffsetSeconds" : 1324.9725812673569,
      "index" : 5,
      "label" : "Recovery 2",
      "maxHeartRateBpm" : 140,
      "paceSecondsPerKm" : 382.6963761848359,
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +0.8s, overshoot 1.7 m",
      "startOffsetSeconds" : 1247.792739391327,
      "stepType" : "recovery"
    },
    {
      "averageHeartRateBpm" : 138.0625,
      "averagePower" : 188.9672131147541,
      "boundaryAdjustmentSeconds" : 0,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3617.4849921695422,
          "endDate" : "2026-06-28T12:20:50Z",
          "endOffsetSeconds" : 1481.9051848649979,
          "startCumulativeDistanceMeters" : 3610.253568961518,
          "startDate" : "2026-06-28T12:20:47Z",
          "startOffsetSeconds" : 1479.3325083255768
        },
        "cumulativeDistanceAtEndMeters" : 3617.4849921695422,
        "cumulativeDistanceAtStartMeters" : 3210.6465108818375,
        "interpolationFraction" : 0.0543381169952194,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3624.960858784383,
          "endDate" : "2026-06-28T12:20:52Z",
          "endOffsetSeconds" : 1484.4778615236282,
          "startCumulativeDistanceMeters" : 3617.4849921695422,
          "startDate" : "2026-06-28T12:20:50Z",
          "startOffsetSeconds" : 1481.9051848649979
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3610.253568961518,
          "endDate" : "2026-06-28T12:20:47Z",
          "endOffsetSeconds" : 1479.3325083255768,
          "startCumulativeDistanceMeters" : 3605.1508841284085,
          "startDate" : "2026-06-28T12:20:44Z",
          "startOffsetSeconds" : 1476.7598305940628
        },
        "targetDistanceMeters" : 400
      },
      "boundaryOvershootMeters" : 6.838481287704781,
      "boundaryStrategy" : "interpolatedCrossing",
      "confidence" : "high",
      "displayDurationSeconds" : 154.49972140789032,
      "distanceMeters" : 399.99999986193234,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 154.49972140789032,
      "elapsedDurationSeconds" : 154.49972140789032,
      "endOffsetSeconds" : 1479.4723026752472,
      "index" : 6,
      "label" : "Work 3",
      "maxHeartRateBpm" : 142,
      "paceSecondsPerKm" : 386.24930365304715,
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 6.8 m",
      "startOffsetSeconds" : 1324.9725812673569,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 130.5625,
      "averagePower" : 184.9655172413793,
      "boundaryAdjustmentSeconds" : 0,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3816.4216885545757,
          "endDate" : "2026-06-28T12:23:39Z",
          "endOffsetSeconds" : 1651.7022296190262,
          "startCumulativeDistanceMeters" : 3809.162908170838,
          "startDate" : "2026-06-28T12:23:37Z",
          "startOffsetSeconds" : 1649.1295337677002
        },
        "cumulativeDistanceAtEndMeters" : 3816.4216885545757,
        "cumulativeDistanceAtStartMeters" : 3610.64651074377,
        "interpolationFraction" : 0.20438730675137687,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3822.170322339749,
          "endDate" : "2026-06-28T12:23:42Z",
          "endOffsetSeconds" : 1654.2749242782593,
          "startCumulativeDistanceMeters" : 3816.4216885545757,
          "startDate" : "2026-06-28T12:23:39Z",
          "startOffsetSeconds" : 1651.7022296190262
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3809.162908170838,
          "endDate" : "2026-06-28T12:23:37Z",
          "endOffsetSeconds" : 1649.1295337677002,
          "startCumulativeDistanceMeters" : 3801.872482735431,
          "startDate" : "2026-06-28T12:23:34Z",
          "startOffsetSeconds" : 1646.5568379163742
        },
        "targetDistanceMeters" : 200
      },
      "boundaryOvershootMeters" : 5.775177810805872,
      "boundaryStrategy" : "interpolatedCrossing",
      "confidence" : "high",
      "displayDurationSeconds" : 170.1830574274063,
      "distanceMeters" : 199.99999988378477,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 170.1830574274063,
      "elapsedDurationSeconds" : 170.1830574274063,
      "endOffsetSeconds" : 1649.6553601026535,
      "index" : 7,
      "label" : "Recovery 3",
      "maxHeartRateBpm" : 142,
      "paceSecondsPerKm" : 850.9152876314781,
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 5.8 m",
      "startOffsetSeconds" : 1479.4723026752472,
      "stepType" : "recovery"
    },
    {
      "averageHeartRateBpm" : 135.06451612903226,
      "averagePower" : 193.10169491525423,
      "boundaryAdjustmentSeconds" : 0,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 4216.947955140844,
          "endDate" : "2026-06-28T12:26:11Z",
          "endOffsetSeconds" : 1803.4901200532913,
          "startCumulativeDistanceMeters" : 4210.577201077016,
          "startDate" : "2026-06-28T12:26:09Z",
          "startOffsetSeconds" : 1800.917450428009
        },
        "cumulativeDistanceAtEndMeters" : 4216.947955140844,
        "cumulativeDistanceAtStartMeters" : 3810.6465106275546,
        "interpolationFraction" : 0.010879332312013087,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 4224.853167099878,
          "endDate" : "2026-06-28T12:26:14Z",
          "endOffsetSeconds" : 1806.0627888441086,
          "startCumulativeDistanceMeters" : 4216.947955140844,
          "startDate" : "2026-06-28T12:26:11Z",
          "startOffsetSeconds" : 1803.4901200532913
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 4210.577201077016,
          "endDate" : "2026-06-28T12:26:09Z",
          "endOffsetSeconds" : 1800.917450428009,
          "startCumulativeDistanceMeters" : 4202.831100488547,
          "startDate" : "2026-06-28T12:26:06Z",
          "startOffsetSeconds" : 1798.3447815179825
        },
        "targetDistanceMeters" : 400
      },
      "boundaryOvershootMeters" : 6.301444513289425,
      "boundaryStrategy" : "interpolatedCrossing",
      "confidence" : "high",
      "displayDurationSeconds" : 151.29007923603058,
      "distanceMeters" : 399.99999995763665,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 151.29007923603058,
      "elapsedDurationSeconds" : 151.29007923603058,
      "endOffsetSeconds" : 1800.945439338684,
      "index" : 8,
      "label" : "Work 4",
      "maxHeartRateBpm" : 139,
      "paceSecondsPerKm" : 378.22519813013366,
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 6.3 m",
      "startOffsetSeconds" : 1649.6553601026535,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 137.86666666666667,
      "averagePower" : 193.24137931034483,
      "boundaryAdjustmentSeconds" : 0,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 4413.469541205093,
          "endDate" : "2026-06-28T12:27:26Z",
          "endOffsetSeconds" : 1878.0977107286453,
          "startCumulativeDistanceMeters" : 4407.379815821536,
          "startDate" : "2026-06-28T12:27:23Z",
          "startOffsetSeconds" : 1875.5250316858292
        },
        "cumulativeDistanceAtEndMeters" : 4413.469541205093,
        "cumulativeDistanceAtStartMeters" : 4210.646510585191,
        "interpolationFraction" : 0.5364272701812783,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 4420.479328559944,
          "endDate" : "2026-06-28T12:27:28Z",
          "endOffsetSeconds" : 1880.6703870296478,
          "startCumulativeDistanceMeters" : 4413.469541205093,
          "startDate" : "2026-06-28T12:27:26Z",
          "startOffsetSeconds" : 1878.0977107286453
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 4407.379815821536,
          "endDate" : "2026-06-28T12:27:23Z",
          "endOffsetSeconds" : 1875.5250316858292,
          "startCumulativeDistanceMeters" : 4400.469880877528,
          "startDate" : "2026-06-28T12:27:21Z",
          "startOffsetSeconds" : 1872.9523557424545
        },
        "targetDistanceMeters" : 200
      },
      "boundaryOvershootMeters" : 2.823030619902056,
      "boundaryStrategy" : "interpolatedCrossing",
      "confidence" : "high",
      "displayDurationSeconds" : 75.95964753627777,
      "distanceMeters" : 199.99999998376734,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 75.95964753627777,
      "elapsedDurationSeconds" : 75.95964753627777,
      "endOffsetSeconds" : 1876.9050868749619,
      "index" : 9,
      "label" : "Recovery 4",
      "maxHeartRateBpm" : 140,
      "paceSecondsPerKm" : 379.79823771221453,
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 2.8 m",
      "startOffsetSeconds" : 1800.945439338684,
      "stepType" : "recovery"
    },
    {
      "averageHeartRateBpm" : 137.8181818181818,
      "averagePower" : 187.63087248322148,
      "boundaryAdjustmentSeconds" : 0.6169360876083374,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 5412.3129852188285,
          "endDate" : "2026-06-28T12:35:29Z",
          "endOffsetSeconds" : 2361.763771176338,
          "startCumulativeDistanceMeters" : 5405.3635165004525,
          "startDate" : "2026-06-28T12:35:27Z",
          "startOffsetSeconds" : 2359.1910477876663
        },
        "cumulativeDistanceAtEndMeters" : 5412.3129852188285,
        "cumulativeDistanceAtStartMeters" : 4410.646510568959,
        "interpolationFraction" : 0.7602011437991727,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 5418.960445047356,
          "endDate" : "2026-06-28T12:35:32Z",
          "endOffsetSeconds" : 2364.336494088173,
          "startCumulativeDistanceMeters" : 5412.3129852188285,
          "startDate" : "2026-06-28T12:35:29Z",
          "startOffsetSeconds" : 2361.763771176338
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 5405.3635165004525,
          "endDate" : "2026-06-28T12:35:27Z",
          "endOffsetSeconds" : 2359.1910477876663,
          "startCumulativeDistanceMeters" : 5399.508401080035,
          "startDate" : "2026-06-28T12:35:24Z",
          "startOffsetSeconds" : 2356.618324279785
        },
        "targetDistanceMeters" : 1000
      },
      "boundaryOvershootMeters" : 1.666474649869997,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "displayDurationSeconds" : 484.85868430137634,
      "distanceMeters" : 1001.66647464987,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 484.85868430137634,
      "elapsedDurationSeconds" : 484.85868430137634,
      "endOffsetSeconds" : 2361.763771176338,
      "index" : 10,
      "label" : "Cooldown",
      "maxHeartRateBpm" : 144,
      "paceSecondsPerKm" : 484.0520238743714,
      "plannedGoalDisplayText" : "1 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 1000,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +0.6s, overshoot 1.7 m",
      "startOffsetSeconds" : 1876.9050868749619,
      "stepType" : "cooldown"
    },
    {
      "averageHeartRateBpm" : 142.84313725490196,
      "averagePower" : 185.05154639175257,
      "confidence" : "medium",
      "displayDurationSeconds" : 250.6228119134903,
      "distanceMeters" : 622.6377170816995,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 250.6228119134903,
      "elapsedDurationSeconds" : 250.6228119134903,
      "endOffsetSeconds" : 2612.3865830898285,
      "index" : 11,
      "label" : "Open \/ Extra",
      "maxHeartRateBpm" : 146,
      "paceSecondsPerKm" : 402.51787682917507,
      "plannedGoalDisplayText" : "Open",
      "plannedGoalType" : "open",
      "sourceNote" : "Extra tail after planned WorkoutKit steps",
      "startOffsetSeconds" : 2361.763771176338,
      "stepType" : "open",
      "tailDiagnostics" : {
        "creationReason" : "Remaining workout time or distance exceeded Open \/ Extra threshold after planned WorkoutKit steps.",
        "finalDistanceSampleCumulativeDistanceMeters" : 6034.950702300528,
        "finalDistanceSampleOffsetSeconds" : 2606.173961162567,
        "lastCadenceSampleOffsetSeconds" : 2611.3194534778595,
        "lastHeartRateSampleOffsetSeconds" : 2609.373922944069,
        "lastPowerSampleOffsetSeconds" : 2608.746708512306,
        "plannedFinalStepEndOffsetSeconds" : 2361.763771176338,
        "remainingMeters" : 622.6377170816995,
        "remainingSeconds" : 250.6228119134903,
        "workoutEndOffsetSeconds" : 2612.3865830898285
      }
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
      "averageHeartRateBpm" : 123.6923076923077,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1007.4891590430527,
      "durationSeconds" : 381.1363214254379,
      "endOffsetSeconds" : 381.1363214254379,
      "index" : 1,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 378.303148976267,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 125.66666666666667,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1615.5672539270272,
      "durationSeconds" : 612.6977468729019,
      "endOffsetSeconds" : 612.6977468729019,
      "index" : 2,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 379.24620308042995,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 130.02631578947367,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 999.0932708913358,
      "durationSeconds" : 378.012770652771,
      "endOffsetSeconds" : 759.1490920782089,
      "index" : 3,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 378.35583690352445,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 381.1363214254379
    },
    {
      "averageHeartRateBpm" : 134.59349593495935,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1613.3145518476822,
      "durationSeconds" : 718.7276104688644,
      "endOffsetSeconds" : 1331.4253573417664,
      "index" : 4,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 445.4975067606789,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 612.6977468729019
    },
    {
      "averageHeartRateBpm" : 134.73333333333332,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1003.1120157750015,
      "durationSeconds" : 488.90860509872437,
      "endOffsetSeconds" : 1248.0576971769333,
      "index" : 5,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 487.391834022639,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 759.1490920782089
    },
    {
      "averageHeartRateBpm" : 135.25316455696202,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1000.4094793633872,
      "durationSeconds" : 477.2606816291809,
      "endOffsetSeconds" : 1725.3183788061142,
      "index" : 6,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 477.06533322023984,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1248.0576971769333
    },
    {
      "averageHeartRateBpm" : 136.904,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1605.1607813299452,
      "durationSeconds" : 709.9290187358856,
      "endOffsetSeconds" : 2041.354376077652,
      "index" : 7,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 442.27907072815395,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1331.4253573417664
    },
    {
      "averageHeartRateBpm" : 136.84415584415584,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1001.0184087067182,
      "durationSeconds" : 482.4048389196396,
      "endOffsetSeconds" : 2207.723217725754,
      "index" : 8,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 481.9140534517145,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1725.3183788061142
    },
    {
      "averageHeartRateBpm" : 139.59139784946237,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1200.9081151958735,
      "durationSeconds" : 567.3923324346542,
      "endOffsetSeconds" : 2608.746708512306,
      "index" : 9,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 472.4693964967586,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 2041.354376077652
    },
    {
      "averageHeartRateBpm" : 141.9090909090909,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 998.7594388601501,
      "durationSeconds" : 388.50510430336,
      "endOffsetSeconds" : 2596.2283220291138,
      "index" : 10,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 388.9876672872775,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 2207.723217725754
    },
    {
      "averageHeartRateBpm" : 141,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event is a raw HealthKit marker until interval parity is proven.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 25.06892966088253,
      "durationSeconds" : 12.518386483192444,
      "endOffsetSeconds" : 2608.746708512306,
      "index" : 11,
      "label" : "unknown",
      "markerKind" : "rawSegmentMarker",
      "paceSecondsPerKm" : 499.3586344743744,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 2596.2283220291138
    }
  ],
  "sourceNotes" : [
    "Plan source: WorkoutKit",
    "Window source: Plan-derived from HealthKit distance\/time samples",
    "Stats source: HealthKit samples",
    "HealthKit segment markers: not used"
  ],
  "workout" : {
    "averageHeartRate" : 133.81764576886525,
    "averagePower" : 187.99664053751408,
    "cadenceSpm" : 174.5515573593598,
    "deviceName" : "Apple Watch Apple Inc. Watch",
    "distanceMeters" : 6032.0831415861885,
    "durationSeconds" : 2319.0149290561676,
    "elapsedSeconds" : 2612.3865830898285,
    "endDate" : "2026-06-28T12:39:40Z",
    "id" : "C75E6F78-0762-450A-94F6-72878DA8EC55",
    "maxHeartRate" : 146,
    "paceSecondsPerKm" : 384.446778106968,
    "sourceID" : "C75E6F78-0762-450A-94F6-72878DA8EC55",
    "sourceName" : "Adriel’s Apple Watch",
    "startDate" : "2026-06-28T11:56:08Z"
  },
  "workoutActivities" : [
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 758.989070057869,
      "durationSeconds" : 762.0643080472946,
      "endDate" : "2026-06-28T12:08:50Z",
      "endOffsetSeconds" : 762.0643080472946,
      "events" : [
        {
          "durationSeconds" : 381.1363214254379,
          "endDate" : "2026-06-28T12:02:29Z",
          "endOffsetSeconds" : 381.1363214254379,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1007.4891590430527,
          "renderedSegmentMarkerDurationSeconds" : 381.1363214254379,
          "renderedSegmentMarkerEndOffsetSeconds" : 381.1363214254379,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T11:56:08Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 612.6977468729019,
          "endDate" : "2026-06-28T12:06:20Z",
          "endOffsetSeconds" : 612.6977468729019,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1615.5672539270272,
          "renderedSegmentMarkerDurationSeconds" : 612.6977468729019,
          "renderedSegmentMarkerEndOffsetSeconds" : 612.6977468729019,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T11:56:08Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 378.012770652771,
          "endDate" : "2026-06-28T12:08:47Z",
          "endOffsetSeconds" : 759.1490920782089,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 999.0932708913358,
          "renderedSegmentMarkerDurationSeconds" : 378.012770652771,
          "renderedSegmentMarkerEndOffsetSeconds" : 759.1490920782089,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 381.1363214254379,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:02:29Z",
          "startOffsetSeconds" : 381.1363214254379,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 718.7276104688644,
          "endDate" : "2026-06-28T12:18:19Z",
          "endOffsetSeconds" : 1331.4253573417664,
          "index" : 4,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1613.3145518476822,
          "renderedSegmentMarkerDurationSeconds" : 718.7276104688644,
          "renderedSegmentMarkerEndOffsetSeconds" : 1331.4253573417664,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 612.6977468729019,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:06:20Z",
          "startOffsetSeconds" : 612.6977468729019,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 488.90860509872437,
          "endDate" : "2026-06-28T12:16:56Z",
          "endOffsetSeconds" : 1248.0576971769333,
          "index" : 5,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1003.1120157750015,
          "renderedSegmentMarkerDurationSeconds" : 488.90860509872437,
          "renderedSegmentMarkerEndOffsetSeconds" : 1248.0576971769333,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 759.1490920782089,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:08:47Z",
          "startOffsetSeconds" : 759.1490920782089,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "5 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "CCB816CC-2186-4D18-A0E3-952CE704D25F",
      "index" : 1,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -2.9152159690856934,
      "nearestRawEventEndOffsetSeconds" : 759.1490920782089,
      "nearestRawEventStartDeltaSeconds" : 0,
      "nearestRawEventStartOffsetSeconds" : 0,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -3.075237989425659,
      "nearestReconstructedIntervalEndOffsetSeconds" : 758.989070057869,
      "nearestReconstructedIntervalIndex" : 1,
      "nearestReconstructedIntervalLabel" : "Warmup",
      "nearestSegmentMarkerEndDeltaSeconds" : -2.9152159690856934,
      "nearestSegmentMarkerEndOffsetSeconds" : 759.1490920782089,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : 0,
      "nearestSegmentMarkerStartOffsetSeconds" : 0,
      "nextDistanceSampleEndOffsetSeconds" : 761.5617439746857,
      "previousDistanceSampleEndOffsetSeconds" : 756.4163969755173,
      "startDate" : "2026-06-28T11:56:08Z",
      "startOffsetSeconds" : 0,
      "statistics" : [
        {
          "endDate" : "2026-06-28T12:08:50Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T11:56:08Z",
          "sum" : 118.60197571976664,
          "summary" : "ActiveEnergyBurned: sum 118.6 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:08:50Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T11:56:08Z",
          "sum" : 18.661360043425884,
          "summary" : "BasalEnergyBurned: sum 18.7 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:08:50Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T11:56:08Z",
          "sum" : 2007.5993398607307,
          "summary" : "DistanceWalkingRunning: sum 2007.6 m",
          "unit" : "m"
        },
        {
          "average" : 125.80569546072749,
          "endDate" : "2026-06-28T12:08:50Z",
          "maximum" : 135,
          "minimum" : 101,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T11:56:08Z",
          "summary" : "HeartRate: avg 125.8 bpm, min 101.0 bpm, max 135.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 270.7588652482271,
          "endDate" : "2026-06-28T12:08:50Z",
          "maximum" : 286,
          "minimum" : 253,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T11:56:08Z",
          "summary" : "RunningGroundContactTime: avg 270.8 ms, min 253.0 ms, max 286.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 187.85084745762705,
          "endDate" : "2026-06-28T12:08:50Z",
          "maximum" : 201,
          "minimum" : 105,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T11:56:08Z",
          "summary" : "RunningPower: avg 187.9 W, min 105.0 W, max 201.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.6559945083695626,
          "endDate" : "2026-06-28T12:08:50Z",
          "maximum" : 2.8222602894766684,
          "minimum" : 1.8933597885688984,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T11:56:08Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 1.9 m\/s, max 2.8 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.8970422535211264,
          "endDate" : "2026-06-28T12:08:50Z",
          "maximum" : 0.96,
          "minimum" : 0.86,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T11:56:08Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 1.0 m",
          "unit" : "m"
        },
        {
          "average" : 6.848951048951047,
          "endDate" : "2026-06-28T12:08:50Z",
          "maximum" : 7.9,
          "minimum" : 6.2,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T11:56:08Z",
          "summary" : "RunningVerticalOscillation: avg 6.8 cm, min 6.2 cm, max 7.9 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T12:08:50Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T11:56:08Z",
          "sum" : 2245.5627785682063,
          "summary" : "StepCount: sum 2245.6 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 118.6 kcal; BasalEnergyBurned: sum 18.7 kcal; DistanceWalkingRunning: sum 2007.6 m; HeartRate: avg 125.8 bpm, min 101.0 bpm, max 135.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 2,
      "alignedPlannedStepLabel" : "Work 1",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 913.3488698005676,
      "durationSeconds" : 154.01560759544373,
      "endDate" : "2026-06-28T12:11:24Z",
      "endOffsetSeconds" : 916.0799156427383,
      "events" : [
        {
          "durationSeconds" : 718.7276104688644,
          "endDate" : "2026-06-28T12:18:19Z",
          "endOffsetSeconds" : 1331.4253573417664,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1613.3145518476822,
          "renderedSegmentMarkerDurationSeconds" : 718.7276104688644,
          "renderedSegmentMarkerEndOffsetSeconds" : 1331.4253573417664,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 612.6977468729019,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:06:20Z",
          "startOffsetSeconds" : 612.6977468729019,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 488.90860509872437,
          "endDate" : "2026-06-28T12:16:56Z",
          "endOffsetSeconds" : 1248.0576971769333,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1003.1120157750015,
          "renderedSegmentMarkerDurationSeconds" : 488.90860509872437,
          "renderedSegmentMarkerEndOffsetSeconds" : 1248.0576971769333,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 759.1490920782089,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:08:47Z",
          "startOffsetSeconds" : 759.1490920782089,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "2 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "C2E533B4-F74B-42C2-AB45-6382FA48BE22",
      "index" : 2,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -156.93082356452942,
      "nearestRawEventEndOffsetSeconds" : 759.1490920782089,
      "nearestRawEventStartDeltaSeconds" : -2.9152159690856934,
      "nearestRawEventStartOffsetSeconds" : 759.1490920782089,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -2.7310458421707153,
      "nearestReconstructedIntervalEndOffsetSeconds" : 913.3488698005676,
      "nearestReconstructedIntervalIndex" : 2,
      "nearestReconstructedIntervalLabel" : "Work 1",
      "nearestSegmentMarkerEndDeltaSeconds" : -156.93082356452942,
      "nearestSegmentMarkerEndOffsetSeconds" : 759.1490920782089,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -2.9152159690856934,
      "nearestSegmentMarkerStartOffsetSeconds" : 759.1490920782089,
      "nextDistanceSampleEndOffsetSeconds" : 915.9215213060379,
      "previousDistanceSampleEndOffsetSeconds" : 910.7762155532837,
      "startDate" : "2026-06-28T12:08:50Z",
      "startOffsetSeconds" : 762.0643080472946,
      "statistics" : [
        {
          "endDate" : "2026-06-28T12:11:24Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:08:50Z",
          "sum" : 24.670825967627962,
          "summary" : "ActiveEnergyBurned: sum 24.7 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:11:24Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:08:50Z",
          "sum" : 3.7715719358860484,
          "summary" : "BasalEnergyBurned: sum 3.8 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:11:24Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:08:50Z",
          "sum" : 399.4827774724778,
          "summary" : "DistanceWalkingRunning: sum 399.5 m",
          "unit" : "m"
        },
        {
          "average" : 135.62935961392,
          "endDate" : "2026-06-28T12:11:24Z",
          "maximum" : 140,
          "minimum" : 132,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:08:50Z",
          "summary" : "HeartRate: avg 135.6 bpm, min 132.0 bpm, max 140.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 272.9642857142858,
          "endDate" : "2026-06-28T12:11:24Z",
          "maximum" : 286,
          "minimum" : 262,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:08:50Z",
          "summary" : "RunningGroundContactTime: avg 273.0 ms, min 262.0 ms, max 286.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 187.06666666666666,
          "endDate" : "2026-06-28T12:11:24Z",
          "maximum" : 196,
          "minimum" : 179,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:08:50Z",
          "summary" : "RunningPower: avg 187.1 W, min 179.0 W, max 196.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.6221052878703404,
          "endDate" : "2026-06-28T12:11:24Z",
          "maximum" : 2.741666093707778,
          "minimum" : 2.5023231701708575,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:08:50Z",
          "summary" : "RunningSpeed: avg 2.6 m\/s, min 2.5 m\/s, max 2.7 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.8975000000000001,
          "endDate" : "2026-06-28T12:11:24Z",
          "maximum" : 0.92,
          "minimum" : 0.86,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:08:50Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 6.751851851851852,
          "endDate" : "2026-06-28T12:11:24Z",
          "maximum" : 7.000000000000001,
          "minimum" : 6.3,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:08:50Z",
          "summary" : "RunningVerticalOscillation: avg 6.8 cm, min 6.3 cm, max 7.0 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T12:11:24Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:08:50Z",
          "sum" : 445.8066325137627,
          "summary" : "StepCount: sum 445.8 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 24.7 kcal; BasalEnergyBurned: sum 3.8 kcal; DistanceWalkingRunning: sum 399.5 m; HeartRate: avg 135.6 bpm, min 132.0 bpm, max 140.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 3,
      "alignedPlannedStepLabel" : "Recovery 1",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 995.6732603311539,
      "durationSeconds" : 80.5305939912796,
      "endDate" : "2026-06-28T12:12:44Z",
      "endOffsetSeconds" : 996.610509634018,
      "events" : [
        {
          "durationSeconds" : 718.7276104688644,
          "endDate" : "2026-06-28T12:18:19Z",
          "endOffsetSeconds" : 1331.4253573417664,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1613.3145518476822,
          "renderedSegmentMarkerDurationSeconds" : 718.7276104688644,
          "renderedSegmentMarkerEndOffsetSeconds" : 1331.4253573417664,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 612.6977468729019,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:06:20Z",
          "startOffsetSeconds" : 612.6977468729019,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 488.90860509872437,
          "endDate" : "2026-06-28T12:16:56Z",
          "endOffsetSeconds" : 1248.0576971769333,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1003.1120157750015,
          "renderedSegmentMarkerDurationSeconds" : 488.90860509872437,
          "renderedSegmentMarkerEndOffsetSeconds" : 1248.0576971769333,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 759.1490920782089,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:08:47Z",
          "startOffsetSeconds" : 759.1490920782089,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "2 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "44261A76-0FC5-410F-B81C-4E868235441F",
      "index" : 3,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -237.46141755580902,
      "nearestRawEventEndOffsetSeconds" : 759.1490920782089,
      "nearestRawEventStartDeltaSeconds" : -156.93082356452942,
      "nearestRawEventStartOffsetSeconds" : 759.1490920782089,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -2.9423296451568604,
      "nearestReconstructedIntervalEndOffsetSeconds" : 993.6681799888611,
      "nearestReconstructedIntervalIndex" : 3,
      "nearestReconstructedIntervalLabel" : "Recovery 1",
      "nearestSegmentMarkerEndDeltaSeconds" : -237.46141755580902,
      "nearestSegmentMarkerEndOffsetSeconds" : 759.1490920782089,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -156.93082356452942,
      "nearestSegmentMarkerStartOffsetSeconds" : 759.1490920782089,
      "nextDistanceSampleEndOffsetSeconds" : 998.2458863258362,
      "previousDistanceSampleEndOffsetSeconds" : 993.100634932518,
      "startDate" : "2026-06-28T12:11:24Z",
      "startOffsetSeconds" : 916.0799156427383,
      "statistics" : [
        {
          "endDate" : "2026-06-28T12:12:44Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:11:24Z",
          "sum" : 13.484562285148769,
          "summary" : "ActiveEnergyBurned: sum 13.5 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:12:44Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:11:24Z",
          "sum" : 1.9720731024195957,
          "summary" : "BasalEnergyBurned: sum 2.0 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:12:44Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:11:24Z",
          "sum" : 200.63646509495607,
          "summary" : "DistanceWalkingRunning: sum 200.6 m",
          "unit" : "m"
        },
        {
          "average" : 135.7120958953188,
          "endDate" : "2026-06-28T12:12:44Z",
          "maximum" : 139,
          "minimum" : 134,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:11:24Z",
          "summary" : "HeartRate: avg 135.7 bpm, min 134.0 bpm, max 139.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 274.57142857142856,
          "endDate" : "2026-06-28T12:12:44Z",
          "maximum" : 294,
          "minimum" : 259,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:11:24Z",
          "summary" : "RunningGroundContactTime: avg 274.6 ms, min 259.0 ms, max 294.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 181.45161290322577,
          "endDate" : "2026-06-28T12:12:44Z",
          "maximum" : 194,
          "minimum" : 172,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:11:24Z",
          "summary" : "RunningPower: avg 181.5 W, min 172.0 W, max 194.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.5373692053785004,
          "endDate" : "2026-06-28T12:12:44Z",
          "maximum" : 2.7200070734454256,
          "minimum" : 2.4009897288908313,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:11:24Z",
          "summary" : "RunningSpeed: avg 2.5 m\/s, min 2.4 m\/s, max 2.7 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.8707142857142857,
          "endDate" : "2026-06-28T12:12:44Z",
          "maximum" : 0.91,
          "minimum" : 0.83,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:11:24Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.8 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 6.873333333333334,
          "endDate" : "2026-06-28T12:12:44Z",
          "maximum" : 7.199999999999999,
          "minimum" : 6.7,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:11:24Z",
          "summary" : "RunningVerticalOscillation: avg 6.9 cm, min 6.7 cm, max 7.2 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T12:12:44Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:11:24Z",
          "sum" : 234.54511844482994,
          "summary" : "StepCount: sum 234.5 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 13.5 kcal; BasalEnergyBurned: sum 2.0 kcal; DistanceWalkingRunning: sum 200.6 m; HeartRate: avg 135.7 bpm, min 134.0 bpm, max 139.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1247.792739391327,
      "durationSeconds" : 152.26964581012726,
      "endDate" : "2026-06-28T12:16:59Z",
      "endOffsetSeconds" : 1250.9163414239883,
      "events" : [
        {
          "durationSeconds" : 718.7276104688644,
          "endDate" : "2026-06-28T12:18:19Z",
          "endOffsetSeconds" : 1331.4253573417664,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1613.3145518476822,
          "renderedSegmentMarkerDurationSeconds" : 718.7276104688644,
          "renderedSegmentMarkerEndOffsetSeconds" : 1331.4253573417664,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 612.6977468729019,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:06:20Z",
          "startOffsetSeconds" : 612.6977468729019,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 488.90860509872437,
          "endDate" : "2026-06-28T12:16:56Z",
          "endOffsetSeconds" : 1248.0576971769333,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1003.1120157750015,
          "renderedSegmentMarkerDurationSeconds" : 488.90860509872437,
          "renderedSegmentMarkerEndOffsetSeconds" : 1248.0576971769333,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 759.1490920782089,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:08:47Z",
          "startOffsetSeconds" : 759.1490920782089,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 0,
          "endDate" : "2026-06-28T12:14:08Z",
          "endOffsetSeconds" : 1079.9637800455093,
          "excludedOrFilteredReason" : "zeroOrNegativeDuration",
          "index" : 3,
          "metadataKeys" : [

          ],
          "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
          "startDate" : "2026-06-28T12:14:08Z",
          "startOffsetSeconds" : 1079.9637800455093,
          "type" : "HKWorkoutEventType(rawValue: 1)",
          "usedBySegmentMarkerRendering" : false
        },
        {
          "durationSeconds" : 0,
          "endDate" : "2026-06-28T12:15:50Z",
          "endOffsetSeconds" : 1181.9999660253525,
          "excludedOrFilteredReason" : "zeroOrNegativeDuration",
          "index" : 4,
          "metadataKeys" : [

          ],
          "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
          "startDate" : "2026-06-28T12:15:50Z",
          "startOffsetSeconds" : 1181.9999660253525,
          "type" : "HKWorkoutEventType(rawValue: 2)",
          "usedBySegmentMarkerRendering" : false
        },
        {
          "durationSeconds" : 477.2606816291809,
          "endDate" : "2026-06-28T12:24:53Z",
          "endOffsetSeconds" : 1725.3183788061142,
          "index" : 5,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1000.4094793633872,
          "renderedSegmentMarkerDurationSeconds" : 477.2606816291809,
          "renderedSegmentMarkerEndOffsetSeconds" : 1725.3183788061142,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1248.0576971769333,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:16:56Z",
          "startOffsetSeconds" : 1248.0576971769333,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "5 event(s): HKWorkoutEventType(rawValue: 1), HKWorkoutEventType(rawValue: 2), HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "A8A68DC0-DC7E-4FBE-A6C7-282AAB1A1F70",
      "index" : 4,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -2.8586442470550537,
      "nearestRawEventEndOffsetSeconds" : 1248.0576971769333,
      "nearestRawEventStartDeltaSeconds" : 83.3532704114914,
      "nearestRawEventStartOffsetSeconds" : 1079.9637800455093,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -3.123602032661438,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1247.792739391327,
      "nearestReconstructedIntervalIndex" : 4,
      "nearestReconstructedIntervalLabel" : "Work 2",
      "nearestSegmentMarkerEndDeltaSeconds" : -2.8586442470550537,
      "nearestSegmentMarkerEndOffsetSeconds" : 1248.0576971769333,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -237.46141755580902,
      "nearestSegmentMarkerStartOffsetSeconds" : 759.1490920782089,
      "nextDistanceSampleEndOffsetSeconds" : 1250.3653898239136,
      "previousDistanceSampleEndOffsetSeconds" : 1245.220088005066,
      "startDate" : "2026-06-28T12:12:44Z",
      "startOffsetSeconds" : 996.610509634018,
      "statistics" : [
        {
          "endDate" : "2026-06-28T12:16:59Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:12:44Z",
          "sum" : 24.6447458872852,
          "summary" : "ActiveEnergyBurned: sum 24.6 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:16:59Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:12:44Z",
          "sum" : 3.729986317292824,
          "summary" : "BasalEnergyBurned: sum 3.7 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:16:59Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:12:44Z",
          "sum" : 399.8873653672717,
          "summary" : "DistanceWalkingRunning: sum 399.9 m",
          "unit" : "m"
        },
        {
          "average" : 131.58494779090634,
          "endDate" : "2026-06-28T12:16:59Z",
          "maximum" : 143,
          "minimum" : 112,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:12:44Z",
          "summary" : "HeartRate: avg 131.6 bpm, min 112.0 bpm, max 143.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 268.62499999999994,
          "endDate" : "2026-06-28T12:16:59Z",
          "maximum" : 277,
          "minimum" : 251,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:12:44Z",
          "summary" : "RunningGroundContactTime: avg 268.6 ms, min 251.0 ms, max 277.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 191.98214285714286,
          "endDate" : "2026-06-28T12:16:59Z",
          "maximum" : 217,
          "minimum" : 137,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:12:44Z",
          "summary" : "RunningPower: avg 192.0 W, min 137.0 W, max 217.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.6757988360510785,
          "endDate" : "2026-06-28T12:16:59Z",
          "maximum" : 3.0490439866876407,
          "minimum" : 1.5495742606540885,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:12:44Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 1.5 m\/s, max 3.0 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9035999999999998,
          "endDate" : "2026-06-28T12:16:59Z",
          "maximum" : 1.02,
          "minimum" : 0.75,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:12:44Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.8 m, max 1.0 m",
          "unit" : "m"
        },
        {
          "average" : 6.8999999999999995,
          "endDate" : "2026-06-28T12:16:59Z",
          "maximum" : 7.3,
          "minimum" : 6.6000000000000005,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:12:44Z",
          "summary" : "RunningVerticalOscillation: avg 6.9 cm, min 6.6 cm, max 7.3 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T12:16:59Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:12:44Z",
          "sum" : 437.87745638043384,
          "summary" : "StepCount: sum 437.9 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 24.6 kcal; BasalEnergyBurned: sum 3.7 kcal; DistanceWalkingRunning: sum 399.9 m; HeartRate: avg 131.6 bpm, min 112.0 bpm, max 143.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 5,
      "alignedPlannedStepLabel" : "Recovery 2",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1324.9725812673569,
      "durationSeconds" : 76.03076446056366,
      "endDate" : "2026-06-28T12:18:15Z",
      "endOffsetSeconds" : 1326.947105884552,
      "events" : [
        {
          "durationSeconds" : 718.7276104688644,
          "endDate" : "2026-06-28T12:18:19Z",
          "endOffsetSeconds" : 1331.4253573417664,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1613.3145518476822,
          "renderedSegmentMarkerDurationSeconds" : 718.7276104688644,
          "renderedSegmentMarkerEndOffsetSeconds" : 1331.4253573417664,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 612.6977468729019,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:06:20Z",
          "startOffsetSeconds" : 612.6977468729019,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 477.2606816291809,
          "endDate" : "2026-06-28T12:24:53Z",
          "endOffsetSeconds" : 1725.3183788061142,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1000.4094793633872,
          "renderedSegmentMarkerDurationSeconds" : 477.2606816291809,
          "renderedSegmentMarkerEndOffsetSeconds" : 1725.3183788061142,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1248.0576971769333,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:16:56Z",
          "startOffsetSeconds" : 1248.0576971769333,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "2 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "B8BFA5BD-45AA-438E-8BF9-4DADC83F5956",
      "index" : 5,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : 4.4782514572143555,
      "nearestRawEventEndOffsetSeconds" : 1331.4253573417664,
      "nearestRawEventStartDeltaSeconds" : -2.8586442470550537,
      "nearestRawEventStartOffsetSeconds" : 1248.0576971769333,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -1.9745246171951294,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1324.9725812673569,
      "nearestReconstructedIntervalIndex" : 5,
      "nearestReconstructedIntervalLabel" : "Recovery 2",
      "nearestSegmentMarkerEndDeltaSeconds" : 4.4782514572143555,
      "nearestSegmentMarkerEndOffsetSeconds" : 1331.4253573417664,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -2.8586442470550537,
      "nearestSegmentMarkerStartOffsetSeconds" : 1248.0576971769333,
      "nextDistanceSampleEndOffsetSeconds" : 1327.5452395677567,
      "previousDistanceSampleEndOffsetSeconds" : 1322.399922132492,
      "startDate" : "2026-06-28T12:16:59Z",
      "startOffsetSeconds" : 1250.9163414239883,
      "statistics" : [
        {
          "endDate" : "2026-06-28T12:18:15Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:16:59Z",
          "sum" : 12.414372958456884,
          "summary" : "ActiveEnergyBurned: sum 12.4 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:18:15Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:16:59Z",
          "sum" : 1.8618608285113936,
          "summary" : "BasalEnergyBurned: sum 1.9 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:18:15Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:16:59Z",
          "sum" : 198.88731493982795,
          "summary" : "DistanceWalkingRunning: sum 198.9 m",
          "unit" : "m"
        },
        {
          "average" : 136.7916669020304,
          "endDate" : "2026-06-28T12:18:15Z",
          "maximum" : 140,
          "minimum" : 131,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:16:59Z",
          "summary" : "HeartRate: avg 136.8 bpm, min 131.0 bpm, max 140.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 268.25000000000006,
          "endDate" : "2026-06-28T12:18:15Z",
          "maximum" : 271,
          "minimum" : 266,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:16:59Z",
          "summary" : "RunningGroundContactTime: avg 268.3 ms, min 266.0 ms, max 271.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 187.68965517241378,
          "endDate" : "2026-06-28T12:18:15Z",
          "maximum" : 193,
          "minimum" : 179,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:16:59Z",
          "summary" : "RunningPower: avg 187.7 W, min 179.0 W, max 193.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.6535405116341444,
          "endDate" : "2026-06-28T12:18:15Z",
          "maximum" : 2.7374848394425366,
          "minimum" : 2.522335114737745,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:16:59Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 2.5 m\/s, max 2.7 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9291666666666666,
          "endDate" : "2026-06-28T12:18:15Z",
          "maximum" : 0.96,
          "minimum" : 0.86,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:16:59Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 1.0 m",
          "unit" : "m"
        },
        {
          "average" : 7.025,
          "endDate" : "2026-06-28T12:18:15Z",
          "maximum" : 7.3999999999999995,
          "minimum" : 6.800000000000001,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:16:59Z",
          "summary" : "RunningVerticalOscillation: avg 7.0 cm, min 6.8 cm, max 7.4 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T12:18:15Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:16:59Z",
          "sum" : 211.87342513525894,
          "summary" : "StepCount: sum 211.9 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 12.4 kcal; BasalEnergyBurned: sum 1.9 kcal; DistanceWalkingRunning: sum 198.9 m; HeartRate: avg 136.8 bpm, min 131.0 bpm, max 140.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 6,
      "alignedPlannedStepLabel" : "Work 3",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1481.9051848649979,
      "durationSeconds" : 154.37865257263184,
      "endDate" : "2026-06-28T12:20:49Z",
      "endOffsetSeconds" : 1481.3257584571838,
      "events" : [
        {
          "durationSeconds" : 718.7276104688644,
          "endDate" : "2026-06-28T12:18:19Z",
          "endOffsetSeconds" : 1331.4253573417664,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1613.3145518476822,
          "renderedSegmentMarkerDurationSeconds" : 718.7276104688644,
          "renderedSegmentMarkerEndOffsetSeconds" : 1331.4253573417664,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 612.6977468729019,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:06:20Z",
          "startOffsetSeconds" : 612.6977468729019,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 477.2606816291809,
          "endDate" : "2026-06-28T12:24:53Z",
          "endOffsetSeconds" : 1725.3183788061142,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1000.4094793633872,
          "renderedSegmentMarkerDurationSeconds" : 477.2606816291809,
          "renderedSegmentMarkerEndOffsetSeconds" : 1725.3183788061142,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1248.0576971769333,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:16:56Z",
          "startOffsetSeconds" : 1248.0576971769333,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 709.9290187358856,
          "endDate" : "2026-06-28T12:30:09Z",
          "endOffsetSeconds" : 2041.354376077652,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1605.1607813299452,
          "renderedSegmentMarkerDurationSeconds" : 709.9290187358856,
          "renderedSegmentMarkerEndOffsetSeconds" : 2041.354376077652,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1331.4253573417664,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:18:19Z",
          "startOffsetSeconds" : 1331.4253573417664,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "3 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "72C8FD82-E333-4113-9808-DFF97A898261",
      "index" : 6,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -149.90040111541748,
      "nearestRawEventEndOffsetSeconds" : 1331.4253573417664,
      "nearestRawEventStartDeltaSeconds" : 4.4782514572143555,
      "nearestRawEventStartOffsetSeconds" : 1331.4253573417664,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -1.8534557819366455,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1479.4723026752472,
      "nearestReconstructedIntervalIndex" : 6,
      "nearestReconstructedIntervalLabel" : "Work 3",
      "nearestSegmentMarkerEndDeltaSeconds" : -149.90040111541748,
      "nearestSegmentMarkerEndOffsetSeconds" : 1331.4253573417664,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : 4.4782514572143555,
      "nearestSegmentMarkerStartOffsetSeconds" : 1331.4253573417664,
      "nextDistanceSampleEndOffsetSeconds" : 1484.4778615236282,
      "previousDistanceSampleEndOffsetSeconds" : 1479.3325083255768,
      "startDate" : "2026-06-28T12:18:15Z",
      "startOffsetSeconds" : 1326.947105884552,
      "statistics" : [
        {
          "endDate" : "2026-06-28T12:20:49Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:18:15Z",
          "sum" : 24.54555854786688,
          "summary" : "ActiveEnergyBurned: sum 24.5 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:20:49Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:18:15Z",
          "sum" : 3.780458207498967,
          "summary" : "BasalEnergyBurned: sum 3.8 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:20:49Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:18:15Z",
          "sum" : 399.7435025745493,
          "summary" : "DistanceWalkingRunning: sum 399.7 m",
          "unit" : "m"
        },
        {
          "average" : 138.2147807443894,
          "endDate" : "2026-06-28T12:20:49Z",
          "maximum" : 142,
          "minimum" : 133,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:18:15Z",
          "summary" : "HeartRate: avg 138.2 bpm, min 133.0 bpm, max 142.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 272.57142857142856,
          "endDate" : "2026-06-28T12:20:49Z",
          "maximum" : 280,
          "minimum" : 266,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:18:15Z",
          "summary" : "RunningGroundContactTime: avg 272.6 ms, min 266.0 ms, max 280.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 188.98333333333338,
          "endDate" : "2026-06-28T12:20:49Z",
          "maximum" : 194,
          "minimum" : 184,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:18:15Z",
          "summary" : "RunningPower: avg 189.0 W, min 184.0 W, max 194.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.6755761902799113,
          "endDate" : "2026-06-28T12:20:49Z",
          "maximum" : 2.7558302661346668,
          "minimum" : 2.6139916342845573,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:18:15Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 2.6 m\/s, max 2.8 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9078571428571429,
          "endDate" : "2026-06-28T12:20:49Z",
          "maximum" : 0.92,
          "minimum" : 0.89,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:18:15Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 7.064285714285715,
          "endDate" : "2026-06-28T12:20:49Z",
          "maximum" : 7.6,
          "minimum" : 6.5,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:18:15Z",
          "summary" : "RunningVerticalOscillation: avg 7.1 cm, min 6.5 cm, max 7.6 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T12:20:49Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:18:15Z",
          "sum" : 447.8256890092221,
          "summary" : "StepCount: sum 447.8 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 24.5 kcal; BasalEnergyBurned: sum 3.8 kcal; DistanceWalkingRunning: sum 399.7 m; HeartRate: avg 138.2 bpm, min 133.0 bpm, max 142.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 7,
      "alignedPlannedStepLabel" : "Recovery 3",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1651.7022296190262,
      "durationSeconds" : 77.81419610977173,
      "endDate" : "2026-06-28T12:23:40Z",
      "endOffsetSeconds" : 1652.2844905853271,
      "events" : [
        {
          "durationSeconds" : 477.2606816291809,
          "endDate" : "2026-06-28T12:24:53Z",
          "endOffsetSeconds" : 1725.3183788061142,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1000.4094793633872,
          "renderedSegmentMarkerDurationSeconds" : 477.2606816291809,
          "renderedSegmentMarkerEndOffsetSeconds" : 1725.3183788061142,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1248.0576971769333,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:16:56Z",
          "startOffsetSeconds" : 1248.0576971769333,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 709.9290187358856,
          "endDate" : "2026-06-28T12:30:09Z",
          "endOffsetSeconds" : 2041.354376077652,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1605.1607813299452,
          "renderedSegmentMarkerDurationSeconds" : 709.9290187358856,
          "renderedSegmentMarkerEndOffsetSeconds" : 2041.354376077652,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1331.4253573417664,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:18:19Z",
          "startOffsetSeconds" : 1331.4253573417664,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 0,
          "endDate" : "2026-06-28T12:21:22Z",
          "endOffsetSeconds" : 1514.0749130249023,
          "excludedOrFilteredReason" : "zeroOrNegativeDuration",
          "index" : 3,
          "metadataKeys" : [

          ],
          "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
          "startDate" : "2026-06-28T12:21:22Z",
          "startOffsetSeconds" : 1514.0749130249023,
          "type" : "HKWorkoutEventType(rawValue: 1)",
          "usedBySegmentMarkerRendering" : false
        },
        {
          "durationSeconds" : 0,
          "endDate" : "2026-06-28T12:22:55Z",
          "endOffsetSeconds" : 1607.219449043274,
          "excludedOrFilteredReason" : "zeroOrNegativeDuration",
          "index" : 4,
          "metadataKeys" : [

          ],
          "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
          "startDate" : "2026-06-28T12:22:55Z",
          "startOffsetSeconds" : 1607.219449043274,
          "type" : "HKWorkoutEventType(rawValue: 2)",
          "usedBySegmentMarkerRendering" : false
        }
      ],
      "eventsSummary" : "4 event(s): HKWorkoutEventType(rawValue: 1), HKWorkoutEventType(rawValue: 2), HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "6170AB8A-C2BD-4394-BCA1-5E769F087EF8",
      "index" : 7,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : 73.03388822078705,
      "nearestRawEventEndOffsetSeconds" : 1725.3183788061142,
      "nearestRawEventStartDeltaSeconds" : 32.749154567718506,
      "nearestRawEventStartOffsetSeconds" : 1514.0749130249023,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -2.629130482673645,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1649.6553601026535,
      "nearestReconstructedIntervalIndex" : 7,
      "nearestReconstructedIntervalLabel" : "Recovery 3",
      "nearestSegmentMarkerEndDeltaSeconds" : 73.03388822078705,
      "nearestSegmentMarkerEndOffsetSeconds" : 1725.3183788061142,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -149.90040111541748,
      "nearestSegmentMarkerStartOffsetSeconds" : 1331.4253573417664,
      "nextDistanceSampleEndOffsetSeconds" : 1654.2749242782593,
      "previousDistanceSampleEndOffsetSeconds" : 1649.1295337677002,
      "startDate" : "2026-06-28T12:20:49Z",
      "startOffsetSeconds" : 1481.3257584571838,
      "statistics" : [
        {
          "endDate" : "2026-06-28T12:23:40Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:20:49Z",
          "sum" : 12.643840562858577,
          "summary" : "ActiveEnergyBurned: sum 12.6 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:23:40Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:20:49Z",
          "sum" : 1.969444842983428,
          "summary" : "BasalEnergyBurned: sum 2.0 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:23:40Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:20:49Z",
          "sum" : 201.70141390102268,
          "summary" : "DistanceWalkingRunning: sum 201.7 m",
          "unit" : "m"
        },
        {
          "average" : 131.5721900361816,
          "endDate" : "2026-06-28T12:23:40Z",
          "maximum" : 142,
          "minimum" : 116,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:20:49Z",
          "summary" : "HeartRate: avg 131.6 bpm, min 116.0 bpm, max 142.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 273.6363636363636,
          "endDate" : "2026-06-28T12:23:40Z",
          "maximum" : 275,
          "minimum" : 270,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:20:49Z",
          "summary" : "RunningGroundContactTime: avg 273.6 ms, min 270.0 ms, max 275.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 185.06666666666666,
          "endDate" : "2026-06-28T12:23:40Z",
          "maximum" : 205,
          "minimum" : 84,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:20:49Z",
          "summary" : "RunningPower: avg 185.1 W, min 84.0 W, max 205.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.6216423840432865,
          "endDate" : "2026-06-28T12:23:40Z",
          "maximum" : 2.871921492955483,
          "minimum" : 1.4221608393296687,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:20:49Z",
          "summary" : "RunningSpeed: avg 2.6 m\/s, min 1.4 m\/s, max 2.9 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9175000000000001,
          "endDate" : "2026-06-28T12:23:40Z",
          "maximum" : 0.94,
          "minimum" : 0.91,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:20:49Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 7.091666666666667,
          "endDate" : "2026-06-28T12:23:40Z",
          "maximum" : 7.7,
          "minimum" : 6.7,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:20:49Z",
          "summary" : "RunningVerticalOscillation: avg 7.1 cm, min 6.7 cm, max 7.7 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T12:23:40Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:20:49Z",
          "sum" : 218.6297488831895,
          "summary" : "StepCount: sum 218.6 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 12.6 kcal; BasalEnergyBurned: sum 2.0 kcal; DistanceWalkingRunning: sum 201.7 m; HeartRate: avg 131.6 bpm, min 116.0 bpm, max 142.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 8,
      "alignedPlannedStepLabel" : "Work 4",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1803.4901200532913,
      "durationSeconds" : 151.21675550937653,
      "endDate" : "2026-06-28T12:26:11Z",
      "endOffsetSeconds" : 1803.5012460947037,
      "events" : [
        {
          "durationSeconds" : 477.2606816291809,
          "endDate" : "2026-06-28T12:24:53Z",
          "endOffsetSeconds" : 1725.3183788061142,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1000.4094793633872,
          "renderedSegmentMarkerDurationSeconds" : 477.2606816291809,
          "renderedSegmentMarkerEndOffsetSeconds" : 1725.3183788061142,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1248.0576971769333,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:16:56Z",
          "startOffsetSeconds" : 1248.0576971769333,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 709.9290187358856,
          "endDate" : "2026-06-28T12:30:09Z",
          "endOffsetSeconds" : 2041.354376077652,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1605.1607813299452,
          "renderedSegmentMarkerDurationSeconds" : 709.9290187358856,
          "renderedSegmentMarkerEndOffsetSeconds" : 2041.354376077652,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1331.4253573417664,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:18:19Z",
          "startOffsetSeconds" : 1331.4253573417664,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 482.4048389196396,
          "endDate" : "2026-06-28T12:32:55Z",
          "endOffsetSeconds" : 2207.723217725754,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1001.0184087067182,
          "renderedSegmentMarkerDurationSeconds" : 482.4048389196396,
          "renderedSegmentMarkerEndOffsetSeconds" : 2207.723217725754,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1725.3183788061142,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:24:53Z",
          "startOffsetSeconds" : 1725.3183788061142,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "3 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "B0155AE2-279E-47A8-9FAB-F605C4C81345",
      "index" : 8,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -78.18286728858948,
      "nearestRawEventEndOffsetSeconds" : 1725.3183788061142,
      "nearestRawEventStartDeltaSeconds" : -45.06504154205322,
      "nearestRawEventStartOffsetSeconds" : 1607.219449043274,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -2.5558067560195923,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1800.945439338684,
      "nearestReconstructedIntervalIndex" : 8,
      "nearestReconstructedIntervalLabel" : "Work 4",
      "nearestSegmentMarkerEndDeltaSeconds" : -78.18286728858948,
      "nearestSegmentMarkerEndOffsetSeconds" : 1725.3183788061142,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : 73.03388822078705,
      "nearestSegmentMarkerStartOffsetSeconds" : 1725.3183788061142,
      "nextDistanceSampleEndOffsetSeconds" : 1806.0627888441086,
      "previousDistanceSampleEndOffsetSeconds" : 1800.917450428009,
      "startDate" : "2026-06-28T12:23:40Z",
      "startOffsetSeconds" : 1652.2844905853271,
      "statistics" : [
        {
          "endDate" : "2026-06-28T12:26:11Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:23:40Z",
          "sum" : 24.23949172358428,
          "summary" : "ActiveEnergyBurned: sum 24.2 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:26:11Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:23:40Z",
          "sum" : 3.7030140832917176,
          "summary" : "BasalEnergyBurned: sum 3.7 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:26:11Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:23:40Z",
          "sum" : 399.7990128031827,
          "summary" : "DistanceWalkingRunning: sum 399.8 m",
          "unit" : "m"
        },
        {
          "average" : 135.15386772375632,
          "endDate" : "2026-06-28T12:26:11Z",
          "maximum" : 139,
          "minimum" : 130,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:23:40Z",
          "summary" : "HeartRate: avg 135.2 bpm, min 130.0 bpm, max 139.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 273.7037037037036,
          "endDate" : "2026-06-28T12:26:11Z",
          "maximum" : 281,
          "minimum" : 266,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:23:40Z",
          "summary" : "RunningGroundContactTime: avg 273.7 ms, min 266.0 ms, max 281.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 193.18644067796612,
          "endDate" : "2026-06-28T12:26:11Z",
          "maximum" : 197,
          "minimum" : 188,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:23:40Z",
          "summary" : "RunningPower: avg 193.2 W, min 188.0 W, max 197.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.7118250076770507,
          "endDate" : "2026-06-28T12:26:11Z",
          "maximum" : 2.7651157725992563,
          "minimum" : 2.6334838502467246,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:23:40Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 2.6 m\/s, max 2.8 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9092857142857143,
          "endDate" : "2026-06-28T12:26:11Z",
          "maximum" : 0.92,
          "minimum" : 0.89,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:23:40Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 6.996551724137931,
          "endDate" : "2026-06-28T12:26:11Z",
          "maximum" : 7.3999999999999995,
          "minimum" : 6.7,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:23:40Z",
          "summary" : "RunningVerticalOscillation: avg 7.0 cm, min 6.7 cm, max 7.4 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T12:26:11Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:23:40Z",
          "sum" : 445.22401057672187,
          "summary" : "StepCount: sum 445.2 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 24.2 kcal; BasalEnergyBurned: sum 3.7 kcal; DistanceWalkingRunning: sum 399.8 m; HeartRate: avg 135.2 bpm, min 130.0 bpm, max 139.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 9,
      "alignedPlannedStepLabel" : "Recovery 4",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1878.0977107286453,
      "durationSeconds" : 75.76058650016785,
      "endDate" : "2026-06-28T12:27:27Z",
      "endOffsetSeconds" : 1879.2618325948715,
      "events" : [
        {
          "durationSeconds" : 709.9290187358856,
          "endDate" : "2026-06-28T12:30:09Z",
          "endOffsetSeconds" : 2041.354376077652,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1605.1607813299452,
          "renderedSegmentMarkerDurationSeconds" : 709.9290187358856,
          "renderedSegmentMarkerEndOffsetSeconds" : 2041.354376077652,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1331.4253573417664,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:18:19Z",
          "startOffsetSeconds" : 1331.4253573417664,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 482.4048389196396,
          "endDate" : "2026-06-28T12:32:55Z",
          "endOffsetSeconds" : 2207.723217725754,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1001.0184087067182,
          "renderedSegmentMarkerDurationSeconds" : 482.4048389196396,
          "renderedSegmentMarkerEndOffsetSeconds" : 2207.723217725754,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1725.3183788061142,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:24:53Z",
          "startOffsetSeconds" : 1725.3183788061142,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "2 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "2D5C9B58-ECE2-4E92-B027-E17459C4B11E",
      "index" : 9,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -153.94345378875732,
      "nearestRawEventEndOffsetSeconds" : 1725.3183788061142,
      "nearestRawEventStartDeltaSeconds" : -78.18286728858948,
      "nearestRawEventStartOffsetSeconds" : 1725.3183788061142,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -2.356745719909668,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1876.9050868749619,
      "nearestReconstructedIntervalIndex" : 9,
      "nearestReconstructedIntervalLabel" : "Recovery 4",
      "nearestSegmentMarkerEndDeltaSeconds" : -153.94345378875732,
      "nearestSegmentMarkerEndOffsetSeconds" : 1725.3183788061142,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -78.18286728858948,
      "nearestSegmentMarkerStartOffsetSeconds" : 1725.3183788061142,
      "nextDistanceSampleEndOffsetSeconds" : 1880.6703870296478,
      "previousDistanceSampleEndOffsetSeconds" : 1875.5250316858292,
      "startDate" : "2026-06-28T12:26:11Z",
      "startOffsetSeconds" : 1803.5012460947037,
      "statistics" : [
        {
          "endDate" : "2026-06-28T12:27:27Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:26:11Z",
          "sum" : 12.175275486177654,
          "summary" : "ActiveEnergyBurned: sum 12.2 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:27:27Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:26:11Z",
          "sum" : 1.8552346953211427,
          "summary" : "BasalEnergyBurned: sum 1.9 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:27:27Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:26:11Z",
          "sum" : 199.53063031146732,
          "summary" : "DistanceWalkingRunning: sum 199.5 m",
          "unit" : "m"
        },
        {
          "average" : 137.92241378876244,
          "endDate" : "2026-06-28T12:27:27Z",
          "maximum" : 140,
          "minimum" : 136,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:26:11Z",
          "summary" : "HeartRate: avg 137.9 bpm, min 136.0 bpm, max 140.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 273.6,
          "endDate" : "2026-06-28T12:27:27Z",
          "maximum" : 281,
          "minimum" : 260,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:26:11Z",
          "summary" : "RunningGroundContactTime: avg 273.6 ms, min 260.0 ms, max 281.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 193.20689655172413,
          "endDate" : "2026-06-28T12:27:27Z",
          "maximum" : 198,
          "minimum" : 189,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:26:11Z",
          "summary" : "RunningPower: avg 193.2 W, min 189.0 W, max 198.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.7153361965165814,
          "endDate" : "2026-06-28T12:27:27Z",
          "maximum" : 2.7958481698221482,
          "minimum" : 2.6540053151234644,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:26:11Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 2.7 m\/s, max 2.8 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9135714285714286,
          "endDate" : "2026-06-28T12:27:27Z",
          "maximum" : 0.92,
          "minimum" : 0.9,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:26:11Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 7.046153846153846,
          "endDate" : "2026-06-28T12:27:27Z",
          "maximum" : 7.7,
          "minimum" : 6.4,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:26:11Z",
          "summary" : "RunningVerticalOscillation: avg 7.0 cm, min 6.4 cm, max 7.7 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T12:27:27Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:26:11Z",
          "sum" : 221.13286380774332,
          "summary" : "StepCount: sum 221.1 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 12.2 kcal; BasalEnergyBurned: sum 1.9 kcal; DistanceWalkingRunning: sum 199.5 m; HeartRate: avg 137.9 bpm, min 136.0 bpm, max 140.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 10,
      "alignedPlannedStepLabel" : "Cooldown",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 2361.763771176338,
      "durationSeconds" : 383.7713840007782,
      "endDate" : "2026-06-28T12:35:29Z",
      "endOffsetSeconds" : 2361.224148631096,
      "events" : [
        {
          "durationSeconds" : 709.9290187358856,
          "endDate" : "2026-06-28T12:30:09Z",
          "endOffsetSeconds" : 2041.354376077652,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1605.1607813299452,
          "renderedSegmentMarkerDurationSeconds" : 709.9290187358856,
          "renderedSegmentMarkerEndOffsetSeconds" : 2041.354376077652,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1331.4253573417664,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:18:19Z",
          "startOffsetSeconds" : 1331.4253573417664,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 482.4048389196396,
          "endDate" : "2026-06-28T12:32:55Z",
          "endOffsetSeconds" : 2207.723217725754,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1001.0184087067182,
          "renderedSegmentMarkerDurationSeconds" : 482.4048389196396,
          "renderedSegmentMarkerEndOffsetSeconds" : 2207.723217725754,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1725.3183788061142,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:24:53Z",
          "startOffsetSeconds" : 1725.3183788061142,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 567.3923324346542,
          "endDate" : "2026-06-28T12:39:36Z",
          "endOffsetSeconds" : 2608.746708512306,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1200.9081151958735,
          "renderedSegmentMarkerDurationSeconds" : 567.3923324346542,
          "renderedSegmentMarkerEndOffsetSeconds" : 2608.746708512306,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 2041.354376077652,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:30:09Z",
          "startOffsetSeconds" : 2041.354376077652,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 0,
          "endDate" : "2026-06-28T12:30:13Z",
          "endOffsetSeconds" : 2045.4134089946747,
          "excludedOrFilteredReason" : "zeroOrNegativeDuration",
          "index" : 4,
          "metadataKeys" : [

          ],
          "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
          "startDate" : "2026-06-28T12:30:13Z",
          "startOffsetSeconds" : 2045.4134089946747,
          "type" : "HKWorkoutEventType(rawValue: 1)",
          "usedBySegmentMarkerRendering" : false
        },
        {
          "durationSeconds" : 0,
          "endDate" : "2026-06-28T12:31:51Z",
          "endOffsetSeconds" : 2143.604341030121,
          "excludedOrFilteredReason" : "zeroOrNegativeDuration",
          "index" : 5,
          "metadataKeys" : [

          ],
          "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
          "startDate" : "2026-06-28T12:31:51Z",
          "startOffsetSeconds" : 2143.604341030121,
          "type" : "HKWorkoutEventType(rawValue: 2)",
          "usedBySegmentMarkerRendering" : false
        },
        {
          "durationSeconds" : 388.50510430336,
          "endDate" : "2026-06-28T12:39:24Z",
          "endOffsetSeconds" : 2596.2283220291138,
          "index" : 6,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 998.7594388601501,
          "renderedSegmentMarkerDurationSeconds" : 388.50510430336,
          "renderedSegmentMarkerEndOffsetSeconds" : 2596.2283220291138,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 2207.723217725754,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:32:55Z",
          "startOffsetSeconds" : 2207.723217725754,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "6 event(s): HKWorkoutEventType(rawValue: 1), HKWorkoutEventType(rawValue: 2), HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "77CD3DDF-E34B-437D-803A-E09BB1C2E16E",
      "index" : 10,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath"
      ],
      "nearestRawEventEndDeltaSeconds" : -153.5009309053421,
      "nearestRawEventEndOffsetSeconds" : 2207.723217725754,
      "nearestRawEventStartDeltaSeconds" : -153.94345378875732,
      "nearestRawEventStartOffsetSeconds" : 1725.3183788061142,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : 0.5396225452423096,
      "nearestReconstructedIntervalEndOffsetSeconds" : 2361.763771176338,
      "nearestReconstructedIntervalIndex" : 10,
      "nearestReconstructedIntervalLabel" : "Cooldown",
      "nearestSegmentMarkerEndDeltaSeconds" : -153.5009309053421,
      "nearestSegmentMarkerEndOffsetSeconds" : 2207.723217725754,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -153.94345378875732,
      "nearestSegmentMarkerStartOffsetSeconds" : 1725.3183788061142,
      "nextDistanceSampleEndOffsetSeconds" : 2364.336494088173,
      "previousDistanceSampleEndOffsetSeconds" : 2359.1910477876663,
      "startDate" : "2026-06-28T12:27:27Z",
      "startOffsetSeconds" : 1879.2618325948715,
      "statistics" : [
        {
          "endDate" : "2026-06-28T12:35:29Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:27:27Z",
          "sum" : 64.46531385495483,
          "summary" : "ActiveEnergyBurned: sum 64.5 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:35:29Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:27:27Z",
          "sum" : 9.398328026566421,
          "summary" : "BasalEnergyBurned: sum 9.4 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:35:29Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:27:27Z",
          "sum" : 994.0000370784959,
          "summary" : "DistanceWalkingRunning: sum 994.0 m",
          "unit" : "m"
        },
        {
          "average" : 136.97391303181644,
          "endDate" : "2026-06-28T12:35:29Z",
          "maximum" : 144,
          "minimum" : 114,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:27:27Z",
          "summary" : "HeartRate: avg 137.0 bpm, min 114.0 bpm, max 144.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 273.9402985074627,
          "endDate" : "2026-06-28T12:35:29Z",
          "maximum" : 294,
          "minimum" : 257,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:27:27Z",
          "summary" : "RunningGroundContactTime: avg 273.9 ms, min 257.0 ms, max 294.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 187.6190476190476,
          "endDate" : "2026-06-28T12:35:29Z",
          "maximum" : 201,
          "minimum" : 86,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:27:27Z",
          "summary" : "RunningPower: avg 187.6 W, min 86.0 W, max 201.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.6640747709692443,
          "endDate" : "2026-06-28T12:35:29Z",
          "maximum" : 2.889337885177201,
          "minimum" : 1.4399857548483346,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:27:27Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 1.4 m\/s, max 2.9 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9150746268656716,
          "endDate" : "2026-06-28T12:35:29Z",
          "maximum" : 0.98,
          "minimum" : 0.87,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:27:27Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 1.0 m",
          "unit" : "m"
        },
        {
          "average" : 7.080882352941177,
          "endDate" : "2026-06-28T12:35:29Z",
          "maximum" : 7.6,
          "minimum" : 6.7,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:27:27Z",
          "summary" : "RunningVerticalOscillation: avg 7.1 cm, min 6.7 cm, max 7.6 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T12:35:29Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:27:27Z",
          "sum" : 1112.3643053578276,
          "summary" : "StepCount: sum 1112.4 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 64.5 kcal; BasalEnergyBurned: sum 9.4 kcal; DistanceWalkingRunning: sum 994.0 m; HeartRate: avg 137.0 bpm, min 114.0 bpm, max 144.0 bpm"
    }
  ],
  "workoutKitPlanAudit" : {
    "displayName" : "Priority 1 (pause work2,recovery3, cooldow",
    "planID" : "6CF7534F-0CD0-47EA-97C5-788B27D4E049",
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
        "plannedGoalDisplayText" : "1 km",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 1000,
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
      "Cooldown: goal 1 km, alert pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current"
    ]
  }
}
```