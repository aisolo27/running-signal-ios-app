# RunSignal Change And Decision Log

Last updated: 2026-07-16

This is the durable historical record for why RunSignal works the way it does. Use it before changing an established architecture, performance boundary, data contract, or runner-facing behavior.

It does not replace:

- `project-status.md` for current product state, verification, and next work.
- `regression-cases.md` for canonical interval behavior and retained evidence.
- `../healthkit-contract.md` for the detailed HealthKit and WorkoutKit contract.
- `../bug-log.md` for recurring implementation safeguards.
- Git history for the exhaustive file-by-file record.

## How To Add An Entry

Record a change here when it creates or revises a durable decision that future work could accidentally reverse. Include:

- Date and status: active, planned, superseded, or rejected.
- What changed.
- Why it changed.
- What future work must preserve.
- Verification or commit evidence when available.

Do not use this file as a backlog. Put current next work in `project-status.md`.

## Active Architecture And Product Decisions

### D-001 — Summary history and detailed evidence have different scopes

- Status: Active
- Established: 2026-07-03 through 2026-07-14
- Primary commits: `55f9d94`, `7dffa66`, `1d51353`, `ea0dcbc`, `112b81f`, `129c6dc`

RunSignal loads lightweight summary records for the full permitted Apple Health running history. It does not automatically hydrate full samples, routes, charts, mechanics, WorkoutKit plans, and interval rows for every historical run.

- Automatic detailed analysis is sequential and limited to the newest 20 non-duplicate workouts inside the previous 30 days.
- Older workouts load full detail on demand when the runner opens or explicitly requests them.
- Normal launch must not decode the complete detailed-evidence table.
- Historical Best Efforts uses a separate resumable distance-only pass. It must not expand the full-evidence queue.

Why: full evidence for hundreds or thousands of workouts creates unnecessary HealthKit queries, CPU work, memory pressure, persistence traffic, battery use, heat, and interaction risk.

Future performance work must preserve this bounded scope unless new physical-device evidence demonstrates that the product contract should change.

### D-002 — An analytics snapshot is not full workout analysis

- Status: Active
- Clarified: 2026-07-16

`AnalyticsEngine.snapshot(for:)` is a lightweight aggregate over already-loaded `CanonicalWorkout` summary fields. It calculates values such as recent distance, category balance, summary Best Efforts, readiness, and data coverage. It does not fetch or hydrate every workout's detailed HealthKit evidence.

Automatic detailed analysis now publishes per-workout classification/readiness and refreshes only affected period caches as each item finishes, then publishes the full summary snapshot, combined Best Efforts cache, suggestions, and queue summary once when the bounded queue completes or yields. This batching does not change the detailed-evidence scope.

Preserve:

- Full summary history may remain available for period totals and navigation.
- Full evidence remains bounded under D-001.
- Any incremental snapshot replacement must update affected totals correctly and retain duplicate exclusion.

### D-003 — Heavy computation stays off the main actor; publication stays bounded

- Status: Active
- Established: 2026-07-10 through 2026-07-11
- Primary commits: `1d51353`, `ea0dcbc`

- Detailed derived preparation and Best Effort distance scanning use immutable snapshots and detached utility-priority work.
- Automatic detailed analysis remains sequential.
- Main-actor persistence, observable publication, cache refreshes, and aggregate recomputation should be batched or limited to affected scopes where practical.
- A performance optimization must not replace bounded work with broad hydration or broad main-actor recomputation.

Physical interaction proof has been positive in prior stress passes, but a reliable post-fix Instruments call tree remains outstanding.

### D-004 — HealthKit v1 is read-only and HealthKit-only

- Status: Active
- Established: 2026-06-05 onward

RunSignal reads completed Apple Health workouts and supporting evidence. It does not write HealthKit data. FIT, HealthFit, screenshots, and manual exports are validation evidence only, not runtime inputs. Backend sync, AI coaching, and file ingestion remain out of scope unless the product direction explicitly changes.

### D-005 — Completed custom-workout rows require the generalized evidence gate

- Status: Active
- Established: 2026-06-13 through 2026-07-09

Runner-facing Work, Recovery, Cooldown, and Open / Extra rows publish only when ordered WorkoutKit planned rows map to complete contiguous HealthKit activity evidence, or to a provable completed prefix for a stopped-early workout.

Raw markers, segment events, and older plan/sample reconstruction remain debug-only. Ambiguous evidence must preserve whole-run analytics and show an unavailable reason instead of guessing interval rows.

### D-006 — Prescribed, measured, elapsed, paused, and active values stay distinct

- Status: Active
- Established: 2026-06-22 through 2026-07-10

