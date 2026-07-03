# RunSignal Raw HealthKit Debug Export

Generated: 2026-06-14T19:48:43Z

## Workout

| Field | Value |
|---|---|
| Workout ID | D57BFD29-EEF1-453D-9A98-4BE0E4159C8E |
| Source | Adriel’s Apple Watch |
| Source ID | D57BFD29-EEF1-453D-9A98-4BE0E4159C8E |
| Device | Apple Watch Apple Inc. Watch |
| Start | Jun 14, 2026 |
| End | Jun 14, 2026 |
| Duration | 12:14 |
| Elapsed | 12:14 |
| Distance | 3.03 km |
| Avg pace | 4:03 /km |
| Avg HR | 172 bpm |
| Max HR | 184 bpm |
| Cadence | 189 spm |
| Power | 295 W |

## Evidence Counts

| Metric | Count |
|---|---:|
| Heart rate | 149 |
| Speed | 283 |
| Distance | 284 |
| Active energy | 283 |
| Power | 282 |
| Cadence | 285 |
| Step count | 285 |
| Stride length | 128 |
| Vertical oscillation | 128 |
| Ground contact | 128 |
| Route points | 734 |
| Events | 7 |
| Workout activities | 1 |

## WorkoutKit Plan Audit

- Status: Available
- Plan type: Custom workout
- Plan ID: C42730A2-7833-4F1F-9FC5-6D9103361287
- Display name: Test Race Day 5k
- Activity: HKWorkoutActivityType(rawValue: 37)
- Warmup: none
- Block 1: 1x, 1 step(s)
- Block 1 step 1: Work - goal 5 km, alert pace 4:00 /km, speed 4.17 m/s, metric current
- Cooldown: none

## Raw HKWorkoutEvent Inventory

Debug-only inventory of public `HKWorkoutEvent` date windows and metadata keys. These rows are not Apple Fitness interval truth.

| Row | Event Type | Label | Start Offset | End Offset | Duration | Metadata Keys | Rendered Marker Window | Marker Distance | Marker Kind | Used By Segment Rendering | Excluded / Filtered Reason | Debug-Only Reason |
|---:|---|---|---:|---:|---:|---|---:|---:|---|---|---|---|
| 1 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 3:56 | 236.0 s | Unavailable | 0:00-3:56 | 1.01 km | Split marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 2 | HKWorkoutEventType(rawValue: 7) | Unavailable | 0:00 | 6:17 | 377.2 s | Unavailable | 0:00-6:17 | 1.62 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 3 | HKWorkoutEventType(rawValue: 7) | Unavailable | 3:56 | 7:50 | 234.2 s | Unavailable | 3:56-7:50 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 4 | HKWorkoutEventType(rawValue: 7) | Unavailable | 6:17 | 12:13 | 355.6 s | Unavailable | 6:17-12:13 | 1.41 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 5 | HKWorkoutEventType(rawValue: 7) | Unavailable | 7:50 | 12:06 | 255.8 s | Unavailable | 7:50-12:06 | 1.00 km | Overlapping segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 6 | HKWorkoutEventType(rawValue: 7) | Unavailable | 12:06 | 12:13 | 6.9 s | Unavailable | 12:06-12:13 | 0.02 km | Raw segment marker | Yes |  | HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth. |
| 7 | HKWorkoutEventType(rawValue: 1) | Unavailable | 12:14 | 12:14 | 0.0 s | Unavailable | Unavailable | Unavailable | Unavailable | No | Excluded from segment rendering: zero or negative duration. | No rendered segment marker candidate. |

## HKWorkoutActivity Inventory

Debug-only inventory of public `HKWorkout.workoutActivities` rows. These rows are not used for production interval reconstruction.

| Activity | Type | Start Date | End Date | Start Offset | End Offset | Duration | Metadata Keys | Nested Events | Statistics | Aligns Planned Step | Aligned Planned Step | Nearest Reconstructed Row | Row End Delta | Apple Fitness/manual | FIT Lap | Raw Event Start | Raw Start Delta | Raw Event End | Raw End Delta | Segment Start | Segment Start Delta | Segment End | Segment End Delta | Previous Sample End | Crossing Sample End | Next Sample End |
|---:|---|---|---|---:|---:|---:|---|---|---|---|---|---|---:|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | HKWorkoutActivityType(rawValue: 37) | 2026-06-14T11:52:37Z | 2026-06-14T12:04:50Z | 0.0 s | 733.8 s | 733.8 s | HKElevationAscended, WOIntervalStepKeyPath | 7 event(s): HKWorkoutEventType(rawValue: 1), HKWorkoutEventType(rawValue: 7) | ActiveEnergyBurned: sum 187.9 kcal; BasalEnergyBurned: sum 17.8 kcal; DistanceWalkingRunning: sum 3026.0 m; HeartRate: avg 169.9 bpm, min 104.0 bpm, max 184.0 bpm | Yes | Work 1 | Open / Extra | 0.0 s | Unavailable in runtime export; compare manual fixture after export. | Manual FIT placeholder; FIT is not runtime truth. | 0.0 s | 0.0 s | 732.8 s | -1.0 s | 0.0 s | 0.0 s | 732.8 s | -1.0 s | Unavailable | Unavailable | Unavailable |

