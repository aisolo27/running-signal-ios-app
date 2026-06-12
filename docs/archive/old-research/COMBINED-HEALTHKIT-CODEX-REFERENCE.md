# Combined HealthKit Codex Reference

This single file combines all markdown files in the reference pack for easy review or upload.



---



<!-- Source file: README.md -->


# HealthKit Codex Reference Pack

Generated: 2026-06-06

Purpose: give Codex a structured, implementation-focused reference for iOS apps that read Apple HealthKit and Apple Watch workout data.

This pack is not a replacement for Apple's official documentation. It is a Codex-friendly companion that summarizes patterns, organizes common HealthKit concepts, and links back to Apple documentation for verification.

Primary Apple source:
- https://developer.apple.com/documentation/healthkit/about-the-healthkit-framework

Recommended usage:
1. Put this folder in Google Drive or inside the repository docs folder.
2. Tell Codex to read `13-codex-rules-for-healthkit.md` first.
3. Tell Codex to use Apple documentation links in `references/apple-healthkit-links.md` as source-of-truth when making HealthKit decisions.
4. For running apps, have Codex read files 05 through 12 before changing workout import or analysis logic.

Directory map:
- `00-healthkit-overview.md` explains what HealthKit is responsible for.
- `01-privacy-permissions-entitlements.md` covers authorization, entitlements, and privacy.
- `02-health-store-setup.md` covers `HKHealthStore`.
- `03-reading-data-queries.md` covers sample queries, anchored queries, statistics queries, and observers.
- `04-healthkit-data-model-types.md` covers object, sample, quantity, category, workout, source, and metadata concepts.
- `05-workouts-hkworkout.md` covers workout-level records.
- `06-workout-events-intervals-laps.md` covers intervals, pauses, resumes, laps, and event interpretation.
- `07-workout-routes-location-elevation.md` covers route points, elevation, and map data.
- `08-running-metrics-hr-power-cadence-form.md` covers running metrics relevant to Apple Watch.
- `09-statistics-splits-pace.md` covers pace, splits, summaries, and derived metrics.
- `10-background-delivery-incremental-sync.md` covers ongoing sync and background delivery.
- `11-data-quality-source-reconciliation.md` covers source quality, duplicate handling, and conflict resolution.
- `12-running-app-implementation-patterns.md` gives app-specific architecture.
- `13-codex-rules-for-healthkit.md` gives strict rules for Codex.



---



<!-- Source file: 13-codex-rules-for-healthkit.md -->


# 13. Codex Rules for HealthKit Work

This file should be read first by Codex before changing any iOS HealthKit logic.

## Non-negotiable rules

1. Apple documentation is the source of truth.
Before adding or changing HealthKit logic, verify the relevant Apple documentation link in `references/apple-healthkit-links.md`.

2. Never copy Apple Fitness assumptions blindly.
Apple Fitness may display fields that are calculated or presented differently from raw HealthKit data.

3. Separate raw data from derived data.
Raw HealthKit objects and app-derived metrics must be stored separately.

4. Preserve HealthKit identity.
Every imported workout and sample should preserve UUID, source, source revision, date range, and metadata when available.

5. Do not use zero as missing data.
Use explicit missing states.

6. Use optional metrics.
Running power, cadence, stride length, vertical oscillation, ground contact time, route, and elevation may be unavailable.

7. Query incrementally.
Use anchored queries and observer queries for ongoing sync. Do not re-import full history on every app launch.

8. Make calculations auditable.
Derived pace, splits, intervals, elevation, and drift should have documented inputs and calculation methods.

9. Keep HealthKit out of SwiftUI views.
Use a service/client layer.

10. Protect privacy.
Request only needed data types and provide clear user-facing explanations.

