# Milestone 9: HealthKit Evidence Contract

## Goal
Make HealthKit evidence durable, auditable, and confidence-gated before adding deeper workout charts, trends, mechanics analysis, or stronger run-type claims.

This milestone is the source of truth for the next implementation phase. Future chats should read this file after `AGENTS.md`, execute the next incomplete step only, and update the step status before moving on.

## Status
- Overall: In progress
- Current step: Step 7 - Build Deeper UI Only After Gates Pass (in progress)

## Affected Areas
- HealthKit import and enrichment
- Workout evidence model
- SwiftData persistence
- Analytics engine
- Run type review/import bridge
- Data and workout detail surfaces
- Tests and physical-iPhone verification notes

## Execution Rules
- Keep the app HealthKit-only. Do not add FIT import, FIT backup, HealthFit export, Drive, Sheets, or file-based workout ingestion.
- Preserve raw HealthKit identity: workout UUID, source, source revision, date range, metadata, and device when available.
- Keep raw/imported evidence separate from derived analytics and user-reviewed labels.
- Treat optional metrics as optional: route, HR series, speed/distance series, power, cadence/steps, stride length, vertical oscillation, ground contact time, workout events, and interval labels.
- Do not promote Workout Analyzer, Trends, Mechanics, or run-type claims unless the required evidence gate passes.
- Simulator checks are useful for UI and sample data only. Real HealthKit confidence requires physical iPhone verification.

## Step 1: Evidence Contract Matrix
Status: Completed

Define a compact matrix for each app surface:
- Latest Run
- Workout Analyzer
- Trends
- Mechanics
- Run Type Analysis
- Training Plan Brief
- Data Quality / Audit

For each surface, document:
- HealthKit inputs required
- Derived calculations allowed
- Minimum coverage/confidence gate
- What to show when evidence is missing
- Whether the surface is ready, limited, or blocked

Acceptance criteria:
- Matrix lives in this file or a linked doc under `docs/milestones/`.
- Each surface has a clear go / limited / defer decision.
- No UI expansion happens before this matrix exists.

### Evidence Snapshot Used For This Contract

- Source: latest physical-iPhone HealthKit verification plus enriched audit exports already reviewed from AirDrop.
- Device proof: `AIS17PM`, iOS `26.5.1`.
- Historical range to preserve: web reference and local HealthKit alignment run from `Jan 3, 2019` through `Jun 5, 2026`; older treadmill/indoor runs near the 2019 boundary may remain summary-heavy even after enrichment.
- Loaded HealthKit state: physical-iPhone sync previously loaded `620` total local records with `3` duplicate candidate matches and an idempotent second anchored sync.
- Latest enriched audit export: `617` audited workouts, `278` heart-rate sample rows, `282` speed/distance sample rows, `140` running dynamics rows, `398,503` route points loaded, and `770,069` series samples loaded.
- Current enrichment boundary: detailed heart-rate and speed/distance evidence reaches roughly `Oct 17, 2022`; workouts back to `Jan 3, 2019` are included in the contract but must be treated as summary-only unless their own audit row proves detailed samples exist.
- Current audit fields: workout summary, route/route point count, heart-rate samples or summary, speed/distance samples or summary, active energy, running power, cadence/steps, stride length, vertical oscillation, ground contact time, and workout events/interval labels when HealthKit exposes them.
- Known wording risk: the current duplicate summary can read like `617 duplicates excluded`; treat it as a confusing diagnostics message until the duplicate-status copy is fixed, not as evidence that 617 records are duplicate workouts.

### Evidence Contract Matrix

