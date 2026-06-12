# RunSignal Raw HealthKit Debug Export

Generated: 2026-06-12T19:45:30Z

## Workout

| Field | Value |
|---|---|
| Workout ID | 1A418F0B-05CB-4316-B1E1-33D34DC7F04B |
| Source | Adriel’s Apple Watch |
| Source ID | 1A418F0B-05CB-4316-B1E1-33D34DC7F04B |
| Device | Apple Watch Apple Inc. Watch |
| Start | Jun 12, 2026 |
| End | Jun 12, 2026 |
| Duration | 32:21 |
| Elapsed | 32:21 |
| Distance | 5.04 km |
| Avg pace | 6:25 /km |
| Avg HR | 127 bpm |
| Max HR | 139 bpm |
| Cadence | 174 spm |
| Power | 187 W |

## Evidence Counts

| Metric | Count |
|---|---:|
| Heart rate | 390 |
| Speed | 752 |
| Distance | 752 |
| Active energy | 753 |
| Power | 751 |
| Cadence | 754 |
| Step count | 754 |
| Stride length | 358 |
| Vertical oscillation | 361 |
| Ground contact | 359 |
| Route points | 1940 |
| Events | 11 |

## WorkoutKit Plan Audit

- Status: Available
- Plan type: Custom workout
- Plan ID: B7CBD195-881D-48E9-9A5B-7E0567FA52AB
- Display name: Friday Easy 5km
- Activity: HKWorkoutActivityType(rawValue: 37)
- Warmup: none
- Block 1: 1x, 1 step(s)
- Block 1 step 1: Work - goal 5 km, alert heart rate zone 2
- Cooldown: none

## Raw HKWorkoutEvent Inventory

Debug-only inventory of public `HKWorkoutEvent` date windows and metadata keys. These rows are not Apple Fitness interval truth.

| Row | Event Type | Label | Start Offset | End Offset | Duration | Metadata Keys | Rendered Marker Window | Marker Distance | Marker Kind | Used By Segment Rendering | Excluded / Filtered Reason | Debug-Only Reason |
|---:|---|---|---:|---:|---:|---|---:|---:|---|---|---|---|
| 1 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 6:23 | 382.7 s | Unavailable | 0:00-6:23 | 1.01 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 2 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 10:14 | 614.2 s | Unavailable | 0:00-10:14 | 1.62 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 3 | HKWorkoutEventType(rawValue: 7) | Unavailable | 6:23 | 12:46 | 383.6 s | Unavailable | 6:23-12:46 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 4 | HKWorkoutEventType(rawValue: 7) | Unavailable | 10:14 | 20:32 | 618.2 s | Unavailable | 10:14-20:32 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 5 | HKWorkoutEventType(rawValue: 7) | Unavailable | 12:46 | 19:08 | 381.8 s | Unavailable | 12:46-19:08 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 6 | HKWorkoutEventType(rawValue: 7) | Unavailable | 19:08 | 25:31 | 383.0 s | Unavailable | 19:08-25:31 | 1.00 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 7 | HKWorkoutEventType(rawValue: 7) | Unavailable | 20:32 | 30:56 | 623.7 s | Unavailable | 20:32-30:56 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 8 | HKWorkoutEventType(rawValue: 7) | Unavailable | 25:31 | 32:01 | 389.4 s | Unavailable | 25:31-32:01 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 9 | HKWorkoutEventType(rawValue: 7) | Unavailable | 30:56 | 32:17 | 80.4 s | Unavailable | 30:56-32:17 | 0.21 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 10 | HKWorkoutEventType(rawValue: 7) | Unavailable | 32:01 | 32:17 | 16.0 s | Unavailable | 32:01-32:17 | 0.04 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 11 | HKWorkoutEventType(rawValue: 1) | Unavailable | 32:21 | 32:21 | 0.0 s | Unavailable | Unavailable | Unavailable | Unavailable | No | Excluded from segment rendering: zero or negative duration. | No rendered segment marker candidate. |

## WorkoutKit Reconstructed Intervals

Planned structure source: WorkoutKit when available. Measured stats source: HealthKit samples.