## App-specific HealthKit interpretation
For the current running app:
- Distance: prefer `HKWorkout` total distance when available; otherwise use documented fallback.
- Duration: use workout duration, and keep elapsed vs moving time separate.
- Active calories: use HealthKit active energy where available.
- Total calories: do not invent unless the app has a documented basal/resting calculation.
- Heart rate: derive average, max, and chart values from samples.
- Pace: calculate from distance/time or speed samples. Do not rely on rounded UI values.
- Splits: derive from distance/time samples or route points with interpolation.
- Intervals: use workout events or workout-plan data if available; otherwise infer and label as inferred.
- Elevation: calculate from route altitude if available, with smoothing/filtering.
- Running power/form metrics: optional sample-based values, not guaranteed.

## Required tests
When Codex changes HealthKit import or metrics logic, it should add or update tests for:
- Workout deduplication
- Missing heart rate
- Missing route
- Pace formatting
- Split boundary interpolation
- Pause/resume handling
- Interval labeling confidence
- Unit conversion
- Duplicate source handling



---



<!-- Source file: 00-healthkit-overview.md -->


# 00. HealthKit Overview

## Apple source
- https://developer.apple.com/documentation/healthkit
- https://developer.apple.com/documentation/healthkit/about-the-healthkit-framework

## Summary
HealthKit is Apple's framework for reading and writing health and fitness data after the user grants permission. For a running app, HealthKit should be treated as the trusted system source for Apple Watch workouts, workout samples, health samples, workout routes, and metadata.

HealthKit does not always expose the exact same display labels shown in Apple Fitness. Apple Fitness may combine raw HealthKit records, Apple Watch samples, workout events, route points, and Apple-specific presentation logic. Your app should read the underlying data and calculate clear derived values when Apple does not provide a ready-made field.

## How this applies to the running app
Use HealthKit as the primary source for:
- Workout records such as distance, duration, activity type, start/end time, and energy where available.
- Time-series samples such as heart rate, running power, speed, step count, and other running dynamics when recorded.
- Workout routes when location permissions and route data exist.
- Workout events such as pause/resume, segment, lap, and marker events when available.

Do not assume HealthKit contains:
- Apple Fitness screen labels exactly as displayed.
- Human-readable interval names such as Warmup, Work, Cooldown, Open, or Recovery.
- Perfect splits already calculated.
- Total calories in the same exact form Apple Fitness displays.

## Codex implementation guidance
When importing workouts, Codex should build the app around raw HealthKit data plus explicit derived calculations:
- Store the original HealthKit identifiers and metadata.
- Store raw samples separately from derived metrics.
- Recalculate pace, splits, drift, and interval summaries from timestamped data.
- Keep a clear distinction between fields read directly from HealthKit and fields calculated by the app.



---



<!-- Source file: 01-privacy-permissions-entitlements.md -->


# 01. Privacy, Permissions, and Entitlements

## Apple source
- https://developer.apple.com/documentation/healthkit/setting-up-healthkit
- https://developer.apple.com/documentation/healthkit/hkhealthstore
- https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_healthkit

## Core principle
Health data is sensitive. The app must request only the HealthKit read and write permissions it needs, explain why each data type is needed, and handle denial gracefully.

## App requirements
For an iOS app using HealthKit:
- Enable the HealthKit capability in the app target.
- Include the HealthKit entitlement.
- Add user-facing privacy strings in `Info.plist`.
- Request authorization before reading or writing HealthKit data.
- Do not block the entire app if the user denies a non-critical metric.

## Permissions for a running app
Likely read permissions:
- Workouts
- Workout routes
- Distance walking/running
- Active energy burned
- Heart rate
- Running power if available
- Running speed if available
- Step count or cadence-related data if available
- Running stride length if available
- Running vertical oscillation if available
- Running ground contact time if available

Write permissions are optional and should only be requested if the app creates workouts, samples, routes, or analysis records in HealthKit.

## Permission UX
The app should explain in plain language:
- Why workout data is needed.
- Why heart rate and running metrics improve analysis.
- Why location route data helps calculate route, elevation, and pace.
- That the user controls HealthKit access in the Health app and Settings.

