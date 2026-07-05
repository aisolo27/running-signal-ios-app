# RunSignal Data Processing And Architecture Context For External Review

Generated: 2026-07-05

Purpose: give ChatGPT Pro enough repo-grounded context to review RunSignal's data processing, HealthKit/WorkoutKit interval strategy, current bugs, and future improvement opportunities without pushing the app back toward overfitted or reverse-engineered interval logic.

## Short Product Summary

RunSignal is a native iPhone SwiftUI app for reviewing completed running workouts from Apple Health / HealthKit. It is not a coaching backend, file-import app, FIT parser product, or HealthFit clone. The current priority is evidence-grounded analysis of completed Apple Watch runs, especially Apple Watch custom workout intervals.

The app's core principle is:

> HealthKit is the runtime source of truth for completed workout data. WorkoutKit plan metadata is used only as the planned-structure source when available. Apple Fitness screenshots are sanity evidence, not the source of truth. FIT / HealthFit files are offline validation references only, not app inputs.

The user does not want the app to hard-fit individual Apple Fitness screenshots. The goal is correctness and explainability from public Apple APIs, even when Apple Fitness displays a cleaner or rounded presentation.

## Current User Concerns To Keep In Mind

1. Apple Fitness may show a fixed interval as `400 m`, while HealthKit activity stats can show measured distances like `404 m`, `409.6 m`, or `410 m`.
2. The app should not reverse-engineer Apple Fitness rows by forcing measured HealthKit data back to the planned goal.
3. The UI now separates goal vs measured fields:
   - Goal distance/time/pace from WorkoutKit planned rows.
   - Measured distance/time/pace from HealthKit activity/sample evidence.
4. Some workouts appear as evidence-missing until using Raw Debug `Force re-enrich selected workout`, which is not acceptable for normal day-to-day use.
5. Analytics manual categorization recently froze/crashed on the physical iPhone.
6. A physical screen recording showed smaller UI issues: bottom tab bar overlap, confusing Raw Debug pause wording, and month diagnostics looking like a single-day picker.
7. The user wants future recommendations to improve reliability and UX without weakening the HealthKit-only product contract.
8. The ideal first-install experience should probably be summary-first: immediately show a useful Apple-Fitness-like overview for all loaded runs, then process deeper evidence in the background or foreground queue, prioritizing newest/recent workouts first and working backward through HealthKit history.

## Repo Shape

Workspace:

- `RunningWorkoutAnalysis.xcworkspace`

