# RunSignal Project Status

Last updated: 2026-07-06

## Product Direction

RunSignal is a native iPhone SwiftUI app for evidence-grounded completed running workout analysis.

The current v1 priority is Apple Watch custom workout correctness across warmup, work, recovery, cooldown, repeat blocks, pauses, and `Open / Extra` tails. Coaching expansion, backend sync, AI calls, FIT import, HealthFit import/export, and file-based workout ingestion remain out of scope.

The active milestone is `Custom Workout Correctness Lock v1`: keep the generalized evidence-gated custom-workout row resolver stable now that WorkoutKit planned rows plus complete contiguous HealthKit activity rows are approved as the v1 normal-detail source when the evidence gate passes.

Decision rule: do not grow support by hard-fitting one workout shape at a time. Product custom-workout rows come from WorkoutKit planned row order plus complete contiguous HealthKit activity boundaries, enriched with HealthKit samples for distance, time, pace, heart rate, power, cadence, and pause/active timing. Older plan/sample-derived reconstruction must not substitute as a product fallback.

## First-Read Map

- Use this file for current state, next work, blockers, and out-of-scope boundaries.
- Use `docs/project-state/accuracy-ledger.md` for workout-shape status, promotion rungs, proof bars, and allowed/blocked interval behavior.
- Use `docs/project-state/data-ingestion-background-reference.md` for current on-device HealthKit load, cache, foreground sync, detailed-evidence backfill, and background-work risk review.
- Use `docs/project-state/data-ingestion-ai-review-synthesis.md` for the consolidated ChatGPT/Claude/Grok/Perplexity review and prioritized ingestion hardening plan.
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

Production custom workout intervals use resolved activity-boundary rows when the evidence gate passes: WorkoutKit planned rows are present and ordered, HealthKit activity rows are complete/contiguous and map to those rows or to a completed prefix for stopped-early workouts, repeat context is complete enough to prove the mapped prefix, pause/resume events are paired and contained within one row, and any post-fixed-row tail is deterministic.

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

The official resolver is generalized beyond these named proof fixtures: future Work/Recovery/Cooldown repeat shapes can promote when the same WorkoutKit prefix, complete contiguous HealthKit activity rows, repeat-context, pause, and tail gates pass. `Open / Extra` is inferred only after all planned rows map and the final planned row is a fixed `Work` or `Cooldown`; planned open cooldowns remain `Cooldown`, stopped-early prefixes suppress tails, and Warmup-only tails stay under review.

Paused timing semantics use a pause-window state machine for explicit pause/resume, motion pause/resume, and `pauseOrResumeRequest` toggle events. Duplicate, dangling, unpaired, cross-row, or caveated pause streams stay blocked from normal-detail promotion. Terminal zero-duration `rawValue: 1` pause markers at workout end are ignored because they do not represent paused elapsed time.

`DerivedAnalyticsEngine.intervalCandidates` remains a raw HealthKit event-marker debug path only. Derived interval analytics publish rows only from the resolved custom-workout row path when the normal-detail evidence gate passes.

## Current Next Work

- Continue data ingestion hardening before expanding analytics depth: measure the new import job, observer delivery, anchored deletions, large backlog sync, thermal behavior, and battery impact on a physical iPhone.
- Profile the new local training-period summary cache on a physical iPhone with a large real HealthKit history; keep it as a disposable SwiftData projection over HealthKit-backed workouts, not a new source of truth.
- Keep generalized resolved activity-boundary row behavior stable across archived Apple Fitness fixtures and priority workouts.
- Re-export the June 30 clean no-pause repeat fixed-cooldown/`Open / Extra` workout from a fresh current-build physical-iPhone install.
- Confirm visible/export status labels agree with the resolved-row source.
- Continue hardening fallback reasons for missing plans, incomplete activity rows, inconsistent repeat context, unsupported tail shapes, unpaired pauses, cross-row pauses, and stale summary-only evidence.
- Keep interval analytics limited to evidence-gated resolved rows until supported and blocked custom-workout styles have stable rows, diagnostics agreement, and regression fixtures.

## Blocked