## Codex rules
- Do not request broad write access unless the feature actually writes HealthKit records.
- Do not assume authorization means every requested type was granted.
- Check authorization per type and degrade gracefully.
- Do not show fake zeros when data is missing because of permission denial.
- Use explicit missing-data states such as `notAuthorized`, `notRecorded`, `notAvailableOnDevice`, or `notImportedYet`.



---



<!-- Source file: 02-health-store-setup.md -->


# 02. Health Store Setup

## Apple source
- https://developer.apple.com/documentation/healthkit/hkhealthstore
- https://developer.apple.com/documentation/healthkit/hkobjecttype
- https://developer.apple.com/documentation/healthkit/hkquantitytype
- https://developer.apple.com/documentation/healthkit/hksampletype

## Role of HKHealthStore
`HKHealthStore` is the central object used to request authorization and run HealthKit queries. The app should use a single HealthKit service layer rather than scattering HealthKit calls across views.

## Recommended app structure
Create a dedicated service such as:

```swift
final class HealthKitClient {
    private let healthStore = HKHealthStore()

    func requestAuthorization() async throws { }
    func fetchWorkouts(...) async throws -> [HKWorkout] { }
    func fetchSamples(...) async throws -> [HKQuantitySample] { }
    func fetchRoute(...) async throws -> [CLLocation] { }
}
```

Then expose app-specific models:

```swift
struct ImportedRunWorkout {
    let healthKitUUID: UUID
    let startDate: Date
    let endDate: Date
    let duration: TimeInterval
    let distanceMeters: Double?
    let activeEnergyKilocalories: Double?
    let sourceName: String
    let rawMetadata: [String: Any]
    let derived: DerivedRunMetrics
}
```

## Availability checks
Before using HealthKit:
- Check whether HealthKit is available on the device.
- Check whether the app has the needed entitlement.
- Request authorization for the exact object types.
- Handle empty results as normal, not as a crash path.

## Codex rules
- Keep HealthKit code behind a client/service layer.
- Do not access HealthKit directly from SwiftUI views.
- Do not mix HealthKit raw models with UI display models.
- Preserve HealthKit UUIDs so the app can dedupe and update existing imported workouts.



---



<!-- Source file: 03-reading-data-queries.md -->


# 03. Reading Data and Queries

## Apple source
- https://developer.apple.com/documentation/healthkit/hksamplequery
- https://developer.apple.com/documentation/healthkit/hkanchoredobjectquery
- https://developer.apple.com/documentation/healthkit/hkstatisticsquery
- https://developer.apple.com/documentation/healthkit/hkstatisticscollectionquery
- https://developer.apple.com/documentation/healthkit/hkobserverquery

## Query types
Use the query type based on the job:

### HKSampleQuery
Use for fetching matching samples in a date range. Good for:
- Workouts
- Heart rate samples
- Running power samples
- Speed samples
- Quantity samples tied to a workout timeframe

### HKAnchoredObjectQuery
Use for incremental sync. Good for:
- Importing only new or changed samples after the previous sync.
- Persisting an anchor between app launches.
- Avoiding full re-imports every time.

### HKStatisticsQuery
Use for aggregate totals over a date range. Good for:
- Total distance in a period.
- Sum of active energy.
- Average heart rate over a range when appropriate.

### HKStatisticsCollectionQuery
Use for bucketed aggregates. Good for:
- Daily totals.
- Per-minute or per-kilometer calculations when time buckets make sense.
- Charts where the app needs consistent intervals.

### HKObserverQuery
Use to be notified when HealthKit data changes. Pair this with anchored queries to fetch the actual changed data.

## Workout-specific sample filtering
When possible, associate samples to a specific workout. Depending on the data type and availability, the app may need to query by:
- Workout start/end date
- Source
- Metadata
- Device/source revision
- Associated workout relationship, if exposed for the sample type

## Codex rules
- Use `HKAnchoredObjectQuery` for sync instead of repeatedly importing all historical data.
- Use observer queries for change notifications, not as the actual data source.
- Never assume a sample exists just because a workout exists.
- Use date predicates carefully. Include a small tolerance around start/end times when necessary, but do not merge unrelated workouts.



