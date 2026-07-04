# RunSignal Data Ingestion and Background Work Reference

Last updated: 2026-07-04

Purpose: repo-grounded reference packet for reviewing how RunSignal reads, caches, syncs, enriches, and resumes HealthKit running-workout data on-device. This is intended to be safe to send to another AI or reviewer that cannot inspect the repository directly.

## Review Question

When a user installs RunSignal on an iPhone with years of running history, does the app read HealthKit data in a way that avoids excessive heat, battery drain, and lost work across tab switches, backgrounding, app relaunches, or swipe-up termination?

Short answer: the current app now has a stronger foreground/manual persistence model plus lightweight HealthKit freshness scaffolding. It restores SwiftData first, imports HealthKit running-workout summaries through a persisted newest-to-oldest date-window job, limits detailed evidence to the newest import window, persists summaries and detailed evidence separately, supports incremental anchored sync after an anchor exists, applies HealthKit deletions locally, drains anchored batches, saves anchors only after local persistence succeeds, registers an `HKObserverQuery`, and enables HealthKit background delivery for workout changes. It still does not schedule `BGTaskScheduler` work or prove multi-year first-install performance, observer delivery, deletion delivery, thermal behavior, or battery impact on a physical iPhone with a large real HealthKit history.

## Runtime Data Contract

- Runtime source of truth is read-only HealthKit completed running workouts.
- Product data source is not FIT, HealthFit, a backend, or imported files.
- Whole-run summaries can be useful without detailed series evidence.
- Detailed workout evidence is expensive and is intentionally separate from summary metadata.
- Custom interval rows require evidence-gated WorkoutKit plus HealthKit activity/sample proof; summary-only older runs remain limited.

## Current App Flow

### First Launch Before HealthKit

`ContentView` creates one `RunningAnalysisStore`, bootstraps it with SwiftData, then attempts a foreground sync if eligible.

Source evidence:

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/ContentView.swift:32-40`
  - `.task { await store.bootstrap(modelContext: modelContext); await store.syncHealthKitChangesOnForeground() }`
  - `.onChange(of: scenePhase)` only runs sync when the phase becomes `.active`.
  - Proves: startup and foreground return are handled through SwiftUI lifecycle.
  - Does not prove: execution continues after the app is suspended, killed, or swiped away.

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/RunningAnalysisStore.swift:263-278`
  - Bootstrap fetches persisted workouts. If none exist, it installs sample workouts and tells the user to load HealthKit.
  - Proves: a fresh install does not immediately query the user's full HealthKit history during bootstrap.
  - Does not prove: explicit `Load HealthKit Runs` is lightweight for very large histories.

### User Taps Load HealthKit Runs

The Settings button starts `store.refreshFromHealthKit()`.

Source evidence:

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/Views.swift:131-138`
  - Button label is `Load HealthKit Runs`; it is disabled while `store.isLoading`.
  - Proves: full HealthKit load is user-initiated from Settings and guarded against double taps by `isLoading`.
  - Current behavior: the load is recorded as a `PersistedHealthKitImportJob` and processed in newest-to-oldest yearly windows.
  - Does not prove: physical-iPhone duration, memory, cancellation behavior, or real thermal throttling.

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/HealthKitService.swift:40-57`
  - `loadRunningWorkouts()` requests authorization, calls the running-workout query path, loads health context, and normalizes with `detailedEvidenceLimit: Self.defaultDetailedEvidenceLimit`.
  - Proves: HealthKit loads request authorization and use a detailed-evidence cap.
  - Does not prove: every yearly summary window is cheap enough on real large histories.

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/HealthKitService.swift:106-115`
  - The running-workout summary query can be scoped by start/end dates and uses `HKSampleQuery` sorted newest first.
  - Proves: current explicit load can fetch all historical summaries through date windows instead of one all-years query.
  - Risk: each yearly window still uses `HKObjectQueryNoLimit` inside that date range.

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/HealthKitService.swift:22`
  - `defaultDetailedEvidenceLimit = 20`.
  - Proves: expensive detailed series/route evidence is capped for the initial normalization pass.
  - Does not prove: summary normalization itself is cheap enough on old devices.

### Summary Versus Detailed Evidence

`HealthKitWorkoutMapper` normalizes all fetched workouts but only asks `WorkoutEvidenceService` to load detailed evidence for the newest capped set.

