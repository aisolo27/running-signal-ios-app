# Bug Log And Gotchas

Use this as a selective lookup, not required full-context reading. Read the index, then only the section relevant to the current task.

## Index

- XcodeBuildMCP and simulator workflow: build/run/test tool mistakes, scheme/defaults issues.
- Package and platform configuration: `Package.swift`, Swift tools, iOS/macOS availability.
- HealthKit: read-only permission/data issues, Simulator limitations, route/sample APIs.
- SwiftData and persistence: local model storage, manual-field preservation, migration risk.
- SwiftUI and layout: blank screens, tab/detail layout, keyboard/editing issues.
- Analytics and data quality: pace math, duplicates, confidence gates, missing data.
- Milestones and docs: completion rules and tracking.

## XcodeBuildMCP And Simulator Workflow

- Symptom: build/run failed with signing/team errors. Cause: used a macOS run tool on an iOS app. Fix: use iOS simulator tools (`test_sim`, `build_run_sim`) with the `RunningWorkoutAnalysis` scheme.
- Symptom: tests failed before compiling because Xcode could not read the test plan. Cause: generated scheme contained a stale duplicate test-plan reference. Fix: keep only `RunningWorkoutAnalysis/RunningWorkoutAnalysis.xctestplan` in the shared scheme.
- Rule: before any Xcode build/run/test, call XcodeBuildMCP `session_show_defaults` and verify workspace, scheme, and simulator.
- Rule: after a physical `build_run_device`, XcodeBuildMCP UI snapshot/screenshot tools can still target the active Simulator. Do not treat Simulator snapshots as physical-iPhone proof; physical HealthKit verification still needs on-device export or a device-specific capture path.

## Package And Platform Configuration

- Symptom: package resolution failed with `.iOS(.v26)` unavailable. Cause: `Package.swift` used `swift-tools-version: 6.1`. Fix: keep Swift tools at `6.2` for iOS 26 package declarations.
- Symptom: `swift test --package-path RunningWorkoutAnalysisPackage` produced SwiftUI/SwiftData/HealthKit availability noise for macOS. Cause: package tests compile on macOS unless a compatible macOS platform is declared. Fix: keep `.macOS(.v14)` in `Package.swift` for local package tests while keeping the app iPhone/iOS-focused.

## HealthKit

- Symptom: route API compile errors around `HKDataTypeIdentifier`. Cause: wrong route type API for this toolchain. Fix: use `HKSeriesType.workoutRoute()`.
- Rule: HealthKit v1 is read-only. Do not write workouts or mutate HealthKit data.
- Rule: Simulator cannot prove real HealthKit permissions or real workout availability. Use sample fallback in Simulator and record physical-iPhone verification separately.
- Rule: Fitness-style run analysis needs per-workout HealthKit sample/series queries, not only workout summary statistics; gate threshold, interval, drift, and target-vs-actual claims on detailed series coverage.
- Rule: `HKWorkoutRouteQuery` callbacks may arrive on concurrent queues; collect route points behind a thread-safe helper instead of mutating a captured array directly.
- Rule: Fitness-style detail comes from a mix of `HKWorkout.statistics(for:)`, associated quantity samples, workout routes, and workout events. Total calories and custom workout labels may not be exposed as clean public HealthKit fields; extract them only when HealthKit returns evidence and keep UI wording cautious.

## SwiftData And Persistence

- Rule: preserve manual fields (`manualRunType`, `notes`) when refreshing workouts from HealthKit.
- Risk: SwiftData schema is v1-only. If fields are renamed or removed later, add an explicit migration plan instead of casual model churn.

## SwiftUI And Layout

- Symptom: accessibility snapshot failed immediately after launch or keyboard focus. Cause: Simulator UI/keyboard had not settled. Fix: retry `snapshot_ui` after a short settle or use screenshot for visual verification.
- Rule: verify all five tabs after meaningful UI changes: Today, Latest Run, Race Goal, History, Data.
- Rule: after editing notes or labels, verify the detail view still opens and save does not crash.

## Analytics And Data Quality

- Rule: pace is canonical as seconds per kilometer; display as `m:ss /km`.
- Rule: aggregate pace from total duration over total distance, not unweighted averages.
- Rule: duplicate candidates are excluded from weekly volume, readiness, intensity distribution, trends, and best efforts.
- Rule: missing HealthKit fields must lower confidence or show caveats; do not promote mechanics/form insights until coverage supports them.
- Rule: calories stay supplemental and must not drive primary coaching decisions.
- Rule: total calories may be shown only when HealthKit returns both active energy and basal energy evidence for the workout. Do not estimate basal calories from body metrics or elapsed time to force Apple Fitness parity.
- Rule: cadence must display as full steps per minute for Apple Fitness parity. If a persisted or imported summary cadence is clearly half-cadence, normalize display/parity outputs to full-step cadence and keep raw sample counts visible in debug.
- Rule: 1 km split parity depends on interpolating the boundary time between distance samples. Snapping a split to the next sample timestamp can drift by several seconds or more when HealthKit distance samples are sparse or uneven.
- Rule: raw `HKWorkoutEvent` segment durations are not the same as Apple Fitness Intervals. Keep raw markers in debug/audit surfaces and do not present them as comparable Warmup/Work/Recovery/Cooldown rows until a derived interval model can calculate distance, time, pace, and heart-rate fields.
- Rule: Apple Fitness split times can still differ by a few seconds from RunSignal's HealthKit distance-series interpolation because Apple may use private smoothing, route/distance presentation, and rounding. Treat 3 seconds on a 1 km split as an acceptable parity tolerance unless repeated evidence shows a wider drift.
- Rule: total calories can differ from Apple Fitness by about 1 kcal after refresh because active and basal energy may be summed from unrounded HealthKit evidence while Apple Fitness rounds display values. Treat 1 kcal as acceptable rounding tolerance.

## Milestones And Docs

- Rule: keep `docs/milestones/` current. Do not mark a milestone complete until tests pass, the app launches in Simulator, and completion notes include limitations.
- Rule: add only durable recurring issues to this bug log. Ignore one-off temp paths, process IDs, and incidental log locations.