| Surface | HealthKit inputs required | Derived calculations allowed now | Minimum coverage / confidence gate | Missing evidence state | Decision |
| --- | --- | --- | --- | --- | --- |
| Latest Run | `HKWorkout` UUID/source/source revision/date range, distance, duration, environment, active energy when available, HR summary or samples, route flag/points, speed/distance samples, events, optional power/cadence/mechanics samples. | Whole-run pace, distance, duration, broad intensity summary, basic caveats, effective run type only as suggested/imported/manual label. | Summary data plus at least one meaningful detail signal for moderate confidence; strong execution claims require HR plus speed/distance series and preferably route/events. | Show summary-only card with explicit caveats; hide charts/drift/segment claims until series exists. | Limited: latest summary is usable, detailed execution remains gated. |
| Workout Analyzer | Same as Latest Run plus persisted per-workout HR, speed or distance series, route points, events/laps/segments, and optional power/cadence/mechanics series. | After persistence, compute splits, pace shape, HR drift, elevation from route, segment/interval interpretation, and sample-count diagnostics. | Moderate only with HR plus speed/distance series; strong only with route or events plus enough sample density for splits/segments. | Show evidence checklist and "analysis unavailable/summary only"; do not infer workout structure without labels or reliable events. | Defer: do not expand UI until Step 2 persistence and Step 3 enrichment queue exist. |
| Trends | `HKWorkout` summary history from `Jan 3, 2019`, duplicate status, reviewed/imported/suggested run type provenance, distance, duration, HR summaries, active energy, optional VO2/resting HR context. | Weekly/monthly volume, aggregate pace, best-effort estimates from summary distance/duration, duplicate-excluded totals, cautious HR/energy summaries. | Summary trends can run on non-duplicate workout history; run-type, intensity, and mechanics trends require provenance and field-specific coverage. | Show trend with confidence label and excluded/pending counts; hide series-dependent trend panels. | Limited: summary trends are allowed, purpose/mechanics trends are gated. |
| Mechanics | Running power, cadence or steps, stride length, vertical oscillation, ground contact time, route/speed context, source/date identity for each sample. | Simple per-workout averages only when HealthKit returns evidence; no form drift or efficiency claims without durable sample coverage. | Strong mechanics requires enough non-duplicate workouts with mechanics samples across comparable sources; current audit treats these metrics as optional and often missing. | Hide mechanics panels or show "not enough mechanics evidence"; never substitute zeroes. | Defer: blocked for claims until Step 2, Step 3, and physical coverage review prove real sample availability. |
| Run Type Analysis | Workout summary, environment, distance/duration/pace, events/intervals when available, imported reviewed web labels, user-reviewed labels, duplicate status, source/date identity. | Suggested labels from rules; reviewed/imported counts; summary by type only when provenance is explicit. | Reviewed or imported labels can drive stronger type summaries; suggested-only labels stay limited; interval/threshold/race claims need events or user review. | Mark unknown/needs review; explain whether label is suggested, imported, or user reviewed. | Limited: useful as a review/trust surface, not ready for strong automated claims until Step 4. |
| Training Plan Brief | Duplicate-excluded history, weekly volume, recent long runs, best efforts, race goal, reviewed/imported run types, HR/pace evidence where available, HealthContext fields only when clearly sourced. | Cautious readiness bands, pace gap, recent-volume summary, missing-evidence caveats, exportable narrative grounded in available metrics. | Can summarize durable summary history; workout-quality prescriptions need reviewed run types and series-backed intensity evidence. | Include missing-evidence section and avoid workout-type prescriptions when labels/series are weak. | Limited: export can improve after trust model; no stronger coaching until gates pass. |
| Data Quality / Audit | All raw HealthKit identity, source metadata, duplicate candidates, sample counts by metric, route point counts, event counts/labels, authorization state, sync/enrichment counts. | Coverage status, caveats, pending evidence count, duplicate/source/date reconciliation, diagnostics export. | Ready for audit reporting when it reflects the current load/sync/enrichment state; physical-iPhone data is required for HealthKit confidence. | Show missing, summary-only, pending, or unavailable states explicitly; never display zero as unknown. | Ready for audit surface, limited by pending evidence and physical verification. |

## Step 2: Persist Full Workout Evidence
Status: Completed

Add a durable evidence cache keyed by HealthKit workout UUID.

