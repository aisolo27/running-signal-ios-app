# HealthKit And WorkoutKit Implementation Reference

Last updated: 2026-07-03

This is a source-map for explaining RunSignal's current Apple Health implementation to another AI or developer. It describes the app as built today, not a future plan.

## Runtime Boundaries

- HealthKit is the runtime source of truth for completed running workouts.
- HealthKit access is read-only. The app requests no share/write permissions.
- WorkoutKit is used only when `HKWorkout.workoutPlan` is available, so the app can read planned custom-workout structure.
- HealthKit workout summaries, quantity samples, routes, events, and activities provide measured evidence.
- HealthFit, FIT files, Apple Fitness screenshots, and manual rows are validation/reference material only. They are not runtime app inputs and should not be added as production data sources unless the product direction changes.
- HealthKit segment/lap/marker events are raw/debug evidence. They are not treated as Apple Fitness interval rows in normal detail.

## Main Data Flow

1. `HealthKitService` asks for read-only HealthKit authorization and loads running `HKWorkout` samples.
2. `HealthKitWorkoutMapper` converts each `HKWorkout` into `CanonicalWorkout`.
3. `WorkoutEvidenceService` loads detailed workout-scoped evidence for the newest configured workouts.
4. `WorkoutEvidence` stores series points, route points, raw events, workout activities, diagnostics, and optional WorkoutKit plan audit.
5. `CustomWorkoutResolvedIntervalRows` promotes custom workout interval rows only when WorkoutKit planned rows and HealthKit activity boundaries pass the evidence gate.
6. `DerivedAnalyticsEngine`, `PersonalBestEffortEngine`, and the SwiftUI views consume canonical workouts and evidence-gated rows for analytics, charts, best efforts, debug screens, and exports.

## HealthKit Authorization And Loading

Source files:

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/HealthKitService.swift`
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/HealthKitPermissionCatalog.swift`
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/HealthKitWorkoutMapper.swift`
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/HealthKitWorkoutSyncService.swift`

### Types

- `HealthKitService`: concrete read-only service backed by `HKHealthStore`. It requests authorization, queries completed running workouts, enriches specific workout IDs, and loads broad health context.
- `HealthKitServicing`: protocol used by the store/UI so HealthKit loading can be swapped or mocked.
- `HealthKitLoadResult`: return object for HealthKit load/enrichment calls. Contains `authorizationState`, loaded `workouts`, broad `healthContext`, and an optional user-facing `message`.
- `HealthKitPermissionCatalog`: central read-permission list and explanation text. Builds the `Set<HKObjectType>` passed to HealthKit authorization.
- `HealthKitPermissionScope`: groups requested read types into `coreRunning`, `calories`, `recovery`, `profile`, and `trainingLoad`.
- `HealthKitPermissionItem`: one requested HealthKit read item with identifier, reason, scope, and whether it is workout-scoped or broad context.
- `HealthKitWorkoutMapper`: converts raw `HKWorkout` objects into app-owned `CanonicalWorkout` records.
- `QuantityOption`: internal mapper enum for reading `HKStatistics` as `.sum`, `.discreteAverage`, or `.discreteMax`.
- `HealthKitSyncState`, `HealthKitWorkoutSyncResult`, `HealthKitWorkoutSyncService`, `HealthKitWorkoutSyncServicing`, `HealthKitSyncStateStore`: foreground/background sync state and incremental refresh plumbing.

### Key Variables And Use Cases

