# RunSignal Raw HealthKit Debug Export

Generated: 2026-06-14T19:56:23Z

## Workout

| Field | Value |
|---|---|
| Workout ID | 4FBA60D5-9E2D-4FC3-A5F5-E5C1262FFB0D |
| Source | Adriel’s Apple Watch |
| Source ID | 4FBA60D5-9E2D-4FC3-A5F5-E5C1262FFB0D |
| Device | Apple Watch Apple Inc. Watch |
| Start | Jun 14, 2026 |
| End | Jun 14, 2026 |
| Duration | 19:59 |
| Elapsed | 19:59 |
| Distance | 2.20 km |
| Avg pace | 9:05 /km |
| Avg HR | 139 bpm |
| Max HR | 161 bpm |
| Cadence | 138 spm |
| Power | 122 W |

## Evidence Counts

| Metric | Count |
|---|---:|
| Heart rate | 240 |
| Speed | 465 |
| Distance | 464 |
| Active energy | 466 |
| Power | 465 |
| Cadence | 466 |
| Step count | 466 |
| Stride length | 94 |
| Vertical oscillation | 98 |
| Ground contact | 96 |
| Route points | 1200 |
| Events | 6 |
| Workout activities | 1 |

## WorkoutKit Plan Audit

- Status: Available
- Plan type: Single goal workout
- Plan ID: 51818698-E9D2-4D62-8439-AE453E7C770D
- Display name: Unavailable
- Activity: HKWorkoutActivityType(rawValue: 37)
- Goal: open

## Raw HKWorkoutEvent Inventory

Debug-only inventory of public `HKWorkoutEvent` date windows and metadata keys. These rows are not Apple Fitness interval truth.

| Row | Event Type | Label | Start Offset | End Offset | Duration | Metadata Keys | Rendered Marker Window | Marker Distance | Marker Kind | Used By Segment Rendering | Excluded / Filtered Reason | Debug-Only Reason |
|---:|---|---|---:|---:|---:|---|---:|---:|---|---|---|---|
| 1 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 6:26 | 386.3 s | Unavailable | 0:00-6:26 | 1.01 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 2 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 12:28 | 747.6 s | Unavailable | 0:00-12:28 | 1.61 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 3 | HKWorkoutEventType(rawValue: 7) | Unavailable | 6:26 | 17:25 | 658.4 s | Unavailable | 6:26-17:25 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 4 | HKWorkoutEventType(rawValue: 7) | Unavailable | 12:28 | 19:56 | 448.9 s | Unavailable | 12:28-19:56 | 0.59 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 5 | HKWorkoutEventType(rawValue: 7) | Unavailable | 17:25 | 19:56 | 151.8 s | Unavailable | 17:25-19:56 | 0.20 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 6 | HKWorkoutEventType(rawValue: 1) | Unavailable | 19:59 | 19:59 | 0.0 s | Unavailable | Unavailable | Unavailable | Unavailable | No | Excluded from segment rendering: zero or negative duration. | No rendered segment marker candidate. |

## HKWorkoutActivity Inventory

Debug-only inventory of public `HKWorkout.workoutActivities` rows. These rows are not used for production interval reconstruction.

| Activity | Type | Start Date | End Date | Start Offset | End Offset | Duration | Metadata Keys | Nested Events | Statistics | Aligns Planned Step | Aligned Planned Step | Nearest Reconstructed Row | Row End Delta | Apple Fitness/manual | FIT Lap | Raw Event Start | Raw Start Delta | Raw Event End | Raw End Delta | Segment Start | Segment Start Delta | Segment End | Segment End Delta | Previous Sample End | Crossing Sample End | Next Sample End |
|---:|---|---|---|---:|---:|---:|---|---|---|---|---|---|---:|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | HKWorkoutActivityType(rawValue: 37) | 2026-06-14T12:11:05Z | 2026-06-14T12:31:04Z | 0.0 s | 1199.5 s | 1199.5 s | Unavailable | 6 event(s): HKWorkoutEventType(rawValue: 1), HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 149.1 kcal; BasalEnergyBurned: sum 29.3 kcal; DistanceWalkingRunning: sum 2199.9 m; HeartRate: avg 138.9 bpm, min 117.0 bpm, max 161.0 bpm | No | Unavailable | Unavailable |  | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 0.0 s | 0.0 s | 1196.5 s | -3.0 s | 0.0 s | 0.0 s | 1196.5 s | -3.0 s | Unavailable | Unavailable | Unavailable |

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

