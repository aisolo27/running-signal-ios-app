# RunSignal Raw HealthKit Debug Export

Generated: 2026-06-29T20:58:52Z

## Review Packet Scope

This packet bundles Raw HealthKit Debug, WorkoutKit plan audit, HealthKit activity rows, Parity Lab candidate rows, structured comparison, fallback labels, pause/tail diagnostics, source metadata, and boundary warnings. It is debug/export-only and does not approve normal workout detail behavior.

Whole-run stats remain usable when custom interval rows are blocked. External HealthFit/FIT archives stay offline validation evidence; attach or reference them separately and do not treat FIT as app input or runtime truth.

Blocked custom interval diagnostics are review aids only. A supported Parity Lab status, readable fallback label, or exported candidate row does not change normal workout detail unless the exact ledger row separately reaches the normal-detail promotion rung.

## Workout

| Field | Value |
|---|---|
| Workout ID | B2227876-F1EA-4A3D-937B-F5D988986539 |
| Source | Adriel’s Apple Watch |
| Source ID | B2227876-F1EA-4A3D-937B-F5D988986539 |
| Device | Apple Watch Apple Inc. Watch |
| Start | Jun 29, 2026 |
| End | Jun 29, 2026 |
| Duration | 31:44 |
| Elapsed | 31:44 |
| Distance | 5.04 km |
| Avg pace | 6:18 /km |
| Avg HR | 134 bpm |
| Max HR | 149 bpm |
| Cadence | 173 spm |
| Power | 192 W |

## Evidence Counts

| Metric | Count |
|---|---:|
| Heart rate | 380 |
| Speed | 738 |
| Distance | 738 |
| Active energy | 739 |
| Power | 738 |
| Cadence | 740 |
| Step count | 740 |
| Stride length | 345 |
| Vertical oscillation | 347 |
| Ground contact | 347 |
| Route points | 1905 |
| Events | 11 |
| Workout activities | 5 |

## WorkoutKit Plan Audit

- Status: Available
- Plan type: Custom workout
- Plan ID: CDE675EF-37A2-420B-91AE-F15683627ADE
- Display name: Priority 4 (no pause) 
- Activity: HKWorkoutActivityType(rawValue: 37)
- Warmup: goal 1 km, alert pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current
- Block 1: 1x, 1 step(s)
- Block 1 step 1: Work - goal 1 km, alert pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current
- Block 2: 1x, 1 step(s)
- Block 2 step 1: Recovery - goal 120 s, alert none
- Block 3: 1x, 1 step(s)
- Block 3 step 1: Work - goal 1 km, alert pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current
- Cooldown: goal 1 km, alert pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current

## Raw HKWorkoutEvent Inventory

Debug-only inventory of public `HKWorkoutEvent` date windows and metadata keys. These rows are not Apple Fitness interval truth.

| Row | Event Type | Label | Start Offset | End Offset | Duration | Metadata Keys | Rendered Marker Window | Marker Distance | Marker Kind | Used By Segment Rendering | Excluded / Filtered Reason | Debug-Only Reason |
|---:|---|---|---:|---:|---:|---|---:|---:|---|---|---|---|
| 1 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 6:22 | 382.5 s | Unavailable | 0:00-6:22 | 1.01 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 2 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 10:13 | 612.9 s | Unavailable | 0:00-10:13 | 1.62 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 3 | HKWorkoutEventType(rawValue: 7) | Unavailable | 6:22 | 12:37 | 374.7 s | Unavailable | 6:22-12:37 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 4 | HKWorkoutEventType(rawValue: 7) | Unavailable | 10:13 | 20:13 | 600.4 s | Unavailable | 10:13-20:13 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 5 | HKWorkoutEventType(rawValue: 7) | Unavailable | 12:37 | 18:51 | 373.8 s | Unavailable | 12:37-18:51 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 6 | HKWorkoutEventType(rawValue: 7) | Unavailable | 18:51 | 25:09 | 378.1 s | Unavailable | 18:51-25:09 | 1.00 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 7 | HKWorkoutEventType(rawValue: 7) | Unavailable | 20:13 | 30:18 | 605.1 s | Unavailable | 20:13-30:18 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 8 | HKWorkoutEventType(rawValue: 7) | Unavailable | 25:09 | 31:26 | 377.0 s | Unavailable | 25:09-31:26 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 9 | HKWorkoutEventType(rawValue: 7) | Unavailable | 30:18 | 31:41 | 82.2 s | Unavailable | 30:18-31:41 | 0.20 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 10 | HKWorkoutEventType(rawValue: 7) | Unavailable | 31:26 | 31:41 | 14.5 s | Unavailable | 31:26-31:41 | 0.03 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 11 | HKWorkoutEventType(rawValue: 1) | Unavailable | 31:44 | 31:44 | 0.0 s | Unavailable | Unavailable | Unavailable | Unavailable | No | Excluded from segment rendering: zero or negative duration. | No rendered segment marker candidate. |

## HKWorkoutActivity Inventory

Debug-only inventory of public `HKWorkout.workoutActivities` rows. These rows are not used for production interval reconstruction.

| Activity | Type | Start Date | End Date | Start Offset | End Offset | Duration | Metadata Keys | Nested Events | Statistics | Aligns Planned Step | Aligned Planned Step | Nearest Reconstructed Row | Row End Delta | Apple Fitness/manual | FIT Lap | Raw Event Start | Raw Start Delta | Raw Event End | Raw End Delta | Segment Start | Segment Start Delta | Segment End | Segment End Delta | Previous Sample End | Crossing Sample End | Next Sample End |
|---:|---|---|---|---:|---:|---:|---|---|---|---|---|---|---:|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | HKWorkoutActivityType(rawValue: 37) | 2026-06-29T11:56:25Z | 2026-06-29T12:02:51Z | 0.0 s | 385.3 s | 385.3 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 3 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 60.1 kcal; BasalEnergyBurned: sum 9.4 kcal; DistanceWalkingRunning: sum 1009.1 m; HeartRate: avg 116.3 bpm, min 62.0 bpm, max 131.0 bpm | No | Unavailable | Warmup | -5.2 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 0.0 s | 0.0 s | 382.5 s | -2.9 s | 0.0 s | 0.0 s | 382.5 s | -2.9 s | 377.5 s | 380.1 s | 382.7 s |
| 2 | HKWorkoutActivityType(rawValue: 37) | 2026-06-29T12:02:51Z | 2026-06-29T12:09:06Z | 385.3 s | 760.3 s | 375.0 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 4 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 60.8 kcal; BasalEnergyBurned: sum 9.2 kcal; DistanceWalkingRunning: sum 998.8 m; HeartRate: avg 132.9 bpm, min 127.0 bpm, max 137.0 bpm | No | Unavailable | Work 1 | -4.6 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 382.5 s | -2.9 s | 757.2 s | -3.1 s | 382.5 s | -2.9 s | 757.2 s | -3.1 s | 753.2 s | 755.7 s | 758.3 s |
| 3 | HKWorkoutActivityType(rawValue: 37) | 2026-06-29T12:09:06Z | 2026-06-29T12:11:06Z | 760.3 s | 880.2 s | 119.9 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 2 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 19.0 kcal; BasalEnergyBurned: sum 2.9 kcal; DistanceWalkingRunning: sum 317.6 m; HeartRate: avg 134.0 bpm, min 131.0 bpm, max 138.0 bpm | No | Unavailable | Recovery 1 | -4.4 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 757.2 s | -3.1 s | 757.2 s | -123.0 s | 757.2 s | -3.1 s | 757.2 s | -123.0 s | Unavailable | Unavailable | Unavailable |
| 4 | HKWorkoutActivityType(rawValue: 37) | 2026-06-29T12:11:06Z | 2026-06-29T12:17:18Z | 880.2 s | 1252.2 s | 372.0 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 4 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 60.5 kcal; BasalEnergyBurned: sum 9.1 kcal; DistanceWalkingRunning: sum 994.9 m; HeartRate: avg 137.5 bpm, min 131.0 bpm, max 144.0 bpm | Yes | Work 1 | Work 1 | -2.5 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 757.2 s | -123.0 s | 1213.3 s | -38.9 s | 757.2 s | -123.0 s | 1213.3 s | -38.9 s | 1247.1 s | 1249.7 s | 1252.3 s |
| 5 | HKWorkoutActivityType(rawValue: 37) | 2026-06-29T12:17:18Z | 2026-06-29T12:23:31Z | 1252.2 s | 1625.4 s | 373.2 s | HKElevationAscended, WOIntervalStepKeyPath | 3 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 61.3 kcal; BasalEnergyBurned: sum 9.1 kcal; DistanceWalkingRunning: sum 1002.7 m; HeartRate: avg 142.4 bpm, min 138.0 bpm, max 146.0 bpm | Yes | Cooldown | Cooldown | -2.7 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 1213.3 s | -38.9 s | 1509.1 s | -116.3 s | 1213.3 s | -38.9 s | 1509.1 s | -116.3 s | 1620.2 s | 1622.7 s | 1625.3 s |

## WorkoutKit Reconstructed Intervals

Planned structure source: WorkoutKit when available. Measured stats source: HealthKit samples.

| Row | Label | Goal | Target | Distance | Elapsed | Pause overlap | Active time | Display time | Duration rule | Pace | Avg HR | Max HR | Power | Start Offset | End Offset | Boundary Strategy | Boundary Adjustment | Overshoot | Confidence | Notes |
|---:|---|---|---|---:|---:|---:|---:|---:|---|---:|---:|---:|---:|---:|---:|---|---:|---:|---|---|
| 1 | Warmup | 1 km | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 1.00 km | 6:20 |  | Unavailable | 6:20 | elapsedRowWindow | 6:20 /km | 118 bpm | 131 bpm | 188 W | 0:00 | 6:20 | crossing sample end | 0.2 s | 0.5 m | High | Distance-goal boundary: crossing sample end, adjustment +0.2s, overshoot 0.5 m |
| 2 | Work 1 | 1 km | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 1.00 km | 6:16 |  | Unavailable | 6:16 | elapsedRowWindow | 6:15 /km | 133 bpm | 137 bpm | 195 W | 6:20 | 12:36 | crossing sample end | 0.9 s | 1.9 m | High | Distance-goal boundary: crossing sample end, adjustment +0.9s, overshoot 1.9 m |
| 3 | Recovery 1 | 120 s | Target unavailable | 0.32 km | 2:00 |  | Unavailable | 2:00 | elapsedRowWindow | 6:18 /km | 133 bpm | 137 bpm | 191 W | 12:36 | 14:36 |  |  |  | High | Time-goal window reconstructed from WorkoutKit duration; active duration subtracts reliable paired pause overlap. |
| 4 | Work 1 | 1 km | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 1.00 km | 6:14 |  | Unavailable | 6:14 | elapsedRowWindow | 6:14 /km | 138 bpm | 144 bpm | 193 W | 14:36 | 20:50 | crossing sample end | 0.2 s | 0.2 m | High | Distance-goal boundary: crossing sample end, adjustment +0.2s, overshoot 0.2 m |
| 5 | Cooldown | 1 km | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 1.00 km | 6:13 |  | Unavailable | 6:13 | elapsedRowWindow | 6:12 /km | 142 bpm | 146 bpm | 193 W | 20:50 | 27:03 | crossing sample end | 0.9 s | 2.3 m | High | Distance-goal boundary: crossing sample end, adjustment +0.9s, overshoot 2.3 m |
| 6 | Open / Extra | Open | Target unavailable | 0.72 km | 4:41 |  | Unavailable | 4:41 | elapsedRowWindow | 6:33 /km | 144 bpm | 149 bpm | 189 W | 27:03 | 31:44 |  |  |  | Medium | Extra tail after planned WorkoutKit steps |