Source evidence:

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/HealthKitWorkoutMapper.swift:5-13`
  - `detailWorkoutIDs = Set(workouts.prefix(detailedEvidenceLimit).map(\.uuid))`.
  - For workouts outside that set, evidence is an empty `WorkoutEvidence(workoutID:)`.
  - Proves: first full load avoids pulling route and sample series for every historical run.
  - Does not prove: route existence checks and workout statistics for every summary are cost-free.

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/WorkoutEvidenceService.swift:19-74`
  - Loading detailed evidence starts multiple async queries for heart rate, speed, distance, energy, power, cadence, steps, running dynamics, route points, events, activities, and WorkoutKit plan audit.
  - Proves: detailed evidence is the expensive path and is richer than workout summaries.
  - Risk: month refresh and audit batch operations can still perform many per-workout HealthKit queries while the app is foregrounded.

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/WorkoutEvidenceService.swift:141-152`
  - Quantity series queries use `HKObjectQueryNoLimit` for samples within a workout or fallback date/source window.
  - Proves: detailed evidence asks for complete sample series for selected workouts.
  - Risk: selected long runs can still have large sample payloads.

### Persistence and Relaunch Behavior

The app uses SwiftData for summaries, detailed evidence, enrichment states, refresh jobs, refresh items, and derived analytics.

Source evidence:

- `RunningWorkoutAnalysis/RunningWorkoutAnalysisApp.swift:21-28`
  - SwiftData model container includes `PersistedWorkout`, `PersistedWorkoutEvidence`, `PersistedEvidenceEnrichmentState`, `PersistedEvidenceRefreshJob`, `PersistedEvidenceRefreshJobItem`, and `PersistedDerivedWorkoutAnalysis`.
  - Proves: persisted state is first-class app storage, not only in-memory cache.

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/PersistenceService.swift:6-12`
  - `fetchWorkouts` reads persisted summaries sorted newest first.
  - Proves: relaunch can restore loaded runs without querying HealthKit first.

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/PersistenceService.swift:17-59`
  - `upsert` preserves manual fields, stores workout summaries, stores detailed evidence separately when available, and refreshes derived analysis for evidence-backed workouts.
  - Proves: HealthKit data and user review fields are merged rather than blindly replaced.
  - Does not prove: write batches are optimized for thousands of records.

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/Models.swift:820-849`
  - `PersistedWorkoutEvidence` stores JSON-encoded `WorkoutEvidence` with counts and `loadedAt`.
  - Proves: expensive evidence can survive relaunch and does not need to be re-read each time.
  - Risk: evidence blobs could become large for route-heavy or sample-heavy runs; storage growth needs measurement.

Test evidence:

- `RunningWorkoutAnalysisPackage/Tests/RunningWorkoutAnalysisFeatureTests/RunningWorkoutAnalysisFeatureTests.swift:518-549`
  - `storeRestoresPersistedHealthKitRunsAndBestEffortsAfterRelaunch` loads a HealthKit run, persists it, creates a new store, bootstraps from the same context, and verifies the old run and all-time best effort survive.
  - Proves: basic relaunch-style persistence works.
  - Does not prove: thousands of workouts, app termination during a SwiftData save, or real HealthKit query interruption.

### Foreground Incremental Sync

After an anchor exists, foreground returns can run an anchored HealthKit sync.

Source evidence:

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/RunningAnalysisStore.swift:258-260`
  - `shouldSyncHealthKitOnForeground` requires a stored anchor and either real data, HealthKit authorization, partial authorization, or a prior sync date.
  - Proves: foreground sync is gated and skipped for sample-only first launch.

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/HealthKitWorkoutSyncService.swift:60-107`
  - Uses `HKAnchoredObjectQuery` with `defaultSyncBatchLimit = 100`.
  - Proves: incremental foreground sync exists and is bounded to 100 changes per query.
  - Risk: if HealthKit has more than 100 pending changes, current code should be reviewed for whether it loops until drained; this file shows one anchored query per sync call.

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/HealthKitWorkoutSyncService.swift:128-165`
  - `HealthKitSyncStateStore` persists the `HKQueryAnchor` and last sync date in `UserDefaults`.
  - Proves: incremental sync can continue from an anchor across launches.

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/RunningAnalysisStore.swift:354-417`
  - `syncHealthKitChanges` processes sync batches, applies fetched workouts and deleted IDs, saves local SwiftData changes before saving the matching anchor, refreshes queue summary, recomputes analytics, and foreground sync is throttled to five minutes and single-flight.
  - Proves: foreground sync avoids repeated rapid sync loops while the user switches tabs/backgrounds and returns, and unit tests cover deleted-workout removal, multi-batch aggregation, and anchor preservation on injected persistence failure.
  - Does not prove: background delivery, observer-triggered sync, physical-iPhone deletion delivery, or real large-history performance.