## Custom Workout Candidate Rule Scorer

Debug-only Parity Lab scorer for active-time duration, pause overlap, and Open / Extra tail rows. These rows are not production interval logic and are not shown in the normal workout UI.

| Field | Value |
|---|---|
| Strategy | custom_workout_candidate_rule_active_time |
| Rule status | candidate-rule-not-scoreable |
| Candidate row count | 0 |
| Open tail row count | 0 |
| Paired pause count | 0 |
| Total paired pause | 0.0 s |
| Scoreable | No |
| Not scoreable reason | WorkoutKit planned steps are missing. |
| Production UI warning | Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI. |

No custom-workout candidate rule rows were produced.

Caveats: debug-only, not promoted · not production interval logic · not shown in normal workout UI · FIT and Apple Fitness/manual rows are not runtime inputs · Active duration subtracts paired HealthKit pause/resume overlap when available.

## Custom Workout Structured Comparison

Debug-only structured status and fallback taxonomy for Parity Lab rows. This is not production interval logic and is not shown in the normal workout UI.

| Field | Value |
|---|---|
| Status | missing-required-evidence |
| Fallback reasons | missingPlannedSteps, noRowLevelEvidence |
| Row count | 1 |
| Row confidences | missingEvidence |
| Tail ambiguity | none |
| Promotes production behavior | No |
| Scope | debug/export-only |

## WorkoutKit Boundary Diagnostics

Unavailable. No reconstructed intervals available for boundary diagnostics.

## HealthKit Segment Markers

Raw debug only. HealthKit Segment Markers must not be promoted as Apple Fitness interval rows.

