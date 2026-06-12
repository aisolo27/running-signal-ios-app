# RunSignal Raw HealthKit Debug Export

Generated: 2026-06-12T19:49:28Z

## Workout

| Field | Value |
|---|---|
| Workout ID | 9C09006E-9850-435C-95F5-A0AA0BE42A33 |
| Source | Adriel’s Apple Watch |
| Source ID | 9C09006E-9850-435C-95F5-A0AA0BE42A33 |
| Device | Apple Watch Apple Inc. Watch |
| Start | Jun 5, 2026 |
| End | Jun 5, 2026 |
| Duration | 38:16 |
| Elapsed | 38:16 |
| Distance | 6.96 km |
| Avg pace | 5:30 /km |
| Avg HR | 151 bpm |
| Max HR | 178 bpm |
| Cadence | 183 spm |
| Power | 218 W |

## Evidence Counts

| Metric | Count |
|---|---:|
| Heart rate | 461 |
| Speed | 892 |
| Distance | 892 |
| Active energy | 892 |
| Power | 889 |
| Cadence | 892 |
| Step count | 892 |
| Stride length | 424 |
| Vertical oscillation | 426 |
| Ground contact | 424 |
| Route points | 2296 |
| Events | 13 |

## WorkoutKit Plan Audit

- Status: Available
- Plan type: Custom workout
- Plan ID: B7CBD195-881D-48E9-9A5B-7E0567FA52AB
- Display name: Friday Tempo 6.5km
- Activity: HKWorkoutActivityType(rawValue: 37)
- Warmup: goal 2 km, alert pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current
- Block 1: 1x, 1 step(s)
- Block 1 step 1: Work - goal 2 km, alert pace range 4:10-4:20 /km, speed 3.85 m/s-4 m/s, metric current
- Cooldown: goal 2.50 km, alert pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current

## Raw HKWorkoutEvent Inventory

Debug-only inventory of public `HKWorkoutEvent` date windows and metadata keys. These rows are not Apple Fitness interval truth.

| Row | Event Type | Label | Start Offset | End Offset | Duration | Metadata Keys | Rendered Marker Window | Marker Distance | Marker Kind | Used By Segment Rendering | Excluded / Filtered Reason | Debug-Only Reason |
|---:|---|---|---:|---:|---:|---|---:|---:|---|---|---|---|
| 1 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 6:10 | 370.4 s | Unavailable | 0:00-6:10 | 1.01 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 2 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 10:00 | 599.7 s | Unavailable | 0:00-10:00 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 3 | HKWorkoutEventType(rawValue: 7) | Unavailable | 6:10 | 12:27 | 376.3 s | Unavailable | 6:10-12:27 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 4 | HKWorkoutEventType(rawValue: 7) | Unavailable | 10:00 | 17:40 | 460.4 s | Unavailable | 10:00-17:40 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 5 | HKWorkoutEventType(rawValue: 7) | Unavailable | 12:27 | 16:43 | 256.0 s | Unavailable | 12:27-16:43 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 6 | HKWorkoutEventType(rawValue: 7) | Unavailable | 16:43 | 20:58 | 255.0 s | Unavailable | 16:43-20:58 | 1.00 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 7 | HKWorkoutEventType(rawValue: 7) | Unavailable | 17:40 | 25:57 | 496.9 s | Unavailable | 17:40-25:57 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 8 | HKWorkoutEventType(rawValue: 7) | Unavailable | 20:58 | 26:58 | 360.5 s | Unavailable | 20:58-26:58 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 9 | HKWorkoutEventType(rawValue: 7) | Unavailable | 25:57 | 35:13 | 555.6 s | Unavailable | 25:57-35:13 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 10 | HKWorkoutEventType(rawValue: 7) | Unavailable | 26:58 | 32:42 | 343.9 s | Unavailable | 26:58-32:42 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 11 | HKWorkoutEventType(rawValue: 7) | Unavailable | 32:42 | 38:15 | 333.2 s | Unavailable | 32:42-38:15 | 0.95 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 12 | HKWorkoutEventType(rawValue: 7) | Unavailable | 35:13 | 38:15 | 182.8 s | Unavailable | 35:13-38:15 | 0.52 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 13 | HKWorkoutEventType(rawValue: 1) | Unavailable | 38:16 | 38:16 | 0.0 s | Unavailable | Unavailable | Unavailable | Unavailable | No | Excluded from segment rendering: zero or negative duration. | No rendered segment marker candidate. |

## WorkoutKit Reconstructed Intervals

Planned structure source: WorkoutKit when available. Measured stats source: HealthKit samples.