Store normalized evidence for:
- Heart rate samples
- Running speed samples
- Distance samples
- Active energy samples
- Running power samples
- Cadence or step samples
- Stride length samples
- Vertical oscillation samples
- Ground contact time samples
- Route points
- Workout events / laps / segments when HealthKit exposes them
- Loaded-at timestamp, source/provenance, sample counts, and caveats

Acceptance criteria:
- Full evidence is persisted separately from `PersistedWorkout` summary fields.
- Existing manual labels and notes survive refresh/enrichment.
- Missing metrics remain explicit missing states, not zeroes.
- Tests cover persistence, missing series, and refresh behavior.

Completion notes:
- Added a separate `PersistedWorkoutEvidence` SwiftData model keyed by HealthKit workout UUID.
- Full normalized `WorkoutEvidence` is JSON-encoded into the evidence cache with loaded-at timestamp, sample counts, route point count, event count, and source summary.
- `PersistedWorkout` remains the summary/manual-label record; fetched `CanonicalWorkout` values do not carry cached full evidence by default.
- Summary-only HealthKit refreshes do not delete or replace existing detailed evidence; evidence only updates when a detail query supplies a new `WorkoutEvidence` payload.
- Manual run type and notes still survive refresh/enrichment.
- Missing metrics remain absent from the persisted `series` dictionary instead of being written as zero-value samples.
- Stored event evidence includes normalized type and optional label when HealthKit exposes event metadata.

## Step 3: Backfill And Enrichment Queue
Status: Completed

Replace the implicit latest-workout-only detailed evidence boundary with an explicit enrichment queue.

The queue should prioritize:
- Latest run
- Recent quality runs
- Recent long runs
- Runs marked unknown or needs review
- Older benchmark/race/time-trial runs
- Remaining historical runs in controlled batches

Acceptance criteria:
- The app can show pending evidence count clearly.
- Backfill does not run expensive full-history detail queries on every launch.
- Enrichment is idempotent and keyed by HealthKit UUID.
- Tests cover pending, enriched, and failed evidence states.

Completion notes:
- Added `EvidenceEnrichmentQueue` with explicit pending/enriched/failed states and priority ordering.
- Queue priority is latest run, recent quality run, recent long run, needs-review run, older benchmark/race/time-trial style run, then remaining historical runs.
- Added durable `PersistedEvidenceEnrichmentState` records keyed by HealthKit workout UUID so failed enrichment attempts are visible and not retried as ordinary pending work.
- Queue idempotence uses `PersistedWorkoutEvidence` UUIDs as the enriched set, so workouts with cached full evidence are skipped.
- Existing HealthKit enrichment remains bounded to selected UUID batches; no full-history detail queries were added to launch, load, or sync.
- Data and HealthKit Audit surfaces now show queue pending/failed counts through the existing UI.
- Tests cover queue priority, pending count, enriched-cache skipping, failed state, full evidence persistence, missing series, and summary refresh behavior.

## Step 4: Run Type Trust Model
Status: Completed

Separate run type provenance so the app does not blur guessed, imported, and user-reviewed labels.

Use distinct states:
- Suggested: rule-based inference from HealthKit evidence
- Imported review: matched from prior reviewed web categories
- User reviewed: explicitly chosen in the iPhone app
- Unknown / needs review: insufficient, conflicting, or missing evidence

Acceptance criteria:
- Trends that depend on run purpose can distinguish reviewed labels from suggestions.
- Imported reviewed labels do not appear identical to direct iPhone manual labels.
- Detail/history screens can explain why a run needs review.
- Tests cover suggested, imported, reviewed, conflict, and unknown states.

Completion notes:
- Added `RunTypeTrustKind` and `RunTypeTrustState` to distinguish suggested, imported review, user reviewed, needs review, and conflict states.
- Added separate imported review fields on `CanonicalWorkout`/`PersistedWorkout` so imported web categories no longer write into the direct user manual label field.
- `effectiveRunType` now resolves user reviewed first, imported review second, suggested inference third.
- `trustedPurposeRunType` is only present for user-reviewed and imported-reviewed labels; suggested, needs-review, and conflict states are excluded from trusted run-purpose trend calculations.
- `RunTypeReviewBridge.applyConfidentMatches` now stores imported review provenance instead of overwriting `manualRunType`.
- Detail/history surfaces now show run type trust state, and workout detail explains the current provenance.
- Tests cover suggested, imported, user-reviewed, conflict, unknown/needs-review, and import-vs-manual separation.

