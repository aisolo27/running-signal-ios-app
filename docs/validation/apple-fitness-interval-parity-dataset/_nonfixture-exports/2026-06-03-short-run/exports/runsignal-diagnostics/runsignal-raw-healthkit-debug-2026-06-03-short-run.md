# RunSignal Raw HealthKit Debug Export

Generated: 2026-06-12T22:24:48Z

## Workout

| Field | Value |
|---|---|
| Workout ID | 0DA6CAFE-C9A1-41CF-B576-1CDFF1190E73 |
| Source | Adriel’s Apple Watch |
| Source ID | 0DA6CAFE-C9A1-41CF-B576-1CDFF1190E73 |
| Device | Apple Watch Apple Inc. Watch |
| Start | Jun 3, 2026 |
| End | Jun 3, 2026 |
| Duration | 6:29 |
| Elapsed | 6:29 |
| Distance | 1.02 km |
| Avg pace | 6:23 /km |
| Avg HR | 158 bpm |
| Max HR | 164 bpm |
| Cadence | 180 spm |
| Power | 190 W |

## Evidence Counts

| Metric | Count |
|---|---:|
| Heart rate | 77 |
| Speed | 149 |
| Distance | 149 |
| Active energy | 150 |
| Power | 149 |
| Cadence | 151 |
| Step count | 151 |
| Stride length | 70 |
| Vertical oscillation | 69 |
| Ground contact | 69 |
| Route points | 390 |
| Events | 3 |
| Workout activities | 1 |

## WorkoutKit Plan Audit

- Status: Available
- Plan type: Single goal workout
- Plan ID: 54BBC4AC-9898-4A3A-83C3-D11796D8D623
- Display name: Unavailable
- Activity: HKWorkoutActivityType(rawValue: 37)
- Goal: open

## Raw HKWorkoutEvent Inventory

Debug-only inventory of public `HKWorkoutEvent` date windows and metadata keys. These rows are not Apple Fitness interval truth.

| Row | Event Type | Label | Start Offset | End Offset | Duration | Metadata Keys | Rendered Marker Window | Marker Distance | Marker Kind | Used By Segment Rendering | Excluded / Filtered Reason | Debug-Only Reason |
|---:|---|---|---:|---:|---:|---|---:|---:|---|---|---|---|
| 1 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 6:18 | 378.4 s | Unavailable | 0:00-6:18 | 1.01 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 2 | HKWorkoutEventType(rawValue: 7) | Unavailable | 6:18 | 6:25 | 6.4 s | Unavailable | 6:18-6:25 | 0.01 km | Raw segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 3 | HKWorkoutEventType(rawValue: 1) | Unavailable | 6:29 | 6:29 | 0.0 s | Unavailable | Unavailable | Unavailable | Unavailable | No | Excluded from segment rendering: zero or negative duration. | No rendered segment marker candidate. |

## HKWorkoutActivity Inventory

Debug-only inventory of public `HKWorkout.workoutActivities` rows. These rows are not used for production interval reconstruction.

| Activity | Type | Start Date | End Date | Start Offset | End Offset | Duration | Metadata Keys | Nested Events | Statistics | Aligns Planned Step | Aligned Planned Step | Nearest Reconstructed Row | Row End Delta | Apple Fitness/manual | FIT Lap | Raw Event Start | Raw Start Delta | Raw Event End | Raw End Delta | Segment Start | Segment Start Delta | Segment End | Segment End Delta | Previous Sample End | Crossing Sample End | Next Sample End |
|---:|---|---|---|---:|---:|---:|---|---|---|---|---|---|---:|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | HKWorkoutActivityType(rawValue: 37) | 2026-06-03T12:25:05Z | 2026-06-03T12:31:35Z | 0.0 s | 389.3 s | 389.3 s | Unavailable | 3 event(s): HKWorkoutEventType(rawValue: 1), HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 78.4 kcal; BasalEnergyBurned: sum 9.4 kcal; DistanceWalkingRunning: sum 1015.2 m; HeartRate: avg 157.8 bpm, min 142.0 bpm, max 164.0 bpm | No | Unavailable | Unavailable |  | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 0.0 s | 0.0 s | 384.8 s | -4.5 s | 0.0 s | 0.0 s | 384.8 s | -4.5 s | Unavailable | Unavailable | Unavailable |

## WorkoutKit Reconstructed Intervals

Planned structure source: WorkoutKit when available. Measured stats source: HealthKit samples.