| Row | Label | Goal | Target | Distance | Time | Pace | Avg HR | Max HR | Power | Start Offset | End Offset | Boundary Strategy | Boundary Adjustment | Overshoot | Confidence | Notes |
|---:|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---:|---:|---|---|
| 1 | Work 1 | 5 km | heart rate zone 2 | 5.00 km | 31:59 | 6:24 /km | 127 bpm | 138 bpm | 187 W | 0:00 | 31:59 | crossing sample end | 0.6 s | 1.6 m | High | Distance-goal boundary: crossing sample end, adjustment +0.6s, overshoot 1.6 m |
| 2 | Open / Extra | Open | Target unavailable | 0.04 km | 0:22 | 8:34 /km | 138 bpm | 139 bpm | 194 W | 31:59 | 32:21 |  |  |  | Medium | Extra tail after planned WorkoutKit steps |

Notes: Plan source: WorkoutKit · Window source: Plan-derived from HealthKit distance/time samples · Stats source: HealthKit samples · HealthKit segment markers: not used

## WorkoutKit Boundary Diagnostics

### Row 1: Work 1

| Field | Value |
|---|---:|
| Target distance | 5000.0 m |
| Start offset | 0:00 |
| End offset | 31:59 |
| Boundary strategy | crossing sample end |
| Boundary adjustment | 0.6 s |
| Overshoot | 1.6 m |
| Cumulative distance at start | 0.0 m |
| Cumulative distance at end | 5001.6 m |
| Interpolation fraction | 0.764 |

| Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
|---|---:|---:|---:|---:|
| Previous | 31:53 | 31:56 | 4987.6 m | 4994.9 m |
| Crossing | 31:56 | 31:59 | 4994.9 m | 5001.6 m |
| Next | 31:59 | 32:01 | 5001.6 m | 5008.8 m |

### Row 2: Open / Extra Tail

| Field | Value |
|---|---:|
| Planned final step end offset | 31:59 |
| Workout end offset | 32:21 |
| Remaining seconds | 22.2 s |
| Remaining meters | 43.2 m |
| Final distance sample offset | 32:14 |
| Final distance sample cumulative | 5044.8 m |
| Last HR sample offset | 32:20 |
| Last power sample offset | 32:17 |
| Last cadence sample offset | 32:19 |
| Reason | Remaining workout time or distance exceeded Open / Extra threshold after planned WorkoutKit steps. |

## HealthKit Segment Markers

Raw debug only. HealthKit Segment Markers must not be promoted as Apple Fitness interval rows.

| Row | Label | Marker Kind | Source | Distance | Time | Pace | Avg HR | Start Offset | End Offset | Confidence | Caveats |
|---:|---|---|---|---:|---:|---:|---:|---:|---:|---|---|
| 1 | Unknown | Split marker | HealthKit segment pattern | 1.01 km | 6:23 | 6:20 /km | 113 bpm | 0:00 | 6:23 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. |
| 2 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.62 km | 10:14 | 6:20 /km | 117 bpm | 0:00 | 10:14 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 3 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:24 | 6:23 /km | 125 bpm | 6:23 | 12:46 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 4 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 10:18 | 6:24 /km | 129 bpm | 10:14 | 20:32 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 5 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:22 | 6:22 /km | 129 bpm | 12:46 | 19:08 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 6 | Unknown | Split marker | HealthKit segment pattern | 1.00 km | 6:23 | 6:23 /km | 133 bpm | 19:08 | 25:31 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. |
| 7 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 10:24 | 6:27 /km | 134 bpm | 20:32 | 30:56 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 8 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 6:29 | 6:29 /km | 135 bpm | 25:31 | 32:01 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 9 | Unknown | Overlapping segment marker | HealthKit segment pattern | 0.21 km | 1:20 | 6:24 /km | 136 bpm | 30:56 | 32:17 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 10 | Unknown | Overlapping segment marker | HealthKit segment pattern | 0.04 km | 0:16 | 7:05 /km | 138 bpm | 32:01 | 32:17 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |

## Planned Step Boundary Comparison

Debug-only comparison helper for FIT/Apple boundary investigation. The FIT lap end offset is intentionally a manual placeholder; RunSignal does not read FIT at runtime.