---



<!-- Source file: 04-healthkit-data-model-types.md -->


# 04. HealthKit Data Model Types

## Apple source
- https://developer.apple.com/documentation/healthkit/hkobject
- https://developer.apple.com/documentation/healthkit/hksample
- https://developer.apple.com/documentation/healthkit/hkquantitysample
- https://developer.apple.com/documentation/healthkit/hkcategorysample
- https://developer.apple.com/documentation/healthkit/hkworkout
- https://developer.apple.com/documentation/healthkit/hksource
- https://developer.apple.com/documentation/healthkit/hksourcerevision
- https://developer.apple.com/documentation/healthkit/hkdevice

## Important model concepts

### HKObject
Base object for HealthKit records. Usually includes UUID, source revision, metadata, and device where available.

### HKSample
A time-bounded health data record. Quantity samples, category samples, workouts, and other records inherit sample-like behavior.

### HKQuantitySample
Numeric data with units. Examples:
- Heart rate
- Distance
- Energy
- Running power
- Running speed
- Step count
- Running dynamics where available

### HKCategorySample
Discrete or categorical data. Not the main source for running workouts, but may appear in broader health contexts.

### HKWorkout
A workout session with activity type, duration, start/end, totals, metadata, and events.

### Source and source revision
Source information matters because the same time window can include data from iPhone, Apple Watch, third-party devices, or apps.

## App storage guidance
Store:
- HealthKit UUID
- Sample type identifier
- Source name
- Source bundle identifier when available
- Source revision
- Device metadata when available
- Start and end date
- Unit-normalized value
- Original metadata keys

## Codex rules
- Always preserve source information.
- Normalize units at import time, but keep the original sample identity.
- Do not blend data from different sources without explicit reconciliation logic.
- Do not overwrite raw HealthKit values with derived values.



---



<!-- Source file: 05-workouts-hkworkout.md -->


# 05. Workouts and HKWorkout

## Apple source
- https://developer.apple.com/documentation/healthkit/hkworkout
- https://developer.apple.com/documentation/healthkit/hkworkoutactivitytype
- https://developer.apple.com/documentation/healthkit/hkworkouttype

## What HKWorkout gives the app
`HKWorkout` represents a workout session. For running, it usually contains:
- Workout activity type
- Start date
- End date
- Duration
- Total distance, if recorded and available
- Total active energy, if recorded and available
- Metadata
- Workout events

## Direct fields vs derived fields
Treat the following as likely direct workout-level fields:
- Distance
- Duration
- Activity type
- Start/end time
- Active energy

Treat the following as often derived or sample-based:
- Average pace
- Split pace
- Heart rate averages
- Heart rate drift
- Elevation gain
- Cadence summaries
- Ground contact time summaries
- Vertical oscillation summaries
- Stride length summaries
- Interval labels

## Unit normalization
Recommended internal units:
- Distance: meters
- Duration: seconds
- Pace: seconds per kilometer
- Speed: meters per second
- Energy: kilocalories
- Heart rate: beats per minute
- Power: watts
- Cadence: steps per minute or strides per minute, explicitly labeled
- Ground contact time: milliseconds
- Vertical oscillation: centimeters or millimeters, explicitly labeled
- Stride length: meters

## Codex rules
- Do not calculate pace from rounded display distance.
- Use precise distance and duration when available.
- If total distance is missing, derive distance from distance samples or route points only when the derivation method is explicit.
- Show missing data honestly.
- Keep workout import idempotent using the HealthKit workout UUID.



---



<!-- Source file: 06-workout-events-intervals-laps.md -->


# 06. Workout Events, Intervals, and Laps

## Apple source
- https://developer.apple.com/documentation/healthkit/hkworkoutevent
- https://developer.apple.com/documentation/healthkit/hkworkouteventtype

