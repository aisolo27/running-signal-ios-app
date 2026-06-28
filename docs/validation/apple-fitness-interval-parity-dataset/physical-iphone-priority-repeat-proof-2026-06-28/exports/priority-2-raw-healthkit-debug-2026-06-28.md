# RunSignal Raw HealthKit Debug Export

Generated: 2026-06-28T19:37:18Z

## Review Packet Scope

This packet bundles Raw HealthKit Debug, WorkoutKit plan audit, HealthKit activity rows, Parity Lab candidate rows, structured comparison, fallback labels, pause/tail diagnostics, source metadata, and boundary warnings. It is debug/export-only and does not approve normal workout detail behavior.

Whole-run stats remain usable when custom interval rows are blocked. External HealthFit/FIT archives stay offline validation evidence; attach or reference them separately and do not treat FIT as app input or runtime truth.

Blocked custom interval diagnostics are review aids only. A supported Parity Lab status, readable fallback label, or exported candidate row does not change normal workout detail unless the exact ledger row separately reaches the normal-detail promotion rung.

## Workout

| Field | Value |
|---|---|
| Workout ID | 376F0E84-E296-4F64-9B07-4D9AA085B817 |
| Source | Adriel’s Apple Watch |
| Source ID | 376F0E84-E296-4F64-9B07-4D9AA085B817 |
| Device | Apple Watch Apple Inc. Watch |
| Start | Jun 28, 2026 |
| End | Jun 28, 2026 |
| Duration | 40:30 |
| Elapsed | 40:30 |
| Distance | 5.95 km |
| Avg pace | 6:49 /km |
| Avg HR | 152 bpm |
| Max HR | 169 bpm |
| Cadence | 163 spm |
| Power | 175 W |

## Evidence Counts

| Metric | Count |
|---|---:|
| Heart rate | 485 |
| Speed | 942 |
| Distance | 942 |
| Active energy | 942 |
| Power | 942 |
| Cadence | 942 |
| Step count | 942 |
| Stride length | 382 |
| Vertical oscillation | 386 |
| Ground contact | 382 |
| Route points | 2428 |
| Events | 11 |
| Workout activities | 10 |

## WorkoutKit Plan Audit

- Status: Available
- Plan type: Custom workout
- Plan ID: DFD6B93D-D335-45F5-B2A9-7BE2707A3549
- Display name: Priority 2 (no pause)
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
| 1 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 6:27 | 386.5 s | Unavailable | 0:00-6:27 | 1.01 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 2 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 10:22 | 621.8 s | Unavailable | 0:00-10:22 | 1.62 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 3 | HKWorkoutEventType(rawValue: 7) | Unavailable | 6:27 | 12:53 | 386.0 s | Unavailable | 6:27-12:53 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 4 | HKWorkoutEventType(rawValue: 7) | Unavailable | 10:22 | 20:41 | 618.9 s | Unavailable | 10:22-20:41 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 5 | HKWorkoutEventType(rawValue: 7) | Unavailable | 12:53 | 19:18 | 385.4 s | Unavailable | 12:53-19:18 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 6 | HKWorkoutEventType(rawValue: 7) | Unavailable | 19:18 | 25:38 | 379.9 s | Unavailable | 19:18-25:38 | 1.00 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 7 | HKWorkoutEventType(rawValue: 7) | Unavailable | 20:41 | 30:50 | 609.3 s | Unavailable | 20:41-30:50 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 8 | HKWorkoutEventType(rawValue: 7) | Unavailable | 25:38 | 31:54 | 376.1 s | Unavailable | 25:38-31:54 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 9 | HKWorkoutEventType(rawValue: 7) | Unavailable | 30:50 | 40:26 | 576.1 s | Unavailable | 30:50-40:26 | 1.11 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 10 | HKWorkoutEventType(rawValue: 7) | Unavailable | 31:54 | 40:26 | 512.2 s | Unavailable | 31:54-40:26 | 0.94 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 11 | HKWorkoutEventType(rawValue: 1) | Unavailable | 40:30 | 40:30 | 0.0 s | Unavailable | Unavailable | Unavailable | Unavailable | No | Excluded from segment rendering: zero or negative duration. | No rendered segment marker candidate. |

## HKWorkoutActivity Inventory

Debug-only inventory of public `HKWorkout.workoutActivities` rows. These rows are not used for production interval reconstruction.

| Activity | Type | Start Date | End Date | Start Offset | End Offset | Duration | Metadata Keys | Nested Events | Statistics | Aligns Planned Step | Aligned Planned Step | Nearest Reconstructed Row | Row End Delta | Apple Fitness/manual | FIT Lap | Raw Event Start | Raw Start Delta | Raw Event End | Raw End Delta | Segment Start | Segment Start Delta | Segment End | Segment End Delta | Previous Sample End | Crossing Sample End | Next Sample End |
|---:|---|---|---|---:|---:|---:|---|---|---|---|---|---|---:|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T12:40:31Z | 2026-06-28T12:53:25Z | 0.0 s | 774.9 s | 774.9 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 5 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 140.9 kcal; BasalEnergyBurned: sum 18.9 kcal; DistanceWalkingRunning: sum 2006.5 m; HeartRate: avg 145.6 bpm, min 127.0 bpm, max 154.0 bpm | No | Unavailable | Warmup | -3.2 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 0.0 s | 0.0 s | 772.5 s | -2.4 s | 0.0 s | 0.0 s | 772.5 s | -2.4 s | 769.2 s | 771.8 s | 774.3 s |
| 2 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T12:53:25Z | 2026-06-28T12:56:03Z | 774.9 s | 932.3 s | 157.3 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 2 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 30.6 kcal; BasalEnergyBurned: sum 3.9 kcal; DistanceWalkingRunning: sum 400.5 m; HeartRate: avg 151.6 bpm, min 148.0 bpm, max 157.0 bpm | Yes | Work 1 | Work 1 | -3.0 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 772.5 s | -2.4 s | 772.5 s | -159.7 s | 772.5 s | -2.4 s | 772.5 s | -159.7 s | 928.7 s | 931.3 s | 933.8 s |
| 3 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T12:56:03Z | 2026-06-28T12:57:20Z | 932.3 s | 1009.1 s | 76.9 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 2 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 15.0 kcal; BasalEnergyBurned: sum 1.9 kcal; DistanceWalkingRunning: sum 200.2 m; HeartRate: avg 151.3 bpm, min 149.0 bpm, max 154.0 bpm | No | Unavailable | Recovery 1 | -3.1 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 772.5 s | -159.7 s | 1158.0 s | 148.8 s | 772.5 s | -159.7 s | 1158.0 s | 148.8 s | 1005.9 s | 1008.5 s | 1011.0 s |
| 4 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T12:57:20Z | 2026-06-28T12:59:51Z | 1009.1 s | 1160.7 s | 151.5 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 3 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 29.9 kcal; BasalEnergyBurned: sum 3.7 kcal; DistanceWalkingRunning: sum 400.7 m; HeartRate: avg 152.5 bpm, min 149.0 bpm, max 157.0 bpm | Yes | Work 2 | Work 2 | -3.0 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1158.0 s | 148.8 s | 1158.0 s | -2.7 s | 1158.0 s | 148.8 s | 1158.0 s | -2.7 s | 1155.1 s | 1157.7 s | 1160.2 s |
| 5 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T12:59:51Z | 2026-06-28T13:01:07Z | 1160.7 s | 1236.6 s | 76.0 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 2 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 15.0 kcal; BasalEnergyBurned: sum 1.9 kcal; DistanceWalkingRunning: sum 200.4 m; HeartRate: avg 153.4 bpm, min 150.0 bpm, max 157.0 bpm | No | Unavailable | Recovery 2 | -3.1 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1158.0 s | -2.7 s | 1240.7 s | 4.1 s | 1158.0 s | -2.7 s | 1240.7 s | 4.1 s | 1232.3 s | 1234.9 s | 1237.4 s |
| 6 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T13:01:07Z | 2026-06-28T13:03:39Z | 1236.6 s | 1388.9 s | 152.2 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 3 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 31.4 kcal; BasalEnergyBurned: sum 3.7 kcal; DistanceWalkingRunning: sum 400.3 m; HeartRate: avg 158.6 bpm, min 156.0 bpm, max 161.0 bpm | Yes | Work 3 | Work 3 | -2.2 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1240.7 s | 4.1 s | 1240.7 s | -148.2 s | 1240.7 s | 4.1 s | 1240.7 s | -148.2 s | 1384.1 s | 1386.7 s | 1389.2 s |
| 7 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T13:03:39Z | 2026-06-28T13:04:55Z | 1388.9 s | 1464.1 s | 75.2 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 2 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 15.5 kcal; BasalEnergyBurned: sum 1.8 kcal; DistanceWalkingRunning: sum 197.6 m; HeartRate: avg 158.5 bpm, min 156.0 bpm, max 161.0 bpm | Yes | Recovery 3 | Recovery 3 | -0.3 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1240.7 s | -148.2 s | 1537.9 s | 73.7 s | 1240.7 s | -148.2 s | 1537.9 s | 73.7 s | 1461.3 s | 1463.8 s | 1466.4 s |
| 8 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T13:04:55Z | 2026-06-28T13:07:28Z | 1464.1 s | 1617.5 s | 153.4 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 3 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 31.9 kcal; BasalEnergyBurned: sum 3.8 kcal; DistanceWalkingRunning: sum 401.3 m; HeartRate: avg 159.2 bpm, min 157.0 bpm, max 161.0 bpm | Yes | Work 4 | Work 4 | -1.3 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1537.9 s | 73.7 s | 1537.9 s | -79.7 s | 1537.9 s | 73.7 s | 1537.9 s | -79.7 s | 1615.6 s | 1618.2 s | 1620.8 s |
| 9 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T13:07:28Z | 2026-06-28T13:08:43Z | 1617.5 s | 1692.5 s | 75.0 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 2 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 15.6 kcal; BasalEnergyBurned: sum 1.8 kcal; DistanceWalkingRunning: sum 200.5 m; HeartRate: avg 159.3 bpm, min 158.0 bpm, max 162.0 bpm | Yes | Recovery 4 | Recovery 4 | -1.7 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1537.9 s | -79.7 s | 1537.9 s | -154.6 s | 1537.9 s | -79.7 s | 1537.9 s | -154.6 s | 1690.3 s | 1692.8 s | 1695.4 s |
| 10 | HKWorkoutActivityType(rawValue: 37) | 2026-06-28T13:08:43Z | 2026-06-28T13:14:55Z | 1692.5 s | 2064.9 s | 372.4 s | HKElevationAscended, WOIntervalStepKeyPath | 4 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 80.6 kcal; BasalEnergyBurned: sum 9.1 kcal; DistanceWalkingRunning: sum 999.4 m; HeartRate: avg 165.8 bpm, min 160.0 bpm, max 169.0 bpm | Yes | Cooldown | Cooldown | 1.0 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1537.9 s | -154.6 s | 1913.9 s | -151.0 s | 1537.9 s | -154.6 s | 1913.9 s | -151.0 s | 2063.3 s | 2065.9 s | 2068.5 s |

## WorkoutKit Reconstructed Intervals

Planned structure source: WorkoutKit when available. Measured stats source: HealthKit samples.

| Row | Label | Goal | Target | Distance | Elapsed | Pause overlap | Active time | Display time | Duration rule | Pace | Avg HR | Max HR | Power | Start Offset | End Offset | Boundary Strategy | Boundary Adjustment | Overshoot | Confidence | Notes |
|---:|---|---|---|---:|---:|---:|---:|---:|---|---:|---:|---:|---:|---:|---:|---|---:|---:|---|---|
| 1 | Warmup | 2 km | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 2.01 km | 12:52 |  | Unavailable | 12:52 | elapsedRowWindow | 6:25 /km | 146 bpm | 154 bpm | 187 W | 0:00 | 12:52 | crossing sample end | 1.8 s | 6.0 m | High | Distance-goal boundary: crossing sample end, adjustment +1.8s, overshoot 6.0 m |
| 2 | Work 1 | 400 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.40 km | 2:38 |  | Unavailable | 2:38 | elapsedRowWindow | 6:34 /km | 152 bpm | 157 bpm | 184 W | 12:52 | 15:29 | interpolated crossing | 0.0 s | 4.8 m | High | Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 4.8 m |
| 3 | Recovery 1 | 200 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.20 km | 1:17 |  | Unavailable | 1:17 | elapsedRowWindow | 6:24 /km | 152 bpm | 154 bpm | 187 W | 15:29 | 16:46 | interpolated crossing | 0.0 s | 5.2 m | High | Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 5.2 m |
| 4 | Work 2 | 400 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.40 km | 2:32 |  | Unavailable | 2:32 | elapsedRowWindow | 6:19 /km | 153 bpm | 157 bpm | 188 W | 16:46 | 19:18 | crossing sample end | 0.2 s | 0.6 m | High | Distance-goal boundary: crossing sample end, adjustment +0.2s, overshoot 0.6 m |
| 5 | Recovery 2 | 200 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.20 km | 1:16 |  | Unavailable | 1:16 | elapsedRowWindow | 6:19 /km | 153 bpm | 157 bpm | 191 W | 19:18 | 20:34 | interpolated crossing | 0.0 s | 4.1 m | High | Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 4.1 m |
| 6 | Work 3 | 400 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.40 km | 2:33 |  | Unavailable | 2:33 | elapsedRowWindow | 6:20 /km | 158 bpm | 161 bpm | 193 W | 20:34 | 23:07 | crossing sample end | 1.0 s | 2.9 m | High | Distance-goal boundary: crossing sample end, adjustment +1.0s, overshoot 2.9 m |
| 7 | Recovery 3 | 200 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.20 km | 1:17 |  | Unavailable | 1:17 | elapsedRowWindow | 6:24 /km | 159 bpm | 161 bpm | 192 W | 23:07 | 24:24 | crossing sample end | 0.5 s | 0.9 m | High | Distance-goal boundary: crossing sample end, adjustment +0.5s, overshoot 0.9 m |
| 8 | Work 4 | 400 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.40 km | 2:32 |  | Unavailable | 2:32 | elapsedRowWindow | 6:21 /km | 160 bpm | 161 bpm | 190 W | 24:24 | 26:56 | interpolated crossing | 0.0 s | 4.8 m | High | Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 4.8 m |
| 9 | Recovery 4 | 200 m | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 0.20 km | 1:15 |  | Unavailable | 1:15 | elapsedRowWindow | 6:13 /km | 159 bpm | 162 bpm | 192 W | 26:56 | 28:11 | interpolated crossing | 0.0 s | 5.7 m | High | Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 5.7 m |
| 10 | Cooldown | 1 km | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 1.01 km | 6:15 |  | Unavailable | 6:15 | elapsedRowWindow | 6:13 /km | 166 bpm | 169 bpm | 194 W | 28:11 | 34:26 | crossing sample end | 2.3 s | 6.6 m | High | Distance-goal boundary: crossing sample end, adjustment +2.3s, overshoot 6.6 m |
| 11 | Open / Extra | Open | Target unavailable | 0.53 km | 6:04 |  | Unavailable | 6:04 | elapsedRowWindow | 11:29 /km | 143 bpm | 169 bpm | 92 W | 34:26 | 40:30 |  |  |  | Medium | Extra tail after planned WorkoutKit steps |

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
| 1 | Warmup | 2 km | mappedByPlannedStepOrder | 1 | 0.0 s | 774.9 s | 2006.5 m | 774.9 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 2 | Work 1 | 400 m | mappedByPlannedStepOrder | 2 | 774.9 s | 932.3 s | 400.5 m | 157.3 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 3 | Recovery 1 | 200 m | mappedByPlannedStepOrder | 3 | 932.3 s | 1009.1 s | 200.2 m | 76.9 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 4 | Work 2 | 400 m | mappedByPlannedStepOrder | 4 | 1009.1 s | 1160.7 s | 400.7 m | 151.5 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 5 | Recovery 2 | 200 m | mappedByPlannedStepOrder | 5 | 1160.7 s | 1236.6 s | 200.4 m | 76.0 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 6 | Work 3 | 400 m | mappedByPlannedStepOrder | 6 | 1236.6 s | 1388.9 s | 400.3 m | 152.2 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 7 | Recovery 3 | 200 m | mappedByPlannedStepOrder | 7 | 1388.9 s | 1464.1 s | 197.6 m | 75.2 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 8 | Work 4 | 400 m | mappedByPlannedStepOrder | 8 | 1464.1 s | 1617.5 s | 401.3 m | 153.4 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 9 | Recovery 4 | 200 m | mappedByPlannedStepOrder | 9 | 1617.5 s | 1692.5 s | 200.5 m | 75.0 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 10 | Cooldown | 1 km | mappedByPlannedStepOrder | 10 | 1692.5 s | 2064.9 s | 999.4 m | 372.4 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 11 | Open / Extra | Open | inferredOpenTailFromWorkoutEnd | Inferred | 2064.9 s | 2430.1 s | 538.5 m | 365.2 s | activity boundary inferred tail |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Inferred from workout end minus final mapped activity boundary. No separate HKWorkoutActivity row represented this tail. |

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
| Paired pause count | 0 |
| Total paired pause | 0.0 s |
| Fixed row exhaustion | fixed-rows-exhausted-before-tail |
| Tail status | open-extra-tail-present |
| Tail duration | 365.2 s |
| Tail distance | 538.5 m |
| Fallback reasons |  |
| Safety flags | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. |
| FIT validation | offline-evidence-only-not-runtime-truth |
| Scoreable | Yes |
| Not scoreable reason | n/a |
| Production UI warning | Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI. |

