# RunSignal Architecture And HealthKit Handoff For Claude

Last updated: 2026-06-23

This file is meant to be handed to Claude or another coding model for a grounded second pass on RunSignal. It describes how the current app is built, what it reads from HealthKit, how workout data is normalized and analyzed, and where the UI surfaces that data.

## Executive Summary

RunSignal is a native iPhone SwiftUI app for analyzing completed running workouts. The app is intentionally HealthKit-first:

- Runtime workout data source: HealthKit only.
- Validation evidence: Apple Fitness screenshots, FIT/HealthFit exports, and parity packets are debug or documentation evidence only.
- Persistence: SwiftData stores canonical workouts, loaded evidence, enrichment state, and derived workout analyses.
- Main feature code: `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/`.
- App shell: `RunningWorkoutAnalysis/RunningWorkoutAnalysisApp.swift`.

The app reads completed running workouts from HealthKit, maps each `HKWorkout` into a `CanonicalWorkout`, optionally attaches detailed workout-scoped evidence, persists that data, computes analytics snapshots and per-workout derived analyses, and displays it through SwiftUI views.

Important boundary for Claude: do not propose FIT import, file-based workout ingestion, or Apple Fitness interval rows as runtime truth unless the user explicitly reverses the current HealthKit-only direction.

## App Shape

The iOS app target is a thin shell around a Swift Package feature module.

Important files:

- `RunningWorkoutAnalysis/RunningWorkoutAnalysisApp.swift`: app entry point and SwiftData model container.
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/ContentView.swift`: top-level tab shell.
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/RunningAnalysisStore.swift`: observable app store and orchestration layer.
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/HealthKitPermissionCatalog.swift`: read-only HealthKit permission list and permission-review export.
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/HealthKitService.swift`: initial authorization, full HealthKit load, targeted enrichment, and broad health context queries.
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/HealthKitWorkoutSyncService.swift`: incremental `HKAnchoredObjectQuery` sync for running workouts.
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/HealthKitWorkoutMapper.swift`: maps `HKWorkout` plus optional evidence into `CanonicalWorkout`.
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/WorkoutEvidenceService.swift`: loads detailed workout-scoped series, routes, events, activity rows, and WorkoutKit plan audit.
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/WorkoutEvidence.swift`: detailed evidence data structures.
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/Models.swift`: canonical model, SwiftData persisted models, snapshot model, readiness/data-quality types.
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/NormalizedRun.swift`: provenance-aware normalized run model.
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/AnalyticsEngine.swift`: app-level analytics snapshot, readiness, data quality, best efforts, export markdown.
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/DerivedAnalytics.swift`: per-workout analytics from loaded evidence.
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/RunClassifier.swift`: simple rule-based run type inference and duplicate detection.
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/Views.swift`: SwiftUI screens, cards, route/map panels, data/debug views.
- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/DiagnosticsExport.swift`: diagnostics, raw HealthKit debug export, parity packet export.

## Top-Level Runtime Flow

1. `RunningWorkoutAnalysisApp` launches `ContentView` and registers SwiftData model types.
2. `ContentView` creates `RunningAnalysisStore` and calls `store.bootstrap(modelContext:)`.
3. `RunningAnalysisStore.bootstrap` loads persisted workouts if they exist, otherwise uses sample data.
4. User taps "Load HealthKit Runs" from the Data or Settings UI.
5. `RunningAnalysisStore.refreshFromHealthKit()` calls `HealthKitService.loadRunningWorkouts()`.
6. `HealthKitService` requests read-only HealthKit access, queries running workouts, queries broad context, and sends workouts into `HealthKitWorkoutMapper.normalize`.
7. `HealthKitWorkoutMapper` maps HealthKit workouts into `CanonicalWorkout`; the newest 20 workouts get detailed evidence immediately.
8. `RunningAnalysisStore` removes sample workouts once real workouts exist, applies reviewed run types, persists data, recomputes analytics, and refreshes the evidence queue.
9. Incremental sync uses `HealthKitWorkoutSyncService.syncRunningWorkouts(from:)` with an `HKAnchoredObjectQuery`.

Key app shell snippet:

```swift
@main
struct RunningWorkoutAnalysisApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            PersistedWorkout.self,
            PersistedWorkoutEvidence.self,
            PersistedEvidenceEnrichmentState.self,
            PersistedDerivedWorkoutAnalysis.self
        ])
    }
}
```

Top-level view snippet:

```swift
public struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var store = RunningAnalysisStore()
    @State private var selectedTab = AppTab.runs

    public var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                RunsView(store: store)
            }
            .tabItem { Label(AppTab.runs.title, systemImage: AppTab.runs.symbol) }
            .tag(AppTab.runs)

            NavigationStack {
                SettingsView(store: store)
            }
            .tabItem { Label(AppTab.settings.title, systemImage: AppTab.settings.symbol) }
            .tag(AppTab.settings)
        }
        .task {
            await store.bootstrap(modelContext: modelContext)
        }
    }
}
```

## HealthKit Permissions

The permission catalog is read-only. The app does not request any HealthKit write types.

Authorization snippet:

```swift
public func requestAuthorization() async -> AuthorizationState {
    guard isAvailable else { return .unavailable }
    do {
        try await store.requestAuthorization(toShare: [], read: readTypes)
        return .authorized
    } catch {
        return .error
    }
}
```

Current read types:

| Display name | HealthKit identifier | How app uses it |
| --- | --- | --- |
| Workouts | `HKWorkoutTypeIdentifier` | Finds completed running `HKWorkout` records. |
| Workout routes | `HKSeriesTypeIdentifierWorkoutRoute` | Loads GPS route points with `HKWorkoutRouteQuery`. |
| Walking + Running Distance | `HKQuantityTypeIdentifierDistanceWalkingRunning` | Workout summary distance and detailed distance series. |
| Active Energy | `HKQuantityTypeIdentifierActiveEnergyBurned` | Active calories. |
| Basal Energy | `HKQuantityTypeIdentifierBasalEnergyBurned` | Combined with active energy for total calories. |
| Heart Rate | `HKQuantityTypeIdentifierHeartRate` | Average/max HR, HR series, HR drift, interval HR. |
| Running Speed | `HKQuantityTypeIdentifierRunningSpeed` | Speed/pace series, pacing shape, rolling best efforts. |
| Step Count | `HKQuantityTypeIdentifierStepCount` | Step count and cadence estimation. |
| Running Power | `HKQuantityTypeIdentifierRunningPower` | Average power and power series. |
| Running Stride Length | `HKQuantityTypeIdentifierRunningStrideLength` | Mechanics evidence. |
| Ground Contact Time | `HKQuantityTypeIdentifierRunningGroundContactTime` | Mechanics evidence. |
| Vertical Oscillation | `HKQuantityTypeIdentifierRunningVerticalOscillation` | Mechanics evidence. |

Intentionally skipped categories include nutrition, glucose/insulin, menstruation, swimming/cycling/rowing/wheelchair metrics, unrelated mobility metrics, body composition, sleep, HRV, profile characteristics, exercise minutes, VO2 Max, and Resting Heart Rate.

Important inconsistency to review: `HealthKitPermissionCatalog.intentionallySkipped` includes VO2 Max and Resting Heart Rate, but `HealthKitService.queryHealthContext()` tries to query `.vo2Max` and `.restingHeartRate`. Unless permissions are changed, those values may remain nil even though the Data UI mentions broad HealthKit context.

## HealthKit Service And Workout Loading

The primary load path lives in `HealthKitService.loadRunningWorkouts()`.

```swift
public func loadRunningWorkouts() async -> HealthKitLoadResult {
    guard isAvailable else {
        return HealthKitLoadResult(
            authorizationState: .unavailable,
            workouts: [],
            healthContext: HealthContext(),
            message: "HealthKit is not available on this device."
        )
    }

    let state = await requestAuthorization()
    guard state == .authorized else {
        return HealthKitLoadResult(
            authorizationState: state,
            workouts: [],
            healthContext: HealthContext(),
            message: "HealthKit permission is not fully available."
        )
    }

    do {
        let workouts = try await queryRunningWorkouts()
        let healthContext = await queryHealthContext()
        let canonical = await HealthKitWorkoutMapper.normalize(
            workouts,
            store: store,
            detailedEvidenceLimit: Self.defaultDetailedEvidenceLimit
        )
        return HealthKitLoadResult(
            authorizationState: canonical.isEmpty ? .partial : .authorized,
            workouts: DuplicateDetector.markDuplicates(canonical),
            healthContext: healthContext,
            message: canonical.isEmpty ? "HealthKit Loaded: no completed running workouts were returned." : nil
        )
    } catch {
        return HealthKitLoadResult(
            authorizationState: .error,
            workouts: [],
            healthContext: HealthContext(),
            message: "Could not read HealthKit running workouts."
        )
    }
}
```

`queryRunningWorkouts()` uses:

- `HKQuery.predicateForWorkouts(with: .running)`
- `HKSampleQuery`
- descending `HKSampleSortIdentifierStartDate`
- `HKObjectQueryNoLimit`

Targeted enrichment uses the same running predicate plus `HKQuery.predicateForObjects(with: uuids)`.

Incremental sync uses:

- `HKAnchoredObjectQuery`
- `HKQuery.predicateForWorkouts(with: .running)`
- saved `HKQueryAnchor`
- returned samples for inserted/updated workouts
- `deletedObjects` for removed workout IDs

## HealthKit Objects Used In The App

### `HKHealthStore`

The app owns a HealthKit store in `HealthKitService`, `HealthKitWorkoutSyncService`, and `WorkoutEvidenceService`. It is used to request authorization and execute HealthKit queries.

### `HKWorkout`

This is the root HealthKit object for each run. Current fields and APIs used:

- `uuid`
- `sourceRevision.source.name`
- `device`
- `startDate`
- `endDate`
- `duration`
- `totalDistance`
- `metadata`
- `statistics(for:)`
- `workoutEvents`
- `workoutActivities`
- `workoutPlan`

The mapper also infers environment from `HKMetadataKeyIndoorWorkout` and route availability.

### `HKQuantityTypeIdentifier`

Used both from workout summary statistics and detailed workout-scoped samples:

- `.distanceWalkingRunning`
- `.activeEnergyBurned`
- `.basalEnergyBurned`
- `.heartRate`
- `.runningSpeed`
- `.stepCount`
- `.runningPower`
- `.runningStrideLength`
- `.runningVerticalOscillation`
- `.runningGroundContactTime`
- `.vo2Max` in broad context query only
- `.restingHeartRate` in broad context query only

Units used:

- Heart rate: `count/min`
- Speed: `m/s`
- Distance: `m`
- Active/basal energy: `kcal`
- Power: `W`
- Step count: `count`
- Stride length: `m`
- Vertical oscillation: `cm`
- Ground contact time: `ms`
- VO2 max: `mL/(kg*min)`

### `HKWorkoutRoute`

Routes are queried with `HKSeriesType.workoutRoute()` and expanded with `HKWorkoutRouteQuery`. Each returned Core Location point is mapped into `WorkoutRoutePoint`.

### `HKWorkoutEvent`

Workout events are copied into `WorkoutEvidenceEvent`. Display labels normalize raw HealthKit event strings into labels such as Pause, Resume, Lap, Segment, Marker, Motion paused, Motion resumed, and Pause/resume request.

Important: raw segment markers are not treated as Apple Fitness interval rows unless a specific, proven custom-workout gate allows it.

### `HKWorkoutActivity`

Activity rows are loaded from `workout.workoutActivities` into `WorkoutEvidenceActivity`. Each activity captures:

- activity type
- location type
- start/end dates
- duration
- metadata keys
- nested events
- activity-level statistics

These rows are important for custom-workout boundary investigation.

### WorkoutKit `workoutPlan`

The app audits `HKWorkout.workoutPlan` when available. The audit is stored as `WorkoutPlanAudit` with:

- status
- plan ID
- plan type
- display name
- summary lines
- planned steps
- error message

This is used for debug/proven custom-workout reconstruction, not broad interval analytics.

## Mapping `HKWorkout` Into `CanonicalWorkout`

`HealthKitWorkoutMapper.normalize` is the bridge from Apple objects into app-owned models.

Representative mapping shape:

```swift
let evidenceService = WorkoutEvidenceService(store: store)
let detailWorkoutIDs = Set(workouts.prefix(detailedEvidenceLimit).map(\.uuid))