## WorkoutKit Reconstructed Intervals

Planned structure source: WorkoutKit when available. Measured stats source: HealthKit samples.

| Row | Label | Goal | Target | Distance | Time | Pace | Avg HR | Max HR | Power | Start Offset | End Offset | Boundary Strategy | Boundary Adjustment | Overshoot | Confidence | Notes |
|---:|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---:|---:|---|---|
| 1 | Open / Extra | Open | Target unavailable | 3.03 km | 12:14 | 4:03 /km | 171 bpm | 184 bpm | 295 W | 0:00 | 12:14 |  |  |  | Medium | Extra tail after planned WorkoutKit steps |

Notes: Plan source: WorkoutKit · Window source: Plan-derived from HealthKit distance/time samples · Stats source: HealthKit samples · HealthKit segment markers: not used · Could not reconstruct Work 1; missing usable distance evidence.

## HKWorkoutActivity Boundary Candidate Intervals

Debug-only alternate reconstruction for Parity Lab exports. These rows are not production interval logic and are not shown in the normal workout UI.

| Field | Value |
|---|---|
| Mapping status | mappedByPlannedStepOrder |
| Activity count | 1 |
| Planned step count | 1 |
| Scoreable | Yes |
| Not scoreable reason | n/a |
| Production UI warning | HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI. |

| Row | Label | Goal | Mapping | Activity | Start Offset | End Offset | Distance | Time | Candidate Confidence | Reason If Not Scoreable | Caveats |
|---:|---|---|---|---:|---:|---:|---:|---:|---|---|---|
| 1 | Work 1 | 5 km | mappedByPlannedStepOrder | 1 | 0.0 s | 733.8 s | 3026.0 m | 733.8 s | activity boundary direct |  | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |

Caveats: debug-only, not promoted · not production interval logic · not shown in normal workout UI · FIT and Apple Fitness/manual rows are not runtime inputs · Activities are generic HealthKit activity windows and labels are mapped from WorkoutKit planned step order. · Missing or ambiguous activity rows must not replace current reconstruction.

## Custom Workout Candidate Rule Scorer

Debug-only Parity Lab scorer for active-time duration, pause overlap, and Open / Extra tail rows. These rows are not production interval logic and are not shown in the normal workout UI.

| Field | Value |
|---|---|
| Strategy | custom_workout_candidate_rule_active_time |
| Rule status | candidate-rule-scoreable |
| Candidate row count | 1 |
| Open tail row count | 0 |
| Paired pause count | 0 |
| Total paired pause | 0.0 s |
| Scoreable | Yes |
| Not scoreable reason | n/a |
| Production UI warning | Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI. |

| Row | Label | Mapping | Elapsed | Pause overlap | Active time | Distance | Duration rule | Confidence | Caveats |
|---:|---|---|---:|---:|---:|---:|---|---|---|
| 1 | Work 1 | mappedByPlannedStepOrder | 733.8 s | 0.0 s | 733.8 s | 3026.0 m | active-duration-minus-paired-pause-overlap | activity boundary direct | debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Active duration subtracts paired HealthKit pause/resume overlap when available. debug-only, not promoted not production interval logic not shown in normal workout UI FIT and Apple Fitness/manual rows are not runtime inputs Mapped to WorkoutKit planned step order only. Uses public HKWorkoutActivity statistics and date windows. |

Caveats: debug-only, not promoted · not production interval logic · not shown in normal workout UI · FIT and Apple Fitness/manual rows are not runtime inputs · Active duration subtracts paired HealthKit pause/resume overlap when available.

## Custom Workout Structured Comparison

Debug-only structured status and fallback taxonomy for Parity Lab rows. This is not production interval logic and is not shown in the normal workout UI.

| Field | Value |
|---|---|
| Status | supported |
| Fallback reasons | None |
| Row count | 1 |
| Row confidences | supported |
| Tail ambiguity | none |
| Promotes production behavior | No |
| Scope | debug/export-only |

## WorkoutKit Boundary Diagnostics

### Row 1: Open / Extra Tail

| Field | Value |
|---|---:|
| Planned final step end offset | 0:00 |
| Workout end offset | 12:14 |
| Remaining seconds | 733.8 s |
| Remaining meters | 3026.0 m |
| Final distance sample offset | 12:10 |
| Final distance sample cumulative | 3026.0 m |
| Last HR sample offset | 12:11 |
| Last power sample offset | 12:08 |
| Last cadence sample offset | 12:13 |
| Reason | Remaining workout time or distance exceeded Open / Extra threshold after planned WorkoutKit steps. |