## What workout events may represent
Workout events can represent changes or markers inside a workout, such as:
- Pause
- Resume
- Lap
- Segment
- Marker
- Other system-supported event types

The exact event availability depends on watchOS, workout type, recording app, and what the user did during the workout.

## Important limitation
HealthKit events may not include the same plain-English interval labels shown in Apple Fitness or the Workout app. Labels like:
- Warmup
- Work
- Recovery
- Cooldown
- Open

may need to be inferred from timing, workout structure, user-created plan data, manual labels, or app-specific rules.

## Recommended interval model
```swift
struct WorkoutInterval {
    let index: Int
    let startDate: Date
    let endDate: Date
    let duration: TimeInterval
    let distanceMeters: Double?
    let label: IntervalLabel
    let source: IntervalSource
}

enum IntervalSource {
    case healthKitEvent
    case workoutPlan
    case inferred
    case manual
}
```

## Inference rules
When labels are not available:
- Do not pretend inferred intervals are Apple-provided.
- Use a confidence field.
- Preserve raw events.
- Prefer user workout-plan data when available.
- Use timestamps and distance boundaries for splits.

## Codex rules
- Store raw `HKWorkoutEvent` data.
- Build intervals as a separate derived layer.
- Label inferred intervals as inferred.
- Do not assume every lap is a work interval.
- Do not assume every pause means the workout should be excluded from analysis.



---



<!-- Source file: 07-workout-routes-location-elevation.md -->


# 07. Workout Routes, Location, and Elevation

## Apple source
- https://developer.apple.com/documentation/healthkit/hkworkoutroute
- https://developer.apple.com/documentation/healthkit/hkworkoutroutequery
- https://developer.apple.com/documentation/corelocation/cllocation

## Workout route role
A workout route stores location points associated with a workout, when route recording is available and the user grants permission.

Route data can support:
- Map display
- Distance validation
- Pace over route segments
- Elevation gain estimation
- Start/end location display
- Detecting GPS gaps or bad samples

## Elevation
Elevation gain is usually calculated from altitude values on route points. Be careful:
- GPS altitude can be noisy.
- Small altitude changes should often be filtered.
- Indoor runs may have no route.
- Treadmill workouts usually do not have useful route points.
- Apple Fitness may use smoothing or device-specific logic not exposed as a direct field.

## Route-based calculations
When calculating from route points:
- Sort by timestamp.
- Remove invalid or duplicate points.
- Detect gaps.
- Apply reasonable smoothing for altitude.
- Do not overcount tiny altitude fluctuations.
- Document the calculation.

## Codex rules
- Do not require route data for workout import.
- Treat route and elevation as optional enrichment.
- Preserve raw `CLLocation` values where possible.
- Do not use route distance to override workout distance unless the app has a clear reconciliation rule.



---



<!-- Source file: 08-running-metrics-hr-power-cadence-form.md -->


# 08. Running Metrics: Heart Rate, Power, Cadence, and Form

## Apple source
- https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier
- https://developer.apple.com/documentation/healthkit/hkquantitysample
- https://developer.apple.com/documentation/healthkit/workouts_and_activity_rings

## Common running metrics
Apple Watch and HealthKit may provide some of the following, depending on watch model, watchOS, workout type, and permissions:
- Heart rate
- Running power
- Running speed
- Step count
- Running stride length
- Running vertical oscillation
- Running ground contact time
- Distance walking/running
- Active energy burned

Some metrics may not exist for older workouts, older watch models, or workouts recorded by third-party apps.

## Heart rate
Use heart rate samples to calculate:
- Average heart rate
- Max heart rate
- Heart rate over time
- Zone distribution
- Heart rate drift
- Recovery heart rate patterns

Be careful with missing samples, sparse samples, and sensor dropouts.

## Running power
Power should be treated as a time-series metric. Use source and timestamps. Do not assume a single workout-level value exists unless HealthKit provides it or the app calculates it.

## Cadence
Cadence may come from running-specific samples if available, or it may need to be estimated from steps over time. If estimated, label it clearly.

