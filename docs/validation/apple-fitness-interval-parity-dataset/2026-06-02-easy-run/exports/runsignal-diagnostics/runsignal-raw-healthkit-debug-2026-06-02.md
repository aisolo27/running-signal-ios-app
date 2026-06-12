# RunSignal Raw HealthKit Debug Export

Generated: 2026-06-12T21:27:16Z

## Workout

| Field | Value |
|---|---|
| Workout ID | 298CF214-ADD6-4161-8DCC-0BC7F1F55A55 |
| Source | Adriel’s Apple Watch |
| Source ID | 298CF214-ADD6-4161-8DCC-0BC7F1F55A55 |
| Device | Apple Watch Apple Inc. Watch |
| Start | Jun 2, 2026 |
| End | Jun 2, 2026 |
| Duration | 36:43 |
| Elapsed | 36:43 |
| Distance | 5.71 km |
| Avg pace | 6:26 /km |
| Avg HR | 131 bpm |
| Max HR | 147 bpm |
| Cadence | 176 spm |
| Power | 189 W |

## Evidence Counts

| Metric | Count |
|---|---:|
| Heart rate | 441 |
| Speed | 854 |
| Distance | 854 |
| Active energy | 855 |
| Power | 854 |
| Cadence | 856 |
| Step count | 856 |
| Stride length | 405 |
| Vertical oscillation | 405 |
| Ground contact | 404 |
| Route points | 2203 |
| Events | 11 |
| Workout activities | 1 |

## WorkoutKit Plan Audit

- Status: Available
- Plan type: Custom workout
- Plan ID: 64073E58-E063-455E-B866-76A369213980
- Display name: Tuesday Easy 5.65km
- Activity: HKWorkoutActivityType(rawValue: 37)
- Warmup: none
- Block 1: 1x, 1 step(s)
- Block 1 step 1: Work - goal 5.65 km, alert heart rate zone 2
- Cooldown: none

## Raw HKWorkoutEvent Inventory

Debug-only inventory of public `HKWorkoutEvent` date windows and metadata keys. These rows are not Apple Fitness interval truth.

| Row | Event Type | Label | Start Offset | End Offset | Duration | Metadata Keys | Rendered Marker Window | Marker Distance | Marker Kind | Used By Segment Rendering | Excluded / Filtered Reason | Debug-Only Reason |
|---:|---|---|---:|---:|---:|---|---:|---:|---|---|---|---|
| 1 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 6:10 | 370.0 s | Unavailable | 0:00-6:10 | 1.01 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 2 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 9:59 | 598.9 s | Unavailable | 0:00-9:59 | 1.62 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 3 | HKWorkoutEventType(rawValue: 7) | Unavailable | 6:10 | 12:31 | 380.6 s | Unavailable | 6:10-12:31 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 4 | HKWorkoutEventType(rawValue: 7) | Unavailable | 9:59 | 20:26 | 626.7 s | Unavailable | 9:59-20:26 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 5 | HKWorkoutEventType(rawValue: 7) | Unavailable | 12:31 | 19:01 | 390.0 s | Unavailable | 12:31-19:01 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 6 | HKWorkoutEventType(rawValue: 7) | Unavailable | 19:01 | 25:29 | 388.2 s | Unavailable | 19:01-25:29 | 1.00 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 7 | HKWorkoutEventType(rawValue: 7) | Unavailable | 20:26 | 30:49 | 623.3 s | Unavailable | 20:26-30:49 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 8 | HKWorkoutEventType(rawValue: 7) | Unavailable | 25:29 | 31:56 | 387.3 s | Unavailable | 25:29-31:56 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 9 | HKWorkoutEventType(rawValue: 7) | Unavailable | 30:49 | 36:38 | 349.4 s | Unavailable | 30:49-36:38 | 0.87 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 10 | HKWorkoutEventType(rawValue: 7) | Unavailable | 31:56 | 36:38 | 282.2 s | Unavailable | 31:56-36:38 | 0.70 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 11 | HKWorkoutEventType(rawValue: 1) | Unavailable | 36:43 | 36:43 | 0.0 s | Unavailable | Unavailable | Unavailable | Unavailable | No | Excluded from segment rendering: zero or negative duration. | No rendered segment marker candidate. |

## HKWorkoutActivity Inventory

Debug-only inventory of public `HKWorkout.workoutActivities` rows. These rows are not used for production interval reconstruction.

