# Data Ingestion AI Review Synthesis

Last updated: 2026-07-04

Purpose: synthesize the ChatGPT Pro, Claude, Grok, and Perplexity reviews of `docs/project-state/data-ingestion-background-reference.md` into a repo-grounded improvement plan for RunSignal's HealthKit import, sync, cache, background, thermal, and relaunch behavior.

## Inputs Reviewed

- `/Users/adrielsolorzano/Documents/chatgpt response to data ingestion.md`
- `/Users/adrielsolorzano/Documents/claude response to data ingestion.md`
- `/Users/adrielsolorzano/Documents/grok response to data ingestion.txt`
- `/Users/adrielsolorzano/Documents/perplexity response to data ingestion.md`
- `docs/project-state/data-ingestion-background-reference.md`
- Current source paths under `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/`
- Local HealthKit reference: `docs/healthkit-reference/10-background-delivery-incremental-sync.md`

## Consensus

All four model responses agree with the main repo diagnosis:

- Current architecture is not fundamentally wrong.
- SwiftData cache-first behavior is the right base.
- Detailed HealthKit evidence must stay separate from cheap workout summaries.
- Initial load avoids the worst detailed-evidence case by capping detailed evidence to the newest import window.
- The biggest remaining risks are physical-iPhone proof for large-history first import, anchored deletion/backlog behavior, observer delivery, thermal/Low Power Mode behavior, and battery impact.

The best target architecture is:

1. Restore from SwiftData first.
2. Import HealthKit summaries explicitly and durably.
3. Sync daily/new data incrementally with anchors.
4. Keep background delivery summary-only.
5. Keep detailed evidence foreground, manual, budgeted, resumable, and thermal-aware.

## Important Correction

Claude's most useful correction: do not treat `BGContinuedProcessingTask` as silent background sync.

Use cases:

- Good fit: user taps a visible long-running action such as `Refresh Month Evidence`, the app shows progress, and the system may let the task continue if the app backgrounds.
- Bad fit: silently waking the app to sync or deeply enrich workouts after the user closes it.

For RunSignal v1, the safe split is:

- `HKObserverQuery` plus `enableBackgroundDelivery`: lightweight summary delta sync only.
- `BGContinuedProcessingTask` or similar background task: only for explicit user-started long work, never automatic hidden detailed evidence refresh.
- Detailed evidence: foreground/manual by default.

## Current Repo Mapping

### Already In Good Shape

- Fresh bootstrap does not immediately query full HealthKit history. `RunningAnalysisStore.bootstrap` uses persisted workouts or sample data.
- Explicit `Load HealthKit Runs` starts the first HealthKit load.
- Initial detailed evidence is capped by `HealthKitService.defaultDetailedEvidenceLimit = 20`.
- SwiftData stores summaries, evidence, enrichment state, refresh jobs/items, and derived analysis.
- Relaunch restores persisted HealthKit runs and best efforts in tests.
- Foreground sync is gated by an existing anchor, throttled to five minutes, and single-flight.
- Monthly evidence refresh has per-workout persisted job items and marks interrupted running jobs as paused on relaunch.
- Evidence queue skips cached evidence and prioritizes recent/useful runs before old historical runs.
- Foreground sync now applies HealthKit deleted workout IDs to in-memory state and SwiftData.
- Foreground sync now saves anchors only after the matching local sync save succeeds.
- Foreground delta sync now uses summary-only normalization with `detailedEvidenceLimit: 0` and route probes disabled.
- Runs pull-to-refresh now uses lightweight anchored sync after import/cache exists.
- Initial HealthKit summary import is now a persisted newest-to-oldest date-window job with status, imported count, pause reason, and cursor state.
- The import loop has a budget policy for cancellation, elapsed time, Low Power Mode, and thermal state.
- `HKObserverQuery` plus `enableBackgroundDelivery` are registered for workout changes and call the summary-only anchored sync path.

### Still Missing

