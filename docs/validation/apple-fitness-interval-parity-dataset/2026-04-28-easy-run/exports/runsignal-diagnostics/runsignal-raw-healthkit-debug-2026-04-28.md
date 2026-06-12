# RunSignal Raw HealthKit Debug Export

Generated: 2026-06-12T19:50:30Z

## Workout

| Field | Value |
|---|---|
| Workout ID | 9AD88333-024B-4476-B81F-7D15A8E0FC89 |
| Source | Adriel’s Apple Watch |
| Source ID | 9AD88333-024B-4476-B81F-7D15A8E0FC89 |
| Device | Apple Watch Apple Inc. Watch |
| Start | Apr 28, 2026 |
| End | Apr 28, 2026 |
| Duration | 46:32 |
| Elapsed | 46:32 |
| Distance | 7.30 km |
| Avg pace | 6:22 /km |
| Avg HR | 133 bpm |
| Max HR | 145 bpm |
| Cadence | 175 spm |
| Power | 192 W |

## Evidence Counts

| Metric | Count |
|---|---:|
| Heart rate | 554 |
| Speed | 1083 |
| Distance | 1082 |
| Active energy | 1085 |
| Power | 1083 |
| Cadence | 1083 |
| Step count | 1083 |
| Stride length | 513 |
| Vertical oscillation | 512 |
| Ground contact | 512 |
| Route points | 2792 |
| Events | 14 |

## WorkoutKit Plan Audit

- Status: Available
- Plan type: Custom workout
- Plan ID: 64073E58-E063-455E-B866-76A369213980
- Display name: Tuesday Easy 7.25km
- Activity: HKWorkoutActivityType(rawValue: 37)
- Warmup: none
- Block 1: 1x, 1 step(s)
- Block 1 step 1: Work - goal 7.25 km, alert pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current
- Cooldown: none

## Raw HKWorkoutEvent Inventory

Debug-only inventory of public `HKWorkoutEvent` date windows and metadata keys. These rows are not Apple Fitness interval truth.

| Row | Event Type | Label | Start Offset | End Offset | Duration | Metadata Keys | Rendered Marker Window | Marker Distance | Marker Kind | Used By Segment Rendering | Excluded / Filtered Reason | Debug-Only Reason |
|---:|---|---|---:|---:|---:|---|---:|---:|---|---|---|---|
| 1 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 6:30 | 390.0 s | Unavailable | 0:00-6:30 | 1.01 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 2 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 10:29 | 629.2 s | Unavailable | 0:00-10:29 | 1.62 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 3 | HKWorkoutEventType(rawValue: 7) | Unavailable | 6:30 | 12:58 | 387.7 s | Unavailable | 6:30-12:58 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 4 | HKWorkoutEventType(rawValue: 7) | Unavailable | 10:29 | 20:42 | 613.0 s | Unavailable | 10:29-20:42 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 5 | HKWorkoutEventType(rawValue: 7) | Unavailable | 12:58 | 19:17 | 379.4 s | Unavailable | 12:58-19:17 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 6 | HKWorkoutEventType(rawValue: 7) | Unavailable | 19:17 | 25:40 | 382.7 s | Unavailable | 19:17-25:40 | 1.00 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 7 | HKWorkoutEventType(rawValue: 7) | Unavailable | 20:42 | 30:48 | 605.9 s | Unavailable | 20:42-30:48 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 8 | HKWorkoutEventType(rawValue: 7) | Unavailable | 25:40 | 31:53 | 372.7 s | Unavailable | 25:40-31:53 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 9 | HKWorkoutEventType(rawValue: 7) | Unavailable | 30:48 | 41:01 | 612.4 s | Unavailable | 30:48-41:01 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 10 | HKWorkoutEventType(rawValue: 7) | Unavailable | 31:53 | 38:11 | 378.3 s | Unavailable | 31:53-38:11 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 11 | HKWorkoutEventType(rawValue: 7) | Unavailable | 38:11 | 44:35 | 384.0 s | Unavailable | 38:11-44:35 | 1.00 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 12 | HKWorkoutEventType(rawValue: 7) | Unavailable | 41:01 | 46:29 | 328.8 s | Unavailable | 41:01-46:29 | 0.86 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 13 | HKWorkoutEventType(rawValue: 7) | Unavailable | 44:35 | 46:29 | 114.5 s | Unavailable | 44:35-46:29 | 0.30 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 14 | HKWorkoutEventType(rawValue: 1) | Unavailable | 46:32 | 46:32 | 0.0 s | Unavailable | Unavailable | Unavailable | Unavailable | No | Excluded from segment rendering: zero or negative duration. | No rendered segment marker candidate. |