| Row | Label | Mapping | Start offset | End offset | Elapsed | Pause overlap | Active time | Distance | Display rule | Duration rule | Confidence | Caveats |
|---:|---|---|---:|---:|---:|---:|---:|---:|---|---|---|---|
| 1 | Warmup | mappedByPlannedStepOrder | 0.0 s | 774.9 s | 774.9 s | 0.0 s | 774.9 s | 2006.5 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 2 | Work 1 | mappedByPlannedStepOrder | 774.9 s | 932.3 s | 157.3 s | 0.0 s | 157.3 s | 400.5 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 3 | Recovery 1 | mappedByPlannedStepOrder | 932.3 s | 1009.1 s | 76.9 s | 0.0 s | 76.9 s | 200.2 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 4 | Work 2 | mappedByPlannedStepOrder | 1009.1 s | 1160.7 s | 151.5 s | 0.0 s | 151.5 s | 400.7 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 5 | Recovery 2 | mappedByPlannedStepOrder | 1160.7 s | 1236.6 s | 76.0 s | 0.0 s | 76.0 s | 200.4 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 6 | Work 3 | mappedByPlannedStepOrder | 1236.6 s | 1388.9 s | 152.2 s | 0.0 s | 152.2 s | 400.3 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 7 | Recovery 3 | mappedByPlannedStepOrder | 1388.9 s | 1464.1 s | 75.2 s | 0.0 s | 75.2 s | 197.6 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 8 | Work 4 | mappedByPlannedStepOrder | 1464.1 s | 1617.5 s | 153.4 s | 0.0 s | 153.4 s | 401.3 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 9 | Recovery 4 | mappedByPlannedStepOrder | 1617.5 s | 1692.5 s | 75.0 s | 0.0 s | 75.0 s | 200.5 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 10 | Cooldown | mappedByPlannedStepOrder | 1692.5 s | 2064.9 s | 372.4 s | 0.0 s | 372.4 s | 999.4 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 11 | Open / Extra | inferredOpenTailFromWorkoutEnd | 2064.9 s | 2430.1 s | 365.2 s | 0.0 s | 365.2 s | 538.5 m | open-tail-measured-duration | open-tail-measured-duration | activity boundary inferred tail | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Inferred from workout end minus final mapped activity boundary. No separate HKWorkoutActivity row represented this tail. |

Caveats: debug-only, not promoted · not production interval logic · not shown in normal workout UI · FIT and Apple Fitness/manual rows are not runtime inputs · Active duration subtracts paired HealthKit pause/resume overlap when available.

## Custom Workout Structured Comparison

Debug-only structured status and fallback taxonomy for Parity Lab rows. This status is not production interval logic, is not shown in the normal workout UI, and does not approve a normal-detail gate by itself.

| Field | Value |
|---|---|
| Status | open-tail-needs-rule |
| Status label | Open / Extra tail handling needs an approved rule. |
| Fallback reasons | Open / Extra tail handling is ambiguous for this workout shape. |
| Primary fallback | Open / Extra tail handling is ambiguous for this workout shape. |
| Row count | 10 |
| Row confidences | needsRule, needsRule, needsRule, needsRule, needsRule, needsRule, needsRule, needsRule, needsRule, needsRule |
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
| End offset | 12:52 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 1.8 s |
| Overshoot | 6.0 m |
| Cumulative distance at start | 0.0 m |
| Cumulative distance at end | 2006.0 m |
| Interpolation fraction | 0.305 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 12:47 | 12:49 | 1988.2 m | 1997.4 m |
| Crossing | 12:49 | 12:52 | 1997.4 m | 2006.0 m |
| Next | 12:52 | 12:54 | 2006.0 m | 2008.2 m |

### Row 2: Work 1

| Field | Value |
|---|---:|
| Target distance | 400.0 m |
| Start offset | 12:52 |
| End offset | 15:29 |
| Boundary strategy | interpolated crossing |
| Boundary adjustment | 0.0 s |
| Overshoot | 4.8 m |
| Cumulative distance at start | 2006.0 m |
| Cumulative distance at end | 2410.8 m |
| Interpolation fraction | 0.223 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 15:26 | 15:29 | 2397.4 m | 2404.6 m |
| Crossing | 15:29 | 15:31 | 2404.6 m | 2410.8 m |
| Next | 15:31 | 15:34 | 2410.8 m | 2418.3 m |

### Row 3: Recovery 1

| Field | Value |
|---|---:|
| Target distance | 200.0 m |
| Start offset | 15:29 |
| End offset | 16:46 |
| Boundary strategy | interpolated crossing |
| Boundary adjustment | 0.0 s |
| Overshoot | 5.2 m |
| Cumulative distance at start | 2406.0 m |
| Cumulative distance at end | 2611.2 m |
| Interpolation fraction | 0.046 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 16:43 | 16:46 | 2598.5 m | 2605.8 m |
| Crossing | 16:46 | 16:48 | 2605.8 m | 2611.2 m |
| Next | 16:48 | 16:51 | 2611.2 m | 2619.0 m |

### Row 4: Work 2

| Field | Value |
|---|---:|
| Target distance | 400.0 m |
| Start offset | 16:46 |
| End offset | 19:18 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 0.2 s |
| Overshoot | 0.6 m |
| Cumulative distance at start | 2606.0 m |
| Cumulative distance at end | 3006.6 m |
| Interpolation fraction | 0.916 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 19:13 | 19:15 | 2992.1 m | 2999.1 m |
| Crossing | 19:15 | 19:18 | 2999.1 m | 3006.6 m |
| Next | 19:18 | 19:20 | 3006.6 m | 3014.4 m |

### Row 5: Recovery 2

| Field | Value |
|---|---:|
| Target distance | 200.0 m |
| Start offset | 19:18 |
| End offset | 20:34 |
| Boundary strategy | interpolated crossing |
| Boundary adjustment | 0.0 s |
| Overshoot | 4.1 m |
| Cumulative distance at start | 3006.6 m |
| Cumulative distance at end | 3210.8 m |
| Interpolation fraction | 0.485 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 20:30 | 20:32 | 3196.3 m | 3202.8 m |
| Crossing | 20:32 | 20:35 | 3202.8 m | 3210.8 m |
| Next | 20:35 | 20:37 | 3210.8 m | 3216.6 m |

### Row 6: Work 3

| Field | Value |
|---|---:|
| Target distance | 400.0 m |
| Start offset | 20:34 |
| End offset | 23:07 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 1.0 s |
| Overshoot | 2.9 m |
| Cumulative distance at start | 3206.6 m |
| Cumulative distance at end | 3609.6 m |
| Interpolation fraction | 0.616 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 23:02 | 23:04 | 3596.2 m | 3601.9 m |
| Crossing | 23:04 | 23:07 | 3601.9 m | 3609.6 m |
| Next | 23:07 | 23:09 | 3609.6 m | 3616.2 m |

### Row 7: Recovery 3

| Field | Value |
|---|---:|
| Target distance | 200.0 m |
| Start offset | 23:07 |
| End offset | 24:24 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 0.5 s |
| Overshoot | 0.9 m |
| Cumulative distance at start | 3609.6 m |
| Cumulative distance at end | 3810.5 m |
| Interpolation fraction | 0.808 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 24:19 | 24:21 | 3800.0 m | 3805.6 m |
| Crossing | 24:21 | 24:24 | 3805.6 m | 3810.5 m |
| Next | 24:24 | 24:26 | 3810.5 m | 3818.9 m |

### Row 8: Work 4

| Field | Value |
|---|---:|
| Target distance | 400.0 m |
| Start offset | 24:24 |
| End offset | 26:56 |
| Boundary strategy | interpolated crossing |
| Boundary adjustment | 0.0 s |
| Overshoot | 4.8 m |
| Cumulative distance at start | 3810.5 m |
| Cumulative distance at end | 4215.3 m |
| Interpolation fraction | 0.208 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 26:53 | 26:56 | 4202.5 m | 4209.3 m |
| Crossing | 26:56 | 26:58 | 4209.3 m | 4215.3 m |
| Next | 26:58 | 27:01 | 4215.3 m | 4222.8 m |

### Row 9: Recovery 4

| Field | Value |
|---|---:|
| Target distance | 200.0 m |
| Start offset | 26:56 |
| End offset | 28:11 |
| Boundary strategy | interpolated crossing |
| Boundary adjustment | 0.0 s |
| Overshoot | 5.7 m |
| Cumulative distance at start | 4210.5 m |
| Cumulative distance at end | 4416.2 m |
| Interpolation fraction | 0.225 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 28:08 | 28:10 | 4401.9 m | 4408.9 m |
| Crossing | 28:10 | 28:13 | 4408.9 m | 4416.2 m |
| Next | 28:13 | 28:15 | 4416.2 m | 4422.2 m |

### Row 10: Cooldown

| Field | Value |
|---|---:|
| Target distance | 1000.0 m |
| Start offset | 28:11 |
| End offset | 34:26 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 2.3 s |
| Overshoot | 6.6 m |
| Cumulative distance at start | 4410.5 m |
| Cumulative distance at end | 5417.1 m |
| Interpolation fraction | 0.121 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 34:21 | 34:23 | 5403.8 m | 5409.6 m |
| Crossing | 34:23 | 34:26 | 5409.6 m | 5417.1 m |
| Next | 34:26 | 34:28 | 5417.1 m | 5425.1 m |

### Row 11: Open / Extra Tail

| Field | Value |
|---|---:|
| Planned final step end offset | 34:26 |
| Workout end offset | 40:30 |
| Remaining seconds | 364.2 s |
| Remaining meters | 528.7 m |
| Final distance sample offset | 40:24 |
| Final distance sample cumulative | 5945.9 m |
| Last HR sample offset | 40:24 |
| Last power sample offset | 40:26 |
| Last cadence sample offset | 40:24 |
| Reason | Remaining workout time or distance exceeded Open / Extra threshold after planned WorkoutKit steps. |

## HealthKit Segment Markers

Raw debug only. HealthKit Segment Markers must not be promoted as Apple Fitness interval rows.

| Row | Label | Marker Kind | Source | Distance | Time | Pace | Avg HR | Start Offset | End Offset | Confidence | Caveats |
|---:|---|---|---|---:|---:|---:|---:|---:|---:|---|---|
| 1 | Unknown | Split marker | HealthKit segment pattern | 1.01 km | 6:27 | 6:24 /km | 142 bpm | 0:00 | 6:27 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 2 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.62 km | 10:22 | 6:25 /km | 145 bpm | 0:00 | 10:22 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 3 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:26 | 6:26 /km | 150 bpm | 6:27 | 12:53 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 4 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 10:19 | 6:24 /km | 152 bpm | 10:22 | 20:41 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 5 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:25 | 6:25 /km | 152 bpm | 12:53 | 19:18 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 6 | Unknown | Split marker | HealthKit segment pattern | 1.00 km | 6:20 | 6:20 /km | 158 bpm | 19:18 | 25:38 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 7 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 10:09 | 6:18 /km | 161 bpm | 20:41 | 30:50 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 8 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:16 | 6:16 /km | 163 bpm | 25:38 | 31:54 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 9 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.11 km | 9:36 | 8:39 /km | 152 bpm | 30:50 | 40:26 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 10 | Unknown | Overlapping segment marker | HealthKit segment pattern | 0.94 km | 8:32 | 9:05 /km | 150 bpm | 31:54 | 40:26 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |

## Planned Step Boundary Comparison

Debug-only comparison helper for FIT/Apple boundary investigation. The FIT lap end offset is intentionally a manual placeholder; RunSignal does not read FIT at runtime.