Test evidence:

- `RunningWorkoutAnalysisPackage/Tests/RunningWorkoutAnalysisFeatureTests/RunningWorkoutAnalysisFeatureTests.swift:1191-1217`
  - `foregroundHealthKitSyncIsThrottledAfterFirstRun` verifies calls at 0s, +120s, and +301s produce only two sync calls.
  - Proves: five-minute throttle exists.

- `RunningWorkoutAnalysisPackage/Tests/RunningWorkoutAnalysisFeatureTests/RunningWorkoutAnalysisFeatureTests.swift:1220-1247`
  - `foregroundHealthKitSyncIsSingleFlight` verifies concurrent foreground sync attempts collapse to one in-flight sync.
  - Proves: basic duplicate foreground sync protection exists.

### Manual Detailed Evidence Backfill

There are two main detailed-evidence backfill paths:

1. HealthKit Audit: enrich next pending runs in bounded batches.
2. Monthly diagnostics: refresh evidence for all loaded runs in a selected month with persisted job/item state.

Source evidence:

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/EvidenceEnrichmentQueue.swift:85-134`
  - Queue excludes duplicates/sample workouts, marks cached evidence as enriched, surfaces failed attempts, and returns only `.pending` IDs up to the requested limit.
  - Proves: audit enrichment does not repeatedly reread cached evidence and can run bounded batches.

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/EvidenceEnrichmentQueue.swift:146-181`
  - Priority order is latest run, recent quality, recent long run, needs review, older benchmark, historical; sort then uses newest first.
  - Proves: the app intentionally prioritizes useful/recent runs before deep history.

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/Views.swift:455-493`
  - HealthKit Audit shows pending/failed counts and has an `Enrich next pending runs` button.
  - Proves: detailed backfill is foreground/manual, not automatic all-history background work.

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/RunningAnalysisStore.swift:420-450`
  - `enrichNextHealthKitAuditBatch(limit: HealthKitService.defaultDetailedEvidenceLimit)` enriches only the next queue candidates, marks returned IDs as enriched, missing IDs as failed, and recomputes.
  - Proves: default audit backfill batch is 20 workouts.

Test evidence:

- `RunningWorkoutAnalysisPackage/Tests/RunningWorkoutAnalysisFeatureTests/RunningWorkoutAnalysisFeatureTests.swift:688-728`
  - `evidenceQueuePrioritizesPendingWorkoutsWithoutFullHistoryQueries` verifies latest, quality, and long-run priority with a limit of 3.
  - Proves: queue ordering is deterministic.

- `RunningWorkoutAnalysisPackage/Tests/RunningWorkoutAnalysisFeatureTests/RunningWorkoutAnalysisFeatureTests.swift:732-780`
  - `evidenceQueueSkipsCachedEvidenceAndSurfacesFailedState` verifies cached evidence is skipped, failed state is surfaced, and only pending IDs are returned.
  - Proves: cached/failed/pending states are respected.

### Monthly Evidence Refresh and Interruption Recovery

Monthly refresh loops through the selected month one workout at a time, persists a job/item record, saves successful evidence, marks failed/skipped items, yields between items, and recomputes once at the end.

