# RunSignal Raw HealthKit Debug Export

Generated: 2026-06-29T21:03:57Z

## Review Packet Scope

This packet bundles Raw HealthKit Debug, WorkoutKit plan audit, HealthKit activity rows, Parity Lab candidate rows, structured comparison, fallback labels, pause/tail diagnostics, source metadata, and boundary warnings. It is debug/export-only and does not approve normal workout detail behavior.

Whole-run stats remain usable when custom interval rows are blocked. External HealthFit/FIT archives stay offline validation evidence; attach or reference them separately and do not treat FIT as app input or runtime truth.

Blocked custom interval diagnostics are review aids only. A supported Parity Lab status, readable fallback label, or exported candidate row does not change normal workout detail unless the exact ledger row separately reaches the normal-detail promotion rung.

## Workout

| Field | Value |
|---|---|
| Workout ID | 9C084DCE-3CCF-4401-8B99-CFB58EF0AC82 |
| Source | Adriel’s Apple Watch |
| Source ID | 9C084DCE-3CCF-4401-8B99-CFB58EF0AC82 |
| Device | Apple Watch Apple Inc. Watch |
| Start | Jun 29, 2026 |
| End | Jun 29, 2026 |
| Duration | 26:20 |
| Elapsed | 28:08 |
| Distance | 3.91 km |
| Avg pace | 6:44 /km |
| Avg HR | 141 bpm |
| Max HR | 178 bpm |
| Cadence | 163 spm |
| Power | 176 W |

## Evidence Counts

| Metric | Count |
|---|---:|
| Heart rate | 314 |
| Speed | 606 |
| Distance | 605 |
| Active energy | 611 |
| Power | 603 |
| Cadence | 607 |
| Step count | 607 |
| Stride length | 235 |
| Vertical oscillation | 236 |
| Ground contact | 233 |
| Route points | 1581 |
| Events | 10 |
| Workout activities | 3 |

## WorkoutKit Plan Audit

- Status: Available
- Plan type: Custom workout
- Plan ID: 56570A6C-3B7B-41D2-BCF8-4B9842914A16
- Display name: Priority 5 (pause everything) 
- Activity: HKWorkoutActivityType(rawValue: 37)
- Warmup: goal 1 km, alert pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current
- Block 1: 1x, 1 step(s)
- Block 1 step 1: Work - goal 2 km, alert pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current
- Cooldown: goal 1 km, alert pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current

## Raw HKWorkoutEvent Inventory

Debug-only inventory of public `HKWorkoutEvent` date windows and metadata keys. These rows are not Apple Fitness interval truth.

| Row | Event Type | Label | Start Offset | End Offset | Duration | Metadata Keys | Rendered Marker Window | Marker Distance | Marker Kind | Used By Segment Rendering | Excluded / Filtered Reason | Debug-Only Reason |
|---:|---|---|---:|---:|---:|---|---:|---:|---|---|---|---|
| 1 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 6:23 | 383.1 s | Unavailable | 0:00-6:23 | 1.01 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 2 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 10:10 | 609.8 s | Unavailable | 0:00-10:10 | 1.62 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 3 | HKWorkoutEventType(rawValue: 7) | Unavailable | 6:23 | 14:28 | 485.3 s | Unavailable | 6:23-14:28 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 4 | HKWorkoutEventType(rawValue: 7) | Unavailable | 10:10 | 22:26 | 735.7 s | Unavailable | 10:10-22:26 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 5 | HKWorkoutEventType(rawValue: 1) | Unavailable | 11:25 | 11:25 | 0.0 s | Unavailable | Unavailable | Unavailable | Unavailable | No | Excluded from segment rendering: zero or negative duration. | No rendered segment marker candidate. |
| 6 | HKWorkoutEventType(rawValue: 2) | Unavailable | 13:13 | 13:13 | 0.0 s | Unavailable | Unavailable | Unavailable | Unavailable | No | Excluded from segment rendering: zero or negative duration. | No rendered segment marker candidate. |
| 7 | HKWorkoutEventType(rawValue: 7) | Unavailable | 14:28 | 21:01 | 392.8 s | Unavailable | 14:28-21:01 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 8 | HKWorkoutEventType(rawValue: 7) | Unavailable | 21:01 | 28:05 | 423.6 s | Unavailable | 21:01-28:05 | 0.90 km | Raw segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 9 | HKWorkoutEventType(rawValue: 7) | Unavailable | 22:26 | 28:05 | 339.2 s | Unavailable | 22:26-28:05 | 0.68 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 10 | HKWorkoutEventType(rawValue: 1) | Unavailable | 28:08 | 28:08 | 0.0 s | Unavailable | Unavailable | Unavailable | Unavailable | No | Excluded from segment rendering: zero or negative duration. | No rendered segment marker candidate. |

## HKWorkoutActivity Inventory

Debug-only inventory of public `HKWorkout.workoutActivities` rows. These rows are not used for production interval reconstruction.

| Activity | Type | Start Date | End Date | Start Offset | End Offset | Duration | Metadata Keys | Nested Events | Statistics | Aligns Planned Step | Aligned Planned Step | Nearest Reconstructed Row | Row End Delta | Apple Fitness/manual | FIT Lap | Raw Event Start | Raw Start Delta | Raw Event End | Raw End Delta | Segment Start | Segment Start Delta | Segment End | Segment End Delta | Previous Sample End | Crossing Sample End | Next Sample End |
|---:|---|---|---|---:|---:|---:|---|---|---|---|---|---|---:|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | HKWorkoutActivityType(rawValue: 37) | 2026-06-29T12:31:53Z | 2026-06-29T12:38:19Z | 0.0 s | 386.1 s | 386.1 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 3 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 61.6 kcal; BasalEnergyBurned: sum 9.4 kcal; DistanceWalkingRunning: sum 1007.5 m; HeartRate: avg 135.4 bpm, min 111.0 bpm, max 146.0 bpm | No | Unavailable | Warmup | -3.1 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 0.0 s | 0.0 s | 383.1 s | -3.0 s | 0.0 s | 0.0 s | 383.1 s | -3.0 s | 380.4 s | 383.0 s | 385.5 s |
| 2 | HKWorkoutActivityType(rawValue: 37) | 2026-06-29T12:38:19Z | 2026-06-29T12:47:47Z | 386.1 s | 954.7 s | 460.5 s | HKElevationAscended, WOIntervalStepKeyPath, WOIntervalStepSuccessful | 6 event(s): HKWorkoutEventType(rawValue: 1), HKWorkoutEventType(rawValue: 2), HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 79.7 kcal; BasalEnergyBurned: sum 11.3 kcal; DistanceWalkingRunning: sum 1211.8 m; HeartRate: avg 142.4 bpm, min 126.0 bpm, max 152.0 bpm | No | Unavailable | Work 1 | 308.1 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 383.1 s | -3.0 s | 868.4 s | -86.3 s | 383.1 s | -3.0 s | 868.4 s | -86.3 s | 1260.3 s | 1262.9 s | 1265.5 s |
| 3 | HKWorkoutActivityType(rawValue: 37) | 2026-06-29T12:47:47Z | 2026-06-29T12:54:18Z | 954.7 s | 1345.3 s | 390.6 s | HKElevationAscended, WOIntervalStepKeyPath | 3 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 69.1 kcal; BasalEnergyBurned: sum 9.6 kcal; DistanceWalkingRunning: sum 998.8 m; HeartRate: avg 142.5 bpm, min 138.0 bpm, max 146.0 bpm | No | Unavailable | Work 1 | -82.5 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 868.4 s | -86.3 s | 1345.6 s | 0.2 s | 868.4 s | -86.3 s | 1345.6 s | 0.2 s | 1260.3 s | 1262.9 s | 1265.5 s |

## WorkoutKit Reconstructed Intervals