| Row | Planned Step | Goal | RunSignal End | FIT Lap End | Nearest Raw Event End | Event Delta | Nearest Segment End | Segment Delta | Previous Sample End | Crossing Sample End | Next Sample End | Warning |
|---:|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 1 | Work 1 | 5 km | 1918.5 s | Manual FIT placeholder | 1920.5 s | 2.0 s | 1920.5 s | 2.0 s | 1916.0 s | 1918.5 s | 1921.1 s |  |
| 2 | Open / Extra | Open | 1940.8 s | Manual FIT placeholder | 1936.6 s | -4.2 s | 1936.6 s | -4.2 s | Unavailable | Unavailable | Unavailable | Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end. |

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
          "endCumulativeDistanceMeters" : 5001.583504582988,
          "endDate" : "2026-06-12T12:21:52Z",
          "endOffsetSeconds" : 1918.5470229387283,
          "startCumulativeDistanceMeters" : 4994.86132403207,
          "startDate" : "2026-06-12T12:21:50Z",
          "startOffsetSeconds" : 1915.9744114875793
        },
        "cumulativeDistanceAtEndMeters" : 5001.583504582988,
        "cumulativeDistanceAtStartMeters" : 0,
        "interpolationFraction" : 0.7644358744913725,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 5008.782973735128,
          "endDate" : "2026-06-12T12:21:55Z",
          "endOffsetSeconds" : 1921.1196330785751,
          "startCumulativeDistanceMeters" : 5001.583504582988,
          "startDate" : "2026-06-12T12:21:52Z",
          "startOffsetSeconds" : 1918.5470229387283
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 4994.86132403207,
          "endDate" : "2026-06-12T12:21:50Z",
          "endOffsetSeconds" : 1915.9744114875793,
          "startCumulativeDistanceMeters" : 4987.638073538896,
          "startDate" : "2026-06-12T12:21:47Z",
          "startOffsetSeconds" : 1913.4017992019653
        },
        "targetDistanceMeters" : 5000
      },
      "index" : 1,
      "label" : "Work 1"
    },
    {
      "index" : 2,
      "label" : "Open \/ Extra",
      "tail" : {
        "creationReason" : "Remaining workout time or distance exceeded Open \/ Extra threshold after planned WorkoutKit steps.",
        "finalDistanceSampleCumulativeDistanceMeters" : 5044.816281497944,
        "finalDistanceSampleOffsetSeconds" : 1933.982741355896,
        "lastCadenceSampleOffsetSeconds" : 1939.1279835700989,
        "lastHeartRateSampleOffsetSeconds" : 1940.13254404068,
        "lastPowerSampleOffsetSeconds" : 1936.555363535881,
        "plannedFinalStepEndOffsetSeconds" : 1918.5470229387283,
        "remainingMeters" : 43.23277691495605,
        "remainingSeconds" : 22.209920048713684,
        "workoutEndOffsetSeconds" : 1940.756942987442
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
    "activeEnergy" : 753,
    "cadence" : 754,
    "distance" : 752,
    "events" : 11,
    "groundContact" : 359,
    "heartRate" : 390,
    "power" : 751,
    "routePoints" : 1940,
    "speed" : 752,
    "stepCount" : 754,
    "strideLength" : 358,
    "verticalOscillation" : 361
  },
  "generatedAt" : "2026-06-12T19:45:30Z",
  "plannedStepBoundaryComparisons" : [
    {
      "crossingDistanceSampleEndOffsetSeconds" : 1918.5470229387283,
      "index" : 1,
      "nearestRawEventEndDeltaSeconds" : 1.9665955305099487,
      "nearestRawEventEndOffsetSeconds" : 1920.5136184692383,
      "nearestRawEventStartOffsetSeconds" : 1531.120176076889,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : 1.9665955305099487,
      "nearestSegmentMarkerEndOffsetSeconds" : 1920.5136184692383,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1531.120176076889,
      "nextDistanceSampleEndOffsetSeconds" : 1921.1196330785751,
      "plannedGoalDisplayText" : "5 km",
      "plannedStepLabel" : "Work 1",
      "previousDistanceSampleEndOffsetSeconds" : 1915.9744114875793,
      "reconstructedEndOffsetSeconds" : 1918.5470229387283,
      "reconstructedLabel" : "Work 1"
    },
    {
      "index" : 2,
      "nearestRawEventEndDeltaSeconds" : -4.201579451560974,
      "nearestRawEventEndOffsetSeconds" : 1936.555363535881,
      "nearestRawEventStartOffsetSeconds" : 1856.1311131715775,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -4.201579451560974,
      "nearestSegmentMarkerEndOffsetSeconds" : 1936.555363535881,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 1856.1311131715775,
      "plannedGoalDisplayText" : "Open",
      "reconstructedEndOffsetSeconds" : 1940.756942987442,
      "reconstructedLabel" : "Open \/ Extra",
      "warning" : "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
    }
  ],
  "rawWorkoutEvents" : [
    {
      "durationSeconds" : 382.6612080335617,
      "endDate" : "2026-06-12T11:56:16Z",
      "endOffsetSeconds" : 382.6612080335617,
      "index" : 1,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1006.8670128582658,
      "renderedSegmentMarkerDurationSeconds" : 382.6612080335617,
      "renderedSegmentMarkerEndOffsetSeconds" : 382.6612080335617,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-12T11:49:54Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 614.1962389945984,
      "endDate" : "2026-06-12T12:00:08Z",
      "endOffsetSeconds" : 614.1962389945984,
      "index" : 2,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1615.4936611867922,
      "renderedSegmentMarkerDurationSeconds" : 614.1962389945984,
      "renderedSegmentMarkerEndOffsetSeconds" : 614.1962389945984,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-12T11:49:54Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 383.5910943746567,
      "endDate" : "2026-06-12T12:02:40Z",
      "endOffsetSeconds" : 766.2523024082184,
      "index" : 3,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1000.9319390313299,
      "renderedSegmentMarkerDurationSeconds" : 383.5910943746567,
      "renderedSegmentMarkerEndOffsetSeconds" : 766.2523024082184,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 382.6612080335617,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-12T11:56:16Z",
      "startOffsetSeconds" : 382.6612080335617,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 618.1870852708817,
      "endDate" : "2026-06-12T12:10:26Z",
      "endOffsetSeconds" : 1232.38332426548,
      "index" : 4,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1609.2064833012607,
      "renderedSegmentMarkerDurationSeconds" : 618.1870852708817,
      "renderedSegmentMarkerEndOffsetSeconds" : 1232.38332426548,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 614.1962389945984,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-12T12:00:08Z",
      "startOffsetSeconds" : 614.1962389945984,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 381.8240830898285,
      "endDate" : "2026-06-12T12:09:02Z",
      "endOffsetSeconds" : 1148.0763854980469,
      "index" : 5,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 999.284226662035,
      "renderedSegmentMarkerDurationSeconds" : 381.8240830898285,
      "renderedSegmentMarkerEndOffsetSeconds" : 1148.0763854980469,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 766.2523024082184,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-12T12:02:40Z",
      "startOffsetSeconds" : 766.2523024082184,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 383.04379057884216,
      "endDate" : "2026-06-12T12:15:25Z",
      "endOffsetSeconds" : 1531.120176076889,
      "index" : 6,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1000.0051222730467,
      "renderedSegmentMarkerDurationSeconds" : 383.04379057884216,
      "renderedSegmentMarkerEndOffsetSeconds" : 1531.120176076889,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1148.0763854980469,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-12T12:09:02Z",
      "startOffsetSeconds" : 1148.0763854980469,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 623.7477889060974,
      "endDate" : "2026-06-12T12:20:50Z",
      "endOffsetSeconds" : 1856.1311131715775,
      "index" : 7,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1610.6066247166368,
      "renderedSegmentMarkerDurationSeconds" : 623.7477889060974,
      "renderedSegmentMarkerEndOffsetSeconds" : 1856.1311131715775,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1232.38332426548,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-12T12:10:26Z",
      "startOffsetSeconds" : 1232.38332426548,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 389.39344239234924,
      "endDate" : "2026-06-12T12:21:54Z",
      "endOffsetSeconds" : 1920.5136184692383,
      "index" : 8,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 999.9987363913142,
      "renderedSegmentMarkerDurationSeconds" : 389.39344239234924,
      "renderedSegmentMarkerEndOffsetSeconds" : 1920.5136184692383,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1531.120176076889,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-12T12:15:25Z",
      "startOffsetSeconds" : 1531.120176076889,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 80.42425036430359,
      "endDate" : "2026-06-12T12:22:10Z",
      "endOffsetSeconds" : 1936.555363535881,
      "index" : 9,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 209.50951229325437,
      "renderedSegmentMarkerDurationSeconds" : 80.42425036430359,
      "renderedSegmentMarkerEndOffsetSeconds" : 1936.555363535881,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1856.1311131715775,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-12T12:20:50Z",
      "startOffsetSeconds" : 1856.1311131715775,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 16.04174506664276,
      "endDate" : "2026-06-12T12:22:10Z",
      "endOffsetSeconds" : 1936.555363535881,
      "index" : 10,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 37.72924428195256,
      "renderedSegmentMarkerDurationSeconds" : 16.04174506664276,
      "renderedSegmentMarkerEndOffsetSeconds" : 1936.555363535881,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1920.5136184692383,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-12T12:21:54Z",
      "startOffsetSeconds" : 1920.5136184692383,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 0,
      "endDate" : "2026-06-12T12:22:14Z",
      "endOffsetSeconds" : 1940.756942987442,
      "excludedOrFilteredReason" : "zeroOrNegativeDuration",
      "index" : 11,
      "metadataKeys" : [

      ],
      "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
      "startDate" : "2026-06-12T12:22:14Z",
      "startOffsetSeconds" : 1940.756942987442,
      "type" : "HKWorkoutEventType(rawValue: 1)",
      "usedBySegmentMarkerRendering" : false
    }
  ],
  "reconstructedIntervals" : [
    {
      "averageHeartRateBpm" : 126.81818181818181,
      "averagePower" : 187.34005376344086,
      "boundaryAdjustmentSeconds" : 0.6060149669647217,
      "boundaryDiagnostics" : {
        "crossingSample" : {
          "endCumulativeDistanceMeters" : 5001.583504582988,
          "endDate" : "2026-06-12T12:21:52Z",
          "endOffsetSeconds" : 1918.5470229387283,
          "startCumulativeDistanceMeters" : 4994.86132403207,
          "startDate" : "2026-06-12T12:21:50Z",
          "startOffsetSeconds" : 1915.9744114875793
        },
        "cumulativeDistanceAtEndMeters" : 5001.583504582988,
        "cumulativeDistanceAtStartMeters" : 0,
        "interpolationFraction" : 0.7644358744913725,
        "nextSample" : {
          "endCumulativeDistanceMeters" : 5008.782973735128,
          "endDate" : "2026-06-12T12:21:55Z",
          "endOffsetSeconds" : 1921.1196330785751,
          "startCumulativeDistanceMeters" : 5001.583504582988,
          "startDate" : "2026-06-12T12:21:52Z",
          "startOffsetSeconds" : 1918.5470229387283
        },
        "previousSample" : {
          "endCumulativeDistanceMeters" : 4994.86132403207,
          "endDate" : "2026-06-12T12:21:50Z",
          "endOffsetSeconds" : 1915.9744114875793,
          "startCumulativeDistanceMeters" : 4987.638073538896,
          "startDate" : "2026-06-12T12:21:47Z",
          "startOffsetSeconds" : 1913.4017992019653
        },
        "targetDistanceMeters" : 5000
      },
      "boundaryOvershootMeters" : 1.5835045829880983,
      "boundaryStrategy" : "crossingSampleEnd",
      "confidence" : "high",
      "distanceMeters" : 5001.583504582988,
      "durationSeconds" : 1918.5470229387283,
      "endOffsetSeconds" : 1918.5470229387283,
      "index" : 1,
      "label" : "Work 1",
      "maxHeartRateBpm" : 138,
      "paceSecondsPerKm" : 383.5879219412711,
      "plannedGoalDisplayText" : "5 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 5000,
      "plannedTargetDisplayText" : "heart rate zone 2",
      "sourceNote" : "Distance-goal boundary: crossing sample end, adjustment +0.6s, overshoot 1.6 m",
      "startOffsetSeconds" : 0,
      "stepType" : "work"
    },
    {
      "averageHeartRateBpm" : 138.2,
      "averagePower" : 194.42857142857142,
      "confidence" : "medium",
      "distanceMeters" : 43.23277691495605,
      "durationSeconds" : 22.209920048713684,
      "endOffsetSeconds" : 1940.756942987442,
      "index" : 2,
      "label" : "Open \/ Extra",
      "maxHeartRateBpm" : 139,
      "paceSecondsPerKm" : 513.7287408672177,
      "plannedGoalDisplayText" : "Open",
      "plannedGoalType" : "open",
      "sourceNote" : "Extra tail after planned WorkoutKit steps",
      "startOffsetSeconds" : 1918.5470229387283,
      "stepType" : "open",
      "tailDiagnostics" : {
        "creationReason" : "Remaining workout time or distance exceeded Open \/ Extra threshold after planned WorkoutKit steps.",
        "finalDistanceSampleCumulativeDistanceMeters" : 5044.816281497944,
        "finalDistanceSampleOffsetSeconds" : 1933.982741355896,
        "lastCadenceSampleOffsetSeconds" : 1939.1279835700989,
        "lastHeartRateSampleOffsetSeconds" : 1940.13254404068,
        "lastPowerSampleOffsetSeconds" : 1936.555363535881,
        "plannedFinalStepEndOffsetSeconds" : 1918.5470229387283,
        "remainingMeters" : 43.23277691495605,
        "remainingSeconds" : 22.209920048713684,
        "workoutEndOffsetSeconds" : 1940.756942987442
      }
    }
  ],
  "segmentMarkers" : [
    {
      "averageHeartRateBpm" : 113.18181818181819,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1006.8670128582658,
      "durationSeconds" : 382.6612080335617,
      "endOffsetSeconds" : 382.6612080335617,
      "index" : 1,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 380.05139024991377,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 117.28225806451613,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1615.4936611867922,
      "durationSeconds" : 614.1962389945984,
      "endOffsetSeconds" : 614.1962389945984,
      "index" : 2,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 380.19105475374664,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 124.75641025641026,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1000.9319390313299,
      "durationSeconds" : 383.5910943746567,
      "endOffsetSeconds" : 766.2523024082184,
      "index" : 3,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 383.2339437043881,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 382.6612080335617
    },
    {
      "averageHeartRateBpm" : 128.70967741935485,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1609.2064833012607,
      "durationSeconds" : 618.1870852708817,
      "endOffsetSeconds" : 1232.38332426548,
      "index" : 4,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 384.1564719542274,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 614.1962389945984
    },
    {
      "averageHeartRateBpm" : 129.10526315789474,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 999.284226662035,
      "durationSeconds" : 381.8240830898285,
      "endOffsetSeconds" : 1148.0763854980469,
      "index" : 5,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 382.0975783489116,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 766.2523024082184
    },
    {
      "averageHeartRateBpm" : 132.53246753246754,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1000.0051222730467,
      "durationSeconds" : 383.04379057884216,
      "endOffsetSeconds" : 1531.120176076889,
      "index" : 6,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 383.0418285340081,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1148.0763854980469
    },
    {
      "averageHeartRateBpm" : 133.50806451612902,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1610.6066247166368,
      "durationSeconds" : 623.7477889060974,
      "endOffsetSeconds" : 1856.1311131715775,
      "index" : 7,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 387.27506725351816,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1232.38332426548
    },
    {
      "averageHeartRateBpm" : 134.6153846153846,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 999.9987363913142,
      "durationSeconds" : 389.39344239234924,
      "endOffsetSeconds" : 1920.5136184692383,
      "index" : 8,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 389.39393443390696,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1531.120176076889
    },
    {
      "averageHeartRateBpm" : 136.47058823529412,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 209.50951229325437,
      "durationSeconds" : 80.42425036430359,
      "endOffsetSeconds" : 1936.555363535881,
      "index" : 9,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 383.86920710183443,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1856.1311131715775
    },
    {
      "averageHeartRateBpm" : 138.33333333333334,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 37.72924428195256,
      "durationSeconds" : 16.04174506664276,
      "endOffsetSeconds" : 1936.555363535881,
      "index" : 10,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 425.1806621612133,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1920.5136184692383
    }
  ],
  "sourceNotes" : [
    "Plan source: WorkoutKit",
    "Window source: Plan-derived from HealthKit distance\/time samples",
    "Stats source: HealthKit samples",
    "HealthKit segment markers: not used"
  ],
  "workout" : {
    "averageHeartRate" : 127.23514868969413,
    "averagePower" : 187.40612516644495,
    "cadenceSpm" : 174.48702102917593,
    "deviceName" : "Apple Watch Apple Inc. Watch",
    "distanceMeters" : 5044.816281497944,
    "durationSeconds" : 1940.756942987442,
    "elapsedSeconds" : 1940.756942987442,
    "endDate" : "2026-06-12T12:22:14Z",
    "id" : "1A418F0B-05CB-4316-B1E1-33D34DC7F04B",
    "maxHeartRate" : 139,
    "paceSecondsPerKm" : 384.70319525911026,
    "sourceID" : "1A418F0B-05CB-4316-B1E1-33D34DC7F04B",
    "sourceName" : "Adriel’s Apple Watch",
    "startDate" : "2026-06-12T11:49:54Z"
  },
  "workoutKitPlanAudit" : {
    "displayName" : "Friday Easy 5km",
    "planID" : "B7CBD195-881D-48E9-9A5B-7E0567FA52AB",
    "planType" : "Custom workout",
    "plannedSteps" : [
      {
        "index" : 1,
        "label" : "Work 1",
        "plannedGoalDisplayText" : "5 km",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 5000,
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
      "Block 1 step 1: Work - goal 5 km, alert heart rate zone 2",
      "Cooldown: none"
    ]
  }
}
```