- No physical-iPhone proof yet for large anchored backlogs, HealthKit deletion delivery, or thermal behavior.
- No `BGTaskScheduler` path.
- Monthly evidence refresh and audit enrichment do not yet share the import budget policy.
- No large-history benchmark or stress test.
- No evidence blob size measurement.

## Prioritized Improvement Plan

### P0: Fix Correctness and Data-Loss Risk

1. Apply HealthKit deletions locally.

Current issue: `HealthKitWorkoutSyncService` returns `deletedWorkoutIDs`, and `RunningAnalysisStore.syncHealthKitChanges` counts them in `HealthKitSyncState`, but the inspected path only merges fetched workouts. It does not visibly remove deleted IDs from the in-memory array or SwiftData before saving sync state.

Status: implemented in the 2026-07-04 data ingestion hardening slice with package tests. Physical-iPhone proof is still pending.

Implementation direction:

- Remove deleted IDs from `workouts`.
- Delete matching persisted SwiftData records and dependent evidence/derived state that should not survive a deleted HealthKit workout.
- Apply additions/updates and deletions in one sync checkpoint.
- Add tests for 250+ deleted workouts, mixed add/delete batches, and deletion persistence.
- Verify deletion behavior on a physical iPhone by deleting a HealthKit workout in Health/Fitness and confirming RunSignal removes it after sync.

Why first:

- If background delivery is added before deletion handling, it can make stale deleted records fresher-looking and harder to detect.

2. Make sync persistence failure observable.

Current issue: anchor-after-persist is the right rule, but it is only meaningful if the store can tell whether local persistence succeeded.

Status: implemented for the sync path through a narrow throwing persistence seam and an injected-failure package test.

Implementation direction:

- Introduce a narrow throwing persistence seam for sync writes, or a combined sync persistence method that can report failure.
- Keep the blast radius small; do not refactor unrelated persistence paths unless tests require it.
- Add a test that injects local persistence failure and proves the anchor and last-sync date are not advanced.

Why first:

- Saving anchors after local writes does not protect data unless failed writes are observable.

3. Add anchored sync drain loop.

Current issue: `HealthKitWorkoutSyncService.syncRunningWorkouts` runs one `HKAnchoredObjectQuery` with limit `100`. If HealthKit has more than 100 pending changes, the current source does not prove the backlog is drained.

Status: implemented in the concrete HealthKit sync service and covered at the store level with stubbed multi-batch results. Physical-iPhone backlog proof is still pending.

Implementation direction:

- Query with current anchor and limit 100.
- Normalize summary-only and return or persist the batch.
- Continue with the returned anchor until the batch has zero added and zero deleted records or a work budget expires.
- Yield between batches.
- Add cancellation checks.

Important persistence rule:

- Save the new anchor only after the matching local workout/deletion batch is successfully persisted.

Why first:

- This is smaller than background delivery and prevents silent missed deltas when backlog exceeds one batch.

4. Move anchor saving after persistence.

Current issue: `RunningAnalysisStore.syncHealthKitChanges` saves `result.newAnchor` before merging and persisting fetched workouts.

Status: implemented for sync batches. Tests verify injected persistence failure prevents sync state advancement.

Risk:

- If persistence fails after the anchor advances, the app can believe HealthKit changes were processed when local SwiftData missed them.

Implementation direction:

- Have sync return batches with anchors.
- Merge/persist a batch.
- Save anchor after `PersistenceService.upsert` and deletion handling succeed.
- Add a test that simulates persistence failure before anchor save.

5. Split summary-only sync from evidence normalization.

Current issue: `HealthKitWorkoutMapper.normalize` defaults `detailedEvidenceLimit` to `20`. The anchored sync service calls it without an override, so foreground delta sync can still load routes/samples/WorkoutKit evidence for up to 20 changed workouts.

Status: implemented for foreground delta sync with `detailedEvidenceLimit: 0` and route probes disabled.

Implementation direction:

- Add an explicit summary-only normalization mode for first import/delta/background sync.
- Pass `detailedEvidenceLimit: 0` for delta and future observer sync.
- Consider disabling per-workout route probes in strict summary/background sync, or budget them separately, because route availability checks still issue one query per workout.
- Mark detailed evidence pending instead of loading it.

### P1: Make First Install Budgeted and Observable

6. Add an `InitialHealthKitImportJob`.

Fields:

- job ID
- status: queued, running, paused, completed, failed
- startedAt, updatedAt, completedAt
- imported count, failed count, skipped count
- current date window or cursor
- pause reason: user cancelled, backgrounded, low power, thermal, error
- last error

Implementation options:

- Date-windowed summary queries, newest first.
- Or anchored initial import with a small limit, if tests prove semantics are reliable for initial history.

Recommendation:

- Start with date-windowed summary import because it gives simple user-facing progress by period and avoids depending on anchored-query paging behavior for initial history.

7. Keep all-history summary coverage, but do not keep it opaque.

Do not regress to "latest 250" summaries. The app needs all years for Analytics and All-Time Best Efforts. The improvement is not to hide older runs; it is to make the import resumable, checkpointed, and measurable.

Minimum UI:

- importing period
- imported count
- cached count
- last successful checkpoint
- pause/resume action

Entry-point rule:

- Settings can start or resume the first summary import.
- Runs pull-to-refresh should run lightweight anchored sync after the first import/cache exists, not trigger another opaque all-history load.
- User-facing copy should avoid promising continuous background work. Prefer wording like: "RunSignal checks for new HealthKit workouts when iOS gives it time. Open the app to finish imports or detailed evidence refresh."

### P2: Add Lightweight Background Freshness

8. Add HealthKit observer/background delivery for workouts.

Scope:

- Register `HKObserverQuery` for `HKObjectType.workoutType()`.
- Enable HealthKit background delivery for workout changes.
- In the observer callback, run only a strict-budget anchored summary sync.
- Mark detailed evidence pending.
- Call the observer completion handler promptly.

Hard rule:

- Do not run `WorkoutEvidenceService.loadEvidence` from background delivery.
- Do not load routes, samples, running dynamics, or WorkoutKit plan audits in the observer callback.

Reason:

- HealthKit background delivery is opportunistic and energy-managed. It is for freshness, not heavy analytics.
- Do not implement observer/background delivery until the P0 deletion, persistence-failure, batch-drain, and summary-only sync behavior has package tests and physical-iPhone proof.

9. Add the background-delivery entitlement only when implementing observer delivery.

Current entitlements only show the base HealthKit entitlement. Add background delivery deliberately with tests/logging, not as a standalone config tweak.

### P3: Make Long Work Safe To Stop

10. Add cancellation checks to all long loops.

Targets:

- first import job loop
- anchored sync drain loop
- `refreshEvidenceForMonth`
- audit enrichment batches
- any future background continuation task

Use:

- `try Task.checkCancellation()` where functions can throw.
- `guard !Task.isCancelled else { pause job; return }` where they cannot throw.
- `await Task.yield()` after checkpointing.

11. Add thermal and Low Power Mode policy.

Policy:

- Low Power Mode: summary sync allowed, detailed evidence pauses unless user explicitly starts/resumes it.
- thermal nominal/fair: normal or smaller batch.
- thermal serious: finish current checkpoint, pause detailed evidence.
- thermal critical: stop after safest checkpoint.

Persist pause reasons so the UI can say why a refresh stopped.

12. Add evidence storage measurement.

Track:

- `PersistedWorkoutEvidence.evidenceData.count`
- route point count
- series sample count
- encode/decode time
- derived analysis recompute time
- cancellation/pause reason
- thermal/Low Power Mode state when a job pauses

Use this before choosing compression, pruning, or downsampling.

## What Not To Build Yet