| Row | Planned Step | Goal | RunSignal End | FIT Lap End | Nearest Raw Event End | Event Delta | Nearest Activity End | Activity Delta | Activity Type | Nearest Segment End | Segment Delta | Previous Sample End | Crossing Sample End | Next Sample End | Warning |
|---:|---|---|---:|---:|---:|---:|---:|---:|---|---:|---:|---:|---:|---:|---|
| 1 | Warmup | 2 km | 771.8 s | Manual FIT placeholder | 772.5 s | 0.8 s | 774.9 s | 3.2 s | HKWorkoutActivityType(rawValue: 37) | 772.5 s | 0.8 s | 769.2 s | 771.8 s | 774.3 s |  |
| 2 | Work 1 | 400 m | 929.3 s | Manual FIT placeholder | 772.5 s | -156.7 s | 932.3 s | 3.0 s | HKWorkoutActivityType(rawValue: 37) | 772.5 s | -156.7 s | 928.7 s | 931.3 s | 933.8 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 3 | Recovery 1 | 200 m | 1006.0 s | Manual FIT placeholder | 1158.0 s | 152.0 s | 1009.1 s | 3.1 s | HKWorkoutActivityType(rawValue: 37) | 1158.0 s | 152.0 s | 1005.9 s | 1008.5 s | 1011.0 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 4 | Work 2 | 400 m | 1157.7 s | Manual FIT placeholder | 1158.0 s | 0.3 s | 1160.7 s | 3.0 s | HKWorkoutActivityType(rawValue: 37) | 1158.0 s | 0.3 s | 1155.1 s | 1157.7 s | 1160.2 s |  |
| 5 | Recovery 2 | 200 m | 1233.5 s | Manual FIT placeholder | 1240.7 s | 7.2 s | 1236.6 s | 3.1 s | HKWorkoutActivityType(rawValue: 37) | 1240.7 s | 7.2 s | 1232.3 s | 1234.9 s | 1237.4 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 6 | Work 3 | 400 m | 1386.7 s | Manual FIT placeholder | 1240.7 s | -145.9 s | 1388.9 s | 2.2 s | HKWorkoutActivityType(rawValue: 37) | 1240.7 s | -145.9 s | 1384.1 s | 1386.7 s | 1389.2 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 7 | Recovery 3 | 200 m | 1463.8 s | Manual FIT placeholder | 1537.9 s | 74.0 s | 1464.1 s | 0.3 s | HKWorkoutActivityType(rawValue: 37) | 1537.9 s | 74.0 s | 1461.3 s | 1463.8 s | 1466.4 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 8 | Work 4 | 400 m | 1616.2 s | Manual FIT placeholder | 1537.9 s | -78.3 s | 1617.5 s | 1.3 s | HKWorkoutActivityType(rawValue: 37) | 1537.9 s | -78.3 s | 1615.6 s | 1618.2 s | 1620.8 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 9 | Recovery 4 | 200 m | 1690.8 s | Manual FIT placeholder | 1537.9 s | -153.0 s | 1692.5 s | 1.7 s | HKWorkoutActivityType(rawValue: 37) | 1537.9 s | -153.0 s | 1690.3 s | 1692.8 s | 1695.4 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 10 | Cooldown | 1 km | 2065.9 s | Manual FIT placeholder | 1913.9 s | -152.0 s | 2064.9 s | -1.0 s | HKWorkoutActivityType(rawValue: 37) | 1913.9 s | -152.0 s | 2063.3 s | 2065.9 s | 2068.5 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 11 | Open / Extra | Open | 2430.1 s | Manual FIT placeholder | 2426.1 s | -4.0 s | 2064.9 s | -365.2 s | HKWorkoutActivityType(rawValue: 37) | 2426.1 s | -4.0 s | Unavailable | Unavailable | Unavailable | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |

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
      "distanceMeters" : 2006.5409944102787,
      "durationSeconds" : 774.9394506216049,
      "endOffsetSeconds" : 774.9394506216049,
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
      "distanceMeters" : 400.455214654905,
      "durationSeconds" : 157.3156670331955,
      "endOffsetSeconds" : 932.2551176548004,
      "index" : 2,
      "label" : "Work 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 774.9394506216049,
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
      "distanceMeters" : 200.21201621345432,
      "durationSeconds" : 76.88241314888,
      "endOffsetSeconds" : 1009.1375308036804,
      "index" : 3,
      "label" : "Recovery 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 932.2551176548004,
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
      "distanceMeters" : 400.66743088555467,
      "durationSeconds" : 151.52106297016144,
      "endOffsetSeconds" : 1160.6585937738419,
      "index" : 4,
      "label" : "Work 2",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1009.1375308036804,
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
      "distanceMeters" : 200.44888219433057,
      "durationSeconds" : 75.99018025398254,
      "endOffsetSeconds" : 1236.6487740278244,
      "index" : 5,
      "label" : "Recovery 2",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1160.6585937738419,
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
      "distanceMeters" : 400.2513401425558,
      "durationSeconds" : 152.24168384075165,
      "endOffsetSeconds" : 1388.890457868576,
      "index" : 6,
      "label" : "Work 3",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1236.6487740278244,
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
      "distanceMeters" : 197.55514381243003,
      "durationSeconds" : 75.21527469158173,
      "endOffsetSeconds" : 1464.1057325601578,
      "index" : 7,
      "label" : "Recovery 3",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1388.890457868576,
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
      "distanceMeters" : 401.29302189747835,
      "durationSeconds" : 153.40174007415771,
      "endOffsetSeconds" : 1617.5074726343155,
      "index" : 8,
      "label" : "Work 4",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1464.1057325601578,
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
      "distanceMeters" : 200.5364019804669,
      "durationSeconds" : 74.98504281044006,
      "endOffsetSeconds" : 1692.4925154447556,
      "index" : 9,
      "label" : "Recovery 4",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1617.5074726343155,
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
      "distanceMeters" : 999.3887381962164,
      "durationSeconds" : 372.4029680490494,
      "endOffsetSeconds" : 2064.895483493805,
      "index" : 10,
      "label" : "Cooldown",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "1 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 1000,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1692.4925154447556,
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
      "distanceMeters" : 538.5110722698,
      "durationSeconds" : 365.21088540554047,
      "endOffsetSeconds" : 2430.1063688993454,
      "index" : 11,
      "label" : "Open \/ Extra",
      "mappingStatus" : "inferredOpenTailFromWorkoutEnd",
      "plannedGoalDisplayText" : "Open",
      "plannedGoalType" : "open",
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 2064.895483493805,
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
          "endCumulativeDistanceMeters" : 2006.0117082833312,
          "endDate" : "2026-06-28T12:53:22Z",
          "endOffsetSeconds" : 771.7509466409683,
          "startCumulativeDistanceMeters" : 1997.3675428917632,
          "startDate" : "2026-06-28T12:53:20Z",
          "startOffsetSeconds" : 769.1780968904495
        },
        "cumulativeDistanceAtEndMeters" : 2006.0117082833312,
        "cumulativeDistanceAtStartMeters" : 0,
        "interpolationFraction" : 0.304535717329595,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2008.2236217572354,
          "endDate" : "2026-06-28T12:53:25Z",
          "endOffsetSeconds" : 774.32379591465,
          "startCumulativeDistanceMeters" : 2006.0117082833312,
          "startDate" : "2026-06-28T12:53:22Z",
          "startOffsetSeconds" : 771.7509466409683
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 1997.3675428917632,
          "endDate" : "2026-06-28T12:53:20Z",
          "endOffsetSeconds" : 769.1780968904495,
          "startCumulativeDistanceMeters" : 1988.2376585160382,
          "startDate" : "2026-06-28T12:53:17Z",
          "startOffsetSeconds" : 766.605250120163
        },
        "targetDistanceMeters" : 2000
      },
      "index" : 1,
      "label" : "Warmup"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 2410.76317142928,
          "endDate" : "2026-06-28T12:56:02Z",
          "endOffsetSeconds" : 931.2668306827545,
          "startCumulativeDistanceMeters" : 2404.646733074682,
          "startDate" : "2026-06-28T12:55:59Z",
          "startOffsetSeconds" : 928.6940019130707
        },
        "cumulativeDistanceAtEndMeters" : 2410.76317142928,
        "cumulativeDistanceAtStartMeters" : 2006.0117082833312,
        "interpolationFraction" : 0.22316503976913607,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2418.3286560943816,
          "endDate" : "2026-06-28T12:56:04Z",
          "endOffsetSeconds" : 933.8396581411362,
          "startCumulativeDistanceMeters" : 2410.76317142928,
          "startDate" : "2026-06-28T12:56:02Z",
          "startOffsetSeconds" : 931.2668306827545
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 2404.646733074682,
          "endDate" : "2026-06-28T12:55:59Z",
          "endOffsetSeconds" : 928.6940019130707,
          "startCumulativeDistanceMeters" : 2397.410419391701,
          "startDate" : "2026-06-28T12:55:57Z",
          "startOffsetSeconds" : 926.1211721897125
        },
        "targetDistanceMeters" : 400
      },
      "index" : 2,
      "label" : "Work 1"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 2611.1807924751192,
          "endDate" : "2026-06-28T12:57:19Z",
          "endOffsetSeconds" : 1008.4514565467834,
          "startCumulativeDistanceMeters" : 2605.7636818578467,
          "startDate" : "2026-06-28T12:57:16Z",
          "startOffsetSeconds" : 1005.8786470890045
        },
        "cumulativeDistanceAtEndMeters" : 2611.1807924751192,
        "cumulativeDistanceAtStartMeters" : 2406.0117083516598,
        "interpolationFraction" : 0.04578575394459342,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2618.983863003319,
          "endDate" : "2026-06-28T12:57:22Z",
          "endOffsetSeconds" : 1011.0242695808411,
          "startCumulativeDistanceMeters" : 2611.1807924751192,
          "startDate" : "2026-06-28T12:57:19Z",
          "startOffsetSeconds" : 1008.4514565467834
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 2605.7636818578467,
          "endDate" : "2026-06-28T12:57:16Z",
          "endOffsetSeconds" : 1005.8786470890045,
          "startCumulativeDistanceMeters" : 2598.4599873484112,
          "startDate" : "2026-06-28T12:57:14Z",
          "startOffsetSeconds" : 1003.305838227272
        },
        "targetDistanceMeters" : 200
      },
      "index" : 3,
      "label" : "Recovery 1"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3006.6416838902514,
          "endDate" : "2026-06-28T12:59:48Z",
          "endOffsetSeconds" : 1157.6750727891922,
          "startCumulativeDistanceMeters" : 2999.123250720557,
          "startDate" : "2026-06-28T12:59:46Z",
          "startOffsetSeconds" : 1155.10224711895
        },
        "cumulativeDistanceAtEndMeters" : 3006.6416838902514,
        "cumulativeDistanceAtStartMeters" : 2606.0117082463657,
        "interpolationFraction" : 0.9162091848571571,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3014.3719595097937,
          "endDate" : "2026-06-28T12:59:51Z",
          "endOffsetSeconds" : 1160.2478969097137,
          "startCumulativeDistanceMeters" : 3006.6416838902514,
          "startDate" : "2026-06-28T12:59:48Z",
          "startOffsetSeconds" : 1157.6750727891922
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 2999.123250720557,
          "endDate" : "2026-06-28T12:59:46Z",
          "endOffsetSeconds" : 1155.10224711895,
          "startCumulativeDistanceMeters" : 2992.0711502626073,
          "startDate" : "2026-06-28T12:59:43Z",
          "startOffsetSeconds" : 1152.529420018196
        },
        "targetDistanceMeters" : 400
      },
      "index" : 4,
      "label" : "Work 2"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3210.763997773174,
          "endDate" : "2026-06-28T13:01:05Z",
          "endOffsetSeconds" : 1234.860275030136,
          "startCumulativeDistanceMeters" : 3202.7618924016133,
          "startDate" : "2026-06-28T13:01:03Z",
          "startOffsetSeconds" : 1232.2874413728714
        },
        "cumulativeDistanceAtEndMeters" : 3210.763997773174,
        "cumulativeDistanceAtStartMeters" : 3006.6416838902514,
        "interpolationFraction" : 0.4848463383682425,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3216.56860998529,
          "endDate" : "2026-06-28T13:01:08Z",
          "endOffsetSeconds" : 1237.4331077337265,
          "startCumulativeDistanceMeters" : 3210.763997773174,
          "startDate" : "2026-06-28T13:01:05Z",
          "startOffsetSeconds" : 1234.860275030136
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3202.7618924016133,
          "endDate" : "2026-06-28T13:01:03Z",
          "endOffsetSeconds" : 1232.2874413728714,
          "startCumulativeDistanceMeters" : 3196.346006739186,
          "startDate" : "2026-06-28T13:01:00Z",
          "startOffsetSeconds" : 1229.7146077156067
        },
        "targetDistanceMeters" : 200
      },
      "index" : 5,
      "label" : "Recovery 2"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3609.5900282445364,
          "endDate" : "2026-06-28T13:03:37Z",
          "endOffsetSeconds" : 1386.6577240228653,
          "startCumulativeDistanceMeters" : 3601.918119308306,
          "startDate" : "2026-06-28T13:03:35Z",
          "startOffsetSeconds" : 1384.0848885774612
        },
        "cumulativeDistanceAtEndMeters" : 3609.5900282445364,
        "cumulativeDistanceAtStartMeters" : 3206.641684000033,
        "interpolationFraction" : 0.6156961365143488,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3616.230888620019,
          "endDate" : "2026-06-28T13:03:40Z",
          "endOffsetSeconds" : 1389.2305612564087,
          "startCumulativeDistanceMeters" : 3609.5900282445364,
          "startDate" : "2026-06-28T13:03:37Z",
          "startOffsetSeconds" : 1386.6577240228653
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3601.918119308306,
          "endDate" : "2026-06-28T13:03:35Z",
          "endOffsetSeconds" : 1384.0848885774612,
          "startCumulativeDistanceMeters" : 3596.214458034141,
          "startDate" : "2026-06-28T13:03:32Z",
          "startOffsetSeconds" : 1381.512051820755
        },
        "targetDistanceMeters" : 400
      },
      "index" : 6,
      "label" : "Work 3"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3810.532906795619,
          "endDate" : "2026-06-28T13:04:54Z",
          "endOffsetSeconds" : 1463.8429609537125,
          "startCumulativeDistanceMeters" : 3805.630305110244,
          "startDate" : "2026-06-28T13:04:52Z",
          "startOffsetSeconds" : 1461.270123243332
        },
        "cumulativeDistanceAtEndMeters" : 3810.532906795619,
        "cumulativeDistanceAtStartMeters" : 3609.5900282445364,
        "interpolationFraction" : 0.807677920501802,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3818.9413451848086,
          "endDate" : "2026-06-28T13:04:57Z",
          "endOffsetSeconds" : 1466.415799498558,
          "startCumulativeDistanceMeters" : 3810.532906795619,
          "startDate" : "2026-06-28T13:04:54Z",
          "startOffsetSeconds" : 1463.8429609537125
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3805.630305110244,
          "endDate" : "2026-06-28T13:04:52Z",
          "endOffsetSeconds" : 1461.270123243332,
          "startCumulativeDistanceMeters" : 3800.040499923518,
          "startDate" : "2026-06-28T13:04:49Z",
          "startOffsetSeconds" : 1458.6972861289978
        },
        "targetDistanceMeters" : 200
      },
      "index" : 7,
      "label" : "Recovery 3"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 4215.327813629992,
          "endDate" : "2026-06-28T13:07:29Z",
          "endOffsetSeconds" : 1618.2148365974426,
          "startCumulativeDistanceMeters" : 4209.274142406182,
          "startDate" : "2026-06-28T13:07:26Z",
          "startOffsetSeconds" : 1615.6419404745102
        },
        "cumulativeDistanceAtEndMeters" : 4215.327813629992,
        "cumulativeDistanceAtStartMeters" : 3810.532906795619,
        "interpolationFraction" : 0.20793405239547766,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 4222.788687056862,
          "endDate" : "2026-06-28T13:07:31Z",
          "endOffsetSeconds" : 1620.787729024887,
          "startCumulativeDistanceMeters" : 4215.327813629992,
          "startDate" : "2026-06-28T13:07:29Z",
          "startOffsetSeconds" : 1618.2148365974426
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 4209.274142406182,
          "endDate" : "2026-06-28T13:07:26Z",
          "endOffsetSeconds" : 1615.6419404745102,
          "startCumulativeDistanceMeters" : 4202.5447771549225,
          "startDate" : "2026-06-28T13:07:24Z",
          "startOffsetSeconds" : 1613.069041967392
        },
        "targetDistanceMeters" : 400
      },
      "index" : 8,
      "label" : "Work 4"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 4416.228782752296,
          "endDate" : "2026-06-28T13:08:43Z",
          "endOffsetSeconds" : 1692.8291079998016,
          "startCumulativeDistanceMeters" : 4408.87793307961,
          "startDate" : "2026-06-28T13:08:41Z",
          "startOffsetSeconds" : 1690.2561737298965
        },
        "cumulativeDistanceAtEndMeters" : 4416.228782752296,
        "cumulativeDistanceAtStartMeters" : 4210.532906742964,
        "interpolationFraction" : 0.225140458184532,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 4422.16822152352,
          "endDate" : "2026-06-28T13:08:46Z",
          "endOffsetSeconds" : 1695.4020380973816,
          "startCumulativeDistanceMeters" : 4416.228782752296,
          "startDate" : "2026-06-28T13:08:43Z",
          "startOffsetSeconds" : 1692.8291079998016
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 4408.87793307961,
          "endDate" : "2026-06-28T13:08:41Z",
          "endOffsetSeconds" : 1690.2561737298965,
          "startCumulativeDistanceMeters" : 4401.8646066666115,
          "startDate" : "2026-06-28T13:08:38Z",
          "startOffsetSeconds" : 1687.6832357645035
        },
        "targetDistanceMeters" : 200
      },
      "index" : 9,
      "label" : "Recovery 4"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 5417.116270438768,
          "endDate" : "2026-06-28T13:14:56Z",
          "endOffsetSeconds" : 2065.9001923799515,
          "startCumulativeDistanceMeters" : 5409.626097196713,
          "startDate" : "2026-06-28T13:14:54Z",
          "startOffsetSeconds" : 2063.327294588089
        },
        "cumulativeDistanceAtEndMeters" : 5417.116270438768,
        "cumulativeDistanceAtStartMeters" : 4410.53290661309,
        "interpolationFraction" : 0.12106654773821604,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 5425.1432978347875,
          "endDate" : "2026-06-28T13:14:59Z",
          "endOffsetSeconds" : 2068.4730925559998,
          "startCumulativeDistanceMeters" : 5417.116270438768,
          "startDate" : "2026-06-28T13:14:56Z",
          "startOffsetSeconds" : 2065.9001923799515
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 5409.626097196713,
          "endDate" : "2026-06-28T13:14:54Z",
          "endOffsetSeconds" : 2063.327294588089,
          "startCumulativeDistanceMeters" : 5403.795289865928,
          "startDate" : "2026-06-28T13:14:51Z",
          "startOffsetSeconds" : 2060.754395365715
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
        "finalDistanceSampleCumulativeDistanceMeters" : 5945.86025665747,
        "finalDistanceSampleOffsetSeconds" : 2423.5285865068436,
        "lastCadenceSampleOffsetSeconds" : 2423.5285865068436,
        "lastHeartRateSampleOffsetSeconds" : 2423.9994778633118,
        "lastPowerSampleOffsetSeconds" : 2426.10140812397,
        "plannedFinalStepEndOffsetSeconds" : 2065.9001923799515,
        "remainingMeters" : 528.743986218702,
        "remainingSeconds" : 364.2061765193939,
        "workoutEndOffsetSeconds" : 2430.1063688993454
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
      "activeDurationSeconds" : 774.9394506216049,
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
      "distanceMeters" : 2006.5409944102787,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 774.9394506216049,
      "endOffsetSeconds" : 774.9394506216049,
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
      "activeDurationSeconds" : 157.3156670331955,
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
      "distanceMeters" : 400.455214654905,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 157.3156670331955,
      "endOffsetSeconds" : 932.2551176548004,
      "index" : 2,
      "isOpenTail" : false,
      "label" : "Work 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 774.9394506216049,
      "stepType" : "work"
    },
    {
      "activeDurationSeconds" : 76.88241314888,
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
      "distanceMeters" : 200.21201621345432,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 76.88241314888,
      "endOffsetSeconds" : 1009.1375308036804,
      "index" : 3,
      "isOpenTail" : false,
      "label" : "Recovery 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 932.2551176548004,
      "stepType" : "recovery"
    },
    {
      "activeDurationSeconds" : 151.52106297016144,
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
      "distanceMeters" : 400.66743088555467,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 151.52106297016144,
      "endOffsetSeconds" : 1160.6585937738419,
      "index" : 4,
      "isOpenTail" : false,
      "label" : "Work 2",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1009.1375308036804,
      "stepType" : "work"
    },
    {
      "activeDurationSeconds" : 75.99018025398254,
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
      "distanceMeters" : 200.44888219433057,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 75.99018025398254,
      "endOffsetSeconds" : 1236.6487740278244,
      "index" : 5,
      "isOpenTail" : false,
      "label" : "Recovery 2",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1160.6585937738419,
      "stepType" : "recovery"
    },
    {
      "activeDurationSeconds" : 152.24168384075165,
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
      "distanceMeters" : 400.2513401425558,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 152.24168384075165,
      "endOffsetSeconds" : 1388.890457868576,
      "index" : 6,
      "isOpenTail" : false,
      "label" : "Work 3",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1236.6487740278244,
      "stepType" : "work"
    },
    {
      "activeDurationSeconds" : 75.21527469158173,
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
      "distanceMeters" : 197.55514381243003,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 75.21527469158173,
      "endOffsetSeconds" : 1464.1057325601578,
      "index" : 7,
      "isOpenTail" : false,
      "label" : "Recovery 3",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1388.890457868576,
      "stepType" : "recovery"
    },
    {
      "activeDurationSeconds" : 153.40174007415771,
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
      "distanceMeters" : 401.29302189747835,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 153.40174007415771,
      "endOffsetSeconds" : 1617.5074726343155,
      "index" : 8,
      "isOpenTail" : false,
      "label" : "Work 4",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1464.1057325601578,
      "stepType" : "work"
    },
    {
      "activeDurationSeconds" : 74.98504281044006,
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
      "distanceMeters" : 200.5364019804669,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 74.98504281044006,
      "endOffsetSeconds" : 1692.4925154447556,
      "index" : 9,
      "isOpenTail" : false,
      "label" : "Recovery 4",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1617.5074726343155,
      "stepType" : "recovery"
    },
    {
      "activeDurationSeconds" : 372.4029680490494,
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
      "distanceMeters" : 999.3887381962164,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 372.4029680490494,
      "endOffsetSeconds" : 2064.895483493805,
      "index" : 10,
      "isOpenTail" : false,
      "label" : "Cooldown",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1692.4925154447556,
      "stepType" : "cooldown"
    },
    {
      "activeDurationSeconds" : 365.21088540554047,
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
      "distanceMeters" : 538.5110722698,
      "durationDisplayRule" : "open-tail-measured-duration",
      "durationRule" : "open-tail-measured-duration",
      "elapsedDurationSeconds" : 365.21088540554047,
      "endOffsetSeconds" : 2430.1063688993454,
      "index" : 11,
      "isOpenTail" : true,
      "label" : "Open \/ Extra",
      "mappingStatus" : "inferredOpenTailFromWorkoutEnd",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 2064.895483493805,
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
    "tailDistanceMeters" : 538.5110722698,
    "tailElapsedDurationSeconds" : 365.21088540554047,
    "tailStatus" : "open-extra-tail-present",
    "totalPairedPauseSeconds" : 0,
    "usesAppleFitnessManualRuntimeLogic" : false,
    "usesFITRuntimeTruth" : false
  },
  "customWorkoutComparisonSummary" : {
    "fallbackReasonLabels" : [
      "Open \/ Extra tail handling is ambiguous for this workout shape."
    ],
    "fallbackReasons" : [
      "openExtraTailAmbiguous"
    ],
    "normalWorkoutUIChanged" : false,
    "primaryFallbackReasonLabel" : "Open \/ Extra tail handling is ambiguous for this workout shape.",
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
    "status" : "open-tail-needs-rule",
    "statusLabel" : "Open \/ Extra tail handling needs an approved rule.",
    "tailAmbiguity" : "fixedCooldownFollowedByPossibleOpenExtraTail",
    "usesFITRuntimeTruth" : false
  },
  "evidenceCounts" : {
    "activeEnergy" : 942,
    "activities" : 10,
    "cadence" : 942,
    "distance" : 942,
    "events" : 11,
    "groundContact" : 382,
    "heartRate" : 485,
    "power" : 942,
    "routePoints" : 2428,
    "speed" : 942,
    "stepCount" : 942,
    "strideLength" : 382,
    "verticalOscillation" : 386
  },
  "generatedAt" : "2026-06-28T19:37:18Z",
  "plannedStepBoundaryComparisons" : [
    {
      "crossingDistanceSampleEndOffsetSeconds" : 771.7509466409683,
      "index" : 1,
      "nearestRawEventEndDeltaSeconds" : 0.7835245132446289,
      "nearestRawEventEndOffsetSeconds" : 772.534471154213,
      "nearestRawEventStartOffsetSeconds" : 386.5417444705963,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 0.7835245132446289,
      "nearestSegmentMarkerEndOffsetSeconds" : 772.534471154213,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 386.5417444705963,
      "nearestWorkoutActivityEndDeltaSeconds" : 3.1885039806365967,
      "nearestWorkoutActivityEndOffsetSeconds" : 774.9394506216049,
      "nearestWorkoutActivityStartOffsetSeconds" : 0,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 774.32379591465,
      "plannedGoalDisplayText" : "2 km",
      "plannedStepLabel" : "Warmup",
      "previousDistanceSampleEndOffsetSeconds" : 769.1780968904495,
      "reconstructedEndOffsetSeconds" : 771.7509466409683,
      "reconstructedLabel" : "Warmup"
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 931.2668306827545,
      "index" : 2,
      "nearestRawEventEndDeltaSeconds" : -156.7336962223053,
      "nearestRawEventEndOffsetSeconds" : 772.534471154213,
      "nearestRawEventStartOffsetSeconds" : 386.5417444705963,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -156.7336962223053,
      "nearestSegmentMarkerEndOffsetSeconds" : 772.534471154213,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 386.5417444705963,
      "nearestWorkoutActivityEndDeltaSeconds" : 2.9869502782821655,
      "nearestWorkoutActivityEndOffsetSeconds" : 932.2551176548004,
      "nearestWorkoutActivityStartOffsetSeconds" : 774.9394506216049,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 933.8396581411362,
      "plannedGoalDisplayText" : "400 m",
      "plannedStepLabel" : "Work 1",
      "previousDistanceSampleEndOffsetSeconds" : 928.6940019130707,
      "reconstructedEndOffsetSeconds" : 929.2681673765182,
      "reconstructedLabel" : "Work 1",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1008.4514565467834,
      "index" : 3,
      "nearestRawEventEndDeltaSeconds" : 151.97865319252014,
      "nearestRawEventEndOffsetSeconds" : 1157.9750982522964,
      "nearestRawEventStartOffsetSeconds" : 772.534471154213,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 151.97865319252014,
      "nearestSegmentMarkerEndOffsetSeconds" : 1157.9750982522964,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 772.534471154213,
      "nearestWorkoutActivityEndDeltaSeconds" : 3.1410857439041138,
      "nearestWorkoutActivityEndOffsetSeconds" : 1009.1375308036804,
      "nearestWorkoutActivityStartOffsetSeconds" : 932.2551176548004,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1011.0242695808411,
      "plannedGoalDisplayText" : "200 m",
      "plannedStepLabel" : "Recovery 1",
      "previousDistanceSampleEndOffsetSeconds" : 1005.8786470890045,
      "reconstructedEndOffsetSeconds" : 1005.9964450597763,
      "reconstructedLabel" : "Recovery 1",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1157.6750727891922,
      "index" : 4,
      "nearestRawEventEndDeltaSeconds" : 0.30002546310424805,
      "nearestRawEventEndOffsetSeconds" : 1157.9750982522964,
      "nearestRawEventStartOffsetSeconds" : 772.534471154213,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 0.30002546310424805,
      "nearestSegmentMarkerEndOffsetSeconds" : 1157.9750982522964,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 772.534471154213,
      "nearestWorkoutActivityEndDeltaSeconds" : 2.983520984649658,
      "nearestWorkoutActivityEndOffsetSeconds" : 1160.6585937738419,
      "nearestWorkoutActivityStartOffsetSeconds" : 1009.1375308036804,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1160.2478969097137,
      "plannedGoalDisplayText" : "400 m",
      "plannedStepLabel" : "Work 2",
      "previousDistanceSampleEndOffsetSeconds" : 1155.10224711895,
      "reconstructedEndOffsetSeconds" : 1157.6750727891922,
      "reconstructedLabel" : "Work 2"
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1234.860275030136,
      "index" : 5,
      "nearestRawEventEndDeltaSeconds" : 7.200172424316406,
      "nearestRawEventEndOffsetSeconds" : 1240.73504281044,
      "nearestRawEventStartOffsetSeconds" : 621.8462615013123,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 7.200172424316406,
      "nearestSegmentMarkerEndOffsetSeconds" : 1240.73504281044,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 621.8462615013123,
      "nearestWorkoutActivityEndDeltaSeconds" : 3.1139036417007446,
      "nearestWorkoutActivityEndOffsetSeconds" : 1236.6487740278244,
      "nearestWorkoutActivityStartOffsetSeconds" : 1160.6585937738419,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1237.4331077337265,
      "plannedGoalDisplayText" : "200 m",
      "plannedStepLabel" : "Recovery 2",
      "previousDistanceSampleEndOffsetSeconds" : 1232.2874413728714,
      "reconstructedEndOffsetSeconds" : 1233.5348703861237,
      "reconstructedLabel" : "Recovery 2",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1386.6577240228653,
      "index" : 6,
      "nearestRawEventEndDeltaSeconds" : -145.92268121242523,
      "nearestRawEventEndOffsetSeconds" : 1240.73504281044,
      "nearestRawEventStartOffsetSeconds" : 621.8462615013123,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -145.92268121242523,
      "nearestSegmentMarkerEndOffsetSeconds" : 1240.73504281044,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 621.8462615013123,
      "nearestWorkoutActivityEndDeltaSeconds" : 2.2327338457107544,
      "nearestWorkoutActivityEndOffsetSeconds" : 1388.890457868576,
      "nearestWorkoutActivityStartOffsetSeconds" : 1236.6487740278244,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1389.2305612564087,
      "plannedGoalDisplayText" : "400 m",
      "plannedStepLabel" : "Work 3",
      "previousDistanceSampleEndOffsetSeconds" : 1384.0848885774612,
      "reconstructedEndOffsetSeconds" : 1386.6577240228653,
      "reconstructedLabel" : "Work 3",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1463.8429609537125,
      "index" : 7,
      "nearestRawEventEndDeltaSeconds" : 74.01081085205078,
      "nearestRawEventEndOffsetSeconds" : 1537.8537718057632,
      "nearestRawEventStartOffsetSeconds" : 1157.9750982522964,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 74.01081085205078,
      "nearestSegmentMarkerEndOffsetSeconds" : 1537.8537718057632,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1157.9750982522964,
      "nearestWorkoutActivityEndDeltaSeconds" : 0.2627716064453125,
      "nearestWorkoutActivityEndOffsetSeconds" : 1464.1057325601578,
      "nearestWorkoutActivityStartOffsetSeconds" : 1388.890457868576,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1466.415799498558,
      "plannedGoalDisplayText" : "200 m",
      "plannedStepLabel" : "Recovery 3",
      "previousDistanceSampleEndOffsetSeconds" : 1461.270123243332,
      "reconstructedEndOffsetSeconds" : 1463.8429609537125,
      "reconstructedLabel" : "Recovery 3",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1618.2148365974426,
      "index" : 8,
      "nearestRawEventEndDeltaSeconds" : -78.32316136360168,
      "nearestRawEventEndOffsetSeconds" : 1537.8537718057632,
      "nearestRawEventStartOffsetSeconds" : 1157.9750982522964,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -78.32316136360168,
      "nearestSegmentMarkerEndOffsetSeconds" : 1537.8537718057632,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1157.9750982522964,
      "nearestWorkoutActivityEndDeltaSeconds" : 1.3305394649505615,
      "nearestWorkoutActivityEndOffsetSeconds" : 1617.5074726343155,
      "nearestWorkoutActivityStartOffsetSeconds" : 1464.1057325601578,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1620.787729024887,
      "plannedGoalDisplayText" : "400 m",
      "plannedStepLabel" : "Work 4",
      "previousDistanceSampleEndOffsetSeconds" : 1615.6419404745102,
      "reconstructedEndOffsetSeconds" : 1616.176933169365,
      "reconstructedLabel" : "Work 4",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1692.8291079998016,
      "index" : 9,
      "nearestRawEventEndDeltaSeconds" : -152.9816734790802,
      "nearestRawEventEndOffsetSeconds" : 1537.8537718057632,
      "nearestRawEventStartOffsetSeconds" : 1157.9750982522964,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -152.9816734790802,
      "nearestSegmentMarkerEndOffsetSeconds" : 1537.8537718057632,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1157.9750982522964,
      "nearestWorkoutActivityEndDeltaSeconds" : 1.6570701599121094,
      "nearestWorkoutActivityEndOffsetSeconds" : 1692.4925154447556,
      "nearestWorkoutActivityStartOffsetSeconds" : 1617.5074726343155,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1695.4020380973816,
      "plannedGoalDisplayText" : "200 m",
      "plannedStepLabel" : "Recovery 4",
      "previousDistanceSampleEndOffsetSeconds" : 1690.2561737298965,
      "reconstructedEndOffsetSeconds" : 1690.8354452848434,
      "reconstructedLabel" : "Recovery 4",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 2065.9001923799515,
      "index" : 10,
      "nearestRawEventEndDeltaSeconds" : -151.97432279586792,
      "nearestRawEventEndOffsetSeconds" : 1913.9258695840836,
      "nearestRawEventStartOffsetSeconds" : 1537.8537718057632,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -151.97432279586792,
      "nearestSegmentMarkerEndOffsetSeconds" : 1913.9258695840836,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1537.8537718057632,
      "nearestWorkoutActivityEndDeltaSeconds" : -1.0047088861465454,
      "nearestWorkoutActivityEndOffsetSeconds" : 2064.895483493805,
      "nearestWorkoutActivityStartOffsetSeconds" : 1692.4925154447556,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 2068.4730925559998,
      "plannedGoalDisplayText" : "1 km",
      "plannedStepLabel" : "Cooldown",
      "previousDistanceSampleEndOffsetSeconds" : 2063.327294588089,
      "reconstructedEndOffsetSeconds" : 2065.9001923799515,
      "reconstructedLabel" : "Cooldown",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "index" : 11,
      "nearestRawEventEndDeltaSeconds" : -4.004960656166077,
      "nearestRawEventEndOffsetSeconds" : 2426.1014082431793,
      "nearestRawEventStartOffsetSeconds" : 1849.9854604005814,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -4.004960656166077,
      "nearestSegmentMarkerEndOffsetSeconds" : 2426.1014082431793,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1849.9854604005814,
      "nearestWorkoutActivityEndDeltaSeconds" : -365.21088540554047,
      "nearestWorkoutActivityEndOffsetSeconds" : 2064.895483493805,
      "nearestWorkoutActivityStartOffsetSeconds" : 1692.4925154447556,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "plannedGoalDisplayText" : "Open",
      "reconstructedEndOffsetSeconds" : 2430.1063688993454,
      "reconstructedLabel" : "Open \/ Extra",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    }
  ],
  "rawWorkoutEvents" : [
    {
      "durationSeconds" : 386.5417444705963,
      "endDate" : "2026-06-28T12:46:57Z",
      "endOffsetSeconds" : 386.5417444705963,
      "index" : 1,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1006.6094232971217,
      "renderedSegmentMarkerDurationSeconds" : 386.5417444705963,
      "renderedSegmentMarkerEndOffsetSeconds" : 386.5417444705963,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T12:40:31Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 621.8462615013123,
      "endDate" : "2026-06-28T12:50:52Z",
      "endOffsetSeconds" : 621.8462615013123,
      "index" : 2,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1615.8135079638967,
      "renderedSegmentMarkerDurationSeconds" : 621.8462615013123,
      "renderedSegmentMarkerEndOffsetSeconds" : 621.8462615013123,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T12:40:31Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 385.99272668361664,
      "endDate" : "2026-06-28T12:53:23Z",
      "endOffsetSeconds" : 772.534471154213,
      "index" : 3,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1000.0758916547805,
      "renderedSegmentMarkerDurationSeconds" : 385.99272668361664,
      "renderedSegmentMarkerEndOffsetSeconds" : 772.534471154213,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 386.5417444705963,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T12:46:57Z",
      "startOffsetSeconds" : 386.5417444705963,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 618.8887813091278,
      "endDate" : "2026-06-28T13:01:11Z",
      "endOffsetSeconds" : 1240.73504281044,
      "index" : 4,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1610.1690358538806,
      "renderedSegmentMarkerDurationSeconds" : 618.8887813091278,
      "renderedSegmentMarkerEndOffsetSeconds" : 1240.73504281044,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 621.8462615013123,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T12:50:52Z",
      "startOffsetSeconds" : 621.8462615013123,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 385.4406270980835,
      "endDate" : "2026-06-28T12:59:49Z",
      "endOffsetSeconds" : 1157.9750982522964,
      "index" : 5,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1000.8578217443057,
      "renderedSegmentMarkerDurationSeconds" : 385.4406270980835,
      "renderedSegmentMarkerEndOffsetSeconds" : 1157.9750982522964,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 772.534471154213,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T12:53:23Z",
      "startOffsetSeconds" : 772.534471154213,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 379.8786735534668,
      "endDate" : "2026-06-28T13:06:08Z",
      "endOffsetSeconds" : 1537.8537718057632,
      "index" : 6,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 999.4675988093759,
      "renderedSegmentMarkerDurationSeconds" : 379.8786735534668,
      "renderedSegmentMarkerEndOffsetSeconds" : 1537.8537718057632,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1157.9750982522964,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T12:59:49Z",
      "startOffsetSeconds" : 1157.9750982522964,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 609.2504175901413,
      "endDate" : "2026-06-28T13:11:21Z",
      "endOffsetSeconds" : 1849.9854604005814,
      "index" : 7,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1609.7181366049376,
      "renderedSegmentMarkerDurationSeconds" : 609.2504175901413,
      "renderedSegmentMarkerEndOffsetSeconds" : 1849.9854604005814,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1240.73504281044,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T13:01:11Z",
      "startOffsetSeconds" : 1240.73504281044,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 376.0720977783203,
      "endDate" : "2026-06-28T13:12:24Z",
      "endOffsetSeconds" : 1913.9258695840836,
      "index" : 8,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 998.9631412437925,
      "renderedSegmentMarkerDurationSeconds" : 376.0720977783203,
      "renderedSegmentMarkerEndOffsetSeconds" : 1913.9258695840836,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1537.8537718057632,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T13:06:08Z",
      "startOffsetSeconds" : 1537.8537718057632,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 576.115947842598,
      "endDate" : "2026-06-28T13:20:57Z",
      "endOffsetSeconds" : 2426.1014082431793,
      "index" : 9,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1110.1595762347551,
      "renderedSegmentMarkerDurationSeconds" : 576.115947842598,
      "renderedSegmentMarkerEndOffsetSeconds" : 2426.1014082431793,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1849.9854604005814,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T13:11:21Z",
      "startOffsetSeconds" : 1849.9854604005814,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 512.1755386590958,
      "endDate" : "2026-06-28T13:20:57Z",
      "endOffsetSeconds" : 2426.1014082431793,
      "index" : 10,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 939.8863799080937,
      "renderedSegmentMarkerDurationSeconds" : 512.1755386590958,
      "renderedSegmentMarkerEndOffsetSeconds" : 2426.1014082431793,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1913.9258695840836,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-28T13:12:24Z",
      "startOffsetSeconds" : 1913.9258695840836,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 0,
      "endDate" : "2026-06-28T13:21:01Z",
      "endOffsetSeconds" : 2430.1063688993454,
      "excludedOrFilteredReason" : "zeroOrNegativeDuration",
      "index" : 11,
      "metadataKeys" : [

      ],
      "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
      "startDate" : "2026-06-28T13:21:01Z",
      "startOffsetSeconds" : 2430.1063688993454,
      "type" : "HKWorkoutEventType(rawValue: 1)",
      "usedBySegmentMarkerRendering" : false
    }
  ],
  "reconstructedIntervals" : [
    {
      "averageHeartRateBpm" : 145.7207792207792,
      "averagePower" : 187.43478260869566,
      "boundaryAdjustmentSeconds" : 1.7893251180648804,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 2006.0117082833312,
          "endDate" : "2026-06-28T12:53:22Z",
          "endOffsetSeconds" : 771.7509466409683,
          "startCumulativeDistanceMeters" : 1997.3675428917632,
          "startDate" : "2026-06-28T12:53:20Z",
          "startOffsetSeconds" : 769.1780968904495
        },
        "cumulativeDistanceAtEndMeters" : 2006.0117082833312,
        "cumulativeDistanceAtStartMeters" : 0,
        "interpolationFraction" : 0.304535717329595,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2008.2236217572354,
          "endDate" : "2026-06-28T12:53:25Z",
          "endOffsetSeconds" : 774.32379591465,
          "startCumulativeDistanceMeters" : 2006.0117082833312,
          "startDate" : "2026-06-28T12:53:22Z",
          "startOffsetSeconds" : 771.7509466409683
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 1997.3675428917632,
          "endDate" : "2026-06-28T12:53:20Z",
          "endOffsetSeconds" : 769.1780968904495,
          "startCumulativeDistanceMeters" : 1988.2376585160382,
          "startDate" : "2026-06-28T12:53:17Z",
          "startOffsetSeconds" : 766.605250120163
        },
        "targetDistanceMeters" : 2000
      },
      "boundaryOvershootMeters" : 6.011708283331245,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "displayDurationSeconds" : 771.7509466409683,
      "distanceMeters" : 2006.0117082833312,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 771.7509466409683,
      "elapsedDurationSeconds" : 771.7509466409683,
      "endOffsetSeconds" : 771.7509466409683,
      "index" : 1,
      "label" : "Warmup",
      "maxHeartRateBpm" : 154,
      "paceSecondsPerKm" : 384.7190639287961,
      "plannedGoalDisplayText" : "2 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 2000,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +1.8s, overshoot 6.0 m",
      "startOffsetSeconds" : 0,
      "stepType" : "warmup"
    },
    {
      "averageHeartRateBpm" : 151.90625,
      "averagePower" : 183.67741935483872,
      "boundaryAdjustmentSeconds" : 0,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 2410.76317142928,
          "endDate" : "2026-06-28T12:56:02Z",
          "endOffsetSeconds" : 931.2668306827545,
          "startCumulativeDistanceMeters" : 2404.646733074682,
          "startDate" : "2026-06-28T12:55:59Z",
          "startOffsetSeconds" : 928.6940019130707
        },
        "cumulativeDistanceAtEndMeters" : 2410.76317142928,
        "cumulativeDistanceAtStartMeters" : 2006.0117082833312,
        "interpolationFraction" : 0.22316503976913607,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2418.3286560943816,
          "endDate" : "2026-06-28T12:56:04Z",
          "endOffsetSeconds" : 933.8396581411362,
          "startCumulativeDistanceMeters" : 2410.76317142928,
          "startDate" : "2026-06-28T12:56:02Z",
          "startOffsetSeconds" : 931.2668306827545
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 2404.646733074682,
          "endDate" : "2026-06-28T12:55:59Z",
          "endOffsetSeconds" : 928.6940019130707,
          "startCumulativeDistanceMeters" : 2397.410419391701,
          "startDate" : "2026-06-28T12:55:57Z",
          "startOffsetSeconds" : 926.1211721897125
        },
        "targetDistanceMeters" : 400
      },
      "boundaryOvershootMeters" : 4.7514631459489465,
      "boundaryStrategy" : "interpolatedCrossing",
      "confidence" : "high",
      "displayDurationSeconds" : 157.51722073554993,
      "distanceMeters" : 400.0000000683285,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 157.51722073554993,
      "elapsedDurationSeconds" : 157.51722073554993,
      "endOffsetSeconds" : 929.2681673765182,
      "index" : 2,
      "label" : "Work 1",
      "maxHeartRateBpm" : 157,
      "paceSecondsPerKm" : 393.79305177160654,
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 4.8 m",
      "startOffsetSeconds" : 771.7509466409683,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 151.92857142857142,
      "averagePower" : 187.13333333333333,
      "boundaryAdjustmentSeconds" : 0,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 2611.1807924751192,
          "endDate" : "2026-06-28T12:57:19Z",
          "endOffsetSeconds" : 1008.4514565467834,
          "startCumulativeDistanceMeters" : 2605.7636818578467,
          "startDate" : "2026-06-28T12:57:16Z",
          "startOffsetSeconds" : 1005.8786470890045
        },
        "cumulativeDistanceAtEndMeters" : 2611.1807924751192,
        "cumulativeDistanceAtStartMeters" : 2406.0117083516598,
        "interpolationFraction" : 0.04578575394459342,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2618.983863003319,
          "endDate" : "2026-06-28T12:57:22Z",
          "endOffsetSeconds" : 1011.0242695808411,
          "startCumulativeDistanceMeters" : 2611.1807924751192,
          "startDate" : "2026-06-28T12:57:19Z",
          "startOffsetSeconds" : 1008.4514565467834
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 2605.7636818578467,
          "endDate" : "2026-06-28T12:57:16Z",
          "endOffsetSeconds" : 1005.8786470890045,
          "startCumulativeDistanceMeters" : 2598.4599873484112,
          "startDate" : "2026-06-28T12:57:14Z",
          "startOffsetSeconds" : 1003.305838227272
        },
        "targetDistanceMeters" : 200
      },
      "boundaryOvershootMeters" : 5.16908412345947,
      "boundaryStrategy" : "interpolatedCrossing",
      "confidence" : "high",
      "displayDurationSeconds" : 76.72827768325806,
      "distanceMeters" : 199.99999989470598,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 76.72827768325806,
      "elapsedDurationSeconds" : 76.72827768325806,
      "endOffsetSeconds" : 1005.9964450597763,
      "index" : 3,
      "label" : "Recovery 1",
      "maxHeartRateBpm" : 154,
      "paceSecondsPerKm" : 383.641388618266,
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 5.2 m",
      "startOffsetSeconds" : 929.2681673765182,
      "stepType" : "recovery"
    },
    {
      "averageHeartRateBpm" : 153.13333333333333,
      "averagePower" : 187.67796610169492,
      "boundaryAdjustmentSeconds" : 0.21557915210723877,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3006.6416838902514,
          "endDate" : "2026-06-28T12:59:48Z",
          "endOffsetSeconds" : 1157.6750727891922,
          "startCumulativeDistanceMeters" : 2999.123250720557,
          "startDate" : "2026-06-28T12:59:46Z",
          "startOffsetSeconds" : 1155.10224711895
        },
        "cumulativeDistanceAtEndMeters" : 3006.6416838902514,
        "cumulativeDistanceAtStartMeters" : 2606.0117082463657,
        "interpolationFraction" : 0.9162091848571571,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3014.3719595097937,
          "endDate" : "2026-06-28T12:59:51Z",
          "endOffsetSeconds" : 1160.2478969097137,
          "startCumulativeDistanceMeters" : 3006.6416838902514,
          "startDate" : "2026-06-28T12:59:48Z",
          "startOffsetSeconds" : 1157.6750727891922
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 2999.123250720557,
          "endDate" : "2026-06-28T12:59:46Z",
          "endOffsetSeconds" : 1155.10224711895,
          "startCumulativeDistanceMeters" : 2992.0711502626073,
          "startDate" : "2026-06-28T12:59:43Z",
          "startOffsetSeconds" : 1152.529420018196
        },
        "targetDistanceMeters" : 400
      },
      "boundaryOvershootMeters" : 0.6299756438857003,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "displayDurationSeconds" : 151.6786277294159,
      "distanceMeters" : 400.6299756438857,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 151.6786277294159,
      "elapsedDurationSeconds" : 151.6786277294159,
      "endOffsetSeconds" : 1157.6750727891922,
      "index" : 4,
      "label" : "Work 2",
      "maxHeartRateBpm" : 157,
      "paceSecondsPerKm" : 378.60029690898835,
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +0.2s, overshoot 0.6 m",
      "startOffsetSeconds" : 1005.9964450597763,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 153,
      "averagePower" : 190.93333333333334,
      "boundaryAdjustmentSeconds" : 0,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3210.763997773174,
          "endDate" : "2026-06-28T13:01:05Z",
          "endOffsetSeconds" : 1234.860275030136,
          "startCumulativeDistanceMeters" : 3202.7618924016133,
          "startDate" : "2026-06-28T13:01:03Z",
          "startOffsetSeconds" : 1232.2874413728714
        },
        "cumulativeDistanceAtEndMeters" : 3210.763997773174,
        "cumulativeDistanceAtStartMeters" : 3006.6416838902514,
        "interpolationFraction" : 0.4848463383682425,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3216.56860998529,
          "endDate" : "2026-06-28T13:01:08Z",
          "endOffsetSeconds" : 1237.4331077337265,
          "startCumulativeDistanceMeters" : 3210.763997773174,
          "startDate" : "2026-06-28T13:01:05Z",
          "startOffsetSeconds" : 1234.860275030136
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3202.7618924016133,
          "endDate" : "2026-06-28T13:01:03Z",
          "endOffsetSeconds" : 1232.2874413728714,
          "startCumulativeDistanceMeters" : 3196.346006739186,
          "startDate" : "2026-06-28T13:01:00Z",
          "startOffsetSeconds" : 1229.7146077156067
        },
        "targetDistanceMeters" : 200
      },
      "boundaryOvershootMeters" : 4.122313882922754,
      "boundaryStrategy" : "interpolatedCrossing",
      "confidence" : "high",
      "displayDurationSeconds" : 75.85979759693146,
      "distanceMeters" : 200.00000010978147,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 75.85979759693146,
      "elapsedDurationSeconds" : 75.85979759693146,
      "endOffsetSeconds" : 1233.5348703861237,
      "index" : 5,
      "label" : "Recovery 2",
      "maxHeartRateBpm" : 157,
      "paceSecondsPerKm" : 379.2989877764573,
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 4.1 m",
      "startOffsetSeconds" : 1157.6750727891922,
      "stepType" : "recovery"
    },
    {
      "averageHeartRateBpm" : 158.33333333333334,
      "averagePower" : 192.8,
      "boundaryAdjustmentSeconds" : 0.9887505769729614,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3609.5900282445364,
          "endDate" : "2026-06-28T13:03:37Z",
          "endOffsetSeconds" : 1386.6577240228653,
          "startCumulativeDistanceMeters" : 3601.918119308306,
          "startDate" : "2026-06-28T13:03:35Z",
          "startOffsetSeconds" : 1384.0848885774612
        },
        "cumulativeDistanceAtEndMeters" : 3609.5900282445364,
        "cumulativeDistanceAtStartMeters" : 3206.641684000033,
        "interpolationFraction" : 0.6156961365143488,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3616.230888620019,
          "endDate" : "2026-06-28T13:03:40Z",
          "endOffsetSeconds" : 1389.2305612564087,
          "startCumulativeDistanceMeters" : 3609.5900282445364,
          "startDate" : "2026-06-28T13:03:37Z",
          "startOffsetSeconds" : 1386.6577240228653
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3601.918119308306,
          "endDate" : "2026-06-28T13:03:35Z",
          "endOffsetSeconds" : 1384.0848885774612,
          "startCumulativeDistanceMeters" : 3596.214458034141,
          "startDate" : "2026-06-28T13:03:32Z",
          "startOffsetSeconds" : 1381.512051820755
        },
        "targetDistanceMeters" : 400
      },
      "boundaryOvershootMeters" : 2.9483442445034598,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "displayDurationSeconds" : 153.12285363674164,
      "distanceMeters" : 402.94834424450346,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 153.12285363674164,
      "elapsedDurationSeconds" : 153.12285363674164,
      "endOffsetSeconds" : 1386.6577240228653,
      "index" : 6,
      "label" : "Work 3",
      "maxHeartRateBpm" : 161,
      "paceSecondsPerKm" : 380.00616164296434,
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +1.0s, overshoot 2.9 m",
      "startOffsetSeconds" : 1233.5348703861237,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 158.6875,
      "averagePower" : 191.61290322580646,
      "boundaryAdjustmentSeconds" : 0.4948134422302246,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3810.532906795619,
          "endDate" : "2026-06-28T13:04:54Z",
          "endOffsetSeconds" : 1463.8429609537125,
          "startCumulativeDistanceMeters" : 3805.630305110244,
          "startDate" : "2026-06-28T13:04:52Z",
          "startOffsetSeconds" : 1461.270123243332
        },
        "cumulativeDistanceAtEndMeters" : 3810.532906795619,
        "cumulativeDistanceAtStartMeters" : 3609.5900282445364,
        "interpolationFraction" : 0.807677920501802,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3818.9413451848086,
          "endDate" : "2026-06-28T13:04:57Z",
          "endOffsetSeconds" : 1466.415799498558,
          "startCumulativeDistanceMeters" : 3810.532906795619,
          "startDate" : "2026-06-28T13:04:54Z",
          "startOffsetSeconds" : 1463.8429609537125
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3805.630305110244,
          "endDate" : "2026-06-28T13:04:52Z",
          "endOffsetSeconds" : 1461.270123243332,
          "startCumulativeDistanceMeters" : 3800.040499923518,
          "startDate" : "2026-06-28T13:04:49Z",
          "startOffsetSeconds" : 1458.6972861289978
        },
        "targetDistanceMeters" : 200
      },
      "boundaryOvershootMeters" : 0.9428785510826856,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "displayDurationSeconds" : 77.18523693084717,
      "distanceMeters" : 200.94287855108269,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 77.18523693084717,
      "elapsedDurationSeconds" : 77.18523693084717,
      "endOffsetSeconds" : 1463.8429609537125,
      "index" : 7,
      "label" : "Recovery 3",
      "maxHeartRateBpm" : 161,
      "paceSecondsPerKm" : 384.11531419972926,
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +0.5s, overshoot 0.9 m",
      "startOffsetSeconds" : 1386.6577240228653,
      "stepType" : "recovery"
    },
    {
      "averageHeartRateBpm" : 159.8,
      "averagePower" : 189.65,
      "boundaryAdjustmentSeconds" : 0,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 4215.327813629992,
          "endDate" : "2026-06-28T13:07:29Z",
          "endOffsetSeconds" : 1618.2148365974426,
          "startCumulativeDistanceMeters" : 4209.274142406182,
          "startDate" : "2026-06-28T13:07:26Z",
          "startOffsetSeconds" : 1615.6419404745102
        },
        "cumulativeDistanceAtEndMeters" : 4215.327813629992,
        "cumulativeDistanceAtStartMeters" : 3810.532906795619,
        "interpolationFraction" : 0.20793405239547766,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 4222.788687056862,
          "endDate" : "2026-06-28T13:07:31Z",
          "endOffsetSeconds" : 1620.787729024887,
          "startCumulativeDistanceMeters" : 4215.327813629992,
          "startDate" : "2026-06-28T13:07:29Z",
          "startOffsetSeconds" : 1618.2148365974426
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 4209.274142406182,
          "endDate" : "2026-06-28T13:07:26Z",
          "endOffsetSeconds" : 1615.6419404745102,
          "startCumulativeDistanceMeters" : 4202.5447771549225,
          "startDate" : "2026-06-28T13:07:24Z",
          "startOffsetSeconds" : 1613.069041967392
        },
        "targetDistanceMeters" : 400
      },
      "boundaryOvershootMeters" : 4.794906834373251,
      "boundaryStrategy" : "interpolatedCrossing",
      "confidence" : "high",
      "displayDurationSeconds" : 152.33397221565247,
      "distanceMeters" : 399.9999999473448,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 152.33397221565247,
      "elapsedDurationSeconds" : 152.33397221565247,
      "endOffsetSeconds" : 1616.176933169365,
      "index" : 8,
      "label" : "Work 4",
      "maxHeartRateBpm" : 161,
      "paceSecondsPerKm" : 380.8349305892635,
      "plannedGoalDisplayText" : "400 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 400,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 4.8 m",
      "startOffsetSeconds" : 1463.8429609537125,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 159.26666666666668,
      "averagePower" : 191.75862068965517,
      "boundaryAdjustmentSeconds" : 0,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 4416.228782752296,
          "endDate" : "2026-06-28T13:08:43Z",
          "endOffsetSeconds" : 1692.8291079998016,
          "startCumulativeDistanceMeters" : 4408.87793307961,
          "startDate" : "2026-06-28T13:08:41Z",
          "startOffsetSeconds" : 1690.2561737298965
        },
        "cumulativeDistanceAtEndMeters" : 4416.228782752296,
        "cumulativeDistanceAtStartMeters" : 4210.532906742964,
        "interpolationFraction" : 0.225140458184532,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 4422.16822152352,
          "endDate" : "2026-06-28T13:08:46Z",
          "endOffsetSeconds" : 1695.4020380973816,
          "startCumulativeDistanceMeters" : 4416.228782752296,
          "startDate" : "2026-06-28T13:08:43Z",
          "startOffsetSeconds" : 1692.8291079998016
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 4408.87793307961,
          "endDate" : "2026-06-28T13:08:41Z",
          "endOffsetSeconds" : 1690.2561737298965,
          "startCumulativeDistanceMeters" : 4401.8646066666115,
          "startDate" : "2026-06-28T13:08:38Z",
          "startOffsetSeconds" : 1687.6832357645035
        },
        "targetDistanceMeters" : 200
      },
      "boundaryOvershootMeters" : 5.695876009332096,
      "boundaryStrategy" : "interpolatedCrossing",
      "confidence" : "high",
      "displayDurationSeconds" : 74.65851211547852,
      "distanceMeters" : 199.99999987012598,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 74.65851211547852,
      "elapsedDurationSeconds" : 74.65851211547852,
      "endOffsetSeconds" : 1690.8354452848434,
      "index" : 9,
      "label" : "Recovery 4",
      "maxHeartRateBpm" : 162,
      "paceSecondsPerKm" : 373.2925608197976,
      "plannedGoalDisplayText" : "200 m",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 200,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: interpolated crossing, adjustment +0.0s, overshoot 5.7 m",
      "startOffsetSeconds" : 1616.176933169365,
      "stepType" : "recovery"
    },
    {
      "averageHeartRateBpm" : 165.86666666666667,
      "averagePower" : 194.43150684931507,
      "boundaryAdjustmentSeconds" : 2.2614059448242188,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 5417.116270438768,
          "endDate" : "2026-06-28T13:14:56Z",
          "endOffsetSeconds" : 2065.9001923799515,
          "startCumulativeDistanceMeters" : 5409.626097196713,
          "startDate" : "2026-06-28T13:14:54Z",
          "startOffsetSeconds" : 2063.327294588089
        },
        "cumulativeDistanceAtEndMeters" : 5417.116270438768,
        "cumulativeDistanceAtStartMeters" : 4410.53290661309,
        "interpolationFraction" : 0.12106654773821604,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 5425.1432978347875,
          "endDate" : "2026-06-28T13:14:59Z",
          "endOffsetSeconds" : 2068.4730925559998,
          "startCumulativeDistanceMeters" : 5417.116270438768,
          "startDate" : "2026-06-28T13:14:56Z",
          "startOffsetSeconds" : 2065.9001923799515
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 5409.626097196713,
          "endDate" : "2026-06-28T13:14:54Z",
          "endOffsetSeconds" : 2063.327294588089,
          "startCumulativeDistanceMeters" : 5403.795289865928,
          "startDate" : "2026-06-28T13:14:51Z",
          "startOffsetSeconds" : 2060.754395365715
        },
        "targetDistanceMeters" : 1000
      },
      "boundaryOvershootMeters" : 6.583363825678134,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "displayDurationSeconds" : 375.06474709510803,
      "distanceMeters" : 1006.5833638256781,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 375.06474709510803,
      "elapsedDurationSeconds" : 375.06474709510803,
      "endOffsetSeconds" : 2065.9001923799515,
      "index" : 10,
      "label" : "Cooldown",
      "maxHeartRateBpm" : 169,
      "paceSecondsPerKm" : 372.61170865134864,
      "plannedGoalDisplayText" : "1 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 1000,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +2.3s, overshoot 6.6 m",
      "startOffsetSeconds" : 1690.8354452848434,
      "stepType" : "cooldown"
    },
    {
      "averageHeartRateBpm" : 143.4794520547945,
      "averagePower" : 91.98581560283688,
      "confidence" : "medium",
      "displayDurationSeconds" : 364.2061765193939,
      "distanceMeters" : 528.743986218702,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 364.2061765193939,
      "elapsedDurationSeconds" : 364.2061765193939,
      "endOffsetSeconds" : 2430.1063688993454,
      "index" : 11,
      "label" : "Open \/ Extra",
      "maxHeartRateBpm" : 169,
      "paceSecondsPerKm" : 688.8138418821636,
      "plannedGoalDisplayText" : "Open",
      "plannedGoalType" : "open",
      "sourceNote" : "Extra tail after planned WorkoutKit steps",
      "startOffsetSeconds" : 2065.9001923799515,
      "stepType" : "open",
      "tailDiagnostics" : {
        "creationReason" : "Remaining workout time or distance exceeded Open \/ Extra threshold after planned WorkoutKit steps.",
        "finalDistanceSampleCumulativeDistanceMeters" : 5945.86025665747,
        "finalDistanceSampleOffsetSeconds" : 2423.5285865068436,
        "lastCadenceSampleOffsetSeconds" : 2423.5285865068436,
        "lastHeartRateSampleOffsetSeconds" : 2423.9994778633118,
        "lastPowerSampleOffsetSeconds" : 2426.10140812397,
        "plannedFinalStepEndOffsetSeconds" : 2065.9001923799515,
        "remainingMeters" : 528.743986218702,
        "remainingSeconds" : 364.2061765193939,
        "workoutEndOffsetSeconds" : 2430.1063688993454
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
      "averageHeartRateBpm" : 141.89743589743588,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1006.6094232971217,
      "durationSeconds" : 386.5417444705963,
      "endOffsetSeconds" : 386.5417444705963,
      "index" : 1,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 384.00370145998573,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 144.65322580645162,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1615.8135079638967,
      "durationSeconds" : 621.8462615013123,
      "endOffsetSeconds" : 621.8462615013123,
      "index" : 2,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 384.85026795258517,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 149.64473684210526,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1000.0758916547805,
      "durationSeconds" : 385.99272668361664,
      "endOffsetSeconds" : 772.534471154213,
      "index" : 3,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 385.9634352798285,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 386.5417444705963
    },
    {
      "averageHeartRateBpm" : 151.95934959349594,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1610.1690358538806,
      "durationSeconds" : 618.8887813091278,
      "endOffsetSeconds" : 1240.73504281044,
      "index" : 4,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 384.3626150598083,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 621.8462615013123
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
      "distanceMeters" : 1000.8578217443057,
      "durationSeconds" : 385.4406270980835,
      "endOffsetSeconds" : 1157.9750982522964,
      "index" : 5,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 385.11027113354965,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 772.534471154213
    },
    {
      "averageHeartRateBpm" : 157.61333333333334,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 999.4675988093759,
      "durationSeconds" : 379.8786735534668,
      "endOffsetSeconds" : 1537.8537718057632,
      "index" : 6,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 380.08102914591774,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1157.9750982522964
    },
    {
      "averageHeartRateBpm" : 160.60655737704917,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1609.7181366049376,
      "durationSeconds" : 609.2504175901413,
      "endOffsetSeconds" : 1849.9854604005814,
      "index" : 7,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 378.4826695654393,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1240.73504281044
    },
    {
      "averageHeartRateBpm" : 162.78947368421052,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 998.9631412437925,
      "durationSeconds" : 376.0720977783203,
      "endOffsetSeconds" : 1913.9258695840836,
      "index" : 8,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 376.46243615162734,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1537.8537718057632
    },
    {
      "averageHeartRateBpm" : 152.02586206896552,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1110.1595762347551,
      "durationSeconds" : 576.115947842598,
      "endOffsetSeconds" : 2426.1014082431793,
      "index" : 9,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 518.9487711276312,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1849.9854604005814
    },
    {
      "averageHeartRateBpm" : 150.38834951456312,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 939.8863799080937,
      "durationSeconds" : 512.1755386590958,
      "endOffsetSeconds" : 2426.1014082431793,
      "index" : 10,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 544.933461754365,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1913.9258695840836
    }
  ],
  "sourceNotes" : [
    "Plan source: WorkoutKit",
    "Window source: Plan-derived from HealthKit distance\/time samples",
    "Stats source: HealthKit samples",
    "HealthKit segment markers: not used"
  ],
  "workout" : {
    "averageHeartRate" : 152.03699755529027,
    "averagePower" : 174.83333333333312,
    "cadenceSpm" : 162.50112772208658,
    "deviceName" : "Apple Watch Apple Inc. Watch",
    "distanceMeters" : 5945.86025665747,
    "durationSeconds" : 2430.1063688993454,
    "elapsedSeconds" : 2430.1063688993454,
    "endDate" : "2026-06-28T13:21:01Z",
    "id" : "376F0E84-E296-4F64-9B07-4D9AA085B817",
    "maxHeartRate" : 169,
    "paceSecondsPerKm" : 408.7055975085187,
    "sourceID" : "376F0E84-E296-4F64-9B07-4D9AA085B817",
    "sourceName" : "Adriel’s Apple Watch",
    "startDate" : "2026-06-28T12:40:31Z"
  },
  "workoutActivities" : [
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 771.7509466409683,
      "durationSeconds" : 774.9394506216049,
      "endDate" : "2026-06-28T12:53:25Z",
      "endOffsetSeconds" : 774.9394506216049,
      "events" : [
        {
          "durationSeconds" : 386.5417444705963,
          "endDate" : "2026-06-28T12:46:57Z",
          "endOffsetSeconds" : 386.5417444705963,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1006.6094232971217,
          "renderedSegmentMarkerDurationSeconds" : 386.5417444705963,
          "renderedSegmentMarkerEndOffsetSeconds" : 386.5417444705963,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:40:31Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 621.8462615013123,
          "endDate" : "2026-06-28T12:50:52Z",
          "endOffsetSeconds" : 621.8462615013123,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1615.8135079638967,
          "renderedSegmentMarkerDurationSeconds" : 621.8462615013123,
          "renderedSegmentMarkerEndOffsetSeconds" : 621.8462615013123,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:40:31Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 385.99272668361664,
          "endDate" : "2026-06-28T12:53:23Z",
          "endOffsetSeconds" : 772.534471154213,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1000.0758916547805,
          "renderedSegmentMarkerDurationSeconds" : 385.99272668361664,
          "renderedSegmentMarkerEndOffsetSeconds" : 772.534471154213,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 386.5417444705963,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:46:57Z",
          "startOffsetSeconds" : 386.5417444705963,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 618.8887813091278,
          "endDate" : "2026-06-28T13:01:11Z",
          "endOffsetSeconds" : 1240.73504281044,
          "index" : 4,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1610.1690358538806,
          "renderedSegmentMarkerDurationSeconds" : 618.8887813091278,
          "renderedSegmentMarkerEndOffsetSeconds" : 1240.73504281044,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 621.8462615013123,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:50:52Z",
          "startOffsetSeconds" : 621.8462615013123,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 385.4406270980835,
          "endDate" : "2026-06-28T12:59:49Z",
          "endOffsetSeconds" : 1157.9750982522964,
          "index" : 5,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1000.8578217443057,
          "renderedSegmentMarkerDurationSeconds" : 385.4406270980835,
          "renderedSegmentMarkerEndOffsetSeconds" : 1157.9750982522964,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 772.534471154213,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:53:23Z",
          "startOffsetSeconds" : 772.534471154213,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "5 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "055F5538-8680-4CA0-9259-0FB177636E3E",
      "index" : 1,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -2.4049794673919678,
      "nearestRawEventEndOffsetSeconds" : 772.534471154213,
      "nearestRawEventStartDeltaSeconds" : 0,
      "nearestRawEventStartOffsetSeconds" : 0,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -3.1885039806365967,
      "nearestReconstructedIntervalEndOffsetSeconds" : 771.7509466409683,
      "nearestReconstructedIntervalIndex" : 1,
      "nearestReconstructedIntervalLabel" : "Warmup",
      "nearestSegmentMarkerEndDeltaSeconds" : -2.4049794673919678,
      "nearestSegmentMarkerEndOffsetSeconds" : 772.534471154213,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : 0,
      "nearestSegmentMarkerStartOffsetSeconds" : 0,
      "nextDistanceSampleEndOffsetSeconds" : 774.32379591465,
      "previousDistanceSampleEndOffsetSeconds" : 769.1780968904495,
      "startDate" : "2026-06-28T12:40:31Z",
      "startOffsetSeconds" : 0,
      "statistics" : [
        {
          "endDate" : "2026-06-28T12:53:25Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:40:31Z",
          "sum" : 140.88612297897865,
          "summary" : "ActiveEnergyBurned: sum 140.9 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:53:25Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:40:31Z",
          "sum" : 18.91507519457298,
          "summary" : "BasalEnergyBurned: sum 18.9 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:53:25Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:40:31Z",
          "sum" : 2006.5409944102787,
          "summary" : "DistanceWalkingRunning: sum 2006.5 m",
          "unit" : "m"
        },
        {
          "average" : 145.59833922804864,
          "endDate" : "2026-06-28T12:53:25Z",
          "maximum" : 154,
          "minimum" : 127,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:40:31Z",
          "summary" : "HeartRate: avg 145.6 bpm, min 127.0 bpm, max 154.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 276.49650349650364,
          "endDate" : "2026-06-28T12:53:25Z",
          "maximum" : 296,
          "minimum" : 253,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:40:31Z",
          "summary" : "RunningGroundContactTime: avg 276.5 ms, min 253.0 ms, max 296.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 187.44,
          "endDate" : "2026-06-28T12:53:25Z",
          "maximum" : 202,
          "minimum" : 155,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:40:31Z",
          "summary" : "RunningPower: avg 187.4 W, min 155.0 W, max 202.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.633880930541934,
          "endDate" : "2026-06-28T12:53:25Z",
          "maximum" : 2.8330337836749293,
          "minimum" : 2.180015808022011,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:40:31Z",
          "summary" : "RunningSpeed: avg 2.6 m\/s, min 2.2 m\/s, max 2.8 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9038461538461541,
          "endDate" : "2026-06-28T12:53:25Z",
          "maximum" : 0.95,
          "minimum" : 0.85,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:40:31Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.8 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 7.099999999999999,
          "endDate" : "2026-06-28T12:53:25Z",
          "maximum" : 8.1,
          "minimum" : 6.7,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:40:31Z",
          "summary" : "RunningVerticalOscillation: avg 7.1 cm, min 6.7 cm, max 8.1 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T12:53:25Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:40:31Z",
          "sum" : 2232.4785776054914,
          "summary" : "StepCount: sum 2232.5 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 140.9 kcal; BasalEnergyBurned: sum 18.9 kcal; DistanceWalkingRunning: sum 2006.5 m; HeartRate: avg 145.6 bpm, min 127.0 bpm, max 154.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 2,
      "alignedPlannedStepLabel" : "Work 1",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 931.2668306827545,
      "durationSeconds" : 157.3156670331955,
      "endDate" : "2026-06-28T12:56:03Z",
      "endOffsetSeconds" : 932.2551176548004,
      "events" : [
        {
          "durationSeconds" : 618.8887813091278,
          "endDate" : "2026-06-28T13:01:11Z",
          "endOffsetSeconds" : 1240.73504281044,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1610.1690358538806,
          "renderedSegmentMarkerDurationSeconds" : 618.8887813091278,
          "renderedSegmentMarkerEndOffsetSeconds" : 1240.73504281044,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 621.8462615013123,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:50:52Z",
          "startOffsetSeconds" : 621.8462615013123,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 385.4406270980835,
          "endDate" : "2026-06-28T12:59:49Z",
          "endOffsetSeconds" : 1157.9750982522964,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1000.8578217443057,
          "renderedSegmentMarkerDurationSeconds" : 385.4406270980835,
          "renderedSegmentMarkerEndOffsetSeconds" : 1157.9750982522964,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 772.534471154213,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:53:23Z",
          "startOffsetSeconds" : 772.534471154213,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "2 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "3A6550A8-0A5A-461B-93A3-6445F8AC4B61",
      "index" : 2,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -159.72064650058746,
      "nearestRawEventEndOffsetSeconds" : 772.534471154213,
      "nearestRawEventStartDeltaSeconds" : -2.4049794673919678,
      "nearestRawEventStartOffsetSeconds" : 772.534471154213,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -2.9869502782821655,
      "nearestReconstructedIntervalEndOffsetSeconds" : 929.2681673765182,
      "nearestReconstructedIntervalIndex" : 2,
      "nearestReconstructedIntervalLabel" : "Work 1",
      "nearestSegmentMarkerEndDeltaSeconds" : -159.72064650058746,
      "nearestSegmentMarkerEndOffsetSeconds" : 772.534471154213,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -2.4049794673919678,
      "nearestSegmentMarkerStartOffsetSeconds" : 772.534471154213,
      "nextDistanceSampleEndOffsetSeconds" : 933.8396581411362,
      "previousDistanceSampleEndOffsetSeconds" : 928.6940019130707,
      "startDate" : "2026-06-28T12:53:25Z",
      "startOffsetSeconds" : 774.9394506216049,
      "statistics" : [
        {
          "endDate" : "2026-06-28T12:56:03Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:53:25Z",
          "sum" : 30.604707697774167,
          "summary" : "ActiveEnergyBurned: sum 30.6 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:56:03Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:53:25Z",
          "sum" : 3.8521246712346096,
          "summary" : "BasalEnergyBurned: sum 3.9 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:56:03Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:53:25Z",
          "sum" : 400.455214654905,
          "summary" : "DistanceWalkingRunning: sum 400.5 m",
          "unit" : "m"
        },
        {
          "average" : 151.57397959183675,
          "endDate" : "2026-06-28T12:56:03Z",
          "maximum" : 157,
          "minimum" : 148,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:53:25Z",
          "summary" : "HeartRate: avg 151.6 bpm, min 148.0 bpm, max 157.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 280.39285714285717,
          "endDate" : "2026-06-28T12:56:03Z",
          "maximum" : 288,
          "minimum" : 272,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:53:25Z",
          "summary" : "RunningGroundContactTime: avg 280.4 ms, min 272.0 ms, max 288.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 183.52459016393442,
          "endDate" : "2026-06-28T12:56:03Z",
          "maximum" : 198,
          "minimum" : 164,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:53:25Z",
          "summary" : "RunningPower: avg 183.5 W, min 164.0 W, max 198.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.58265320469668,
          "endDate" : "2026-06-28T12:56:03Z",
          "maximum" : 2.8185915008140094,
          "minimum" : 2.3171077753428233,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:53:25Z",
          "summary" : "RunningSpeed: avg 2.6 m\/s, min 2.3 m\/s, max 2.8 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.8955172413793104,
          "endDate" : "2026-06-28T12:56:03Z",
          "maximum" : 0.94,
          "minimum" : 0.83,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:53:25Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.8 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 7.071428571428571,
          "endDate" : "2026-06-28T12:56:03Z",
          "maximum" : 7.6,
          "minimum" : 6.6000000000000005,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:53:25Z",
          "summary" : "RunningVerticalOscillation: avg 7.1 cm, min 6.6 cm, max 7.6 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T12:56:03Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:53:25Z",
          "sum" : 442.2102963731287,
          "summary" : "StepCount: sum 442.2 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 30.6 kcal; BasalEnergyBurned: sum 3.9 kcal; DistanceWalkingRunning: sum 400.5 m; HeartRate: avg 151.6 bpm, min 148.0 bpm, max 157.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1008.4514565467834,
      "durationSeconds" : 76.88241314888,
      "endDate" : "2026-06-28T12:57:20Z",
      "endOffsetSeconds" : 1009.1375308036804,
      "events" : [
        {
          "durationSeconds" : 618.8887813091278,
          "endDate" : "2026-06-28T13:01:11Z",
          "endOffsetSeconds" : 1240.73504281044,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1610.1690358538806,
          "renderedSegmentMarkerDurationSeconds" : 618.8887813091278,
          "renderedSegmentMarkerEndOffsetSeconds" : 1240.73504281044,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 621.8462615013123,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:50:52Z",
          "startOffsetSeconds" : 621.8462615013123,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 385.4406270980835,
          "endDate" : "2026-06-28T12:59:49Z",
          "endOffsetSeconds" : 1157.9750982522964,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1000.8578217443057,
          "renderedSegmentMarkerDurationSeconds" : 385.4406270980835,
          "renderedSegmentMarkerEndOffsetSeconds" : 1157.9750982522964,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 772.534471154213,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:53:23Z",
          "startOffsetSeconds" : 772.534471154213,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "2 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "276AEC06-4278-4B0B-8575-3C082CBB2CF3",
      "index" : 3,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : 148.83756744861603,
      "nearestRawEventEndOffsetSeconds" : 1157.9750982522964,
      "nearestRawEventStartDeltaSeconds" : -159.72064650058746,
      "nearestRawEventStartOffsetSeconds" : 772.534471154213,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -3.1410857439041138,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1005.9964450597763,
      "nearestReconstructedIntervalIndex" : 3,
      "nearestReconstructedIntervalLabel" : "Recovery 1",
      "nearestSegmentMarkerEndDeltaSeconds" : 148.83756744861603,
      "nearestSegmentMarkerEndOffsetSeconds" : 1157.9750982522964,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -159.72064650058746,
      "nearestSegmentMarkerStartOffsetSeconds" : 772.534471154213,
      "nextDistanceSampleEndOffsetSeconds" : 1011.0242695808411,
      "previousDistanceSampleEndOffsetSeconds" : 1005.8786470890045,
      "startDate" : "2026-06-28T12:56:03Z",
      "startOffsetSeconds" : 932.2551176548004,
      "statistics" : [
        {
          "endDate" : "2026-06-28T12:57:20Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:56:03Z",
          "sum" : 14.982567571072611,
          "summary" : "ActiveEnergyBurned: sum 15.0 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:57:20Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:56:03Z",
          "sum" : 1.8825999084520912,
          "summary" : "BasalEnergyBurned: sum 1.9 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:57:20Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:56:03Z",
          "sum" : 200.21201621345432,
          "summary" : "DistanceWalkingRunning: sum 200.2 m",
          "unit" : "m"
        },
        {
          "average" : 151.25652173913042,
          "endDate" : "2026-06-28T12:57:20Z",
          "maximum" : 154,
          "minimum" : 149,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:56:03Z",
          "summary" : "HeartRate: avg 151.3 bpm, min 149.0 bpm, max 154.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 280.92857142857144,
          "endDate" : "2026-06-28T12:57:20Z",
          "maximum" : 290,
          "minimum" : 271,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:56:03Z",
          "summary" : "RunningGroundContactTime: avg 280.9 ms, min 271.0 ms, max 290.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 187.03333333333333,
          "endDate" : "2026-06-28T12:57:20Z",
          "maximum" : 192,
          "minimum" : 183,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:56:03Z",
          "summary" : "RunningPower: avg 187.0 W, min 183.0 W, max 192.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.62661152036819,
          "endDate" : "2026-06-28T12:57:20Z",
          "maximum" : 2.6936895668883594,
          "minimum" : 2.5542338652702994,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:56:03Z",
          "summary" : "RunningSpeed: avg 2.6 m\/s, min 2.6 m\/s, max 2.7 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9107142857142857,
          "endDate" : "2026-06-28T12:57:20Z",
          "maximum" : 0.92,
          "minimum" : 0.9,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:56:03Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 6.892857142857143,
          "endDate" : "2026-06-28T12:57:20Z",
          "maximum" : 7.1,
          "minimum" : 6.6000000000000005,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:56:03Z",
          "summary" : "RunningVerticalOscillation: avg 6.9 cm, min 6.6 cm, max 7.1 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T12:57:20Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:56:03Z",
          "sum" : 220.91110452230117,
          "summary" : "StepCount: sum 220.9 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 15.0 kcal; BasalEnergyBurned: sum 1.9 kcal; DistanceWalkingRunning: sum 200.2 m; HeartRate: avg 151.3 bpm, min 149.0 bpm, max 154.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 4,
      "alignedPlannedStepLabel" : "Work 2",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1157.6750727891922,
      "durationSeconds" : 151.52106297016144,
      "endDate" : "2026-06-28T12:59:51Z",
      "endOffsetSeconds" : 1160.6585937738419,
      "events" : [
        {
          "durationSeconds" : 618.8887813091278,
          "endDate" : "2026-06-28T13:01:11Z",
          "endOffsetSeconds" : 1240.73504281044,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1610.1690358538806,
          "renderedSegmentMarkerDurationSeconds" : 618.8887813091278,
          "renderedSegmentMarkerEndOffsetSeconds" : 1240.73504281044,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 621.8462615013123,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:50:52Z",
          "startOffsetSeconds" : 621.8462615013123,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 385.4406270980835,
          "endDate" : "2026-06-28T12:59:49Z",
          "endOffsetSeconds" : 1157.9750982522964,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1000.8578217443057,
          "renderedSegmentMarkerDurationSeconds" : 385.4406270980835,
          "renderedSegmentMarkerEndOffsetSeconds" : 1157.9750982522964,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 772.534471154213,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:53:23Z",
          "startOffsetSeconds" : 772.534471154213,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 379.8786735534668,
          "endDate" : "2026-06-28T13:06:08Z",
          "endOffsetSeconds" : 1537.8537718057632,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 999.4675988093759,
          "renderedSegmentMarkerDurationSeconds" : 379.8786735534668,
          "renderedSegmentMarkerEndOffsetSeconds" : 1537.8537718057632,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1157.9750982522964,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:59:49Z",
          "startOffsetSeconds" : 1157.9750982522964,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "3 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "553ED29E-A19C-478C-AF2B-A7D33D8E22BC",
      "index" : 4,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -2.68349552154541,
      "nearestRawEventEndOffsetSeconds" : 1157.9750982522964,
      "nearestRawEventStartDeltaSeconds" : 148.83756744861603,
      "nearestRawEventStartOffsetSeconds" : 1157.9750982522964,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -2.983520984649658,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1157.6750727891922,
      "nearestReconstructedIntervalIndex" : 4,
      "nearestReconstructedIntervalLabel" : "Work 2",
      "nearestSegmentMarkerEndDeltaSeconds" : -2.68349552154541,
      "nearestSegmentMarkerEndOffsetSeconds" : 1157.9750982522964,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : 148.83756744861603,
      "nearestSegmentMarkerStartOffsetSeconds" : 1157.9750982522964,
      "nextDistanceSampleEndOffsetSeconds" : 1160.2478969097137,
      "previousDistanceSampleEndOffsetSeconds" : 1155.10224711895,
      "startDate" : "2026-06-28T12:57:20Z",
      "startOffsetSeconds" : 1009.1375308036804,
      "statistics" : [
        {
          "endDate" : "2026-06-28T12:59:51Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:57:20Z",
          "sum" : 29.912096743384467,
          "summary" : "ActiveEnergyBurned: sum 29.9 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:59:51Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:57:20Z",
          "sum" : 3.710256821013826,
          "summary" : "BasalEnergyBurned: sum 3.7 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T12:59:51Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:57:20Z",
          "sum" : 400.66743088555467,
          "summary" : "DistanceWalkingRunning: sum 400.7 m",
          "unit" : "m"
        },
        {
          "average" : 152.47674418604652,
          "endDate" : "2026-06-28T12:59:51Z",
          "maximum" : 157,
          "minimum" : 149,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:57:20Z",
          "summary" : "HeartRate: avg 152.5 bpm, min 149.0 bpm, max 157.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 280.55172413793105,
          "endDate" : "2026-06-28T12:59:51Z",
          "maximum" : 289,
          "minimum" : 271,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:57:20Z",
          "summary" : "RunningGroundContactTime: avg 280.6 ms, min 271.0 ms, max 289.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 187.86440677966098,
          "endDate" : "2026-06-28T12:59:51Z",
          "maximum" : 194,
          "minimum" : 183,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:57:20Z",
          "summary" : "RunningPower: avg 187.9 W, min 183.0 W, max 194.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.653923489252878,
          "endDate" : "2026-06-28T12:59:51Z",
          "maximum" : 2.76185086369165,
          "minimum" : 2.5532005796126636,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:57:20Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 2.6 m\/s, max 2.8 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9155172413793102,
          "endDate" : "2026-06-28T12:59:51Z",
          "maximum" : 0.95,
          "minimum" : 0.89,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:57:20Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 6.993103448275861,
          "endDate" : "2026-06-28T12:59:51Z",
          "maximum" : 7.3,
          "minimum" : 6.7,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:57:20Z",
          "summary" : "RunningVerticalOscillation: avg 7.0 cm, min 6.7 cm, max 7.3 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T12:59:51Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:57:20Z",
          "sum" : 435.5174209739116,
          "summary" : "StepCount: sum 435.5 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 29.9 kcal; BasalEnergyBurned: sum 3.7 kcal; DistanceWalkingRunning: sum 400.7 m; HeartRate: avg 152.5 bpm, min 149.0 bpm, max 157.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1234.860275030136,
      "durationSeconds" : 75.99018025398254,
      "endDate" : "2026-06-28T13:01:07Z",
      "endOffsetSeconds" : 1236.6487740278244,
      "events" : [
        {
          "durationSeconds" : 618.8887813091278,
          "endDate" : "2026-06-28T13:01:11Z",
          "endOffsetSeconds" : 1240.73504281044,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1610.1690358538806,
          "renderedSegmentMarkerDurationSeconds" : 618.8887813091278,
          "renderedSegmentMarkerEndOffsetSeconds" : 1240.73504281044,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 621.8462615013123,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:50:52Z",
          "startOffsetSeconds" : 621.8462615013123,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 379.8786735534668,
          "endDate" : "2026-06-28T13:06:08Z",
          "endOffsetSeconds" : 1537.8537718057632,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 999.4675988093759,
          "renderedSegmentMarkerDurationSeconds" : 379.8786735534668,
          "renderedSegmentMarkerEndOffsetSeconds" : 1537.8537718057632,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1157.9750982522964,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:59:49Z",
          "startOffsetSeconds" : 1157.9750982522964,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "2 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "914539F0-6739-4A44-ABE7-981F7584EAC0",
      "index" : 5,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : 4.086268782615662,
      "nearestRawEventEndOffsetSeconds" : 1240.73504281044,
      "nearestRawEventStartDeltaSeconds" : -2.68349552154541,
      "nearestRawEventStartOffsetSeconds" : 1157.9750982522964,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -3.1139036417007446,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1233.5348703861237,
      "nearestReconstructedIntervalIndex" : 5,
      "nearestReconstructedIntervalLabel" : "Recovery 2",
      "nearestSegmentMarkerEndDeltaSeconds" : 4.086268782615662,
      "nearestSegmentMarkerEndOffsetSeconds" : 1240.73504281044,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -2.68349552154541,
      "nearestSegmentMarkerStartOffsetSeconds" : 1157.9750982522964,
      "nextDistanceSampleEndOffsetSeconds" : 1237.4331077337265,
      "previousDistanceSampleEndOffsetSeconds" : 1232.2874413728714,
      "startDate" : "2026-06-28T12:59:51Z",
      "startOffsetSeconds" : 1160.6585937738419,
      "statistics" : [
        {
          "endDate" : "2026-06-28T13:01:07Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:59:51Z",
          "sum" : 14.994762439931627,
          "summary" : "ActiveEnergyBurned: sum 15.0 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:01:07Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:59:51Z",
          "sum" : 1.860737714195766,
          "summary" : "BasalEnergyBurned: sum 1.9 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:01:07Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:59:51Z",
          "sum" : 200.44888219433057,
          "summary" : "DistanceWalkingRunning: sum 200.4 m",
          "unit" : "m"
        },
        {
          "average" : 153.4396551724138,
          "endDate" : "2026-06-28T13:01:07Z",
          "maximum" : 157,
          "minimum" : 150,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:59:51Z",
          "summary" : "HeartRate: avg 153.4 bpm, min 150.0 bpm, max 157.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 271.9230769230769,
          "endDate" : "2026-06-28T13:01:07Z",
          "maximum" : 279,
          "minimum" : 262,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:59:51Z",
          "summary" : "RunningGroundContactTime: avg 271.9 ms, min 262.0 ms, max 279.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 190.6896551724138,
          "endDate" : "2026-06-28T13:01:07Z",
          "maximum" : 194,
          "minimum" : 185,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:59:51Z",
          "summary" : "RunningPower: avg 190.7 W, min 185.0 W, max 194.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.6957578858858695,
          "endDate" : "2026-06-28T13:01:07Z",
          "maximum" : 2.7723245973392534,
          "minimum" : 2.61443618773884,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:59:51Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 2.6 m\/s, max 2.8 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9176923076923078,
          "endDate" : "2026-06-28T13:01:07Z",
          "maximum" : 0.94,
          "minimum" : 0.91,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:59:51Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 7.069230769230769,
          "endDate" : "2026-06-28T13:01:07Z",
          "maximum" : 7.3999999999999995,
          "minimum" : 6.800000000000001,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:59:51Z",
          "summary" : "RunningVerticalOscillation: avg 7.1 cm, min 6.8 cm, max 7.4 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T13:01:07Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T12:59:51Z",
          "sum" : 216.4437829376652,
          "summary" : "StepCount: sum 216.4 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 15.0 kcal; BasalEnergyBurned: sum 1.9 kcal; DistanceWalkingRunning: sum 200.4 m; HeartRate: avg 153.4 bpm, min 150.0 bpm, max 157.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 6,
      "alignedPlannedStepLabel" : "Work 3",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1386.6577240228653,
      "durationSeconds" : 152.24168384075165,
      "endDate" : "2026-06-28T13:03:39Z",
      "endOffsetSeconds" : 1388.890457868576,
      "events" : [
        {
          "durationSeconds" : 618.8887813091278,
          "endDate" : "2026-06-28T13:01:11Z",
          "endOffsetSeconds" : 1240.73504281044,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1610.1690358538806,
          "renderedSegmentMarkerDurationSeconds" : 618.8887813091278,
          "renderedSegmentMarkerEndOffsetSeconds" : 1240.73504281044,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 621.8462615013123,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:50:52Z",
          "startOffsetSeconds" : 621.8462615013123,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 379.8786735534668,
          "endDate" : "2026-06-28T13:06:08Z",
          "endOffsetSeconds" : 1537.8537718057632,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 999.4675988093759,
          "renderedSegmentMarkerDurationSeconds" : 379.8786735534668,
          "renderedSegmentMarkerEndOffsetSeconds" : 1537.8537718057632,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1157.9750982522964,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:59:49Z",
          "startOffsetSeconds" : 1157.9750982522964,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 609.2504175901413,
          "endDate" : "2026-06-28T13:11:21Z",
          "endOffsetSeconds" : 1849.9854604005814,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1609.7181366049376,
          "renderedSegmentMarkerDurationSeconds" : 609.2504175901413,
          "renderedSegmentMarkerEndOffsetSeconds" : 1849.9854604005814,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1240.73504281044,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:01:11Z",
          "startOffsetSeconds" : 1240.73504281044,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "3 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "00220B15-6B22-450D-BA8B-49BF2C5E2DFD",
      "index" : 6,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -148.155415058136,
      "nearestRawEventEndOffsetSeconds" : 1240.73504281044,
      "nearestRawEventStartDeltaSeconds" : 4.086268782615662,
      "nearestRawEventStartOffsetSeconds" : 1240.73504281044,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -2.2327338457107544,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1386.6577240228653,
      "nearestReconstructedIntervalIndex" : 6,
      "nearestReconstructedIntervalLabel" : "Work 3",
      "nearestSegmentMarkerEndDeltaSeconds" : -148.155415058136,
      "nearestSegmentMarkerEndOffsetSeconds" : 1240.73504281044,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : 4.086268782615662,
      "nearestSegmentMarkerStartOffsetSeconds" : 1240.73504281044,
      "nextDistanceSampleEndOffsetSeconds" : 1389.2305612564087,
      "previousDistanceSampleEndOffsetSeconds" : 1384.0848885774612,
      "startDate" : "2026-06-28T13:01:07Z",
      "startOffsetSeconds" : 1236.6487740278244,
      "statistics" : [
        {
          "endDate" : "2026-06-28T13:03:39Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:01:07Z",
          "sum" : 31.384227771724152,
          "summary" : "ActiveEnergyBurned: sum 31.4 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:03:39Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:01:07Z",
          "sum" : 3.7278777196998987,
          "summary" : "BasalEnergyBurned: sum 3.7 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:03:39Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:01:07Z",
          "sum" : 400.2513401425558,
          "summary" : "DistanceWalkingRunning: sum 400.3 m",
          "unit" : "m"
        },
        {
          "average" : 158.64736842105262,
          "endDate" : "2026-06-28T13:03:39Z",
          "maximum" : 161,
          "minimum" : 156,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:01:07Z",
          "summary" : "HeartRate: avg 158.6 bpm, min 156.0 bpm, max 161.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 279.10344827586204,
          "endDate" : "2026-06-28T13:03:39Z",
          "maximum" : 293,
          "minimum" : 263,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:01:07Z",
          "summary" : "RunningGroundContactTime: avg 279.1 ms, min 263.0 ms, max 293.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 192.84745762711862,
          "endDate" : "2026-06-28T13:03:39Z",
          "maximum" : 198,
          "minimum" : 187,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:01:07Z",
          "summary" : "RunningPower: avg 192.8 W, min 187.0 W, max 198.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.7096657302943292,
          "endDate" : "2026-06-28T13:03:39Z",
          "maximum" : 2.7760161804829093,
          "minimum" : 2.629336395559735,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:01:07Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 2.6 m\/s, max 2.8 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.93,
          "endDate" : "2026-06-28T13:03:39Z",
          "maximum" : 0.97,
          "minimum" : 0.91,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:01:07Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 1.0 m",
          "unit" : "m"
        },
        {
          "average" : 7.071428571428571,
          "endDate" : "2026-06-28T13:03:39Z",
          "maximum" : 7.6,
          "minimum" : 6.6000000000000005,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:01:07Z",
          "summary" : "RunningVerticalOscillation: avg 7.1 cm, min 6.6 cm, max 7.6 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T13:03:39Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:01:07Z",
          "sum" : 437.38129748199816,
          "summary" : "StepCount: sum 437.4 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 31.4 kcal; BasalEnergyBurned: sum 3.7 kcal; DistanceWalkingRunning: sum 400.3 m; HeartRate: avg 158.6 bpm, min 156.0 bpm, max 161.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 7,
      "alignedPlannedStepLabel" : "Recovery 3",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1463.8429609537125,
      "durationSeconds" : 75.21527469158173,
      "endDate" : "2026-06-28T13:04:55Z",
      "endOffsetSeconds" : 1464.1057325601578,
      "events" : [
        {
          "durationSeconds" : 379.8786735534668,
          "endDate" : "2026-06-28T13:06:08Z",
          "endOffsetSeconds" : 1537.8537718057632,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 999.4675988093759,
          "renderedSegmentMarkerDurationSeconds" : 379.8786735534668,
          "renderedSegmentMarkerEndOffsetSeconds" : 1537.8537718057632,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1157.9750982522964,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:59:49Z",
          "startOffsetSeconds" : 1157.9750982522964,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 609.2504175901413,
          "endDate" : "2026-06-28T13:11:21Z",
          "endOffsetSeconds" : 1849.9854604005814,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1609.7181366049376,
          "renderedSegmentMarkerDurationSeconds" : 609.2504175901413,
          "renderedSegmentMarkerEndOffsetSeconds" : 1849.9854604005814,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1240.73504281044,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:01:11Z",
          "startOffsetSeconds" : 1240.73504281044,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "2 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "BA0E9C87-9CF1-43AF-9F38-A788144D6381",
      "index" : 7,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : 73.74803924560547,
      "nearestRawEventEndOffsetSeconds" : 1537.8537718057632,
      "nearestRawEventStartDeltaSeconds" : -148.155415058136,
      "nearestRawEventStartOffsetSeconds" : 1240.73504281044,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -0.2627716064453125,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1463.8429609537125,
      "nearestReconstructedIntervalIndex" : 7,
      "nearestReconstructedIntervalLabel" : "Recovery 3",
      "nearestSegmentMarkerEndDeltaSeconds" : 73.74803924560547,
      "nearestSegmentMarkerEndOffsetSeconds" : 1537.8537718057632,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -148.155415058136,
      "nearestSegmentMarkerStartOffsetSeconds" : 1240.73504281044,
      "nextDistanceSampleEndOffsetSeconds" : 1466.415799498558,
      "previousDistanceSampleEndOffsetSeconds" : 1461.270123243332,
      "startDate" : "2026-06-28T13:03:39Z",
      "startOffsetSeconds" : 1388.890457868576,
      "statistics" : [
        {
          "endDate" : "2026-06-28T13:04:55Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:03:39Z",
          "sum" : 15.532623934365759,
          "summary" : "ActiveEnergyBurned: sum 15.5 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:04:55Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:03:39Z",
          "sum" : 1.841762347072297,
          "summary" : "BasalEnergyBurned: sum 1.8 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:04:55Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:03:39Z",
          "sum" : 197.55514381243003,
          "summary" : "DistanceWalkingRunning: sum 197.6 m",
          "unit" : "m"
        },
        {
          "average" : 158.52542372881356,
          "endDate" : "2026-06-28T13:04:55Z",
          "maximum" : 161,
          "minimum" : 156,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:03:39Z",
          "summary" : "HeartRate: avg 158.5 bpm, min 156.0 bpm, max 161.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 279.2142857142857,
          "endDate" : "2026-06-28T13:04:55Z",
          "maximum" : 284,
          "minimum" : 270,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:03:39Z",
          "summary" : "RunningGroundContactTime: avg 279.2 ms, min 270.0 ms, max 284.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 191.46666666666667,
          "endDate" : "2026-06-28T13:04:55Z",
          "maximum" : 196,
          "minimum" : 185,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:03:39Z",
          "summary" : "RunningPower: avg 191.5 W, min 185.0 W, max 196.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.6883639326944713,
          "endDate" : "2026-06-28T13:04:55Z",
          "maximum" : 2.7530158265045652,
          "minimum" : 2.609713208898704,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:03:39Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 2.6 m\/s, max 2.8 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.93,
          "endDate" : "2026-06-28T13:04:55Z",
          "maximum" : 0.95,
          "minimum" : 0.91,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:03:39Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 6.98,
          "endDate" : "2026-06-28T13:04:55Z",
          "maximum" : 7.1,
          "minimum" : 6.800000000000001,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:03:39Z",
          "summary" : "RunningVerticalOscillation: avg 7.0 cm, min 6.8 cm, max 7.1 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T13:04:55Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:03:39Z",
          "sum" : 214.67031784278535,
          "summary" : "StepCount: sum 214.7 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 15.5 kcal; BasalEnergyBurned: sum 1.8 kcal; DistanceWalkingRunning: sum 197.6 m; HeartRate: avg 158.5 bpm, min 156.0 bpm, max 161.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 8,
      "alignedPlannedStepLabel" : "Work 4",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1618.2148365974426,
      "durationSeconds" : 153.40174007415771,
      "endDate" : "2026-06-28T13:07:28Z",
      "endOffsetSeconds" : 1617.5074726343155,
      "events" : [
        {
          "durationSeconds" : 379.8786735534668,
          "endDate" : "2026-06-28T13:06:08Z",
          "endOffsetSeconds" : 1537.8537718057632,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 999.4675988093759,
          "renderedSegmentMarkerDurationSeconds" : 379.8786735534668,
          "renderedSegmentMarkerEndOffsetSeconds" : 1537.8537718057632,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1157.9750982522964,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T12:59:49Z",
          "startOffsetSeconds" : 1157.9750982522964,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 609.2504175901413,
          "endDate" : "2026-06-28T13:11:21Z",
          "endOffsetSeconds" : 1849.9854604005814,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1609.7181366049376,
          "renderedSegmentMarkerDurationSeconds" : 609.2504175901413,
          "renderedSegmentMarkerEndOffsetSeconds" : 1849.9854604005814,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1240.73504281044,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:01:11Z",
          "startOffsetSeconds" : 1240.73504281044,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 376.0720977783203,
          "endDate" : "2026-06-28T13:12:24Z",
          "endOffsetSeconds" : 1913.9258695840836,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 998.9631412437925,
          "renderedSegmentMarkerDurationSeconds" : 376.0720977783203,
          "renderedSegmentMarkerEndOffsetSeconds" : 1913.9258695840836,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1537.8537718057632,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:06:08Z",
          "startOffsetSeconds" : 1537.8537718057632,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "3 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "A841BD5C-E295-43FF-8C8A-6CA0BCB9ECB6",
      "index" : 8,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -79.65370082855225,
      "nearestRawEventEndOffsetSeconds" : 1537.8537718057632,
      "nearestRawEventStartDeltaSeconds" : 73.74803924560547,
      "nearestRawEventStartOffsetSeconds" : 1537.8537718057632,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -1.3305394649505615,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1616.176933169365,
      "nearestReconstructedIntervalIndex" : 8,
      "nearestReconstructedIntervalLabel" : "Work 4",
      "nearestSegmentMarkerEndDeltaSeconds" : -79.65370082855225,
      "nearestSegmentMarkerEndOffsetSeconds" : 1537.8537718057632,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : 73.74803924560547,
      "nearestSegmentMarkerStartOffsetSeconds" : 1537.8537718057632,
      "nextDistanceSampleEndOffsetSeconds" : 1620.787729024887,
      "previousDistanceSampleEndOffsetSeconds" : 1615.6419404745102,
      "startDate" : "2026-06-28T13:04:55Z",
      "startOffsetSeconds" : 1464.1057325601578,
      "statistics" : [
        {
          "endDate" : "2026-06-28T13:07:28Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:04:55Z",
          "sum" : 31.921728333174485,
          "summary" : "ActiveEnergyBurned: sum 31.9 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:07:28Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:04:55Z",
          "sum" : 3.7562450946592105,
          "summary" : "BasalEnergyBurned: sum 3.8 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:07:28Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:04:55Z",
          "sum" : 401.29302189747835,
          "summary" : "DistanceWalkingRunning: sum 401.3 m",
          "unit" : "m"
        },
        {
          "average" : 159.2474226804124,
          "endDate" : "2026-06-28T13:07:28Z",
          "maximum" : 161,
          "minimum" : 157,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:04:55Z",
          "summary" : "HeartRate: avg 159.2 bpm, min 157.0 bpm, max 161.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 278.7037037037037,
          "endDate" : "2026-06-28T13:07:28Z",
          "maximum" : 285,
          "minimum" : 273,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:04:55Z",
          "summary" : "RunningGroundContactTime: avg 278.7 ms, min 273.0 ms, max 285.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 189.72881355932205,
          "endDate" : "2026-06-28T13:07:28Z",
          "maximum" : 195,
          "minimum" : 182,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:04:55Z",
          "summary" : "RunningPower: avg 189.7 W, min 182.0 W, max 195.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.69031189798164,
          "endDate" : "2026-06-28T13:07:28Z",
          "maximum" : 2.7506591464445567,
          "minimum" : 2.587542887018952,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:04:55Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 2.6 m\/s, max 2.8 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9314814814814815,
          "endDate" : "2026-06-28T13:07:28Z",
          "maximum" : 0.95,
          "minimum" : 0.91,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:04:55Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 7.1259259259259276,
          "endDate" : "2026-06-28T13:07:28Z",
          "maximum" : 7.3,
          "minimum" : 6.9,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:04:55Z",
          "summary" : "RunningVerticalOscillation: avg 7.1 cm, min 6.9 cm, max 7.3 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T13:07:28Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:04:55Z",
          "sum" : 439.46269870512975,
          "summary" : "StepCount: sum 439.5 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 31.9 kcal; BasalEnergyBurned: sum 3.8 kcal; DistanceWalkingRunning: sum 401.3 m; HeartRate: avg 159.2 bpm, min 157.0 bpm, max 161.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 9,
      "alignedPlannedStepLabel" : "Recovery 4",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1692.8291079998016,
      "durationSeconds" : 74.98504281044006,
      "endDate" : "2026-06-28T13:08:43Z",
      "endOffsetSeconds" : 1692.4925154447556,
      "events" : [
        {
          "durationSeconds" : 609.2504175901413,
          "endDate" : "2026-06-28T13:11:21Z",
          "endOffsetSeconds" : 1849.9854604005814,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1609.7181366049376,
          "renderedSegmentMarkerDurationSeconds" : 609.2504175901413,
          "renderedSegmentMarkerEndOffsetSeconds" : 1849.9854604005814,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1240.73504281044,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:01:11Z",
          "startOffsetSeconds" : 1240.73504281044,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 376.0720977783203,
          "endDate" : "2026-06-28T13:12:24Z",
          "endOffsetSeconds" : 1913.9258695840836,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 998.9631412437925,
          "renderedSegmentMarkerDurationSeconds" : 376.0720977783203,
          "renderedSegmentMarkerEndOffsetSeconds" : 1913.9258695840836,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1537.8537718057632,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:06:08Z",
          "startOffsetSeconds" : 1537.8537718057632,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "2 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "55E498DB-1CE0-4619-B54A-DCD0FACFC22B",
      "index" : 9,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -154.6387436389923,
      "nearestRawEventEndOffsetSeconds" : 1537.8537718057632,
      "nearestRawEventStartDeltaSeconds" : -79.65370082855225,
      "nearestRawEventStartOffsetSeconds" : 1537.8537718057632,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -1.6570701599121094,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1690.8354452848434,
      "nearestReconstructedIntervalIndex" : 9,
      "nearestReconstructedIntervalLabel" : "Recovery 4",
      "nearestSegmentMarkerEndDeltaSeconds" : -154.6387436389923,
      "nearestSegmentMarkerEndOffsetSeconds" : 1537.8537718057632,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -79.65370082855225,
      "nearestSegmentMarkerStartOffsetSeconds" : 1537.8537718057632,
      "nextDistanceSampleEndOffsetSeconds" : 1695.4020380973816,
      "previousDistanceSampleEndOffsetSeconds" : 1690.2561737298965,
      "startDate" : "2026-06-28T13:07:28Z",
      "startOffsetSeconds" : 1617.5074726343155,
      "statistics" : [
        {
          "endDate" : "2026-06-28T13:08:43Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:07:28Z",
          "sum" : 15.554911919552087,
          "summary" : "ActiveEnergyBurned: sum 15.6 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:08:43Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:07:28Z",
          "sum" : 1.8360788374183885,
          "summary" : "BasalEnergyBurned: sum 1.8 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:08:43Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:07:28Z",
          "sum" : 200.5364019804669,
          "summary" : "DistanceWalkingRunning: sum 200.5 m",
          "unit" : "m"
        },
        {
          "average" : 159.2758620689655,
          "endDate" : "2026-06-28T13:08:43Z",
          "maximum" : 162,
          "minimum" : 158,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:07:28Z",
          "summary" : "HeartRate: avg 159.3 bpm, min 158.0 bpm, max 162.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 279.3846153846154,
          "endDate" : "2026-06-28T13:08:43Z",
          "maximum" : 284,
          "minimum" : 274,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:07:28Z",
          "summary" : "RunningGroundContactTime: avg 279.4 ms, min 274.0 ms, max 284.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 191.75862068965515,
          "endDate" : "2026-06-28T13:08:43Z",
          "maximum" : 197,
          "minimum" : 188,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:07:28Z",
          "summary" : "RunningPower: avg 191.8 W, min 188.0 W, max 197.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.711632177396475,
          "endDate" : "2026-06-28T13:08:43Z",
          "maximum" : 2.7948747491829664,
          "minimum" : 2.6526295886190447,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:07:28Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 2.7 m\/s, max 2.8 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9342857142857144,
          "endDate" : "2026-06-28T13:08:43Z",
          "maximum" : 0.96,
          "minimum" : 0.92,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:07:28Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 1.0 m",
          "unit" : "m"
        },
        {
          "average" : 7.1,
          "endDate" : "2026-06-28T13:08:43Z",
          "maximum" : 7.3,
          "minimum" : 6.9,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:07:28Z",
          "summary" : "RunningVerticalOscillation: avg 7.1 cm, min 6.9 cm, max 7.3 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T13:08:43Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:07:28Z",
          "sum" : 210.87793953461127,
          "summary" : "StepCount: sum 210.9 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 15.6 kcal; BasalEnergyBurned: sum 1.8 kcal; DistanceWalkingRunning: sum 200.5 m; HeartRate: avg 159.3 bpm, min 158.0 bpm, max 162.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 10,
      "alignedPlannedStepLabel" : "Cooldown",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 2065.9001923799515,
      "durationSeconds" : 372.4029680490494,
      "endDate" : "2026-06-28T13:14:55Z",
      "endOffsetSeconds" : 2064.895483493805,
      "events" : [
        {
          "durationSeconds" : 609.2504175901413,
          "endDate" : "2026-06-28T13:11:21Z",
          "endOffsetSeconds" : 1849.9854604005814,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1609.7181366049376,
          "renderedSegmentMarkerDurationSeconds" : 609.2504175901413,
          "renderedSegmentMarkerEndOffsetSeconds" : 1849.9854604005814,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1240.73504281044,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:01:11Z",
          "startOffsetSeconds" : 1240.73504281044,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 376.0720977783203,
          "endDate" : "2026-06-28T13:12:24Z",
          "endOffsetSeconds" : 1913.9258695840836,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 998.9631412437925,
          "renderedSegmentMarkerDurationSeconds" : 376.0720977783203,
          "renderedSegmentMarkerEndOffsetSeconds" : 1913.9258695840836,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1537.8537718057632,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:06:08Z",
          "startOffsetSeconds" : 1537.8537718057632,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 576.115947842598,
          "endDate" : "2026-06-28T13:20:57Z",
          "endOffsetSeconds" : 2426.1014082431793,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1110.1595762347551,
          "renderedSegmentMarkerDurationSeconds" : 576.115947842598,
          "renderedSegmentMarkerEndOffsetSeconds" : 2426.1014082431793,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1849.9854604005814,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:11:21Z",
          "startOffsetSeconds" : 1849.9854604005814,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 512.1755386590958,
          "endDate" : "2026-06-28T13:20:57Z",
          "endOffsetSeconds" : 2426.1014082431793,
          "index" : 4,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 939.8863799080937,
          "renderedSegmentMarkerDurationSeconds" : 512.1755386590958,
          "renderedSegmentMarkerEndOffsetSeconds" : 2426.1014082431793,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1913.9258695840836,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-28T13:12:24Z",
          "startOffsetSeconds" : 1913.9258695840836,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "4 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "80410643-AC23-41B0-8844-E479BC2C1B43",
      "index" : 10,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath"
      ],
      "nearestRawEventEndDeltaSeconds" : -150.96961390972137,
      "nearestRawEventEndOffsetSeconds" : 1913.9258695840836,
      "nearestRawEventStartDeltaSeconds" : -154.6387436389923,
      "nearestRawEventStartOffsetSeconds" : 1537.8537718057632,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : 1.0047088861465454,
      "nearestReconstructedIntervalEndOffsetSeconds" : 2065.9001923799515,
      "nearestReconstructedIntervalIndex" : 10,
      "nearestReconstructedIntervalLabel" : "Cooldown",
      "nearestSegmentMarkerEndDeltaSeconds" : -150.96961390972137,
      "nearestSegmentMarkerEndOffsetSeconds" : 1913.9258695840836,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -154.6387436389923,
      "nearestSegmentMarkerStartOffsetSeconds" : 1537.8537718057632,
      "nextDistanceSampleEndOffsetSeconds" : 2068.4730925559998,
      "previousDistanceSampleEndOffsetSeconds" : 2063.327294588089,
      "startDate" : "2026-06-28T13:08:43Z",
      "startOffsetSeconds" : 1692.4925154447556,
      "statistics" : [
        {
          "endDate" : "2026-06-28T13:14:55Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:08:43Z",
          "sum" : 80.63918179946006,
          "summary" : "ActiveEnergyBurned: sum 80.6 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:14:55Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:08:43Z",
          "sum" : 9.118640381401647,
          "summary" : "BasalEnergyBurned: sum 9.1 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-28T13:14:55Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:08:43Z",
          "sum" : 999.3887381962164,
          "summary" : "DistanceWalkingRunning: sum 999.4 m",
          "unit" : "m"
        },
        {
          "average" : 165.80868508958397,
          "endDate" : "2026-06-28T13:14:55Z",
          "maximum" : 169,
          "minimum" : 160,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:08:43Z",
          "summary" : "HeartRate: avg 165.8 bpm, min 160.0 bpm, max 169.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 276.2727272727273,
          "endDate" : "2026-06-28T13:14:55Z",
          "maximum" : 289,
          "minimum" : 265,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:08:43Z",
          "summary" : "RunningGroundContactTime: avg 276.3 ms, min 265.0 ms, max 289.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 194.44137931034484,
          "endDate" : "2026-06-28T13:14:55Z",
          "maximum" : 201,
          "minimum" : 184,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:08:43Z",
          "summary" : "RunningPower: avg 194.4 W, min 184.0 W, max 201.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.7401206175017103,
          "endDate" : "2026-06-28T13:14:55Z",
          "maximum" : 2.8452244869033954,
          "minimum" : 2.619272526149887,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:08:43Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 2.6 m\/s, max 2.8 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9475757575757576,
          "endDate" : "2026-06-28T13:14:55Z",
          "maximum" : 0.99,
          "minimum" : 0.91,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:08:43Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 1.0 m",
          "unit" : "m"
        },
        {
          "average" : 7.086764705882354,
          "endDate" : "2026-06-28T13:14:55Z",
          "maximum" : 7.5,
          "minimum" : 6.6000000000000005,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:08:43Z",
          "summary" : "RunningVerticalOscillation: avg 7.1 cm, min 6.6 cm, max 7.5 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-28T13:14:55Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-28T13:08:43Z",
          "sum" : 1047.3130849764063,
          "summary" : "StepCount: sum 1047.3 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 80.6 kcal; BasalEnergyBurned: sum 9.1 kcal; DistanceWalkingRunning: sum 999.4 m; HeartRate: avg 165.8 bpm, min 160.0 bpm, max 169.0 bpm"
    }
  ],
  "workoutKitPlanAudit" : {
    "displayName" : "Priority 2 (no pause)",
    "planID" : "DFD6B93D-D335-45F5-B2A9-7BE2707A3549",
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