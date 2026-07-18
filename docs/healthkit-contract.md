# HealthKit And WorkoutKit Contract

Last updated: 2026-07-17

This is the compact implementation reference for RunSignal's Apple Health integration. Current product status remains in `docs/project-state/project-status.md`.

## Runtime Authority

- HealthKit is read-only runtime truth for completed running workouts.
- `HKWorkout.workoutPlan` is optional WorkoutKit planned structure.
- `HKWorkout.statistics(for:)`, associated quantity samples, routes, events, and workout activities provide completed evidence.
- FIT, HealthFit, screenshots, and manual rows are offline validation only.
- HealthKit event markers are raw/debug evidence, not Apple Fitness interval rows.

## Main Pipeline

1. `HealthKitService` requests read authorization and queries completed running `HKWorkout` samples.
2. `HealthKitWorkoutMapper` converts them into `CanonicalWorkout` summaries.
3. `WorkoutEvidenceService` loads bounded workout-scoped quantity samples, routes, events, activities, and optional plan audits.
4. SwiftData stores lightweight workout summaries and separate detailed-evidence/derived projections.
5. `CustomWorkoutResolvedIntervalRows` maps expanded planned rows to complete contiguous HealthKit activity rows when the evidence gate passes.
6. Analytics, Best Efforts, charts, interval views, and exports consume canonical workouts and evidence-gated rows.

## Authorization And Queries

- Request read access only. HealthKit does not reveal whether every individual read type was granted; report request completion and observed data availability separately.
- Production first launch starts empty and explains the read-only, on-device use before presenting Apple's authorization sheet. Sample workouts remain test/debug fixtures and are never inserted into a user's run history.
- Full user-requested history uses an unbounded workout summary query, processed in resumable windows.
- Detailed evidence remains bounded and explicit because per-workout quantity/route/activity queries are expensive.
- Best Efforts history verification has its own resumable distance-sample path. It checks every eligible run without turning the broader full-evidence queue into an unbounded import.
- Prefer samples associated with the workout. Source/date fallback is weaker evidence and must retain provenance.
- Route query callbacks can be concurrent; collection must be thread-safe.
- Simulator data is sample-only and cannot prove real permissions or workout availability.

Requested data includes workouts, routes, walking/running distance, heart rate, running speed, running power, step count/cadence, stride length, vertical oscillation, ground contact time, active/basal energy, VO2 Max, and resting heart rate when available.

## Incremental And Background Work

- Anchored sync applies additions and deletions locally before saving the matching anchor.
- `HKObserverQuery` wakes a lightweight summary-only sync path.
- Foreground and observer sync share a single in-flight task.
- First render must not wait on observer registration, background delivery, broad history, or detailed evidence hydration.
- `Connect Apple Health`, `Continue History Import`, and `Refresh Apple Health` expose the current action instead of one ambiguous load command.
- Authorization time does not consume the history-import work budget. An ordinary elapsed slice yields and continues with a fresh budget; cancellation, Low Power Mode, and serious thermal state remain explicit pause reasons.
- Detailed evidence/backfill obeys cancellation, elapsed-time, Low Power Mode, and thermal budgets.
- Derived caches are disposable projections; HealthKit-backed workout records remain truth.

## Custom Workout Rows

The product resolver requires:

- Ordered expanded WorkoutKit planned rows.
- Complete contiguous HealthKit activity rows, or a valid completed planned prefix.
- Complete repeat context for mapped rows.
- Reliable paired pauses contained within one row.
- Deterministic tail status.

Native `HKWorkoutActivity.duration` and activity statistics are preferred when positive, contained, and consistent with pause evidence. Associated sample-window aggregation is the fallback. Paused active duration equals elapsed activity-window duration minus reliable paired pause overlap.

Missing or conflicting evidence yields whole-run-only behavior. Plan/sample reconstruction and raw event candidates remain diagnostic and cannot replace blocked product rows.