- Do not add FIT, HealthFit, file import, or backend sync.
- Do not run detailed evidence enrichment automatically in the background.
- Do not treat `BGContinuedProcessingTask` as an always-on sync mechanism.
- Do not make first import "latest only"; all-time summary coverage is still required.
- Do not optimize custom interval support by loosening the current evidence gate.

## Test Plan

Focused package tests:

- Anchored sync drains 250+ added workouts across multiple 100-item batches.
- Anchored sync drains deleted workouts across multiple batches.
- Deleted HealthKit workouts are removed from in-memory state and SwiftData.
- Mixed add/update/delete sync batches apply atomically before anchor advancement.
- Anchor is not saved when local persistence fails.
- Delta/background sync uses summary-only normalization and does not load detailed evidence.
- Foreground sync still respects five-minute throttle and single-flight after drain loop changes.
- Initial import job resumes from a stored date window/cursor.
- Initial import cancellation leaves a paused job and does not duplicate summaries on resume.
- Monthly refresh cancellation leaves job/item state recoverable.
- Thermal/Low Power Mode policy pauses detailed evidence but allows summary sync.
- Evidence queue continues to skip cached evidence after cancellation/resume.

Implemented package coverage as of 2026-07-04:

- Deleted HealthKit workouts are removed from in-memory state and SwiftData.
- Multi-batch sync results are applied before reporting sync state.
- Injected local persistence failure prevents sync-state advancement and rolls back in-memory changes.

Add integration/physical proof later:

- Physical iPhone with real HealthKit history.
- Measure first import duration, memory, thermal state, and UI responsiveness.
- Measure detailed evidence refresh on a route-heavy long run.
- Verify observer delivery wakes are opportunistic and foreground sync still catches missed changes.

## Fanout Review Addendum

Five isolated reviewer agents were run after the first synthesis to look for missed issues. Consensus changes:

| Angle | Added finding | Resulting plan change |
| --- | --- | --- |
| Implementation | Deleted HealthKit workouts are detected but not applied locally. | Promote deletion application to P0 before background delivery. |
| Risk | Anchor-after-persist is incomplete while persistence failures are swallowed. | Add a throwing/testable sync persistence seam before anchor checkpointing. |
| UX | Pull-to-refresh should not trigger full all-history load after cache/import exists. | Split refresh entry points into first import vs lightweight delta sync. |
| Simpler path | Do not build observer/background delivery before measurement proves it is needed. | Defer background delivery until core sync correctness and physical-iPhone measurement pass. |
| Tests/rollout | Current sync protocol is too coarse to prove per-batch anchor checkpointing. | Introduce batch-oriented sync tests/seams before wider ingestion architecture. |

Strongest preserved objection: adding a batch/persistence seam is extra abstraction before visible product improvement. The reason to still do it is that the current risk is silent local truth drift: deleted HealthKit records can remain locally, and anchors can advance past changes that were not durably saved.

## Recommended Implementation Order

1. Physical-iPhone proof for deletion delivery, observer delivery, large anchored backlog behavior, first-import duration, and foreground sync thermal/battery behavior.
2. Apply the ingestion budget policy to monthly evidence refresh and audit enrichment.
3. Add evidence blob size and import timing instrumentation.
4. Tune first-import window size if physical measurement shows yearly windows are too large.
5. Optional explicit user-started background continuation for `Refresh Month Evidence`.

## Bottom Line

The external reports do not overturn the current direction. They sharpen it.

RunSignal should stay HealthKit-only and cache-first. The 2026-07-04 code slice hardens foreground sync correctness and adds app-side ingestion scaffolding in package tests: it applies HealthKit deletions, makes sync persistence failures observable, drains anchored sync batches, keeps delta/background sync summary-only, preserves anchors only after persistence, adds a persisted date-window import job, adds import budget policy, and registers HealthKit observer/background delivery for lightweight workout-change freshness. The next work is physical-iPhone proof, instrumentation, and extending pause/budget policy to detailed-evidence refresh paths.