Planned structure source: WorkoutKit when available. Measured stats source: HealthKit samples.

| Row | Label | Goal | Target | Distance | Elapsed | Pause overlap | Active time | Display time | Duration rule | Pace | Avg HR | Max HR | Power | Start Offset | End Offset | Boundary Strategy | Boundary Adjustment | Overshoot | Confidence | Notes |
|---:|---|---|---|---:|---:|---:|---:|---:|---|---:|---:|---:|---:|---:|---:|---|---:|---:|---|---|
| 1 | Warmup | 1 km | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 1.01 km | 6:23 |  | Unavailable | 6:23 | elapsedRowWindow | 6:21 /km | 136 bpm | 146 bpm | 188 W | 0:00 | 6:23 | crossing sample end | 2.4 s | 5.9 m | High | Distance-goal boundary: crossing sample end, adjustment +2.4s, overshoot 5.9 m |
| 2 | Work 1 | 2 km | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 2.00 km | 14:40 |  | Unavailable | 14:40 | elapsedRowWindow | 7:19 /km | 143 bpm | 152 bpm | 187 W | 6:23 | 21:03 | crossing sample end | 1.9 s | 4.2 m | High | Distance-goal boundary: crossing sample end, adjustment +1.9s, overshoot 4.2 m |
| 3 | Open / Extra | Open | Target unavailable | 0.90 km | 7:05 |  | Unavailable | 7:05 | elapsedRowWindow | 7:54 /km | 144 bpm | 178 bpm | 144 W | 21:03 | 28:08 |  |  |  | Medium | Extra tail after planned WorkoutKit steps |

Notes: Plan source: WorkoutKit · Window source: Plan-derived from HealthKit distance/time samples · Stats source: HealthKit samples · HealthKit segment markers: not used · Could not reconstruct Cooldown; missing usable distance evidence.

## HKWorkoutActivity Boundary Candidate Intervals

Debug-only alternate reconstruction for Parity Lab exports. These rows are not production interval logic and are not shown in the normal workout UI.

| Field | Value |
|---|---|
| Mapping status | mappedByPlannedStepOrder |
| Activity count | 3 |
| Planned step count | 3 |
| Scoreable | Yes |
| Not scoreable reason | n/a |
| Production UI warning | HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI. |

| Row | Label | Goal | Mapping | Activity | Start Offset | End Offset | Distance | Time | Candidate Confidence | Reason If Not Scoreable | Caveats |
|---:|---|---|---|---:|---:|---:|---:|---:|---|---|---|
| 1 | Warmup | 1 km | mappedByPlannedStepOrder | 1 | 0.0 s | 386.1 s | 1007.5 m | 386.1 s | activity boundary direct |  | Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 2 | Work 1 | 2 km | mappedByPlannedStepOrder | 2 | 386.1 s | 954.7 s | 1211.8 m | 568.7 s | activity boundary direct |  | Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 3 | Cooldown | 1 km | mappedByPlannedStepOrder | 3 | 954.7 s | 1345.3 s | 998.8 m | 390.6 s | activity boundary direct |  | Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 4 | Open / Extra | Open | inferredOpenTailFromWorkoutEnd | Inferred | 1345.3 s | 1687.7 s | 688.5 m | 342.4 s | activity boundary inferred tail |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Inferred from workout end minus final mapped activity boundary. No separate HKWorkoutActivity row represented this tail. |

Caveats: debug-only, not promoted · not production interval logic · not shown in normal workout UI · FIT and Apple Fitness/manual rows are not runtime inputs · Activities are generic HealthKit activity windows and labels are mapped from WorkoutKit planned step order. · Missing or ambiguous activity rows must not replace current reconstruction.

## Custom Workout Candidate Rule Scorer

Debug-only Parity Lab scorer for active-time duration, pause overlap, and Open / Extra tail rows. These rows are not production interval logic, are not shown in the normal workout UI, and do not approve a normal-detail gate.

| Field | Value |
|---|---|
| Strategy | custom_workout_candidate_rule_active_time |
| Rule status | candidate-rule-scoreable |
| Candidate row count | 4 |
| Planned expanded row count | 3 |
| Open tail row count | 1 |
| Paired pause count | 1 |
| Total paired pause | 108.2 s |
| Fixed row exhaustion | fixed-rows-exhausted-before-tail |
| Tail status | open-extra-tail-present |
| Tail duration | 342.4 s |
| Tail distance | 688.5 m |
| Fallback reasons |  |
| Safety flags | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. |
| FIT validation | offline-evidence-only-not-runtime-truth |
| Scoreable | Yes |
| Not scoreable reason | n/a |
| Production UI warning | Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI. |

| Row | Label | Mapping | Start offset | End offset | Elapsed | Pause overlap | Active time | Distance | Display rule | Duration rule | Confidence | Caveats |
|---:|---|---|---:|---:|---:|---:|---:|---:|---|---|---|---|
| 1 | Warmup | mappedByPlannedStepOrder | 0.0 s | 386.1 s | 386.1 s | 0.0 s | 386.1 s | 1007.5 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 2 | Work 1 | mappedByPlannedStepOrder | 386.1 s | 954.7 s | 568.7 s | 108.2 s | 460.5 s | 1211.8 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 3 | Cooldown | mappedByPlannedStepOrder | 954.7 s | 1345.3 s | 390.6 s | 0.0 s | 390.6 s | 998.8 m | active-duration-minus-paired-pause-overlap | active-duration-minus-paired-pause-overlap | activity boundary direct | Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |
| 4 | Open / Extra | inferredOpenTailFromWorkoutEnd | 1345.3 s | 1687.7 s | 342.4 s | 0.0 s | 342.4 s | 688.5 m | open-tail-measured-duration | open-tail-measured-duration | activity boundary inferred tail | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Inferred from workout end minus final mapped activity boundary. No separate HKWorkoutActivity row represented this tail. |

Caveats: debug-only, not promoted · not production interval logic · not shown in normal workout UI · FIT and Apple Fitness/manual rows are not runtime inputs · Active duration subtracts paired HealthKit pause/resume overlap when available.

## Custom Workout Structured Comparison

Debug-only structured status and fallback taxonomy for Parity Lab rows. This status is not production interval logic, is not shown in the normal workout UI, and does not approve a normal-detail gate by itself.

| Field | Value |
|---|---|
| Status | open-tail-needs-rule |
| Status label | Open / Extra tail handling needs an approved rule. |
| Fallback reasons | Open / Extra tail handling is ambiguous for this workout shape. |
| Primary fallback | Open / Extra tail handling is ambiguous for this workout shape. |
| Row count | 3 |
| Row confidences | needsRule, needsRule, needsRule |
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
| End offset | 6:23 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 2.4 s |
| Overshoot | 5.9 m |
| Cumulative distance at start | 0.0 m |
| Cumulative distance at end | 1005.9 m |
| Interpolation fraction | 0.052 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 6:18 | 6:20 | 992.6 m | 999.7 m |
| Crossing | 6:20 | 6:23 | 999.7 m | 1005.9 m |
| Next | 6:23 | 6:26 | 1005.9 m | 1013.4 m |

### Row 2: Work 1

| Field | Value |
|---|---:|
| Target distance | 2000.0 m |
| Start offset | 6:23 |
| End offset | 21:03 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 1.9 s |
| Overshoot | 4.2 m |
| Cumulative distance at start | 1005.9 m |
| Cumulative distance at end | 3010.2 m |
| Interpolation fraction | 0.258 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 20:58 | 21:00 | 2997.4 m | 3004.5 m |
| Crossing | 21:00 | 21:03 | 3004.5 m | 3010.2 m |
| Next | 21:03 | 21:05 | 3010.2 m | 3017.1 m |

### Row 3: Open / Extra Tail