Source evidence:

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/RunningAnalysisStore.swift:512-670`
  - `refreshEvidenceForMonth` filters loaded workouts to one month, starts a persisted job, marks each item running, calls `enrichRunningWorkouts(ids: [workout.id])`, commits successful evidence, marks item result, calls `await Task.yield()` between workouts, then recomputes and finishes the job.
  - Proves: the month refresh is checkpointed per workout and avoids one giant all-history detailed refresh.
  - Does not prove: cancellation is checked, background execution continues, or thermal state is respected.

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/PersistenceService.swift:255-299`
  - `startEvidenceRefreshJob` deduplicates active jobs for the same scope, marks them running, and creates missing job items.
  - Proves: retries/resumes reuse durable job state instead of creating unbounded duplicate jobs.

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/PersistenceService.swift:313-371`
  - Each item records success/failed/skipped status, whether old evidence was preserved, whether new evidence was committed, and final job status.
  - Proves: a failed refresh does not necessarily imply old cached evidence was destroyed.

- `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/PersistenceService.swift:375-389`
  - On bootstrap, running jobs are marked paused with "Paused after app relaunch before completion."
  - Proves: swipe-up/kill/relaunch does not lose the fact that work was interrupted.
  - Does not prove: the app continues working while killed. It explicitly converts running work to paused state on next launch.

Test evidence:

- `RunningWorkoutAnalysisPackage/Tests/RunningWorkoutAnalysisFeatureTests/RunningWorkoutAnalysisFeatureTests.swift:1088-1123`
  - A running monthly job is persisted, a new store bootstraps, and the job becomes paused with recoverable interruption proof.
  - Proves: interrupted job metadata survives relaunch.

- `RunningWorkoutAnalysisPackage/Tests/RunningWorkoutAnalysisFeatureTests/RunningWorkoutAnalysisFeatureTests.swift:1387-1465`
  - Monthly evidence refresh persists item checkpoints, records one success and one failure, and exposes a recoverable failed summary.
  - Proves: per-item outcome tracking exists.

## What Happens In User Scenarios

### User switches tabs while a refresh runs

The store lives above the tabs in `ContentView`, so tab switching does not recreate the store. A foreground `Task` launched by a button can continue while the app remains active. The UI uses `isLoading` and `isEnrichingAudit` to disable duplicate work.

Risk: SwiftUI view/task lifetime should be stress-tested for navigation away from the initiating view, especially for long monthly refreshes. The code does not show an explicit long-lived background worker actor independent of view-launched `Task { ... }`.

### User backgrounds the app and opens another app

The app syncs when it becomes active again. It does not currently show a `didEnterBackground` handler, background task assertion, BGTaskScheduler registration, HealthKit observer query, or HealthKit background delivery registration.

Expected current behavior: iOS may suspend in-flight foreground tasks. On next launch/active phase, foreground anchored sync can run if an anchor exists; interrupted monthly refresh jobs are marked paused on bootstrap and can be resumed manually.

### User swipes up/kills the app

No work continues after force-quit. Persisted summaries/evidence already saved should remain in SwiftData. If a monthly refresh job was marked running before termination, bootstrap changes it to paused and the UI can offer resume/retry. This is recoverable state, not true background continuation.

### User has 10+ years of workouts

Current strengths:

- First HealthKit load fetches all summary workouts through persisted yearly windows so old runs are not silently excluded.
- Detailed evidence is capped to the newest import window; older windows are summary-only.
- Historical detailed evidence is backfilled manually and prioritized.
- Cached evidence is skipped.
- Summaries and best efforts persist across relaunch.

Current risks:

- Summary import is date-windowed, but high-volume years can still be large.
- Older import windows disable detailed evidence and route probes; the newest window can still load detailed evidence for up to `HealthKitService.defaultDetailedEvidenceLimit`.
- No large-history benchmark test is present in the inspected tests.
- Incremental sync uses a batch limit of 100 and now has a batch loop in the foreground sync service, with unit coverage through stubbed multi-batch results.
- Detailed evidence queries use no per-query sample limit for selected workouts.
- Initial import has a cancellation/thermal/Low Power Mode budget policy; monthly evidence refresh and audit enrichment still need equivalent pause policy.

## Background/Incremental Sync Gap Against Local HealthKit Reference

Existing local reference `docs/healthkit-reference/10-background-delivery-incremental-sync.md` recommends:

- initial historical import,
- saved anchors per type,
- observer queries,
- HealthKit background delivery,
- anchored queries on notification,
- durable sync metadata,
- no expensive full-history query on every launch.

Current repo alignment:

- Has initial historical import.
- Initial historical import is now a persisted newest-to-oldest date-window job with status, imported count, pause reason, and cursor state.
- Has saved workout anchor and last sync date.
- Has anchored foreground workout sync.
- Drains anchored sync batches and checkpoints each returned anchor only after local persistence succeeds.
- Has `HKObserverQuery` registration and `enableBackgroundDelivery` for workout changes.
- Avoids full-history query on every launch by bootstrapping from SwiftData and syncing only if an anchor exists.

Current missing/not found by source search:

- No `BGTaskScheduler`.
- No `UIApplication.didEnterBackground` work handoff.
- No automatic background detailed-evidence refresh.
- Monthly evidence refresh and audit enrichment still need the import budget policy.
- No physical-iPhone proof yet that HealthKit deletion delivery behaves the same as the stubbed package tests.
- No physical-iPhone proof yet for large anchored backlogs or real thermal behavior.

## Recommendations To Ask Reviewers About

1. First-install import strategy
   - Should `queryRunningWorkouts()` be paged or date-windowed instead of `HKObjectQueryNoLimit`?
   - Should first install load only summary metadata for all years, then schedule/prioritize detailed backfill?
   - What progress UI should exist for users with 500, 1,000, or 2,000+ runs?

2. Incremental sync drain
   - Should HealthKit deletions remove local workouts and persisted SwiftData records in the same checkpoint as fetched additions/updates?
   - Should persistence writes throw or otherwise report failure before advancing anchors?
   - Should anchored sync loop until no more changes are returned, while yielding and respecting a per-run budget?
   - Should delta/background sync use a summary-only mapper path with `detailedEvidenceLimit: 0` and optional route probes disabled?
   - How should anchor invalidation or partial authorization be handled without losing cached data?

3. Background delivery
   - Should RunSignal add `HKObserverQuery` plus `enableBackgroundDelivery` for workout changes?
   - If yes, what is the minimum safe background work: update summaries only, defer detailed evidence, and finish quickly?
   - Should `BGTaskScheduler` be used for deferred non-urgent enrichment, or is foreground/manual refresh more appropriate for v1?

4. Cancellation and thermal behavior
   - Add cancellation checks between workouts and before expensive per-workout query groups.
   - Use `ProcessInfo.processInfo.thermalState` or a simple budget policy to pause detailed refresh.
   - Persist paused reason as user-visible state.

5. Detailed evidence storage growth
   - Measure average/maximum `PersistedWorkoutEvidence.evidenceData` size for short, long, route-heavy, and custom interval workouts.
   - Consider compression, pruning, or storing only derived summaries for old low-priority runs if raw evidence grows too large.

6. Large-history test matrix
   - Synthetic SwiftData test with 1,000+ summaries and mixed cached/pending evidence.
   - Stub HealthKit service test for initial load result with 1,000 summaries and only 20 detailed evidence records.
   - Foreground sync backlog test with more than 100 changes.
   - Monthly refresh interruption test with many items and cancellation/relaunch checkpoints.
   - UI/performance smoke on physical iPhone with real HealthKit history.

## Suggested Improvement Shape

Preferred direction for v1 hardening:

1. Keep first install explicit behind `Load HealthKit Runs`.
2. Keep all-history summaries, but make the summary import budgeted and observable:
   - record started/finished/imported counts,
   - avoid repeated full query after anchor exists,
   - show progress/readiness copy.
3. Harden foreground sync before adding background delivery:
   - apply HealthKit deletions locally,
   - make sync persistence failure observable,
   - persist anchors only after local save,
   - drain anchored changes beyond one 100-item batch,
   - make delta sync truly summary-only.
4. Keep detailed evidence foreground/manual by default.
5. Add cancellation and pause semantics to all long refresh loops.
6. Add HealthKit observer/background delivery only for lightweight summary sync, not full detailed evidence refresh.
7. Add tests for large summary arrays, >100 anchored changes, deleted HealthKit records, anchor persistence failure, and interrupted month refresh across relaunch.

## External Reviewer Prompt

Use this with another AI/reviewer:

```text
You are reviewing a native iPhone SwiftUI app called RunSignal. It reads completed running workouts from read-only HealthKit and stores local SwiftData summaries/evidence. Please review the repo-grounded behavior below for first-install import, large HealthKit histories, foreground/background execution, battery/thermal risk, and relaunch recovery.