Unavailable. RunSignal needs a WorkoutKit plan and HealthKit distance/time evidence before it can reconstruct custom workout intervals.

## HKWorkoutActivity Boundary Candidate Intervals

Debug-only alternate reconstruction for Parity Lab exports. These rows are not production interval logic and are not shown in the normal workout UI.

| Field | Value |
|---|---|
| Mapping status | activity mapping ambiguous |
| Activity count | 1 |
| Planned step count | 0 |
| Scoreable | No |
| Not scoreable reason | WorkoutKit planned steps are missing. |
| Production UI warning | HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI. |

No activity-boundary candidate rows were produced.

Caveats: debug-only, not promoted · not production interval logic · not shown in normal workout UI · FIT and Apple Fitness/manual rows are not runtime inputs

## WorkoutKit Boundary Diagnostics

Unavailable. No reconstructed intervals available for boundary diagnostics.

## HealthKit Segment Markers

Raw debug only. HealthKit Segment Markers must not be promoted as Apple Fitness interval rows.

| Row | Label | Marker Kind | Source | Distance | Time | Pace | Avg HR | Start Offset | End Offset | Confidence | Caveats |
|---:|---|---|---|---:|---:|---:|---:|---:|---:|---|---|
| 1 | Unknown | Split marker | HealthKit segment pattern | 1.01 km | 6:18 | 6:16 /km | 157 bpm | 0:00 | 6:18 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. |
| 2 | Unknown | Raw segment marker | HealthKit segment pattern | 0.01 km | 0:06 | 12:34 /km | 160 bpm | 6:18 | 6:25 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event is a raw HealthKit marker until interval parity is proven. |

## Planned Step Boundary Comparison

Debug-only comparison helper for FIT/Apple boundary investigation. The FIT lap end offset is intentionally a manual placeholder; RunSignal does not read FIT at runtime.

Unavailable. No reconstructed WorkoutKit rows are available for boundary comparison.

## Boundary Source Warnings

- One or more raw HKWorkoutEvent records have unavailable metadata keys.
- One or more HKWorkoutActivity records have unavailable metadata keys.
- No reconstructed WorkoutKit rows are available for planned-step comparison.
- FIT lap end offsets are not read by RunSignal; compare them manually after physical-device export.
- Apple Fitness/manual row offsets are not read by RunSignal; compare HKWorkoutActivity timing manually after physical-device export.

## Evidence Caveats

- None

## JSON Payload