## HealthKit Segment Markers

Raw debug only. HealthKit Segment Markers must not be promoted as Apple Fitness interval rows.

| Row | Label | Marker Kind | Source | Distance | Time | Pace | Avg HR | Start Offset | End Offset | Confidence | Caveats |
|---:|---|---|---|---:|---:|---:|---:|---:|---:|---|---|
| 1 | Unknown | Split marker | HealthKit segment pattern | 1.01 km | 3:56 | 3:54 /km | 156 bpm | 0:00 | 3:56 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event window matches a split-like distance marker, not an Apple Fitness interval row. |
| 2 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.62 km | 6:17 | 3:53 /km | 162 bpm | 0:00 | 6:17 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 3 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 3:54 | 3:54 /km | 175 bpm | 3:56 | 7:50 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 4 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.41 km | 5:56 | 4:13 /km | 180 bpm | 6:17 | 12:13 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 5 | Unknown | Overlapping segment marker | HealthKit segment pattern | 1.00 km | 4:16 | 4:16 /km | 181 bpm | 7:50 | 12:06 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event overlaps another segment window, so it should stay raw/debug-only. |
| 6 | Unknown | Raw segment marker | HealthKit segment pattern | 0.02 km | 0:07 | 7:10 /km | 181 bpm | 12:06 | 12:13 | Limited | HealthKit did not expose an Apple Fitness interval label for this event. This event is a raw HealthKit marker until interval parity is proven. |

## Planned Step Boundary Comparison

Debug-only comparison helper for FIT/Apple boundary investigation. The FIT lap end offset is intentionally a manual placeholder; RunSignal does not read FIT at runtime.

| Row | Planned Step | Goal | RunSignal End | FIT Lap End | Nearest Raw Event End | Event Delta | Nearest Activity End | Activity Delta | Activity Type | Nearest Segment End | Segment Delta | Previous Sample End | Crossing Sample End | Next Sample End | Warning |
|---:|---|---|---:|---:|---:|---:|---:|---:|---|---:|---:|---:|---:|---:|---|
| 1 | Work 1 | Open | 733.8 s | Manual FIT placeholder | 732.8 s | -1.0 s | 733.8 s | 0.0 s | HKWorkoutActivityType(rawValue: 37) | 732.8 s | -1.0 s | Unavailable | Unavailable | Unavailable |  |

## Boundary Source Warnings