Key facts:
- Fresh bootstrap uses sample data unless persisted workouts already exist.
- User taps "Load HealthKit Runs" to run the first full HealthKit load.
- First full load imports all running HKWorkout summaries through persisted newest-to-oldest date windows.
- Initial detailed evidence is capped to the newest import window; older windows are summary-only.
- Detailed evidence pulls full per-workout sample/route/event/activity evidence and is stored separately.
- SwiftData persists summaries, evidence blobs, enrichment states, refresh jobs/items, HealthKit import job state, and derived analytics.
- Foreground incremental sync uses HKAnchoredObjectQuery with batch limit 100 after an anchor exists and drains multiple batches.
- Foreground sync is throttled to five minutes and single-flight.
- Sync applies HealthKit deletions and advances anchors only after local persistence succeeds.
- HKObserverQuery and enableBackgroundDelivery are registered for lightweight workout-change freshness.
- Monthly detailed refresh is manual, one month at a time, checkpointed per workout, and interrupted running jobs become paused on relaunch.
- No BGTaskScheduler or didEnterBackground handoff is implemented. Physical-iPhone proof is still needed for observer delivery, large histories, deletion delivery, thermal behavior, and battery impact.

Please identify:
1. Highest-risk battery/thermal/performance paths for users with 10+ years of running data.
2. Whether the current yearly first-import windows are small enough or need smaller paging.
3. Whether anchored sync needs a tighter per-activation budget beyond the current batch drain loop.
4. Whether the current observer/background-delivery path is minimal enough for v1.
5. Specific tests and instrumentation needed before shipping this to real users.
```
