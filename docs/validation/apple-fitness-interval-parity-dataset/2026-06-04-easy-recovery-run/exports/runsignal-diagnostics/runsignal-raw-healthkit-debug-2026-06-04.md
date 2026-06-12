# RunSignal Raw HealthKit Debug Export

Generated: 2026-06-12T21:29:46Z

## Workout

| Field | Value |
|---|---|
| Workout ID | 0F92DFB9-F99B-4950-9D00-6B499F0714FB |
| Source | Adriel’s Apple Watch |
| Source ID | 0F92DFB9-F99B-4950-9D00-6B499F0714FB |
| Device | Apple Watch Apple Inc. Watch |
| Start | Jun 4, 2026 |
| End | Jun 4, 2026 |
| Duration | 36:57 |
| Elapsed | 36:57 |
| Distance | 5.70 km |
| Avg pace | 6:29 /km |
| Avg HR | 127 bpm |
| Max HR | 141 bpm |
| Cadence | 177 spm |
| Power | 187 W |

## Evidence Counts

| Metric | Count |
|---|---:|
| Heart rate | 443 |
| Speed | 860 |
| Distance | 860 |
| Active energy | 860 |
| Power | 859 |
| Cadence | 862 |
| Step count | 862 |
| Stride length | 411 |
| Vertical oscillation | 412 |
| Ground contact | 411 |
| Route points | 2217 |
| Events | 11 |
| Workout activities | 1 |

## WorkoutKit Plan Audit

- Status: Available
- Plan type: Custom workout
- Plan ID: 69C2E08A-9784-4EB2-9D8B-E3824DF4E9EE
- Display name: Thursday Recovery 5.65k
- Activity: HKWorkoutActivityType(rawValue: 37)
- Warmup: none
- Block 1: 1x, 1 step(s)
- Block 1 step 1: Work - goal 5.65 km, alert heart rate zone 2
- Cooldown: none

## Raw HKWorkoutEvent Inventory

Debug-only inventory of public `HKWorkoutEvent` date windows and metadata keys. These rows are not Apple Fitness interval truth.

| Row | Event Type | Label | Start Offset | End Offset | Duration | Metadata Keys | Rendered Marker Window | Marker Distance | Marker Kind | Used By Segment Rendering | Excluded / Filtered Reason | Debug-Only Reason |
|---:|---|---|---:|---:|---:|---|---:|---:|---|---|---|---|
| 1 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 6:27 | 386.7 s | Unavailable | 0:00-6:27 | 1.00 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 2 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 10:21 | 621.1 s | Unavailable | 0:00-10:21 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 3 | HKWorkoutEventType(rawValue: 7) | Unavailable | 6:27 | 12:49 | 382.7 s | Unavailable | 6:27-12:49 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 4 | HKWorkoutEventType(rawValue: 7) | Unavailable | 10:21 | 20:43 | 621.9 s | Unavailable | 10:21-20:43 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 5 | HKWorkoutEventType(rawValue: 7) | Unavailable | 12:49 | 19:19 | 389.8 s | Unavailable | 12:49-19:19 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 6 | HKWorkoutEventType(rawValue: 7) | Unavailable | 19:19 | 25:48 | 388.4 s | Unavailable | 19:19-25:48 | 1.00 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 7 | HKWorkoutEventType(rawValue: 7) | Unavailable | 20:43 | 31:12 | 629.0 s | Unavailable | 20:43-31:12 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 8 | HKWorkoutEventType(rawValue: 7) | Unavailable | 25:48 | 32:19 | 391.7 s | Unavailable | 25:48-32:19 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 9 | HKWorkoutEventType(rawValue: 7) | Unavailable | 31:12 | 36:52 | 340.2 s | Unavailable | 31:12-36:52 | 0.87 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 10 | HKWorkoutEventType(rawValue: 7) | Unavailable | 32:19 | 36:52 | 273.0 s | Unavailable | 32:19-36:52 | 0.69 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 11 | HKWorkoutEventType(rawValue: 1) | Unavailable | 36:57 | 36:57 | 0.0 s | Unavailable | Unavailable | Unavailable | Unavailable | No | Excluded from segment rendering: zero or negative duration. | No rendered segment marker candidate. |

## HKWorkoutActivity Inventory

Debug-only inventory of public `HKWorkout.workoutActivities` rows. These rows are not used for production interval reconstruction.