## Normal Kilometer Splits

Normal splits are a separate derived product and never loosen the custom-workout row gate.

- Canonicalize detailed distance samples before split use: order and deduplicate them, reject invalid or materially overlapping windows, retain provenance, and require the detailed total to reconcile to the workout summary.
- Prefer a complete validated `lap` chain. Normalize documented legacy zero-duration lap events from the prior boundary before evaluating the chain.
- A `segment` chain is a calibrated legacy Watch heuristic, not a generic Apple Fitness interval contract. It must span the distance evidence, have the exact kilometer-plus-partial row count, distance-validate, and be unique at displayed one-second precision.
- Split duration uses the reliable pause-event family whose total reconciles to `elapsedSeconds - durationSeconds`. Boundary dates remain elapsed timestamps, while displayed time and pace use pause-adjusted active time.
- When no boundary chain passes, interpolate crossings across each distance sample's real start/end window on that active-time clock.
- Summary-only evidence never creates repeated average-based kilometer rows. Show the whole-run summary and an explicit splits-unavailable reason instead.
- Route points remain a diagnostic cross-check until a source-stratified physical corpus proves a safe route fallback.

## Metric Rules

- Canonical pace is seconds per kilometer; aggregate pace is total duration divided by total distance.
- HealthKit distance quantity samples are interval contributions, not odometer readings. Respect each sample's start/end window.
- Fixed-distance product rows can present prescribed distance while keeping measured activity values for validation and aggregates.
- Time/open rows remain measured-first.
- Shortened/skipped rows use measured distance and pause-adjusted active time.
- Cadence is displayed as full steps per minute.
- Elevation gain filters inaccurate route points and isolated altitude spikes.
- Best Efforts require credible exact distance-series evidence. Summary-only estimates are never displayed in Best Efforts, restored from its cache, or merged back into its records.
- While distance-only history verification is incomplete, the UI says `Verified Best Efforts` and reports checked/pending coverage. `All-Time Records` is reserved for complete imported and checked history.
- Missing data lowers confidence or produces unavailable states; it must not be synthesized into certainty.

## Source Map

- Authorization/loading: `HealthKitService.swift`, `HealthKitPermissionCatalog.swift`, `HealthKitWorkoutMapper.swift`.
- Incremental sync: `HealthKitWorkoutSyncService.swift`.
- Evidence queries: `WorkoutEvidence.swift`, `WorkoutEvidenceService.swift`, `EvidenceEnrichmentQueue.swift`.
- Plans/resolution: `CustomWorkoutStepModel.swift`, `CustomWorkoutResolvedIntervalRows.swift`, `WorkoutIntervalReconstruction.swift`.
- Persistence/cache: `PersistenceService.swift`, `RunningAnalysisStore.swift`, `IngestionBudgetPolicy.swift`.
- Analytics: `DerivedAnalytics.swift`, `AnalyticsSummary.swift`, `IntervalProductAnalytics.swift`.
- Diagnostics: `DiagnosticsExport.swift`.

## Verification Boundary

- Package tests prove deterministic mapping, math, persistence, and fallback behavior.
- Simulator proves build, launch, and sample-data UI behavior.
- Physical iPhone proves real HealthKit permissions/data, WorkoutKit plans, background delivery, large-history performance, thermal behavior, battery impact, and Apple Fitness comparison.

## Apple References

- [HealthKit](https://developer.apple.com/documentation/healthkit)
- [HKWorkout](https://developer.apple.com/documentation/healthkit/hkworkout)
- [HKWorkoutActivity](https://developer.apple.com/documentation/healthkit/hkworkoutactivity)
- [HKWorkoutEvent](https://developer.apple.com/documentation/healthkit/hkworkoutevent)
- [HKWorkoutEventType.lap](https://developer.apple.com/documentation/healthkit/hkworkouteventtype/lap)
- [WorkoutKit](https://developer.apple.com/documentation/workoutkit)