| Activity | Type | Start Date | End Date | Start Offset | End Offset | Duration | Metadata Keys | Nested Events | Statistics | Aligns Planned Step | Aligned Planned Step | Nearest Reconstructed Row | Row End Delta | Apple Fitness/manual | FIT Lap | Raw Event Start | Raw Start Delta | Raw Event End | Raw End Delta | Segment Start | Segment Start Delta | Segment End | Segment End Delta | Previous Sample End | Crossing Sample End | Next Sample End |
|---:|---|---|---|---:|---:|---:|---|---|---|---|---|---|---:|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | HKWorkoutActivityType(rawValue: 37) | 2026-06-02T11:51:50Z | 2026-06-02T12:28:05Z | 0.0 s | 2174.8 s | 2174.8 s | HKElevationAscended, WOIntervalStepKeyPath | 10 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 347.9 kcal; BasalEnergyBurned: sum 53.3 kcal; DistanceWalkingRunning: sum 5651.2 m; HeartRate: avg 130.6 bpm, min 62.0 bpm, max 147.0 bpm | Yes | Work 1 | Work 1 | -2.2 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 0.0 s | 0.0 s | 2198.3 s | 23.5 s | 0.0 s | 0.0 s | 2198.3 s | 23.5 s | 2170.0 s | 2172.6 s | 2175.2 s |

## WorkoutKit Reconstructed Intervals

Planned structure source: WorkoutKit when available. Measured stats source: HealthKit samples.

| Row | Label | Goal | Target | Distance | Time | Pace | Avg HR | Max HR | Power | Start Offset | End Offset | Boundary Strategy | Boundary Adjustment | Overshoot | Confidence | Notes |
|---:|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---:|---:|---|---|
| 1 | Work 1 | 5.65 km | heart rate zone 2 | 5.65 km | 36:13 | 6:24 /km | 131 bpm | 147 bpm | 189 W | 0:00 | 36:13 | crossing sample end | 0.9 s | 1.9 m | High | Distance-goal boundary: crossing sample end, adjustment +0.9s, overshoot 1.9 m |
| 2 | Open / Extra | Open | Target unavailable | 0.06 km | 0:30 | 8:48 /km | 134 bpm | 137 bpm | 180 W | 36:13 | 36:43 |  |  |  | Medium | Extra tail after planned WorkoutKit steps |

Notes: Plan source: WorkoutKit · Window source: Plan-derived from HealthKit distance/time samples · Stats source: HealthKit samples · HealthKit segment markers: not used

## WorkoutKit Boundary Diagnostics

### Row 1: Work 1

| Field | Value |
|---|---:|
| Target distance | 5650.0 m |
| Start offset | 0:00 |
| End offset | 36:13 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 0.9 s |
| Overshoot | 1.9 m |
| Cumulative distance at start | 0.0 m |
| Cumulative distance at end | 5651.9 m |
| Interpolation fraction | 0.661 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 36:07 | 36:10 | 5639.8 m | 5646.4 m |
| Crossing | 36:10 | 36:13 | 5646.4 m | 5651.9 m |
| Next | 36:13 | 36:15 | 5651.9 m | 5659.1 m |

### Row 2: Open / Extra Tail

| Field | Value |
|---|---:|
| Planned final step end offset | 36:13 |
| Workout end offset | 36:43 |
| Remaining seconds | 30.1 s |
| Remaining meters | 57.0 m |
| Final distance sample offset | 36:36 |
| Final distance sample cumulative | 5708.9 m |
| Last HR sample offset | 36:43 |
| Last power sample offset | 36:38 |
| Last cadence sample offset | 36:41 |
| Reason | Remaining workout time or distance exceeded Open / Extra threshold after planned WorkoutKit steps. |

## HealthKit Segment Markers

Raw debug only. HealthKit Segment Markers must not be promoted as Apple Fitness interval rows.

| Row | Label | Marker Kind | Source | Distance | Time | Pace | Avg HR | Start Offset | End Offset | Confidence | Caveats |
|---:|---|---|---|---:|---:|---:|---:|---:|---:|---|---|
| 1 | Unknown | Split marker | HealthKit segment pattern | 1.01 km | 6:10 | 6:08 /km | 120 bpm | 0:00 | 6:10 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. |
| 2 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.62 km | 9:59 | 6:11 /km | 123 bpm | 0:00 | 9:59 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 3 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:21 | 6:21 /km | 130 bpm | 6:10 | 12:31 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 4 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 10:27 | 6:30 /km | 132 bpm | 9:59 | 20:26 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 5 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:30 | 6:30 /km | 131 bpm | 12:31 | 19:01 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 6 | Unknown | Split marker | HealthKit segment pattern | 1.00 km | 6:28 | 6:28 /km | 134 bpm | 19:01 | 25:29 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. |
| 7 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 10:23 | 6:27 /km | 136 bpm | 20:26 | 30:49 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 8 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:27 | 6:28 /km | 137 bpm | 25:29 | 31:56 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 9 | Unknown | Overlapping segment marker | HealthKit segment pattern | 0.87 km | 5:49 | 6:40 /km | 136 bpm | 30:49 | 36:38 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 10 | Unknown | Overlapping segment marker | HealthKit segment pattern | 0.70 km | 4:42 | 6:41 /km | 136 bpm | 31:56 | 36:38 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |

## Planned Step Boundary Comparison

Debug-only comparison helper for FIT/Apple boundary investigation. The FIT lap end offset is intentionally a manual placeholder; RunSignal does not read FIT at runtime.

| Row | Planned Step | Goal | RunSignal End | FIT Lap End | Nearest Raw Event End | Event Delta | Nearest Activity End | Activity Delta | Activity Type | Nearest Segment End | Segment Delta | Previous Sample End | Crossing Sample End | Next Sample End | Warning |
|---:|---|---|---:|---:|---:|---:|---:|---:|---|---:|---:|---:|---:|---:|---|
| 1 | Work 1 | 5.65 km | 2172.6 s | Manual FIT placeholder | 2198.3 s | 25.7 s | 2174.8 s | 2.2 s | HKWorkoutActivityType(rawValue: 37) | 2198.3 s | 25.7 s | 2170.0 s | 2172.6 s | 2175.2 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 2 | Open / Extra | Open | 2202.7 s | Manual FIT placeholder | 2198.3 s | -4.4 s | 2174.8 s | -27.8 s | HKWorkoutActivityType(rawValue: 37) | 2198.3 s | -4.4 s | Unavailable | Unavailable | Unavailable | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |

## Boundary Source Warnings

- One or more raw HKWorkoutEvent records have unavailable metadata keys.
- FIT lap end offsets are not read by RunSignal; compare them manually after physical-device export.
- Apple Fitness/manual row offsets are not read by RunSignal; compare HKWorkoutActivity timing manually after physical-device export.

## Evidence Caveats

- None

## JSON Payload