- `HealthKitService.store`: private `HKHealthStore` used for every HealthKit authorization and query call.
- `HealthKitService.defaultDetailedEvidenceLimit`: newest-workout cap for expensive detailed evidence loading during full history loads.
- `HealthKitService.isAvailable`: wraps `HKHealthStore.isHealthDataAvailable()` for Simulator/device availability checks.
- `HealthKitService.readTypes`: computed read-only `Set<HKObjectType>` from `HealthKitPermissionCatalog`.
- `queryRunningWorkouts().predicate`: `HKQuery.predicateForWorkouts(with: .running)`; restricts full history load to running workouts.
- `queryRunningWorkouts().sort`: descending `HKSampleSortIdentifierStartDate`; newest workouts first.
- `queryRunningWorkouts(ids:).uuids`: parsed workout UUID filter for targeted enrichment.
- `queryRunningWorkouts(ids:).idPredicate`: `HKQuery.predicateForObjects(with:)`; narrows enrichment to selected workouts.
- `queryRunningWorkouts(ids:).runningPredicate`: keeps targeted enrichment running-only.
- `queryRunningWorkouts(ids:).predicate`: compound ID + running predicate.
- `HealthKitWorkoutMapper.normalize().normalized`: output array of `CanonicalWorkout` values.
- `HealthKitWorkoutMapper.normalize().evidenceService`: `WorkoutEvidenceService` used to load detailed samples/routes/events/activity rows/plans.
- `HealthKitWorkoutMapper.normalize().detailWorkoutIDs`: newest workout UUIDs selected for detailed evidence.
- `HealthKitWorkoutMapper.normalize().shouldLoadDetail`: per-workout flag deciding whether to load detailed evidence or keep summary-only evidence.
- `HealthKitWorkoutMapper.normalize().evidence`: `WorkoutEvidence` attached to the canonical workout; either fully loaded or empty summary-only placeholder.
- `HealthKitWorkoutMapper.normalize().routeAvailable`: true when route points exist or a route sample candidate exists.
- `HealthKitWorkoutMapper.normalize().canonical`: app-owned workout model populated from `HKWorkout`, `HKStatistics`, and `WorkoutEvidence`.
- `HealthKitWorkoutMapper.quantity().type`: `HKQuantityType` resolved from an `HKQuantityTypeIdentifier`.
- `HealthKitWorkoutMapper.quantity().statistics`: workout-attached `HKStatistics` for sum/average/max values.
- `HealthKitWorkoutMapper.totalEnergyKilocalories().active`: active calories from workout statistics or evidence series.
- `HealthKitWorkoutMapper.totalEnergyKilocalories().basal`: basal calories from workout statistics or evidence series.

### HealthKit Objects Used

- `HKHealthStore`: HealthKit store used for authorization and queries.
- `HKWorkout`: completed running workout summary. Provides UUID, source, device, start/end, duration, total distance, energy, events, metadata, statistics, activities, and optional workout plan.
- `HKSampleQuery`: used to fetch workouts, quantity samples, and workout routes.
- `HKStatistics` / `HKStatisticsOptions`: used for summary values already attached to an `HKWorkout`.
- `HKQuantitySample`: workout-scoped metric sample converted into a timestamped evidence point.
- `HKWorkoutRoute` / `HKWorkoutRouteQuery`: route sample and route-point iterator.
- `HKWorkoutEvent`: raw workout event stream for pause/resume, lap, segment, marker, and debug labels.
- `HKWorkoutActivity`: HealthKit activity row boundary evidence used by the official custom workout resolver.
- `HKWorkoutActivityType`, `HKWorkoutConfiguration`, `HKWorkoutSessionLocationType`: activity classification fields stored as labels for diagnostics.
- `HKObjectType`, `HKQuantityType`, `HKSeriesType`, `HKCategoryType`, `HKCharacteristicType`: HealthKit type builders for authorization/querying.
- `HKUnit`: unit conversion for meters, seconds, BPM, watts, calories, centimeters, milliseconds, steps, and derived step cadence.
- `HKMetadataKeyIndoorWorkout`: used to infer indoor/outdoor when available.
- `HKMetadataKeyWorkoutBrandName`, `HKWorkoutSegmentName`, `WorkoutSegmentName`: metadata keys inspected only for raw interval/event label summaries.

### Read Types Requested

- Workouts: `HKWorkoutTypeIdentifier`.
- Workout routes: `HKSeriesTypeIdentifierWorkoutRoute`.
- Distance: `HKQuantityTypeIdentifierDistanceWalkingRunning`.
- Step count: `HKQuantityTypeIdentifierStepCount`.
- Heart rate: `HKQuantityTypeIdentifierHeartRate`.
- VO2 Max: `HKQuantityTypeIdentifierVO2Max`.
- Resting heart rate: `HKQuantityTypeIdentifierRestingHeartRate`.
- Active energy: `HKQuantityTypeIdentifierActiveEnergyBurned`.
- Basal energy: `HKQuantityTypeIdentifierBasalEnergyBurned`.
- Running speed: `HKQuantityTypeIdentifierRunningSpeed`.
- Running power: `HKQuantityTypeIdentifierRunningPower`.
- Running stride length: `HKQuantityTypeIdentifierRunningStrideLength`.
- Ground contact time: `HKQuantityTypeIdentifierRunningGroundContactTime`.
- Vertical oscillation: `HKQuantityTypeIdentifierRunningVerticalOscillation`.