- Missing WorkoutKit plans, missing/non-contiguous/incomplete HealthKit activity rows, activity rows that exceed planned row count, inconsistent or non-prefix repeat context, unsupported tail shapes, unpaired or cross-row pause streams, and stale summary-only evidence remain blocked from custom interval rows.
- HealthKit segment markers remain raw/debug-only and must not be treated as Apple Fitness row truth.
- March 19-style material distance drift remains blocked until renewed evidence resolves the drift.
- Duplicate, no-plan, same-day extra, drift/guard-unknown, stale summary-only, or missing-detail workouts remain excluded from production approval scoring.

## Known Limitations

- Some older runs are summary-only because detailed HealthKit series may be unavailable.
- First-install all-history summary import, anchored deletion sync, observer delivery, and long detailed-evidence refreshes are not yet proven against large real HealthKit histories, true background delivery, cancellation, or thermal adaptation on a physical iPhone.
- FIT does not prove exact Apple Fitness UI presentation parity or private Apple smoothing/labeling rules.
- WorkoutKit plan data can be unavailable or throw and must stay optional.
- Mechanics, trends, stronger run-type claims, and interval-row analytics remain confidence-gated.

## Recent Proof

- 2026-07-06 Runs dashboard date display: Completed Runs rows now show year-inclusive dates such as `Jun 24, 2024`; `swift test --package-path RunningWorkoutAnalysisPackage` passed with 257 tests.
- 2026-07-06 local analytics cache verification: `swift test --package-path RunningWorkoutAnalysisPackage` passed, Simulator build/install/launch passed on booted iPhone 17, Analytics tab rendered the cached-summary surface without blank screen, and physical-iPhone build/install/launch passed on `AIS17PM` with `RunSignal com.adrielsolorzano.runninganalysis` confirmed by `xcrun devicectl device info apps`.
- `docs/validation/apple-fitness-interval-parity-dataset/user-supplied-june30-clean-repeat-tail-review-2026-06-30/` archives June 30 user-supplied evidence for a clean no-pause repeat fixed-cooldown/`Open / Extra` workout.
- `docs/validation/apple-fitness-interval-parity-dataset/physical-iphone-priority-repeat-proof-2026-06-28/` archives the five-priority physical proof set with Apple Fitness screenshots, typed manual rows, and Raw HealthKit Debug/Parity Lab exports.
- Health Context follow-up: verify VO2 Max and Resting Heart Rate on the physical iPhone after granting Apple Health read access.
- Best Efforts visible official segment bests use `PersonalBestEffortEngine` exact distance-window records; summary-only whole-run estimates remain excluded.
- Refresh architecture follow-up: verify monthly evidence refresh activation, scroll responsiveness, thermal behavior, and archived diagnostics/logs on the physical iPhone.

## 2026-06-30 Interval Status Agreement

- Normal detail fallback copy uses one clean `Intervals under review` state with a `View Interval Evidence` path to Raw Debug.
- Raw Debug and exports use `Official Interval Rows`, `Resolved Row Evidence`, and `Not promoted yet` labels so evidence existence and promotion status do not read as contradictory.
- Raw Debug developer controls, monthly diagnostics, and source/device metadata sit behind a collapsed `Developer tools` disclosure.

## 2026-07-01 Analytics Expansion Slice

- RunSignal has a first-pass `Analytics` tab with `Week Signal`: Monday-start weekly totals, run count, average pace, daily distance bars, purpose-category totals, and weekly workout rows from non-duplicate HealthKit runs.
- Workout detail uses Swift Charts-backed core chart cards for pace, heart rate, power, and cadence.
- Official promoted interval rows are tappable into interval detail; under-review evidence rows and raw/debug candidates remain out of product drill-down.
- Workout detail has a HealthFit-inspired `Interval Analysis` overview for official promoted interval rows: work-row aggregate metrics, per-row bars for pace, heart rate, power, cadence, duration, and distance, shared chart scrub selection, pause-aware active-timer pace, and Apple-Fitness-like row list/drill-down below it.
- Remaining proof is physical-iPhone validation with real HealthKit data for analytics, chart rendering, and one official interval drill-down.

## 2026-07-01 Repo Cleanup Slice