## Step 5: Derived Analytics Versioning
Status: Completed

Make detailed analytics recomputable from cached evidence.

Track calculation versions for:
- Splits and pacing shape
- HR drift
- Cadence/power/mechanics averages and trends
- Best efforts and rolling-distance efforts
- Interval/segment interpretation
- Readiness and data-quality confidence

Acceptance criteria:
- Derived analytics record their version and inputs.
- Changing calculation logic can recompute derived results from cached evidence.
- Whole-workout average pace remains labeled as an estimate until rolling evidence exists.
- Tests cover versioned calculations and confidence downgrades.

## Step 6: Physical iPhone Verification
Status: Completed

Verify HealthKit evidence shape on the physical iPhone with representative Apple Watch runs:
- Easy outdoor run
- Treadmill run
- Interval or structured workout
- Long run
- Race or time trial
- Older historical run

Record:
- Which fields HealthKit exposed
- Which samples were associated directly with the workout
- Which fields required fallback queries
- Route availability and route point count
- Event/lap/segment availability
- Mechanics availability
- Any source/date fallback overmatching risk

Acceptance criteria:
- Verification notes are added to this file or a linked doc.
- Each major app surface has a ready / limited / blocked decision based on real iPhone evidence.
- Simulator-only proof is not treated as HealthKit data proof.

Verification notes:
- Archived linked doc: `docs/milestones/archive/09-healthkit-physical-verification.md`
- June 6, 2026 progress: existing aggregate physical evidence from `AIS17PM` is documented, the representative-run checklist is defined, and current surface decisions remain limited/blocked where row-level evidence is missing.
- June 6, 2026 app support: added a Data tab `Share physical verification` export that selects representative non-duplicate workouts for the Step 6 archetypes and marks missing slots explicitly. This makes the next connected-device pass auditable without treating Simulator data as HealthKit proof.
- June 6, 2026 app support update: added a Data tab `Open physical verification` screen so the representative checklist can be reviewed on-device before export, including candidate workout, sample counts, route, events, mechanics, run-type trust, and missing-slot status.
- June 6, 2026 diagnostics fix: replaced split authorization/message diagnostics state with a single `HealthKitActionStatus`, so non-HealthKit UI messages no longer overwrite the HealthKit authorization/message pair exported in diagnostics.
- June 6, 2026 blocker: XcodeBuildMCP `list_devices` reported `AIS17PM` as `disconnected`, and no local row-level AirDrop/audit artifact was found for the required representative Apple Watch run archetypes. Step 6 is not complete until a connected physical iPhone run or row-level physical audit export fills the checklist.
- June 6, 2026 connected-device progress: XcodeBuildMCP `list_devices` reported `AIS17PM` connected on iOS `26.5.1`; `swift test --package-path RunningWorkoutAnalysisPackage` passed with `35` tests; XcodeBuildMCP `build_run_sim` succeeded on `iPhone 17`; XcodeBuildMCP `build_run_device` installed and launched `com.adrielsolorzano.runninganalysis` on `AIS17PM`. Step 6 remains incomplete until the on-phone HealthKit authorization/load/enrichment flow produces representative-run verification evidence.
- June 6, 2026 completion: on-phone exports confirmed HealthKit `Authorized`, `620` loaded workouts, `617` included, `3` duplicates, `0` pending evidence, and representative candidates for easy outdoor, treadmill, interval/structured, long run, race/time trial, and older historical runs. Recent outdoor/tempo/long rows expose associated HR, speed/distance, active energy, route, event, power, cadence/steps, and mechanics samples. Treadmill, race, and older historical representatives remain limited because direct HR/speed/distance/mechanics samples are absent.