- Planned distance and target pace describe the prescription.
- HealthKit samples and activity rows describe completed evidence.
- Paused rows retain elapsed duration, pause overlap, and active/timer duration.
- Completed fixed-distance runner-facing pace uses prescribed distance with the mapped activity-row timer.
- Shortened work uses measured distance and pause-adjusted active time.
- Completion status and pace-target status are separate.

Future UI or analytics changes must not collapse these bases into one unlabeled value.

### D-007 — Persisted derived behavior is versioned

- Status: Active
- Established: 2026-07-12
- Primary commit: `80e9643`

When a derived algorithm changes, bump the calculation version and rebuild outdated cached analysis from stored raw evidence during targeted hydration. A source-code fix is incomplete if an older on-device cache can continue displaying the superseded result.

### D-008 — Heart-rate-zone profiles are effective-dated

- Status: Active
- Established: 2026-07-12 through 2026-07-13
- Primary commits: `80e9643`, `1ed653c`

Changing the current zone profile does not silently rewrite older workouts. The runner may explicitly apply the current profile to all workouts only through a warned destructive action. Active, proposed, and historical profile states must remain visibly distinct.

### D-009 — Foreground Apple Health sync stays quiet and throttled

- Status: Active
- Established: 2026-07-11 through 2026-07-12
- Primary commits: `ea0dcbc`, `80e9643`

App activation uses a persisted 15-minute throttle and a single-flight anchored check. Background or foreground maintenance must not present the blocking explicit-refresh banner. Pull-to-refresh and Settings refresh remain explicit visible actions.

### D-010 — Best Efforts are exact-only

- Status: Active
- Established: 2026-07-13 through 2026-07-14
- Revised: 2026-07-16
- Primary commits: `112b81f`, `129c6dc`

RunSignal displays exact segment records and exact-total records only. Summary estimates and provisional record sections are intentionally absent. `All-Time Records` appears only after eligible history and detailed distance verification are complete; incomplete coverage remains `Verified Best Efforts` with checked, pending, and failed counts.

The verified bucket set includes 3K. Adding that bucket required new persisted summary and history-checkpoint versions so users whose prior history scan was complete are rescanned instead of remaining on a pre-3K cache.

### D-011 — Production first launch is honest and explain-before-ask

- Status: Active
- Established: 2026-07-13 through 2026-07-14
- Revised: 2026-07-16
- Primary commits: `112b81f`, `129c6dc`, `5b71c34`

- Production first launch contains no demo workouts.
- RunSignal explains read-only, private on-device processing before Apple's Health sheet.
- `Not Now` leads to a truthful empty Runs screen with a Connect action.
- A fresh-install recording must preserve true first launch by installing without opening the app.

HealthKit authorization-sheet completion does not prove that every requested read type was granted. Empty-result recovery copy must not claim more access than successful queries prove.

When a completed partial-access check returns zero completed runs, the app presents `Review Apple Health Access`, explains that Apple does not reveal individual declined read types, provides the Health-app review path, and keeps Refresh available. Each active history import or continuation pass reports completed date windows over the windows remaining in that pass. After a resume, the visible counter restarts at zero over the reduced remaining set while the persisted cursor and already imported runs remain intact. This progress remains separate from automatic detailed analysis and Best Effort verification.

Background observer registration reuses the store's completed authorization/import gate. It must not immediately issue a second HealthKit authorization request.

### D-012 — Interval Library is a repeated-prescription comparison tool

- Status: Active
- Accepted and implemented: 2026-07-16

The primary Interval Library experience should emphasize repeated comparable prescriptions across separate workouts.

- De-emphasize one-off and single-Work-row plans; place them in a secondary or collapsed single-session area if retained.
- Clearly distinguish workout count from Work-rep count.
- Present target results as a fraction such as `9 of 12 Work reps on target`.
- Label aggregate pace as average Work pace, not an unexplained latest pace.
- Make chart points inspectable and make dated results open the source workout.

Do not implement this direction by weakening the official interval evidence gate under D-005.

### D-013 — Run-type color remains supplementary

- Status: Active
- Recorded and implemented: 2026-07-16

Run types may receive distinct accessible colors across Runs and Analytics, but the written Easy, Long, Interval, Threshold, Race, or Other label must remain. Color must not become the only category signal.

The shared mapping is Easy green, Long orange, Interval cyan, Threshold purple, Race pink, and Other gray. Runs tags and Analytics purpose/list surfaces reuse the same semantic mapping.

### D-014 — Profile averages follow a trailing four-week convention

- Status: Active
- Recorded and implemented: 2026-07-16

Strava documents its profile averages as averages from the last four weeks, alongside year-to-date and all-time totals. Source: `https://support.strava.com/en-us/articles/15402175-your-strava-profile-page`.

RunSignal uses the same profile-style convention:

- Average runs, time, and distance per week: trailing four weeks, clearly labeled.
- Year-to-date: calendar-year totals.
- All-time: cumulative totals.

Keep period-specific Week, Month, Year, and All-Time Analytics separate from this compact profile summary.

### D-015 — Normal kilometer splits require validated boundary evidence

- Status: Active
- Established: 2026-07-17

Normal one-kilometer splits are distinct from custom-workout interval rows under D-005.

- Detailed distance must be ordered, deduplicated, non-overlapping, and reconciled to the workout summary before it can validate a boundary chain or produce window-interpolated splits.
- A complete validated HealthKit `lap` chain is preferred because Apple defines laps as equal-distance partitions. Documented legacy zero-duration laps are expanded from the prior boundary.
- A contiguous public HealthKit segment-event chain may supply normal split boundaries only when it starts with the workout, ends with the final distance evidence, has the exact expected kilometer-plus-partial row count, each full row distance-validates as approximately one kilometer, and no materially different validated chain competes with it.
- Older Apple Watch runs can expose kilometer and mile segment chains at the same time. RunSignal selects the validated kilometer chain and ignores the interleaved mile chain.
- Displayed split time subtracts only a reliable pause-event timeline that reconciles to the HealthKit workout's elapsed-minus-active duration. Elapsed boundary dates remain available for sample slicing and diagnostics.
- When no boundary chain passes, RunSignal derives crossings by accruing every distance contribution across its actual HealthKit sample start/end window on that active-time clock. It never credits a long sample's entire distance at the sample start timestamp.
- Summary-only evidence produces no kilometer rows; whole-run distance, duration, and average pace remain available with a clear unavailable reason.
- Developer review and parity exports must name the selected normal-split source and retain the chain counts, selected rows, and validation or rejection reason needed to audit that choice later.
- Segment events remain debug-only for custom-workout Work, Recovery, Cooldown, and Open / Extra reconstruction.
- This derived behavior is cache-versioned under D-007 so stored legacy splits rebuild during targeted hydration.

### D-016 — Running units are presentation policy; prescriptions and aggregate bases stay explicit

- Status: Active
- Established: 2026-07-17

RunSignal stores and evaluates completed evidence in canonical units: meters, seconds, and seconds per kilometer. The runner chooses a primary distance-and-pace unit of kilometers or miles plus an optional secondary distance-and-pace presentation. The primary unit controls general measured distance, pace, charts, and normal split basis. Secondary distance appears only on selected summary surfaces; secondary pace appears only beneath Avg pace on Workout Details. Neither changes calculations, target status, completion status, grouping, Best Efforts, or cache identity.

On dual-unit summary cards, the secondary value is subordinate evidence: render it on a separate line, in parentheses, with smaller typography and medium weight. Use the same adaptive primary/off-white foreground as the headline metric so hierarchy comes from size, weight, placement, and parentheses rather than poor contrast. It must not share the primary metric's headline hierarchy or appear as a peer bullet value. Supporting metric labels and captions must use explicit semantic high-contrast colors in dark mode.

WorkoutKit fixed-distance prescriptions retain their authored unit when available. A plan such as `1 mi warmup · 5 × 800 m · 0.5 mi cooldown` must not be flattened into one display unit. Runner-facing pace presentation follows the selected primary denominator, while raw plan/debug evidence remains auditable. Race and Best Effort identities such as `400m`, `1 Mile`, `5K`, and `Half Marathon` remain stable names.

Legacy cached target text may be converted for runner presentation only when it strictly matches an explicit `/km` or `/mi` pace value or range. Opaque and non-pace target text remains unchanged. This parsing is display-only and must never create or alter target evaluation.

Interval Library aggregate bases are explicit:

- Repeated comparable fixed-distance Work uses fully completed reps only. Main average Completed Work pace equals total active/timer duration divided by total prescribed distance.
- Shortened fixed-distance reps stay visible separately and use measured HealthKit distance plus pause-adjusted active time.
- Repeated time-based or open Work uses a clearly labeled measured basis because no prescribed distance denominator exists.
- Mixed prescribed and measured distances must never enter one unlabeled aggregate. HealthKit-measured Work totals may remain supporting evidence.

This decision extends D-012 without weakening D-005 or D-006. It also generalizes D-015: a mile split is a separately validated 1,609.344-meter projection, never a relabeled kilometer row. Kilometer and mile projections must each preserve the same distance reconciliation, pause, ambiguity, partial-row, unavailable-state, diagnostic, and targeted cache-version requirements.

Changing the display preference must not query HealthKit, start import or analysis work, broadly hydrate evidence, or rewrite unit-neutral training and Best Effort caches. Runner formatting follows the preference; developer parity and diagnostic exports remain explicitly canonical unless their schema names another unit.

## Major Change Timeline

### 2026-06-05 to 2026-06-11 — Foundation and evidence model