## Running dynamics
Ground contact time, vertical oscillation, and stride length are optional. Do not force these fields into every workout.

## Codex rules
- Never assume Apple Watch recorded every running metric.
- Use optional fields and missing-data states.
- Calculate averages from time-aligned samples.
- Exclude obvious dropouts when the app has documented filtering rules.
- Keep sample-level data available for charts and future recalculation.



---



<!-- Source file: 09-statistics-splits-pace.md -->


# 09. Statistics, Splits, and Pace

## Apple source
- https://developer.apple.com/documentation/healthkit/hkstatisticsquery
- https://developer.apple.com/documentation/healthkit/hkstatisticscollectionquery
- https://developer.apple.com/documentation/healthkit/hkquantitysample

## Pace
Pace is usually derived from distance and elapsed or moving time.

Recommended internal representation:
- Pace as seconds per kilometer.
- Display as `m:ss /km`.
- Store whether pace uses elapsed time or moving time.

## Splits
Splits can be calculated from:
- Distance samples
- Route points
- Speed samples
- Workout event/lap data
- App-defined interval definitions

For 1 km splits:
- Use cumulative distance when available.
- Interpolate crossing time when the split boundary falls between samples.
- Keep splits independent from rounded display values.

## Average values
For averages:
- Distance-weighted and time-weighted averages are not always the same.
- Heart rate average is usually time-based over samples.
- Pace average should come from total distance and time, not average of split paces.
- Power average should be time-based over valid power samples.

## Drift
For heart rate drift or pace fade:
- Define the comparison window clearly.
- Use first half vs second half, or matched segments.
- Avoid comparing warmup to work intervals unless intentionally analyzing workout execution.

## Codex rules
- Never average pace strings.
- Never calculate splits from rounded UI values.
- Keep elapsed pace and moving pace separate.
- Store calculation method with derived metrics.



---



<!-- Source file: 10-background-delivery-incremental-sync.md -->


# 10. Background Delivery and Incremental Sync

## Apple source
- https://developer.apple.com/documentation/healthkit/hkobserverquery
- https://developer.apple.com/documentation/healthkit/hkanchoredobjectquery
- https://developer.apple.com/documentation/healthkit/hkhealthstore/1614175-enablebackgrounddelivery

## Sync model
Use a durable sync process:
1. Request authorization.
2. Run an initial historical import.
3. Save anchors per object type.
4. Register observer queries.
5. When HealthKit notifies changes, run anchored queries.
6. Update local database records by HealthKit UUID.
7. Preserve deletion handling where supported.

## What to store
For each synced object type:
- Object type identifier
- Last anchor
- Last successful sync date
- Last error
- Number of inserted, updated, and deleted objects
- Source app/device if useful

## Error handling
HealthKit sync should be resilient:
- Retry on transient errors.
- Do not wipe local data on temporary authorization or query failures.
- Avoid full re-sync unless the anchor is invalid or the user requests it.
- Log enough information to debug data gaps.

## Codex rules
- Do not run expensive full-history queries on every app launch.
- Use anchored queries for incremental sync.
- Keep sync logic outside SwiftUI views.
- Make sync idempotent.
- Avoid duplicate workouts by matching HealthKit UUIDs.



---



<!-- Source file: 11-data-quality-source-reconciliation.md -->


# 11. Data Quality, Source, and Reconciliation

## Apple source
- https://developer.apple.com/documentation/healthkit/hksource
- https://developer.apple.com/documentation/healthkit/hksourcerevision
- https://developer.apple.com/documentation/healthkit/hkdevice
- https://developer.apple.com/documentation/healthkit/hkmetadata

## Why source matters
A user can have overlapping data from:
- Apple Watch
- iPhone
- Third-party apps
- Imported FIT/GPX files
- Manual entries
- Duplicate workout services

A robust running app must avoid blindly merging everything.

## Reconciliation strategy
For workouts:
- Prefer `HKWorkout` as the workout session identity.
- Use workout UUID for dedupe.
- Keep source information visible for debugging.
- Do not merge two workouts unless there is explicit evidence they are duplicates.