## Step 7: Build Deeper UI Only After Gates Pass
Status: In progress

After evidence persistence, backfill, trust model, and iPhone verification are in place, add deeper visuals only for surfaces that pass gates.

Candidate UI work:
- Latest Run detail charts
- Split/segment review
- HR and pace drift
- Run type review queue
- Mechanics trend panels
- Workout Analyzer parity surfaces
- Evidence-first Training Plan Brief export improvements

Started scope:
- Add a gated execution analysis detail section for enriched workouts using cached `DerivedWorkoutAnalysis`, with missing-evidence states for summary-only runs.
- Add compact split review rows from cached distance evidence, limited to a small iPhone-friendly preview and hidden when split evidence is unavailable.

Acceptance criteria:
- UI uses cached evidence, not repeated ad hoc HealthKit queries.
- Each chart/table has a missing-evidence state.
- No dense table UI on iPhone.
- Desktop/mobile-equivalent simulator checks are replaced here by small/large iPhone simulator checks plus physical-device data proof when HealthKit behavior matters.

## Test Commands
- `swift test --package-path RunningWorkoutAnalysisPackage`
- Before any Xcode build/run/test, call XcodeBuildMCP `session_show_defaults`.
- XcodeBuildMCP simulator build/run with the `RunningWorkoutAnalysis` scheme and an iPhone simulator such as `iPhone 17`.

## Simulator Checks
- Launch app without blank screen.
- Check Today, Latest Run, Race Goal, History, and Data tabs.
- Confirm evidence pending/limited states are readable.
- Confirm run type labels and review controls do not overlap on small iPhone layouts.

## Known Risks
- HealthKit may not expose all Apple Fitness-visible fields through public APIs.
- HealthKit samples may be condensed, coalesced, sparse, or not associated directly with the workout.
- Source/date fallback queries can overmatch nearby samples from the same source if not audited carefully.
- Persisting route and health samples increases local privacy sensitivity; exports should remain explicit and local.
- SwiftData schema changes need careful migration planning.

## Resolved Issues

- Diagnostics authorization/message staleness: fixed on June 6, 2026 by storing the last HealthKit action status as a single authorization/message pair and exporting diagnostics from that status instead of the general UI message.

## Known Issues