- README routing points new agents to `project-status.md`, `accuracy-ledger.md`, and `documentation-index.md` instead of removed `current-state.md` / `next-work.md` files.
- Removed unrouted legacy SwiftUI screens and an unused workout-series wrapper while leaving validation evidence, interval resolver logic, diagnostics exports, and raw/debug interval boundaries intact.
- `.gitignore` covers additional Xcode/test scratch outputs without broadly ignoring curated validation evidence.

## 2026-07-02 Interval Analysis v2 Slice

- Supported custom workouts now enter interval analysis through a compact official-row summary in workout detail, then a dedicated touch-first interval analysis screen.
- The dedicated screen uses one selectable Swift Charts interval bar chart, core work-repeat totals, selected-row details, and grouped Work/Recovery repeats when official resolved rows form repeat pairs.
- The slice remains display-only and official-row-only: it does not expand custom workout detection, use raw segment markers, or add FIT/HealthFit runtime input.

## 2026-07-04 Data Ingestion Hardening Slice

- Foreground HealthKit sync now processes batch results, applies deleted HealthKit workout IDs to in-memory state and SwiftData, and saves anchors only after the matching local sync save succeeds.
- Delta sync normalization is summary-only: it uses `detailedEvidenceLimit: 0` and disables per-workout route probes so foreground delta/background-ready sync does not silently load detailed evidence.
- Explicit `Load HealthKit Runs` now records a persisted HealthKit import job and walks summary history through newest-to-oldest yearly windows, with older windows summary-only and an import budget policy for elapsed time, cancellation, Low Power Mode, and thermal state.
- The app registers `HKObserverQuery` plus HealthKit background delivery for workout changes; observer work runs the lightweight summary-only anchored sync path, not detailed evidence enrichment.
- Runs pull-to-refresh now uses lightweight anchored sync when an import/cache and anchor exist; Settings remains the explicit full `Load HealthKit Runs` entry point.
- Settings import status now hides persisted resume cursor dates after pause/completion and uses user-facing pause copy instead of internal budget wording.
- Best Efforts recompute from persisted detailed evidence after relaunch without hydrating all cached evidence into the main workout list, so exact PRs loaded by `Load HealthKit Runs` survive app restart/force-quit.
- Package tests cover deleted-workout removal, multi-batch sync aggregation, anchor/sync-state preservation when injected local persistence fails, import job completion/pause state, import cursor persistence, and background observer registration.
- The HealthFit screen recording reference stays as tracked metadata/UI notes in `docs/validation/healthfit-interval-ui-reference.md`; the ignored local video copy was removed during repo cleanup to keep the workspace light.

## 2026-07-06 Local Analytics Summary Cache Slice

- Analytics period summaries now have a local SwiftData materialized-view cache (`PersistedTrainingPeriodSummary`) for Week, Month, Year, and All-Time summaries.
- The cache is rebuilt from the current local HealthKit-backed workout summaries after import, foreground/background-ready sync, and manual category changes; it stores compact aggregate totals, bucket totals, category totals, comparison values, and workout IDs rather than full workout payloads.
- `AnalyticsView` now asks `RunningAnalysisStore` for cached period starts and summaries, with the existing pure `TrainingPeriodAnalyticsSummary.make` path remaining as the fallback when a cache row is missing.
- The cache remains disposable derived state: HealthKit is still runtime truth, SwiftData workout summaries are the local cache, and detailed evidence stays manual/foreground unless a user explicitly loads full analysis.
- Package tests cover cache persistence after HealthKit import/relaunch and cache refresh after manual run-type/category edits.

## 2026-07-04 Interval Goal Vs Measured Display

- Official interval detail, Raw Debug official rows, and selected Interval Analysis rows now separate WorkoutKit goal distance/time from measured HealthKit distance/time/pace. Distance-goal rows show goal distance, measured distance, measured time, goal-normalized pace, and measured pace; time-goal and open rows stay measured-first without inventing a goal distance.

## 2026-07-05 Physical Recording Bug-Fix Pass

