# RunSignal Project Status

Last updated: 2026-07-10

This is the only current project-status and next-work authority. Historical plans, proof notes, and old test counts do not override it.

## Product Contract

RunSignal is a native iPhone SwiftUI app for evidence-grounded analysis of completed running workouts. V1 is HealthKit-only and read-only.

- HealthKit completed running workouts are runtime truth.
- WorkoutKit `HKWorkout.workoutPlan`, when available, supplies planned custom-workout structure.
- HealthKit workout summaries, samples, routes, events, and `HKWorkoutActivity` rows supply completed metrics and public boundary evidence.
- FIT, HealthFit, screenshots, and manual rows are offline validation evidence only, never app inputs.
- Segment/lap/marker events remain raw debug evidence and are not Apple Fitness interval rows.
- Whole-run analytics remain available when custom interval evidence is unavailable.
- Backend sync, AI coaching, file import/export, and HealthKit writes remain out of scope.

## Project Shape

- Open and build `RunningWorkoutAnalysis.xcworkspace` with the `RunningWorkoutAnalysis` scheme.
- The app target is a thin shell; implementation lives in `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/`.
- Package tests: `swift test --package-path RunningWorkoutAnalysisPackage`.
- `Package.swift` stays compatible with iOS 26 and macOS 14.

## Official Custom-Workout Resolver

One generalized evidence gate controls product interval rows. It is not a workout-shape whitelist.

Rows can publish when ordered expanded WorkoutKit planned rows map to complete contiguous HealthKit activity rows, or to a completed planned prefix for a stopped-early workout. Repeat context must be complete enough to prove the mapping. Pause windows must be paired, reliable, and contained within one row. Any post-plan tail must be deterministic.

- Planned open cooldown remains `Cooldown` through workout end.
- `Open / Extra` is inferred only after every mapped fixed planned row is complete and continued activity remains above the tail threshold.
- Stopped-early workouts show only the completed prefix and never invent unfinished rows or a tail.
- Paused rows display active/timer duration; elapsed duration and pause overlap remain available for detail and diagnostics.
- Shortened or manually skipped distance work uses measured HealthKit distance and pause-adjusted active time. It never chases the unfinished planned distance.
- Runner-facing fixed-distance rows may show prescribed distance, while measured HealthKit values remain the validation and aggregate truth.
- Completion status and target-pace status are separate.
- Official row analytics consume only resolved product rows. `DerivedAnalyticsEngine.intervalCandidates` stays debug-only.

## Supported Behavior

The generalized gate covers:

- Normal custom Work/Recovery/Cooldown sequences and repeat blocks.
- Clean and pause-aware repeats.
- Planned open cooldowns.
- Fixed cooldown followed by deterministic `Open / Extra`.
- Recovery-containing rows when every planned row maps cleanly.
- Single-row and multi-row stopped-early completed prefixes.
- Dynamic distance/time goals and typed pace-range target evaluation.
- Unstructured or no-plan runs as `Other`, with whole-run analytics and normal splits but no custom interval analysis.

Representative real-device cases and their exact regression tests are cataloged in `docs/project-state/regression-cases.md`.

## Blocked And Fallback Behavior

Custom interval rows must remain unavailable when evidence contains:

- Missing WorkoutKit plan.
- Missing, incomplete, non-contiguous, or excess HealthKit activity rows.
- Incomplete or non-prefix repeat context.
- Duplicate, dangling, unpaired, ambiguous, or cross-row pauses.
- Ambiguous Warmup/Recovery/Cooldown or post-plan tail mapping.
- Material boundary drift or stale summary-only evidence.

These conditions produce whole-run detail plus a clear unavailable/review reason. Older plan/sample reconstruction and raw event markers must never silently replace product rows.

## Current Product State

- Run taxonomy is exactly Easy, Long, Interval, Threshold, Race, and Other. Tempo is folded into Threshold.
- Manual category edits persist and update Analytics without hydrating all detailed evidence.
- A single manual category edit refreshes only the affected Week, Month, Year, and All-Time caches; unrelated historical period caches remain untouched.
- Analytics supports Week, Month, Year, and All-Time views, purpose mix, charts, Best Efforts, interval prescriptions, target evaluation, interval library grouping, and like-for-like trends.
- Analytics merges persisted and currently loaded official interval workouts by workout ID, with current loaded evidence winning, before building the interval library.
- Structured workouts show their WorkoutKit plan and official interval rows when the resolver passes.
- Work rows support hit/too-fast/too-slow pace-target evaluation, visibly distinct shortened-work status, and pause-aware measured math. A shortened target row can say `On Target · Shortened` so pace result never hides completion state.
- Completed fixed-distance rows show prescribed distance with HealthKit activity-row time, heart rate, cadence, and power. Their displayed pace and target evaluation use that same activity-row timer plus prescribed-distance basis; shortened rows continue to use measured distance and active time.
- HealthKit history import, anchored foreground sync, deletion handling, background observer registration, resumable summary backfill, compact derived caches, and Low Power/thermal budgets are implemented.
- Background-delivery registration failures report their own message without downgrading valid cached/query-based HealthKit readiness.
- Normal bootstrap avoids hydrating the full detailed-evidence table.

## Current Next Work

- Observe limited-history authorization, observer delivery, anchored deletions, backlog continuation, interruption/resume, Low Power Mode, thermal behavior, and battery impact on a physical iPhone.
- Profile the local training-period summary cache with a large real HealthKit history.
- Re-export the June 30 clean repeat/fixed-cooldown/`Open / Extra` case from a fresh current build and confirm visible/export status agreement.
- Re-verify the July 9 recording cases on a physical iPhone: loaded HealthKit readiness at launch, repeated run-detail-to-Analytics navigation, category-edit responsiveness with the real history, Priority 5 shortened-row copy, and activity-row pace/heart-rate/power/cadence parity against Apple Fitness.
- Continue tightening explicit fallback reasons without expanding into guessed interval rows.

## Known Limitations

- Some historical workouts are summary-only because detailed HealthKit series may be unavailable.
- WorkoutKit plan data is optional and can be unavailable or fail to load.
- Simulator sample data cannot prove HealthKit permissions, real workout availability, background delivery, thermal behavior, battery impact, or physical launch performance.
- Apple Fitness can use private smoothing, rounding, and presentation rules not exposed by public APIs.

## Latest Verification

On 2026-07-10, all 286 package tests passed. Simulator build/install/launch passed on iPhone 17. In sample-data mode, launch, run detail, an immediate category edit plus follow-on swipe, repeated run-detail-to-Analytics navigation, and Settings-to-Analytics navigation all completed without an app assertion or crash. The captured runtime logs contained no RunSignal fatal/assertion/crash signature; the Simulator runtime emitted one system Accessibility duplicate-class warning. Physical-iPhone build/install/launch also passed on `AIS17PM` running iOS 26.5.2. Real HealthKit readiness, real-history edit latency, shortened-row presentation, and Apple Fitness metric parity still require interaction re-verification on that device.