## Canonical App Models

Source files:

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/Models.swift`
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/NormalizedRun.swift`
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/PersistenceService.swift`

### Types And Fields

- `AuthorizationState`: app-level HealthKit permission state: not requested, unavailable, requesting, authorized, denied, partial, or error.
- `HealthKitActionStatus`: UI/status wrapper for the latest HealthKit action message and timestamp.
- `HealthContext`: broad context values: `vo2Max`, `restingHeartRate`, `averageHeartRate`, `maxHeartRate`, and `activeEnergyKilocaloriesTotal`.
- `HealthContextVerification`: trust summary for whether broad context values are available.
- `WholeRunHealthKitSummary`: readiness summary for whether whole-run HealthKit review is usable.
- `CanonicalWorkout`: primary in-app workout record. Important HealthKit-derived fields:
  - Identity/source: `id`, `sourceID`, `sourceName`, `deviceName`.
  - Time: `startDate`, `endDate`, `durationSeconds`, `elapsedSeconds`.
  - Classification: `environment`, `inferredRunType`, `manualRunType`, `importedRunType`, `isDuplicate`, `duplicateOfID`.
  - Summary metrics: `distanceMeters`, `activeEnergyKilocalories`, `totalEnergyKilocalories`, `elevationGainMeters`, `averageHeartRate`, `maxHeartRate`, `averageCadence`, `averagePower`, `strideLengthMeters`, `verticalOscillationCentimeters`, `groundContactMilliseconds`.
  - Evidence availability: `routeAvailable`, `seriesAvailable`, `routePointCount`, `seriesSampleCount`, metric-specific sample counts, `intervalCount`, `intervalLabelsSummary`.
  - Attached detail: `evidence`.
- `PersistedWorkout`: SwiftData persistence mirror of `CanonicalWorkout`, excluding heavyweight detailed evidence.
- `MetricSourceKind`: provenance category for normalized metrics: HealthKit workout summary, workout-scoped sample, broad context, derived, inferred, or unavailable.
- `MetricProvenance`: source, HealthKit type, calculation method, confidence, and warning for a metric.
- `NormalizedRunDataQuality`: normalized run source/confidence/warnings summary.
- `NormalizedRun`: external/normalized representation with summary metrics, series arrays, route points, events, data quality, notes, and provenance.

## Workout Evidence Layer

Source files:

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/WorkoutEvidence.swift`
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/WorkoutEvidenceService.swift`

### Evidence Types

- `WorkoutEvidenceMetric`: supported series metrics: heart rate, running speed, distance, active energy, basal energy, running power, cadence, step count, stride length, vertical oscillation, and ground contact time.
- `WorkoutEvidencePoint`: one timestamped metric value.
- `WorkoutRoutePoint`: one route point with date, latitude, longitude, optional altitude, and optional speed.
- `WorkoutEvidenceEvent`: normalized wrapper for `HKWorkoutEvent`. Stores start/end dates, raw type label, display label, and metadata keys.
- `WorkoutEvidenceActivityStatistic`: one statistic attached to a HealthKit activity row: quantity type, unit, start/end, source count, sum, average, minimum, maximum, and duration.
- `WorkoutEvidenceActivity`: normalized `HKWorkoutActivity` row. Stores row identity, activity type, location type, start/end, duration, metadata keys, row events, and row statistics.
- `WorkoutPlanAuditStatus`: WorkoutKit plan audit state: available, unavailable, failed, or unsupported.
- `WorkoutPlanAudit`: optional WorkoutKit plan evidence with status, plan ID, plan type, display name, summary lines, planned steps, and error message.
- `WorkoutMetricSeries`: metric series plus unit, sorted points, sample count, average, and maximum.
- `WorkoutEvidence`: full workout detail bundle: `workoutID`, `loadedAt`, `series`, `route`, `events`, `activities`, `workoutPlanAudit`, and query `diagnostics`.
- `WorkoutEvidenceDiagnostics` / `WorkoutEvidenceQueryDiagnostic`: query status, counts, and warnings for evidence loading.

### EvidenceService Local Results

`WorkoutEvidenceService` uses small internal result objects to keep HealthKit query outcomes explicit:

- `MetricLoadResult`: one metric series plus diagnostic.
- `SampleQueryResult`: raw sample query points plus optional error message.
- `RouteLoadResult`, `RouteQueryResult`, `RoutePointCollector`: route query state and converted route points.
- `ActivityLoadResult`: normalized HealthKit activities plus diagnostic.
- `PlanAuditResult`: WorkoutKit plan audit plus diagnostic.

### Key Variables And Use Cases

- `WorkoutEvidenceService.store`: `HKHealthStore` used for all evidence queries.
- `loadEvidence().heartRate`: async load for `HKQuantityTypeIdentifierHeartRate` into `.heartRate` BPM series.
- `loadEvidence().speed`: async load for `HKQuantityTypeIdentifierRunningSpeed` into `.runningSpeed` meters/second series.
- `loadEvidence().distance`: async load for `HKQuantityTypeIdentifierDistanceWalkingRunning` into cumulative/series distance meters.
- `loadEvidence().activeEnergy`: async load for `HKQuantityTypeIdentifierActiveEnergyBurned` into active calorie series.
- `loadEvidence().basalEnergy`: async load for `HKQuantityTypeIdentifierBasalEnergyBurned` into basal calorie series.
- `loadEvidence().power`: async load for `HKQuantityTypeIdentifierRunningPower` into watt series.
- `loadEvidence().cadence`: derived full-step cadence series from step-count samples.
- `loadEvidence().steps`: raw step-count sample series.
- `loadEvidence().stride`: running stride length series.
- `loadEvidence().vertical`: vertical oscillation series in centimeters.
- `loadEvidence().ground`: ground contact time series.
- `loadEvidence().route`: route-point load result from `HKWorkoutRoute`.
- `loadEvidence().events`: normalized raw `HKWorkoutEvent` records.
- `loadEvidence().activities`: normalized `HKWorkoutActivity` rows and their statistics.
- `loadEvidence().planAudit`: WorkoutKit plan audit from `HKWorkout.workoutPlan` when available.
- `quantitySeries().type`: HealthKit quantity type being queried.
- `quantitySeries().predicate`: workout association predicate.
- `quantitySeries().sort`: ascending sample start-date sort.
- `quantitySeries().associated`: samples directly associated with the workout.
- `quantitySeries().datePredicate`: fallback sample window around workout start/end.
- `quantitySeries().sourcePredicate`: fallback source filter using the workout source.
- `quantitySeries().fallbackPredicate`: combined date + source fallback.
- `quantitySeries().fallback`: fallback sample result when direct association returns nothing.
- `stepCadencePoints().minutes`: sample duration converted to minutes for steps-per-minute calculation.
- `stepCadencePoints().steps`: step count converted from the sample quantity.
- `routePoints().routeType`: `HKSeriesType.workoutRoute()`.
- `routePoints().routeQueryResult`: HealthKit route samples plus query error state.
- `routePoints().points`: accumulated route points from all route samples.
- `evidenceEvents().workout.workoutEvents`: raw HealthKit event array normalized into `WorkoutEvidenceEvent`.
- `evidenceActivities().workout.workoutActivities`: HealthKit activity rows normalized into `WorkoutEvidenceActivity`.
- `activityStatistics().allStatistics`: activity-level statistics converted into `WorkoutEvidenceActivityStatistic`.

### Metric Loading Rules

For each metric, the service first queries samples associated with the specific `HKWorkout` by `HKQuery.predicateForObjects(from:)`. If that returns nothing, it falls back to a source/date predicate around the workout window. Step cadence is derived from step-count samples as full steps per minute.

## WorkoutKit Planned Structure

Source files:

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/WorkoutEvidenceService.swift`
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/CustomWorkoutStepModel.swift`
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/WorkoutIntervalReconstruction.swift`