Primary implementation:

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/`

Thin app shell:

- `RunningWorkoutAnalysis/`

Tests:

- `RunningWorkoutAnalysisPackage/Tests/RunningWorkoutAnalysisFeatureTests/`

Standard package validation:

```bash
swift test --package-path RunningWorkoutAnalysisPackage
```

Recent status docs:

- `docs/project-state/project-status.md`
- `docs/project-state/accuracy-ledger.md`
- `docs/project-state/data-ingestion-background-reference.md`
- `docs/bug-log.md`

## Runtime Data Contract

The runtime data contract is intentionally narrow:

- Read completed running workouts from HealthKit.
- HealthKit access is read-only.
- Use `HKWorkout`, `HKWorkoutActivity`, workout-scoped quantity samples, route series, workout events, and optional `HKWorkout.workoutPlan`.
- Use WorkoutKit planned steps only as plan structure and goals.
- Use HealthKit samples and activities as measured evidence.
- Keep HealthKit segment markers raw/debug-only.
- Do not add FIT file import, HealthFit export/import, or file-based workout ingestion unless the product direction is explicitly reversed.
- Whole-run stats remain usable even when custom interval rows are blocked.

## Main Data Flow

### Desired First-Install User Experience

The user proposed a useful target model:

1. On first install, quickly load and show the workout overview for as many HealthKit runs as possible.
2. The overview should resemble Apple Fitness's basic workout summary:
   - Workout time.
   - Distance.
   - Active calories.
   - Total calories when HealthKit provides enough evidence.
   - Average pace.
   - Average heart rate.
   - Average power when available.
   - Average cadence when available.
3. This summary-first mode should make the app immediately useful even before deep evidence is loaded.
4. In-depth processing should then run as a staged queue:
   - Latest run first.
   - Recent quality workouts next.
   - Recent long runs and likely Best Effort candidates.
   - Runs needing manual category review.
   - Older benchmarks.
   - Remaining historical runs, newest to oldest.
5. Deep processing includes detailed HealthKit samples, route points, WorkoutKit plan audit, custom interval resolution, Best Efforts exact segment windows, chart readiness, and analytics confidence upgrades.
6. The UI should make the state clear: summary ready now, detailed analysis processing, detailed evidence ready, or detail unavailable/blocked.

This model fits the current architecture because summaries and detailed evidence are already separated. The current app partially does this, but the product UX still needs refinement so users are not forced into Raw Debug actions to get normal detail screens updated.

### 1. App Bootstrap

`RunningAnalysisStore.bootstrap(modelContext:)` loads persisted SwiftData state first.

If no persisted real workouts exist:

- The app uses sample data.
- It does not immediately query the user's full HealthKit history.

If persisted real workouts exist:

- It restores saved workout summaries from SwiftData.
- It intentionally keeps the main workout list lightweight at launch.
- Detailed evidence can be hydrated later from persisted evidence or refreshed explicitly.

Important recent fix:

- Workout detail now hydrates already-cached evidence for the selected workout on entry, so a workout that has persisted detail should not remain evidence-missing until Raw Debug force-enrich is tapped.

### 2. User-Initiated HealthKit Import

The `Load HealthKit Runs` path goes through `RunningAnalysisStore.refreshFromHealthKit()`.

Current behavior:

- Creates/persists a `PersistedHealthKitImportJob`.
- Walks HealthKit running history newest-to-oldest in yearly windows.
- Loads all completed running workout summaries in those windows.
- Loads detailed evidence only for the newest import window using a bounded detailed-evidence cap.
- Persists summaries separately from detailed evidence.

Reason:

- Multi-year Apple Watch histories can be large.
- Summary import is cheaper than detailed series/route/event loading.
- Detailed evidence is expensive and should be staged, prioritized, or explicit.

Known risk:

- First-install all-history behavior still needs physical-iPhone proof for heat, battery, memory, cancellation, and long histories.

### 3. HealthKit Service And Mapping

Important files:

- `HealthKitService.swift`
- `HealthKitWorkoutMapper.swift`
- `WorkoutEvidenceService.swift`

`HealthKitService` is the entry point for HealthKit reads. It requests authorization and queries running workouts.

`HealthKitWorkoutMapper` normalizes `HKWorkout` into `CanonicalWorkout`.

`WorkoutEvidenceService` loads richer per-workout evidence:

- Quantity samples.
- Route points.
- Workout events.
- `HKWorkoutActivity` rows.
- WorkoutKit plan audit from `HKWorkout.workoutPlan` when available.

Evidence loading is the expensive path. It is richer than workout summaries and is where most detailed charts, splits, exact Best Efforts, and official interval rows get their proof.

### 4. Persistence

Important files:

- `Models.swift`
- `PersistenceService.swift`

SwiftData stores:

- `PersistedWorkout`
- `PersistedWorkoutEvidence`
- `PersistedEvidenceEnrichmentState`
- `PersistedEvidenceRefreshJob`
- `PersistedEvidenceRefreshJobItem`
- `PersistedDerivedWorkoutAnalysis`

Key design choice:

- Workout summaries and detailed evidence are persisted separately.
- Manual fields such as `manualRunType` and `notes` are preserved across HealthKit refreshes.
- Derived analytics can be cached and recomputed from persisted raw evidence.

This separation prevents every launch from needing to hydrate all sample/route/evidence payloads into the main list, but it also creates a UX challenge: normal detail screens need to hydrate selected cached evidence automatically when needed.

### 5. Foreground Sync And Background Delivery

Important files:

- `HealthKitWorkoutSyncService.swift`
- `RunningAnalysisStore.swift`

Current behavior:

- Foreground sync uses anchored HealthKit changes after an anchor exists.
- Sync is summary-only and lightweight.
- Sync applies deleted HealthKit workout IDs locally.
- Anchors are saved only after local persistence succeeds.
- Foreground sync is throttled and single-flight.
- The app registers an `HKObserverQuery` and enables HealthKit background delivery for workout changes.

Current limitation:

- There is no fully proven background refresh / BGTaskScheduler pipeline.
- Observer delivery, deletion delivery, large-history performance, and thermal behavior still need physical-iPhone validation.

### 6. Evidence Enrichment Queue

Important file:

- `EvidenceEnrichmentQueue.swift`

The queue classifies workouts as:

- Pending.
- Enriched.
- Failed.

It prioritizes:

- Latest run.
- Recent quality runs.
- Recent long runs.
- Runs needing review.
- Older benchmarks.
- Historical runs.

The intent is to avoid loading detailed evidence for every historical workout at once. The queue should make evidence loading visible and recoverable instead of hidden behind Raw Debug.

### 7. Monthly Evidence Refresh

The Raw Debug developer tools expose a monthly evidence refresh. This is currently more of an audit/developer workflow than a polished user flow.

Behavior:

- Select a date in a month.
- Refreshes loaded workouts in that month one workout at a time.
- Persists job and item state.
- Can preserve cached evidence on failure.
- Recomputes after the month refresh.

Known UX concern:

- The selector looked like `Jul 5, 2026` while the action is month-scoped, which confused the user. The label was changed from `Select month` to `Select date in month`, but a future better UX would be a true month picker or month chip.

## Custom Workout Interval Strategy

This is the most important correctness area.

### Official Row Source

Official product interval rows come from:

1. WorkoutKit planned row order and goals, when `HKWorkout.workoutPlan` is available.
2. Complete contiguous HealthKit activity-boundary rows from `HKWorkout.workoutActivities`.
3. HealthKit samples for distance, time, pace, heart rate, power, cadence, and pause/active timing.

The app should not:

- Treat raw HealthKit segment markers as Apple Fitness interval rows.
- Use FIT files as runtime truth.
- Substitute older plan/sample-derived reconstruction as product fallback rows.
- Force measured HealthKit row distance to match Apple Fitness's displayed planned goal.

### Evidence Gate

Official custom interval rows require an evidence gate:

- WorkoutKit planned rows are present and ordered.
- HealthKit activity rows are complete and contiguous.
- Activity rows map to planned rows or a completed prefix for stopped-early workouts.
- Repeat context is sufficient.
- Pause/resume events are paired and assignable within rows.
- Tail behavior is deterministic.

If the gate fails:

- The normal product UI should show whole-run stats and clear fallback reasons.
- Raw Debug can show candidate/reconstructed evidence for investigation.

### Goal Vs Measured Display

Recent user issue:

- Apple Fitness showed work intervals as 400 m.
- RunSignal/HealthKit measured rows showed values such as 404 m, 405 m, 410 m.

Current product decision:

- Preserve measured HealthKit distance/time/pace.
- Preserve WorkoutKit goal distance/time and goal-normalized pace separately.
- UI now shows goal and measured fields side by side.

Example intended display:

- Goal Distance: `400 m` from WorkoutKit.
- Measured Distance: `404 m` from HealthKit.
- Measured Time: `1:35`.
- Goal Pace: based on measured time over goal distance.
- Measured Pace: based on measured time over measured distance.

This makes it clear why Apple Fitness can appear to show a cleaner 400 m interval while HealthKit records a slightly longer measured activity.

### Pauses

Pause handling uses a state machine over HealthKit workout events:

- Explicit pause/resume.
- Motion pause/resume.
- `pauseOrResumeRequest` toggle events.

Blocked cases:

- Duplicate pause streams.
- Dangling/unpaired pause events.
- Cross-row pauses.
- Ambiguous/caveated pauses.

Recent Raw Debug UX issue:

- UI showed `Fallback: Pause/resume evidence is unpaired` and also `Pauses 0`.
- That was technically "0 accepted paired pause windows," but visually contradictory.
- Label was changed to `Accepted pauses`.

## Analytics And Derived Data

Important files:

- `DerivedAnalytics.swift`
- `AnalyticsSummary.swift`
- `AnalyticsViews.swift`
- `PersonalBestEfforts.swift`

Analytics are HealthKit-only and confidence-gated.

Current analytics include:

- Week / Month / Year / All-Time summaries.
- Period-to-date comparisons.
- Distance totals.
- Run count.
- Average pace.
- Purpose/category mix.
- Manual run categorization.
- Best Efforts / exact segment PRs.
- Workout detail charts for pace, heart rate, power, cadence.
- Official interval analysis when supported rows exist.

Pace convention:

- Canonical pace is seconds per kilometer.
- Aggregate pace should be total duration over total distance, not unweighted row averages.

Best Efforts:

- Exact segment records require trustworthy distance-series evidence.
- Summary-only whole-run estimates are not promoted as official segment bests.
- Impossible segment evidence, such as a 3-second 1K from bursty distance samples, is rejected.

Manual categorization:

- Uses `CanonicalWorkout.manualRunType`.
- Stored through `PersistenceService.updateManualFields`.
- Preserved across HealthKit refreshes.
- Recent physical-iPhone crash/freeze likely came from category taps triggering a full expensive recompute on a large real HealthKit history.
- Recent fix: manual category writes now use a lightweight recompute path without full evidence hydration or derived-analysis refresh.

## Current UI Surface

Main tabs:

- Runs.
- Analytics.
- Settings.

Key screens:

- Runs readiness card.
- Completed Runs list.
- Workout detail.
- Raw HealthKit Debug.
- Interval Analysis.
- Interval detail.
- Settings / HealthKit load.

Trust-first UX:

- The app tries to label whether data is sample-only, summary-ready, detailed-evidence-ready, official structured-workout evidence, or blocked/unavailable.
- The user wants clearer day-to-day behavior: normal screens should not require Raw Debug force-enrich to become useful when data is already cached or can be refreshed through a normal user-facing flow.

## Known Issues And Recent Fixes

### Recently fixed or partially fixed

1. Analytics category crash/freeze risk:
   - Cause: manual category tap triggered expensive full evidence/derived recompute.
   - Fix: manual category writes now use lightweight recompute.

2. Evidence appears missing until Debug force-enrich:
   - Cause: bootstrap intentionally keeps main list lightweight and did not hydrate selected cached evidence into workout detail.
   - Fix: workout detail now hydrates persisted cached evidence for the selected workout on entry.
   - Still open: if no persisted detail exists, the app needs a better normal user-facing refresh path.

3. Raw Debug pause wording:
   - Changed from `Pauses` to `Accepted pauses`.

4. Bottom tab overlap:
   - Workout detail got extra bottom inset.
   - Other long screens may still need review.

5. Monthly diagnostics label:
   - Changed to `Select date in month`.
   - Better future design: true month selector.

### Still open / worth reviewing

1. First-install full-history import proof:
   - Need physical-iPhone thermal/battery/memory/timing evidence with a large history.

2. Normal evidence refresh UX:
   - Raw Debug force-enrich should not be the main way a normal user gets charts/route/interval evidence.
   - Need a clearer "refresh details for this run" or "refresh recent evidence" product path.

3. Background delivery:
   - Observer query and background delivery are registered, but real delivery and behavior after app kill/relaunch need proof.

4. Custom interval blocked reasons:
   - Must stay clear and user-readable.
   - Avoid contradictory states like "structured official" on one surface and "under review" on another.

5. Performance:
   - Avoid heavy work in SwiftUI body paths.
   - Avoid per-row persistence/recompute loops on large histories.
   - Avoid hydrating every persisted evidence payload into the main list by default.

6. UI polish:
   - Bottom tab overlap across Raw Debug, Analytics, Interval Analysis, Interval Detail.
   - Large navigation title collapse artifacts.
   - Chart axis label density/clipping.
   - More readable month refresh controls.

## Validation Status

Recent package validation:

- `swift test --package-path RunningWorkoutAnalysisPackage`
- 251 tests passed after the latest bug-fix pass.

Recent simulator smoke:

- XcodeBuildMCP simulator build/run succeeded on iPhone 17.
- Runtime UI snapshot showed the app live on Runs with sample data.

Physical-iPhone validation:

- Prior installs and launches on device `AIS17PM` succeeded.
- The latest bug-fix patch has not yet been physically verified at the time this report was generated.
- Real HealthKit behavior must be judged on the physical iPhone, not Simulator sample data.

## Things ChatGPT Pro Should Not Recommend Unless The Product Direction Changes

Please do not recommend:

- FIT import as runtime app input.
- HealthFit import/export as runtime source of truth.
- Screenshot-based hard fitting to Apple Fitness rows.
- Treating HealthKit segment markers as Apple Fitness interval rows.
- Replacing measured HealthKit activity distances with planned WorkoutKit distances.
- Broad interval promotion when evidence gates fail.
- Heavy all-history detailed evidence loading on app launch.
- Full recompute or evidence hydration from every small UI interaction.
- Confident coaching/training-load/VDOT claims before the truth layer is stable.

## Useful Review Questions For ChatGPT Pro

1. Given this HealthKit-only contract, what is the best UX for staged evidence loading so a normal user does not need Raw Debug force-enrich?
2. How should the app communicate "summary loaded" vs "detailed evidence cached" vs "detail refresh needed" without overwhelming the user?
3. Is the current goal-vs-measured interval display conceptually correct for Apple Watch custom workouts where Apple Fitness shows planned 400 m rows but HealthKit records measured activity distances over 400 m?
4. What should a safe physical-iPhone validation plan look like for first-install import, foreground sync, monthly refresh, and app relaunch?
5. How should the app prioritize detailed evidence refresh across latest run, quality workouts, long runs, best-effort candidates, and historical runs?
6. What user-facing copy would make unsupported custom intervals clear without sounding like the app is broken?
7. What performance pitfalls should be audited in a SwiftUI + SwiftData + HealthKit app with 600+ completed running workouts?
8. Should the app provide a visible "Refresh details for this run" button in normal workout detail, and if so, where should it sit relative to Raw Debug?
9. How should manual run categorization be designed so it stays fast on large histories and avoids accidental recompute storms?
10. What additional regression tests would best protect against future interval overfitting?
11. Is the proposed first-install model correct: show summary overview for all runs quickly, then process detailed custom analytics in a prioritized queue from newest to oldest?
12. What should the queue prioritization formula be if the app wants recent runs, intervals/races, long runs, Best Effort candidates, and unknown/unreviewed runs to feel useful quickly?

## Suggested Response Format For ChatGPT Pro

Please respond with:

1. Architecture risks, ordered by severity.
2. Data-loading recommendations that preserve the HealthKit-only contract.
3. Interval correctness recommendations that avoid Apple Fitness screenshot overfitting.
4. UX improvements for evidence states and refresh actions.
5. Performance improvements for large real HealthKit histories.
6. Physical-device validation plan.
7. Test coverage recommendations.

Assume the app should remain a native iPhone app, HealthKit read-only, and no backend/file-import runtime source should be added.