Notes: Plan source: WorkoutKit · Window source: Plan-derived from HealthKit distance/time samples · Stats source: HealthKit samples · HealthKit segment markers: not used

## HKWorkoutActivity Boundary Candidate Intervals

Debug-only alternate reconstruction for Parity Lab exports. These rows are not production interval logic and are not shown in the normal workout UI.

| Field | Value |
|---|---|
| Mapping status | mappedByPlannedStepOrder |
| Activity count | 5 |
| Planned step count | 5 |
| Scoreable | Yes |
| Not scoreable reason | n/a |
| Production UI warning | HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI. |

| Row | Label | Goal | Mapping | Activity | Start Offset | End Offset | Distance | Time | Candidate Confidence | Reason If Not Scoreable | Caveats |
|---:|---|---|---|---:|---:|---:|---:|---:|---|---|---|
| 1 | Warmup | 1 km | mappedByPlannedStepOrder | 1 | 0.0 s | 385.3 s | 1009.1 m | 385.3 s | activity boundary direct |  | Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 2 | Work 1 | 1 km | mappedByPlannedStepOrder | 2 | 385.3 s | 760.3 s | 998.8 m | 375.0 s | activity boundary direct |  | Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 3 | Recovery 1 | 120 s | mappedByPlannedStepOrder | 3 | 760.3 s | 880.2 s | 317.6 m | 119.9 s | activity boundary direct |  | Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 4 | Work 1 | 1 km | mappedByPlannedStepOrder | 4 | 880.2 s | 1252.2 s | 994.9 m | 372.0 s | activity boundary direct |  | Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 5 | Cooldown | 1 km | mappedByPlannedStepOrder | 5 | 1252.2 s | 1625.4 s | 1002.7 m | 373.2 s | activity boundary direct |  | Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 6 | Open / Extra | Open | inferredOpenTailFromWorkoutEnd | Inferred | 1625.4 s | 1904.1 s | 715.4 m | 278.7 s | activity boundary inferred tail |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Inferred from workout end minus final mapped activity boundary. No separate HKWorkoutActivity row represented this tail. |

Caveats: debug-only, not promoted · not production interval logic · not shown in normal workout UI · FIT and Apple Fitness/manual rows are not runtime inputs · Activities are generic HealthKit activity windows and labels are mapped from WorkoutKit planned step order. · Missing or ambiguous activity rows must not replace current reconstruction.

## Custom Workout Candidate Rule Scorer

Debug-only Parity Lab scorer for active-time duration, pause overlap, and Open / Extra tail rows. These rows are not production interval logic, are not shown in the normal workout UI, and do not approve a normal-detail gate.

| Field | Value |
|---|---|
| Strategy | custom_workout_candidate_rule_active_time |
| Rule status | candidate-rule-scoreable |
| Candidate row count | 6 |
| Planned expanded row count | 5 |
| Open tail row count | 1 |
| Paired pause count | 0 |
| Total paired pause | 0.0 s |
| Fixed row exhaustion | fixed-rows-exhausted-before-tail |
| Tail status | open-extra-tail-present |
| Tail duration | 278.7 s |
| Tail distance | 715.4 m |
| Fallback reasons |  |
| Safety flags | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. |
| FIT validation | offline-evidence-only-not-runtime-truth |
| Scoreable | Yes |
| Not scoreable reason | n/a |
| Production UI warning | Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI. |

| Row | Label | Mapping | Start offset | End offset | Elapsed | Pause overlap | Active time | Distance | Display rule | Duration rule | Confidence | Caveats |
|---:|---|---|---:|---:|---:|---:|---:|---:|---|---|---|---|
| 1 | Warmup | mappedByPlannedStepOrder | 0.0 s | 385.3 s | 385.3 s | 0.0 s | 385.3 s | 1009.1 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 2 | Work 1 | mappedByPlannedStepOrder | 385.3 s | 760.3 s | 375.0 s | 0.0 s | 375.0 s | 998.8 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 3 | Recovery 1 | mappedByPlannedStepOrder | 760.3 s | 880.2 s | 119.9 s | 0.0 s | 119.9 s | 317.6 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 4 | Work 1 | mappedByPlannedStepOrder | 880.2 s | 1252.2 s | 372.0 s | 0.0 s | 372.0 s | 994.9 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 5 | Cooldown | mappedByPlannedStepOrder | 1252.2 s | 1625.4 s | 373.2 s | 0.0 s | 373.2 s | 1002.7 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 6 | Open / Extra | inferredOpenTailFromWorkoutEnd | 1625.4 s | 1904.1 s | 278.7 s | 0.0 s | 278.7 s | 715.4 m | open-tail-measured-duration | open-tail-measured-duration | activity boundary inferred tail | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Inferred from workout end minus final mapped activity boundary. No separate HKWorkoutActivity row represented this tail. |

Caveats: debug-only, not promoted · not production interval logic · not shown in normal workout UI · FIT and Apple Fitness/manual rows are not runtime inputs · Active duration subtracts paired HealthKit pause/resume overlap when available.

## Custom Workout Structured Comparison

Debug-only structured status and fallback taxonomy for Parity Lab rows. This status is not production interval logic, is not shown in the normal workout UI, and does not approve a normal-detail gate by itself.

| Field | Value |
|---|---|
| Status | supported |
| Status label | Structured comparison is supported. |
| Fallback reasons | None |
| Primary fallback | None |
| Row count | 5 |
| Row confidences | supported, supported, supported, supported, supported |
| Tail ambiguity | fixedCooldownFollowedByPossibleOpenExtraTail |
| Promotes production behavior | No |
| Scope | debug/export-only |
| Normal workout UI changed | No |
| Uses FIT runtime truth | No |

## WorkoutKit Boundary Diagnostics

### Row 1: Warmup

| Field | Value |
|---|---:|
| Target distance | 1000.0 m |
| Start offset | 0:00 |
| End offset | 6:20 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 0.2 s |
| Overshoot | 0.5 m |
| Cumulative distance at start | 0.0 m |
| Cumulative distance at end | 1000.5 m |
| Interpolation fraction | 0.915 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 6:15 | 6:18 | 986.7 m | 994.9 m |
| Crossing | 6:18 | 6:20 | 994.9 m | 1000.5 m |
| Next | 6:20 | 6:23 | 1000.5 m | 1008.8 m |

### Row 2: Work 1

| Field | Value |
|---|---:|
| Target distance | 1000.0 m |
| Start offset | 6:20 |
| End offset | 12:36 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 0.9 s |
| Overshoot | 1.9 m |
| Cumulative distance at start | 1000.5 m |
| Cumulative distance at end | 2002.3 m |
| Interpolation fraction | 0.656 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 12:31 | 12:33 | 1989.9 m | 1996.9 m |
| Crossing | 12:33 | 12:36 | 1996.9 m | 2002.3 m |
| Next | 12:36 | 12:38 | 2002.3 m | 2009.4 m |

### Row 4: Work 1

| Field | Value |
|---|---:|
| Target distance | 1000.0 m |
| Start offset | 14:36 |
| End offset | 20:50 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 0.2 s |
| Overshoot | 0.2 m |
| Cumulative distance at start | 2320.2 m |
| Cumulative distance at end | 3320.4 m |
| Interpolation fraction | 0.940 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 20:45 | 20:47 | 3309.2 m | 3316.5 m |
| Crossing | 20:47 | 20:50 | 3316.5 m | 3320.4 m |
| Next | 20:50 | 20:52 | 3320.4 m | 3331.3 m |

### Row 5: Cooldown

| Field | Value |
|---|---:|
| Target distance | 1000.0 m |
| Start offset | 20:50 |
| End offset | 27:03 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 0.9 s |
| Overshoot | 2.3 m |
| Cumulative distance at start | 3320.4 m |
| Cumulative distance at end | 4322.7 m |
| Interpolation fraction | 0.651 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 26:58 | 27:00 | 4310.0 m | 4316.1 m |
| Crossing | 27:00 | 27:03 | 4316.1 m | 4322.7 m |
| Next | 27:03 | 27:05 | 4322.7 m | 4330.1 m |

### Row 6: Open / Extra Tail

| Field | Value |
|---|---:|
| Planned final step end offset | 27:03 |
| Workout end offset | 31:44 |
| Remaining seconds | 281.4 s |
| Remaining meters | 715.7 m |
| Final distance sample offset | 31:38 |
| Final distance sample cumulative | 5038.4 m |
| Last HR sample offset | 31:40 |
| Last power sample offset | 31:41 |
| Last cadence sample offset | 31:43 |
| Reason | Remaining workout time or distance exceeded Open / Extra threshold after planned WorkoutKit steps. |

## HealthKit Segment Markers

Raw debug only. HealthKit Segment Markers must not be promoted as Apple Fitness interval rows.

| Row | Label | Marker Kind | Source | Distance | Time | Pace | Avg HR | Start Offset | End Offset | Confidence | Caveats |
|---:|---|---|---|---:|---:|---:|---:|---:|---:|---|---|
| 1 | Unknown | Split marker | HealthKit segment pattern | 1.01 km | 6:22 | 6:19 /km | 118 bpm | 0:00 | 6:22 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 2 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.62 km | 10:13 | 6:19 /km | 123 bpm | 0:00 | 10:13 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 3 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:15 | 6:15 /km | 133 bpm | 6:22 | 12:37 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 4 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 10:00 | 6:13 /km | 136 bpm | 10:13 | 20:13 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 5 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:14 | 6:14 /km | 135 bpm | 12:37 | 18:51 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 6 | Unknown | Split marker | HealthKit segment pattern | 1.00 km | 6:18 | 6:16 /km | 141 bpm | 18:51 | 25:09 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 7 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 10:05 | 6:16 /km | 143 bpm | 20:13 | 30:18 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 8 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:17 | 6:19 /km | 144 bpm | 25:09 | 31:26 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 9 | Unknown | Overlapping segment marker | HealthKit segment pattern | 0.20 km | 1:22 | 6:43 /km | 142 bpm | 30:18 | 31:41 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 10 | Unknown | Overlapping segment marker | HealthKit segment pattern | 0.03 km | 0:15 | 7:32 /km | 141 bpm | 31:26 | 31:41 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |

## Planned Step Boundary Comparison

Debug-only comparison helper for FIT/Apple boundary investigation. The FIT lap end offset is intentionally a manual placeholder; RunSignal does not read FIT at runtime.