```json
{
  "activityBoundaryCandidateIntervals" : [

  ],
  "activityBoundaryCandidateSummary" : {
    "activityCount" : 1,
    "boundaryLogicChanged" : false,
    "candidateConfidence" : "activity mapping ambiguous",
    "caveats" : [
      "debug-only, not promoted",
      "not production interval logic",
      "not shown in normal workout UI",
      "FIT and Apple Fitness\/manual rows are not runtime inputs"
    ],
    "isScoreable" : false,
    "mappingStatus" : "activity mapping ambiguous",
    "normalWorkoutUIChanged" : false,
    "notScoreableReason" : "WorkoutKit planned steps are missing.",
    "plannedStepCount" : 0,
    "productionIntervalBehaviorChanged" : false,
    "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
    "scope" : "debug\/export-only",
    "strategyID" : "hkworkoutactivity_boundary",
    "usesAppleFitnessManualRuntimeLogic" : false,
    "usesFITRuntimeTruth" : false
  },
  "boundaryDiagnostics" : [

  ],
  "boundarySourceWarnings" : [
    "One or more raw HKWorkoutEvent records have unavailable metadata keys.",
    "One or more HKWorkoutActivity records have unavailable metadata keys.",
    "No reconstructed WorkoutKit rows are available for planned-step comparison.",
    "FIT lap end offsets are not read by RunSignal; compare them manually after physical-device export.",
    "Apple Fitness\/manual row offsets are not read by RunSignal; compare HKWorkoutActivity timing manually after physical-device export."
  ],
  "caveats" : [

  ],
  "evidenceCounts" : {
    "activeEnergy" : 150,
    "activities" : 1,
    "cadence" : 151,
    "distance" : 149,
    "events" : 3,
    "groundContact" : 69,
    "heartRate" : 77,
    "power" : 149,
    "routePoints" : 390,
    "speed" : 149,
    "stepCount" : 151,
    "strideLength" : 70,
    "verticalOscillation" : 69
  },
  "generatedAt" : "2026-06-12T22:24:48Z",
  "plannedStepBoundaryComparisons" : [

  ],
  "rawWorkoutEvents" : [
    {
      "durationSeconds" : 378.4046609401703,
      "endDate" : "2026-06-03T12:31:24Z",
      "endOffsetSeconds" : 378.4046609401703,
      "index" : 1,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1006.7393393392371,
      "renderedSegmentMarkerDurationSeconds" : 378.4046609401703,
      "renderedSegmentMarkerEndOffsetSeconds" : 378.4046609401703,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-03T12:25:05Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 6.415632724761963,
      "endDate" : "2026-06-03T12:31:30Z",
      "endOffsetSeconds" : 384.82029366493225,
      "index" : 2,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 8.506490667893218,
      "renderedSegmentMarkerDurationSeconds" : 6.415632724761963,
      "renderedSegmentMarkerEndOffsetSeconds" : 384.82029366493225,
      "renderedSegmentMarkerKind" : "rawSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 378.4046609401703,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-03T12:31:24Z",
      "startOffsetSeconds" : 378.4046609401703,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 0,
      "endDate" : "2026-06-03T12:31:35Z",
      "endOffsetSeconds" : 389.3219350576401,
      "excludedOrFilteredReason" : "zeroOrNegativeDuration",
      "index" : 3,
      "metadataKeys" : [

      ],
      "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
      "startDate" : "2026-06-03T12:31:35Z",
      "startOffsetSeconds" : 389.3219350576401,
      "type" : "HKWorkoutEventType(rawValue: 1)",
      "usedBySegmentMarkerRendering" : false
    }
  ],
  "reconstructedIntervals" : [

  ],
  "segmentMarkers" : [
    {
      "averageHeartRateBpm" : 157.44,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1006.7393393392371,
      "durationSeconds" : 378.4046609401703,
      "endOffsetSeconds" : 378.4046609401703,
      "index" : 1,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 375.8715351170565,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 160.5,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event is a raw HealthKit marker until interval parity is proven."
      ],
      "confidence" : "limited",
      "distanceMeters" : 8.506490667893218,
      "durationSeconds" : 6.415632724761963,
      "endOffsetSeconds" : 384.82029366493225,
      "index" : 2,
      "label" : "unknown",
      "markerKind" : "rawSegmentMarker",
      "paceSecondsPerKm" : 754.2044040531356,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 378.4046609401703
    }
  ],
  "sourceNotes" : [

  ],
  "workout" : {
    "averageHeartRate" : 157.79159174159173,
    "averagePower" : 189.78523489932883,
    "cadenceSpm" : 179.77769015589058,
    "deviceName" : "Apple Watch Apple Inc. Watch",
    "distanceMeters" : 1015.2458300071303,
    "durationSeconds" : 389.3219350576401,
    "elapsedSeconds" : 389.3219350576401,
    "endDate" : "2026-06-03T12:31:35Z",
    "id" : "0DA6CAFE-C9A1-41CF-B576-1CDFF1190E73",
    "maxHeartRate" : 164,
    "paceSecondsPerKm" : 383.47553228059627,
    "sourceID" : "0DA6CAFE-C9A1-41CF-B576-1CDFF1190E73",
    "sourceName" : "Adriel’s Apple Watch",
    "startDate" : "2026-06-03T12:25:05Z"
  },
  "workoutActivities" : [
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "durationSeconds" : 389.3219350576401,
      "endDate" : "2026-06-03T12:31:35Z",
      "endOffsetSeconds" : 389.3219350576401,
      "events" : [
        {
          "durationSeconds" : 378.4046609401703,
          "endDate" : "2026-06-03T12:31:24Z",
          "endOffsetSeconds" : 378.4046609401703,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1006.7393393392371,
          "renderedSegmentMarkerDurationSeconds" : 378.4046609401703,
          "renderedSegmentMarkerEndOffsetSeconds" : 378.4046609401703,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T12:25:05Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 6.415632724761963,
          "endDate" : "2026-06-03T12:31:30Z",
          "endOffsetSeconds" : 384.82029366493225,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 8.506490667893218,
          "renderedSegmentMarkerDurationSeconds" : 6.415632724761963,
          "renderedSegmentMarkerEndOffsetSeconds" : 384.82029366493225,
          "renderedSegmentMarkerKind" : "rawSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 378.4046609401703,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-03T12:31:24Z",
          "startOffsetSeconds" : 378.4046609401703,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 0,
          "endDate" : "2026-06-03T12:31:35Z",
          "endOffsetSeconds" : 389.3219350576401,
          "excludedOrFilteredReason" : "zeroOrNegativeDuration",
          "index" : 3,
          "metadataKeys" : [

          ],
          "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
          "startDate" : "2026-06-03T12:31:35Z",
          "startOffsetSeconds" : 389.3219350576401,
          "type" : "HKWorkoutEventType(rawValue: 1)",
          "usedBySegmentMarkerRendering" : false
        }
      ],
      "eventsSummary" : "3 event(s): HKWorkoutEventType(rawValue: 1), HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "0DA6CAFE-C9A1-41CF-B576-1CDFF1190E73",
      "index" : 1,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [

      ],
      "nearestRawEventEndDeltaSeconds" : -4.501641392707825,
      "nearestRawEventEndOffsetSeconds" : 384.82029366493225,
      "nearestRawEventStartDeltaSeconds" : 0,
      "nearestRawEventStartOffsetSeconds" : 0,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -4.501641392707825,
      "nearestSegmentMarkerEndOffsetSeconds" : 384.82029366493225,
      "nearestSegmentMarkerKind" : "rawSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : 0,
      "nearestSegmentMarkerStartOffsetSeconds" : 0,
      "startDate" : "2026-06-03T12:25:05Z",
      "startOffsetSeconds" : 0,
      "statistics" : [
        {
          "endDate" : "2026-06-03T12:31:35Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:25:05Z",
          "sum" : 78.3962475775574,
          "summary" : "ActiveEnergyBurned: sum 78.4 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-03T12:31:35Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:25:05Z",
          "sum" : 9.423386176851835,
          "summary" : "BasalEnergyBurned: sum 9.4 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-03T12:31:35Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:25:05Z",
          "sum" : 1015.2458300071303,
          "summary" : "DistanceWalkingRunning: sum 1015.2 m",
          "unit" : "m"
        },
        {
          "average" : 157.79159174159173,
          "endDate" : "2026-06-03T12:31:35Z",
          "maximum" : 164,
          "minimum" : 142,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:25:05Z",
          "summary" : "HeartRate: avg 157.8 bpm, min 142.0 bpm, max 164.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 257.49275362318843,
          "endDate" : "2026-06-03T12:31:35Z",
          "maximum" : 278,
          "minimum" : 238,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:25:05Z",
          "summary" : "RunningGroundContactTime: avg 257.5 ms, min 238.0 ms, max 278.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 189.78523489932883,
          "endDate" : "2026-06-03T12:31:35Z",
          "maximum" : 202,
          "minimum" : 78,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:25:05Z",
          "summary" : "RunningPower: avg 189.8 W, min 78.0 W, max 202.0 W",
          "unit" : "W"
        },
        {
          "average" : 2.702008094658186,
          "endDate" : "2026-06-03T12:31:35Z",
          "maximum" : 2.8504016922223996,
          "minimum" : 1.378446072637269,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:25:05Z",
          "summary" : "RunningSpeed: avg 2.7 m\/s, min 1.4 m\/s, max 2.9 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.8979999999999999,
          "endDate" : "2026-06-03T12:31:35Z",
          "maximum" : 0.95,
          "minimum" : 0.85,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:25:05Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.8 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 7.794202898550724,
          "endDate" : "2026-06-03T12:31:35Z",
          "maximum" : 8.2,
          "minimum" : 7.199999999999999,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:25:05Z",
          "summary" : "RunningVerticalOscillation: avg 7.8 cm, min 7.2 cm, max 8.2 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-03T12:31:35Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-03T12:25:05Z",
          "sum" : 1163.4995685837002,
          "summary" : "StepCount: sum 1163.5 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 78.4 kcal; BasalEnergyBurned: sum 9.4 kcal; DistanceWalkingRunning: sum 1015.2 m; HeartRate: avg 157.8 bpm, min 142.0 bpm, max 164.0 bpm"
    }
  ],
  "workoutKitPlanAudit" : {
    "planID" : "54BBC4AC-9898-4A3A-83C3-D11796D8D623",
    "planType" : "Single goal workout",
    "plannedSteps" : [

    ],
    "status" : "available",
    "summaryLines" : [
      "Activity: HKWorkoutActivityType(rawValue: 37)",
      "Goal: open"
    ]
  }
}
```