| Field | Value |
|---|---:|
| Planned final step end offset | 21:03 |
| Workout end offset | 28:08 |
| Remaining seconds | 424.8 s |
| Remaining meters | 896.4 m |
| Final distance sample offset | 28:02 |
| Final distance sample cumulative | 3906.5 m |
| Last HR sample offset | 28:05 |
| Last power sample offset | 28:02 |
| Last cadence sample offset | 28:02 |
| Reason | Remaining workout time or distance exceeded Open / Extra threshold after planned WorkoutKit steps. |

## HealthKit Segment Markers

Raw debug only. HealthKit Segment Markers must not be promoted as Apple Fitness interval rows.

| Row | Label | Marker Kind | Source | Distance | Time | Pace | Avg HR | Start Offset | End Offset | Confidence | Caveats |
|---:|---|---|---|---:|---:|---:|---:|---:|---:|---|---|
| 1 | Unknown | Split marker | HealthKit segment pattern | 1.01 km | 6:23 | 6:21 /km | 136 bpm | 0:00 | 6:23 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 2 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.62 km | 10:10 | 6:17 /km | 139 bpm | 0:00 | 10:10 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 3 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 8:05 | 8:05 /km | 143 bpm | 6:23 | 14:28 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 4 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 12:16 | 7:38 /km | 142 bpm | 10:10 | 22:26 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 5 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:33 | 6:33 /km | 142 bpm | 14:28 | 21:01 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 6 | Unknown | Raw segment marker | HealthKit segment pattern | 0.90 km | 7:04 | 7:51 /km | 144 bpm | 21:01 | 28:05 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event is a raw HealthKit marker until interval parity is proven. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |
| 7 | Unknown | Overlapping segment marker | HealthKit segment pattern | 0.68 km | 5:39 | 8:18 /km | 144 bpm | 22:26 | 28:05 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted. WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics. |

## Planned Step Boundary Comparison

Debug-only comparison helper for FIT/Apple boundary investigation. The FIT lap end offset is intentionally a manual placeholder; RunSignal does not read FIT at runtime.

| Row | Planned Step | Goal | RunSignal End | FIT Lap End | Nearest Raw Event End | Event Delta | Nearest Activity End | Activity Delta | Activity Type | Nearest Segment End | Segment Delta | Previous Sample End | Crossing Sample End | Next Sample End | Warning |
|---:|---|---|---:|---:|---:|---:|---:|---:|---|---:|---:|---:|---:|---:|---|
| 1 | Warmup | 1 km | 383.0 s | Manual FIT placeholder | 383.1 s | 0.1 s | 386.1 s | 3.1 s | HKWorkoutActivityType(rawValue: 37) | 383.1 s | 0.1 s | 380.4 s | 383.0 s | 385.5 s |  |
| 2 | Work 1 | 2 km | 1262.9 s | Manual FIT placeholder | 1261.3 s | -1.6 s | 1345.3 s | 82.5 s | HKWorkoutActivityType(rawValue: 37) | 1261.3 s | -1.6 s | 1260.3 s | 1262.9 s | 1265.5 s |  |
| 3 | Cooldown | Open | 1687.7 s | Manual FIT placeholder | 1684.8 s | -2.9 s | 1345.3 s | -342.4 s | HKWorkoutActivityType(rawValue: 37) | 1684.8 s | -2.9 s | Unavailable | Unavailable | Unavailable |  |

## Boundary Source Warnings

