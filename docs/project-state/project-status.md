# RunSignal Project Status

Last updated: 2026-07-01

## Product Direction

RunSignal is a native iPhone SwiftUI app for evidence-grounded completed running workout analysis.

The current v1 priority is Apple Watch custom workout correctness across warmup, work, recovery, cooldown, repeat blocks, pauses, and `Open / Extra` tails. Coaching expansion, backend sync, AI calls, FIT import, HealthFit import/export, and file-based workout ingestion remain out of scope.

The active milestone is `Custom Workout Correctness Lock v1`: keep the generalized evidence-gated custom workout row resolver stable now that WorkoutKit planned rows plus complete contiguous HealthKit activity rows are approved as the v1 normal-detail source when the evidence gate passes.

Decision rule: do not grow support by hard-fitting one workout shape at a time. Product custom-workout rows come from WorkoutKit planned row order plus complete contiguous HealthKit activity boundaries, enriched with HealthKit samples for distance, time, pace, heart rate, power, cadence, and pause/active timing. Older plan/sample-derived reconstruction must not substitute as a product fallback.

## First-Read Map

- Use this file for current state, next work, blockers, and out-of-scope boundaries.
- Use `docs/project-state/accuracy-ledger.md` for workout-shape status, promotion rungs, proof bars, and allowed/blocked interval behavior.
- Use `docs/project-state/documentation-index.md` when choosing deeper docs, scorecards, scripts, or archives.

## Runtime Data Contract

- HealthKit is the runtime source of truth for completed running workouts.
- HealthKit access is read-only.
- WorkoutKit `HKWorkout.workoutPlan` is the planned-structure source when available.
- HealthKit samples and `HKWorkout.workoutActivities` are the measured-stats and boundary evidence sources.
- HealthKit segment markers stay raw/debug-only.
- FIT files are offline validation evidence only, not runtime truth and not an app input.
- Apple Fitness screenshots/manual rows are optional sanity evidence, not the main promotion gate.
- Whole-run stats remain usable even when custom interval rows are blocked.

## Project Shape

- Open/build `RunningWorkoutAnalysis.xcworkspace`.
- The app target is a thin shell.
- Primary implementation lives in `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/`.
- Package tests run with `swift test --package-path RunningWorkoutAnalysisPackage`.
- Keep `Package.swift` compatible with iOS 26 and macOS 14 so local package tests remain usable.

## Current Validation State

Production custom workout intervals use resolved activity-boundary rows when the evidence gate passes: WorkoutKit planned rows are present and ordered, HealthKit activity rows are complete/contiguous and map to those rows or to a completed prefix for stopped-early workouts, pause/resume events are paired and contained within one row, and any post-fixed-row tail is deterministic.

Normal workout detail supports these resolved custom-workout row classes when the evidence gate passes:

- Stopped-early single fixed-distance `Work`.
- Stopped-early multi-step custom workouts mapped to the completed WorkoutKit planned prefix.
- Simple fixed-distance `Work > inferred Open / Extra`.
- `Warmup(2 km) > one Work step > Cooldown(Open)`.
- `Warmup(2 km) > one Work step > fixed Cooldown > inferred Open / Extra`.
- Clean no-pause repeat blocks with open cooldown.
- Clean no-pause repeat blocks with fixed cooldown plus inferred `Open / Extra`.
- Narrow paused-repeat blocks with active/timer display for paused rows only.
- Narrow May 1-style `Warmup > Recovery > Work > fixed Cooldown > inferred Open / Extra`.

Paused timing semantics use a pause-window state machine for explicit pause/resume, motion pause/resume, and `pauseOrResumeRequest` toggle events. Duplicate, dangling, unpaired, cross-row, or otherwise caveated pause streams stay blocked from normal-detail promotion.

`DerivedAnalyticsEngine.intervalCandidates` remains a raw HealthKit event-marker debug path only. Derived interval analytics publish rows only from the resolved custom-workout row path when the normal-detail evidence gate passes.

## Current Next Work

- Keep resolved activity-boundary row behavior stable across archived Apple Fitness fixtures and priority workouts.
- Re-export the June 30 clean no-pause repeat fixed-cooldown/`Open / Extra` workout from a fresh current-build physical-iPhone install.
- Confirm visible/export status labels agree with the official resolved-row source.
- Continue hardening fallback reasons for missing plans, incomplete activity rows, unpaired pauses, cross-row pauses, and stale summary-only evidence.
- Keep interval analytics limited to evidence-gated resolved rows until supported and blocked custom-workout styles have stable rows, diagnostics agreement, and regression fixtures.