## WorkoutKit Reconstructed Intervals

Planned structure source: WorkoutKit when available. Measured stats source: HealthKit samples.

| Row | Label | Goal | Target | Distance | Time | Pace | Avg HR | Max HR | Power | Start Offset | End Offset | Boundary Strategy | Boundary Adjustment | Overshoot | Confidence | Notes |
|---:|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---:|---:|---|---|
| 1 | Work 1 | 7.25 km | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 7.26 km | 46:09 | 6:22 /km | 133 bpm | 145 bpm | 192 W | 0:00 | 46:09 | crossing sample end | 2.2 s | 6.3 m | High | Distance-goal boundary: crossing sample end, adjustment +2.2s, overshoot 6.3 m |
| 2 | Open / Extra | Open | Target unavailable | 0.05 km | 0:23 | 7:56 /km | 139 bpm | 141 bpm | 192 W | 46:09 | 46:32 |  |  |  | Medium | Extra tail after planned WorkoutKit steps |

Notes: Plan source: WorkoutKit · Window source: Plan-derived from HealthKit distance/time samples · Stats source: HealthKit samples · HealthKit segment markers: not used

## WorkoutKit Boundary Diagnostics

### Row 1: Work 1

| Field | Value |
|---|---:|
| Target distance | 7250.0 m |
| Start offset | 0:00 |
| End offset | 46:09 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 2.2 s |
| Overshoot | 6.3 m |
| Cumulative distance at start | 0.0 m |
| Cumulative distance at end | 7256.3 m |
| Interpolation fraction | 0.152 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 46:04 | 46:06 | 7241.7 m | 7248.9 m |
| Crossing | 46:06 | 46:09 | 7248.9 m | 7256.3 m |
| Next | 46:09 | 46:11 | 7256.3 m | 7263.2 m |

### Row 2: Open / Extra Tail

| Field | Value |
|---|---:|
| Planned final step end offset | 46:09 |
| Workout end offset | 46:32 |
| Remaining seconds | 23.0 s |
| Remaining meters | 48.3 m |
| Final distance sample offset | 46:27 |
| Final distance sample cumulative | 7304.6 m |
| Last HR sample offset | 46:28 |
| Last power sample offset | 46:29 |
| Last cadence sample offset | 46:27 |
| Reason | Remaining workout time or distance exceeded Open / Extra threshold after planned WorkoutKit steps. |

## HealthKit Segment Markers

Raw debug only. HealthKit Segment Markers must not be promoted as Apple Fitness interval rows.

| Row | Label | Marker Kind | Source | Distance | Time | Pace | Avg HR | Start Offset | End Offset | Confidence | Caveats |
|---:|---|---|---|---:|---:|---:|---:|---:|---:|---|---|
| 1 | Unknown | Split marker | HealthKit segment pattern | 1.01 km | 6:30 | 6:27 /km | 120 bpm | 0:00 | 6:30 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. |
| 2 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.62 km | 10:29 | 6:29 /km | 123 bpm | 0:00 | 10:29 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 3 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:28 | 6:28 /km | 129 bpm | 6:30 | 12:58 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 4 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 10:13 | 6:21 /km | 131 bpm | 10:29 | 20:42 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 5 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:19 | 6:20 /km | 131 bpm | 12:58 | 19:17 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 6 | Unknown | Split marker | HealthKit segment pattern | 1.00 km | 6:23 | 6:23 /km | 134 bpm | 19:17 | 25:40 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. |
| 7 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 10:06 | 6:16 /km | 136 bpm | 20:42 | 30:48 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 8 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:13 | 6:13 /km | 140 bpm | 25:40 | 31:53 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 9 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 10:12 | 6:21 /km | 139 bpm | 30:48 | 41:01 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 10 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:18 | 6:19 /km | 139 bpm | 31:53 | 38:11 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 11 | Unknown | Split marker | HealthKit segment pattern | 1.00 km | 6:24 | 6:24 /km | 138 bpm | 38:11 | 44:35 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. |
| 12 | Unknown | Overlapping segment marker | HealthKit segment pattern | 0.86 km | 5:29 | 6:22 /km | 139 bpm | 41:01 | 46:29 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 13 | Unknown | Overlapping segment marker | HealthKit segment pattern | 0.30 km | 1:54 | 6:24 /km | 140 bpm | 44:35 | 46:29 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |

## Planned Step Boundary Comparison

Debug-only comparison helper for FIT/Apple boundary investigation. The FIT lap end offset is intentionally a manual placeholder; RunSignal does not read FIT at runtime.

| Row | Planned Step | Goal | RunSignal End | FIT Lap End | Nearest Raw Event End | Event Delta | Nearest Segment End | Segment Delta | Previous Sample End | Crossing Sample End | Next Sample End | Warning |
|---:|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 1 | Work 1 | 7.25 km | 2768.8 s | Manual FIT placeholder | 2789.4 s | 20.6 s | 2789.4 s | 20.6 s | 2766.2 s | 2768.8 s | 2771.3 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 2 | Open / Extra | Open | 2791.8 s | Manual FIT placeholder | 2789.4 s | -2.4 s | 2789.4 s | -2.4 s | Unavailable | Unavailable | Unavailable |  |

## Boundary Source Warnings

- One or more raw HKWorkoutEvent records have unavailable metadata keys.
- FIT lap end offsets are not read by RunSignal; compare them manually after physical-device export.

## Evidence Caveats

- None

## JSON Payload

```json
{
  "boundaryDiagnostics" : [
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 7256.321907041827,
          "endDate" : "2026-04-28T12:31:01Z",
          "endOffsetSeconds" : 2768.776450753212,
          "startCumulativeDistanceMeters" : 7248.865729862358,
          "startDate" : "2026-04-28T12:30:58Z",
          "startOffsetSeconds" : 2766.203897833824
        },
        "cumulativeDistanceAtEndMeters" : 7256.321907041827,
        "cumulativeDistanceAtStartMeters" : 0,
        "interpolationFraction" : 0.15212489058936074,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 7263.231672611553,
          "endDate" : "2026-04-28T12:31:04Z",
          "endOffsetSeconds" : 2771.3490022420883,
          "startCumulativeDistanceMeters" : 7256.321907041827,
          "startDate" : "2026-04-28T12:31:01Z",
          "startOffsetSeconds" : 2768.776450753212
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 7248.865729862358,
          "endDate" : "2026-04-28T12:30:58Z",
          "endOffsetSeconds" : 2766.203897833824,
          "startCumulativeDistanceMeters" : 7241.699116425589,
          "startDate" : "2026-04-28T12:30:56Z",
          "startOffsetSeconds" : 2763.631346464157
        },
        "targetDistanceMeters" : 7250
      },
      "index" : 1,
      "label" : "Work 1"
    },
    {
      "index" : 2,
      "label" : "Open \/ Extra",
      "tail" : {
        "creationReason" : "Remaining workout time or distance exceeded Open \/ Extra threshold after planned WorkoutKit steps.",
        "finalDistanceSampleCumulativeDistanceMeters" : 7304.608153569279,
        "finalDistanceSampleOffsetSeconds" : 2786.7843371629715,
        "lastCadenceSampleOffsetSeconds" : 2786.7843371629715,
        "lastHeartRateSampleOffsetSeconds" : 2787.524899959564,
        "lastPowerSampleOffsetSeconds" : 2789.3568897247314,
        "plannedFinalStepEndOffsetSeconds" : 2768.776450753212,
        "remainingMeters" : 48.28624652745202,
        "remainingSeconds" : 22.98109722137451,
        "workoutEndOffsetSeconds" : 2791.7575479745865
      }
    }
  ],
  "boundarySourceWarnings" : [
    "One or more raw HKWorkoutEvent records have unavailable metadata keys.",
    "FIT lap end offsets are not read by RunSignal; compare them manually after physical-device export."
  ],
  "caveats" : [

  ],
  "evidenceCounts" : {
    "activeEnergy" : 1085,
    "cadence" : 1083,
    "distance" : 1082,
    "events" : 14,
    "groundContact" : 512,
    "heartRate" : 554,
    "power" : 1083,
    "routePoints" : 2792,
    "speed" : 1083,
    "stepCount" : 1083,
    "strideLength" : 513,
    "verticalOscillation" : 512
  },
  "generatedAt" : "2026-06-12T19:50:30Z",
  "plannedStepBoundaryComparisons" : [
    {
      "crossingDistanceSampleEndOffsetSeconds" : 2768.776450753212,
      "index" : 1,
      "nearestRawEventEndDeltaSeconds" : 20.58043897151947,
      "nearestRawEventEndOffsetSeconds" : 2789.3568897247314,
      "nearestRawEventStartOffsetSeconds" : 2460.5094732046127,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 20.58043897151947,
      "nearestSegmentMarkerEndOffsetSeconds" : 2789.3568897247314,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 2460.5094732046127,
      "nextDistanceSampleEndOffsetSeconds" : 2771.3490022420883,
      "plannedGoalDisplayText" : "7.25 km",
      "plannedStepLabel" : "Work 1",
      "previousDistanceSampleEndOffsetSeconds" : 2766.203897833824,
      "reconstructedEndOffsetSeconds" : 2768.776450753212,
      "reconstructedLabel" : "Work 1",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "index" : 2,
      "nearestRawEventEndDeltaSeconds" : -2.4006582498550415,
      "nearestRawEventEndOffsetSeconds" : 2789.3568897247314,
      "nearestRawEventStartOffsetSeconds" : 2460.5094732046127,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -2.4006582498550415,
      "nearestSegmentMarkerEndOffsetSeconds" : 2789.3568897247314,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 2460.5094732046127,
      "plannedGoalDisplayText" : "Open",
      "reconstructedEndOffsetSeconds" : 2791.7575479745865,
      "reconstructedLabel" : "Open \/ Extra"
    }
  ],
  "rawWorkoutEvents" : [
    {
      "durationSeconds" : 390.02656841278076,
      "endDate" : "2026-04-28T11:51:22Z",
      "endOffsetSeconds" : 390.02656841278076,
      "index" : 1,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1007.5754622035538,
      "renderedSegmentMarkerDurationSeconds" : 390.02656841278076,
      "renderedSegmentMarkerEndOffsetSeconds" : 390.02656841278076,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-04-28T11:44:52Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 629.1564658880234,
      "endDate" : "2026-04-28T11:55:21Z",
      "endOffsetSeconds" : 629.1564658880234,
      "index" : 2,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1616.1947415380776,
      "renderedSegmentMarkerDurationSeconds" : 629.1564658880234,
      "renderedSegmentMarkerEndOffsetSeconds" : 629.1564658880234,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-04-28T11:44:52Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 387.71597158908844,
      "endDate" : "2026-04-28T11:57:50Z",
      "endOffsetSeconds" : 777.7425400018692,
      "index" : 3,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 999.3455975445972,
      "renderedSegmentMarkerDurationSeconds" : 387.71597158908844,
      "renderedSegmentMarkerEndOffsetSeconds" : 777.7425400018692,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 390.02656841278076,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-04-28T11:51:22Z",
      "startOffsetSeconds" : 390.02656841278076,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 613.0095367431641,
      "endDate" : "2026-04-28T12:05:34Z",
      "endOffsetSeconds" : 1242.1660026311874,
      "index" : 4,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1609.5107011817647,
      "renderedSegmentMarkerDurationSeconds" : 613.0095367431641,
      "renderedSegmentMarkerEndOffsetSeconds" : 1242.1660026311874,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 629.1564658880234,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-04-28T11:55:21Z",
      "startOffsetSeconds" : 629.1564658880234,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 379.4321211576462,
      "endDate" : "2026-04-28T12:04:09Z",
      "endOffsetSeconds" : 1157.1746611595154,
      "index" : 5,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 999.6898160896721,
      "renderedSegmentMarkerDurationSeconds" : 379.4321211576462,
      "renderedSegmentMarkerEndOffsetSeconds" : 1157.1746611595154,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 777.7425400018692,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-04-28T11:57:50Z",
      "startOffsetSeconds" : 777.7425400018692,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 382.6611865758896,
      "endDate" : "2026-04-28T12:10:32Z",
      "endOffsetSeconds" : 1539.835847735405,
      "index" : 6,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1000.2609391149763,
      "renderedSegmentMarkerDurationSeconds" : 382.6611865758896,
      "renderedSegmentMarkerEndOffsetSeconds" : 1539.835847735405,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1157.1746611595154,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-04-28T12:04:09Z",
      "startOffsetSeconds" : 1157.1746611595154,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 605.9107073545456,
      "endDate" : "2026-04-28T12:15:40Z",
      "endOffsetSeconds" : 1848.076709985733,
      "index" : 7,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1609.8160213694314,
      "renderedSegmentMarkerDurationSeconds" : 605.9107073545456,
      "renderedSegmentMarkerEndOffsetSeconds" : 1848.076709985733,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1242.1660026311874,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-04-28T12:05:34Z",
      "startOffsetSeconds" : 1242.1660026311874,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 372.6867632865906,
      "endDate" : "2026-04-28T12:16:45Z",
      "endOffsetSeconds" : 1912.5226110219955,
      "index" : 8,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1000.1272814644344,
      "renderedSegmentMarkerDurationSeconds" : 372.6867632865906,
      "renderedSegmentMarkerEndOffsetSeconds" : 1912.5226110219955,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1539.835847735405,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-04-28T12:10:32Z",
      "startOffsetSeconds" : 1539.835847735405,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 612.4327632188797,
      "endDate" : "2026-04-28T12:25:53Z",
      "endOffsetSeconds" : 2460.5094732046127,
      "index" : 9,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1608.8182796099518,
      "renderedSegmentMarkerDurationSeconds" : 612.4327632188797,
      "renderedSegmentMarkerEndOffsetSeconds" : 2460.5094732046127,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1848.076709985733,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-04-28T12:15:40Z",
      "startOffsetSeconds" : 1848.076709985733,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 378.32142186164856,
      "endDate" : "2026-04-28T12:23:03Z",
      "endOffsetSeconds" : 2290.844032883644,
      "index" : 10,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 999.4024799917206,
      "renderedSegmentMarkerDurationSeconds" : 378.32142186164856,
      "renderedSegmentMarkerEndOffsetSeconds" : 2290.844032883644,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1912.5226110219955,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-04-28T12:16:45Z",
      "startOffsetSeconds" : 1912.5226110219955,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 384.03734588623047,
      "endDate" : "2026-04-28T12:29:27Z",
      "endOffsetSeconds" : 2674.8813787698746,
      "index" : 11,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1000.0698642583257,
      "renderedSegmentMarkerDurationSeconds" : 384.03734588623047,
      "renderedSegmentMarkerEndOffsetSeconds" : 2674.8813787698746,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 2290.844032883644,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-04-28T12:23:03Z",
      "startOffsetSeconds" : 2290.844032883644,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 328.8474165201187,
      "endDate" : "2026-04-28T12:31:22Z",
      "endOffsetSeconds" : 2789.3568897247314,
      "index" : 12,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 860.2684098700538,
      "renderedSegmentMarkerDurationSeconds" : 328.8474165201187,
      "renderedSegmentMarkerEndOffsetSeconds" : 2789.3568897247314,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 2460.5094732046127,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-04-28T12:25:53Z",
      "startOffsetSeconds" : 2460.5094732046127,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 114.47551095485687,
      "endDate" : "2026-04-28T12:31:22Z",
      "endOffsetSeconds" : 2789.3568897247314,
      "index" : 13,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 298.1367129019991,
      "renderedSegmentMarkerDurationSeconds" : 114.47551095485687,
      "renderedSegmentMarkerEndOffsetSeconds" : 2789.3568897247314,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 2674.8813787698746,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-04-28T12:29:27Z",
      "startOffsetSeconds" : 2674.8813787698746,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 0,
      "endDate" : "2026-04-28T12:31:24Z",
      "endOffsetSeconds" : 2791.7575479745865,
      "excludedOrFilteredReason" : "zeroOrNegativeDuration",
      "index" : 14,
      "metadataKeys" : [

      ],
      "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
      "startDate" : "2026-04-28T12:31:24Z",
      "startOffsetSeconds" : 2791.7575479745865,
      "type" : "HKWorkoutEventType(rawValue: 1)",
      "usedBySegmentMarkerRendering" : false
    }
  ],
  "reconstructedIntervals" : [
    {
      "averageHeartRateBpm" : 133.10382513661202,
      "averagePower" : 191.77302325581397,
      "boundaryAdjustmentSeconds" : 2.181203603744507,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 7256.321907041827,
          "endDate" : "2026-04-28T12:31:01Z",
          "endOffsetSeconds" : 2768.776450753212,
          "startCumulativeDistanceMeters" : 7248.865729862358,
          "startDate" : "2026-04-28T12:30:58Z",
          "startOffsetSeconds" : 2766.203897833824
        },
        "cumulativeDistanceAtEndMeters" : 7256.321907041827,
        "cumulativeDistanceAtStartMeters" : 0,
        "interpolationFraction" : 0.15212489058936074,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 7263.231672611553,
          "endDate" : "2026-04-28T12:31:04Z",
          "endOffsetSeconds" : 2771.3490022420883,
          "startCumulativeDistanceMeters" : 7256.321907041827,
          "startDate" : "2026-04-28T12:31:01Z",
          "startOffsetSeconds" : 2768.776450753212
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 7248.865729862358,
          "endDate" : "2026-04-28T12:30:58Z",
          "endOffsetSeconds" : 2766.203897833824,
          "startCumulativeDistanceMeters" : 7241.699116425589,
          "startDate" : "2026-04-28T12:30:56Z",
          "startOffsetSeconds" : 2763.631346464157
        },
        "targetDistanceMeters" : 7250
      },
      "boundaryOvershootMeters" : 6.321907041827217,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "distanceMeters" : 7256.321907041827,
      "durationSeconds" : 2768.776450753212,
      "endOffsetSeconds" : 2768.776450753212,
      "index" : 1,
      "label" : "Work 1",
      "maxHeartRateBpm" : 145,
      "paceSecondsPerKm" : 381.5674781553282,
      "plannedGoalDisplayText" : "7.25 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 7250,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +2.2s, overshoot 6.3 m",
      "startOffsetSeconds" : 0,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 138.6,
      "averagePower" : 191.875,
      "confidence" : "medium",
      "distanceMeters" : 48.28624652745202,
      "durationSeconds" : 22.98109722137451,
      "endOffsetSeconds" : 2791.7575479745865,
      "index" : 2,
      "label" : "Open \/ Extra",
      "maxHeartRateBpm" : 141,
      "paceSecondsPerKm" : 475.9346371706308,
      "plannedGoalDisplayText" : "Open",
      "plannedGoalType" : "open",
      "sourceNote" : "Extra tail after planned WorkoutKit steps",
      "startOffsetSeconds" : 2768.776450753212,
      "stepType" : "open",
      "tailDiagnostics" : {
        "creationReason" : "Remaining workout time or distance exceeded Open \/ Extra threshold after planned WorkoutKit steps.",
        "finalDistanceSampleCumulativeDistanceMeters" : 7304.608153569279,
        "finalDistanceSampleOffsetSeconds" : 2786.7843371629715,
        "lastCadenceSampleOffsetSeconds" : 2786.7843371629715,
        "lastHeartRateSampleOffsetSeconds" : 2787.524899959564,
        "lastPowerSampleOffsetSeconds" : 2789.3568897247314,
        "plannedFinalStepEndOffsetSeconds" : 2768.776450753212,
        "remainingMeters" : 48.28624652745202,
        "remainingSeconds" : 22.98109722137451,
        "workoutEndOffsetSeconds" : 2791.7575479745865
      }
    }
  ],
  "segmentMarkers" : [
    {
      "averageHeartRateBpm" : 119.675,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1007.5754622035538,
      "durationSeconds" : 390.02656841278076,
      "endOffsetSeconds" : 390.02656841278076,
      "index" : 1,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 387.094151300388,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 122.87301587301587,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1616.1947415380776,
      "durationSeconds" : 629.1564658880234,
      "endOffsetSeconds" : 629.1564658880234,
      "index" : 2,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 389.2825844051915,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 128.82894736842104,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 999.3455975445972,
      "durationSeconds" : 387.71597158908844,
      "endOffsetSeconds" : 777.7425400018692,
      "index" : 3,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 387.96986001810654,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 390.02656841278076
    },
    {
      "averageHeartRateBpm" : 131.14406779661016,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1609.5107011817647,
      "durationSeconds" : 613.0095367431641,
      "endOffsetSeconds" : 1242.1660026311874,
      "index" : 4,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 380.8670152320633,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 629.1564658880234
    },
    {
      "averageHeartRateBpm" : 131.04225352112675,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 999.6898160896721,
      "durationSeconds" : 379.4321211576462,
      "endOffsetSeconds" : 1157.1746611595154,
      "index" : 5,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 379.54985141472235,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 777.7425400018692
    },
    {
      "averageHeartRateBpm" : 133.93506493506493,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1000.2609391149763,
      "durationSeconds" : 382.6611865758896,
      "endOffsetSeconds" : 1539.835847735405,
      "index" : 6,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 382.561361352834,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1157.1746611595154
    },
    {
      "averageHeartRateBpm" : 136.3388429752066,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1609.8160213694314,
      "durationSeconds" : 605.9107073545456,
      "endOffsetSeconds" : 1848.076709985733,
      "index" : 7,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 376.38506469771124,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1242.1660026311874
    },
    {
      "averageHeartRateBpm" : 139.5810810810811,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1000.1272814644344,
      "durationSeconds" : 372.6867632865906,
      "endOffsetSeconds" : 1912.5226110219955,
      "index" : 8,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 372.63933320655417,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1539.835847735405
    },
    {
      "averageHeartRateBpm" : 139.34959349593495,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1608.8182796099518,
      "durationSeconds" : 612.4327632188797,
      "endOffsetSeconds" : 2460.5094732046127,
      "index" : 9,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 380.67242955951514,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1848.076709985733
    },
    {
      "averageHeartRateBpm" : 139.25,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 999.4024799917206,
      "durationSeconds" : 378.32142186164856,
      "endOffsetSeconds" : 2290.844032883644,
      "index" : 10,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 378.5476116336861,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1912.5226110219955
    },
    {
      "averageHeartRateBpm" : 138.2987012987013,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1000.0698642583257,
      "durationSeconds" : 384.03734588623047,
      "endOffsetSeconds" : 2674.8813787698746,
      "index" : 11,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 384.01051727625173,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 2290.844032883644
    },
    {
      "averageHeartRateBpm" : 138.9848484848485,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 860.2684098700538,
      "durationSeconds" : 328.8474165201187,
      "endOffsetSeconds" : 2789.3568897247314,
      "index" : 12,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 382.26141137716786,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 2460.5094732046127
    },
    {
      "averageHeartRateBpm" : 140.17391304347825,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 298.1367129019991,
      "durationSeconds" : 114.47551095485687,
      "endOffsetSeconds" : 2789.3568897247314,
      "index" : 13,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 383.96985678340883,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 2674.8813787698746
    }
  ],
  "sourceNotes" : [
    "Plan source: WorkoutKit",
    "Window source: Plan-derived from HealthKit distance\/time samples",
    "Stats source: HealthKit samples",
    "HealthKit segment markers: not used"
  ],
  "workout" : {
    "averageHeartRate" : 133.25204169353108,
    "averagePower" : 191.77377654662956,
    "cadenceSpm" : 174.98150615065416,
    "deviceName" : "Apple Watch Apple Inc. Watch",
    "distanceMeters" : 7304.608153569279,
    "durationSeconds" : 2791.7575479745865,
    "elapsedSeconds" : 2791.7575479745865,
    "endDate" : "2026-04-28T12:31:24Z",
    "id" : "9AD88333-024B-4476-B81F-7D15A8E0FC89",
    "maxHeartRate" : 145,
    "paceSecondsPerKm" : 382.19128107651323,
    "sourceID" : "9AD88333-024B-4476-B81F-7D15A8E0FC89",
    "sourceName" : "Adriel’s Apple Watch",
    "startDate" : "2026-04-28T11:44:52Z"
  },
  "workoutKitPlanAudit" : {
    "displayName" : "Tuesday Easy 7.25km",
    "planID" : "64073E58-E063-455E-B866-76A369213980",
    "planType" : "Custom workout",
    "plannedSteps" : [
      {
        "index" : 1,
        "label" : "Work 1",
        "plannedGoalDisplayText" : "7.25 km",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 7250,
        "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
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
      "Block 1 step 1: Work - goal 7.25 km, alert pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "Cooldown: none"
    ]
  }
}
```