### WorkoutKit Objects Used

- `HKWorkout.workoutPlan`: optional planned workout structure exposed through HealthKit/WorkoutKit.
- WorkoutKit import is guarded by `#if canImport(WorkoutKit)`, so unsupported platforms report plan audit as unsupported/unavailable rather than breaking builds.

### App-Owned Planned-Step Types

- `CustomWorkoutStepRole`: app role for planned rows: warmup, work, recovery, cooldown, open, extra, or unknown.
- `CustomWorkoutStepSource`: where a step came from: WorkoutKit, HealthKit, or FIT reference only. Runtime promoted rows should be WorkoutKit plus HealthKit, not FIT.
- `CustomWorkoutPlanStep`: compact planned step with original index, role, goal type, goal value, and source.
- `CustomWorkoutRepeatBlock`: repeat block index, iteration count, and repeated steps.
- `ExpandedCustomWorkoutPlanStep`: one expanded planned row after repeat expansion. Tracks original index, expanded index, block index, repeat iteration, role, goal, and source.
- `CustomWorkoutStepModel`: warmup, repeat blocks, and cooldown model. Expands custom plans into ordered `PlannedWorkoutStep` rows.
- `PlannedWorkoutGoalType`: goal kind for planned rows: distance, time, open, energy, or unavailable.
- `PlannedWorkoutStep`: final app row used by interval logic. Fields are `index`, `label`, `stepType`, `repeatBlockIndex`, `repeatIndex`, `plannedGoalType`, `plannedGoalValue`, `plannedGoalDisplayText`, and `plannedTargetDisplayText`.