## Blocked

- Missing WorkoutKit plans, missing/non-contiguous/incomplete HealthKit activity rows, activity rows that exceed planned row count, unpaired or cross-row pause streams, stale summary-only evidence, and non-prefix partial repeat context remain blocked from custom interval rows.
- HealthKit segment markers remain raw/debug-only and must not be treated as Apple Fitness row truth.
- March 19-style material distance drift remains blocked until renewed evidence resolves the drift.
- Duplicate, no-plan, same-day extra, drift/guard-unknown, stale summary-only, or missing-detail workouts remain excluded from production approval scoring.

## Known Limitations

- Some older runs are summary-only because detailed HealthKit series may be unavailable.
- FIT does not prove exact Apple Fitness UI presentation parity or private Apple smoothing/labeling rules.
- WorkoutKit plan data can be unavailable or throw and must stay optional.
- Mechanics, trends, stronger run-type claims, and interval-row analytics remain confidence-gated.

## Recent Proof And Follow-Up

- `docs/validation/apple-fitness-interval-parity-dataset/user-supplied-june30-clean-repeat-tail-review-2026-06-30/` archives June 30 user-supplied evidence for a clean no-pause repeat fixed-cooldown/`Open / Extra` workout.
- `docs/validation/apple-fitness-interval-parity-dataset/physical-iphone-priority-repeat-proof-2026-06-28/` archives the five-priority physical proof set with Apple Fitness screenshots, typed manual rows, and Raw HealthKit Debug/Parity Lab exports.
- Health Context follow-up: verify VO2 Max and Resting Heart Rate on the physical iPhone after granting Apple Health read access.
- Best Efforts follow-up: visible official segment bests use `PersonalBestEffortEngine` exact distance-window records; summary-only whole-run estimates remain excluded.
- Refresh architecture follow-up: verify monthly evidence refresh activation, scroll responsiveness, thermal behavior, and archived diagnostics/logs on the physical iPhone.

## 2026-06-30 Interval Status Agreement

- Normal detail fallback copy uses one clean `Intervals under review` state with a `View Interval Evidence` path to Raw Debug.
- Raw Debug and exports use `Official Interval Rows`, `Resolved Row Evidence`, and `Not promoted yet` labels so evidence existence and promotion status do not read as contradictory.
- Raw Debug developer controls, monthly diagnostics, and source/device metadata sit behind a collapsed `Developer tools` disclosure.

## 2026-07-01 Analytics Expansion Slice

- RunSignal has a first-pass `Analytics` tab with `Week Signal`: Monday-start weekly totals, run count, average pace, daily distance bars, purpose-category totals, and weekly workout rows from non-duplicate HealthKit runs.
- Workout detail uses Swift Charts-backed core chart cards for pace, heart rate, power, and cadence.
- Official promoted interval rows are tappable into interval detail; under-review evidence rows and raw/debug candidates remain out of product drill-down.
- Workout detail now has a HealthFit-inspired `Interval Analysis` overview for official promoted interval rows: work-row aggregate metrics, per-row bars for pace, heart rate, power, cadence, duration, and distance, shared chart scrub selection, pause-aware active-timer pace, and the existing Apple-Fitness-like row list/drill-down below it.
- Remaining proof is physical-iPhone validation with real HealthKit data for the weekly analytics tab, chart rendering, and one official interval drill-down.
- Remaining interval-chart proof is a physical-iPhone workout whose official resolved rows are promoted, then visually checking the interval analysis scrub, selected-row values, and drill-down charts against Raw Debug/exported resolved rows.

## 2026-07-01 Repo Cleanup Slice

- README routing points new agents to `project-status.md`, `accuracy-ledger.md`, and `documentation-index.md` instead of removed `current-state.md` / `next-work.md` files.
- Removed unrouted legacy SwiftUI screens and an unused workout-series wrapper while leaving validation evidence, interval resolver logic, diagnostics exports, and raw/debug interval boundaries intact.
- `.gitignore` covers additional Xcode/test scratch outputs without broadly ignoring curated validation evidence.