| Row | Label | Goal | Target | Distance | Time | Pace | Avg HR | Max HR | Power | Start Offset | End Offset | Boundary Strategy | Boundary Adjustment | Overshoot | Confidence | Notes |
|---:|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---:|---:|---|---|
| 1 | Warmup | 2 km | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 2.01 km | 12:27 | 6:12 /km | 133 bpm | 147 bpm | 194 W | 0:00 | 12:27 | crossing sample end | 2.5 s | 5.5 m | High | Distance-goal boundary: crossing sample end, adjustment +2.5s, overshoot 5.5 m |
| 2 | Work 1 | 2 km | pace range 4:10-4:20 /km, speed 3.85 m/s-4 m/s, metric current | 2.01 km | 8:32 | 4:15 /km | 171 bpm | 178 bpm | 279 W | 12:27 | 20:59 | crossing sample end | 2.1 s | 8.6 m | High | Distance-goal boundary: crossing sample end, adjustment +2.1s, overshoot 8.6 m |
| 3 | Cooldown | 2.50 km | pace range 6:00-6:30 /km, speed 2.56 m/s-2.78 m/s, metric current | 2.51 km | 14:40 | 5:51 /km | 155 bpm | 178 bpm | 206 W | 20:59 | 35:38 | crossing sample end | 2.5 s | 7.7 m | High | Distance-goal boundary: crossing sample end, adjustment +2.5s, overshoot 7.7 m |
| 4 | Open / Extra | Open | Target unavailable | 0.44 km | 2:38 | 5:59 /km | 154 bpm | 156 bpm | 207 W | 35:38 | 38:16 |  |  |  | Medium | Extra tail after planned WorkoutKit steps |

Notes: Plan source: WorkoutKit · Window source: Plan-derived from HealthKit distance/time samples · Stats source: HealthKit samples · HealthKit segment markers: not used

## WorkoutKit Boundary Diagnostics

### Row 1: Warmup

| Field | Value |
|---|---:|
| Target distance | 2000.0 m |
| Start offset | 0:00 |
| End offset | 12:27 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 2.5 s |
| Overshoot | 5.5 m |
| Cumulative distance at start | 0.0 m |
| Cumulative distance at end | 2005.5 m |
| Interpolation fraction | 0.028 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 12:21 | 12:24 | 1991.5 m | 1999.8 m |
| Crossing | 12:24 | 12:27 | 1999.8 m | 2005.5 m |
| Next | 12:27 | 12:29 | 2005.5 m | 2008.5 m |

### Row 2: Work 1

| Field | Value |
|---|---:|
| Target distance | 2000.0 m |
| Start offset | 12:27 |
| End offset | 20:59 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 2.1 s |
| Overshoot | 8.6 m |
| Cumulative distance at start | 2005.5 m |
| Cumulative distance at end | 4014.1 m |
| Interpolation fraction | 0.186 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 20:53 | 20:56 | 3992.7 m | 4003.6 m |
| Crossing | 20:56 | 20:59 | 4003.6 m | 4014.1 m |
| Next | 20:59 | 21:01 | 4014.1 m | 4024.4 m |

### Row 3: Cooldown

| Field | Value |
|---|---:|
| Target distance | 2500.0 m |
| Start offset | 20:59 |
| End offset | 35:38 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 2.5 s |
| Overshoot | 7.7 m |
| Cumulative distance at start | 4014.1 m |
| Cumulative distance at end | 6521.8 m |
| Interpolation fraction | 0.027 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 35:33 | 35:36 | 6506.5 m | 6513.9 m |
| Crossing | 35:36 | 35:38 | 6513.9 m | 6521.8 m |
| Next | 35:38 | 35:41 | 6521.8 m | 6529.8 m |

### Row 4: Open / Extra Tail

| Field | Value |
|---|---:|
| Planned final step end offset | 35:38 |
| Workout end offset | 38:16 |
| Remaining seconds | 157.8 s |
| Remaining meters | 440.0 m |
| Final distance sample offset | 38:13 |
| Final distance sample cumulative | 6961.8 m |
| Last HR sample offset | 38:14 |
| Last power sample offset | 38:13 |
| Last cadence sample offset | 38:13 |
| Reason | Remaining workout time or distance exceeded Open / Extra threshold after planned WorkoutKit steps. |

## HealthKit Segment Markers

Raw debug only. HealthKit Segment Markers must not be promoted as Apple Fitness interval rows.

| Row | Label | Marker Kind | Source | Distance | Time | Pace | Avg HR | Start Offset | End Offset | Confidence | Caveats |
|---:|---|---|---|---:|---:|---:|---:|---:|---:|---|---|
| 1 | Unknown | Split marker | HealthKit segment pattern | 1.01 km | 6:10 | 6:08 /km | 127 bpm | 0:00 | 6:10 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. |
| 2 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 10:00 | 6:11 /km | 130 bpm | 0:00 | 10:00 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 3 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:16 | 6:17 /km | 138 bpm | 6:10 | 12:27 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 4 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 7:40 | 4:45 /km | 159 bpm | 10:00 | 17:40 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 5 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 4:16 | 4:15 /km | 167 bpm | 12:27 | 16:43 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 6 | Unknown | Split marker | HealthKit segment pattern | 1.00 km | 4:15 | 4:15 /km | 174 bpm | 16:43 | 20:58 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. |
| 7 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 8:17 | 5:09 /km | 165 bpm | 17:40 | 25:57 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 8 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:01 | 6:02 /km | 157 bpm | 20:58 | 26:58 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 9 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 9:16 | 5:45 /km | 154 bpm | 25:57 | 35:13 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 10 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 5:44 | 5:43 /km | 155 bpm | 26:58 | 32:42 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 11 | Unknown | Split marker | HealthKit segment pattern | 0.95 km | 5:33 | 5:49 /km | 154 bpm | 32:42 | 38:15 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. |
| 12 | Unknown | Overlapping segment marker | HealthKit segment pattern | 0.52 km | 3:03 | 5:54 /km | 154 bpm | 35:13 | 38:15 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |

## Planned Step Boundary Comparison

Debug-only comparison helper for FIT/Apple boundary investigation. The FIT lap end offset is intentionally a manual placeholder; RunSignal does not read FIT at runtime.

| Row | Planned Step | Goal | RunSignal End | FIT Lap End | Nearest Raw Event End | Event Delta | Nearest Segment End | Segment Delta | Previous Sample End | Crossing Sample End | Next Sample End | Warning |
|---:|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 1 | Warmup | 2 km | 746.6 s | Manual FIT placeholder | 746.7 s | 0.1 s | 746.7 s | 0.1 s | 744.0 s | 746.6 s | 749.2 s |  |
| 2 | Work 1 | 2 km | 1258.5 s | Manual FIT placeholder | 1257.7 s | -0.8 s | 1257.7 s | -0.8 s | 1256.0 s | 1258.5 s | 1261.1 s |  |
| 3 | Cooldown | 2.50 km | 2138.4 s | Manual FIT placeholder | 2112.5 s | -25.8 s | 2112.5 s | -25.8 s | 2135.8 s | 2138.4 s | 2140.9 s | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |
| 4 | Open / Extra | Open | 2296.1 s | Manual FIT placeholder | 2295.3 s | -0.8 s | 2295.3 s | -0.8 s | Unavailable | Unavailable | Unavailable |  |

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
          "endCumulativeDistanceMeters" : 2005.5431161262095,
          "endDate" : "2026-06-05T12:06:20Z",
          "endOffsetSeconds" : 746.6089458465576,
          "startCumulativeDistanceMeters" : 1999.838293876499,
          "startDate" : "2026-06-05T12:06:17Z",
          "startOffsetSeconds" : 744.0364048480988
        },
        "cumulativeDistanceAtEndMeters" : 2005.5431161262095,
        "cumulativeDistanceAtStartMeters" : 0,
        "interpolationFraction" : 0.02834551479833867,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2008.505719098961,
          "endDate" : "2026-06-05T12:06:22Z",
          "endOffsetSeconds" : 749.1814864873886,
          "startCumulativeDistanceMeters" : 2005.5431161262095,
          "startDate" : "2026-06-05T12:06:20Z",
          "startOffsetSeconds" : 746.6089458465576
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 1999.838293876499,
          "endDate" : "2026-06-05T12:06:17Z",
          "endOffsetSeconds" : 744.0364048480988,
          "startCumulativeDistanceMeters" : 1991.4634173170198,
          "startDate" : "2026-06-05T12:06:15Z",
          "startOffsetSeconds" : 741.4638620615005
        },
        "targetDistanceMeters" : 2000
      },
      "index" : 1,
      "label" : "Warmup"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 4014.0946027147584,
          "endDate" : "2026-06-05T12:14:52Z",
          "endOffsetSeconds" : 1258.5366969108582,
          "startCumulativeDistanceMeters" : 4003.5900940666907,
          "startDate" : "2026-06-05T12:14:49Z",
          "startOffsetSeconds" : 1255.9641867876053
        },
        "cumulativeDistanceAtEndMeters" : 4014.0946027147584,
        "cumulativeDistanceAtStartMeters" : 2005.5431161262095,
        "interpolationFraction" : 0.18592226680474952,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 4024.4142980310135,
          "endDate" : "2026-06-05T12:14:54Z",
          "endOffsetSeconds" : 1261.1092076301575,
          "startCumulativeDistanceMeters" : 4014.0946027147584,
          "startDate" : "2026-06-05T12:14:52Z",
          "startOffsetSeconds" : 1258.5366969108582
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 4003.5900940666907,
          "endDate" : "2026-06-05T12:14:49Z",
          "endOffsetSeconds" : 1255.9641867876053,
          "startCumulativeDistanceMeters" : 3992.712427934166,
          "startDate" : "2026-06-05T12:14:47Z",
          "startOffsetSeconds" : 1253.3916746377945
        },
        "targetDistanceMeters" : 2000
      },
      "index" : 2,
      "label" : "Work 1"
    },
    {
      "distanceBoundary" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 6521.780760779278,
          "endDate" : "2026-06-05T12:29:32Z",
          "endOffsetSeconds" : 2138.373197555542,
          "startCumulativeDistanceMeters" : 6513.879721211502,
          "startDate" : "2026-06-05T12:29:29Z",
          "startOffsetSeconds" : 2135.800537109375
        },
        "cumulativeDistanceAtEndMeters" : 6521.780760779278,
        "cumulativeDistanceAtStartMeters" : 4014.0946027147584,
        "interpolationFraction" : 0.027196611460145168,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 6529.8358674973715,
          "endDate" : "2026-06-05T12:29:34Z",
          "endOffsetSeconds" : 2140.9458624124527,
          "startCumulativeDistanceMeters" : 6521.780760779278,
          "startDate" : "2026-06-05T12:29:32Z",
          "startOffsetSeconds" : 2138.373197555542
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 6513.879721211502,
          "endDate" : "2026-06-05T12:29:29Z",
          "endOffsetSeconds" : 2135.800537109375,
          "startCumulativeDistanceMeters" : 6506.46263961005,
          "startDate" : "2026-06-05T12:29:26Z",
          "startOffsetSeconds" : 2133.2278796434402
        },
        "targetDistanceMeters" : 2500
      },
      "index" : 3,
      "label" : "Cooldown"
    },
    {
      "index" : 4,
      "label" : "Open \/ Extra",
      "tail" : {
        "creationReason" : "Remaining workout time or distance exceeded Open \/ Extra threshold after planned WorkoutKit steps.",
        "finalDistanceSampleCumulativeDistanceMeters" : 6961.794989385642,
        "finalDistanceSampleOffsetSeconds" : 2292.7333512306213,
        "lastCadenceSampleOffsetSeconds" : 2292.7333512306213,
        "lastHeartRateSampleOffsetSeconds" : 2293.805965900421,
        "lastPowerSampleOffsetSeconds" : 2292.7333512306213,
        "plannedFinalStepEndOffsetSeconds" : 2138.373197555542,
        "remainingMeters" : 440.01422860636376,
        "remainingSeconds" : 157.76232945919037,
        "workoutEndOffsetSeconds" : 2296.1355270147324
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
    "activeEnergy" : 892,
    "cadence" : 892,
    "distance" : 892,
    "events" : 13,
    "groundContact" : 424,
    "heartRate" : 461,
    "power" : 889,
    "routePoints" : 2296,
    "speed" : 892,
    "stepCount" : 892,
    "strideLength" : 424,
    "verticalOscillation" : 426
  },
  "generatedAt" : "2026-06-12T19:49:28Z",
  "plannedStepBoundaryComparisons" : [
    {
      "crossingDistanceSampleEndOffsetSeconds" : 746.6089458465576,
      "index" : 1,
      "nearestRawEventEndDeltaSeconds" : 0.07291996479034424,
      "nearestRawEventEndOffsetSeconds" : 746.681865811348,
      "nearestRawEventStartOffsetSeconds" : 370.35203897953033,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 0.07291996479034424,
      "nearestSegmentMarkerEndOffsetSeconds" : 746.681865811348,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 370.35203897953033,
      "nextDistanceSampleEndOffsetSeconds" : 749.1814864873886,
      "plannedGoalDisplayText" : "2 km",
      "plannedStepLabel" : "Warmup",
      "previousDistanceSampleEndOffsetSeconds" : 744.0364048480988,
      "reconstructedEndOffsetSeconds" : 746.6089458465576,
      "reconstructedLabel" : "Warmup"
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1258.5366969108582,
      "index" : 2,
      "nearestRawEventEndDeltaSeconds" : -0.8490381240844727,
      "nearestRawEventEndOffsetSeconds" : 1257.6876587867737,
      "nearestRawEventStartOffsetSeconds" : 1002.7201548814774,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -0.8490381240844727,
      "nearestSegmentMarkerEndOffsetSeconds" : 1257.6876587867737,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1002.7201548814774,
      "nextDistanceSampleEndOffsetSeconds" : 1261.1092076301575,
      "plannedGoalDisplayText" : "2 km",
      "plannedStepLabel" : "Work 1",
      "previousDistanceSampleEndOffsetSeconds" : 1255.9641867876053,
      "reconstructedEndOffsetSeconds" : 1258.5366969108582,
      "reconstructedLabel" : "Work 1"
    },
    {
      "crossingDistanceSampleEndOffsetSeconds" : 2138.373197555542,
      "index" : 3,
      "nearestRawEventEndDeltaSeconds" : -25.83899986743927,
      "nearestRawEventEndOffsetSeconds" : 2112.5341976881027,
      "nearestRawEventStartOffsetSeconds" : 1556.9071568250656,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -25.83899986743927,
      "nearestSegmentMarkerEndOffsetSeconds" : 2112.5341976881027,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1556.9071568250656,
      "nextDistanceSampleEndOffsetSeconds" : 2140.9458624124527,
      "plannedGoalDisplayText" : "2.50 km",
      "plannedStepLabel" : "Cooldown",
      "previousDistanceSampleEndOffsetSeconds" : 2135.800537109375,
      "reconstructedEndOffsetSeconds" : 2138.373197555542,
      "reconstructedLabel" : "Cooldown",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    },
    {
      "index" : 4,
      "nearestRawEventEndDeltaSeconds" : -0.829500675201416,
      "nearestRawEventEndOffsetSeconds" : 2295.306026339531,
      "nearestRawEventStartOffsetSeconds" : 1962.0940775871277,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -0.829500675201416,
      "nearestSegmentMarkerEndOffsetSeconds" : 2295.306026339531,
      "nearestSegmentMarkerKind" : "splitMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1962.0940775871277,
      "plannedGoalDisplayText" : "Open",
      "reconstructedEndOffsetSeconds" : 2296.1355270147324,
      "reconstructedLabel" : "Open \/ Extra"
    }
  ],
  "rawWorkoutEvents" : [
    {
      "durationSeconds" : 370.35203897953033,
      "endDate" : "2026-06-05T12:00:04Z",
      "endOffsetSeconds" : 370.35203897953033,
      "index" : 1,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1007.4621388893975,
      "renderedSegmentMarkerDurationSeconds" : 370.35203897953033,
      "renderedSegmentMarkerEndOffsetSeconds" : 370.35203897953033,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-05T11:53:53Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 599.6764123439789,
      "endDate" : "2026-06-05T12:03:53Z",
      "endOffsetSeconds" : 599.6764123439789,
      "index" : 2,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1614.9585770679528,
      "renderedSegmentMarkerDurationSeconds" : 599.6764123439789,
      "renderedSegmentMarkerEndOffsetSeconds" : 599.6764123439789,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-05T11:53:53Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 376.3298268318176,
      "endDate" : "2026-06-05T12:06:20Z",
      "endOffsetSeconds" : 746.681865811348,
      "index" : 3,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 998.1649537155631,
      "renderedSegmentMarkerDurationSeconds" : 376.3298268318176,
      "renderedSegmentMarkerEndOffsetSeconds" : 746.681865811348,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 370.35203897953033,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-05T12:00:04Z",
      "startOffsetSeconds" : 370.35203897953033,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 460.3710551261902,
      "endDate" : "2026-06-05T12:11:33Z",
      "endOffsetSeconds" : 1060.047467470169,
      "index" : 4,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1612.5969429928446,
      "renderedSegmentMarkerDurationSeconds" : 460.3710551261902,
      "renderedSegmentMarkerEndOffsetSeconds" : 1060.047467470169,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 599.6764123439789,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-05T12:03:53Z",
      "startOffsetSeconds" : 599.6764123439789,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 256.0382890701294,
      "endDate" : "2026-06-05T12:10:36Z",
      "endOffsetSeconds" : 1002.7201548814774,
      "index" : 5,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1003.5624618075121,
      "renderedSegmentMarkerDurationSeconds" : 256.0382890701294,
      "renderedSegmentMarkerEndOffsetSeconds" : 1002.7201548814774,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 746.681865811348,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-05T12:06:20Z",
      "startOffsetSeconds" : 746.681865811348,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 254.96750390529633,
      "endDate" : "2026-06-05T12:14:51Z",
      "endOffsetSeconds" : 1257.6876587867737,
      "index" : 6,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1001.4381121622223,
      "renderedSegmentMarkerDurationSeconds" : 254.96750390529633,
      "renderedSegmentMarkerEndOffsetSeconds" : 1257.6876587867737,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1002.7201548814774,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-05T12:10:36Z",
      "startOffsetSeconds" : 1002.7201548814774,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 496.85968935489655,
      "endDate" : "2026-06-05T12:19:50Z",
      "endOffsetSeconds" : 1556.9071568250656,
      "index" : 7,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1607.978358852993,
      "renderedSegmentMarkerDurationSeconds" : 496.85968935489655,
      "renderedSegmentMarkerEndOffsetSeconds" : 1556.9071568250656,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1060.047467470169,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-05T12:11:33Z",
      "startOffsetSeconds" : 1060.047467470169,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 360.54478573799133,
      "endDate" : "2026-06-05T12:20:51Z",
      "endOffsetSeconds" : 1618.232444524765,
      "index" : 8,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 995.2061292675457,
      "renderedSegmentMarkerDurationSeconds" : 360.54478573799133,
      "renderedSegmentMarkerEndOffsetSeconds" : 1618.232444524765,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1257.6876587867737,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-05T12:14:51Z",
      "startOffsetSeconds" : 1257.6876587867737,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 555.6270408630371,
      "endDate" : "2026-06-05T12:29:06Z",
      "endOffsetSeconds" : 2112.5341976881027,
      "index" : 9,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1610.1716531493084,
      "renderedSegmentMarkerDurationSeconds" : 555.6270408630371,
      "renderedSegmentMarkerEndOffsetSeconds" : 2112.5341976881027,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1556.9071568250656,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-05T12:19:50Z",
      "startOffsetSeconds" : 1556.9071568250656,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 343.86163306236267,
      "endDate" : "2026-06-05T12:26:35Z",
      "endOffsetSeconds" : 1962.0940775871277,
      "index" : 10,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1001.7449528674188,
      "renderedSegmentMarkerDurationSeconds" : 343.86163306236267,
      "renderedSegmentMarkerEndOffsetSeconds" : 1962.0940775871277,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1618.232444524765,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-05T12:20:51Z",
      "startOffsetSeconds" : 1618.232444524765,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 333.21194875240326,
      "endDate" : "2026-06-05T12:32:08Z",
      "endOffsetSeconds" : 2295.306026339531,
      "index" : 11,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 954.2162406759826,
      "renderedSegmentMarkerDurationSeconds" : 333.21194875240326,
      "renderedSegmentMarkerEndOffsetSeconds" : 2295.306026339531,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1962.0940775871277,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-05T12:26:35Z",
      "startOffsetSeconds" : 1962.0940775871277,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 182.77182865142822,
      "endDate" : "2026-06-05T12:32:08Z",
      "endOffsetSeconds" : 2295.306026339531,
      "index" : 12,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 516.0894573225432,
      "renderedSegmentMarkerDurationSeconds" : 182.77182865142822,
      "renderedSegmentMarkerEndOffsetSeconds" : 2295.306026339531,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 2112.5341976881027,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-05T12:29:06Z",
      "startOffsetSeconds" : 2112.5341976881027,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 0,
      "endDate" : "2026-06-05T12:32:09Z",
      "endOffsetSeconds" : 2296.1355270147324,
      "excludedOrFilteredReason" : "zeroOrNegativeDuration",
      "index" : 13,
      "metadataKeys" : [

      ],
      "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
      "startDate" : "2026-06-05T12:32:09Z",
      "startOffsetSeconds" : 2296.1355270147324,
      "type" : "HKWorkoutEventType(rawValue: 1)",
      "usedBySegmentMarkerRendering" : false
    }
  ],
  "reconstructedIntervals" : [
    {
      "averageHeartRateBpm" : 132.6291390728477,
      "averagePower" : 193.77430555555554,
      "boundaryAdjustmentSeconds" : 2.499621033668518,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 2005.5431161262095,
          "endDate" : "2026-06-05T12:06:20Z",
          "endOffsetSeconds" : 746.6089458465576,
          "startCumulativeDistanceMeters" : 1999.838293876499,
          "startDate" : "2026-06-05T12:06:17Z",
          "startOffsetSeconds" : 744.0364048480988
        },
        "cumulativeDistanceAtEndMeters" : 2005.5431161262095,
        "cumulativeDistanceAtStartMeters" : 0,
        "interpolationFraction" : 0.02834551479833867,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 2008.505719098961,
          "endDate" : "2026-06-05T12:06:22Z",
          "endOffsetSeconds" : 749.1814864873886,
          "startCumulativeDistanceMeters" : 2005.5431161262095,
          "startDate" : "2026-06-05T12:06:20Z",
          "startOffsetSeconds" : 746.6089458465576
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 1999.838293876499,
          "endDate" : "2026-06-05T12:06:17Z",
          "endOffsetSeconds" : 744.0364048480988,
          "startCumulativeDistanceMeters" : 1991.4634173170198,
          "startDate" : "2026-06-05T12:06:15Z",
          "startOffsetSeconds" : 741.4638620615005
        },
        "targetDistanceMeters" : 2000
      },
      "boundaryOvershootMeters" : 5.5431161262094975,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "distanceMeters" : 2005.5431161262095,
      "durationSeconds" : 746.6089458465576,
      "endOffsetSeconds" : 746.6089458465576,
      "index" : 1,
      "label" : "Warmup",
      "maxHeartRateBpm" : 147,
      "paceSecondsPerKm" : 372.2726975267747,
      "plannedGoalDisplayText" : "2 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 2000,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +2.5s, overshoot 5.5 m",
      "startOffsetSeconds" : 0,
      "stepType" : "warmup"
    },
    {
      "averageHeartRateBpm" : 170.5686274509804,
      "averagePower" : 278.85,
      "boundaryAdjustmentSeconds" : 2.0942232608795166,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 4014.0946027147584,
          "endDate" : "2026-06-05T12:14:52Z",
          "endOffsetSeconds" : 1258.5366969108582,
          "startCumulativeDistanceMeters" : 4003.5900940666907,
          "startDate" : "2026-06-05T12:14:49Z",
          "startOffsetSeconds" : 1255.9641867876053
        },
        "cumulativeDistanceAtEndMeters" : 4014.0946027147584,
        "cumulativeDistanceAtStartMeters" : 2005.5431161262095,
        "interpolationFraction" : 0.18592226680474952,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 4024.4142980310135,
          "endDate" : "2026-06-05T12:14:54Z",
          "endOffsetSeconds" : 1261.1092076301575,
          "startCumulativeDistanceMeters" : 4014.0946027147584,
          "startDate" : "2026-06-05T12:14:52Z",
          "startOffsetSeconds" : 1258.5366969108582
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 4003.5900940666907,
          "endDate" : "2026-06-05T12:14:49Z",
          "endOffsetSeconds" : 1255.9641867876053,
          "startCumulativeDistanceMeters" : 3992.712427934166,
          "startDate" : "2026-06-05T12:14:47Z",
          "startOffsetSeconds" : 1253.3916746377945
        },
        "targetDistanceMeters" : 2000
      },
      "boundaryOvershootMeters" : 8.551486588548869,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "distanceMeters" : 2008.5514865885489,
      "durationSeconds" : 511.92775106430054,
      "endOffsetSeconds" : 1258.5366969108582,
      "index" : 2,
      "label" : "Work 1",
      "maxHeartRateBpm" : 178,
      "paceSecondsPerKm" : 254.87409931113646,
      "plannedGoalDisplayText" : "2 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 2000,
      "plannedTargetDisplayText" : "pace range 4:10-4:20 \/km, speed 3.85 m\/s-4 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +2.1s, overshoot 8.6 m",
      "startOffsetSeconds" : 746.6089458465576,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 155.35795454545453,
      "averagePower" : 205.61516034985422,
      "boundaryAdjustmentSeconds" : 2.5026928186416626,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 6521.780760779278,
          "endDate" : "2026-06-05T12:29:32Z",
          "endOffsetSeconds" : 2138.373197555542,
          "startCumulativeDistanceMeters" : 6513.879721211502,
          "startDate" : "2026-06-05T12:29:29Z",
          "startOffsetSeconds" : 2135.800537109375
        },
        "cumulativeDistanceAtEndMeters" : 6521.780760779278,
        "cumulativeDistanceAtStartMeters" : 4014.0946027147584,
        "interpolationFraction" : 0.027196611460145168,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 6529.8358674973715,
          "endDate" : "2026-06-05T12:29:34Z",
          "endOffsetSeconds" : 2140.9458624124527,
          "startCumulativeDistanceMeters" : 6521.780760779278,
          "startDate" : "2026-06-05T12:29:32Z",
          "startOffsetSeconds" : 2138.373197555542
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 6513.879721211502,
          "endDate" : "2026-06-05T12:29:29Z",
          "endOffsetSeconds" : 2135.800537109375,
          "startCumulativeDistanceMeters" : 6506.46263961005,
          "startDate" : "2026-06-05T12:29:26Z",
          "startOffsetSeconds" : 2133.2278796434402
        },
        "targetDistanceMeters" : 2500
      },
      "boundaryOvershootMeters" : 7.6861580645199865,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "distanceMeters" : 2507.68615806452,
      "durationSeconds" : 879.8365006446838,
      "endOffsetSeconds" : 2138.373197555542,
      "index" : 3,
      "label" : "Cooldown",
      "maxHeartRateBpm" : 178,
      "paceSecondsPerKm" : 350.85590667524303,
      "plannedGoalDisplayText" : "2.50 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 2500,
      "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +2.5s, overshoot 7.7 m",
      "startOffsetSeconds" : 1258.5366969108582,
      "stepType" : "cooldown"
    },
    {
      "averageHeartRateBpm" : 154.0625,
      "averagePower" : 207.47540983606558,
      "confidence" : "medium",
      "distanceMeters" : 440.01422860636376,
      "durationSeconds" : 157.76232945919037,
      "endOffsetSeconds" : 2296.1355270147324,
      "index" : 4,
      "label" : "Open \/ Extra",
      "maxHeartRateBpm" : 156,
      "paceSecondsPerKm" : 358.5391544243093,
      "plannedGoalDisplayText" : "Open",
      "plannedGoalType" : "open",
      "sourceNote" : "Extra tail after planned WorkoutKit steps",
      "startOffsetSeconds" : 2138.373197555542,
      "stepType" : "open",
      "tailDiagnostics" : {
        "creationReason" : "Remaining workout time or distance exceeded Open \/ Extra threshold after planned WorkoutKit steps.",
        "finalDistanceSampleCumulativeDistanceMeters" : 6961.794989385642,
        "finalDistanceSampleOffsetSeconds" : 2292.7333512306213,
        "lastCadenceSampleOffsetSeconds" : 2292.7333512306213,
        "lastHeartRateSampleOffsetSeconds" : 2293.805965900421,
        "lastPowerSampleOffsetSeconds" : 2292.7333512306213,
        "plannedFinalStepEndOffsetSeconds" : 2138.373197555542,
        "remainingMeters" : 440.01422860636376,
        "remainingSeconds" : 157.76232945919037,
        "workoutEndOffsetSeconds" : 2296.1355270147324
      }
    }
  ],
  "segmentMarkers" : [
    {
      "averageHeartRateBpm" : 127.2,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1007.4621388893975,
      "durationSeconds" : 370.35203897953033,
      "endOffsetSeconds" : 370.35203897953033,
      "index" : 1,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 367.6088903825187,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 130.27272727272728,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1614.9585770679528,
      "durationSeconds" : 599.6764123439789,
      "endOffsetSeconds" : 599.6764123439789,
      "index" : 2,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 371.3261880888145,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 137.98684210526315,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 998.1649537155631,
      "durationSeconds" : 376.3298268318176,
      "endOffsetSeconds" : 746.681865811348,
      "index" : 3,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 377.02167906313457,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 370.35203897953033
    },
    {
      "averageHeartRateBpm" : 159.3913043478261,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1612.5969429928446,
      "durationSeconds" : 460.3710551261902,
      "endOffsetSeconds" : 1060.047467470169,
      "index" : 4,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 285.48426631132025,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 599.6764123439789
    },
    {
      "averageHeartRateBpm" : 166.76470588235293,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1003.5624618075121,
      "durationSeconds" : 256.0382890701294,
      "endOffsetSeconds" : 1002.7201548814774,
      "index" : 5,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 255.12940032549636,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 746.681865811348
    },
    {
      "averageHeartRateBpm" : 174.37254901960785,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1001.4381121622223,
      "durationSeconds" : 254.96750390529633,
      "endOffsetSeconds" : 1257.6876587867737,
      "index" : 6,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 254.60135859498257,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1002.7201548814774
    },
    {
      "averageHeartRateBpm" : 164.51,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1607.978358852993,
      "durationSeconds" : 496.85968935489655,
      "endOffsetSeconds" : 1556.9071568250656,
      "index" : 7,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 308.9965027323612,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1060.047467470169
    },
    {
      "averageHeartRateBpm" : 156.56944444444446,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 995.2061292675457,
      "durationSeconds" : 360.54478573799133,
      "endOffsetSeconds" : 1618.232444524765,
      "index" : 8,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 362.2815164968347,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1257.6876587867737
    },
    {
      "averageHeartRateBpm" : 154.15315315315314,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1610.1716531493084,
      "durationSeconds" : 555.6270408630371,
      "endOffsetSeconds" : 2112.5341976881027,
      "index" : 9,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 345.0731726498198,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1556.9071568250656
    },
    {
      "averageHeartRateBpm" : 154.66666666666666,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1001.7449528674188,
      "durationSeconds" : 343.86163306236267,
      "endOffsetSeconds" : 1962.0940775871277,
      "index" : 10,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 343.2626559066606,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1618.232444524765
    },
    {
      "averageHeartRateBpm" : 154.1492537313433,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row."
      ],
      "confidence" : "limited",
      "distanceMeters" : 954.2162406759826,
      "durationSeconds" : 333.21194875240326,
      "endOffsetSeconds" : 2295.306026339531,
      "index" : 11,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 349.1996201158245,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1962.0940775871277
    },
    {
      "averageHeartRateBpm" : 154.2972972972973,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 516.0894573225432,
      "durationSeconds" : 182.77182865142822,
      "endOffsetSeconds" : 2295.306026339531,
      "index" : 12,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 354.1475727863984,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 2112.5341976881027
    }
  ],
  "sourceNotes" : [
    "Plan source: WorkoutKit",
    "Window source: Plan-derived from HealthKit distance\/time samples",
    "Stats source: HealthKit samples",
    "HealthKit segment markers: not used"
  ],
  "workout" : {
    "averageHeartRate" : 151.33539537385687,
    "averagePower" : 218.28571428571425,
    "cadenceSpm" : 182.58254223717807,
    "deviceName" : "Apple Watch Apple Inc. Watch",
    "distanceMeters" : 6961.794989385643,
    "durationSeconds" : 2296.1355270147324,
    "elapsedSeconds" : 2296.1355270147324,
    "endDate" : "2026-06-05T12:32:09Z",
    "id" : "9C09006E-9850-435C-95F5-A0AA0BE42A33",
    "maxHeartRate" : 178,
    "paceSecondsPerKm" : 329.8194690472147,
    "sourceID" : "9C09006E-9850-435C-95F5-A0AA0BE42A33",
    "sourceName" : "Adriel’s Apple Watch",
    "startDate" : "2026-06-05T11:53:53Z"
  },
  "workoutKitPlanAudit" : {
    "displayName" : "Friday Tempo 6.5km",
    "planID" : "B7CBD195-881D-48E9-9A5B-7E0567FA52AB",
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
        "plannedGoalDisplayText" : "2 km",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 2000,
        "plannedTargetDisplayText" : "pace range 4:10-4:20 \/km, speed 3.85 m\/s-4 m\/s, metric current",
        "repeatBlockIndex" : 1,
        "repeatIndex" : 1,
        "stepType" : "work"
      },
      {
        "index" : 3,
        "label" : "Cooldown",
        "plannedGoalDisplayText" : "2.50 km",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 2500,
        "plannedTargetDisplayText" : "pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
        "stepType" : "cooldown"
      }
    ],
    "status" : "available",
    "summaryLines" : [
      "Activity: HKWorkoutActivityType(rawValue: 37)",
      "Warmup: goal 2 km, alert pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current",
      "Block 1: 1x, 1 step(s)",
      "Block 1 step 1: Work - goal 2 km, alert pace range 4:10-4:20 \/km, speed 3.85 m\/s-4 m\/s, metric current",
      "Cooldown: goal 2.50 km, alert pace range 6:00-6:30 \/km, speed 2.56 m\/s-2.78 m\/s, metric current"
    ]
  }
}
```