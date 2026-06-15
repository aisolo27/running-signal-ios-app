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
- Rule: WorkoutKit custom-workout distance-goal rows are not generic 1 km splits. Prefer the crossing HealthKit distance sample end only when its overshoot is inside the documented small tolerance; otherwise fall back to interpolated crossing.
- Rule: distinguish planned open cooldowns from post-cooldown extra activity. A final WorkoutKit `Cooldown` step with an open goal should keep the `Cooldown` label through workout end; a fixed distance/time cooldown that completes and is followed by continued running should leave the remaining activity as `Open / Extra`.
- Rule: Apple Fitness split times can still differ by a few seconds from RunSignal's HealthKit distance-series interpolation because Apple may use private smoothing, route/distance presentation, and rounding. Treat 3 seconds on a 1 km split as an acceptable parity tolerance unless repeated evidence shows a wider drift.
- Rule: older workouts with zero detailed evidence should not be used for boundary tuning until Raw HealthKit Debug proves fresh evidence loading. Check for stale summary-only cached evidence or an empty-detail workout that was marked enriched; a future debug-only reload action should invalidate the selected workout's evidence cache before re-querying HealthKit.
- Rule: total calories can differ from Apple Fitness by about 1 kcal after refresh because active and basal energy may be summed from unrounded HealthKit evidence while Apple Fitness rounds display values. Treat 1 kcal as acceptable rounding tolerance.
- Rule: docs-only FIT decoders should map `workout_step` to FIT global message `27`; global message `26` is `workout`. A wrong mapping can parse placeholder step rows and falsely classify repeat-block evidence.
- Rule: Gate B row-level FIT timing must keep elapsed time and timer time visible. Large custom-workout errors can be pause/timer artifacts even when labels and distances look good, so do not approve repeat-block or warmup/work/cooldown subclasses from a single derived duration.
- Rule: WorkoutKit can represent a one-step Work section as `Block 1: 1x, 1 step(s)`. Treat that as a single Work step, not a repeat-block blocker; only expanded repeat iterations such as `repeatIndex > 1` should trigger `repeat-block-needs-rule`.
- Rule: clean fixed-cooldown Open / Extra tail support does not approve recovery-containing tails, repeat-block tails, simple Work/Open promotion, or broad `HKWorkoutActivity` promotion. Keep those behind separate Gate B decisions.
- Rule: count/shape alignment is not enough for normal-detail interval promotion. For approved normal-detail gates, require complete contiguous `HKWorkoutActivity` rows with distance statistics, then use those activity windows as the displayed interval boundaries. Do not re-block clean activity-backed rows just because the older distance/time reconstruction engine drifts by a few seconds.
- Rule: time-goal custom-workout rows use elapsed planned seconds until pause-adjusted active timer logic exists. Block promoted time-goal normal-detail rows when paired pause/resume evidence is present.
- Rule: paused repeat-block rows must preserve both elapsed row windows and active/timer duration. For docs/debug scoring, compute active/timer duration by subtracting paired HealthKit pause overlap from the elapsed HealthKit activity window; FIT can validate this offline but must not be the runtime source. Keep rows blocked when pause events are unpaired, overlap is ambiguous, or repeat/tail guards are unresolved.
- Rule: recovery-containing Open/Extra tails must keep planned Recovery rows distinct from post-plan residual movement. Infer Open/Extra only after every fixed planned row maps to a complete contiguous HealthKit activity row and the final fixed row is exhausted; block when the tail overlaps Recovery, the final step is an open cooldown, or the residual is below threshold/ambiguous.
- Rule: ambiguous repeat-tail cases must expand repeat blocks and map every Work/Recovery/Cooldown row before inferring Open/Extra. A final open cooldown remains Cooldown through workout end; Open/Extra after repeats requires a resolved fixed final row plus residual movement above threshold. Count alignment or FIT session-minus-lap residuals alone are not enough.
- Rule: Gate A simple Work/Open prototype eligibility is exactly one fixed-distance planned Work step, exactly one complete HealthKit activity row, and a positive Open/Extra tail. Any Warmup, Recovery, Cooldown, repeat block, structured interval, missing plan, duplicate/no-plan status, activity mismatch, or ambiguous tail must fall back.
- Rule: a stopped-early single fixed-distance Work custom workout can still be a valid partial Work row when one planned Work step maps to one complete HealthKit activity row and FIT offline evidence shows the same one-step/one-lap shape. Keep this separate from broad simple Work/Open promotion.
- Rule: plain open Watch runs can have FIT split laps and HealthKit activity rows but zero WorkoutKit planned steps. Treat them as readable workouts with splits/whole-run analysis, not custom interval workouts.
- Rule: HealthFit FIT session elapsed duration may decode as `0.0 s` through the lightweight docs parser even when lap rows and session timer duration are valid. For offline validation, keep lap rows and timer duration visible and do not score these files from session elapsed alone.

## Milestones And Docs

- Rule: keep `docs/milestones/` current. Do not mark a milestone complete until tests pass, the app launches in Simulator, and completion notes include limitations.
- Rule: add only durable recurring issues to this bug log. Ignore one-off temp paths, process IDs, and incidental log locations.