## Official Custom Workout Interval Rows

Source files:

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/CustomWorkoutResolvedIntervalRows.swift`
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/WorkoutIntervalReconstruction.swift`
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/CustomWorkoutComparisonModel.swift`

### Resolver Types

- `CustomWorkoutResolvedIntervalRows`: official normal-detail resolver for custom-workout rows. It maps expanded WorkoutKit planned steps to complete contiguous HealthKit activity rows.
- `WorkoutIntervalReconstructionResult`: result bundle for reconstructed/promoted rows, support status, fallback reasons, and comparison/debug metadata.
- `ReconstructedWorkoutInterval`: one interval row with label, planned goal, actual window, distance, pace, heart rate, cadence, power, pause timing, source fields, diagnostics, and confidence.
- `DerivedIntervalLabel`: row label type used across analytics and interval UI: warmup, work, recovery, cooldown, open, unknown, etc.
- `IntervalPlanSource`: whether the plan came from WorkoutKit, RunSignal, or is unavailable. Official rows use WorkoutKit.
- `IntervalWindowSource`: whether the row window came from HealthKit activity boundaries, old plan/sample derivation, or is unavailable. Official promoted rows use HealthKit activity boundaries.
- `IntervalReconstructionConfidence`: high, medium, low, or unavailable confidence.
- `ReconstructedIntervalDurationDisplayRule`: elapsed row-window display vs active-timer display.
- `DistanceGoalBoundaryStrategy`, `DistanceBoundaryDiagnostics`, `TailDiagnostics`: diagnostics for distance crossing, boundary adjustment, and `Open / Extra` tails.
- `PauseResolutionEventKind`, `PauseResolutionEvent`, `PauseWindowResolution`, `PauseWindowResolver`, `WorkoutPauseTimingSemantics`: pause/resume state machine for explicit pause/resume, motion pause/resume, and pause/resume request toggle events.

### Key Variables And Use Cases

- `resolve().audit`: `WorkoutPlanAudit`; must be available before normal-detail interval rows can promote.
- `resolve().plannedSteps`: ordered expanded WorkoutKit planned rows.
- `resolve().activities`: ordered HealthKit activity boundary rows.
- `resolve().pauses`: paired pause windows from raw HealthKit events.
- `resolve().resolvedPlannedSteps`: prefix of planned steps mapped to available HealthKit activity rows.
- `resolve().rows`: final official `ReconstructedWorkoutInterval` array.
- `resolvedRow().elapsed`: row-window duration from HealthKit activity start/end.
- `resolvedRow().pauseOverlap`: seconds paused inside the row window.
- `resolvedRow().activeDuration`: elapsed minus pause overlap.
- `resolvedRow().displayRule`: elapsed-window vs active-timer display decision.
- `resolvedRow().distanceMeters`: row distance from HealthKit activity statistics or tail calculation.
- `resolvedRow().pace`: seconds per kilometer for the selected display duration and row distance.
- `resolvedRow().heartRates`: heart-rate series values inside the row window.
- `resolvedRow().cadence`: average cadence inside the row window, falling back to step-count-derived cadence.
- `resolvedRow().power`: average running power inside the row window.
- `pairedPauseIntervals().pendingPause`: current unmatched pause timestamp.
- `pairedPauseIntervals().intervals`: completed pause/resume windows.
- `pairedPauseIntervals().sawPauseEvidence`: distinguishes no-pause workouts from malformed pause streams.
- `appendOpenTailIfNeeded().finalStep`: last planned row; only fixed Work/Cooldown can create inferred `Open / Extra`.
- `appendOpenTailIfNeeded().lastEnd`: end of the final mapped HealthKit activity row.
- `appendOpenTailIfNeeded().mappedDistance`: total distance already assigned to official rows.
- `appendOpenTailIfNeeded().tailDistance`: remaining whole-run distance after mapped rows.
- `appendOpenTailIfNeeded().tailDuration`: elapsed time after the final mapped activity row.

### Promotion Gate

`CustomWorkoutResolvedIntervalRows.resolve(workout:evidence:)` returns rows only when all of these are true:

- WorkoutKit plan audit is available and has ordered planned steps.
- Repeat context is complete and consistent.
- HealthKit activity rows are present, complete, contiguous, and no more numerous than planned rows.
- Activity rows map to all planned rows or a valid completed prefix for stopped-early workouts.
- Pause/resume events can be paired and each pause belongs to exactly one row.
- Any post-fixed-row tail is deterministic enough to become `Open / Extra`.

When the gate fails, normal detail keeps whole-run stats and shows interval evidence as unavailable/under review instead of substituting older reconstruction logic.

### Row Metrics

Each official row can include:

- Planned fields: row index, label, step type, goal type/value/text, repeat block, repeat iteration.
- Time fields: actual start/end, elapsed duration, pause overlap, active duration, display duration rule.
- Distance/pace: activity distance and pause-aware pace when available.
- Physiology/execution: average/max heart rate, cadence, power.
- Source/confidence: WorkoutKit plan source, HealthKit activity-boundary window source, source note, confidence, diagnostics.

## Raw Event And Debug-Only Paths

Source files:

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/DerivedAnalytics.swift`
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/DiagnosticsExport.swift`
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/HealthKitAudit.swift`