| Activity | Type | Start Date | End Date | Start Offset | End Offset | Duration | Metadata Keys | Nested Events | Statistics | Aligns Planned Step | Aligned Planned Step | Nearest Reconstructed Row | Row End Delta | Apple Fitness/manual | FIT Lap | Raw Event Start | Raw Start Delta | Raw Event End | Raw End Delta | Segment Start | Segment Start Delta | Segment End | Segment End Delta | Previous Sample End | Crossing Sample End | Next Sample End |
|---:|---|---|---|---:|---:|---:|---|---|---|---|---|---|---:|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | HKWorkoutActivityType(rawValue: 37) | 2026-06-04T11:47:06Z | 2026-06-04T12:23:42Z | 0.0 s | 2195.6 s | 2195.6 s | HKElevationAscended, WOIntervalStepKeyPath | 10 event(s): HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 346.7 kcal; BasalEnergyBurned: sum 53.8 kcal; DistanceWalkingRunning: sum 5657.2 m; HeartRate: avg 126.0 bpm, min 58.0 bpm, max 141.0 bpm | Yes | Work 1 | Work 1 | -1.3 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 0.0 s | 0.0 s | 2212.3 s | 16.7 s | 0.0 s | 0.0 s | 2212.3 s | 16.7 s | 2191.7 s | 2194.3 s | 2196.9 s |

## WorkoutKit Reconstructed Intervals

Planned structure source: WorkoutKit when available. Measured stats source: HealthKit samples.

| Row | Label | Goal | Target | Distance | Time | Pace | Avg HR | Max HR | Power | Start Offset | End Offset | Boundary Strategy | Boundary Adjustment | Overshoot | Confidence | Notes |
|---:|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---:|---:|---|---|
| 1 | Work 1 | 5.65 km | heart rate zone 2 | 5.65 km | 36:34 | 6:28 /km | 126 bpm | 141 bpm | 187 W | 0:00 | 36:34 | crossing sample end | 1.3 s | 2.9 m | High | Distance-goal boundary: crossing sample end, adjustment +1.3s, overshoot 2.9 m |
| 2 | Open / Extra | Open | Target unavailable | 0.04 km | 0:22 | 8:50 /km | 137 bpm | 138 bpm | 189 W | 36:34 | 36:57 |  |  |  | Medium | Extra tail after planned WorkoutKit steps |

Notes: Plan source: WorkoutKit · Window source: Plan-derived from HealthKit distance/time samples · Stats source: HealthKit samples · HealthKit segment markers: not used

## WorkoutKit Boundary Diagnostics

### Row 1: Work 1

| Field | Value |
|---|---:|
| Target distance | 5650.0 m |
| Start offset | 0:00 |
| End offset | 36:34 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 1.3 s |
| Overshoot | 2.9 m |
| Cumulative distance at start | 7.2 m |
| Cumulative distance at end | 5660.2 m |
| Interpolation fraction | 0.503 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 36:29 | 36:32 | 5648.2 m | 5654.3 m |
| Crossing | 36:32 | 36:34 | 5654.3 m | 5660.2 m |
| Next | 36:34 | 36:37 | 5660.2 m | 5668.1 m |

### Row 2: Open / Extra Tail

| Field | Value |
|---|---:|
| Planned final step end offset | 36:34 |
| Workout end offset | 36:57 |
| Remaining seconds | 22.2 s |
| Remaining meters | 42.0 m |
| Final distance sample offset | 36:50 |
| Final distance sample cumulative | 5702.1 m |
| Last HR sample offset | 36:53 |
| Last power sample offset | 36:52 |
| Last cadence sample offset | 36:55 |
| Reason | Remaining workout time or distance exceeded Open / Extra threshold after planned WorkoutKit steps. |

## HealthKit Segment Markers

Raw debug only. HealthKit Segment Markers must not be promoted as Apple Fitness interval rows.

| Row | Label | Marker Kind | Source | Distance | Time | Pace | Avg HR | Start Offset | End Offset | Confidence | Caveats |
|---:|---|---|---|---:|---:|---:|---:|---:|---:|---|---|
| 1 | Unknown | Split marker | HealthKit segment pattern | 1.00 km | 6:27 | 6:25 /km | 110 bpm | 0:00 | 6:27 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. |
| 2 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 10:21 | 6:26 /km | 114 bpm | 0:00 | 10:21 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 3 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:23 | 6:24 /km | 123 bpm | 6:27 | 12:49 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 4 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 10:22 | 6:27 /km | 127 bpm | 10:21 | 20:43 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 5 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:30 | 6:30 /km | 127 bpm | 12:49 | 19:19 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 6 | Unknown | Split marker | HealthKit segment pattern | 1.00 km | 6:28 | 6:29 /km | 132 bpm | 19:19 | 25:48 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. |
| 7 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 10:29 | 6:31 /km | 133 bpm | 20:43 | 31:12 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 8 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:32 | 6:32 /km | 133 bpm | 25:48 | 32:19 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 9 | Unknown | Overlapping segment marker | HealthKit segment pattern | 0.87 km | 5:40 | 6:32 /km | 136 bpm | 31:12 | 36:52 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 10 | Unknown | Overlapping segment marker | HealthKit segment pattern | 0.69 km | 4:33 | 6:33 /km | 136 bpm | 32:19 | 36:52 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |

## Planned Step Boundary Comparison

Debug-only comparison helper for FIT/Apple boundary investigation. The FIT lap end offset is intentionally a manual placeholder; RunSignal does not read FIT at runtime.

| Row | Planned Step | Goal | RunSignal End | FIT Lap End | Nearest Raw Event End | Event Delta | Nearest Activity End | Activity Delta | Activity Type | Nearest Segment End | Segment Delta | Previous Sample End | Crossing Sample End | Next Sample End | Warning |
|---:|---|---|---:|---:|---:|---:|---:|---:|---|---:|---:|---:|---:|---:|---|
| 1 | Work 1 | 5.65 km | 2194.3 s | Manual FIT placeholder | 2212.3 s | 18.0 s | 2195.6 s | 1.3 s | HKWorkoutActivityType(rawValue: 37) | 2212.3 s | 18.0 s | 2191.7 s | 2194.3 s | 2196.9 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 2 | Open / Extra | Open | 2216.5 s | Manual FIT placeholder | 2212.3 s | -4.2 s | 2195.6 s | -20.9 s | HKWorkoutActivityType(rawValue: 37) | 2212.3 s | -4.2 s | Unavailable | Unavailable | Unavailable | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |

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
          "endCumulativeDistanceMeters" : 5660.158285633661,
          "endDate" : "2026-06-04T12:23:41Z",
          "endOffsetSeconds" : 2194.2983305454254,
          "startCumulativeDistanceMeters" : 5654.269577890402,
          "startDate" : "2026-06-04T12:23:38Z",
          "startOffsetSeconds" : 2191.725753903389
        },
        "cumulativeDistanceAtEndMeters" : 5660.158285633661,
        "cumulativeDistanceAtStartMeters" : 7.2293981584613345,
        "interpolationFraction" : 0.5026264499962811,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 5668.110154737951,
          "endDate" : "2026-06-04T12:23:43Z",
          "endOffsetSeconds" : 2196.870908141136,
          "startCumulativeDistanceMeters" : 5660.158285633661,
          "startDate" : "2026-06-04T12:23:41Z",
          "startOffsetSeconds" : 2194.2983305454254
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 5654.269577890402,
          "endDate" : "2026-06-04T12:23:38Z",
          "endOffsetSeconds" : 2191.725753903389,
          "startCumulativeDistanceMeters" : 5648.2072463184595,
          "startDate" : "2026-06-04T12:23:36Z",
          "startOffsetSeconds" : 2189.153175830841
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
        "finalDistanceSampleCumulativeDistanceMeters" : 5702.109193835175,
        "finalDistanceSampleOffsetSeconds" : 2209.733841896057,
        "lastCadenceSampleOffsetSeconds" : 2214.8790199756622,
        "lastHeartRateSampleOffsetSeconds" : 2212.978714108467,
        "lastPowerSampleOffsetSeconds" : 2212.3064296245575,
        "plannedFinalStepEndOffsetSeconds" : 2194.2983305454254,
        "remainingMeters" : 41.95090820151381,
        "remainingSeconds" : 22.246679425239563,
        "workoutEndOffsetSeconds" : 2216.545009970665
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
    "activeEnergy" : 860,
    "activities" : 1,
    "cadence" : 862,
    "distance" : 860,
    "events" : 11,
    "groundContact" : 411,
    "heartRate" : 443,
    "power" : 859,
    "routePoints" : 2217,
    "speed" : 860,
    "stepCount" : 862,
    "strideLength" : 411,
    "verticalOscillation" : 412
  },
  "generatedAt" : "2026-06-12T21:29:46Z",
  "plannedStepBoundaryComparisons" : [
    {
      "crossingDistanceSampleEndOffsetSeconds" : 2194.2983305454254,
      "index" : 1,
      "nearestRawEventEndDeltaSeconds" : 18.00809907913208,
      "nearestRawEventEndOffsetSeconds" : 2212.3064296245575,
      "nearestRawEventStartOffsetSeconds" : 1872.0573481321335,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 18.00809907913208,
      "nearestSegmentMarkerEndOffsetSeconds" : 2212.3064296245575,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1872.0573481321335,
      "nearestWorkoutActivityEndDeltaSeconds" : 1.3349615335464478,
      "nearestWorkoutActivityEndOffsetSeconds" : 2195.633292078972,
      "nearestWorkoutActivityStartOffsetSeconds" : 0,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "nextDistanceSampleEndOffsetSeconds" : 2196.870908141136,
      "plannedGoalDisplayText" : "5.65 km",
      "plannedStepLabel" : "Work 1",
      "previousDistanceSampleEndOffsetSeconds" : 2191.725753903389,
      "reconstructedEndOffsetSeconds" : 2194.2983305454254,
      "reconstructedLabel" : "Work 1",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "index" : 2,
      "nearestRawEventEndDeltaSeconds" : -4.238580346107483,
      "nearestRawEventEndOffsetSeconds" : 2212.3064296245575,
      "nearestRawEventStartOffsetSeconds" : 1872.0573481321335,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -4.238580346107483,
      "nearestSegmentMarkerEndOffsetSeconds" : 2212.3064296245575,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1872.0573481321335,
      "nearestWorkoutActivityEndDeltaSeconds" : -20.911717891693115,
      "nearestWorkoutActivityEndOffsetSeconds" : 2195.633292078972,
      "nearestWorkoutActivityStartOffsetSeconds" : 0,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "plannedGoalDisplayText" : "Open",
      "reconstructedEndOffsetSeconds" : 2216.545009970665,
      "reconstructedLabel" : "Open \/ Extra",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    }
  ],
  "rawWorkoutEvents" : [
    {
      "durationSeconds" : 386.68887984752655,
      "endDate" : "2026-06-04T11:53:33Z",
      "endOffsetSeconds" : 386.68887984752655,
      "index" : 1,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1003.7724266026452,
      "renderedSegmentMarkerDurationSeconds" : 386.68887984752655,
      "renderedSegmentMarkerEndOffsetSeconds" : 386.68887984752655,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-04T11:47:06Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 621.0999114513397,
      "endDate" : "2026-06-04T11:57:28Z",
      "endOffsetSeconds" : 621.0999114513397,
      "index" : 2,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1610.1672375527128,
      "renderedSegmentMarkerDurationSeconds" : 621.0999114513397,
      "renderedSegmentMarkerEndOffsetSeconds" : 621.0999114513397,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-04T11:47:06Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 382.7223094701767,
      "endDate" : "2026-06-04T11:59:56Z",
      "endOffsetSeconds" : 769.4111893177032,
      "index" : 3,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 996.068039814211,
      "renderedSegmentMarkerDurationSeconds" : 382.7223094701767,
      "renderedSegmentMarkerEndOffsetSeconds" : 769.4111893177032,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 386.68887984752655,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-04T11:53:33Z",
      "startOffsetSeconds" : 386.68887984752655,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 621.9483083486557,
      "endDate" : "2026-06-04T12:07:49Z",
      "endOffsetSeconds" : 1243.0482197999954,
      "index" : 4,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1607.9588615279479,
      "renderedSegmentMarkerDurationSeconds" : 621.9483083486557,
      "renderedSegmentMarkerEndOffsetSeconds" : 1243.0482197999954,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 621.0999114513397,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-04T11:57:28Z",
      "startOffsetSeconds" : 621.0999114513397,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 389.75526201725006,
      "endDate" : "2026-06-04T12:06:26Z",
      "endOffsetSeconds" : 1159.1664513349533,
      "index" : 5,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1000.4930034533543,
      "renderedSegmentMarkerDurationSeconds" : 389.75526201725006,
      "renderedSegmentMarkerEndOffsetSeconds" : 1159.1664513349533,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 769.4111893177032,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-04T11:59:56Z",
      "startOffsetSeconds" : 769.4111893177032,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 388.4484142065048,
      "endDate" : "2026-06-04T12:12:54Z",
      "endOffsetSeconds" : 1547.6148655414581,
      "index" : 6,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 999.64426880357,
      "renderedSegmentMarkerDurationSeconds" : 388.4484142065048,
      "renderedSegmentMarkerEndOffsetSeconds" : 1547.6148655414581,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1159.1664513349533,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-04T12:06:26Z",
      "startOffsetSeconds" : 1159.1664513349533,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 629.0091283321381,
      "endDate" : "2026-06-04T12:18:18Z",
      "endOffsetSeconds" : 1872.0573481321335,
      "index" : 7,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1609.4270264548213,
      "renderedSegmentMarkerDurationSeconds" : 629.0091283321381,
      "renderedSegmentMarkerEndOffsetSeconds" : 1872.0573481321335,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1243.0482197999954,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-04T12:07:49Z",
      "startOffsetSeconds" : 1243.0482197999954,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 391.7193866968155,
      "endDate" : "2026-06-04T12:19:26Z",
      "endOffsetSeconds" : 1939.3342522382736,
      "index" : 8,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1000.1186303624613,
      "renderedSegmentMarkerDurationSeconds" : 391.7193866968155,
      "renderedSegmentMarkerEndOffsetSeconds" : 1939.3342522382736,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1547.6148655414581,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-04T12:12:54Z",
      "startOffsetSeconds" : 1547.6148655414581,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 340.249081492424,
      "endDate" : "2026-06-04T12:23:59Z",
      "endOffsetSeconds" : 2212.3064296245575,
      "index" : 9,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 867.3266701412313,
      "renderedSegmentMarkerDurationSeconds" : 340.249081492424,
      "renderedSegmentMarkerEndOffsetSeconds" : 2212.3064296245575,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1872.0573481321335,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-04T12:18:18Z",
      "startOffsetSeconds" : 1872.0573481321335,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 272.9721773862839,
      "endDate" : "2026-06-04T12:23:59Z",
      "endOffsetSeconds" : 2212.3064296245575,
      "index" : 10,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 694.7834266404716,
      "renderedSegmentMarkerDurationSeconds" : 272.9721773862839,
      "renderedSegmentMarkerEndOffsetSeconds" : 2212.3064296245575,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1939.3342522382736,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-04T12:19:26Z",
      "startOffsetSeconds" : 1939.3342522382736,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 0,
      "endDate" : "2026-06-04T12:24:03Z",
      "endOffsetSeconds" : 2216.545009970665,
      "excludedOrFilteredReason" : "zeroOrNegativeDuration",
      "index" : 11,
      "metadataKeys" : [

      ],
      "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
      "startDate" : "2026-06-04T12:24:03Z",
      "startOffsetSeconds" : 2216.545009970665,
      "type" : "HKWorkoutEventType(rawValue: 1)",
      "usedBySegmentMarkerRendering" : false
    }
  ],
  "reconstructedIntervals" : [
    {
      "averageHeartRateBpm" : 126.43835616438356,
      "averagePower" : 187.3967136150235,
      "boundaryAdjustmentSeconds" : 1.2795315980911255,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 5660.158285633661,
          "endDate" : "2026-06-04T12:23:41Z",
          "endOffsetSeconds" : 2194.2983305454254,
          "startCumulativeDistanceMeters" : 5654.269577890402,
          "startDate" : "2026-06-04T12:23:38Z",
          "startOffsetSeconds" : 2191.725753903389
        },
        "cumulativeDistanceAtEndMeters" : 5660.158285633661,
        "cumulativeDistanceAtStartMeters" : 7.2293981584613345,
        "interpolationFraction" : 0.5026264499962811,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 5668.110154737951,
          "endDate" : "2026-06-04T12:23:43Z",
          "endOffsetSeconds" : 2196.870908141136,
          "startCumulativeDistanceMeters" : 5660.158285633661,
          "startDate" : "2026-06-04T12:23:41Z",
          "startOffsetSeconds" : 2194.2983305454254
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 5654.269577890402,
          "endDate" : "2026-06-04T12:23:38Z",
          "endOffsetSeconds" : 2191.725753903389,
          "startCumulativeDistanceMeters" : 5648.2072463184595,
          "startDate" : "2026-06-04T12:23:36Z",
          "startOffsetSeconds" : 2189.153175830841
        },
        "targetDistanceMeters" : 5650
      },
      "boundaryOvershootMeters" : 2.92888747519919,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "distanceMeters" : 5652.928887475199,
      "durationSeconds" : 2194.2983305454254,
      "endOffsetSeconds" : 2194.2983305454254,
      "index" : 1,
      "label" : "Work 1",
      "maxHeartRateBpm" : 141,
      "paceSecondsPerKm" : 388.1701635071298,
      "plannedGoalDisplayText" : "5.65 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 5650,
      "plannedTargetDisplayText" : "heart rate zone 2",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +1.3s, overshoot 2.9 m",
      "startOffsetSeconds" : 0,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 136.6,
      "averagePower" : 188.625,
      "confidence" : "medium",
      "distanceMeters" : 41.95090820151381,
      "durationSeconds" : 22.246679425239563,
      "endOffsetSeconds" : 2216.545009970665,
      "index" : 2,
      "label" : "Open \/ Extra",
      "maxHeartRateBpm" : 138,
      "paceSecondsPerKm" : 530.3026889996337,
      "plannedGoalDisplayText" : "Open",
      "plannedGoalType" : "open",
      "sourceNote" : "Extra tail after planned WorkoutKit steps",
      "startOffsetSeconds" : 2194.2983305454254,
      "stepType" : "open",
      "tailDiagnostics" : {
        "creationReason" : "Remaining workout time or distance exceeded Open \/ Extra threshold after planned WorkoutKit steps.",
        "finalDistanceSampleCumulativeDistanceMeters" : 5702.109193835175,
        "finalDistanceSampleOffsetSeconds" : 2209.733841896057,
        "lastCadenceSampleOffsetSeconds" : 2214.8790199756622,
        "lastHeartRateSampleOffsetSeconds" : 2212.978714108467,
        "lastPowerSampleOffsetSeconds" : 2212.3064296245575,
        "plannedFinalStepEndOffsetSeconds" : 2194.2983305454254,
        "remainingMeters" : 41.95090820151381,
        "remainingSeconds" : 22.246679425239563,
        "workoutEndOffsetSeconds" : 2216.545009970665
      }
    }
  ],
  "segmentMarkers" : [
    {
      "averageHeartRateBpm" : 109.97402597402598,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1003.7724266026452,
      "durationSeconds" : 386.68887984752655,
      "endOffsetSeconds" : 386.68887984752655,
      "index" : 1,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 385.2356067961626,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 114.38709677419355,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1610.1672375527128,
      "durationSeconds" : 621.0999114513397,
      "endOffsetSeconds" : 621.0999114513397,
      "index" : 2,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 385.73627444770716,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 123.02631578947368,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 996.068039814211,
      "durationSeconds" : 382.7223094701767,
      "endOffsetSeconds" : 769.4111893177032,
      "index" : 3,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 384.2330987163919,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 386.68887984752655
    },
    {
      "averageHeartRateBpm" : 127.01612903225806,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1607.9588615279479,
      "durationSeconds" : 621.9483083486557,
      "endOffsetSeconds" : 1243.0482197999954,
      "index" : 4,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 386.7936694335918,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 621.0999114513397
    },
    {
      "averageHeartRateBpm" : 127.12820512820512,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1000.4930034533543,
      "durationSeconds" : 389.75526201725006,
      "endOffsetSeconds" : 1159.1664513349533,
      "index" : 5,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 389.5632060113867,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 769.4111893177032
    },
    {
      "averageHeartRateBpm" : 132.2051282051282,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row."
      ],
      "confidence" : "limited",
      "distanceMeters" : 999.64426880357,
      "durationSeconds" : 388.4484142065048,
      "endOffsetSeconds" : 1547.6148655414581,
      "index" : 6,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 388.5866465992163,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1159.1664513349533
    },
    {
      "averageHeartRateBpm" : 133.0236220472441,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1609.4270264548213,
      "durationSeconds" : 629.0091283321381,
      "endOffsetSeconds" : 1872.0573481321335,
      "index" : 7,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 390.82798908732946,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1243.0482197999954
    },
    {
      "averageHeartRateBpm" : 133.26582278481013,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1000.1186303624613,
      "durationSeconds" : 391.7193866968155,
      "endOffsetSeconds" : 1939.3342522382736,
      "index" : 8,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 391.6729223960653,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1547.6148655414581
    },
    {
      "averageHeartRateBpm" : 135.77611940298507,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 867.3266701412313,
      "durationSeconds" : 340.249081492424,
      "endOffsetSeconds" : 2212.3064296245575,
      "index" : 9,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 392.296343702909,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1872.0573481321335
    },
    {
      "averageHeartRateBpm" : 136.12962962962962,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 694.7834266404716,
      "durationSeconds" : 272.9721773862839,
      "endOffsetSeconds" : 2212.3064296245575,
      "index" : 10,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 392.88815322812576,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1939.3342522382736
    }
  ],
  "sourceNotes" : [
    "Plan source: WorkoutKit",
    "Window source: Plan-derived from HealthKit distance\/time samples",
    "Stats source: HealthKit samples",
    "HealthKit segment markers: not used"
  ],
  "workout" : {
    "averageHeartRate" : 126.66639261639263,
    "averagePower" : 187.40861466821886,
    "cadenceSpm" : 176.6048500086226,
    "deviceName" : "Apple Watch Apple Inc. Watch",
    "distanceMeters" : 5701.994884913457,
    "durationSeconds" : 2216.545009970665,
    "elapsedSeconds" : 2216.545009970665,
    "endDate" : "2026-06-04T12:24:03Z",
    "id" : "0F92DFB9-F99B-4950-9D00-6B499F0714FB",
    "maxHeartRate" : 141,
    "paceSecondsPerKm" : 388.7314974335174,
    "sourceID" : "0F92DFB9-F99B-4950-9D00-6B499F0714FB",
    "sourceName" : "Adriel’s Apple Watch",
    "startDate" : "2026-06-04T11:47:06Z"
  },
  "workoutActivities" : [
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 1,
      "alignedPlannedStepLabel" : "Work 1",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "crossingDistanceSampleEndOffsetSeconds" : 2194.2983305454254,
      "durationSeconds" : 2195.633292078972,
      "endDate" : "2026-06-04T12:23:42Z",
      "endOffsetSeconds" : 2195.633292078972,
      "events" : [
        {
          "durationSeconds" : 386.68887984752655,
          "endDate" : "2026-06-04T11:53:33Z",
          "endOffsetSeconds" : 386.68887984752655,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1003.7724266026452,
          "renderedSegmentMarkerDurationSeconds" : 386.68887984752655,
          "renderedSegmentMarkerEndOffsetSeconds" : 386.68887984752655,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-04T11:47:06Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 621.0999114513397,
          "endDate" : "2026-06-04T11:57:28Z",
          "endOffsetSeconds" : 621.0999114513397,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1610.1672375527128,
          "renderedSegmentMarkerDurationSeconds" : 621.0999114513397,
          "renderedSegmentMarkerEndOffsetSeconds" : 621.0999114513397,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-04T11:47:06Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 382.7223094701767,
          "endDate" : "2026-06-04T11:59:56Z",
          "endOffsetSeconds" : 769.4111893177032,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 996.068039814211,
          "renderedSegmentMarkerDurationSeconds" : 382.7223094701767,
          "renderedSegmentMarkerEndOffsetSeconds" : 769.4111893177032,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 386.68887984752655,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-04T11:53:33Z",
          "startOffsetSeconds" : 386.68887984752655,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 621.9483083486557,
          "endDate" : "2026-06-04T12:07:49Z",
          "endOffsetSeconds" : 1243.0482197999954,
          "index" : 4,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1607.9588615279479,
          "renderedSegmentMarkerDurationSeconds" : 621.9483083486557,
          "renderedSegmentMarkerEndOffsetSeconds" : 1243.0482197999954,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 621.0999114513397,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-04T11:57:28Z",
          "startOffsetSeconds" : 621.0999114513397,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 389.75526201725006,
          "endDate" : "2026-06-04T12:06:26Z",
          "endOffsetSeconds" : 1159.1664513349533,
          "index" : 5,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1000.4930034533543,
          "renderedSegmentMarkerDurationSeconds" : 389.75526201725006,
          "renderedSegmentMarkerEndOffsetSeconds" : 1159.1664513349533,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 769.4111893177032,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-04T11:59:56Z",
          "startOffsetSeconds" : 769.4111893177032,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 388.4484142065048,
          "endDate" : "2026-06-04T12:12:54Z",
          "endOffsetSeconds" : 1547.6148655414581,
          "index" : 6,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 999.64426880357,
          "renderedSegmentMarkerDurationSeconds" : 388.4484142065048,
          "renderedSegmentMarkerEndOffsetSeconds" : 1547.6148655414581,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1159.1664513349533,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-04T12:06:26Z",
          "startOffsetSeconds" : 1159.1664513349533,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 629.0091283321381,
          "endDate" : "2026-06-04T12:18:18Z",
          "endOffsetSeconds" : 1872.0573481321335,
          "index" : 7,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1609.4270264548213,
          "renderedSegmentMarkerDurationSeconds" : 629.0091283321381,
          "renderedSegmentMarkerEndOffsetSeconds" : 1872.0573481321335,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1243.0482197999954,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-04T12:07:49Z",
          "startOffsetSeconds" : 1243.0482197999954,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 391.7193866968155,
          "endDate" : "2026-06-04T12:19:26Z",
          "endOffsetSeconds" : 1939.3342522382736,
          "index" : 8,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1000.1186303624613,
          "renderedSegmentMarkerDurationSeconds" : 391.7193866968155,
          "renderedSegmentMarkerEndOffsetSeconds" : 1939.3342522382736,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1547.6148655414581,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-04T12:12:54Z",
          "startOffsetSeconds" : 1547.6148655414581,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 340.249081492424,
          "endDate" : "2026-06-04T12:23:59Z",
          "endOffsetSeconds" : 2212.3064296245575,
          "index" : 9,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 867.3266701412313,
          "renderedSegmentMarkerDurationSeconds" : 340.249081492424,
          "renderedSegmentMarkerEndOffsetSeconds" : 2212.3064296245575,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1872.0573481321335,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-04T12:18:18Z",
          "startOffsetSeconds" : 1872.0573481321335,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 272.9721773862839,
          "endDate" : "2026-06-04T12:23:59Z",
          "endOffsetSeconds" : 2212.3064296245575,
          "index" : 10,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 694.7834266404716,
          "renderedSegmentMarkerDurationSeconds" : 272.9721773862839,
          "renderedSegmentMarkerEndOffsetSeconds" : 2212.3064296245575,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1939.3342522382736,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-04T12:19:26Z",
          "startOffsetSeconds" : 1939.3342522382736,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        }
      ],
      "eventsSummary" : "10 event(s): HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "DB0F0842-B9B7-4067-8DEB-DC84178E2B1F",
      "index" : 1,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath"
      ],
      "nearestRawEventEndDeltaSeconds" : 16.673137545585632,
      "nearestRawEventEndOffsetSeconds" : 2212.3064296245575,
      "nearestRawEventStartDeltaSeconds" : 0,
      "nearestRawEventStartOffsetSeconds" : 0,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : -1.3349615335464478,
      "nearestReconstructedIntervalEndOffsetSeconds" : 2194.2983305454254,
      "nearestReconstructedIntervalIndex" : 1,
      "nearestReconstructedIntervalLabel" : "Work 1",
      "nearestSegmentMarkerEndDeltaSeconds" : 16.673137545585632,
      "nearestSegmentMarkerEndOffsetSeconds" : 2212.3064296245575,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : 0,
      "nearestSegmentMarkerStartOffsetSeconds" : 0,
      "nextDistanceSampleEndOffsetSeconds" : 2196.870908141136,
      "previousDistanceSampleEndOffsetSeconds" : 2191.725753903389,
      "startDate" : "2026-06-04T11:47:06Z",
      "startOffsetSeconds" : 0,
      "statistics" : [
        {
          "endDate" : "2026-06-04T12:23:42Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-04T11:47:06Z",
          "sum" : 346.71064042676784,
          "summary" : "ActiveEnergyBurned: sum 346.7 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-04T12:23:42Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-04T11:47:06Z",
          "sum" : 53.770679502585764,
          "summary" : "BasalEnergyBurned: sum 53.8 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-04T12:23:42Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-04T11:47:06Z",
          "sum" : 5657.211036200994,
          "summary" : "DistanceWalkingRunning: sum 5657.2 m",
          "unit" : "m"
        },
        {
          "average" : 125.97895513627044,
          "endDate" : "2026-06-04T12:23:42Z",
          "maximum" : 141,
          "minimum" : 58,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-04T11:47:06Z",
          "summary" : "HeartRate: avg 126.0 bpm, min 58.0 bpm, max 141.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 261.3243902439024,
          "endDate" : "2026-06-04T12:23:42Z",
          "maximum" : 285,
          "minimum" : 226,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-04T11:47:06Z",
          "summary" : "RunningGroundContactTime: avg 261.3 ms, min 226.0 ms, max 285.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 187.3967136150235,
          "endDate" : "2026-06-04T12:23:42Z",
          "maximum" : 224,
          "minimum" : 60,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-04T11:47:06Z",
          "summary" : "RunningPower: avg 187.4 W, min 60.0 W, max 224.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.6338819459078273,
          "endDate" : "2026-06-04T12:23:42Z",
          "maximum" : 3.251624693629397,
          "minimum" : 0.9139416494256192,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-04T11:47:06Z",
          "summary" : "RunningSpeed: avg 2.6 m\/s, min 0.9 m\/s, max 3.3 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.8845721271393645,
          "endDate" : "2026-06-04T12:23:42Z",
          "maximum" : 1.01,
          "minimum" : 0.79,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-04T11:47:06Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.8 m, max 1.0 m",
          "unit" : "m"
        },
        {
          "average" : 7.790510948905108,
          "endDate" : "2026-06-04T12:23:42Z",
          "maximum" : 8.5,
          "minimum" : 6.5,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-04T11:47:06Z",
          "summary" : "RunningVerticalOscillation: avg 7.8 cm, min 6.5 cm, max 8.5 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-04T12:23:42Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-04T11:47:06Z",
          "sum" : 6467.001024904987,
          "summary" : "StepCount: sum 6467.0 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 346.7 kcal; BasalEnergyBurned: sum 53.8 kcal; DistanceWalkingRunning: sum 5657.2 m; HeartRate: avg 126.0 bpm, min 58.0 bpm, max 141.0 bpm"
    }
  ],
  "workoutKitPlanAudit" : {
    "displayName" : "Thursday Recovery 5.65k",
    "planID" : "69C2E08A-9784-4EB2-9D8B-E3824DF4E9EE",
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