```json
{
  "boundaryDiagnostics" : [
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 5651.865399219561,
          "endDate" : "2026-06-02T12:28:03Z",
          "endOffsetSeconds" : 2172.5804797410965,
          "startCumulativeDistanceMeters" : 5646.356947398512,
          "startDate" : "2026-06-02T12:28:00Z",
          "startOffsetSeconds" : 2170.007947564125
        },
        "cumulativeDistanceAtEndMeters" : 5651.865399219561,
        "cumulativeDistanceAtStartMeters" : 0,
        "interpolationFraction" : 0.6613568966087638,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 5659.131705024745,
          "endDate" : "2026-06-02T12:28:05Z",
          "endOffsetSeconds" : 2175.153011083603,
          "startCumulativeDistanceMeters" : 5651.865399219561,
          "startDate" : "2026-06-02T12:28:03Z",
          "startOffsetSeconds" : 2172.5804797410965
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 5646.356947398512,
          "endDate" : "2026-06-02T12:28:00Z",
          "endOffsetSeconds" : 2170.007947564125,
          "startCumulativeDistanceMeters" : 5639.782603667118,
          "startDate" : "2026-06-02T12:27:58Z",
          "startOffsetSeconds" : 2167.435415506363
        },
        "targetDistanceMeters" : 5650
      },
      "index" : 1,
      "label" : "Work 1"
    },
    {
      "index" : 2,
      "label" : "Open \/ Extra",
      "tail" : {
        "creationReason" : "Remaining workout time or distance exceeded Open \/ Extra threshold after planned WorkoutKit steps.",
        "finalDistanceSampleCumulativeDistanceMeters" : 5708.88059842051,
        "finalDistanceSampleOffsetSeconds" : 2195.73328602314,
        "lastCadenceSampleOffsetSeconds" : 2200.878359556198,
        "lastHeartRateSampleOffsetSeconds" : 2202.592178940773,
        "lastPowerSampleOffsetSeconds" : 2198.3058240413666,
        "plannedFinalStepEndOffsetSeconds" : 2172.5804797410965,
        "remainingMeters" : 57.0151992009487,
        "remainingSeconds" : 30.089375257492065,
        "workoutEndOffsetSeconds" : 2202.6698549985886
      }
    }
  ],
  "boundarySourceWarnings" : [
    "One or more raw HKWorkoutEvent records have unavailable metadata keys.",
    "FIT lap end offsets are not read by RunSignal; compare them manually after physical-device export.",
    "Apple Fitness\/manual row offsets are not read by RunSignal; compare HKWorkoutActivity timing manually after physical-device export."
  ],
  "caveats" : [

  ],
  "evidenceCounts" : {
    "activeEnergy" : 855,
    "activities" : 1,
    "cadence" : 856,
    "distance" : 854,
    "events" : 11,
    "groundContact" : 404,
    "heartRate" : 441,
    "power" : 854,
    "routePoints" : 2203,
    "speed" : 854,
    "stepCount" : 856,
    "strideLength" : 405,
    "verticalOscillation" : 405
  },
  "generatedAt" : "2026-06-12T21:27:16Z",
  "plannedStepBoundaryComparisons" : [
    {
      "crossingDistanceSampleEndOffsetSeconds" : 2172.5804797410965,
      "index" : 1,
      "nearestRawEventEndDeltaSeconds" : 25.72534430027008,
      "nearestRawEventEndOffsetSeconds" : 2198.3058240413666,
      "nearestRawEventStartOffsetSeconds" : 1848.884808421135,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 25.72534430027008,
      "nearestSegmentMarkerEndOffsetSeconds" : 2198.3058240413666,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1848.884808421135,
      "nearestWorkoutActivityEndDeltaSeconds" : 2.2456982135772705,
      "nearestWorkoutActivityEndOffsetSeconds" : 2174.8261779546738,
      "nearestWorkoutActivityStartOffsetSeconds" : 0,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 2175.153011083603,
      "plannedGoalDisplayText" : "5.65 km",
      "plannedStepLabel" : "Work 1",
      "previousDistanceSampleEndOffsetSeconds" : 2170.007947564125,
      "reconstructedEndOffsetSeconds" : 2172.5804797410965,
      "reconstructedLabel" : "Work 1",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "index" : 2,
      "nearestRawEventEndDeltaSeconds" : -4.364030957221985,
      "nearestRawEventEndOffsetSeconds" : 2198.3058240413666,
      "nearestRawEventStartOffsetSeconds" : 1848.884808421135,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -4.364030957221985,
      "nearestSegmentMarkerEndOffsetSeconds" : 2198.3058240413666,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1848.884808421135,
      "nearestWorkoutActivityEndDeltaSeconds" : -27.843677043914795,
      "nearestWorkoutActivityEndOffsetSeconds" : 2174.8261779546738,
      "nearestWorkoutActivityStartOffsetSeconds" : 0,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "plannedGoalDisplayText" : "Open",
      "reconstructedEndOffsetSeconds" : 2202.6698549985886,
      "reconstructedLabel" : "Open \/ Extra",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    }
  ],
  "rawWorkoutEvents" : [
    {
      "durationSeconds" : 369.99872374534607,
      "endDate" : "2026-06-02T11:58:00Z",
      "endOffsetSeconds" : 369.99872374534607,
      "index" : 1,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1006.078092119742,
      "renderedSegmentMarkerDurationSeconds" : 369.99872374534607,
      "renderedSegmentMarkerEndOffsetSeconds" : 369.99872374534607,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-02T11:51:50Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 598.8872522115707,
      "endDate" : "2026-06-02T12:01:49Z",
      "endOffsetSeconds" : 598.8872522115707,
      "index" : 2,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1616.176964379544,
      "renderedSegmentMarkerDurationSeconds" : 598.8872522115707,
      "renderedSegmentMarkerEndOffsetSeconds" : 598.8872522115707,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-02T11:51:50Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 380.5730197429657,
      "endDate" : "2026-06-02T12:04:21Z",
      "endOffsetSeconds" : 750.5717434883118,
      "index" : 3,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1000.0552561246654,
      "renderedSegmentMarkerDurationSeconds" : 380.5730197429657,
      "renderedSegmentMarkerEndOffsetSeconds" : 750.5717434883118,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 369.99872374534607,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-02T11:58:00Z",
      "startOffsetSeconds" : 369.99872374534607,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 626.6695135831833,
      "endDate" : "2026-06-02T12:12:16Z",
      "endOffsetSeconds" : 1225.556765794754,
      "index" : 4,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1608.6082796858097,
      "renderedSegmentMarkerDurationSeconds" : 626.6695135831833,
      "renderedSegmentMarkerEndOffsetSeconds" : 1225.556765794754,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 598.8872522115707,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-02T12:01:49Z",
      "startOffsetSeconds" : 598.8872522115707,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 389.99895799160004,
      "endDate" : "2026-06-02T12:10:51Z",
      "endOffsetSeconds" : 1140.5707014799118,
      "index" : 5,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1000.459475710722,
      "renderedSegmentMarkerDurationSeconds" : 389.99895799160004,
      "renderedSegmentMarkerEndOffsetSeconds" : 1140.5707014799118,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 750.5717434883118,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-02T12:04:21Z",
      "startOffsetSeconds" : 750.5717434883118,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 388.2198199033737,
      "endDate" : "2026-06-02T12:17:19Z",
      "endOffsetSeconds" : 1528.7905213832855,
      "index" : 6,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1001.5468672855104,
      "renderedSegmentMarkerDurationSeconds" : 388.2198199033737,
      "renderedSegmentMarkerEndOffsetSeconds" : 1528.7905213832855,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1140.5707014799118,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-02T12:10:51Z",
      "startOffsetSeconds" : 1140.5707014799118,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 623.3280426263809,
      "endDate" : "2026-06-02T12:22:39Z",
      "endOffsetSeconds" : 1848.884808421135,
      "index" : 7,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1609.6159877253717,
      "renderedSegmentMarkerDurationSeconds" : 623.3280426263809,
      "renderedSegmentMarkerEndOffsetSeconds" : 1848.884808421135,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1225.556765794754,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-02T12:12:16Z",
      "startOffsetSeconds" : 1225.556765794754,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 387.2731543779373,
      "endDate" : "2026-06-02T12:23:46Z",
      "endOffsetSeconds" : 1916.0636757612228,
      "index" : 8,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 997.714994237007,
      "renderedSegmentMarkerDurationSeconds" : 387.2731543779373,
      "renderedSegmentMarkerEndOffsetSeconds" : 1916.0636757612228,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1528.7905213832855,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-02T12:17:19Z",
      "startOffsetSeconds" : 1528.7905213832855,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 349.4210156202316,
      "endDate" : "2026-06-02T12:28:29Z",
      "endOffsetSeconds" : 2198.3058240413666,
      "index" : 9,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 874.4793666297846,
      "renderedSegmentMarkerDurationSeconds" : 349.4210156202316,
      "renderedSegmentMarkerEndOffsetSeconds" : 2198.3058240413666,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1848.884808421135,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-02T12:22:39Z",
      "startOffsetSeconds" : 1848.884808421135,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 282.24214828014374,
      "endDate" : "2026-06-02T12:28:29Z",
      "endOffsetSeconds" : 2198.3058240413666,
      "index" : 10,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 703.0259129428632,
      "renderedSegmentMarkerDurationSeconds" : 282.24214828014374,
      "renderedSegmentMarkerEndOffsetSeconds" : 2198.3058240413666,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1916.0636757612228,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-02T12:23:46Z",
      "startOffsetSeconds" : 1916.0636757612228,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 0,
      "endDate" : "2026-06-02T12:28:33Z",
      "endOffsetSeconds" : 2202.6698549985886,
      "excludedOrFilteredReason" : "zeroOrNegativeDuration",
      "index" : 11,
      "metadataKeys" : [

      ],
      "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
      "startDate" : "2026-06-02T12:28:33Z",
      "startOffsetSeconds" : 2202.6698549985886,
      "type" : "HKWorkoutEventType(rawValue: 1)",
      "usedBySegmentMarkerRendering" : false
    }
  ],
  "reconstructedIntervals" : [
    {
      "averageHeartRateBpm" : 131.2258064516129,
      "averagePower" : 188.79715302491104,
      "boundaryAdjustmentSeconds" : 0.8711702823638916,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 5651.865399219561,
          "endDate" : "2026-06-02T12:28:03Z",
          "endOffsetSeconds" : 2172.5804797410965,
          "startCumulativeDistanceMeters" : 5646.356947398512,
          "startDate" : "2026-06-02T12:28:00Z",
          "startOffsetSeconds" : 2170.007947564125
        },
        "cumulativeDistanceAtEndMeters" : 5651.865399219561,
        "cumulativeDistanceAtStartMeters" : 0,
        "interpolationFraction" : 0.6613568966087638,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 5659.131705024745,
          "endDate" : "2026-06-02T12:28:05Z",
          "endOffsetSeconds" : 2175.153011083603,
          "startCumulativeDistanceMeters" : 5651.865399219561,
          "startDate" : "2026-06-02T12:28:03Z",
          "startOffsetSeconds" : 2172.5804797410965
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 5646.356947398512,
          "endDate" : "2026-06-02T12:28:00Z",
          "endOffsetSeconds" : 2170.007947564125,
          "startCumulativeDistanceMeters" : 5639.782603667118,
          "startDate" : "2026-06-02T12:27:58Z",
          "startOffsetSeconds" : 2167.435415506363
        },
        "targetDistanceMeters" : 5650
      },
      "boundaryOvershootMeters" : 1.8653992195613682,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "distanceMeters" : 5651.865399219561,
      "durationSeconds" : 2172.5804797410965,
      "endOffsetSeconds" : 2172.5804797410965,
      "index" : 1,
      "label" : "Work 1",
      "maxHeartRateBpm" : 147,
      "paceSecondsPerKm" : 384.4006051596872,
      "plannedGoalDisplayText" : "5.65 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 5650,
      "plannedTargetDisplayText" : "heart rate zone 2",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +0.9s, overshoot 1.9 m",
      "startOffsetSeconds" : 0,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 133.71428571428572,
      "averagePower" : 179.8181818181818,
      "confidence" : "medium",
      "distanceMeters" : 57.0151992009487,
      "durationSeconds" : 30.089375257492065,
      "endOffsetSeconds" : 2202.6698549985886,
      "index" : 2,
      "label" : "Open \/ Extra",
      "maxHeartRateBpm" : 137,
      "paceSecondsPerKm" : 527.743052364735,
      "plannedGoalDisplayText" : "Open",
      "plannedGoalType" : "open",
      "sourceNote" : "Extra tail after planned WorkoutKit steps",
      "startOffsetSeconds" : 2172.5804797410965,
      "stepType" : "open",
      "tailDiagnostics" : {
        "creationReason" : "Remaining workout time or distance exceeded Open \/ Extra threshold after planned WorkoutKit steps.",
        "finalDistanceSampleCumulativeDistanceMeters" : 5708.88059842051,
        "finalDistanceSampleOffsetSeconds" : 2195.73328602314,
        "lastCadenceSampleOffsetSeconds" : 2200.878359556198,
        "lastHeartRateSampleOffsetSeconds" : 2202.592178940773,
        "lastPowerSampleOffsetSeconds" : 2198.3058240413666,
        "plannedFinalStepEndOffsetSeconds" : 2172.5804797410965,
        "remainingMeters" : 57.0151992009487,
        "remainingSeconds" : 30.089375257492065,
        "workoutEndOffsetSeconds" : 2202.6698549985886
      }
    }
  ],
  "segmentMarkers" : [
    {
      "averageHeartRateBpm" : 119.5,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1006.078092119742,
      "durationSeconds" : 369.99872374534607,
      "endOffsetSeconds" : 369.99872374534607,
      "index" : 1,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 367.76342377735557,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 123.14166666666667,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1616.176964379544,
      "durationSeconds" : 598.8872522115707,
      "endOffsetSeconds" : 598.8872522115707,
      "index" : 2,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 370.5579682244052,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 129.97368421052633,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1000.0552561246654,
      "durationSeconds" : 380.5730197429657,
      "endOffsetSeconds" : 750.5717434883118,
      "index" : 3,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 380.5519919146588,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 369.99872374534607
    },
    {
      "averageHeartRateBpm" : 131.592,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1608.6082796858097,
      "durationSeconds" : 626.6695135831833,
      "endOffsetSeconds" : 1225.556765794754,
      "index" : 4,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 389.57247795938434,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 598.8872522115707
    },
    {
      "averageHeartRateBpm" : 131.3846153846154,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1000.459475710722,
      "durationSeconds" : 389.99895799160004,
      "endOffsetSeconds" : 1140.5707014799118,
      "index" : 5,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 389.8198452411543,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 750.5717434883118
    },
    {
      "averageHeartRateBpm" : 133.92207792207793,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1001.5468672855104,
      "durationSeconds" : 388.2198199033737,
      "endOffsetSeconds" : 1528.7905213832855,
      "index" : 6,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 387.6202228614271,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1140.5707014799118
    },
    {
      "averageHeartRateBpm" : 135.83870967741936,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1609.6159877253717,
      "durationSeconds" : 623.3280426263809,
      "endOffsetSeconds" : 1848.884808421135,
      "index" : 7,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 387.25264123850855,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1225.556765794754
    },
    {
      "averageHeartRateBpm" : 137.26923076923077,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 997.714994237007,
      "durationSeconds" : 387.2731543779373,
      "endOffsetSeconds" : 1916.0636757612228,
      "index" : 8,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 388.16010244899724,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1528.7905213832855
    },
    {
      "averageHeartRateBpm" : 136.3943661971831,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 874.4793666297846,
      "durationSeconds" : 349.4210156202316,
      "endOffsetSeconds" : 2198.3058240413666,
      "index" : 9,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 399.5760551411167,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1848.884808421135
    },
    {
      "averageHeartRateBpm" : 136.24561403508773,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 703.0259129428632,
      "durationSeconds" : 282.24214828014374,
      "endOffsetSeconds" : 2198.3058240413666,
      "index" : 10,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 401.4676316818528,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1916.0636757612228
    }
  ],
  "sourceNotes" : [
    "Plan source: WorkoutKit",
    "Window source: Plan-derived from HealthKit distance\/time samples",
    "Stats source: HealthKit samples",
    "HealthKit segment markers: not used"
  ],
  "workout" : {
    "averageHeartRate" : 131.2882882882883,
    "averagePower" : 188.68149882903987,
    "cadenceSpm" : 175.5514041007125,
    "deviceName" : "Apple Watch Apple Inc. Watch",
    "distanceMeters" : 5708.880598420509,
    "durationSeconds" : 2202.6698549985886,
    "elapsedSeconds" : 2202.6698549985886,
    "endDate" : "2026-06-02T12:28:33Z",
    "id" : "298CF214-ADD6-4161-8DCC-0BC7F1F55A55",
    "maxHeartRate" : 147,
    "paceSecondsPerKm" : 385.83218146268587,
    "sourceID" : "298CF214-ADD6-4161-8DCC-0BC7F1F55A55",
    "sourceName" : "Adriel’s Apple Watch",
    "startDate" : "2026-06-02T11:51:50Z"
  },
  "workoutActivities" : [
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 1,
      "alignedPlannedStepLabel" : "Work 1",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 2172.5804797410965,
      "durationSeconds" : 2174.8261779546738,
      "endDate" : "2026-06-02T12:28:05Z",
      "endOffsetSeconds" : 2174.8261779546738,
      "events" : [
        {
          "durationSeconds" : 369.99872374534607,
          "endDate" : "2026-06-02T11:58:00Z",
          "endOffsetSeconds" : 369.99872374534607,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1006.078092119742,
          "renderedSegmentMarkerDurationSeconds" : 369.99872374534607,
          "renderedSegmentMarkerEndOffsetSeconds" : 369.99872374534607,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-02T11:51:50Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 598.8872522115707,
          "endDate" : "2026-06-02T12:01:49Z",
          "endOffsetSeconds" : 598.8872522115707,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1616.176964379544,
          "renderedSegmentMarkerDurationSeconds" : 598.8872522115707,
          "renderedSegmentMarkerEndOffsetSeconds" : 598.8872522115707,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-02T11:51:50Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 380.5730197429657,
          "endDate" : "2026-06-02T12:04:21Z",
          "endOffsetSeconds" : 750.5717434883118,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1000.0552561246654,
          "renderedSegmentMarkerDurationSeconds" : 380.5730197429657,
          "renderedSegmentMarkerEndOffsetSeconds" : 750.5717434883118,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 369.99872374534607,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-02T11:58:00Z",
          "startOffsetSeconds" : 369.99872374534607,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 626.6695135831833,
          "endDate" : "2026-06-02T12:12:16Z",
          "endOffsetSeconds" : 1225.556765794754,
          "index" : 4,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1608.6082796858097,
          "renderedSegmentMarkerDurationSeconds" : 626.6695135831833,
          "renderedSegmentMarkerEndOffsetSeconds" : 1225.556765794754,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 598.8872522115707,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-02T12:01:49Z",
          "startOffsetSeconds" : 598.8872522115707,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 389.99895799160004,
          "endDate" : "2026-06-02T12:10:51Z",
          "endOffsetSeconds" : 1140.5707014799118,
          "index" : 5,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1000.459475710722,
          "renderedSegmentMarkerDurationSeconds" : 389.99895799160004,
          "renderedSegmentMarkerEndOffsetSeconds" : 1140.5707014799118,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 750.5717434883118,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-02T12:04:21Z",
          "startOffsetSeconds" : 750.5717434883118,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 388.2198199033737,
          "endDate" : "2026-06-02T12:17:19Z",
          "endOffsetSeconds" : 1528.7905213832855,
          "index" : 6,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1001.5468672855104,
          "renderedSegmentMarkerDurationSeconds" : 388.2198199033737,
          "renderedSegmentMarkerEndOffsetSeconds" : 1528.7905213832855,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1140.5707014799118,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-02T12:10:51Z",
          "startOffsetSeconds" : 1140.5707014799118,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 623.3280426263809,
          "endDate" : "2026-06-02T12:22:39Z",
          "endOffsetSeconds" : 1848.884808421135,
          "index" : 7,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1609.6159877253717,
          "renderedSegmentMarkerDurationSeconds" : 623.3280426263809,
          "renderedSegmentMarkerEndOffsetSeconds" : 1848.884808421135,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1225.556765794754,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-02T12:12:16Z",
          "startOffsetSeconds" : 1225.556765794754,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 387.2731543779373,
          "endDate" : "2026-06-02T12:23:46Z",
          "endOffsetSeconds" : 1916.0636757612228,
          "index" : 8,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 997.714994237007,
          "renderedSegmentMarkerDurationSeconds" : 387.2731543779373,
          "renderedSegmentMarkerEndOffsetSeconds" : 1916.0636757612228,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1528.7905213832855,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-02T12:17:19Z",
          "startOffsetSeconds" : 1528.7905213832855,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 349.4210156202316,
          "endDate" : "2026-06-02T12:28:29Z",
          "endOffsetSeconds" : 2198.3058240413666,
          "index" : 9,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 874.4793666297846,
          "renderedSegmentMarkerDurationSeconds" : 349.4210156202316,
          "renderedSegmentMarkerEndOffsetSeconds" : 2198.3058240413666,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1848.884808421135,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-02T12:22:39Z",
          "startOffsetSeconds" : 1848.884808421135,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 282.24214828014374,
          "endDate" : "2026-06-02T12:28:29Z",
          "endOffsetSeconds" : 2198.3058240413666,
          "index" : 10,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 703.0259129428632,
          "renderedSegmentMarkerDurationSeconds" : 282.24214828014374,
          "renderedSegmentMarkerEndOffsetSeconds" : 2198.3058240413666,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1916.0636757612228,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-02T12:23:46Z",
          "startOffsetSeconds" : 1916.0636757612228,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "10 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "7A3910DA-A2AF-4BDA-9B37-18E5C8C927F6",
      "index" : 1,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath"
      ],
      "nearestRawEventEndDeltaSeconds" : 23.47964608669281,
      "nearestRawEventEndOffsetSeconds" : 2198.3058240413666,
      "nearestRawEventStartDeltaSeconds" : 0,
      "nearestRawEventStartOffsetSeconds" : 0,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -2.2456982135772705,
      "nearestReconstructedIntervalEndOffsetSeconds" : 2172.5804797410965,
      "nearestReconstructedIntervalIndex" : 1,
      "nearestReconstructedIntervalLabel" : "Work 1",
      "nearestSegmentMarkerEndDeltaSeconds" : 23.47964608669281,
      "nearestSegmentMarkerEndOffsetSeconds" : 2198.3058240413666,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : 0,
      "nearestSegmentMarkerStartOffsetSeconds" : 0,
      "nextDistanceSampleEndOffsetSeconds" : 2175.153011083603,
      "previousDistanceSampleEndOffsetSeconds" : 2170.007947564125,
      "startDate" : "2026-06-02T11:51:50Z",
      "startOffsetSeconds" : 0,
      "statistics" : [
        {
          "endDate" : "2026-06-02T12:28:05Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-02T11:51:50Z",
          "sum" : 347.8979066059512,
          "summary" : "ActiveEnergyBurned: sum 347.9 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-02T12:28:05Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-02T11:51:50Z",
          "sum" : 53.260320762225554,
          "summary" : "BasalEnergyBurned: sum 53.3 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-02T12:28:05Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-02T11:51:50Z",
          "sum" : 5651.165565357682,
          "summary" : "DistanceWalkingRunning: sum 5651.2 m",
          "unit" : "m"
        },
        {
          "average" : 130.60757780784843,
          "endDate" : "2026-06-02T12:28:05Z",
          "maximum" : 147,
          "minimum" : 61.99999999999999,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-02T11:51:50Z",
          "summary" : "HeartRate: avg 130.6 bpm, min 62.0 bpm, max 147.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 266.8424999999998,
          "endDate" : "2026-06-02T12:28:05Z",
          "maximum" : 292,
          "minimum" : 233,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-02T11:51:50Z",
          "summary" : "RunningGroundContactTime: avg 266.8 ms, min 233.0 ms, max 292.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 188.7902843601896,
          "endDate" : "2026-06-02T12:28:05Z",
          "maximum" : 216,
          "minimum" : 126,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-02T11:51:50Z",
          "summary" : "RunningPower: avg 188.8 W, min 126.0 W, max 216.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.6607638670994196,
          "endDate" : "2026-06-02T12:28:05Z",
          "maximum" : 3.035511808002889,
          "minimum" : 1.99657952414113,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-02T11:51:50Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 2.0 m\/s, max 3.0 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.8965087281795516,
          "endDate" : "2026-06-02T12:28:05Z",
          "maximum" : 1,
          "minimum" : 0.84,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-02T11:51:50Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.8 m, max 1.0 m",
          "unit" : "m"
        },
        {
          "average" : 7.8290322580645135,
          "endDate" : "2026-06-02T12:28:05Z",
          "maximum" : 8.5,
          "minimum" : 7.199999999999999,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-02T11:51:50Z",
          "summary" : "RunningVerticalOscillation: avg 7.8 cm, min 7.2 cm, max 8.5 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-02T12:28:05Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-02T11:51:50Z",
          "sum" : 6364.110668987893,
          "summary" : "StepCount: sum 6364.1 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 347.9 kcal; BasalEnergyBurned: sum 53.3 kcal; DistanceWalkingRunning: sum 5651.2 m; HeartRate: avg 130.6 bpm, min 62.0 bpm, max 147.0 bpm"
    }
  ],
  "workoutKitPlanAudit" : {
    "displayName" : "Tuesday Easy 5.65km",
    "planID" : "64073E58-E063-455E-B866-76A369213980",
    "planType" : "Custom workout",
    "plannedSteps" : [
      {
        "index" : 1,
        "label" : "Work 1",
        "plannedGoalDisplayText" : "5.65 km",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 5650,
        "plannedTargetDisplayText" : "heart rate zone 2",
        "repeatBlockIndex" : 1,
        "repeatIndex" : 1,
        "stepType" : "work"
      }
    ],
    "status" : "available",
    "summaryLines" : [
      "Activity: HKWorkoutActivityType(rawValue: 37)",
      "Warmup: none",
      "Block 1: 1x, 1 step(s)",
      "Block 1 step 1: Work - goal 5.65 km, alert heart rate zone 2",
      "Cooldown: none"
    ]
  }
}
```