- Analytics manual category writes now avoid the expensive full evidence/derived-analysis recompute path, reducing freeze/crash risk on physical iPhones with large HealthKit histories.
- Workout detail now hydrates already-cached per-workout evidence on entry, so previously refreshed runs do not remain evidence-missing until the Raw Debug force re-enrich action is used.
- Workout detail now has a normal full-analysis readiness card with `Summary ready`, `Full analysis queued`, `Analyzing run`, `Full analysis ready`, `Some details unavailable`, and `Analysis failed` states, plus `Load full analysis` / `Refresh full analysis` actions for the selected run.
- Raw HealthKit Debug is now a secondary `View technical details` path from the readiness card, not the main user workflow for loading or judging detailed evidence.
- Raw Debug labels now distinguish accepted pause windows from unpaired pause fallback reasons, and Workout detail has extra bottom inset space for the floating tab bar.
- Follow-up recording review measured long black-screen spans during app relaunch/transition and confirmed manual tag taps still felt blocking; single-row Analytics tag writes now update optimistically with a short guarded delayed save and per-row saving indicator.
- Workout detail now surfaces a normal user-facing Workout Plan card from structured WorkoutKit planned rows before Workout Intervals, so users can see the prescribed plan without opening Developer Tools.
- Startup profiling follow-up moved HealthKit background-delivery registration and foreground sync out of the first-render path, skips the first duplicate `.active` scene-phase sync, and adds startup log markers around bootstrap and deferred maintenance. Simulator launch reaches Runs cleanly; physical-iPhone timing still needs a fresh device recording because Simulator uses sample data.

## 2026-07-02 Post-Recording Chart And Split Follow-Up

- Reviewed `/Users/adrielsolorzano/Downloads/ScreenRecording_07-02-2026 13-03-21_1.MP4` from the physical-iPhone app build and confirmed the visible complaints: static workout charts, raw seconds-per-km pace axis labels, capped kilometer splits, noisy Raw Debug provenance copy, and an interval workout still showing under review despite resolved boundary-row evidence.
- Workout metric charts now support shared drag/scrub selection and format pace axes as pace strings instead of raw values such as `1,500 /km`.
- Workout detail now shows all kilometer splits instead of truncating at five.
- Raw Debug no longer shows the `Direct vs Calculated` provenance block.
- Added regression coverage for the six-work-repeat fixed-cooldown plus `Open / Extra` recording shape so normal detail can promote the 15 official rows when the same evidence shape is available from HealthKit/WorkoutKit, including a terminal zero-duration `HKWorkoutEventType(rawValue: 1)` marker at workout end.

## 2026-07-02 Analytics Period Expansion

- The Analytics tab now supports Week, Month, Year, and All-Time summaries instead of week-only placeholders.
- Current Week, Month, and Year views compare against the previous period on the same elapsed-day basis: week-to-date, month-to-date, and year-to-date compare only the matching first days of the prior period.
- Period summaries keep HealthKit-only completed-run filtering, duplicate exclusion, distance, run count, average pace, evidence status, purpose mix, distance bars, and workout drill-down rows.
- Added package tests for week-to-date, month-to-date, and year-to-date comparison windows.

## 2026-07-03 Best Efforts Data-Quality Guard

- All-Time Best Efforts now reject exact segment records whose distance samples imply an impossible segment pace, preventing corrupted or bursty HealthKit distance samples from surfacing as official `Exact` rows such as a 3-second 1K.
- Added regression coverage for impossible rolling-segment evidence; affected records fall back to non-official estimated rows unless another valid exact record exists.
- Remaining follow-up: improve the user-visible HealthKit evidence refresh/backfill flow so all-time PR completeness is easier to understand after fresh installs and foreground syncs.

## 2026-07-03 Recording UI Follow-Up

- Raised contrast for run-list subtext and shared metric tile labels/details so small HealthKit metadata is easier to read on dark cards.
- Raised contrast for Runs list section headers, All-Time Best Efforts metadata/pace, Analytics Purpose Mix labels/distances, and Analytics workout row metadata/pace on physical-phone dark mode.
- Workout charts now clamp the x-axis to the actual loaded sample range and overlay subtle official interval-boundary markers when supported resolved rows are available.
- Interval Analysis now leads with a whole official-row breakdown before the work-repeat summary, keeps the work-repeat drilldown, and defaults selection to the first official row instead of Work 1.
- All-Time Best Effort rows now navigate to the source workout detail when the backing HealthKit run is loaded, so records such as longest run, 400m, 1K, mile, and 5K can be opened for full run context.