- One or more raw HKWorkoutEvent records have unavailable metadata keys.
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
      "distanceMeters" : 3026.0183546345215,
      "durationSeconds" : 733.815575003624,
      "endOffsetSeconds" : 733.815575003624,
      "index" : 1,
      "label" : "Work 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "plannedGoalDisplayText" : "5 km",
      "plannedGoalType" : "distance",
      "plannedGoalValue" : 5000,
      "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
      "startOffsetSeconds" : 0,
      "stepType" : "work"
    }
  ],
  "activityBoundaryCandidateSummary" : {
    "activityCount" : 1,
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
    "plannedStepCount" : 1,
    "productionIntervalBehaviorChanged" : false,
    "productionUIWarning" : "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI.",
    "scope" : "debug\/export-only",
    "strategyID" : "hkworkoutactivity_boundary",
    "usesAppleFitnessManualRuntimeLogic" : false,
    "usesFITRuntimeTruth" : false
  },
  "boundaryDiagnostics" : [
    {
      "index" : 1,
      "label" : "Open \/ Extra",
      "tail" : {
        "creationReason" : "Remaining workout time or distance exceeded Open \/ Extra threshold after planned WorkoutKit steps.",
        "finalDistanceSampleCumulativeDistanceMeters" : 3026.0183546345215,
        "finalDistanceSampleOffsetSeconds" : 730.2745238542557,
        "lastCadenceSampleOffsetSeconds" : 732.8471400737762,
        "lastHeartRateSampleOffsetSeconds" : 731.1994960308075,
        "lastPowerSampleOffsetSeconds" : 727.701909661293,
        "plannedFinalStepEndOffsetSeconds" : 0,
        "remainingMeters" : 3026.0183546345215,
        "remainingSeconds" : 733.815575003624,
        "workoutEndOffsetSeconds" : 733.815575003624
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
  "customWorkoutCandidateRuleRows" : [
    {
      "activeDurationSeconds" : 733.815575003624,
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
      "distanceMeters" : 3026.0183546345215,
      "durationRule" : "active-duration-minus-paired-pause-overlap",
      "elapsedDurationSeconds" : 733.815575003624,
      "index" : 1,
      "isOpenTail" : false,
      "label" : "Work 1",
      "mappingStatus" : "mappedByPlannedStepOrder",
      "pauseOverlapSeconds" : 0,
      "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
      "stepType" : "work"
    }
  ],
  "customWorkoutCandidateRuleSummary" : {
    "boundaryLogicChanged" : false,
    "candidateRowCount" : 1,
    "caveats" : [
      "debug-only, not promoted",
      "not production interval logic",
      "not shown in normal workout UI",
      "FIT and Apple Fitness\/manual rows are not runtime inputs",
      "Active duration subtracts paired HealthKit pause\/resume overlap when available."
    ],
    "isScoreable" : true,
    "normalWorkoutUIChanged" : false,
    "openTailRowCount" : 0,
    "pairedPauseCount" : 0,
    "productionIntervalBehaviorChanged" : false,
    "productionUIWarning" : "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI.",
    "ruleStatus" : "candidate-rule-scoreable",
    "scope" : "debug\/export-only",
    "strategyID" : "custom_workout_candidate_rule_active_time",
    "totalPairedPauseSeconds" : 0,
    "usesAppleFitnessManualRuntimeLogic" : false,
    "usesFITRuntimeTruth" : false
  },
  "customWorkoutComparisonSummary" : {
    "fallbackReasons" : [

    ],
    "normalWorkoutUIChanged" : false,
    "productionIntervalBehaviorChanged" : false,
    "promotesProductionBehavior" : false,
    "rowConfidences" : [
      "supported"
    ],
    "rowCount" : 1,
    "scope" : "debug\/export-only",
    "status" : "supported",
    "tailAmbiguity" : "none",
    "usesFITRuntimeTruth" : false
  },
  "evidenceCounts" : {
    "activeEnergy" : 283,
    "activities" : 1,
    "cadence" : 285,
    "distance" : 284,
    "events" : 7,
    "groundContact" : 128,
    "heartRate" : 149,
    "power" : 282,
    "routePoints" : 734,
    "speed" : 283,
    "stepCount" : 285,
    "strideLength" : 128,
    "verticalOscillation" : 128
  },
  "generatedAt" : "2026-06-14T19:48:43Z",
  "plannedStepBoundaryComparisons" : [
    {
      "index" : 1,
      "nearestRawEventEndDeltaSeconds" : -0.9684349298477173,
      "nearestRawEventEndOffsetSeconds" : 732.8471400737762,
      "nearestRawEventStartOffsetSeconds" : 377.2422090768814,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestSegmentMarkerEndDeltaSeconds" : -0.9684349298477173,
      "nearestSegmentMarkerEndOffsetSeconds" : 732.8471400737762,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartOffsetSeconds" : 377.2422090768814,
      "nearestWorkoutActivityEndDeltaSeconds" : 0,
      "nearestWorkoutActivityEndOffsetSeconds" : 733.815575003624,
      "nearestWorkoutActivityStartOffsetSeconds" : 0,
      "nearestWorkoutActivityType" : "HKWorkoutActivityType(rawValue: 37)",
      "plannedGoalDisplayText" : "Open",
      "plannedStepLabel" : "Work 1",
      "reconstructedEndOffsetSeconds" : 733.815575003624,
      "reconstructedLabel" : "Open \/ Extra"
    }
  ],
  "rawWorkoutEvents" : [
    {
      "durationSeconds" : 235.97900211811066,
      "endDate" : "2026-06-14T11:56:32Z",
      "endOffsetSeconds" : 235.97900211811066,
      "index" : 1,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1009.8686886617138,
      "renderedSegmentMarkerDurationSeconds" : 235.97900211811066,
      "renderedSegmentMarkerEndOffsetSeconds" : 235.97900211811066,
      "renderedSegmentMarkerKind" : "splitMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-14T11:52:37Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 377.2422090768814,
      "endDate" : "2026-06-14T11:58:54Z",
      "endOffsetSeconds" : 377.2422090768814,
      "index" : 2,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1620.8297595454378,
      "renderedSegmentMarkerDurationSeconds" : 377.2422090768814,
      "renderedSegmentMarkerEndOffsetSeconds" : 377.2422090768814,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 0,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-14T11:52:37Z",
      "startOffsetSeconds" : 0,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 234.22505474090576,
      "endDate" : "2026-06-14T12:00:27Z",
      "endOffsetSeconds" : 470.2040568590164,
      "index" : 3,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1000.9256927971862,
      "renderedSegmentMarkerDurationSeconds" : 234.22505474090576,
      "renderedSegmentMarkerEndOffsetSeconds" : 470.2040568590164,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 235.97900211811066,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-14T11:56:32Z",
      "startOffsetSeconds" : 235.97900211811066,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 355.60493099689484,
      "endDate" : "2026-06-14T12:04:49Z",
      "endOffsetSeconds" : 732.8471400737762,
      "index" : 4,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 1405.1885950890837,
      "renderedSegmentMarkerDurationSeconds" : 355.60493099689484,
      "renderedSegmentMarkerEndOffsetSeconds" : 732.8471400737762,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 377.2422090768814,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-14T11:58:54Z",
      "startOffsetSeconds" : 377.2422090768814,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 255.75479066371918,
      "endDate" : "2026-06-14T12:04:42Z",
      "endOffsetSeconds" : 725.9588475227356,
      "index" : 5,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 999.1904367474547,
      "renderedSegmentMarkerDurationSeconds" : 255.75479066371918,
      "renderedSegmentMarkerEndOffsetSeconds" : 725.9588475227356,
      "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 470.2040568590164,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-14T12:00:27Z",
      "startOffsetSeconds" : 470.2040568590164,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 6.888292551040649,
      "endDate" : "2026-06-14T12:04:49Z",
      "endOffsetSeconds" : 732.8471400737762,
      "index" : 6,
      "metadataKeys" : [

      ],
      "renderedSegmentMarkerDistanceMeters" : 16.033536428166826,
      "renderedSegmentMarkerDurationSeconds" : 6.888292551040649,
      "renderedSegmentMarkerEndOffsetSeconds" : 732.8471400737762,
      "renderedSegmentMarkerKind" : "rawSegmentMarker",
      "renderedSegmentMarkerStartOffsetSeconds" : 725.9588475227356,
      "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
      "startDate" : "2026-06-14T12:04:42Z",
      "startOffsetSeconds" : 725.9588475227356,
      "type" : "HKWorkoutEventType(rawValue: 7)",
      "usedBySegmentMarkerRendering" : true
    },
    {
      "durationSeconds" : 0,
      "endDate" : "2026-06-14T12:04:50Z",
      "endOffsetSeconds" : 733.815575003624,
      "excludedOrFilteredReason" : "zeroOrNegativeDuration",
      "index" : 7,
      "metadataKeys" : [

      ],
      "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
      "startDate" : "2026-06-14T12:04:50Z",
      "startOffsetSeconds" : 733.815575003624,
      "type" : "HKWorkoutEventType(rawValue: 1)",
      "usedBySegmentMarkerRendering" : false
    }
  ],
  "reconstructedIntervals" : [
    {
      "averageHeartRateBpm" : 171.16107382550337,
      "averagePower" : 294.6418439716312,
      "confidence" : "medium",
      "distanceMeters" : 3026.0183546345215,
      "durationSeconds" : 733.815575003624,
      "endOffsetSeconds" : 733.815575003624,
      "index" : 1,
      "label" : "Open \/ Extra",
      "maxHeartRateBpm" : 184,
      "paceSecondsPerKm" : 242.5020237830822,
      "plannedGoalDisplayText" : "Open",
      "plannedGoalType" : "open",
      "sourceNote" : "Extra tail after planned WorkoutKit steps",
      "startOffsetSeconds" : 0,
      "stepType" : "open",
      "tailDiagnostics" : {
        "creationReason" : "Remaining workout time or distance exceeded Open \/ Extra threshold after planned WorkoutKit steps.",
        "finalDistanceSampleCumulativeDistanceMeters" : 3026.0183546345215,
        "finalDistanceSampleOffsetSeconds" : 730.2745238542557,
        "lastCadenceSampleOffsetSeconds" : 732.8471400737762,
        "lastHeartRateSampleOffsetSeconds" : 731.1994960308075,
        "lastPowerSampleOffsetSeconds" : 727.701909661293,
        "plannedFinalStepEndOffsetSeconds" : 0,
        "remainingMeters" : 3026.0183546345215,
        "remainingSeconds" : 733.815575003624,
        "workoutEndOffsetSeconds" : 733.815575003624
      }
    }
  ],
  "segmentMarkers" : [
    {
      "averageHeartRateBpm" : 155.9375,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event window matches a split-like distance marker, not an Apple Fitness interval row."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1009.8686886617138,
      "durationSeconds" : 235.97900211811066,
      "endOffsetSeconds" : 235.97900211811066,
      "index" : 1,
      "label" : "unknown",
      "markerKind" : "splitMarker",
      "paceSecondsPerKm" : 233.67295646212375,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 162.43421052631578,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1620.8297595454378,
      "durationSeconds" : 377.2422090768814,
      "endOffsetSeconds" : 377.2422090768814,
      "index" : 2,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 232.74634911853983,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 0
    },
    {
      "averageHeartRateBpm" : 175.08333333333334,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1000.9256927971862,
      "durationSeconds" : 234.22505474090576,
      "endOffsetSeconds" : 470.2040568590164,
      "index" : 3,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 234.00843481831365,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 235.97900211811066
    },
    {
      "averageHeartRateBpm" : 180.24657534246575,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 1405.1885950890837,
      "durationSeconds" : 355.60493099689484,
      "endOffsetSeconds" : 732.8471400737762,
      "index" : 4,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 253.06562566738654,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 377.2422090768814
    },
    {
      "averageHeartRateBpm" : 181.40384615384616,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event overlaps another segment window, so it should stay raw\/debug-only."
      ],
      "confidence" : "limited",
      "distanceMeters" : 999.1904367474547,
      "durationSeconds" : 255.75479066371918,
      "endOffsetSeconds" : 725.9588475227356,
      "index" : 5,
      "label" : "unknown",
      "markerKind" : "overlappingSegmentMarker",
      "paceSecondsPerKm" : 255.96200809952427,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 470.2040568590164
    },
    {
      "averageHeartRateBpm" : 181,
      "caveats" : [
        "HealthKit did not expose an Apple Fitness interval label for this event.",
        "This event is a raw HealthKit marker until interval parity is proven."
      ],
      "confidence" : "limited",
      "distanceMeters" : 16.033536428166826,
      "durationSeconds" : 6.888292551040649,
      "endOffsetSeconds" : 732.8471400737762,
      "index" : 6,
      "label" : "unknown",
      "markerKind" : "rawSegmentMarker",
      "paceSecondsPerKm" : 429.61779404696273,
      "source" : "healthKitSegmentPattern",
      "startOffsetSeconds" : 725.9588475227356
    }
  ],
  "sourceNotes" : [
    "Plan source: WorkoutKit",
    "Window source: Plan-derived from HealthKit distance\/time samples",
    "Stats source: HealthKit samples",
    "HealthKit segment markers: not used",
    "Could not reconstruct Work 1; missing usable distance evidence."
  ],
  "workout" : {
    "averageHeartRate" : 172.07046799354492,
    "averagePower" : 294.64184397163115,
    "cadenceSpm" : 189.19962197459225,
    "deviceName" : "Apple Watch Apple Inc. Watch",
    "distanceMeters" : 3026.0183546345215,
    "durationSeconds" : 733.815575003624,
    "elapsedSeconds" : 733.815575003624,
    "endDate" : "2026-06-14T12:04:50Z",
    "id" : "D57BFD29-EEF1-453D-9A98-4BE0E4159C8E",
    "maxHeartRate" : 184,
    "paceSecondsPerKm" : 242.5020237830822,
    "sourceID" : "D57BFD29-EEF1-453D-9A98-4BE0E4159C8E",
    "sourceName" : "Adriel’s Apple Watch",
    "startDate" : "2026-06-14T11:52:37Z"
  },
  "workoutActivities" : [
    {
      "activityType" : "HKWorkoutActivityType(rawValue: 37)",
      "alignedPlannedStepIndex" : 1,
      "alignedPlannedStepLabel" : "Work 1",
      "alignsWithPlannedStep" : true,
      "appleFitnessManualRowReference" : "Unavailable in runtime export; compare manual fixture after export.",
      "durationSeconds" : 733.815575003624,
      "endDate" : "2026-06-14T12:04:50Z",
      "endOffsetSeconds" : 733.815575003624,
      "events" : [
        {
          "durationSeconds" : 235.97900211811066,
          "endDate" : "2026-06-14T11:56:32Z",
          "endOffsetSeconds" : 235.97900211811066,
          "index" : 1,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1009.8686886617138,
          "renderedSegmentMarkerDurationSeconds" : 235.97900211811066,
          "renderedSegmentMarkerEndOffsetSeconds" : 235.97900211811066,
          "renderedSegmentMarkerKind" : "splitMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-14T11:52:37Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 377.2422090768814,
          "endDate" : "2026-06-14T11:58:54Z",
          "endOffsetSeconds" : 377.2422090768814,
          "index" : 2,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1620.8297595454378,
          "renderedSegmentMarkerDurationSeconds" : 377.2422090768814,
          "renderedSegmentMarkerEndOffsetSeconds" : 377.2422090768814,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 0,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-14T11:52:37Z",
          "startOffsetSeconds" : 0,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 234.22505474090576,
          "endDate" : "2026-06-14T12:00:27Z",
          "endOffsetSeconds" : 470.2040568590164,
          "index" : 3,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1000.9256927971862,
          "renderedSegmentMarkerDurationSeconds" : 234.22505474090576,
          "renderedSegmentMarkerEndOffsetSeconds" : 470.2040568590164,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 235.97900211811066,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-14T11:56:32Z",
          "startOffsetSeconds" : 235.97900211811066,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 355.60493099689484,
          "endDate" : "2026-06-14T12:04:49Z",
          "endOffsetSeconds" : 732.8471400737762,
          "index" : 4,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 1405.1885950890837,
          "renderedSegmentMarkerDurationSeconds" : 355.60493099689484,
          "renderedSegmentMarkerEndOffsetSeconds" : 732.8471400737762,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 377.2422090768814,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-14T11:58:54Z",
          "startOffsetSeconds" : 377.2422090768814,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 255.75479066371918,
          "endDate" : "2026-06-14T12:04:42Z",
          "endOffsetSeconds" : 725.9588475227356,
          "index" : 5,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 999.1904367474547,
          "renderedSegmentMarkerDurationSeconds" : 255.75479066371918,
          "renderedSegmentMarkerEndOffsetSeconds" : 725.9588475227356,
          "renderedSegmentMarkerKind" : "overlappingSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 470.2040568590164,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-14T12:00:27Z",
          "startOffsetSeconds" : 470.2040568590164,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 6.888292551040649,
          "endDate" : "2026-06-14T12:04:49Z",
          "endOffsetSeconds" : 732.8471400737762,
          "index" : 6,
          "metadataKeys" : [

          ],
          "renderedSegmentMarkerDistanceMeters" : 16.033536428166826,
          "renderedSegmentMarkerDurationSeconds" : 6.888292551040649,
          "renderedSegmentMarkerEndOffsetSeconds" : 732.8471400737762,
          "renderedSegmentMarkerKind" : "rawSegmentMarker",
          "renderedSegmentMarkerStartOffsetSeconds" : 725.9588475227356,
          "segmentMarkerDebugOnlyReason" : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth",
          "startDate" : "2026-06-14T12:04:42Z",
          "startOffsetSeconds" : 725.9588475227356,
          "type" : "HKWorkoutEventType(rawValue: 7)",
          "usedBySegmentMarkerRendering" : true
        },
        {
          "durationSeconds" : 0,
          "endDate" : "2026-06-14T12:04:50Z",
          "endOffsetSeconds" : 733.815575003624,
          "excludedOrFilteredReason" : "zeroOrNegativeDuration",
          "index" : 7,
          "metadataKeys" : [

          ],
          "segmentMarkerDebugOnlyReason" : "noRenderedSegmentMarkerCandidate",
          "startDate" : "2026-06-14T12:04:50Z",
          "startOffsetSeconds" : 733.815575003624,
          "type" : "HKWorkoutEventType(rawValue: 1)",
          "usedBySegmentMarkerRendering" : false
        }
      ],
      "eventsSummary" : "7 event(s): HKWorkoutEventType(rawValue: 1), HKWorkoutEventType(rawValue: 7)",
      "fitLapReference" : "Manual FIT placeholder; FIT is not runtime truth.",
      "id" : "AAC65F46-6D30-4E68-935E-BC934618845E",
      "index" : 1,
      "locationType" : "HKWorkoutSessionLocationType(rawValue: 3)",
      "metadataKeys" : [
        "HKElevationAscended",
        "WOIntervalStepKeyPath"
      ],
      "nearestRawEventEndDeltaSeconds" : -0.9684349298477173,
      "nearestRawEventEndOffsetSeconds" : 732.8471400737762,
      "nearestRawEventStartDeltaSeconds" : 0,
      "nearestRawEventStartOffsetSeconds" : 0,
      "nearestRawEventType" : "HKWorkoutEventType(rawValue: 7)",
      "nearestReconstructedIntervalEndDeltaSeconds" : 0,
      "nearestReconstructedIntervalEndOffsetSeconds" : 733.815575003624,
      "nearestReconstructedIntervalIndex" : 1,
      "nearestReconstructedIntervalLabel" : "Open \/ Extra",
      "nearestSegmentMarkerEndDeltaSeconds" : -0.9684349298477173,
      "nearestSegmentMarkerEndOffsetSeconds" : 732.8471400737762,
      "nearestSegmentMarkerKind" : "overlappingSegmentMarker",
      "nearestSegmentMarkerStartDeltaSeconds" : 0,
      "nearestSegmentMarkerStartOffsetSeconds" : 0,
      "startDate" : "2026-06-14T11:52:37Z",
      "startOffsetSeconds" : 0,
      "statistics" : [
        {
          "endDate" : "2026-06-14T12:04:50Z",
          "quantityType" : "HKQuantityTypeIdentifierActiveEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-14T11:52:37Z",
          "sum" : 187.92697871510808,
          "summary" : "ActiveEnergyBurned: sum 187.9 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-14T12:04:50Z",
          "quantityType" : "HKQuantityTypeIdentifierBasalEnergyBurned",
          "sourceCount" : 0,
          "startDate" : "2026-06-14T11:52:37Z",
          "sum" : 17.82051060345333,
          "summary" : "BasalEnergyBurned: sum 17.8 kcal",
          "unit" : "kcal"
        },
        {
          "endDate" : "2026-06-14T12:04:50Z",
          "quantityType" : "HKQuantityTypeIdentifierDistanceWalkingRunning",
          "sourceCount" : 0,
          "startDate" : "2026-06-14T11:52:37Z",
          "sum" : 3026.0183546345215,
          "summary" : "DistanceWalkingRunning: sum 3026.0 m",
          "unit" : "m"
        },
        {
          "average" : 169.90247621033512,
          "endDate" : "2026-06-14T12:04:50Z",
          "maximum" : 184,
          "minimum" : 104,
          "quantityType" : "HKQuantityTypeIdentifierHeartRate",
          "sourceCount" : 0,
          "startDate" : "2026-06-14T11:52:37Z",
          "summary" : "HeartRate: avg 169.9 bpm, min 104.0 bpm, max 184.0 bpm",
          "unit" : "bpm"
        },
        {
          "average" : 192.92968750000003,
          "endDate" : "2026-06-14T12:04:50Z",
          "maximum" : 215,
          "minimum" : 182,
          "quantityType" : "HKQuantityTypeIdentifierRunningGroundContactTime",
          "sourceCount" : 0,
          "startDate" : "2026-06-14T11:52:37Z",
          "summary" : "RunningGroundContactTime: avg 192.9 ms, min 182.0 ms, max 215.0 ms",
          "unit" : "ms"
        },
        {
          "average" : 294.64184397163115,
          "endDate" : "2026-06-14T12:04:50Z",
          "maximum" : 352,
          "minimum" : 160,
          "quantityType" : "HKQuantityTypeIdentifierRunningPower",
          "sourceCount" : 0,
          "startDate" : "2026-06-14T11:52:37Z",
          "summary" : "RunningPower: avg 294.6 W, min 160.0 W, max 352.0 W",
          "unit" : "W"
        },
        {
          "average" : 4.1966680075853935,
          "endDate" : "2026-06-14T12:04:50Z",
          "maximum" : 5.015578712433614,
          "minimum" : 3.400865950529044,
          "quantityType" : "HKQuantityTypeIdentifierRunningSpeed",
          "sourceCount" : 0,
          "startDate" : "2026-06-14T11:52:37Z",
          "summary" : "RunningSpeed: avg 4.2 m\/s, min 3.4 m\/s, max 5.0 m\/s",
          "unit" : "m\/s"
        },
        {
          "average" : 1.3245312499999997,
          "endDate" : "2026-06-14T12:04:50Z",
          "maximum" : 1.47,
          "minimum" : 1.2,
          "quantityType" : "HKQuantityTypeIdentifierRunningStrideLength",
          "sourceCount" : 0,
          "startDate" : "2026-06-14T11:52:37Z",
          "summary" : "RunningStrideLength: avg 1.3 m, min 1.2 m, max 1.5 m",
          "unit" : "m"
        },
        {
          "average" : 7.0367187499999995,
          "endDate" : "2026-06-14T12:04:50Z",
          "maximum" : 7.8,
          "minimum" : 6.5,
          "quantityType" : "HKQuantityTypeIdentifierRunningVerticalOscillation",
          "sourceCount" : 0,
          "startDate" : "2026-06-14T11:52:37Z",
          "summary" : "RunningVerticalOscillation: avg 7.0 cm, min 6.5 cm, max 7.8 cm",
          "unit" : "cm"
        },
        {
          "endDate" : "2026-06-14T12:04:50Z",
          "quantityType" : "HKQuantityTypeIdentifierStepCount",
          "sourceCount" : 0,
          "startDate" : "2026-06-14T11:52:37Z",
          "sum" : 2311.376438865472,
          "summary" : "StepCount: sum 2311.4 count",
          "unit" : "count"
        }
      ],
      "statisticsSummary" : "ActiveEnergyBurned: sum 187.9 kcal; BasalEnergyBurned: sum 17.8 kcal; DistanceWalkingRunning: sum 3026.0 m; HeartRate: avg 169.9 bpm, min 104.0 bpm, max 184.0 bpm"
    }
  ],
  "workoutKitPlanAudit" : {
    "displayName" : "Test Race Day 5k",
    "planID" : "C42730A2-7833-4F1F-9FC5-6D9103361287",
    "planType" : "Custom workout",
    "plannedSteps" : [
      {
        "index" : 1,
        "label" : "Work 1",
        "plannedGoalDisplayText" : "5 km",
        "plannedGoalType" : "distance",
        "plannedGoalValue" : 5000,
        "plannedTargetDisplayText" : "pace 4:00 \/km, speed 4.17 m\/s, metric current",
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
      "Block 1 step 1: Work - goal 5 km, alert pace 4:00 \/km, speed 4.17 m\/s, metric current",
      "Cooldown: none"
    ]
  }
}
```