### Types

- `DerivedAnalyticsInputSummary`: counts and quality summary for series/event evidence.
- `DerivedBestEffortEstimate`: conservative derived best-effort estimate.
- `DerivedSplitEstimate`: kilometer split estimate from distance/time samples.
- `DerivedExecutionSegment`: raw/debug execution segment.
- `DerivedIntervalEventSource`: labels whether a raw event came from HealthKit labeled event, HealthKit segment pattern, resolved custom workout row, or other debug source.
- `DerivedAnalyticsEngine`: derives splits, best efforts, debug interval candidates, and official interval rows from evidence.
- `HealthKitAuditField` / `HealthKitAuditRow`: exportable audit rows for HealthKit field availability.
- `DiagnosticsExport`: Markdown/JSON export packet for Raw HealthKit Debug, WorkoutKit plan audit, HealthKit activities, resolved rows, fallback labels, pause/tail diagnostics, source metadata, and boundary warnings.

Important rule: `DerivedAnalyticsEngine.intervalCandidates` is raw HealthKit marker/debug evidence only. Product interval analytics publish rows from the resolved custom-workout path when the normal-detail evidence gate passes.

## HealthFit And FIT Reference Boundary

Source files/docs:

- `docs/project-state/project-status.md`
- `docs/validation/healthfit-interval-ui-reference.md`
- archived validation scorecards under `docs/archive/old-validation/`

HealthFit is not a runtime dependency. The app does not import HealthFit, does not parse HealthFit exports in production, and does not accept FIT files as app input.

HealthFit/FIT material has been used for:

- UI inspiration for the Interval Analysis screen.
- Offline validation and scorecards against historical Apple Fitness/HealthFit/FIT evidence.
- Debug comparison when studying row boundaries, labels, tails, and timing drift.

HealthFit/FIT material must stay out of the runtime source chain:

- Do not create production rows from FIT laps.
- Do not backfill missing HealthKit/WorkoutKit structure from FIT.
- Do not treat HealthFit elapsed values as product truth.
- Do not add file-based ingestion unless the product direction explicitly changes.

## Quick Prompt For Another AI

Use this when handing the project to another AI:

```text
RunSignal is a native iPhone SwiftUI app. Runtime workout data is read-only HealthKit only. Completed running workouts start as HKWorkout, are mapped into CanonicalWorkout, and optionally carry WorkoutEvidence with workout-scoped metric series, route points, raw HKWorkoutEvent records, HKWorkoutActivity rows, diagnostics, and a WorkoutKit plan audit from HKWorkout.workoutPlan. WorkoutKit is used only as planned custom-workout structure. Official custom interval rows come from CustomWorkoutResolvedIntervalRows by mapping expanded WorkoutKit PlannedWorkoutStep rows to complete contiguous HealthKit activity boundaries, with pause pairing and tail gates. HealthKit segment/lap markers are raw/debug-only. HealthFit/FIT files and Apple Fitness screenshots are offline validation/reference evidence only and are not app inputs or runtime truth.
```