- Created the native iPhone SwiftUI app and data-quality/parity surfaces.
- Added HealthKit audits, evidence-derived workout analysis, Apple Fitness comparison tooling, WorkoutKit reconstruction, and total-calorie support.
- Established that raw events and segment markers are debug evidence rather than Apple Fitness interval rows.

### 2026-06-12 to 2026-06-15 — Custom-workout evidence gates

- Collected physical-device boundary evidence and activity-row exports.
- Added repeat expansion, debug comparison models, timer-drift rules, pause handling, and guarded normal-detail promotion.
- Promoted only supported Work/Open and repeat shapes while retaining fallback behavior for ambiguous cases.

### 2026-06-22 to 2026-06-30 — Timing semantics and product interval rows

- Formalized elapsed, active/timer, pause-overlap, prescribed-distance, and measured-distance semantics.
- Expanded the generalized resolver to paused repeats, recovery tails, stopped-early prefixes, and deterministic tails.
- Added resolved product interval rows, weekly analytics, charts, and cleanup of superseded proof artifacts.

### 2026-07-01 to 2026-07-03 — Analytics, categorization, and full summary history

- Added interactive interval charts, Week/Month/Year/All-Time Analytics, Best Effort navigation, and manual run categorization.
- Fixed category-edit freezes and dark-mode contrast.
- Removed the old history cap so the full permitted workout-summary history can load.
- Added resumable ingestion safeguards while keeping detailed evidence bounded.

### 2026-07-05 to 2026-07-09 — Detail UX, caches, and metric accuracy

- Added evidence readiness, startup polish, local analytics caches, improved workout detail, WorkoutKit titles, and planned-distance interval pace rules.
- Tightened HealthKit accuracy, interval analytics, persistence, and repository hygiene.

### 2026-07-10 to 2026-07-11 — Automatic analysis and large-history responsiveness

- Added the newest-20-within-30-days sequential automatic queue, off-main derived preparation, Low Power and thermal budgets, weather/city display, run-type suggestions, and Developer Mode separation.
- Reorganized searchable year/type history, compact Year/All-Time Analytics, and Best Efforts.
- Moved Best Effort distance scanning off the main actor and added indexed distance-timeline queries.

### 2026-07-12 to 2026-07-13 — Complete splits, heart-rate zones, and first launch

- Removed the ten-split cap and added truthful final partial splits.
- Added versioned derived caches and targeted rebuilds.
- Added effective-dated Automatic HRR, percent-maximum, and Manual heart-rate-zone profiles.
- Added first-run Apple Health onboarding, no production demo data, exact-only Best Efforts, resumable distance-only verification, and large-history fixtures.

### 2026-07-14 — Release verification

- Repeated package, Simulator, and physical-device installation gates.
- Confirmed the fresh development install separately from true first-launch interaction and real HealthKit behavior.

### 2026-07-16 — Fresh-install recording review

- Confirmed 648 visible completed runs from 651 HealthKit workouts with three hidden duplicates.
- Confirmed that permission-denial recovery copy can misleadingly appear connected.
- Confirmed that import, automatic detailed analysis, and Best Effort verification are separate visible workloads.
- Accepted the repeated-prescription Interval Library direction in D-012.
- Clarified the summary-snapshot versus full-evidence distinction in D-002.
- Added truthful zero-result Health access recovery and determinate history-window progress.
- Batched automatic-analysis aggregate publication without expanding the newest-20-within-30-days evidence queue.
- Redesigned Interval Library around repeated prescriptions, with one-offs collapsed, explicit workout/Work-rep/target counts, inspectable pace charts, and source-workout links.
- Added shared accessible run-type colors, a verified 3K Best Effort bucket with cache invalidation, and trailing-four-week/YTD/all-time running statistics.

### 2026-07-17 — Legacy Apple Watch split correction

- Confirmed from the paired iPhone's stored 2019 evidence that distance samples cover multi-minute start/end windows while the previous split engine credited their full contribution at the start timestamp.
- Confirmed that the January 3 and January 5 runs contain simultaneous contiguous kilometer and mile segment chains; the kilometer chains reproduce the Apple Fitness split times supplied in the recording and screenshots.
- Confirmed that the January 14 run's apparent 7:29 third split contains a 2:25 explicit pause; subtracting the pause produces Apple Fitness's displayed 5:04 while the boundary itself remains valid.
- Added lap-first validated normal-split selection, distance quality/reconciliation gates, pause-aware active split timing, ambiguity rejection, interval-aware distance fallback, honest unavailable states, derived-cache invalidation, physical-evidence regression fixtures, and parity/review v3 audit fields.
- Added an Indoor/Outdoor environment filter to Run History without changing the Most Recent or custom-workout analysis paths.