| Row | Planned Step | Goal | RunSignal End | FIT Lap End | Nearest Raw Event End | Event Delta | Nearest Activity End | Activity Delta | Activity Type | Nearest Segment End | Segment Delta | Previous Sample End | Crossing Sample End | Next Sample End | Warning |
|---:|---|---|---:|---:|---:|---:|---:|---:|---|---:|---:|---:|---:|---:|---|
| 1 | Warmup | 1 km | 380.1 s | Manual FIT placeholder | 382.5 s | 2.4 s | 385.3 s | 5.2 s | HKWorkoutActivityType(rawValue: 37) | 382.5 s | 2.4 s | 377.5 s | 380.1 s | 382.7 s |  |
| 2 | Work 1 | 1 km | 755.7 s | Manual FIT placeholder | 757.2 s | 1.5 s | 760.3 s | 4.6 s | HKWorkoutActivityType(rawValue: 37) | 757.2 s | 1.5 s | 753.2 s | 755.7 s | 758.3 s |  |
| 3 | Recovery 1 | 120 s | 875.7 s | Manual FIT placeholder | 757.2 s | -118.5 s | 880.2 s | 4.4 s | HKWorkoutActivityType(rawValue: 37) | 757.2 s | -118.5 s | Unavailable | Unavailable | Unavailable | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 4 | Work 1 | 1 km | 1249.7 s | Manual FIT placeholder | 1213.3 s | -36.4 s | 1252.2 s | 2.5 s | HKWorkoutActivityType(rawValue: 37) | 1213.3 s | -36.4 s | 1247.1 s | 1249.7 s | 1252.3 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 5 | Cooldown | 1 km | 1622.7 s | Manual FIT placeholder | 1509.1 s | -113.6 s | 1625.4 s | 2.7 s | HKWorkoutActivityType(rawValue: 37) | 1509.1 s | -113.6 s | 1620.2 s | 1622.7 s | 1625.3 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 6 | Open / Extra | Open | 1904.1 s | Manual FIT placeholder | 1900.6 s | -3.6 s | 1625.4 s | -278.7 s | HKWorkoutActivityType(rawValue: 37) | 1900.6 s | -3.6 s | Unavailable | Unavailable | Unavailable | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |

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
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 1009.055418806329,
      "durationSeconds" : 385.3351848125458,
      "endOffsetSeconds" : 385.3351848125458,
      "index" : 1,
      "label" : "Warmup",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "1 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 1000,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 0,
      "stepType" : "warmup"
    },
    {
      "activityIndex" : 2,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 998.7806252063344,
      "durationSeconds" : 374.9580247402191,
      "endOffsetSeconds" : 760.2932095527649,
      "index" : 2,
      "label" : "Work 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "1 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 1000,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 385.3351848125458,
      "stepType" : "work"
    },
    {
      "activityIndex" : 3,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 317.6312901694349,
      "durationSeconds" : 119.88019299507141,
      "endOffsetSeconds" : 880.1734025478363,
      "index" : 3,
      "label" : "Recovery 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "120 s",
      "plannedGoalType" : "time",
      "plannedGoalValue" : 120,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 760.2932095527649,
      "stepType" : "recovery"
    },
    {
      "activityIndex" : 4,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 994.8709033485997,
      "durationSeconds" : 372.02334666252136,
      "endOffsetSeconds" : 1252.1967492103577,
      "index" : 4,
      "label" : "Work 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "1 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 1000,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 880.1734025478363,
      "stepType" : "work"
    },
    {
      "activityIndex" : 5,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 1002.6938880537947,
      "durationSeconds" : 373.2097953557968,
      "endOffsetSeconds" : 1625.4065445661545,
      "index" : 5,
      "label" : "Cooldown",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "1 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 1000,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1252.1967492103577,
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
      "distanceMeters" : 715.4083173745867,
      "durationSeconds" : 278.7364624738693,
      "endOffsetSeconds" : 1904.1430070400238,
      "index" : 6,
      "label" : "Open \/ Extra",
      "mappingStatus" : "inferredOpenTailFromWorkoutEnd",
      "plannedGoalDisplayText" : "Open",
      "plannedGoalType" : "open",
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1625.4065445661545,
      "stepType" : "open"
    }
  ],
  "activityBoundaryCandidateSummary" : {
    "activityCount" : 5,
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
    "plannedStepCount" : 5,
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
          "endCumulativeDistanceMeters" : 1000.4737301554997,
          "endDate" : "2026-06-29T12:02:45Z",
          "endOffsetSeconds" : 380.0976564884186,
          "startCumulativeDistanceMeters" : 994.9306376106106,
          "startDate" : "2026-06-29T12:02:43Z",
          "startOffsetSeconds" : 377.52485716342926
        },
        "cumulativeDistanceAtEndMeters" : 1000.4737301554997,
        "cumulativeDistanceAtStartMeters" : 0,
        "interpolationFraction" : 0.9145368489406789,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 1008.7953529320657,
          "endDate" : "2026-06-29T12:02:48Z",
          "endOffsetSeconds" : 382.6704571247101,
          "startCumulativeDistanceMeters" : 1000.4737301554997,
          "startDate" : "2026-06-29T12:02:45Z",
          "startOffsetSeconds" : 380.0976564884186
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 994.9306376106106,
          "endDate" : "2026-06-29T12:02:43Z",
          "endOffsetSeconds" : 377.52485716342926,
          "startCumulativeDistanceMeters" : 986.6898067917209,
          "startDate" : "2026-06-29T12:02:40Z",
          "startOffsetSeconds" : 374.95205640792847
        },
        "targetDistanceMeters" : 1000
      },
      "index" : 1,
      "label" : "Warmup"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 2002.3472920570057,
          "endDate" : "2026-06-29T12:09:01Z",
          "endOffsetSeconds" : 755.7270810604095,
          "startCumulativeDistanceMeters" : 1996.9038647902198,
          "startDate" : "2026-06-29T12:08:59Z",
          "startOffsetSeconds" : 753.1543092727661
        },
        "cumulativeDistanceAtEndMeters" : 2002.3472920570057,
        "cumulativeDistanceAtStartMeters" : 1000.4737301554997,
        "interpolationFraction" : 0.6558120813080507,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2009.4314649295993,
          "endDate" : "2026-06-29T12:09:04Z",
          "endOffsetSeconds" : 758.2998538017273,
          "startCumulativeDistanceMeters" : 2002.3472920570057,
          "startDate" : "2026-06-29T12:09:01Z",
          "startOffsetSeconds" : 755.7270810604095
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 1996.9038647902198,
          "endDate" : "2026-06-29T12:08:59Z",
          "endOffsetSeconds" : 753.1543092727661,
          "startCumulativeDistanceMeters" : 1989.8724876604974,
          "startDate" : "2026-06-29T12:08:56Z",
          "startOffsetSeconds" : 750.5815391540527
        },
        "targetDistanceMeters" : 1000
      },
      "index" : 2,
      "label" : "Work 1"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3320.438686862588,
          "endDate" : "2026-06-29T12:17:15Z",
          "endOffsetSeconds" : 1249.6888868808746,
          "startCumulativeDistanceMeters" : 3316.4526569314767,
          "startDate" : "2026-06-29T12:17:13Z",
          "startOffsetSeconds" : 1247.116190314293
        },
        "cumulativeDistanceAtEndMeters" : 3320.438686862588,
        "cumulativeDistanceAtStartMeters" : 2320.200609448414,
        "interpolationFraction" : 0.9402720455469623,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3331.3221397860907,
          "endDate" : "2026-06-29T12:17:18Z",
          "endOffsetSeconds" : 1252.2615820169449,
          "startCumulativeDistanceMeters" : 3320.438686862588,
          "startDate" : "2026-06-29T12:17:15Z",
          "startOffsetSeconds" : 1249.6888868808746
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3316.4526569314767,
          "endDate" : "2026-06-29T12:17:13Z",
          "endOffsetSeconds" : 1247.116190314293,
          "startCumulativeDistanceMeters" : 3309.1567216168623,
          "startDate" : "2026-06-29T12:17:10Z",
          "startOffsetSeconds" : 1244.543494105339
        },
        "targetDistanceMeters" : 1000
      },
      "index" : 4,
      "label" : "Work 1"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 4322.73835345963,
          "endDate" : "2026-06-29T12:23:28Z",
          "endOffsetSeconds" : 1622.7307941913605,
          "startCumulativeDistanceMeters" : 4316.145080376649,
          "startDate" : "2026-06-29T12:23:26Z",
          "startOffsetSeconds" : 1620.158043384552
        },
        "cumulativeDistanceAtEndMeters" : 4322.73835345963,
        "cumulativeDistanceAtStartMeters" : 3320.438686862588,
        "interpolationFraction" : 0.6512101701083296,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 4330.076221011579,
          "endDate" : "2026-06-29T12:23:31Z",
          "endOffsetSeconds" : 1625.3035442829132,
          "startCumulativeDistanceMeters" : 4322.73835345963,
          "startDate" : "2026-06-29T12:23:28Z",
          "startOffsetSeconds" : 1622.7307941913605
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 4316.145080376649,
          "endDate" : "2026-06-29T12:23:26Z",
          "endOffsetSeconds" : 1620.158043384552,
          "startCumulativeDistanceMeters" : 4309.965034197783,
          "startDate" : "2026-06-29T12:23:23Z",
          "startOffsetSeconds" : 1617.5852938890457
        },
        "targetDistanceMeters" : 1000
      },
      "index" : 5,
      "label" : "Cooldown"
    },
    {
      "index" : 6,
      "label" : "Open \/ Extra",
      "tail" : {
        "creationReason" : "Remaining workout time or distance exceeded Open \/ Extra threshold after planned WorkoutKit steps.",
        "finalDistanceSampleCumulativeDistanceMeters" : 5038.4404429590795,
        "finalDistanceSampleOffsetSeconds" : 1898.0153962373734,
        "lastCadenceSampleOffsetSeconds" : 1903.1609038114548,
        "lastHeartRateSampleOffsetSeconds" : 1900.1574779748917,
        "lastPowerSampleOffsetSeconds" : 1900.5881489515305,
        "plannedFinalStepEndOffsetSeconds" : 1622.7307941913605,
        "remainingMeters" : 715.7020894994494,
        "remainingSeconds" : 281.41221284866333,
        "workoutEndOffsetSeconds" : 1904.1430070400238
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
      "activeDurationSeconds" : 385.3351848125458,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 1009.055418806329,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 385.3351848125458,
      "endOffsetSeconds" : 385.3351848125458,
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
      "activeDurationSeconds" : 374.9580247402191,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 998.7806252063344,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 374.9580247402191,
      "endOffsetSeconds" : 760.2932095527649,
      "index" : 2,
      "isOpenTail" : false,
      "label" : "Work 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 385.3351848125458,
      "stepType" : "work"
    },
    {
      "activeDurationSeconds" : 119.88019299507141,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 317.6312901694349,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 119.88019299507141,
      "endOffsetSeconds" : 880.1734025478363,
      "index" : 3,
      "isOpenTail" : false,
      "label" : "Recovery 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 760.2932095527649,
      "stepType" : "recovery"
    },
    {
      "activeDurationSeconds" : 372.02334666252136,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 994.8709033485997,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 372.02334666252136,
      "endOffsetSeconds" : 1252.1967492103577,
      "index" : 4,
      "isOpenTail" : false,
      "label" : "Work 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 880.1734025478363,
      "stepType" : "work"
    },
    {
      "activeDurationSeconds" : 373.2097953557968,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 1002.6938880537947,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 373.2097953557968,
      "endOffsetSeconds" : 1625.4065445661545,
      "index" : 5,
      "isOpenTail" : false,
      "label" : "Cooldown",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1252.1967492103577,
      "stepType" : "cooldown"
    },
    {
      "activeDurationSeconds" : 278.7364624738693,
      "candidateConfidence" : "activity boundary inferred tail",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Inferred from workout end minus final mapped activity boundary.",
        "No separate HKWorkoutActivity row represented this tail."
      ],
      "distanceMeters" : 715.4083173745867,
      "durationDisplayRule" : "open-tail-measured-duration",
      "durationRule" : "open-tail-measured-duration",
      "elapsedDurationSeconds" : 278.7364624738693,
      "endOffsetSeconds" : 1904.1430070400238,
      "index" : 6,
      "isOpenTail" : true,
      "label" : "Open \/ Extra",
      "mappingStatus" : "inferredOpenTailFromWorkoutEnd",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1625.4065445661545,
      "stepType" : "open"
    }
  ],
  "customWorkoutCandidateRuleSummary" : {
    "boundaryLogicChanged" : false,
    "candidateRowCount" : 6,
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
    "plannedExpandedRowCount" : 5,
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
    "tailDistanceMeters" : 715.4083173745867,
    "tailElapsedDurationSeconds" : 278.7364624738693,
    "tailStatus" : "open-extra-tail-present",
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
      "supported",
      "supported",
      "supported",
      "supported",
      "supported"
    ],
    "rowCount" : 5,
    "scope" : "debug\/export-only",
    "status" : "supported",
    "statusLabel" : "Structured comparison is supported.",
    "tailAmbiguity" : "fixedCooldownFollowedByPossibleOpenExtraTail",
    "usesFITRuntimeTruth" : false
  },
  "evidenceCounts" : {
    "activeEnergy" : 739,
    "activities" : 5,
    "cadence" : 740,
    "distance" : 738,
    "events" : 11,
    "groundContact" : 347,
    "heartRate" : 380,
    "power" : 738,
    "routePoints" : 1905,
    "speed" : 738,
    "stepCount" : 740,
    "strideLength" : 345,
    "verticalOscillation" : 347
  },
  "generatedAt" : "2026-06-29T20:58:52Z",
  "plannedStepBoundaryComparisons" : [
    {
      "crossingDistanceSampleEndOffsetSeconds" : 380.0976564884186,
      "index" : 1,
      "nearestRawEventEndDeltaSeconds" : 2.3529210090637207,
      "nearestRawEventEndOffsetSeconds" : 382.4505774974823,
      "nearestRawEventStartOffsetSeconds" : 0,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 2.3529210090637207,
      "nearestSegmentMarkerEndOffsetSeconds" : 382.4505774974823,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 0,
      "nearestWorkoutActivityEndDeltaSeconds" : 5.237528324127197,
      "nearestWorkoutActivityEndOffsetSeconds" : 385.3351848125458,
      "nearestWorkoutActivityStartOffsetSeconds" : 0,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 382.6704571247101,
      "plannedGoalDisplayText" : "1 km",
      "plannedStepLabel" : "Warmup",
      "previousDistanceSampleEndOffsetSeconds" : 377.52485716342926,
      "reconstructedEndOffsetSeconds" : 380.0976564884186,
      "reconstructedLabel" : "Warmup"
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 755.7270810604095,
      "index" : 2,
      "nearestRawEventEndDeltaSeconds" : 1.4633524417877197,
      "nearestRawEventEndOffsetSeconds" : 757.1904335021973,
      "nearestRawEventStartOffsetSeconds" : 382.4505774974823,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 1.4633524417877197,
      "nearestSegmentMarkerEndOffsetSeconds" : 757.1904335021973,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 382.4505774974823,
      "nearestWorkoutActivityEndDeltaSeconds" : 4.566128492355347,
      "nearestWorkoutActivityEndOffsetSeconds" : 760.2932095527649,
      "nearestWorkoutActivityStartOffsetSeconds" : 385.3351848125458,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 758.2998538017273,
      "plannedGoalDisplayText" : "1 km",
      "plannedStepLabel" : "Work 1",
      "previousDistanceSampleEndOffsetSeconds" : 753.1543092727661,
      "reconstructedEndOffsetSeconds" : 755.7270810604095,
      "reconstructedLabel" : "Work 1"
    },
    {
      "index" : 3,
      "nearestRawEventEndDeltaSeconds" : -118.53664755821228,
      "nearestRawEventEndOffsetSeconds" : 757.1904335021973,
      "nearestRawEventStartOffsetSeconds" : 382.4505774974823,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -118.53664755821228,
      "nearestSegmentMarkerEndOffsetSeconds" : 757.1904335021973,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 382.4505774974823,
      "nearestWorkoutActivityEndDeltaSeconds" : 4.446321487426758,
      "nearestWorkoutActivityEndOffsetSeconds" : 880.1734025478363,
      "nearestWorkoutActivityStartOffsetSeconds" : 760.2932095527649,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "plannedGoalDisplayText" : "120 s",
      "plannedStepLabel" : "Recovery 1",
      "reconstructedEndOffsetSeconds" : 875.7270810604095,
      "reconstructedLabel" : "Recovery 1",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1249.6888868808746,
      "index" : 4,
      "nearestRawEventEndDeltaSeconds" : -36.37689542770386,
      "nearestRawEventEndOffsetSeconds" : 1213.3119914531708,
      "nearestRawEventStartOffsetSeconds" : 612.8703894615173,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -36.37689542770386,
      "nearestSegmentMarkerEndOffsetSeconds" : 1213.3119914531708,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 612.8703894615173,
      "nearestWorkoutActivityEndDeltaSeconds" : 2.5078623294830322,
      "nearestWorkoutActivityEndOffsetSeconds" : 1252.1967492103577,
      "nearestWorkoutActivityStartOffsetSeconds" : 880.1734025478363,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1252.2615820169449,
      "plannedGoalDisplayText" : "1 km",
      "plannedStepLabel" : "Work 1",
      "previousDistanceSampleEndOffsetSeconds" : 1247.116190314293,
      "reconstructedEndOffsetSeconds" : 1249.6888868808746,
      "reconstructedLabel" : "Work 1",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1622.7307941913605,
      "index" : 5,
      "nearestRawEventEndDeltaSeconds" : -113.6307442188263,
      "nearestRawEventEndOffsetSeconds" : 1509.1000499725342,
      "nearestRawEventStartOffsetSeconds" : 1131.0395669937134,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -113.6307442188263,
      "nearestSegmentMarkerEndOffsetSeconds" : 1509.1000499725342,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1131.0395669937134,
      "nearestWorkoutActivityEndDeltaSeconds" : 2.6757503747940063,
      "nearestWorkoutActivityEndOffsetSeconds" : 1625.4065445661545,
      "nearestWorkoutActivityStartOffsetSeconds" : 1252.1967492103577,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1625.3035442829132,
      "plannedGoalDisplayText" : "1 km",
      "plannedStepLabel" : "Cooldown",
      "previousDistanceSampleEndOffsetSeconds" : 1620.158043384552,
      "reconstructedEndOffsetSeconds" : 1622.7307941913605,
      "reconstructedLabel" : "Cooldown",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "index" : 6,
      "nearestRawEventEndDeltaSeconds" : -3.554858088493347,
      "nearestRawEventEndOffsetSeconds" : 1900.5881489515305,
      "nearestRawEventStartOffsetSeconds" : 1818.4333629608154,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -3.554858088493347,
      "nearestSegmentMarkerEndOffsetSeconds" : 1900.5881489515305,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1818.4333629608154,
      "nearestWorkoutActivityEndDeltaSeconds" : -278.7364624738693,
      "nearestWorkoutActivityEndOffsetSeconds" : 1625.4065445661545,
      "nearestWorkoutActivityStartOffsetSeconds" : 1252.1967492103577,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "plannedGoalDisplayText" : "Open",
      "reconstructedEndOffsetSeconds" : 1904.1430070400238,
      "reconstructedLabel" : "Open \/ Extra",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    }
  ],
  "rawWorkoutEvents" : [
    {
      "durationSeconds" : 382.4505774974823,
      "endDate" : "2026-06-29T12:02:48Z",
      "endOffsetSeconds" : 382.4505774974823,
      "index" : 1,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1008.0841608994491,
      "renderedSegmentMarkerDurationSeconds" : 382.4505774974823,
      "renderedSegmentMarkerEndOffsetSeconds" : 382.4505774974823,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-29T11:56:25Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 612.8703894615173,
      "endDate" : "2026-06-29T12:06:38Z",
      "endOffsetSeconds" : 612.8703894615173,
      "index" : 2,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1615.8570383258962,
      "renderedSegmentMarkerDurationSeconds" : 612.8703894615173,
      "renderedSegmentMarkerEndOffsetSeconds" : 612.8703894615173,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-29T11:56:25Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 374.73985600471497,
      "endDate" : "2026-06-29T12:09:03Z",
      "endOffsetSeconds" : 757.1904335021973,
      "index" : 3,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 998.2924966373256,
      "renderedSegmentMarkerDurationSeconds" : 374.73985600471497,
      "renderedSegmentMarkerEndOffsetSeconds" : 757.1904335021973,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 382.4505774974823,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-29T12:02:48Z",
      "startOffsetSeconds" : 382.4505774974823,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 600.4416019916534,
      "endDate" : "2026-06-29T12:16:39Z",
      "endOffsetSeconds" : 1213.3119914531708,
      "index" : 4,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1608.406722784213,
      "renderedSegmentMarkerDurationSeconds" : 600.4416019916534,
      "renderedSegmentMarkerEndOffsetSeconds" : 1213.3119914531708,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 612.8703894615173,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-29T12:06:38Z",
      "startOffsetSeconds" : 612.8703894615173,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 373.8491334915161,
      "endDate" : "2026-06-29T12:15:16Z",
      "endOffsetSeconds" : 1131.0395669937134,
      "index" : 5,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 999.987420996021,
      "renderedSegmentMarkerDurationSeconds" : 373.8491334915161,
      "renderedSegmentMarkerEndOffsetSeconds" : 1131.0395669937134,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 757.1904335021973,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-29T12:09:03Z",
      "startOffsetSeconds" : 757.1904335021973,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 378.0604829788208,
      "endDate" : "2026-06-29T12:21:34Z",
      "endOffsetSeconds" : 1509.1000499725342,
      "index" : 6,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1004.3705103394454,
      "renderedSegmentMarkerDurationSeconds" : 378.0604829788208,
      "renderedSegmentMarkerEndOffsetSeconds" : 1509.1000499725342,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1131.0395669937134,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-29T12:15:16Z",
      "startOffsetSeconds" : 1131.0395669937134,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 605.1213715076447,
      "endDate" : "2026-06-29T12:26:44Z",
      "endOffsetSeconds" : 1818.4333629608154,
      "index" : 7,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1610.2132500634452,
      "renderedSegmentMarkerDurationSeconds" : 605.1213715076447,
      "renderedSegmentMarkerEndOffsetSeconds" : 1818.4333629608154,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1213.3119914531708,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-29T12:16:39Z",
      "startOffsetSeconds" : 1213.3119914531708,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 376.98248291015625,
      "endDate" : "2026-06-29T12:27:51Z",
      "endOffsetSeconds" : 1886.0825328826904,
      "index" : 8,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 995.6191625988376,
      "renderedSegmentMarkerDurationSeconds" : 376.98248291015625,
      "renderedSegmentMarkerEndOffsetSeconds" : 1886.0825328826904,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1509.1000499725342,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-29T12:21:34Z",
      "startOffsetSeconds" : 1509.1000499725342,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 82.15478599071503,
      "endDate" : "2026-06-29T12:28:06Z",
      "endOffsetSeconds" : 1900.5881489515305,
      "index" : 9,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 203.96343178552524,
      "renderedSegmentMarkerDurationSeconds" : 82.15478599071503,
      "renderedSegmentMarkerEndOffsetSeconds" : 1900.5881489515305,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1818.4333629608154,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-29T12:26:44Z",
      "startOffsetSeconds" : 1818.4333629608154,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 14.505616068840027,
      "endDate" : "2026-06-29T12:28:06Z",
      "endOffsetSeconds" : 1900.5881489515305,
      "index" : 10,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 32.086691488000724,
      "renderedSegmentMarkerDurationSeconds" : 14.505616068840027,
      "renderedSegmentMarkerEndOffsetSeconds" : 1900.5881489515305,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1886.0825328826904,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-29T12:27:51Z",
      "startOffsetSeconds" : 1886.0825328826904,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 0,
      "endDate" : "2026-06-29T12:28:10Z",
      "endOffsetSeconds" : 1904.1430070400238,
      "excludedOrFilteredReason" : "zeroOrNegativeDuration",
      "index" : 11,
      "metadataKeys" : [

      ],
      "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
      "startDate" : "2026-06-29T12:28:10Z",
      "startOffsetSeconds" : 1904.1430070400238,
      "type" : "HKWorkoutEventType(rawValue: 1)",
      "usedBySegmentMarkerRendering" : false
    }
  ],
  "reconstructedIntervals" : [
    {
      "averageHeartRateBpm" : 117.90789473684211,
      "averagePower" : 188.04761904761904,
      "boundaryAdjustmentSeconds" : 0.21987950801849365,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 1000.4737301554997,
          "endDate" : "2026-06-29T12:02:45Z",
          "endOffsetSeconds" : 380.0976564884186,
          "startCumulativeDistanceMeters" : 994.9306376106106,
          "startDate" : "2026-06-29T12:02:43Z",
          "startOffsetSeconds" : 377.52485716342926
        },
        "cumulativeDistanceAtEndMeters" : 1000.4737301554997,
        "cumulativeDistanceAtStartMeters" : 0,
        "interpolationFraction" : 0.9145368489406789,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 1008.7953529320657,
          "endDate" : "2026-06-29T12:02:48Z",
          "endOffsetSeconds" : 382.6704571247101,
          "startCumulativeDistanceMeters" : 1000.4737301554997,
          "startDate" : "2026-06-29T12:02:45Z",
          "startOffsetSeconds" : 380.0976564884186
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 994.9306376106106,
          "endDate" : "2026-06-29T12:02:43Z",
          "endOffsetSeconds" : 377.52485716342926,
          "startCumulativeDistanceMeters" : 986.6898067917209,
          "startDate" : "2026-06-29T12:02:40Z",
          "startOffsetSeconds" : 374.95205640792847
        },
        "targetDistanceMeters" : 1000
      },
      "boundaryOvershootMeters" : 0.47373015549965203,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "displayDurationSeconds" : 380.0976564884186,
      "distanceMeters" : 1000.4737301554997,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 380.0976564884186,
      "elapsedDurationSeconds" : 380.0976564884186,
      "endOffsetSeconds" : 380.0976564884186,
      "index" : 1,
      "label" : "Warmup",
      "maxHeartRateBpm" : 131,
      "paceSecondsPerKm" : 379.9176780277295,
      "plannedGoalDisplayText" : "1 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 1000,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +0.2s, overshoot 0.5 m",
      "startOffsetSeconds" : 0,
      "stepType" : "warmup"
    },
    {
      "averageHeartRateBpm" : 132.88,
      "averagePower" : 195.1156462585034,
      "boundaryAdjustmentSeconds" : 0.8855170011520386,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 2002.3472920570057,
          "endDate" : "2026-06-29T12:09:01Z",
          "endOffsetSeconds" : 755.7270810604095,
          "startCumulativeDistanceMeters" : 1996.9038647902198,
          "startDate" : "2026-06-29T12:08:59Z",
          "startOffsetSeconds" : 753.1543092727661
        },
        "cumulativeDistanceAtEndMeters" : 2002.3472920570057,
        "cumulativeDistanceAtStartMeters" : 1000.4737301554997,
        "interpolationFraction" : 0.6558120813080507,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2009.4314649295993,
          "endDate" : "2026-06-29T12:09:04Z",
          "endOffsetSeconds" : 758.2998538017273,
          "startCumulativeDistanceMeters" : 2002.3472920570057,
          "startDate" : "2026-06-29T12:09:01Z",
          "startOffsetSeconds" : 755.7270810604095
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 1996.9038647902198,
          "endDate" : "2026-06-29T12:08:59Z",
          "endOffsetSeconds" : 753.1543092727661,
          "startCumulativeDistanceMeters" : 1989.8724876604974,
          "startDate" : "2026-06-29T12:08:56Z",
          "startOffsetSeconds" : 750.5815391540527
        },
        "targetDistanceMeters" : 1000
      },
      "boundaryOvershootMeters" : 1.8735619015060365,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "displayDurationSeconds" : 375.62942457199097,
      "distanceMeters" : 1001.873561901506,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 375.62942457199097,
      "elapsedDurationSeconds" : 375.62942457199097,
      "endOffsetSeconds" : 755.7270810604095,
      "index" : 2,
      "label" : "Work 1",
      "maxHeartRateBpm" : 137,
      "paceSecondsPerKm" : 374.9269756745203,
      "plannedGoalDisplayText" : "1 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 1000,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +0.9s, overshoot 1.9 m",
      "startOffsetSeconds" : 380.0976564884186,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 133.375,
      "averagePower" : 191.31914893617022,
      "confidence" : "high",
      "displayDurationSeconds" : 120,
      "distanceMeters" : 317.8533173914084,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 120,
      "elapsedDurationSeconds" : 120,
      "endOffsetSeconds" : 875.7270810604095,
      "index" : 3,
      "label" : "Recovery 1",
      "maxHeartRateBpm" : 137,
      "paceSecondsPerKm" : 377.5326335582352,
      "plannedGoalDisplayText" : "120 s",
      "plannedGoalType" : "time",
      "plannedGoalValue" : 120,
      "sourceNote" : "Time-goal window reconstructed from WorkoutKit duration; active duration subtracts reliable paired pause overlap.",
      "startOffsetSeconds" : 755.7270810604095,
      "stepType" : "recovery"
    },
    {
      "averageHeartRateBpm" : 137.55405405405406,
      "averagePower" : 193.13698630136986,
      "boundaryAdjustmentSeconds" : 0.153661847114563,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3320.438686862588,
          "endDate" : "2026-06-29T12:17:15Z",
          "endOffsetSeconds" : 1249.6888868808746,
          "startCumulativeDistanceMeters" : 3316.4526569314767,
          "startDate" : "2026-06-29T12:17:13Z",
          "startOffsetSeconds" : 1247.116190314293
        },
        "cumulativeDistanceAtEndMeters" : 3320.438686862588,
        "cumulativeDistanceAtStartMeters" : 2320.200609448414,
        "interpolationFraction" : 0.9402720455469623,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3331.3221397860907,
          "endDate" : "2026-06-29T12:17:18Z",
          "endOffsetSeconds" : 1252.2615820169449,
          "startCumulativeDistanceMeters" : 3320.438686862588,
          "startDate" : "2026-06-29T12:17:15Z",
          "startOffsetSeconds" : 1249.6888868808746
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3316.4526569314767,
          "endDate" : "2026-06-29T12:17:13Z",
          "endOffsetSeconds" : 1247.116190314293,
          "startCumulativeDistanceMeters" : 3309.1567216168623,
          "startDate" : "2026-06-29T12:17:10Z",
          "startOffsetSeconds" : 1244.543494105339
        },
        "targetDistanceMeters" : 1000
      },
      "boundaryOvershootMeters" : 0.23807741417385841,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "displayDurationSeconds" : 373.9618058204651,
      "distanceMeters" : 1000.2380774141739,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 373.9618058204651,
      "elapsedDurationSeconds" : 373.9618058204651,
      "endOffsetSeconds" : 1249.6888868808746,
      "index" : 4,
      "label" : "Work 1",
      "maxHeartRateBpm" : 144,
      "paceSecondsPerKm" : 373.8727951521653,
      "plannedGoalDisplayText" : "1 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 1000,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +0.2s, overshoot 0.2 m",
      "startOffsetSeconds" : 875.7270810604095,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 142.4078947368421,
      "averagePower" : 193.486301369863,
      "boundaryAdjustmentSeconds" : 0.8973493576049805,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 4322.73835345963,
          "endDate" : "2026-06-29T12:23:28Z",
          "endOffsetSeconds" : 1622.7307941913605,
          "startCumulativeDistanceMeters" : 4316.145080376649,
          "startDate" : "2026-06-29T12:23:26Z",
          "startOffsetSeconds" : 1620.158043384552
        },
        "cumulativeDistanceAtEndMeters" : 4322.73835345963,
        "cumulativeDistanceAtStartMeters" : 3320.438686862588,
        "interpolationFraction" : 0.6512101701083296,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 4330.076221011579,
          "endDate" : "2026-06-29T12:23:31Z",
          "endOffsetSeconds" : 1625.3035442829132,
          "startCumulativeDistanceMeters" : 4322.73835345963,
          "startDate" : "2026-06-29T12:23:28Z",
          "startOffsetSeconds" : 1622.7307941913605
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 4316.145080376649,
          "endDate" : "2026-06-29T12:23:26Z",
          "endOffsetSeconds" : 1620.158043384552,
          "startCumulativeDistanceMeters" : 4309.965034197783,
          "startDate" : "2026-06-29T12:23:23Z",
          "startOffsetSeconds" : 1617.5852938890457
        },
        "targetDistanceMeters" : 1000
      },
      "boundaryOvershootMeters" : 2.2996665970422328,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "displayDurationSeconds" : 373.04190731048584,
      "distanceMeters" : 1002.2996665970422,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 373.04190731048584,
      "elapsedDurationSeconds" : 373.04190731048584,
      "endOffsetSeconds" : 1622.7307941913605,
      "index" : 5,
      "label" : "Cooldown",
      "maxHeartRateBpm" : 146,
      "paceSecondsPerKm" : 372.18600359014295,
      "plannedGoalDisplayText" : "1 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 1000,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +0.9s, overshoot 2.3 m",
      "startOffsetSeconds" : 1249.6888868808746,
      "stepType" : "cooldown"
    },
    {
      "averageHeartRateBpm" : 143.5090909090909,
      "averagePower" : 189.045871559633,
      "confidence" : "medium",
      "displayDurationSeconds" : 281.41221284866333,
      "distanceMeters" : 715.7020894994494,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 281.41221284866333,
      "elapsedDurationSeconds" : 281.41221284866333,
      "endOffsetSeconds" : 1904.1430070400238,
      "index" : 6,
      "label" : "Open \/ Extra",
      "maxHeartRateBpm" : 149,
      "paceSecondsPerKm" : 393.19741688260063,
      "plannedGoalDisplayText" : "Open",
      "plannedGoalType" : "open",
      "sourceNote" : "Extra tail after planned WorkoutKit steps",
      "startOffsetSeconds" : 1622.7307941913605,
      "stepType" : "open",
      "tailDiagnostics" : {
        "creationReason" : "Remaining workout time or distance exceeded Open \/ Extra threshold after planned WorkoutKit steps.",
        "finalDistanceSampleCumulativeDistanceMeters" : 5038.4404429590795,
        "finalDistanceSampleOffsetSeconds" : 1898.0153962373734,
        "lastCadenceSampleOffsetSeconds" : 1903.1609038114548,
        "lastHeartRateSampleOffsetSeconds" : 1900.1574779748917,
        "lastPowerSampleOffsetSeconds" : 1900.5881489515305,
        "plannedFinalStepEndOffsetSeconds" : 1622.7307941913605,
        "remainingMeters" : 715.7020894994494,
        "remainingSeconds" : 281.41221284866333,
        "workoutEndOffsetSeconds" : 1904.1430070400238
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
      "averageHeartRateBpm" : 117.90789473684211,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1008.0841608994491,
      "durationSeconds" : 382.4505774974823,
      "endOffsetSeconds" : 382.4505774974823,
      "index" : 1,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 379.3835795974079,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 123.42276422764228,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1615.8570383258962,
      "durationSeconds" : 612.8703894615173,
      "endOffsetSeconds" : 612.8703894615173,
      "index" : 2,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 379.2850326019435,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 132.88,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 998.2924966373256,
      "durationSeconds" : 374.73985600471497,
      "endOffsetSeconds" : 757.1904335021973,
      "index" : 3,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 375.38082001717777,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 382.4505774974823
    },
    {
      "averageHeartRateBpm" : 135.7563025210084,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1608.406722784213,
      "durationSeconds" : 600.4416019916534,
      "endOffsetSeconds" : 1213.3119914531708,
      "index" : 4,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 373.3145313843667,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 612.8703894615173
    },
    {
      "averageHeartRateBpm" : 135.46666666666667,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 999.987420996021,
      "durationSeconds" : 373.8491334915161,
      "endOffsetSeconds" : 1131.0395669937134,
      "index" : 5,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 373.85383620040926,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 757.1904335021973
    },
    {
      "averageHeartRateBpm" : 141.30263157894737,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1004.3705103394454,
      "durationSeconds" : 378.0604829788208,
      "endOffsetSeconds" : 1509.1000499725342,
      "index" : 6,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 376.4153557744824,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1131.0395669937134
    },
    {
      "averageHeartRateBpm" : 142.8181818181818,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1610.2132500634452,
      "durationSeconds" : 605.1213715076447,
      "endOffsetSeconds" : 1818.4333629608154,
      "index" : 7,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 375.802007270653,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1213.3119914531708
    },
    {
      "averageHeartRateBpm" : 143.65333333333334,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 995.6191625988376,
      "durationSeconds" : 376.98248291015625,
      "endOffsetSeconds" : 1886.0825328826904,
      "index" : 8,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 378.641248653882,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1509.1000499725342
    },
    {
      "averageHeartRateBpm" : 141.52941176470588,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 203.96343178552524,
      "durationSeconds" : 82.15478599071503,
      "endOffsetSeconds" : 1900.5881489515305,
      "index" : 9,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 402.79174198786615,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1818.4333629608154
    },
    {
      "averageHeartRateBpm" : 141,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 32.086691488000724,
      "durationSeconds" : 14.505616068840027,
      "endOffsetSeconds" : 1900.5881489515305,
      "index" : 10,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 452.07577958807656,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1886.0825328826904
    }
  ],
  "sourceNotes" : [
    "Plan source: WorkoutKit",
    "Window source: Plan-derived from HealthKit distance\/time samples",
    "Stats source: HealthKit samples",
    "HealthKit segment markers: not used"
  ],
  "workout" : {
    "averageHeartRate" : 134.44758886946389,
    "averagePower" : 191.8414634146343,
    "cadenceSpm" : 172.92517717056396,
    "deviceName" : "Apple Watch Apple Inc. Watch",
    "distanceMeters" : 5038.4404429590795,
    "durationSeconds" : 1904.1430070400238,
    "elapsedSeconds" : 1904.1430070400238,
    "endDate" : "2026-06-29T12:28:10Z",
    "id" : "B2227876-F1EA-4A3D-937B-F5D988986539",
    "maxHeartRate" : 149,
    "paceSecondsPerKm" : 377.9230951714335,
    "sourceID" : "B2227876-F1EA-4A3D-937B-F5D988986539",
    "sourceName" : "Adriel’s Apple Watch",
    "startDate" : "2026-06-29T11:56:25Z"
  },
  "workoutActivities" : [
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 380.0976564884186,
      "durationSeconds" : 385.3351848125458,
      "endDate" : "2026-06-29T12:02:51Z",
      "endOffsetSeconds" : 385.3351848125458,
      "events" : [
        {
          "durationSeconds" : 382.4505774974823,
          "endDate" : "2026-06-29T12:02:48Z",
          "endOffsetSeconds" : 382.4505774974823,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1008.0841608994491,
          "renderedSegmentMarkerDurationSeconds" : 382.4505774974823,
          "renderedSegmentMarkerEndOffsetSeconds" : 382.4505774974823,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T11:56:25Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 612.8703894615173,
          "endDate" : "2026-06-29T12:06:38Z",
          "endOffsetSeconds" : 612.8703894615173,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1615.8570383258962,
          "renderedSegmentMarkerDurationSeconds" : 612.8703894615173,
          "renderedSegmentMarkerEndOffsetSeconds" : 612.8703894615173,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T11:56:25Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 374.73985600471497,
          "endDate" : "2026-06-29T12:09:03Z",
          "endOffsetSeconds" : 757.1904335021973,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 998.2924966373256,
          "renderedSegmentMarkerDurationSeconds" : 374.73985600471497,
          "renderedSegmentMarkerEndOffsetSeconds" : 757.1904335021973,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 382.4505774974823,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:02:48Z",
          "startOffsetSeconds" : 382.4505774974823,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "3 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "EE8D5E04-21B5-40B0-B668-83233BB62DDB",
      "index" : 1,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -2.8846073150634766,
      "nearestRawEventEndOffsetSeconds" : 382.4505774974823,
      "nearestRawEventStartDeltaSeconds" : 0,
      "nearestRawEventStartOffsetSeconds" : 0,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -5.237528324127197,
      "nearestReconstructedIntervalEndOffsetSeconds" : 380.0976564884186,
      "nearestReconstructedIntervalIndex" : 1,
      "nearestReconstructedIntervalLabel" : "Warmup",
      "nearestSegmentMarkerEndDeltaSeconds" : -2.8846073150634766,
      "nearestSegmentMarkerEndOffsetSeconds" : 382.4505774974823,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : 0,
      "nearestSegmentMarkerStartOffsetSeconds" : 0,
      "nextDistanceSampleEndOffsetSeconds" : 382.6704571247101,
      "previousDistanceSampleEndOffsetSeconds" : 377.52485716342926,
      "startDate" : "2026-06-29T11:56:25Z",
      "startOffsetSeconds" : 0,
      "statistics" : [
        {
          "endDate" : "2026-06-29T12:02:51Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T11:56:25Z",
          "sum" : 60.1023262568763,
          "summary" : "ActiveEnergyBurned: sum 60.1 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-29T12:02:51Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T11:56:25Z",
          "sum" : 9.43589238782846,
          "summary" : "BasalEnergyBurned: sum 9.4 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-29T12:02:51Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T11:56:25Z",
          "sum" : 1009.055418806329,
          "summary" : "DistanceWalkingRunning: sum 1009.1 m",
          "unit" : "m"
        },
        {
          "average" : 116.33167447306793,
          "endDate" : "2026-06-29T12:02:51Z",
          "maximum" : 131,
          "minimum" : 61.99999999999999,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T11:56:25Z",
          "summary" : "HeartRate: avg 116.3 bpm, min 62.0 bpm, max 131.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 276.4117647058823,
          "endDate" : "2026-06-29T12:02:51Z",
          "maximum" : 295,
          "minimum" : 258,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T11:56:25Z",
          "summary" : "RunningGroundContactTime: avg 276.4 ms, min 258.0 ms, max 295.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 188.18791946308727,
          "endDate" : "2026-06-29T12:02:51Z",
          "maximum" : 202,
          "minimum" : 74,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T11:56:25Z",
          "summary" : "RunningPower: avg 188.2 W, min 74.0 W, max 202.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.67382510096201,
          "endDate" : "2026-06-29T12:02:51Z",
          "maximum" : 2.8566219681625014,
          "minimum" : 1.343806431663968,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T11:56:25Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 1.3 m\/s, max 2.9 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9039705882352942,
          "endDate" : "2026-06-29T12:02:51Z",
          "maximum" : 0.97,
          "minimum" : 0.85,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T11:56:25Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.8 m, max 1.0 m",
          "unit" : "m"
        },
        {
          "average" : 6.9217391304347835,
          "endDate" : "2026-06-29T12:02:51Z",
          "maximum" : 7.9,
          "minimum" : 6.5,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T11:56:25Z",
          "summary" : "RunningVerticalOscillation: avg 6.9 cm, min 6.5 cm, max 7.9 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-29T12:02:51Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T11:56:25Z",
          "sum" : 1125.2858435456014,
          "summary" : "StepCount: sum 1125.3 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 60.1 kcal; BasalEnergyBurned: sum 9.4 kcal; DistanceWalkingRunning: sum 1009.1 m; HeartRate: avg 116.3 bpm, min 62.0 bpm, max 131.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 755.7270810604095,
      "durationSeconds" : 374.9580247402191,
      "endDate" : "2026-06-29T12:09:06Z",
      "endOffsetSeconds" : 760.2932095527649,
      "events" : [
        {
          "durationSeconds" : 612.8703894615173,
          "endDate" : "2026-06-29T12:06:38Z",
          "endOffsetSeconds" : 612.8703894615173,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1615.8570383258962,
          "renderedSegmentMarkerDurationSeconds" : 612.8703894615173,
          "renderedSegmentMarkerEndOffsetSeconds" : 612.8703894615173,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T11:56:25Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 374.73985600471497,
          "endDate" : "2026-06-29T12:09:03Z",
          "endOffsetSeconds" : 757.1904335021973,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 998.2924966373256,
          "renderedSegmentMarkerDurationSeconds" : 374.73985600471497,
          "renderedSegmentMarkerEndOffsetSeconds" : 757.1904335021973,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 382.4505774974823,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:02:48Z",
          "startOffsetSeconds" : 382.4505774974823,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 600.4416019916534,
          "endDate" : "2026-06-29T12:16:39Z",
          "endOffsetSeconds" : 1213.3119914531708,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1608.406722784213,
          "renderedSegmentMarkerDurationSeconds" : 600.4416019916534,
          "renderedSegmentMarkerEndOffsetSeconds" : 1213.3119914531708,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 612.8703894615173,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:06:38Z",
          "startOffsetSeconds" : 612.8703894615173,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 373.8491334915161,
          "endDate" : "2026-06-29T12:15:16Z",
          "endOffsetSeconds" : 1131.0395669937134,
          "index" : 4,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 999.987420996021,
          "renderedSegmentMarkerDurationSeconds" : 373.8491334915161,
          "renderedSegmentMarkerEndOffsetSeconds" : 1131.0395669937134,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 757.1904335021973,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:09:03Z",
          "startOffsetSeconds" : 757.1904335021973,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "4 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "B6F108D3-40D3-4427-A805-9DFF65376809",
      "index" : 2,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -3.102776050567627,
      "nearestRawEventEndOffsetSeconds" : 757.1904335021973,
      "nearestRawEventStartDeltaSeconds" : -2.8846073150634766,
      "nearestRawEventStartOffsetSeconds" : 382.4505774974823,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -4.566128492355347,
      "nearestReconstructedIntervalEndOffsetSeconds" : 755.7270810604095,
      "nearestReconstructedIntervalIndex" : 2,
      "nearestReconstructedIntervalLabel" : "Work 1",
      "nearestSegmentMarkerEndDeltaSeconds" : -3.102776050567627,
      "nearestSegmentMarkerEndOffsetSeconds" : 757.1904335021973,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -2.8846073150634766,
      "nearestSegmentMarkerStartOffsetSeconds" : 382.4505774974823,
      "nextDistanceSampleEndOffsetSeconds" : 758.2998538017273,
      "previousDistanceSampleEndOffsetSeconds" : 753.1543092727661,
      "startDate" : "2026-06-29T12:02:51Z",
      "startOffsetSeconds" : 385.3351848125458,
      "statistics" : [
        {
          "endDate" : "2026-06-29T12:09:06Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:02:51Z",
          "sum" : 60.778542221716656,
          "summary" : "ActiveEnergyBurned: sum 60.8 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-29T12:09:06Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:02:51Z",
          "sum" : 9.181560802374895,
          "summary" : "BasalEnergyBurned: sum 9.2 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-29T12:09:06Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:02:51Z",
          "sum" : 998.7806252063344,
          "summary" : "DistanceWalkingRunning: sum 998.8 m",
          "unit" : "m"
        },
        {
          "average" : 132.945107398568,
          "endDate" : "2026-06-29T12:09:06Z",
          "maximum" : 137,
          "minimum" : 127,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:02:51Z",
          "summary" : "HeartRate: avg 132.9 bpm, min 127.0 bpm, max 137.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 267.92857142857133,
          "endDate" : "2026-06-29T12:09:06Z",
          "maximum" : 287,
          "minimum" : 256,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:02:51Z",
          "summary" : "RunningGroundContactTime: avg 267.9 ms, min 256.0 ms, max 287.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 195.04827586206892,
          "endDate" : "2026-06-29T12:09:06Z",
          "maximum" : 206,
          "minimum" : 181,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:02:51Z",
          "summary" : "RunningPower: avg 195.0 W, min 181.0 W, max 206.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.737127214367017,
          "endDate" : "2026-06-29T12:09:06Z",
          "maximum" : 2.8890627939032196,
          "minimum" : 2.5360801618570434,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:02:51Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 2.5 m\/s, max 2.9 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9274285714285716,
          "endDate" : "2026-06-29T12:09:06Z",
          "maximum" : 0.98,
          "minimum" : 0.87,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:02:51Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 1.0 m",
          "unit" : "m"
        },
        {
          "average" : 6.982857142857143,
          "endDate" : "2026-06-29T12:09:06Z",
          "maximum" : 7.3,
          "minimum" : 6.5,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:02:51Z",
          "summary" : "RunningVerticalOscillation: avg 7.0 cm, min 6.5 cm, max 7.3 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-29T12:09:06Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:02:51Z",
          "sum" : 1093.9124828412569,
          "summary" : "StepCount: sum 1093.9 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 60.8 kcal; BasalEnergyBurned: sum 9.2 kcal; DistanceWalkingRunning: sum 998.8 m; HeartRate: avg 132.9 bpm, min 127.0 bpm, max 137.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "durationSeconds" : 119.88019299507141,
      "endDate" : "2026-06-29T12:11:06Z",
      "endOffsetSeconds" : 880.1734025478363,
      "events" : [
        {
          "durationSeconds" : 600.4416019916534,
          "endDate" : "2026-06-29T12:16:39Z",
          "endOffsetSeconds" : 1213.3119914531708,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1608.406722784213,
          "renderedSegmentMarkerDurationSeconds" : 600.4416019916534,
          "renderedSegmentMarkerEndOffsetSeconds" : 1213.3119914531708,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 612.8703894615173,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:06:38Z",
          "startOffsetSeconds" : 612.8703894615173,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 373.8491334915161,
          "endDate" : "2026-06-29T12:15:16Z",
          "endOffsetSeconds" : 1131.0395669937134,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 999.987420996021,
          "renderedSegmentMarkerDurationSeconds" : 373.8491334915161,
          "renderedSegmentMarkerEndOffsetSeconds" : 1131.0395669937134,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 757.1904335021973,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:09:03Z",
          "startOffsetSeconds" : 757.1904335021973,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "2 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "E2891ABF-2379-4D45-88BE-45684DA4D87F",
      "index" : 3,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -122.98296904563904,
      "nearestRawEventEndOffsetSeconds" : 757.1904335021973,
      "nearestRawEventStartDeltaSeconds" : -3.102776050567627,
      "nearestRawEventStartOffsetSeconds" : 757.1904335021973,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -4.446321487426758,
      "nearestReconstructedIntervalEndOffsetSeconds" : 875.7270810604095,
      "nearestReconstructedIntervalIndex" : 3,
      "nearestReconstructedIntervalLabel" : "Recovery 1",
      "nearestSegmentMarkerEndDeltaSeconds" : -122.98296904563904,
      "nearestSegmentMarkerEndOffsetSeconds" : 757.1904335021973,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -3.102776050567627,
      "nearestSegmentMarkerStartOffsetSeconds" : 757.1904335021973,
      "startDate" : "2026-06-29T12:09:06Z",
      "startOffsetSeconds" : 760.2932095527649,
      "statistics" : [
        {
          "endDate" : "2026-06-29T12:11:06Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:09:06Z",
          "sum" : 19.02618296060401,
          "summary" : "ActiveEnergyBurned: sum 19.0 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-29T12:11:06Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:09:06Z",
          "sum" : 2.9355709027747987,
          "summary" : "BasalEnergyBurned: sum 2.9 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-29T12:11:06Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:09:06Z",
          "sum" : 317.6312901694349,
          "summary" : "DistanceWalkingRunning: sum 317.6 m",
          "unit" : "m"
        },
        {
          "average" : 133.95283018867923,
          "endDate" : "2026-06-29T12:11:06Z",
          "maximum" : 138,
          "minimum" : 131,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:09:06Z",
          "summary" : "HeartRate: avg 134.0 bpm, min 131.0 bpm, max 138.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 273.6818181818182,
          "endDate" : "2026-06-29T12:11:06Z",
          "maximum" : 291,
          "minimum" : 266,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:09:06Z",
          "summary" : "RunningGroundContactTime: avg 273.7 ms, min 266.0 ms, max 291.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 191.04255319148936,
          "endDate" : "2026-06-29T12:11:06Z",
          "maximum" : 195,
          "minimum" : 186,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:09:06Z",
          "summary" : "RunningPower: avg 191.0 W, min 186.0 W, max 195.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.684926557350297,
          "endDate" : "2026-06-29T12:11:06Z",
          "maximum" : 2.753993837040782,
          "minimum" : 2.6066107641536624,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:09:06Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 2.6 m\/s, max 2.8 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9236363636363636,
          "endDate" : "2026-06-29T12:11:06Z",
          "maximum" : 0.94,
          "minimum" : 0.9,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:09:06Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 7.045454545454545,
          "endDate" : "2026-06-29T12:11:06Z",
          "maximum" : 7.3999999999999995,
          "minimum" : 6.7,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:09:06Z",
          "summary" : "RunningVerticalOscillation: avg 7.0 cm, min 6.7 cm, max 7.4 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-29T12:11:06Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:09:06Z",
          "sum" : 342.7709079181743,
          "summary" : "StepCount: sum 342.8 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 19.0 kcal; BasalEnergyBurned: sum 2.9 kcal; DistanceWalkingRunning: sum 317.6 m; HeartRate: avg 134.0 bpm, min 131.0 bpm, max 138.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 4,
      "alignedPlannedStepLabel" : "Work 1",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1249.6888868808746,
      "durationSeconds" : 372.02334666252136,
      "endDate" : "2026-06-29T12:17:18Z",
      "endOffsetSeconds" : 1252.1967492103577,
      "events" : [
        {
          "durationSeconds" : 600.4416019916534,
          "endDate" : "2026-06-29T12:16:39Z",
          "endOffsetSeconds" : 1213.3119914531708,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1608.406722784213,
          "renderedSegmentMarkerDurationSeconds" : 600.4416019916534,
          "renderedSegmentMarkerEndOffsetSeconds" : 1213.3119914531708,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 612.8703894615173,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:06:38Z",
          "startOffsetSeconds" : 612.8703894615173,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 373.8491334915161,
          "endDate" : "2026-06-29T12:15:16Z",
          "endOffsetSeconds" : 1131.0395669937134,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 999.987420996021,
          "renderedSegmentMarkerDurationSeconds" : 373.8491334915161,
          "renderedSegmentMarkerEndOffsetSeconds" : 1131.0395669937134,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 757.1904335021973,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:09:03Z",
          "startOffsetSeconds" : 757.1904335021973,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 378.0604829788208,
          "endDate" : "2026-06-29T12:21:34Z",
          "endOffsetSeconds" : 1509.1000499725342,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1004.3705103394454,
          "renderedSegmentMarkerDurationSeconds" : 378.0604829788208,
          "renderedSegmentMarkerEndOffsetSeconds" : 1509.1000499725342,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1131.0395669937134,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:15:16Z",
          "startOffsetSeconds" : 1131.0395669937134,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 605.1213715076447,
          "endDate" : "2026-06-29T12:26:44Z",
          "endOffsetSeconds" : 1818.4333629608154,
          "index" : 4,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1610.2132500634452,
          "renderedSegmentMarkerDurationSeconds" : 605.1213715076447,
          "renderedSegmentMarkerEndOffsetSeconds" : 1818.4333629608154,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1213.3119914531708,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:16:39Z",
          "startOffsetSeconds" : 1213.3119914531708,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "4 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "54C19932-E6A5-47E7-9C03-CC521E2DCAB3",
      "index" : 4,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -38.88475775718689,
      "nearestRawEventEndOffsetSeconds" : 1213.3119914531708,
      "nearestRawEventStartDeltaSeconds" : -122.98296904563904,
      "nearestRawEventStartOffsetSeconds" : 757.1904335021973,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -2.5078623294830322,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1249.6888868808746,
      "nearestReconstructedIntervalIndex" : 4,
      "nearestReconstructedIntervalLabel" : "Work 1",
      "nearestSegmentMarkerEndDeltaSeconds" : -38.88475775718689,
      "nearestSegmentMarkerEndOffsetSeconds" : 1213.3119914531708,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -122.98296904563904,
      "nearestSegmentMarkerStartOffsetSeconds" : 757.1904335021973,
      "nextDistanceSampleEndOffsetSeconds" : 1252.2615820169449,
      "previousDistanceSampleEndOffsetSeconds" : 1247.116190314293,
      "startDate" : "2026-06-29T12:11:06Z",
      "startOffsetSeconds" : 880.1734025478363,
      "statistics" : [
        {
          "endDate" : "2026-06-29T12:17:18Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:11:06Z",
          "sum" : 60.453293082012046,
          "summary" : "ActiveEnergyBurned: sum 60.5 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-29T12:17:18Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:11:06Z",
          "sum" : 9.110029652309413,
          "summary" : "BasalEnergyBurned: sum 9.1 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-29T12:17:18Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:11:06Z",
          "sum" : 994.8709033485997,
          "summary" : "DistanceWalkingRunning: sum 994.9 m",
          "unit" : "m"
        },
        {
          "average" : 137.49226804123722,
          "endDate" : "2026-06-29T12:17:18Z",
          "maximum" : 144,
          "minimum" : 131,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:11:06Z",
          "summary" : "HeartRate: avg 137.5 bpm, min 131.0 bpm, max 144.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 270.27536231884056,
          "endDate" : "2026-06-29T12:17:18Z",
          "maximum" : 285,
          "minimum" : 259,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:11:06Z",
          "summary" : "RunningGroundContactTime: avg 270.3 ms, min 259.0 ms, max 285.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 193.18749999999997,
          "endDate" : "2026-06-29T12:17:18Z",
          "maximum" : 203,
          "minimum" : 175,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:11:06Z",
          "summary" : "RunningPower: avg 193.2 W, min 175.0 W, max 203.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.719121557199408,
          "endDate" : "2026-06-29T12:17:18Z",
          "maximum" : 2.8477402003333827,
          "minimum" : 2.447735228217268,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:11:06Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 2.4 m\/s, max 2.8 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9331884057971013,
          "endDate" : "2026-06-29T12:17:18Z",
          "maximum" : 1.08,
          "minimum" : 0.88,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:11:06Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 1.1 m",
          "unit" : "m"
        },
        {
          "average" : 7.079710144927535,
          "endDate" : "2026-06-29T12:17:18Z",
          "maximum" : 8,
          "minimum" : 6.6000000000000005,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:11:06Z",
          "summary" : "RunningVerticalOscillation: avg 7.1 cm, min 6.6 cm, max 8.0 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-29T12:17:18Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:11:06Z",
          "sum" : 1068.9299643125134,
          "summary" : "StepCount: sum 1068.9 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 60.5 kcal; BasalEnergyBurned: sum 9.1 kcal; DistanceWalkingRunning: sum 994.9 m; HeartRate: avg 137.5 bpm, min 131.0 bpm, max 144.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 5,
      "alignedPlannedStepLabel" : "Cooldown",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1622.7307941913605,
      "durationSeconds" : 373.2097953557968,
      "endDate" : "2026-06-29T12:23:31Z",
      "endOffsetSeconds" : 1625.4065445661545,
      "events" : [
        {
          "durationSeconds" : 378.0604829788208,
          "endDate" : "2026-06-29T12:21:34Z",
          "endOffsetSeconds" : 1509.1000499725342,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1004.3705103394454,
          "renderedSegmentMarkerDurationSeconds" : 378.0604829788208,
          "renderedSegmentMarkerEndOffsetSeconds" : 1509.1000499725342,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1131.0395669937134,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:15:16Z",
          "startOffsetSeconds" : 1131.0395669937134,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 605.1213715076447,
          "endDate" : "2026-06-29T12:26:44Z",
          "endOffsetSeconds" : 1818.4333629608154,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1610.2132500634452,
          "renderedSegmentMarkerDurationSeconds" : 605.1213715076447,
          "renderedSegmentMarkerEndOffsetSeconds" : 1818.4333629608154,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1213.3119914531708,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:16:39Z",
          "startOffsetSeconds" : 1213.3119914531708,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 376.98248291015625,
          "endDate" : "2026-06-29T12:27:51Z",
          "endOffsetSeconds" : 1886.0825328826904,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 995.6191625988376,
          "renderedSegmentMarkerDurationSeconds" : 376.98248291015625,
          "renderedSegmentMarkerEndOffsetSeconds" : 1886.0825328826904,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1509.1000499725342,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:21:34Z",
          "startOffsetSeconds" : 1509.1000499725342,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "3 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "5131C4CE-E47A-483A-9804-485C25C26D40",
      "index" : 5,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath"
      ],
      "nearestRawEventEndDeltaSeconds" : -116.3064945936203,
      "nearestRawEventEndOffsetSeconds" : 1509.1000499725342,
      "nearestRawEventStartDeltaSeconds" : -38.88475775718689,
      "nearestRawEventStartOffsetSeconds" : 1213.3119914531708,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -2.6757503747940063,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1622.7307941913605,
      "nearestReconstructedIntervalIndex" : 5,
      "nearestReconstructedIntervalLabel" : "Cooldown",
      "nearestSegmentMarkerEndDeltaSeconds" : -116.3064945936203,
      "nearestSegmentMarkerEndOffsetSeconds" : 1509.1000499725342,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -38.88475775718689,
      "nearestSegmentMarkerStartOffsetSeconds" : 1213.3119914531708,
      "nextDistanceSampleEndOffsetSeconds" : 1625.3035442829132,
      "previousDistanceSampleEndOffsetSeconds" : 1620.158043384552,
      "startDate" : "2026-06-29T12:17:18Z",
      "startOffsetSeconds" : 1252.1967492103577,
      "statistics" : [
        {
          "endDate" : "2026-06-29T12:23:31Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:17:18Z",
          "sum" : 61.322777230536616,
          "summary" : "ActiveEnergyBurned: sum 61.3 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-29T12:23:31Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:17:18Z",
          "sum" : 9.139109834748488,
          "summary" : "BasalEnergyBurned: sum 9.1 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-29T12:23:31Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:17:18Z",
          "sum" : 1002.6938880537947,
          "summary" : "DistanceWalkingRunning: sum 1002.7 m",
          "unit" : "m"
        },
        {
          "average" : 142.4357571057102,
          "endDate" : "2026-06-29T12:23:31Z",
          "maximum" : 146,
          "minimum" : 138,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:17:18Z",
          "summary" : "HeartRate: avg 142.4 bpm, min 138.0 bpm, max 146.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 268.88235294117646,
          "endDate" : "2026-06-29T12:23:31Z",
          "maximum" : 299,
          "minimum" : 244,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:17:18Z",
          "summary" : "RunningGroundContactTime: avg 268.9 ms, min 244.0 ms, max 299.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 193.46575342465755,
          "endDate" : "2026-06-29T12:23:31Z",
          "maximum" : 225,
          "minimum" : 75,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:17:18Z",
          "summary" : "RunningPower: avg 193.5 W, min 75.0 W, max 225.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.7196912879531605,
          "endDate" : "2026-06-29T12:23:31Z",
          "maximum" : 3.171409992593641,
          "minimum" : 0.988651153960296,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:17:18Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 1.0 m\/s, max 3.2 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9330303030303029,
          "endDate" : "2026-06-29T12:23:31Z",
          "maximum" : 1.02,
          "minimum" : 0.88,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:17:18Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 1.0 m",
          "unit" : "m"
        },
        {
          "average" : 7.06029411764706,
          "endDate" : "2026-06-29T12:23:31Z",
          "maximum" : 8.6,
          "minimum" : 6.7,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:17:18Z",
          "summary" : "RunningVerticalOscillation: avg 7.1 cm, min 6.7 cm, max 8.6 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-29T12:23:31Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:17:18Z",
          "sum" : 1064.4210820337828,
          "summary" : "StepCount: sum 1064.4 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 61.3 kcal; BasalEnergyBurned: sum 9.1 kcal; DistanceWalkingRunning: sum 1002.7 m; HeartRate: avg 142.4 bpm, min 138.0 bpm, max 146.0 bpm"
    }
  ],
  "workoutKitPlanAudit" : {
    "displayName" : "Priority 4 (no pause) ",
    "planID" : "CDE675EF-37A2-420B-91AE-F15683627ADE",
    "planType" : "Custom workout",
    "plannedSteps" : [
      {
        "index" : 1,
        "label" : "Warmup",
        "plannedGoalDisplayText" : "1 km",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 1000,
        "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
        "stepType" : "warmup"
      },
      {
        "index" : 2,
        "label" : "Work 1",
        "plannedGoalDisplayText" : "1 km",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 1000,
        "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
        "repeatBlockIndex" : 1,
        "repeatIndex" : 1,
        "stepType" : "work"
      },
      {
        "index" : 3,
        "label" : "Recovery 1",
        "plannedGoalDisplayText" : "120 s",
        "plannedGoalType" : "time",
        "plannedGoalValue" : 120,
        "repeatBlockIndex" : 2,
        "repeatIndex" : 1,
        "stepType" : "recovery"
      },
      {
        "index" : 4,
        "label" : "Work 1",
        "plannedGoalDisplayText" : "1 km",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 1000,
        "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
        "repeatBlockIndex" : 3,
        "repeatIndex" : 1,
        "stepType" : "work"
      },
      {
        "index" : 5,
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
      "Warmup: goal 1 km, alert pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "Block 1: 1x, 1 step(s)",
      "Block 1 step 1: Work - goal 1 km, alert pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "Block 2: 1x, 1 step(s)",
      "Block 2 step 1: Recovery - goal 120 s, alert none",
      "Block 3: 1x, 1 step(s)",
      "Block 3 step 1: Work - goal 1 km, alert pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "Cooldown: goal 1 km, alert pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current"
    ]
  }
}
```