## 2026-07-03 Manual Run Categorization Slice

- Analytics period headers now show the year and expose a current-period jump button when browsing older Week, Month, or Year views.
- Analytics workout rows expose visible manual category menus and a bulk Select mode with All Visible, Before Nov 2025, Clear, category picker, and Apply actions.
- Manual category writes use existing persisted `manualRunType` fields, preserving the HealthKit-only runtime data contract while letting purpose mix and period summaries reflect reviewed labels.
- Bulk manual category Apply now writes selected rows as one store/persistence batch with one analytics recompute, avoiding all-time history freezes from per-row saves and recomputes.

## 2026-07-03 Trust-First Workout Review UX

- Runs now has a user-facing readiness card that separates sample data, HealthKit access, detailed-evidence refresh state, exact Best Efforts, and loaded completed runs before the user opens any detail screen.
- Workout detail now starts with a run-review card that answers whether the workout is sample-only, whole-run-ready, duplicate-only, or official structured-workout evidence, while keeping Raw HealthKit Debug secondary.
- Best Effort rows now use plain trust language for `Official exact`, `Official total`, `Estimate`, and `Unavailable`, including caveat explanations without promoting estimated rows as official PRs.
- Official Interval Analysis now opens with a work-rep execution summary for work count, fade, recovery rows, pause rows, and `Open / Extra` context before the chart/list drill-down.
- Added focused package tests for app readiness, Best Effort trust copy, sample-workout proof boundaries, official workout review, and interval execution summary behavior.
- Simulator proof passed on iPhone 17: Runs readiness card, Best Effort trust row copy, and Workout Detail sample-proof copy were visible and non-overlapping after the package test suite passed.
- Physical iPhone install/run succeeded on `AIS17PM` through XcodeBuildMCP after package tests and simulator smoke. Real HealthKit app-visible proof still requires checking the live phone screen because the available UI snapshot path can still target Simulator after a device run.

## 2026-07-03 Repo Hygiene Cleanup

- Removed ignored local junk: `.DS_Store` files, SwiftPM `.build`, and the large ignored HealthFit local video copy.
- Moved completed date-specific validation evidence, older physical-iPhone proof folders, screenshot archives, and nonfixture exports into `docs/archive/old-validation/` while keeping evidence tracked.
- Kept active validation focused on the interval parity router, active scripts/scorecards, the June 26 paired-pause fixed-tail proof, the June 28 priority proof, the June 30 current review packet, and the future fixture template.

## 2026-07-03 HealthKit Full History Cache Fix

- `Load HealthKit Runs` now fetches all completed running workout summaries instead of only the newest 250, so Analytics year navigation can reach older loaded history while detailed evidence remains capped/batched.
- Added regression coverage that a loaded HealthKit run persists through a relaunch-style store bootstrap and keeps All-Time Best Efforts populated from the local cache.

## 2026-07-03 HealthKit Accuracy Hardening Slice

- Workouts now expose an environment-aware capability profile so indoor runs do not treat missing route/GPS elevation as an error, while outdoor/unknown runs keep expected-vs-available evidence visible.
- Workout review now surfaces an `Expected Data` signal driven by the capability profile, separating indoor, outdoor, and unknown evidence expectations.
- Official resolved custom-workout rows prefer native `HKWorkoutActivity` duration/statistics when available and reconciled with pause evidence; sample-window aggregation remains HealthKit fallback evidence for missing activity-level stats.
- Workout-scoped quantity samples now preserve sample start/end, associated-vs-source/date fallback provenance, source revision, device, and metadata keys for future evidence-quality decisions.
- WorkoutKit planned steps now preserve typed target metadata from alerts alongside display text, enabling later target-vs-actual analysis without parsing strings.
- Shortened/skipped planned distance rows now add resolved-row diagnostics when HealthKit activity distance ends materially before the planned distance; this preserves Priority 5-style guard evidence without broadening interval analytics.