| Row | Label | Marker Kind | Source | Distance | Time | Pace | Avg HR | Start Offset | End Offset | Confidence | Caveats |
|---:|---|---|---|---:|---:|---:|---:|---:|---:|---|---|
| 1 | Unknown | Split marker | HealthKit segment pattern | 1.01 km | 6:26 | 6:23 /km | 151 bpm | 0:00 | 6:26 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. |
| 2 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.61 km | 12:28 | 7:43 /km | 148 bpm | 0:00 | 12:28 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 3 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 10:58 | 11:01 /km | 136 bpm | 6:26 | 17:25 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 4 | Unknown | Overlapping segment marker | HealthKit segment pattern | 0.59 km | 7:29 | 12:45 /km | 124 bpm | 12:28 | 19:56 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 5 | Unknown | Overlapping segment marker | HealthKit segment pattern | 0.20 km | 2:32 | 12:56 /km | 122 bpm | 17:25 | 19:56 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |

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
  "customWorkoutCandidateRuleRows" : [

  ],
  "customWorkoutCandidateRuleSummary" : {
    "boundaryLogicChanged" : false,
    "candidateRowCount" : 0,
    "caveats" : [
      "debug-only, not promoted",
      "not production interval logic",
      "not shown in normal workout UI",
      "FIT and Apple Fitness\/manual rows are not runtime inputs",
      "Active duration subtracts paired HealthKit pause\/resume overlap when available."
    ],
    "isScoreable" : false,
    "normalWorkoutUIChanged" : false,
    "notScoreableReason" : "WorkoutKit planned steps are missing.",
    "openTailRowCount" : 0,
    "pairedPauseCount" : 0,
    "productionIntervalBehaviorChanged" : false,
    "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
    "ruleStatus" : "candidate-rule-not-scoreable",
    "scope" : "debug\/export-only",
    "strategyID" : "custom_workout_candidate_rule_active_time",
    "totalPairedPauseSeconds" : 0,
    "usesAppleFitnessManualRuntimeLogic" : false,
    "usesFITRuntimeTruth" : false
  },
  "customWorkoutComparisonSummary" : {
    "fallbackReasons" : [
      "missingPlannedSteps",
      "noRowLevelEvidence"
    ],
    "normalWorkoutUIChanged" : false,
    "productionIntervalBehaviorChanged" : false,
    "promotesProductionBehavior" : false,
    "rowConfidences" : [
      "missingEvidence"
    ],
    "rowCount" : 1,
    "scope" : "debug\/export-only",
    "status" : "missing-required-evidence",
    "tailAmbiguity" : "none",
    "usesFITRuntimeTruth" : false
  },
  "evidenceCounts" : {
    "activeEnergy" : 466,
    "activities" : 1,
    "cadence" : 466,
    "distance" : 464,
    "events" : 6,
    "groundContact" : 96,
    "heartRate" : 240,
    "power" : 465,
    "routePoints" : 1200,
    "speed" : 465,
    "stepCount" : 466,
    "strideLength" : 94,
    "verticalOscillation" : 98
  },
  "generatedAt" : "2026-06-14T19:56:23Z",
  "plannedStepBoundaryComparisons" : [

  ],
  "rawWorkoutEvents" : [
    {
      "durationSeconds" : 386.2941107749939,
      "endDate" : "2026-06-14T12:17:31Z",
      "endOffsetSeconds" : 386.2941107749939,
      "index" : 1,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1007.4201494979767,
      "renderedSegmentMarkerDurationSeconds" : 386.2941107749939,
      "renderedSegmentMarkerEndOffsetSeconds" : 386.2941107749939,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-14T12:11:05Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 747.5774726867676,
      "endDate" : "2026-06-14T12:23:32Z",
      "endOffsetSeconds" : 747.5774726867676,
      "index" : 2,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1612.9554598584084,
      "renderedSegmentMarkerDurationSeconds" : 747.5774726867676,
      "renderedSegmentMarkerEndOffsetSeconds" : 747.5774726867676,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-14T12:11:05Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 658.3564544916153,
      "endDate" : "2026-06-14T12:28:30Z",
      "endOffsetSeconds" : 1044.6505652666092,
      "index" : 3,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 996.6815067093654,
      "renderedSegmentMarkerDurationSeconds" : 658.3564544916153,
      "renderedSegmentMarkerEndOffsetSeconds" : 1044.6505652666092,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 386.2941107749939,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-14T12:17:31Z",
      "startOffsetSeconds" : 386.2941107749939,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 448.90103256702423,
      "endDate" : "2026-06-14T12:31:01Z",
      "endOffsetSeconds" : 1196.4785052537918,
      "index" : 4,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 586.8984647450259,
      "renderedSegmentMarkerDurationSeconds" : 448.90103256702423,
      "renderedSegmentMarkerEndOffsetSeconds" : 1196.4785052537918,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 747.5774726867676,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-14T12:23:32Z",
      "startOffsetSeconds" : 747.5774726867676,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 151.82793998718262,
      "endDate" : "2026-06-14T12:31:01Z",
      "endOffsetSeconds" : 1196.4785052537918,
      "index" : 5,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 195.75226839609218,
      "renderedSegmentMarkerDurationSeconds" : 151.82793998718262,
      "renderedSegmentMarkerEndOffsetSeconds" : 1196.4785052537918,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 1044.6505652666092,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-14T12:28:30Z",
      "startOffsetSeconds" : 1044.6505652666092,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 0,
      "endDate" : "2026-06-14T12:31:04Z",
      "endOffsetSeconds" : 1199.4714599847794,
      "excludedOrFilteredReason" : "zeroOrNegativeDuration",
      "index" : 6,
      "metadataKeys" : [

      ],
      "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
      "startDate" : "2026-06-14T12:31:04Z",
      "startOffsetSeconds" : 1199.4714599847794,
      "type" : "HKWorkoutEventType(rawValue: 1)",
      "usedBySegmentMarkerRendering" : false
    }
  ],
  "reconstructedIntervals" : [

  ],
  "segmentMarkers" : [
    {
      "averageHeartRateBpm" : 151.42307692307693,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1007.4201494979767,
      "durationSeconds" : 386.2941107749939,
      "endOffsetSeconds" : 386.2941107749939,
      "index" : 1,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 383.4488628875392,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 148.18791946308724,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1612.9554598584084,
      "durationSeconds" : 747.5774726867676,
      "endOffsetSeconds" : 747.5774726867676,
      "index" : 2,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 463.48302311608336,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 135.73846153846154,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 996.6815067093654,
      "durationSeconds" : 658.3564544916153,
      "endOffsetSeconds" : 1044.6505652666092,
      "index" : 3,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 660.5484801912689,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 386.2941107749939
    },
    {
      "averageHeartRateBpm" : 123.82222222222222,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 586.8984647450259,
      "durationSeconds" : 448.90103256702423,
      "endOffsetSeconds" : 1196.4785052537918,
      "index" : 4,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 764.8700065386034,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 747.5774726867676
    },
    {
      "averageHeartRateBpm" : 121.51612903225806,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 195.75226839609218,
      "durationSeconds" : 151.82793998718262,
      "endOffsetSeconds" : 1196.4785052537918,
      "index" : 5,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 775.6126722371795,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 1044.6505652666092
    }
  ],
  "sourceNotes" : [

  ],
  "workout" : {
    "averageHeartRate" : 138.862296037296,
    "averagePower" : 122.0387096774194,
    "cadenceSpm" : 137.82361819051454,
    "deviceName" : "Apple Watch Apple Inc. Watch",
    "distanceMeters" : 2199.8539246034343,
    "durationSeconds" : 1199.4714599847794,
    "elapsedSeconds" : 1199.4714599847794,
    "endDate" : "2026-06-14T12:31:04Z",
    "id" : "4FBA60D5-9E2D-4FC3-A5F5-E5C1262FFB0D",
    "maxHeartRate" : 161,
    "paceSecondsPerKm" : 545.2505034855926,
    "sourceID" : "4FBA60D5-9E2D-4FC3-A5F5-E5C1262FFB0D",
    "sourceName" : "Adriel’s Apple Watch",
    "startDate" : "2026-06-14T12:11:05Z"
  },
  "workoutActivities" : [
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignsWithPlannedStep" : false,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "durationSeconds" : 1199.4714599847794,
      "endDate" : "2026-06-14T12:31:04Z",
      "endOffsetSeconds" : 1199.4714599847794,
      "events" : [
        {
          "durationSeconds" : 386.2941107749939,
          "endDate" : "2026-06-14T12:17:31Z",
          "endOffsetSeconds" : 386.2941107749939,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1007.4201494979767,
          "renderedSegmentMarkerDurationSeconds" : 386.2941107749939,
          "renderedSegmentMarkerEndOffsetSeconds" : 386.2941107749939,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-14T12:11:05Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 747.5774726867676,
          "endDate" : "2026-06-14T12:23:32Z",
          "endOffsetSeconds" : 747.5774726867676,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1612.9554598584084,
          "renderedSegmentMarkerDurationSeconds" : 747.5774726867676,
          "renderedSegmentMarkerEndOffsetSeconds" : 747.5774726867676,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-14T12:11:05Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 658.3564544916153,
          "endDate" : "2026-06-14T12:28:30Z",
          "endOffsetSeconds" : 1044.6505652666092,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 996.6815067093654,
          "renderedSegmentMarkerDurationSeconds" : 658.3564544916153,
          "renderedSegmentMarkerEndOffsetSeconds" : 1044.6505652666092,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 386.2941107749939,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-14T12:17:31Z",
          "startOffsetSeconds" : 386.2941107749939,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 448.90103256702423,
          "endDate" : "2026-06-14T12:31:01Z",
          "endOffsetSeconds" : 1196.4785052537918,
          "index" : 4,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 586.8984647450259,
          "renderedSegmentMarkerDurationSeconds" : 448.90103256702423,
          "renderedSegmentMarkerEndOffsetSeconds" : 1196.4785052537918,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 747.5774726867676,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-14T12:23:32Z",
          "startOffsetSeconds" : 747.5774726867676,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 151.82793998718262,
          "endDate" : "2026-06-14T12:31:01Z",
          "endOffsetSeconds" : 1196.4785052537918,
          "index" : 5,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 195.75226839609218,
          "renderedSegmentMarkerDurationSeconds" : 151.82793998718262,
          "renderedSegmentMarkerEndOffsetSeconds" : 1196.4785052537918,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 1044.6505652666092,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-14T12:28:30Z",
          "startOffsetSeconds" : 1044.6505652666092,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 0,
          "endDate" : "2026-06-14T12:31:04Z",
          "endOffsetSeconds" : 1199.4714599847794,
          "excludedOrFilteredReason" : "zeroOrNegativeDuration",
          "index" : 6,
          "metadataKeys" : [

          ],
          "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
          "startDate" : "2026-06-14T12:31:04Z",
          "startOffsetSeconds" : 1199.4714599847794,
          "type" : "HKWorkoutEventType(rawValue: 1)",
          "usedBySegmentMarkerRendering" : false
        }
      ],
      "eventsSummary" : "6 event(s): HKWorkoutEventType(rawValue: 1), HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "4FBA60D5-9E2D-4FC3-A5F5-E5C1262FFB0D",
      "index" : 1,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [

      ],
      "nearestRawEventEndDeltaSeconds" : -2.992954730987549,
      "nearestRawEventEndOffsetSeconds" : 1196.4785052537918,
      "nearestRawEventStartDeltaSeconds" : 0,
      "nearestRawEventStartOffsetSeconds" : 0,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -2.992954730987549,
      "nearestSegmentMarkerEndOffsetSeconds" : 1196.4785052537918,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : 0,
      "nearestSegmentMarkerStartOffsetSeconds" : 0,
      "startDate" : "2026-06-14T12:11:05Z",
      "startOffsetSeconds" : 0,
      "statistics" : [
        {
          "endDate" : "2026-06-14T12:31:04Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-14T12:11:05Z",
          "sum" : 149.06146132213718,
          "summary" : "ActiveEnergyBurned: sum 149.1 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-14T12:31:04Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-14T12:11:05Z",
          "sum" : 29.298160337603196,
          "summary" : "BasalEnergyBurned: sum 29.3 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-14T12:31:04Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-14T12:11:05Z",
          "sum" : 2199.8539246034343,
          "summary" : "DistanceWalkingRunning: sum 2199.9 m",
          "unit" : "m"
        },
        {
          "average" : 138.862296037296,
          "endDate" : "2026-06-14T12:31:04Z",
          "maximum" : 161,
          "minimum" : 117,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-14T12:11:05Z",
          "summary" : "HeartRate: avg 138.9 bpm, min 117.0 bpm, max 161.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 268.72916666666663,
          "endDate" : "2026-06-14T12:31:04Z",
          "maximum" : 306,
          "minimum" : 243,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-14T12:11:05Z",
          "summary" : "RunningGroundContactTime: avg 268.7 ms, min 243.0 ms, max 306.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 122.0387096774194,
          "endDate" : "2026-06-14T12:31:04Z",
          "maximum" : 197,
          "minimum" : 63,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-14T12:11:05Z",
          "summary" : "RunningPower: avg 122.0 W, min 63.0 W, max 197.0 W",
          "unit" : "W"
        },
        {
          "average" : 1.8483746032375914,
          "endDate" : "2026-06-14T12:31:04Z",
          "maximum" : 2.7621670342720464,
          "minimum" : 1.0130717593481164,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-14T12:11:05Z",
          "summary" : "RunningSpeed: avg 1.8 m\/s, min 1.0 m\/s, max 2.8 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 0.8657446808510636,
          "endDate" : "2026-06-14T12:31:04Z",
          "maximum" : 0.91,
          "minimum" : 0.78,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-14T12:11:05Z",
          "summary" : "RunningStrideLength: avg 0.9 m, min 0.8 m, max 0.9 m",
          "unit" : "m"
        },
        {
          "average" : 7.2316326530612205,
          "endDate" : "2026-06-14T12:31:04Z",
          "maximum" : 8.4,
          "minimum" : 6.6000000000000005,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-14T12:11:05Z",
          "summary" : "RunningVerticalOscillation: avg 7.2 cm, min 6.6 cm, max 8.4 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-14T12:31:04Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-14T12:11:05Z",
          "sum" : 2754,
          "summary" : "StepCount: sum 2754.0 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 149.1 kcal; BasalEnergyBurned: sum 29.3 kcal; DistanceWalkingRunning: sum 2199.9 m; HeartRate: avg 138.9 bpm, min 117.0 bpm, max 161.0 bpm"
    }
  ],
  "workoutKitPlanAudit" : {
    "planID" : "51818698-E9D2-4D62-8439-AE453E7C770D",
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