for workout in workouts {
    let shouldLoadDetail = detailWorkoutIDs.contains(workout.uuid)
    let evidence = shouldLoadDetail
        ? await evidenceService.loadEvidence(for: workout)
        : WorkoutEvidence(workoutID: workout.uuid.uuidString)

    let routeAvailable = !evidence.route.isEmpty
        ? true
        : await hasRoute(for: workout, store: store)

    var canonical = CanonicalWorkout(
        id: workout.uuid.uuidString,
        sourceID: workout.uuid.uuidString,
        sourceName: workout.sourceRevision.source.name,
        deviceName: deviceName(workout),
        startDate: workout.startDate,
        endDate: workout.endDate,
        environment: inferEnvironment(workout: workout, routeAvailable: routeAvailable),
        distanceMeters: workout.totalDistance?.doubleValue(for: .meter()) ?? evidence.sum(.distance),
        durationSeconds: workout.duration,
        elapsedSeconds: workout.endDate.timeIntervalSince(workout.startDate),
        activeEnergyKilocalories: quantity(workout, .activeEnergyBurned, unit: .kilocalorie()) ?? evidence.sum(.activeEnergy),
        totalEnergyKilocalories: totalEnergyKilocalories(workout: workout, evidence: evidence),
        averageHeartRate: evidence.average(.heartRate),
        maxHeartRate: evidence.maximum(.heartRate),
        averagePower: quantity(workout, .runningPower, unit: .watt(), option: .discreteAverage) ?? evidence.average(.runningPower),
        evidence: shouldLoadDetail ? evidence : nil
    )
}
```

`CanonicalWorkout` is the central app-level workout object. Important fields:

- Identity/source: `id`, `sourceID`, `sourceName`, `deviceName`
- Time: `startDate`, `endDate`, `durationSeconds`, `elapsedSeconds`
- Context: `environment`
- Distance/energy: `distanceMeters`, `activeEnergyKilocalories`, `totalEnergyKilocalories`, `elevationGainMeters`
- HR: `averageHeartRate`, `maxHeartRate`
- Mechanics: `averageCadence`, `averagePower`, `strideLengthMeters`, `verticalOscillationCentimeters`, `groundContactMilliseconds`
- Evidence availability: `routeAvailable`, `seriesAvailable`, `routePointCount`, `seriesSampleCount`
- Per-metric sample counts: HR, speed, distance, active energy, power, cadence, steps, stride, vertical oscillation, ground contact time
- Interval summary: `intervalCount`, `intervalLabelsSummary`
- Review/classification: `inferredRunType`, `manualRunType`, `importedRunType`, `importedReviewID`, `notes`
- Duplicate handling: `isDuplicate`, `duplicateOfID`
- Attached detailed evidence: `evidence`

## Detailed Workout Evidence

`WorkoutEvidenceService.loadEvidence(for:)` uses concurrent queries for each detailed series and non-series evidence.

Key evidence-loading snippet:

```swift
public func loadEvidence(for workout: HKWorkout) async -> WorkoutEvidence {
    async let heartRate = quantitySeries(.heartRate, unit: HKUnit.count().unitDivided(by: .minute()), metric: .heartRate, unitLabel: "bpm", workout: workout)
    async let speed = quantitySeries(.runningSpeed, unit: HKUnit.meter().unitDivided(by: .second()), metric: .runningSpeed, unitLabel: "m/s", workout: workout)
    async let distance = quantitySeries(.distanceWalkingRunning, unit: .meter(), metric: .distance, unitLabel: "m", workout: workout)
    async let activeEnergy = quantitySeries(.activeEnergyBurned, unit: .kilocalorie(), metric: .activeEnergy, unitLabel: "kcal", workout: workout)
    async let basalEnergy = quantitySeries(.basalEnergyBurned, unit: .kilocalorie(), metric: .basalEnergy, unitLabel: "kcal", workout: workout)
    async let power = quantitySeries(.runningPower, unit: .watt(), metric: .runningPower, unitLabel: "W", workout: workout)
    async let cadence = stepCadenceSeries(for: workout)
    async let steps = quantitySeries(.stepCount, unit: .count(), metric: .stepCount, unitLabel: "steps", workout: workout)
    async let stride = quantitySeries(.runningStrideLength, unit: .meter(), metric: .strideLength, unitLabel: "m", workout: workout)
    async let vertical = quantitySeries(.runningVerticalOscillation, unit: HKUnit.meterUnit(with: .centi), metric: .verticalOscillation, unitLabel: "cm", workout: workout)
    async let ground = quantitySeries(.runningGroundContactTime, unit: HKUnit.secondUnit(with: .milli), metric: .groundContactTime, unitLabel: "ms", workout: workout)
    async let route = routePoints(for: workout)
    async let planAudit = workoutPlanAudit(for: workout)
}
```

Each quantity query first tries `HKQuery.predicateForObjects(from: workout)`. If no associated samples are returned, it falls back to:

- a date window from `workout.startDate - 2s` to `workout.endDate + 2s`
- same HealthKit source as the workout

This fallback is useful because HealthKit does not always attach samples directly to the workout object.

`WorkoutEvidenceMetric` currently supports:

```swift
public enum WorkoutEvidenceMetric: String, Codable, CaseIterable, Identifiable, Sendable {
    case heartRate
    case runningSpeed
    case distance
    case activeEnergy
    case basalEnergy
    case runningPower
    case cadence
    case stepCount
    case strideLength
    case verticalOscillation
    case groundContactTime
}
```

Detailed evidence objects:

- `WorkoutEvidencePoint`: date plus numeric value.
- `WorkoutMetricSeries`: metric, unit label, sorted points, sample count, average, maximum, sum helpers.
- `WorkoutRoutePoint`: date, latitude, longitude, altitude, speed.
- `WorkoutEvidenceEvent`: start/end dates, raw type string, label, display label.
- `WorkoutEvidenceActivityStatistic`: quantity type, unit, dates, source count, sum/average/min/max/duration.
- `WorkoutEvidenceActivity`: activity row identity, type, location, dates, duration, metadata keys, nested events, statistics.
- `WorkoutPlanAudit`: WorkoutKit plan audit status and planned steps.
- `WorkoutEvidenceDiagnostics`: query diagnostics and warnings.
- `WorkoutEvidence`: workout ID, load timestamp, series dictionary, route points, events, activity rows, plan audit, diagnostics.

## Persistence

SwiftData stores four model types:

- `PersistedWorkout`
- `PersistedWorkoutEvidence`
- `PersistedEvidenceEnrichmentState`
- `PersistedDerivedWorkoutAnalysis`

`PersistenceService.upsert`:

- fetches existing workouts
- updates or inserts `PersistedWorkout`
- preserves manual fields such as notes/manual run type
- stores evidence JSON in `PersistedWorkoutEvidence`
- stores or refreshes derived analyses when evidence exists
- deletes stale persisted records that are no longer in the current workout set

Manual edits flow through `RunningAnalysisStore.update(workoutID:manualRunType:notes:)` and persist via `PersistenceService.updateManualFields`.

## Evidence Enrichment Queue

The app does not load full detailed evidence for every historical workout during the initial HealthKit load. It loads details for the newest 20 by default, then uses the queue to prioritize additional enrichment.

Queue priorities:

1. `latestRun`
2. `recentQuality`
3. `recentLongRun`
4. `needsReview`
5. `olderBenchmark`
6. `historical`

The queue skips:

- duplicates
- sample workouts
- workouts already cached with evidence

This is a performance and battery-safety design. Claude should be careful before suggesting "load all evidence for every workout on every refresh."

## Normalized Run Layer

`NormalizedRun` is a provenance-aware projection of `CanonicalWorkout`.

It includes:

- identity and source
- start/end/duration/elapsed
- activity type
- indoor/outdoor flag
- distance and energy
- average pace
- HR, max HR
- power, speed, cadence
- stride, vertical oscillation, ground contact
- elevation gain
- heart-rate series
- pace/speed series
- route points
- event summary
- data-quality report
- metric provenance dictionary

`MetricProvenance` labels each metric as one of:

- `healthKitWorkoutSummary`
- `workoutScopedHealthKitSample`
- `broadHealthKitContext`
- `derived`
- `inferred`
- `unavailable`

This is a strong foundation for Claude to expand data lineage or UI trust labels.

## App-Level Analytics

`AnalyticsEngine.snapshot(for:)` produces `AnalysisSnapshot`.

The snapshot computes:

- weekly volume in km
- previous weekly volume in km
- training-load confidence
- easy/quality/long-run balance
- fitness trend
- best efforts
- readiness summary
- data-quality report

Data-quality report includes:

- total workout count
- included workout count
- duplicate count
- heart-rate coverage
- cadence coverage
- power coverage
- mechanics coverage
- route coverage
- series coverage
- confidence
- caveats

Readiness is currently oriented around a sub-20 5K goal:

- goal date: October 17, 2026
- target pace: 3:59/km
- best 5K estimate
- pace gap
- evidence insights
- confidence

Best efforts estimate 1K, 1 mile, 3K, 5K, and 10K from eligible workouts when the workout distance is close enough to the target.

`AnalyticsEngine` also creates:

- readiness evidence cards
- latest-run review insights
- trend text
- export markdown for a coaching brief

## Per-Workout Derived Analytics

`DerivedAnalyticsEngine` computes richer per-workout analysis when evidence is available.

`DerivedWorkoutAnalysis` includes:

- version
- workout ID
- input summary
- estimated pace
- pace confidence
- pacing shape
- pacing shape confidence
- heart-rate drift percent
- HR drift confidence
- cadence average
- power average
- stride length average
- vertical oscillation average
- ground contact average
- mechanics confidence
- best-effort estimates
- split estimates
- execution segments
- interval candidates
- interval count
- interval confidence
- readiness/data-quality confidence
- caveats

Derived analytics use:

- running-speed series for pacing shape
- distance series for rolling efforts and splits
- heart-rate series for drift
- power/cadence/mechanics series for mechanics
- events/activity rows/WorkoutKit plan audit for interval candidates

Important limitation: derived interval candidates are confidence-gated. Raw HealthKit event markers are not automatically promoted to normal Apple Fitness interval UI.

## Run Classification And Duplicate Detection

`RunClassifier` is intentionally simple and rule-based:

- long run: distance >= 12 km
- threshold: within 25 seconds/km of sub-20 5K pace and distance >= 3 km
- recovery: distance < 2.5 km and duration < 20 minutes
- easy: HR exists and distance >= 4 km
- otherwise unknown

Manual and imported review fields can override or supplement inferred run type.

Duplicate detection groups workouts that are close in:

- start date, within about 90 seconds
- duration, within about 60 seconds or 5 percent
- distance, when present

It prefers Apple Watch/Fitness-like sources and richer evidence. Non-preferred duplicates stay in storage but are hidden from the main v1 completed-run list.

## UI Surfaces

### Main Tabs

`ContentView` exposes two top-level tabs:

- Runs
- Settings

`RunsView` shows:

- sample-data notice when no real HealthKit data is loaded
- HealthKit loaded notice
- most recent completed run
- completed run list

`SettingsView` shows:

- authorization state
- sample vs HealthKit mode
- run counts and duplicate counts
- route/sample totals
- debug and export links

### V1 App Views In `Views.swift`

The codebase also contains richer v1 views/components, including:

- `TodayView`
- `LatestRunView`
- `HistoryView`
- `DataView`
- `WorkoutDetailView`
- `HealthKitPermissionReviewView`
- `GoldenValidationView`
- `RawHealthKitDebugView`
- `AppleFitnessValidationView`

`DataView` is where HealthKit loading and export actions are most obvious:

- Load HealthKit Runs button
- authorization status
- data-quality metrics
- route/sample totals
- permission review
- broad health context display
- data-quality caveats
- share coaching brief
- share diagnostics
- share HealthKit audit
- share physical verification report
- share Apple Fitness validation checklist

### Workout Detail UI

Workout detail panels include:

- workout summary metrics
- active and total calories
- pace
- average/max heart rate
- average power
- cadence
- elevation
- route availability
- route map when route points exist
- chart availability tiles for HR, pace/speed, power, cadence, vertical oscillation, ground contact, stride length, elevation
- 1 km splits when derived split estimates exist
- event summary
- Apple Fitness interval panel when a narrow proven interval gate is supported

The interval panel intentionally hides raw marker durations when they are not the same thing as Apple Fitness interval rows. The UI tells users to inspect Raw HealthKit Debug for raw event data.

## Custom Workout And Apple Fitness Parity Boundary

There is significant custom-workout research in the repo. The current product boundary is conservative:

- WorkoutKit `HKWorkout.workoutPlan` is the planned-structure source when available.
- HealthKit samples/activity rows are the completed-stats source.
- FIT and Apple Fitness screenshots are validation evidence only.
- Raw HealthKit segment markers remain raw/debug-only unless a narrow, physically proven gate promotes them.

Already implemented/promoted narrow cases include specific simple fixed-distance Work/Open and selected repeat-block/open-cooldown shapes. Broad structured interval analytics remain blocked.

Claude should not suggest replacing the normal workout-detail UI with debug Parity Lab candidate rows. Any interval analytics should preserve explicit source, confidence, fallback reason, and blocker labels.

## Current Debug And Export Surfaces

`RunningAnalysisStore` exposes:

- `exportMarkdown`
- `diagnosticsMarkdown`
- `healthKitAuditMarkdown`
- `physicalVerificationMarkdown`
- `goldenValidationChecklistMarkdown`
- `healthKitPermissionReviewMarkdown`
- `parityPacketJSON(for:)`
- monthly diagnostics JSON/Markdown

`DiagnosticsExport` creates:

- HealthKit load diagnostics
- workout evidence markdown
- raw HealthKit debug markdown
- parity packet JSON
- custom-workout comparison rows
- interval timing and pause-overlap details

These exports are useful for Claude to inspect how data is represented without changing the runtime data source.

## Important Existing Constraints

- Keep HealthKit read-only.
- Keep the native app iPhone-focused.
- Keep sample-data fallback for Simulator.
- Do not mutate HealthKit.
- Do not add FIT import or file-based runtime ingestion.
- Do not treat Apple Fitness screenshots as runtime data.
- Do not broaden custom-workout interval gates without row-level evidence, tests, and physical-iPhone proof.
- Use `swift test --package-path RunningWorkoutAnalysisPackage` for package-level validation before full Xcode work.
- Before any XcodeBuildMCP build/run/test, call `session_show_defaults`.

## High-Value Questions For Claude

Ask Claude to focus on these, because they are likely to improve the app without violating current boundaries:

1. Should the broad health-context query be changed to match the permission catalog, or should the app explicitly request VO2 Max and Resting Heart Rate?
2. Should `NormalizedRun` become the main UI-facing model so every displayed metric has provenance and confidence?
3. Should HealthKit query diagnostics be elevated in the UI when fallback date/source matching was used?
4. Should the evidence queue support background/lazy enrichment policies that are safer than loading every workout immediately?
5. Should derived analytics versioning/invalidation be stricter when evidence changes or analytics code changes?
6. Should run classification be split into "detected type," "user-reviewed type," and "training-purpose confidence" rather than one effective run type?
7. Should readiness move beyond sub-20 5K toward configurable race goals, recent load, and recovery context?
8. Should chart components render actual time series instead of mostly availability tiles?
9. Should route analytics include elevation profile, grade-adjusted pace, stop detection, or route repeat comparison?
10. Should the app expose a HealthKit coverage matrix per workout so users understand why a claim is limited?

## Safe Implementation Ideas For Claude To Consider

These fit the existing architecture:

- Add metric provenance badges to workout detail metrics.
- Add a "why confidence is limited" sheet from `DataQualityReport` and `DerivedWorkoutAnalysis.caveats`.
- Add optional manual race goal settings, still using HealthKit-only workout data.
- Add trend charts from persisted `CanonicalWorkout` values.
- Add real charts for HR, speed/pace, power, cadence, and mechanics when `WorkoutEvidence` exists.
- Add a route/elevation detail panel from `WorkoutRoutePoint`.
- Add a per-workout "HealthKit evidence coverage" section from sample counts and diagnostics.
- Improve duplicate review UI without deleting underlying records.
- Tighten broad-context permission behavior.
- Add tests around HealthKit permission catalog/read-type consistency.

## Risky Or Out-Of-Scope Ideas

These should be rejected or require explicit user approval:

- FIT import as product/runtime data source.
- HealthFit backup ingestion as product/runtime data source.
- Writing workouts or samples back to HealthKit.
- Treating raw `HKWorkoutEvent` markers as Apple Fitness interval rows.
- Broad custom-workout interval promotion without physical proof.
- Provider/API calls or production data mutation.
- Loading all historical evidence repeatedly without queueing/caching.

## Suggested Claude Prompt

Use this prompt with the file:

```text
You are reviewing a native iPhone SwiftUI app called RunSignal. Read this handoff and inspect the referenced Swift files. The app must remain HealthKit-only at runtime, read-only, and conservative about Apple Fitness custom-workout interval claims. Please identify concrete coding improvements, missing tests, unsafe assumptions, and better model/UI boundaries. Prioritize improvements that preserve HealthKit as the source of truth, improve metric provenance/confidence, and make running analytics more useful without widening unsupported interval behavior.
```