## Completion Notes
- Step 1 completed on June 6, 2026. Added the Evidence Contract Matrix using the latest enriched HealthKit audit export and physical-iPhone evidence snapshot through the historical `Jan 3, 2019` baseline.
- Step 2 completed on June 6, 2026. Added durable full-evidence persistence with `PersistedWorkoutEvidence`, kept it separate from `PersistedWorkout`, and added tests for full evidence persistence, missing-series behavior, and summary refresh preserving manual fields plus cached evidence.
- Verification for Step 2: `swift test --package-path RunningWorkoutAnalysisPackage` passed with `26` tests; XcodeBuildMCP `session_show_defaults` confirmed the workspace/scheme/simulator defaults; XcodeBuildMCP `build_run_sim` succeeded on `iPhone 17`.
- Step 3 completed on June 6, 2026. Added an explicit cache-aware enrichment queue, durable failed/enriched attempt state, pending/failed queue counts on existing Data/Audit surfaces, and tests for pending, enriched, and failed queue behavior.
- Verification for Step 3: `swift test --package-path RunningWorkoutAnalysisPackage` passed with `28` tests; XcodeBuildMCP `session_show_defaults` confirmed the workspace/scheme/simulator defaults; XcodeBuildMCP `build_run_sim` succeeded on `iPhone 17`.
- Step 4 completed on June 6, 2026. Added distinct suggested/imported-review/user-reviewed/needs-review/conflict run type states, kept imported reviewed labels separate from direct iPhone manual labels, and restricted trusted run-purpose trend/readiness calculations to reviewed or imported labels.
- Verification for Step 4: `swift test --package-path RunningWorkoutAnalysisPackage` passed with `29` tests; XcodeBuildMCP `session_show_defaults` confirmed the workspace/scheme/simulator defaults; XcodeBuildMCP `build_run_sim` succeeded on `iPhone 17`.
- Step 5 completed on June 6, 2026. Added versioned `DerivedWorkoutAnalysis` records backed by `PersistedDerivedWorkoutAnalysis`, recorded calculation inputs/signatures, recomputed derived analytics from cached evidence on summary refresh or explicit refresh, kept whole-workout pace labeled limited/estimated until rolling evidence exists, and added confidence-gated derived pacing, HR drift, mechanics, best-effort, interval, readiness, and data-quality outputs.
- Verification for Step 5: `swift test --package-path RunningWorkoutAnalysisPackage` passed with `33` tests; XcodeBuildMCP `session_show_defaults` confirmed the workspace/scheme/simulator defaults; XcodeBuildMCP `build_run_sim` succeeded on `iPhone 17`. Existing warning remains: `totalEnergyBurned` is deprecated in `HealthKitWorkoutMapper.swift`.
- Step 6 started on June 6, 2026. Added linked physical-verification notes with the existing aggregate `AIS17PM` evidence snapshot, representative Apple Watch run checklist, surface gate decisions, and the current blocker.
- Step 6 app support added on June 6, 2026. Added `PhysicalVerificationReport` plus a Data tab share export so a connected physical-iPhone run can produce representative-run verification notes from loaded HealthKit data.
- Step 6 app support update on June 6, 2026. Added an on-device Physical Verification screen reachable from Data so candidate rows can be reviewed before sharing the verification export.
- Step 6 diagnostics support update on June 6, 2026. Fixed stale diagnostics authorization/message export by introducing `HealthKitActionStatus` and keeping diagnostics tied to the last HealthKit action instead of later non-HealthKit UI messages.
- Verification for Step 6 progress: `swift test --package-path RunningWorkoutAnalysisPackage` passed with `35` tests; XcodeBuildMCP `build_run_sim` succeeded on `iPhone 17`; simulator UI navigation confirmed Data -> `Open physical verification` opens the representative checklist screen and shows the physical-device gate. XcodeBuildMCP `list_devices` reported `AIS17PM` as `disconnected`; local artifact search did not find a row-level physical audit export for the representative checklist. Simulator-only proof was not counted as HealthKit data proof.
- Verification for Step 6 connected-device pass: `swift test --package-path RunningWorkoutAnalysisPackage` passed with `35` tests; XcodeBuildMCP `build_run_sim` succeeded on `iPhone 17`; Simulator screenshot confirmed the app launched on Today without a blank screen or obvious overlap; XcodeBuildMCP `list_devices` reported `AIS17PM` connected on iOS `26.5.1`; XcodeBuildMCP `build_run_device` installed and launched the app on the physical iPhone. Existing warning remains: `totalEnergyBurned` is deprecated in `HealthKitWorkoutMapper.swift`.
- Step 6 completed on June 6, 2026 from the on-phone diagnostics, HealthKit audit, and physical verification exports. Representative-run proof is archived in `docs/milestones/archive/09-healthkit-physical-verification.md`.
- Step 7 started on June 6, 2026 with a gated execution analysis card on workout detail, backed by persisted `DerivedWorkoutAnalysis` and explicit missing-analysis states.
- Step 7 split review started on June 6, 2026. `DerivedWorkoutAnalysis` v2 now stores compact 1 km split estimates from cached distance samples, refreshes stale derived records from persisted evidence, and renders up to five split rows in the workout detail execution card.
- Step 7 HR drift / pace-shape visual started on June 10, 2026. `DerivedWorkoutAnalysis` now carries optional opening/finish execution segments from cached heart-rate and speed samples, and workout detail renders a compact gated visual only when those cached segments exist.
- Remaining limitations: failed queue items do not yet have a manual retry/reset control, direct conflict resolution UI is not built yet, older 2019-era runs may remain summary-only, optional mechanics/route/event fields are not guaranteed by HealthKit, and treadmill/race/historical representatives remain limited until direct series evidence is available or the UI shows unavailable states.