- One or more raw HKWorkoutEvent records have unavailable metadata keys.
- HKWorkoutActivity end boundaries do not align within 3 seconds of reconstructed planned-step row ends.
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
      "distanceMeters" : 1007.4834852371379,
      "durationSeconds" : 386.0734852552414,
      "endOffsetSeconds" : 386.0734852552414,
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
      "distanceMeters" : 1211.7571052208305,
      "durationSeconds" : 568.6582807302475,
      "endOffsetSeconds" : 954.7317659854889,
      "index" : 2,
      "label" : "Work 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "2 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 2000,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 386.0734852552414,
      "stepType" : "work"
    },
    {
      "activityIndex" : 3,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 998.8098980472089,
      "durationSeconds" : 390.5984698534012,
      "endOffsetSeconds" : 1345.33023583889,
      "index" : 3,
      "label" : "Cooldown",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "1 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 1000,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 954.7317659854889,
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
      "distanceMeters" : 688.4937994360089,
      "durationSeconds" : 342.37749111652374,
      "endOffsetSeconds" : 1687.7077269554138,
      "index" : 4,
      "label" : "Open \/ Extra",
      "mappingStatus" : "inferredOpenTailFromWorkoutEnd",
      "plannedGoalDisplayText" : "Open",
      "plannedGoalType" : "open",
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1345.33023583889,
      "stepType" : "open"
    }
  ],
  "activityBoundaryCandidateSummary" : {
    "activityCount" : 3,
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
    "plannedStepCount" : 3,
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
          "endCumulativeDistanceMeters" : 1005.9421286939178,
          "endDate" : "2026-06-29T12:38:16Z",
          "endOffsetSeconds" : 382.9695198535919,
          "startCumulativeDistanceMeters" : 999.6771451563109,
          "startDate" : "2026-06-29T12:38:13Z",
          "startOffsetSeconds" : 380.39672553539276
        },
        "cumulativeDistanceAtEndMeters" : 1005.9421286939178,
        "cumulativeDistanceAtStartMeters" : 0,
        "interpolationFraction" : 0.05153323097357303,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 1013.4078651566524,
          "endDate" : "2026-06-29T12:38:18Z",
          "endOffsetSeconds" : 385.54231309890747,
          "startCumulativeDistanceMeters" : 1005.9421286939178,
          "startDate" : "2026-06-29T12:38:16Z",
          "startOffsetSeconds" : 382.9695198535919
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 999.6771451563109,
          "endDate" : "2026-06-29T12:38:13Z",
          "endOffsetSeconds" : 380.39672553539276,
          "startCumulativeDistanceMeters" : 992.580774113303,
          "startDate" : "2026-06-29T12:38:11Z",
          "startOffsetSeconds" : 377.823930978775
        },
        "targetDistanceMeters" : 1000
      },
      "index" : 1,
      "label" : "Warmup"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3010.1813315106556,
          "endDate" : "2026-06-29T12:52:56Z",
          "endOffsetSeconds" : 1262.879832148552,
          "startCumulativeDistanceMeters" : 3004.4716054811142,
          "startDate" : "2026-06-29T12:52:53Z",
          "startOffsetSeconds" : 1260.307086110115
        },
        "cumulativeDistanceAtEndMeters" : 3010.1813315106556,
        "cumulativeDistanceAtStartMeters" : 1005.9421286939178,
        "interpolationFraction" : 0.25754707059414783,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3017.126612709835,
          "endDate" : "2026-06-29T12:52:58Z",
          "endOffsetSeconds" : 1265.4525760412216,
          "startCumulativeDistanceMeters" : 3010.1813315106556,
          "startDate" : "2026-06-29T12:52:56Z",
          "startOffsetSeconds" : 1262.879832148552
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3004.4716054811142,
          "endDate" : "2026-06-29T12:52:53Z",
          "endOffsetSeconds" : 1260.307086110115,
          "startCumulativeDistanceMeters" : 2997.366533363005,
          "startDate" : "2026-06-29T12:52:50Z",
          "startOffsetSeconds" : 1257.7343413829803
        },
        "targetDistanceMeters" : 2000
      },
      "index" : 2,
      "label" : "Work 1"
    },
    {
      "index" : 3,
      "label" : "Open \/ Extra",
      "tail" : {
        "creationReason" : "Remaining workout time or distance exceeded Open \/ Extra threshold after planned WorkoutKit steps.",
        "finalDistanceSampleCumulativeDistanceMeters" : 3906.5442879411858,
        "finalDistanceSampleOffsetSeconds" : 1682.246218085289,
        "lastCadenceSampleOffsetSeconds" : 1682.246218085289,
        "lastHeartRateSampleOffsetSeconds" : 1684.5779539346695,
        "lastPowerSampleOffsetSeconds" : 1682.246218085289,
        "plannedFinalStepEndOffsetSeconds" : 1262.879832148552,
        "remainingMeters" : 896.3629564305302,
        "remainingSeconds" : 424.8278948068619,
        "workoutEndOffsetSeconds" : 1687.7077269554138
      }
    }
  ],
  "boundarySourceWarnings" : [
    "One or more raw HKWorkoutEvent records have unavailable metadata keys.",
    "HKWorkoutActivity end boundaries do not align within 3 seconds of reconstructed planned-step row ends.",
    "FIT lap end offsets are not read by RunSignal; compare them manually after physical-device export.",
    "Apple Fitness\/manual row offsets are not read by RunSignal; compare HKWorkoutActivity timing manually after physical-device export."
  ],
  "caveats" : [

  ],
  "customWorkoutCandidateRuleRows" : [
    {
      "activeDurationSeconds" : 386.0734852552414,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 1007.4834852371379,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 386.0734852552414,
      "endOffsetSeconds" : 386.0734852552414,
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
      "activeDurationSeconds" : 460.45380675792694,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 1211.7571052208305,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 568.6582807302475,
      "endOffsetSeconds" : 954.7317659854889,
      "index" : 2,
      "isOpenTail" : false,
      "label" : "Work 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 108.20447397232056,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 386.0734852552414,
      "stepType" : "work"
    },
    {
      "activeDurationSeconds" : 390.5984698534012,
      "candidateConfidence" : "activity boundary direct",
      "caveats" : [
        "Mapped to WorkoutKit planned step order only.",
        "Uses public HKWorkoutActivity statistics and date windows."
      ],
      "distanceMeters" : 998.8098980472089,
      "durationDisplayRule" : "active-duration-minus-paired-pause-overlap",
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 390.5984698534012,
      "endOffsetSeconds" : 1345.33023583889,
      "index" : 3,
      "isOpenTail" : false,
      "label" : "Cooldown",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 954.7317659854889,
      "stepType" : "cooldown"
    },
    {
      "activeDurationSeconds" : 342.37749111652374,
      "candidateConfidence" : "activity boundary inferred tail",
      "caveats" : [
        "debug-only, not promoted",
        "not production interval logic",
        "not shown in normal workout UI",
        "FIT and Apple Fitness\/manual rows are not runtime inputs",
        "Inferred from workout end minus final mapped activity boundary.",
        "No separate HKWorkoutActivity row represented this tail."
      ],
      "distanceMeters" : 688.4937994360089,
      "durationDisplayRule" : "open-tail-measured-duration",
      "durationRule" : "open-tail-measured-duration",
      "elapsedDurationSeconds" : 342.37749111652374,
      "endOffsetSeconds" : 1687.7077269554138,
      "index" : 4,
      "isOpenTail" : true,
      "label" : "Open \/ Extra",
      "mappingStatus" : "inferredOpenTailFromWorkoutEnd",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 1345.33023583889,
      "stepType" : "open"
    }
  ],
  "customWorkoutCandidateRuleSummary" : {
    "boundaryLogicChanged" : false,
    "candidateRowCount" : 4,
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
    "pairedPauseCount" : 1,
    "plannedExpandedRowCount" : 3,
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
    "tailDistanceMeters" : 688.4937994360089,
    "tailElapsedDurationSeconds" : 342.37749111652374,
    "tailStatus" : "open-extra-tail-present",
    "totalPairedPauseSeconds" : 108.20447397232056,
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
      "needsRule"
    ],
    "rowCount" : 3,
    "scope" : "debug\/export-only",
    "status" : "open-tail-needs-rule",
    "statusLabel" : "Open \/ Extra tail handling needs an approved rule.",
    "tailAmbiguity" : "fixedCooldownFollowedByPossibleOpenExtraTail",
    "usesFITRuntimeTruth" : false
  },
  "evidenceCounts" : {
    "activeEnergy" : 611,
    "activities" : 3,
    "cadence" : 607,
    "distance" : 605,
    "events" : 10,
    "groundContact" : 233,
    "heartRate" : 314,
    "power" : 603,
    "routePoints" : 1581,
    "speed" : 606,
    "stepCount" : 607,
    "strideLength" : 235,
    "verticalOscillation" : 236
  },
  "generatedAt" : "2026-06-29T21:03:57Z",
  "plannedStepBoundaryComparisons" : [
    {
      "crossingDistanceSampleEndOffsetSeconds" : 382.9695198535919,
      "index" : 1,
      "nearestRawEventEndDeltaSeconds" : 0.1325843334197998,
      "nearestRawEventEndOffsetSeconds" : 383.1021041870117,
      "nearestRawEventStartOffsetSeconds" : 0,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 0.1325843334197998,
      "nearestSegmentMarkerEndOffsetSeconds" : 383.1021041870117,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 0,
      "nearestWorkoutActivityEndDeltaSeconds" : 3.103965401649475,
      "nearestWorkoutActivityEndOffsetSeconds" : 386.0734852552414,
      "nearestWorkoutActivityStartOffsetSeconds" : 0,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 385.54231309890747,
      "plannedGoalDisplayText" : "1 km",
      "plannedStepLabel" : "Warmup",
      "previousDistanceSampleEndOffsetSeconds" : 380.39672553539276,
      "reconstructedEndOffsetSeconds" : 382.9695198535919,
      "reconstructedLabel" : "Warmup"
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1262.879832148552,
      "index" : 2,
      "nearestRawEventEndDeltaSeconds" : -1.6191679239273071,
      "nearestRawEventEndOffsetSeconds" : 1261.2606642246246,
      "nearestRawEventStartOffsetSeconds" : 868.4362744092941,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -1.6191679239273071,
      "nearestSegmentMarkerEndOffsetSeconds" : 1261.2606642246246,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 868.4362744092941,
      "nearestWorkoutActivityEndDeltaSeconds" : 82.45040369033813,
      "nearestWorkoutActivityEndOffsetSeconds" : 1345.33023583889,
      "nearestWorkoutActivityStartOffsetSeconds" : 954.7317659854889,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 1265.4525760412216,
      "plannedGoalDisplayText" : "2 km",
      "plannedStepLabel" : "Work 1",
      "previousDistanceSampleEndOffsetSeconds" : 1260.307086110115,
      "reconstructedEndOffsetSeconds" : 1262.879832148552,
      "reconstructedLabel" : "Work 1"
    },
    {
      "index" : 3,
      "nearestRawEventEndDeltaSeconds" : -2.8887815475463867,
      "nearestRawEventEndOffsetSeconds" : 1684.8189454078674,
      "nearestRawEventStartOffsetSeconds" : 1261.2606642246246,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -2.8887815475463867,
      "nearestSegmentMarkerEndOffsetSeconds" : 1684.8189454078674,
      "nearestSegmentMarkerKind" : "rawSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1261.2606642246246,
      "nearestWorkoutActivityEndDeltaSeconds" : -342.37749111652374,
      "nearestWorkoutActivityEndOffsetSeconds" : 1345.33023583889,
      "nearestWorkoutActivityStartOffsetSeconds" : 954.7317659854889,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "plannedGoalDisplayText" : "Open",
      "plannedStepLabel" : "Cooldown",
      "reconstructedEndOffsetSeconds" : 1687.7077269554138,
      "reconstructedLabel" : "Open \/ Extra"
    }
  ],
  "rawWorkoutEvents" : [
    {
      "durationSeconds" : 383.1021041870117,
      "endDate" : "2026-06-29T12:38:16Z",
      "endOffsetSeconds" : 383.1021041870117,
      "index" : 1,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1006.3268621715114,
      "renderedSegmentMarkerDurationSeconds" : 383.1021041870117,
      "renderedSegmentMarkerEndOffsetSeconds" : 383.1021041870117,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-29T12:31:53Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 609.841292142868,
      "endDate" : "2026-06-29T12:42:03Z",
      "endOffsetSeconds" : 609.841292142868,
      "index" : 2,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1617.4698127977153,
      "renderedSegmentMarkerDurationSeconds" : 609.841292142868,
      "renderedSegmentMarkerEndOffsetSeconds" : 609.841292142868,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-29T12:31:53Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 485.3341702222824,
      "endDate" : "2026-06-29T12:46:21Z",
      "endOffsetSeconds" : 868.4362744092941,
      "index" : 3,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1000.1010810490474,
      "renderedSegmentMarkerDurationSeconds" : 485.3341702222824,
      "renderedSegmentMarkerEndOffsetSeconds" : 868.4362744092941,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 383.1021041870117,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-29T12:38:16Z",
      "startOffsetSeconds" : 383.1021041870117,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 735.7372370958328,
      "endDate" : "2026-06-29T12:54:18Z",
      "endOffsetSeconds" : 1345.5785292387009,
      "index" : 4,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1607.84175284611,
      "renderedSegmentMarkerDurationSeconds" : 735.7372370958328,
      "renderedSegmentMarkerEndOffsetSeconds" : 1345.5785292387009,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 609.841292142868,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-29T12:42:03Z",
      "startOffsetSeconds" : 609.841292142868,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 0,
      "endDate" : "2026-06-29T12:43:18Z",
      "endOffsetSeconds" : 685.0017039775848,
      "excludedOrFilteredReason" : "zeroOrNegativeDuration",
      "index" : 5,
      "metadataKeys" : [

      ],
      "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
      "startDate" : "2026-06-29T12:43:18Z",
      "startOffsetSeconds" : 685.0017039775848,
      "type" : "HKWorkoutEventType(rawValue: 1)",
      "usedBySegmentMarkerRendering" : false
    },
    {
      "durationSeconds" : 0,
      "endDate" : "2026-06-29T12:45:06Z",
      "endOffsetSeconds" : 793.2061779499054,
      "excludedOrFilteredReason" : "zeroOrNegativeDuration",
      "index" : 6,
      "metadataKeys" : [

      ],
      "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
      "startDate" : "2026-06-29T12:45:06Z",
      "startOffsetSeconds" : 793.2061779499054,
      "type" : "HKWorkoutEventType(rawValue: 2)",
      "usedBySegmentMarkerRendering" : false
    },
    {
      "durationSeconds" : 392.8243898153305,
      "endDate" : "2026-06-29T12:52:54Z",
      "endOffsetSeconds" : 1261.2606642246246,
      "index" : 7,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1000.1599495661319,
      "renderedSegmentMarkerDurationSeconds" : 392.8243898153305,
      "renderedSegmentMarkerEndOffsetSeconds" : 1261.2606642246246,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 868.4362744092941,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-29T12:46:21Z",
      "startOffsetSeconds" : 868.4362744092941,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 423.5582811832428,
      "endDate" : "2026-06-29T12:59:58Z",
      "endOffsetSeconds" : 1684.8189454078674,
      "index" : 8,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 899.9563951544951,
      "renderedSegmentMarkerDurationSeconds" : 423.5582811832428,
      "renderedSegmentMarkerEndOffsetSeconds" : 1684.8189454078674,
      "renderedSegmentMarkerKind" : "rawSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1261.2606642246246,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-29T12:52:54Z",
      "startOffsetSeconds" : 1261.2606642246246,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 339.24041616916656,
      "endDate" : "2026-06-29T12:59:58Z",
      "endOffsetSeconds" : 1684.8189454078674,
      "index" : 9,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 681.2327222973604,
      "renderedSegmentMarkerDurationSeconds" : 339.24041616916656,
      "renderedSegmentMarkerEndOffsetSeconds" : 1684.8189454078674,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1345.5785292387009,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-29T12:54:18Z",
      "startOffsetSeconds" : 1345.5785292387009,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 0,
      "endDate" : "2026-06-29T13:00:00Z",
      "endOffsetSeconds" : 1687.7077269554138,
      "excludedOrFilteredReason" : "zeroOrNegativeDuration",
      "index" : 10,
      "metadataKeys" : [

      ],
      "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
      "startDate" : "2026-06-29T13:00:00Z",
      "startOffsetSeconds" : 1687.7077269554138,
      "type" : "HKWorkoutEventType(rawValue: 1)",
      "usedBySegmentMarkerRendering" : false
    }
  ],
  "reconstructedIntervals" : [
    {
      "averageHeartRateBpm" : 135.77631578947367,
      "averagePower" : 187.65540540540542,
      "boundaryAdjustmentSeconds" : 2.4402098655700684,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 1005.9421286939178,
          "endDate" : "2026-06-29T12:38:16Z",
          "endOffsetSeconds" : 382.9695198535919,
          "startCumulativeDistanceMeters" : 999.6771451563109,
          "startDate" : "2026-06-29T12:38:13Z",
          "startOffsetSeconds" : 380.39672553539276
        },
        "cumulativeDistanceAtEndMeters" : 1005.9421286939178,
        "cumulativeDistanceAtStartMeters" : 0,
        "interpolationFraction" : 0.05153323097357303,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 1013.4078651566524,
          "endDate" : "2026-06-29T12:38:18Z",
          "endOffsetSeconds" : 385.54231309890747,
          "startCumulativeDistanceMeters" : 1005.9421286939178,
          "startDate" : "2026-06-29T12:38:16Z",
          "startOffsetSeconds" : 382.9695198535919
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 999.6771451563109,
          "endDate" : "2026-06-29T12:38:13Z",
          "endOffsetSeconds" : 380.39672553539276,
          "startCumulativeDistanceMeters" : 992.580774113303,
          "startDate" : "2026-06-29T12:38:11Z",
          "startOffsetSeconds" : 377.823930978775
        },
        "targetDistanceMeters" : 1000
      },
      "boundaryOvershootMeters" : 5.942128693917766,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "displayDurationSeconds" : 382.9695198535919,
      "distanceMeters" : 1005.9421286939178,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 382.9695198535919,
      "elapsedDurationSeconds" : 382.9695198535919,
      "endOffsetSeconds" : 382.9695198535919,
      "index" : 1,
      "label" : "Warmup",
      "maxHeartRateBpm" : 146,
      "paceSecondsPerKm" : 380.7073080345357,
      "plannedGoalDisplayText" : "1 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 1000,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +2.4s, overshoot 5.9 m",
      "startOffsetSeconds" : 0,
      "stepType" : "warmup"
    },
    {
      "averageHeartRateBpm" : 142.68387096774194,
      "averagePower" : 187.08695652173913,
      "boundaryAdjustmentSeconds" : 1.9101427793502808,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 3010.1813315106556,
          "endDate" : "2026-06-29T12:52:56Z",
          "endOffsetSeconds" : 1262.879832148552,
          "startCumulativeDistanceMeters" : 3004.4716054811142,
          "startDate" : "2026-06-29T12:52:53Z",
          "startOffsetSeconds" : 1260.307086110115
        },
        "cumulativeDistanceAtEndMeters" : 3010.1813315106556,
        "cumulativeDistanceAtStartMeters" : 1005.9421286939178,
        "interpolationFraction" : 0.25754707059414783,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 3017.126612709835,
          "endDate" : "2026-06-29T12:52:58Z",
          "endOffsetSeconds" : 1265.4525760412216,
          "startCumulativeDistanceMeters" : 3010.1813315106556,
          "startDate" : "2026-06-29T12:52:56Z",
          "startOffsetSeconds" : 1262.879832148552
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 3004.4716054811142,
          "endDate" : "2026-06-29T12:52:53Z",
          "endOffsetSeconds" : 1260.307086110115,
          "startCumulativeDistanceMeters" : 2997.366533363005,
          "startDate" : "2026-06-29T12:52:50Z",
          "startOffsetSeconds" : 1257.7343413829803
        },
        "targetDistanceMeters" : 2000
      },
      "boundaryOvershootMeters" : 4.239202816737816,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "displayDurationSeconds" : 879.91031229496,
      "distanceMeters" : 2004.2392028167378,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 879.91031229496,
      "elapsedDurationSeconds" : 879.91031229496,
      "endOffsetSeconds" : 1262.879832148552,
      "index" : 2,
      "label" : "Work 1",
      "maxHeartRateBpm" : 152,
      "paceSecondsPerKm" : 439.024598989154,
      "plannedGoalDisplayText" : "2 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 2000,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +1.9s, overshoot 4.2 m",
      "startOffsetSeconds" : 382.9695198535919,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 143.50602409638554,
      "averagePower" : 143.56962025316454,
      "confidence" : "medium",
      "displayDurationSeconds" : 424.8278948068619,
      "distanceMeters" : 896.3629564305302,
      "durationDisplayRule" : "elapsedRowWindow",
      "durationSeconds" : 424.8278948068619,
      "elapsedDurationSeconds" : 424.8278948068619,
      "endOffsetSeconds" : 1687.7077269554138,
      "index" : 3,
      "label" : "Open \/ Extra",
      "maxHeartRateBpm" : 178,
      "paceSecondsPerKm" : 473.9462867794078,
      "plannedGoalDisplayText" : "Open",
      "plannedGoalType" : "open",
      "sourceNote" : "Extra tail after planned WorkoutKit steps",
      "startOffsetSeconds" : 1262.879832148552,
      "stepType" : "open",
      "tailDiagnostics" : {
        "creationReason" : "Remaining workout time or distance exceeded Open \/ Extra threshold after planned WorkoutKit steps.",
        "finalDistanceSampleCumulativeDistanceMeters" : 3906.5442879411858,
        "finalDistanceSampleOffsetSeconds" : 1682.246218085289,
        "lastCadenceSampleOffsetSeconds" : 1682.246218085289,
        "lastHeartRateSampleOffsetSeconds" : 1684.5779539346695,
        "lastPowerSampleOffsetSeconds" : 1682.246218085289,
        "plannedFinalStepEndOffsetSeconds" : 1262.879832148552,
        "remainingMeters" : 896.3629564305302,
        "remainingSeconds" : 424.8278948068619,
        "workoutEndOffsetSeconds" : 1687.7077269554138
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
      "averageHeartRateBpm" : 135.77631578947367,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1006.3268621715114,
      "durationSeconds" : 383.1021041870117,
      "endOffsetSeconds" : 383.1021041870117,
      "index" : 1,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 380.6935088270738,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 139.03252032520325,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1617.4698127977153,
      "durationSeconds" : 609.841292142868,
      "endOffsetSeconds" : 609.841292142868,
      "index" : 2,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 377.0341105087049,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 143.1315789473684,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1000.1010810490474,
      "durationSeconds" : 485.3341702222824,
      "endOffsetSeconds" : 868.4362744092941,
      "index" : 3,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 485.2851170935595,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 383.1021041870117
    },
    {
      "averageHeartRateBpm" : 142.07258064516128,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1607.84175284611,
      "durationSeconds" : 735.7372370958328,
      "endOffsetSeconds" : 1345.5785292387009,
      "index" : 4,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 457.5930658558111,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 609.841292142868
    },
    {
      "averageHeartRateBpm" : 142.21794871794873,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1000.1599495661319,
      "durationSeconds" : 392.8243898153305,
      "endOffsetSeconds" : 1261.2606642246246,
      "index" : 5,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 392.7615677729719,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 868.4362744092941
    },
    {
      "averageHeartRateBpm" : 143.52380952380952,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event is a raw HealthKit marker until interval parity is proven.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 899.9563951544951,
      "durationSeconds" : 423.5582811832428,
      "endOffsetSeconds" : 1684.8189454078674,
      "index" : 6,
      "label" : "unknown",
      "markerKind" : "rawSegmentMarker",
      "paceSecondsPerKm" : 470.6431150039561,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1261.2606642246246
    },
    {
      "averageHeartRateBpm" : 143.70149253731344,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only.",
        "Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.",
        "WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics."
      ],
      "confidence" : "limited",
      "distanceMeters" : 681.2327222973604,
      "durationSeconds" : 339.24041616916656,
      "endOffsetSeconds" : 1684.8189454078674,
      "index" : 7,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 497.9802130248919,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1345.5785292387009
    }
  ],
  "sourceNotes" : [
    "Plan source: WorkoutKit",
    "Window source: Plan-derived from HealthKit distance\/time samples",
    "Stats source: HealthKit samples",
    "HealthKit segment markers: not used",
    "Could not reconstruct Cooldown; missing usable distance evidence."
  ],
  "workout" : {
    "averageHeartRate" : 141.2815892440893,
    "averagePower" : 175.81260364842444,
    "cadenceSpm" : 163.01599409053208,
    "deviceName" : "Apple Watch Apple Inc. Watch",
    "distanceMeters" : 3906.5442879411858,
    "durationSeconds" : 1579.5032529830933,
    "elapsedSeconds" : 1687.7077269554138,
    "endDate" : "2026-06-29T13:00:00Z",
    "id" : "9C084DCE-3CCF-4401-8B99-CFB58EF0AC82",
    "maxHeartRate" : 178,
    "paceSecondsPerKm" : 404.3223720408704,
    "sourceID" : "9C084DCE-3CCF-4401-8B99-CFB58EF0AC82",
    "sourceName" : "Adriel’s Apple Watch",
    "startDate" : "2026-06-29T12:31:53Z"
  },
  "workoutActivities" : [
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 382.9695198535919,
      "durationSeconds" : 386.0734852552414,
      "endDate" : "2026-06-29T12:38:19Z",
      "endOffsetSeconds" : 386.0734852552414,
      "events" : [
        {
          "durationSeconds" : 383.1021041870117,
          "endDate" : "2026-06-29T12:38:16Z",
          "endOffsetSeconds" : 383.1021041870117,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1006.3268621715114,
          "renderedSegmentMarkerDurationSeconds" : 383.1021041870117,
          "renderedSegmentMarkerEndOffsetSeconds" : 383.1021041870117,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:31:53Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 609.841292142868,
          "endDate" : "2026-06-29T12:42:03Z",
          "endOffsetSeconds" : 609.841292142868,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1617.4698127977153,
          "renderedSegmentMarkerDurationSeconds" : 609.841292142868,
          "renderedSegmentMarkerEndOffsetSeconds" : 609.841292142868,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:31:53Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 485.3341702222824,
          "endDate" : "2026-06-29T12:46:21Z",
          "endOffsetSeconds" : 868.4362744092941,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1000.1010810490474,
          "renderedSegmentMarkerDurationSeconds" : 485.3341702222824,
          "renderedSegmentMarkerEndOffsetSeconds" : 868.4362744092941,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 383.1021041870117,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:38:16Z",
          "startOffsetSeconds" : 383.1021041870117,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "3 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "2D4F4DEF-0099-4CD8-8734-BB05669E6D13",
      "index" : 1,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -2.9713810682296753,
      "nearestRawEventEndOffsetSeconds" : 383.1021041870117,
      "nearestRawEventStartDeltaSeconds" : 0,
      "nearestRawEventStartOffsetSeconds" : 0,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -3.103965401649475,
      "nearestReconstructedIntervalEndOffsetSeconds" : 382.9695198535919,
      "nearestReconstructedIntervalIndex" : 1,
      "nearestReconstructedIntervalLabel" : "Warmup",
      "nearestSegmentMarkerEndDeltaSeconds" : -2.9713810682296753,
      "nearestSegmentMarkerEndOffsetSeconds" : 383.1021041870117,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : 0,
      "nearestSegmentMarkerStartOffsetSeconds" : 0,
      "nextDistanceSampleEndOffsetSeconds" : 385.54231309890747,
      "previousDistanceSampleEndOffsetSeconds" : 380.39672553539276,
      "startDate" : "2026-06-29T12:31:53Z",
      "startOffsetSeconds" : 0,
      "statistics" : [
        {
          "endDate" : "2026-06-29T12:38:19Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:31:53Z",
          "sum" : 61.606209165786176,
          "summary" : "ActiveEnergyBurned: sum 61.6 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-29T12:38:19Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:31:53Z",
          "sum" : 9.440952826099979,
          "summary" : "BasalEnergyBurned: sum 9.4 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-29T12:38:19Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:31:53Z",
          "sum" : 1007.4834852371379,
          "summary" : "DistanceWalkingRunning: sum 1007.5 m",
          "unit" : "m"
        },
        {
          "average" : 135.43107476635515,
          "endDate" : "2026-06-29T12:38:19Z",
          "maximum" : 146,
          "minimum" : 111,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:31:53Z",
          "summary" : "HeartRate: avg 135.4 bpm, min 111.0 bpm, max 146.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 275.4571428571429,
          "endDate" : "2026-06-29T12:38:19Z",
          "maximum" : 320,
          "minimum" : 263,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:31:53Z",
          "summary" : "RunningGroundContactTime: avg 275.5 ms, min 263.0 ms, max 320.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 187.68456375838923,
          "endDate" : "2026-06-29T12:38:19Z",
          "maximum" : 203,
          "minimum" : 57,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:31:53Z",
          "summary" : "RunningPower: avg 187.7 W, min 57.0 W, max 203.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.6511722204841766,
          "endDate" : "2026-06-29T12:38:19Z",
          "maximum" : 2.856124487332692,
          "minimum" : 0.8132813973939219,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:31:53Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 0.8 m\/s, max 2.9 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9061971830985917,
          "endDate" : "2026-06-29T12:38:19Z",
          "maximum" : 1.01,
          "minimum" : 0.82,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:31:53Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.8 m, max 1.0 m",
          "unit" : "m"
        },
        {
          "average" : 6.980281690140845,
          "endDate" : "2026-06-29T12:38:19Z",
          "maximum" : 8.4,
          "minimum" : 6.5,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:31:53Z",
          "summary" : "RunningVerticalOscillation: avg 7.0 cm, min 6.5 cm, max 8.4 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-29T12:38:19Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:31:53Z",
          "sum" : 1120.6516592043276,
          "summary" : "StepCount: sum 1120.7 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 61.6 kcal; BasalEnergyBurned: sum 9.4 kcal; DistanceWalkingRunning: sum 1007.5 m; HeartRate: avg 135.4 bpm, min 111.0 bpm, max 146.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1262.879832148552,
      "durationSeconds" : 460.45380675792694,
      "endDate" : "2026-06-29T12:47:47Z",
      "endOffsetSeconds" : 954.7317659854889,
      "events" : [
        {
          "durationSeconds" : 609.841292142868,
          "endDate" : "2026-06-29T12:42:03Z",
          "endOffsetSeconds" : 609.841292142868,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1617.4698127977153,
          "renderedSegmentMarkerDurationSeconds" : 609.841292142868,
          "renderedSegmentMarkerEndOffsetSeconds" : 609.841292142868,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:31:53Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 485.3341702222824,
          "endDate" : "2026-06-29T12:46:21Z",
          "endOffsetSeconds" : 868.4362744092941,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1000.1010810490474,
          "renderedSegmentMarkerDurationSeconds" : 485.3341702222824,
          "renderedSegmentMarkerEndOffsetSeconds" : 868.4362744092941,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 383.1021041870117,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:38:16Z",
          "startOffsetSeconds" : 383.1021041870117,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 735.7372370958328,
          "endDate" : "2026-06-29T12:54:18Z",
          "endOffsetSeconds" : 1345.5785292387009,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1607.84175284611,
          "renderedSegmentMarkerDurationSeconds" : 735.7372370958328,
          "renderedSegmentMarkerEndOffsetSeconds" : 1345.5785292387009,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 609.841292142868,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:42:03Z",
          "startOffsetSeconds" : 609.841292142868,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 0,
          "endDate" : "2026-06-29T12:43:18Z",
          "endOffsetSeconds" : 685.0017039775848,
          "excludedOrFilteredReason" : "zeroOrNegativeDuration",
          "index" : 4,
          "metadataKeys" : [

          ],
          "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
          "startDate" : "2026-06-29T12:43:18Z",
          "startOffsetSeconds" : 685.0017039775848,
          "type" : "HKWorkoutEventType(rawValue: 1)",
          "usedBySegmentMarkerRendering" : false
        },
        {
          "durationSeconds" : 0,
          "endDate" : "2026-06-29T12:45:06Z",
          "endOffsetSeconds" : 793.2061779499054,
          "excludedOrFilteredReason" : "zeroOrNegativeDuration",
          "index" : 5,
          "metadataKeys" : [

          ],
          "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
          "startDate" : "2026-06-29T12:45:06Z",
          "startOffsetSeconds" : 793.2061779499054,
          "type" : "HKWorkoutEventType(rawValue: 2)",
          "usedBySegmentMarkerRendering" : false
        },
        {
          "durationSeconds" : 392.8243898153305,
          "endDate" : "2026-06-29T12:52:54Z",
          "endOffsetSeconds" : 1261.2606642246246,
          "index" : 6,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1000.1599495661319,
          "renderedSegmentMarkerDurationSeconds" : 392.8243898153305,
          "renderedSegmentMarkerEndOffsetSeconds" : 1261.2606642246246,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 868.4362744092941,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:46:21Z",
          "startOffsetSeconds" : 868.4362744092941,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "6 event(s): HKWorkoutEventType(rawValue: 1), HKWorkoutEventType(rawValue: 2), HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "9B06F702-2A7E-4981-9E76-BA9B9DE73F70",
      "index" : 2,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath",
        "WOIntervalStepSuccessful"
      ],
      "nearestRawEventEndDeltaSeconds" : -86.29549157619476,
      "nearestRawEventEndOffsetSeconds" : 868.4362744092941,
      "nearestRawEventStartDeltaSeconds" : -2.9713810682296753,
      "nearestRawEventStartOffsetSeconds" : 383.1021041870117,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : 308.14806616306305,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1262.879832148552,
      "nearestReconstructedIntervalIndex" : 2,
      "nearestReconstructedIntervalLabel" : "Work 1",
      "nearestSegmentMarkerEndDeltaSeconds" : -86.29549157619476,
      "nearestSegmentMarkerEndOffsetSeconds" : 868.4362744092941,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -2.9713810682296753,
      "nearestSegmentMarkerStartOffsetSeconds" : 383.1021041870117,
      "nextDistanceSampleEndOffsetSeconds" : 1265.4525760412216,
      "previousDistanceSampleEndOffsetSeconds" : 1260.307086110115,
      "startDate" : "2026-06-29T12:38:19Z",
      "startOffsetSeconds" : 386.0734852552414,
      "statistics" : [
        {
          "endDate" : "2026-06-29T12:47:47Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:38:19Z",
          "sum" : 79.68643588386904,
          "summary" : "ActiveEnergyBurned: sum 79.7 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-29T12:47:47Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:38:19Z",
          "sum" : 11.2757003355706,
          "summary" : "BasalEnergyBurned: sum 11.3 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-29T12:47:47Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:38:19Z",
          "sum" : 1211.7571052208305,
          "summary" : "DistanceWalkingRunning: sum 1211.8 m",
          "unit" : "m"
        },
        {
          "average" : 142.41667727019936,
          "endDate" : "2026-06-29T12:47:47Z",
          "maximum" : 152,
          "minimum" : 126,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:38:19Z",
          "summary" : "HeartRate: avg 142.4 bpm, min 126.0 bpm, max 152.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 272.13749999999993,
          "endDate" : "2026-06-29T12:47:47Z",
          "maximum" : 295,
          "minimum" : 257,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:38:19Z",
          "summary" : "RunningGroundContactTime: avg 272.1 ms, min 257.0 ms, max 295.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 190.49152542372872,
          "endDate" : "2026-06-29T12:47:47Z",
          "maximum" : 220,
          "minimum" : 104,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:38:19Z",
          "summary" : "RunningPower: avg 190.5 W, min 104.0 W, max 220.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.6852365162727643,
          "endDate" : "2026-06-29T12:47:47Z",
          "maximum" : 3.1084996863517427,
          "minimum" : 1.6797804748331875,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:38:19Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 1.7 m\/s, max 3.1 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.9233333333333332,
          "endDate" : "2026-06-29T12:47:47Z",
          "maximum" : 0.97,
          "minimum" : 0.88,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:38:19Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.9 m, max 1.0 m",
          "unit" : "m"
        },
        {
          "average" : 6.987654320987655,
          "endDate" : "2026-06-29T12:47:47Z",
          "maximum" : 7.5,
          "minimum" : 6.6000000000000005,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:38:19Z",
          "summary" : "RunningVerticalOscillation: avg 7.0 cm, min 6.6 cm, max 7.5 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-29T12:47:47Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:38:19Z",
          "sum" : 1317.7158259576343,
          "summary" : "StepCount: sum 1317.7 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 79.7 kcal; BasalEnergyBurned: sum 11.3 kcal; DistanceWalkingRunning: sum 1211.8 m; HeartRate: avg 142.4 bpm, min 126.0 bpm, max 152.0 bpm"
    },
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 1262.879832148552,
      "durationSeconds" : 390.5984698534012,
      "endDate" : "2026-06-29T12:54:18Z",
      "endOffsetSeconds" : 1345.33023583889,
      "events" : [
        {
          "durationSeconds" : 735.7372370958328,
          "endDate" : "2026-06-29T12:54:18Z",
          "endOffsetSeconds" : 1345.5785292387009,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1607.84175284611,
          "renderedSegmentMarkerDurationSeconds" : 735.7372370958328,
          "renderedSegmentMarkerEndOffsetSeconds" : 1345.5785292387009,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 609.841292142868,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:42:03Z",
          "startOffsetSeconds" : 609.841292142868,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 392.8243898153305,
          "endDate" : "2026-06-29T12:52:54Z",
          "endOffsetSeconds" : 1261.2606642246246,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1000.1599495661319,
          "renderedSegmentMarkerDurationSeconds" : 392.8243898153305,
          "renderedSegmentMarkerEndOffsetSeconds" : 1261.2606642246246,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 868.4362744092941,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:46:21Z",
          "startOffsetSeconds" : 868.4362744092941,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 423.5582811832428,
          "endDate" : "2026-06-29T12:59:58Z",
          "endOffsetSeconds" : 1684.8189454078674,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 899.9563951544951,
          "renderedSegmentMarkerDurationSeconds" : 423.5582811832428,
          "renderedSegmentMarkerEndOffsetSeconds" : 1684.8189454078674,
          "renderedSegmentMarkerKind" : "rawSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1261.2606642246246,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-29T12:52:54Z",
          "startOffsetSeconds" : 1261.2606642246246,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "3 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "2D2C109C-B40D-47BC-8C66-092C0F7F5AC6",
      "index" : 3,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath"
      ],
      "nearestRawEventEndDeltaSeconds" : 0.24829339981079102,
      "nearestRawEventEndOffsetSeconds" : 1345.5785292387009,
      "nearestRawEventStartDeltaSeconds" : -86.29549157619476,
      "nearestRawEventStartOffsetSeconds" : 868.4362744092941,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -82.45040369033813,
      "nearestReconstructedIntervalEndOffsetSeconds" : 1262.879832148552,
      "nearestReconstructedIntervalIndex" : 2,
      "nearestReconstructedIntervalLabel" : "Work 1",
      "nearestSegmentMarkerEndDeltaSeconds" : 0.24829339981079102,
      "nearestSegmentMarkerEndOffsetSeconds" : 1345.5785292387009,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : -86.29549157619476,
      "nearestSegmentMarkerStartOffsetSeconds" : 868.4362744092941,
      "nextDistanceSampleEndOffsetSeconds" : 1265.4525760412216,
      "previousDistanceSampleEndOffsetSeconds" : 1260.307086110115,
      "startDate" : "2026-06-29T12:47:47Z",
      "startOffsetSeconds" : 954.7317659854889,
      "statistics" : [
        {
          "endDate" : "2026-06-29T12:54:18Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:47:47Z",
          "sum" : 69.09049199472108,
          "summary" : "ActiveEnergyBurned: sum 69.1 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-29T12:54:18Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:47:47Z",
          "sum" : 9.56463233219064,
          "summary" : "BasalEnergyBurned: sum 9.6 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-29T12:54:18Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:47:47Z",
          "sum" : 998.8098980472089,
          "summary" : "DistanceWalkingRunning: sum 998.8 m",
          "unit" : "m"
        },
        {
          "average" : 142.51752972457675,
          "endDate" : "2026-06-29T12:54:18Z",
          "maximum" : 146,
          "minimum" : 138,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:47:47Z",
          "summary" : "HeartRate: avg 142.5 bpm, min 138.0 bpm, max 146.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 279.513888888889,
          "endDate" : "2026-06-29T12:54:18Z",
          "maximum" : 304,
          "minimum" : 262,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:47:47Z",
          "summary" : "RunningGroundContactTime: avg 279.5 ms, min 262.0 ms, max 304.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 183.88157894736838,
          "endDate" : "2026-06-29T12:54:18Z",
          "maximum" : 200,
          "minimum" : 162,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:47:47Z",
          "summary" : "RunningPower: avg 183.9 W, min 162.0 W, max 200.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.579220939132315,
          "endDate" : "2026-06-29T12:54:18Z",
          "maximum" : 2.8243924144489636,
          "minimum" : 2.283171417251583,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:47:47Z",
          "summary" : "RunningSpeed: avg 2.6 m\/s, min 2.3 m\/s, max 2.8 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.8765277777777776,
          "endDate" : "2026-06-29T12:54:18Z",
          "maximum" : 0.98,
          "minimum" : 0.79,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:47:47Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.8 m, max 1.0 m",
          "unit" : "m"
        },
        {
          "average" : 7.022222222222222,
          "endDate" : "2026-06-29T12:54:18Z",
          "maximum" : 7.8,
          "minimum" : 6.7,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:47:47Z",
          "summary" : "RunningVerticalOscillation: avg 7.0 cm, min 6.7 cm, max 7.8 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-29T12:54:18Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-29T12:47:47Z",
          "sum" : 1108.0123147285121,
          "summary" : "StepCount: sum 1108.0 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 69.1 kcal; BasalEnergyBurned: sum 9.6 kcal; DistanceWalkingRunning: sum 998.8 m; HeartRate: avg 142.5 bpm, min 138.0 bpm, max 146.0 bpm"
    }
  ],
  "workoutKitPlanAudit" : {
    "displayName" : "Priority 5 (pause everything) ",
    "planID" : "56570A6C-3B7B-41D2-BCF8-4B9842914A16",
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
        "plannedGoalDisplayText" : "2 km",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 2000,
        "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
        "repeatBlockIndex" : 1,
        "repeatIndex" : 1,
        "stepType" : "work"
      },
      {
        "index" : 3,
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
      "Block 1 step 1: Work - goal 2 km, alert pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "Cooldown: goal 1 km, alert pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current"
    ]
  }
}
```