For samples:
- Filter by workout timeframe.
- Consider source if multiple devices overlap.
- Prefer Apple Watch data for Apple Watch workouts unless the user chose another source.
- Avoid combining third-party samples into an Apple Watch workout without a clear rule.

## Missing and suspicious data
Flag but do not crash on:
- Missing route
- Missing heart rate
- Missing distance
- Missing power
- Gaps in samples
- Zero or impossible values
- Unusually high GPS distance
- Duplicate workouts

## Codex rules
- Add quality flags instead of silently correcting data.
- Store original source and metadata.
- Keep a reconciliation audit trail for derived values.
- Do not hide missing data behind zero values.



---



<!-- Source file: 12-running-app-implementation-patterns.md -->


# 12. Running App Implementation Patterns

## Apple source
- https://developer.apple.com/documentation/healthkit
- https://developer.apple.com/documentation/healthkit/hkworkout
- https://developer.apple.com/documentation/healthkit/hkworkoutroute
- https://developer.apple.com/documentation/healthkit/hkquantitysample

## Recommended architecture

### HealthKitClient
Responsible for:
- Authorization
- Query execution
- Anchored sync
- Observer registration
- Raw HealthKit object mapping

### WorkoutRepository
Responsible for:
- Local persistence
- Dedupe
- Updating imported workouts
- Querying app models

### MetricsEngine
Responsible for:
- Pace
- Splits
- Heart rate summaries
- Power summaries
- Drift
- Running dynamics summaries
- Data quality flags

### Presentation layer
Responsible for:
- UI formatting
- Missing-data messaging
- Charts
- Human-readable labels

## Import pipeline
1. Fetch workouts.
2. Upsert workout shell by HealthKit UUID.
3. Fetch related samples by type and timeframe.
4. Fetch route if available.
5. Store raw samples.
6. Run metrics engine.
7. Save derived metrics with calculation version.
8. Display workout summary.

## Calculation versioning
Every derived metric should include:
- Calculation version
- Inputs used
- Date calculated
- Confidence or quality flags where relevant

This allows the app to improve calculations later without losing raw data.

## Codex rules
- Build raw import first, derived calculations second.
- Make calculations repeatable.
- Keep UI separate from HealthKit.
- Add tests for pace, split, and interval calculations.



---



<!-- Source file: references/apple-healthkit-links.md -->


# Apple HealthKit Documentation Links

Use these links as the source-of-truth list when Codex needs to verify Apple behavior.

## Framework overview
- HealthKit: https://developer.apple.com/documentation/healthkit
- About the HealthKit framework: https://developer.apple.com/documentation/healthkit/about-the-healthkit-framework
- Setting up HealthKit: https://developer.apple.com/documentation/healthkit/setting-up-healthkit

## Authorization and store
- HKHealthStore: https://developer.apple.com/documentation/healthkit/hkhealthstore
- HealthKit entitlement: https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_healthkit

## Core object model
- HKObject: https://developer.apple.com/documentation/healthkit/hkobject
- HKSample: https://developer.apple.com/documentation/healthkit/hksample
- HKQuantitySample: https://developer.apple.com/documentation/healthkit/hkquantitysample
- HKCategorySample: https://developer.apple.com/documentation/healthkit/hkcategorysample
- HKQuantityType: https://developer.apple.com/documentation/healthkit/hkquantitytype
- HKSampleType: https://developer.apple.com/documentation/healthkit/hksampletype
- HKObjectType: https://developer.apple.com/documentation/healthkit/hkobjecttype
- HKQuantityTypeIdentifier: https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier

## Queries
- HKSampleQuery: https://developer.apple.com/documentation/healthkit/hksamplequery
- HKAnchoredObjectQuery: https://developer.apple.com/documentation/healthkit/hkanchoredobjectquery
- HKStatisticsQuery: https://developer.apple.com/documentation/healthkit/hkstatisticsquery
- HKStatisticsCollectionQuery: https://developer.apple.com/documentation/healthkit/hkstatisticscollectionquery
- HKObserverQuery: https://developer.apple.com/documentation/healthkit/hkobserverquery
- enableBackgroundDelivery: https://developer.apple.com/documentation/healthkit/hkhealthstore/1614175-enablebackgrounddelivery

## Workouts
- HKWorkout: https://developer.apple.com/documentation/healthkit/hkworkout
- HKWorkoutType: https://developer.apple.com/documentation/healthkit/hkworkouttype
- HKWorkoutActivityType: https://developer.apple.com/documentation/healthkit/hkworkoutactivitytype
- HKWorkoutEvent: https://developer.apple.com/documentation/healthkit/hkworkoutevent
- HKWorkoutEventType: https://developer.apple.com/documentation/healthkit/hkworkouteventtype
- HKWorkoutRoute: https://developer.apple.com/documentation/healthkit/hkworkoutroute
- HKWorkoutRouteQuery: https://developer.apple.com/documentation/healthkit/hkworkoutroutequery

## Source, device, and metadata
- HKSource: https://developer.apple.com/documentation/healthkit/hksource
- HKSourceRevision: https://developer.apple.com/documentation/healthkit/hksourcerevision
- HKDevice: https://developer.apple.com/documentation/healthkit/hkdevice
- HKMetadata: https://developer.apple.com/documentation/healthkit/hkmetadata

## Related Apple frameworks
- Core Location CLLocation: https://developer.apple.com/documentation/corelocation/cllocation
- WorkoutKit: https://developer.apple.com/documentation/workoutkit



---



<!-- Source file: references/api-symbol-index.md -->


# API Symbol Index

This is a quick index for Codex. Verify each symbol in Apple documentation before implementation.

## Store and authorization
- `HKHealthStore`
- `HKObjectType`
- `HKSampleType`
- `HKQuantityType`
- `requestAuthorization(toShare:read:)`

## Samples and objects
- `HKObject`
- `HKSample`
- `HKQuantitySample`
- `HKCategorySample`
- `HKWorkout`
- `HKWorkoutEvent`
- `HKWorkoutRoute`

## Queries
- `HKSampleQuery`
- `HKAnchoredObjectQuery`
- `HKStatisticsQuery`
- `HKStatisticsCollectionQuery`
- `HKObserverQuery`
- `HKWorkoutRouteQuery`

## Running-related types to verify
- Distance walking/running
- Active energy burned
- Heart rate
- Step count
- Running speed
- Running power
- Running stride length
- Running vertical oscillation
- Running ground contact time

## Metadata/source
- `HKSource`
- `HKSourceRevision`
- `HKDevice`
- `HKMetadataKeySyncIdentifier`
- `HKMetadataKeySyncVersion`

## Units
- `HKUnit.meter()`
- `HKUnit.second()`
- `HKUnit.count()`
- `HKUnit.count().unitDivided(by: .minute())`
- `HKUnit.kilocalorie()`
- `HKUnit.watt()`



---



<!-- Source file: prompts/codex-healthkit-reference-prompt.md -->


# Codex Prompt: Use HealthKit Reference Pack

Use this when starting a Codex task related to HealthKit, Apple Watch workouts, or running app metrics.

```text
Before making changes, read the HealthKit reference pack in this folder.

Start with:
1. 13-codex-rules-for-healthkit.md
2. references/apple-healthkit-links.md
3. The topic-specific file relevant to the task.

Apple documentation is the source of truth. The local markdown files are implementation guidance and summaries only.

For any HealthKit change:
- Preserve raw HealthKit identity and metadata.
- Separate raw data from derived metrics.
- Use optional fields for metrics that may not exist.
- Do not assume Apple Fitness display fields are available directly in HealthKit.
- Add or update tests for unit conversion, missing data, dedupe, and derived calculations.
- Explain which values are read directly from HealthKit and which values are calculated by the app.
```
