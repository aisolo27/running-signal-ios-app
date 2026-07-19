# RunSignal Daily Learning Review

## 2026-07-10

Scope: reviewed Codex session logs from July 10, 2026 whose `session_meta.payload.cwd` exactly matched `/Users/adrielsolorzano/Documents/Codex Projects/ios app Running Workout Analysis with Xcode & Codex`. Found three exact-cwd sessions and excluded the active daily-learning automation session. Source sessions reviewed:

- `019f4a2f-c040-7821-9f0e-3c80cc2f75be` at `2026-07-10T04:01:11Z`
- `019f4c5b-e0d8-75c0-96ce-a4a9b853af5e` at `2026-07-10T14:08:37Z`

Completed work:

- Fixed the July 9 recording issues around Analytics crashes, false HealthKit-unavailable startup state, blocking run-type edits, shortened-row presentation, and inconsistent fixed-distance interval metrics. Commit `4012072` landed on `main`.
- Added automatic new-run analysis, newest-20-within-30-days queue limits, sequential/off-main derived preparation, Low Power and thermal budget handling, richer workout detail UI, weather/city display, temperature settings, deterministic run-type suggestions, and Developer Mode separation for raw audit tools. Commit `1d51353` landed on `main`.
- Installed and launched the current pushed build on `AIS17PM`; iPhone Mirroring confirmed the July 10 workout rendered runner-facing `Work` and `Open` cards and Analytics navigation responded immediately.

Pending work:

- Next fresh HealthKit run still needs real-world proof for automatic-analysis duration, battery impact, thermal behavior, weather/city availability, and large-history responsiveness.
- Re-export and re-check the June 30 clean repeat/fixed-cooldown/`Open / Extra` case from a current build.
- Continue physical-iPhone checks for limited-history authorization, observer delivery, anchored deletions, backlog continuation, interruption/resume, and Apple Fitness metric parity.

Mistakes and fixes:

- The category suggestion path could erase a stronger stored category with a weak `Other`; fixed to preserve stronger stored classification.
- Explicit refresh flows preserved cached evidence on disk but did not restore it into the visible workout after a failed query; fixed without returning to full-history hydration.
- Automatic queue policy initially risked treating the cap as "20 missing analyses after filtering" rather than "newest 20 workouts overall"; fixed so older workouts do not silently enter the automatic queue.
- iOS 26 Simulator surfaced `CLGeocoder` reverse-geocoding deprecation warnings. This is a future MapKit migration note, not a current failure.

Workflow improvements:

- Keep commit/push proof, Simulator UI proof, physical-iPhone launch proof, and real HealthKit behavior proof separate.
- For automatic-analysis changes, test both cap ordering and already-detailed workouts that still need derived analytics preparation.
- For interval presentation changes, preserve the distinction between prescribed display distance, measured HealthKit totals, row timer basis, and target evaluation basis.

Docs updated:

- `docs/project-state/project-status.md`: updated by the source implementation sessions with the July 10 product state, next-work items, known limitations, and latest verification.
- `docs/bug-log.md`: updated by the source implementation sessions with recurring safeguards for readiness, cache refresh scope, automatic queue caps, and interval metric basis.
- `docs/project-state/daily-learning-review.md`: added by this review to capture lower-risk daily learning in one place.

Docs not updated:

- `docs/project-state/current-state.md`, `docs/project-state/next-work.md`, and `docs/project-state/documentation-index.md` do not exist in this checkout. The active authority remains `docs/project-state/project-status.md`.
- `AGENTS.md` was not changed; existing router rules already cover the durable workflow lessons.

## 2026-07-11

Scope: reviewed Codex session logs from July 11, 2026 whose `session_meta.payload.cwd` or `turn_context.cwd` exactly matched `/Users/adrielsolorzano/Documents/Codex Projects/ios app Running Workout Analysis with Xcode & Codex`. Found two exact-cwd sessions and excluded the active daily-learning automation session. Source session reviewed:

- `019f5112-366b-7a10-b6e7-5a34ab59feea` at `2026-07-11T12:06:15Z`

Completed work:

- Reviewed two iPhone screen recordings and mapped visible friction to the Runs list, workout detail, interval results, charts, and Analytics surfaces.
- Implemented the requested UI and performance follow-up on feature branch `codex/fix-healthkit-freeze-run-history`.
- Added weekday-inclusive run dates, WorkoutKit-name-first row titles with indoor/outdoor context, visible run-type tags, searchable and year/type-filtered history, a separate Best Efforts surface, compact Year/All-Time Analytics, consolidated Settings, and inline detail navigation title cleanup.
- Reworked charts and interval copy: one visible metric selector, persistent tap/drag distance inspection, cadence/power median bars, `Work Reps` and `Full Repeats` comparison scopes, clearer detailed-data wording, and exact-threshold pace deltas without invented target status.
- Moved Best Efforts refresh work off the main actor, reused one distance timeline per workout, and replaced repeated sample filtering with indexed gap queries.
- Committed `ea0dcbc` (`Fix HealthKit refresh and reorganize run history`), fast-forwarded it to `main`, pushed `main` to GitHub, and deleted the local feature branch.

Pending work:

- Physically verify the revised classification, cached real-workout title hydration, Analytics chart feel, exact-threshold interval copy, battery impact, thermal behavior, and fresh HealthKit processing on the iPhone.
- Capture a post-fix Instruments call tree if device attachment becomes reliable; `xctrace` timed out twice while waiting for the connected device during the source session.
- Continue previously listed physical checks for limited-history authorization, observer delivery, anchored deletions, backlog continuation, interruption/resume, and the next fresh HealthKit workout.

Mistakes and fixes:

- Large HealthKit refresh work could freeze interaction because Best Efforts distance-window scanning still ran too much work on the main actor. Fixed by snapshotting, processing off actor, and publishing only finished summaries.
- History and detail hydration risked silently changing visible categories as rows appeared. Fixed so cached plan metadata can hydrate lightly while classification stays in import, analysis, or explicit review paths.
- The first UI review correctly treated recording evidence, code inspection, tests, Simulator proof, physical-device launch, and real HealthKit behavior as separate proof channels. Keep that separation for future UI changes.
- A workflow rule was made explicit in practice: implementation changes should start on a feature branch, and `push live` means verified work goes to `main`, the feature branch is deleted, and `main` is pushed.

Workflow improvements:

- For screen-recording-driven UI work, first separate presentation fixes from HealthKit plumbing. In this case most requested data already existed; the durable work was row hierarchy, chart readability, and interaction performance.
- Preserve untracked review artifacts during publish flows. The source session kept `docs/project-state/daily-learning-review.md` untracked while committing only implementation, tests, and routing-doc changes.
- Treat `xctrace` attach failure as a tooling limitation, not as failed physical interaction proof, when direct device interaction has already demonstrated responsiveness.

Docs updated:

- `docs/project-state/project-status.md`: updated by the source implementation session with July 11 product state, next-work items, known limitations, and latest verification.
- `docs/bug-log.md`: updated by the source implementation session with durable safeguards for large history surfaces, Best Efforts refresh, visible hydration/classification boundaries, and interval UI validation.
- `docs/project-state/daily-learning-review.md`: updated by this review with the July 11 learning summary because the source session was broad and the durable lessons are useful but do not require another routing-doc edit.

Docs not updated:

- `AGENTS.md` was not changed; branch-first implementation and `push live` cleanup are already covered by the current project and global operating rules.
- `docs/project-state/current-state.md`, `docs/project-state/next-work.md`, and `docs/project-state/documentation-index.md` still do not exist in this checkout. The active authority remains `docs/project-state/project-status.md`.

## 2026-07-12

Scope: reviewed Codex session logs from July 12, 2026 whose `session_meta.payload.cwd` or `turn_context.cwd` exactly matched `/Users/adrielsolorzano/Documents/Codex Projects/ios app Running Workout Analysis with Xcode & Codex`. Found two exact-cwd sessions and excluded the active daily-learning automation session. Source session reviewed:

- `019f57fd-c660-7cc1-a9a3-dab63992ef87` at `2026-07-12T20:21:17Z`

Completed work:

- Analyzed two July 12 iPhone recordings and the pasted heart-rate-zone notes against the current app and project docs.
- Confirmed the missing 11 km+ and 27 km+ splits were a deterministic RunSignal bug: both detailed and fallback split paths capped rows at ten, while Apple Fitness showed the underlying workout data continued.
- Implemented split output for every completed kilometer plus a truthful `Final` partial row, with split-level heart rate, cadence, and power support.
- Revised chart presentation so Pace, Heart Rate, and Cadence stay primary, Power moves under More Metrics, cadence/power use visible lines, and selection clearing is labeled plainly.
- Changed Location display from a compact/captioned card to a prominent city row with route-estimation wording.
- Added effective-dated heart-rate-zone profiles with Automatic HRR, percent-of-maximum-HR, and Manual modes. Automatic HRR uses the latest Apple Health resting heart rate plus a six-month completed-running maximum; later changes create new snapshots instead of rewriting historical workouts.
- Installed and launched the first July 12 feature build on `AIS17PM` for testing after 308 package tests and Simulator smoke passed.
- After the follow-up recording, fixed persisted split-cache staleness by versioning derived analysis and rebuilding outdated cached rows from stored raw evidence on workout-detail hydration.
- Fixed manual-zone editing and history interactions: tappable Zone 1-5 rows, automatically contiguous adjacent limits, manual draft preservation across editor navigation, safe placement of Save Changes, and a destructive warning before resetting history.
- Quieted foreground HealthKit checks so app switching uses the persisted throttle and does not show the blocking update banner; explicit refresh still shows progress.
- Added all-years history collapse/expand behavior, one Clear Filters action, hid Power from runner-facing charts, and simplified interval comparison to a Work Rep Comparison while keeping full Work/Recovery detail.

Pending work:

- Physically verify the July 12 recording cases on the iPhone with real HealthKit data: the 11.03 km and 27.21 km cached runs rebuild to all full splits plus final partial rows, Hialeah appears as the location value, manual zone edits/save/history match Simulator behavior, foreground app switching stays quiet and responsive, and six-month HRR inputs/time-in-zone detail agree with real samples.
- Real structured interval comparison remains code/build verified and needs physical HealthKit evidence because Simulator sample data cannot render that real workout surface.
- Continue the standing physical checks for limited-history authorization, observer delivery, anchored deletions, backlog continuation, interruption/resume, Low Power Mode, thermal behavior, battery impact, and the next fresh HealthKit workout.

Mistakes and fixes:

- The first split fix corrected the algorithm but did not invalidate or rebuild older persisted derived-analysis rows, so the iPhone could still display stale ten-split results. Fixed by bumping the calculation version and rebuilding outdated cached analysis during detail hydration.
- The manual zone editor initially reinitialized the parent form after returning from a zone row and discarded an unsaved Manual draft. Fixed by separating initialization from editor navigation state.
- Simulator testing caught that the floating tab bar could intercept Save Changes in Manual mode. Fixed by moving the primary save action directly under the zone rows and leaving explanatory/history content below.
- Foreground sync still presented a blocking update banner across repeated app switches. Fixed by using the persisted last-sync date with the in-memory throttle and keeping background/foreground anchored checks quiet.

Workflow improvements:

- For cache-backed analytics fixes, test both the new computation and presentation of an older persisted row; source-code correctness alone does not prove on-device cached values changed.
- For settings forms behind a floating tab bar, run the real tap path in Simulator before handoff, especially for bottom actions like Save Changes.
- Treat "push the new app to my iPhone" as device install/run only when the user asks for testing, and keep it separate from Git commit/GitHub push.
- Preserve separate proof channels: 313 package tests and Simulator UI smoke passed, and the corrected build installed/launched on `AIS17PM`, but real HealthKit split/city/zone values remain user-visible physical-phone validation.

Docs updated:

- `docs/project-state/project-status.md`: already updated by the source implementation session with July 12 product state, next-work items, known limitations, and latest verification.
- `docs/bug-log.md`: already updated by the source implementation session with durable gotchas for derived-analysis cache versioning and foreground HealthKit sync throttling.
- `docs/project-state/daily-learning-review.md`: updated by this review with the July 12 learning summary, including lower-confidence workflow lessons and source-session evidence.

Docs not updated:

- `AGENTS.md` was not changed; existing rules already cover branch-first implementation, proof-channel separation, and physical-vs-Simulator routing.
- `docs/project-state/current-state.md`, `docs/project-state/next-work.md`, and `docs/project-state/documentation-index.md` still do not exist in this checkout. The active authority remains `docs/project-state/project-status.md`.

## 2026-07-13

Scope: reviewed Codex session logs from July 13, 2026 whose `session_meta.payload.cwd` or `turn_context.cwd` exactly matched `/Users/adrielsolorzano/Documents/Codex Projects/ios app Running Workout Analysis with Xcode & Codex`. Found five exact-cwd sessions and excluded the active daily-learning automation session. Source sessions reviewed:

- `019f5bb3-f274-7f00-9bbb-208becd9a608` at `2026-07-13T13:39:41Z`
- `019f5bcf-1995-7ea3-8c04-66d7127b4256` at `2026-07-13T14:08:48Z`
- `019f5bf3-6b17-7e32-bc46-4818f0ce60ea` at `2026-07-13T14:48:28Z`
- `019f5d15-82bf-71d1-bb2e-e5b546c8f86f` at `2026-07-13T20:05:20Z`

Completed work:

- Fixed heart-rate-zone Settings copy and actions so active profiles no longer show proposed-change wording, unsaved mode changes show Save Changes, one-profile history avoids a meaningless reset action, and `Apply Current Profile to All Workouts` opens a clearer destructive warning above the floating tab bar. Commit `1ed653c` was merged to `main` and pushed.
- Prepared a fresh physical-iPhone install for first-launch recording without opening RunSignal. The install-only session verified current `main` at `1ed653c`, a successful device build/install, RunSignal `1.0` present on `AIS17PM`, and no RunSignal process running.
- Reviewed the true first-launch recordings and confirmed the first import was working but confusing: the app stayed responsive, initially looked empty for roughly 45-50 seconds, then populated hundreds of runs; Best Efforts later advanced from partial coverage to All-Time Records after retrying four failed runs.
- Implemented first-run HealthKit onboarding on local branch `codex/first-run-healthkit-onboarding`: no demo/sample workouts on production first launch, explain-before-ask Apple Health onboarding, `Not Now` to an honest empty Runs state, state-specific Connect/Continue/Refresh actions, exact-only Best Efforts, checkpointed distance-only history verification, and no provisional estimates. Local commit `112b81f` was created but not pushed.
- Implemented the recording-driven follow-up on the same branch: transparent RunSignal mark for launch/startup/onboarding, removed backend/AI wording, shared connection/import presentation across Runs, Analytics, Settings, and heart-rate zones, partial-history and paused/failed copy, explicit failed-run Best Effort retry wording, raw-versus-visible HealthKit count semantics, duplicate-window import optimization, and 1,000/5,000-run performance fixtures.
- Installed and launched the follow-up build on `AIS17PM` as process `7133` without resetting existing app data; no commit or GitHub push was performed for that final follow-up.

Pending work:

- The current branch remains `codex/first-run-healthkit-onboarding` with local commit `112b81f` plus later uncommitted implementation, asset, test, and `project-status.md` changes from the follow-up session.
- Physically verify the true first-install path again after the latest branding/import-state follow-up: onboarding explanation before Apple's sheet, real permission choices, import progress and duration, large-history responsiveness, thermal behavior, and battery impact.
- Continue standing physical checks for limited-history authorization, observer delivery, anchored deletions, backlog continuation, interruption/resume, Low Power Mode, thermal behavior, battery impact, fresh-workout automatic processing, real city/weather, and real HealthKit split/zone/interval values.

Mistakes and fixes:

- Heart-rate-zone Settings reused proposed-change copy for the active saved profile and exposed a reset-history action even when only one profile existed. Fixed by separating active, proposed, and historical states and by renaming the destructive action.
- The floating tab bar could intercept bottom Settings actions. The July 13 heart-rate-zone fix moved the destructive action above the lower obstruction; this reinforces the July 12 lesson for bottom-of-form actions.
- First-run import progress initially blurred connected, finding runs, loading history, verifying Best Efforts, and ready states. Fixed by using one shared presentation model and by withholding misleading zero totals in Analytics while history is still currenting.
- Reinstalling the development app after deletion can trigger a one-time iPhone developer-trust gate. The build/signature was valid; the correct fix was trusting `Apple Development: aisolorzano98@hotmail.com` in iOS Settings before retrying launch.
- The source sessions kept proof channels separate: package tests, Simulator smoke, physical build/install/launch, and real HealthKit behavior were reported independently.

Workflow improvements:

- For first-launch recording prep, install-only means build and install, then perform a read-only bundle/process check and stop before launch. This preserves the true first-run app state.
- For first-run UX audits, time the visible phases from recordings and compare them with source behavior before assuming a data failure. July 13 showed a working import with poor progress communication.
- For HealthKit permission copy, RunSignal can explain read-only, on-device processing before the Apple sheet, but Apple's generic Health Access labels are system-owned; verify requested write types in code instead of judging from the sheet label alone.
- For large-history changes, add synthetic 1,000- and 5,000-run fixtures and isolate import-window merge timing so local performance regressions are visible without needing live HealthKit data.

Docs updated:

- `docs/project-state/project-status.md`: updated by the source implementation sessions with July 13 product state, latest verification, and remaining physical-iPhone proof boundaries.
- `docs/project-state/daily-learning-review.md`: updated by this review with the July 13 learning summary and source-session evidence.

Docs not updated:

- `docs/bug-log.md` was not changed by this review; the recurring lessons were already represented by existing bug-log categories or by source implementation fixes, and no new durable bug-log entry was strong enough to add on top of the dirty worktree.
- `AGENTS.md` was not changed; existing router rules already cover exact-cwd routing, branch-first implementation, install/run proof separation, and physical-vs-Simulator boundaries.
- `docs/project-state/current-state.md`, `docs/project-state/next-work.md`, and `docs/project-state/documentation-index.md` still do not exist in this checkout. The active authority remains `docs/project-state/project-status.md`.

## 2026-07-14

Scope: reviewed Codex session logs from July 14, 2026 whose `session_meta.payload.cwd` or `turn_context.cwd` exactly matched `/Users/adrielsolorzano/Documents/Codex Projects/ios app Running Workout Analysis with Xcode & Codex`. Found one exact-cwd session, but it was the active daily-learning automation session and was excluded as non-source evidence. Other July 14 logs that mentioned the repo path were excluded because their metadata/context cwd did not exactly match this checkout.

Completed work:

- No source RunSignal implementation, review, install, build, or documentation session was found for the exact cwd on July 14 after excluding the active automation log.

Pending work:

- No new repo-local pending work was discovered from July 14 exact-cwd session logs.
- Existing pending work remains governed by `docs/project-state/project-status.md`, especially the physical-iPhone first-install and real HealthKit validation items already listed there.

Mistakes and fixes:

- No new project bug, implementation mistake, toolchain failure, or fix was found in eligible July 14 exact-cwd logs.

Workflow improvements:

- Keep exact-cwd filtering strict. Text mentions of the repo path are not enough for this automation; `session_meta.payload.cwd` or `turn_context.cwd` must match the RunSignal checkout.
- Continue excluding the active daily-learning automation session from source evidence so the review does not summarize itself.

Docs updated:

- `docs/project-state/daily-learning-review.md`: updated by this review with the July 14 no-source-session result and the strict filtering note.

Docs not updated:

- `docs/project-state/project-status.md` was not changed because no new stable product state, validation status, limitation, priority, or blocker was found.
- `docs/bug-log.md` was not changed because no recurring bug, mistake, toolchain gotcha, or verification lesson was found.
- `AGENTS.md` was not changed because the current router already covers exact-cwd routing and proof-channel separation.
- `docs/project-state/current-state.md`, `docs/project-state/next-work.md`, and `docs/project-state/documentation-index.md` still do not exist in this checkout. The active authority remains `docs/project-state/project-status.md`.

## 2026-07-15

Scope: reviewed Codex session logs from July 15, 2026 whose `session_meta.payload.cwd` or `turn_context.cwd` exactly matched `/Users/adrielsolorzano/Documents/Codex Projects/ios app Running Workout Analysis with Xcode & Codex`. Found one exact-cwd session, `019f68fa-7e22-7512-8108-2c9ad11c13e4`, but it was the active daily-learning automation session and was excluded as non-source evidence.

Completed work:

- No independent RunSignal implementation, review, install, build, verification, or documentation session was found for the exact cwd on July 15 after excluding the active automation log.

Pending work:

- No new repo-local pending work was discovered from July 15 exact-cwd session logs.
- Existing pending work remains governed by `docs/project-state/project-status.md`, especially the physical-iPhone first-install path and real HealthKit validation items already listed there.

Mistakes and fixes:

- No new project bug, implementation mistake, toolchain failure, or fix was found in eligible July 15 exact-cwd logs.

Workflow improvements:

- Keep excluding the daily-learning automation session itself from source evidence; a self-summary-only day should record no new durable lessons instead of reusing the automation's own output as project evidence.
- Keep presence-checking `docs/project-state/current-state.md` and `docs/project-state/next-work.md`; both remain absent in this checkout, so `docs/project-state/project-status.md` is still the active status and next-work authority.

Docs updated:

- `docs/project-state/daily-learning-review.md`: updated by this review with the July 15 no-source-session result and the self-exclusion note.

Docs not updated:

- `docs/project-state/project-status.md` was not changed because no new stable product state, validation status, limitation, priority, or blocker was found.
- `docs/bug-log.md` was not changed because no recurring bug, mistake, toolchain gotcha, or verification lesson was found.
- `AGENTS.md` was not changed because no new durable routing or tooling rule was found.
- `docs/project-state/current-state.md`, `docs/project-state/next-work.md`, and `docs/project-state/documentation-index.md` still do not exist in this checkout. The active authority remains `docs/project-state/project-status.md`.

## 2026-07-17

Scope: reviewed Codex session logs from July 17, 2026 whose `session_meta.payload.cwd` or `turn_context.cwd` exactly matched `/Users/adrielsolorzano/Documents/Codex Projects/ios app Running Workout Analysis with Xcode & Codex`. Found 27 exact-cwd files representing 26 unique session IDs; excluded the active daily-learning automation session. Source logs reviewed represented 25 unique source session IDs, including main sessions and user-authorized audit/worker sessions from the branch cleanup, HealthKit split evidence, unit-display, and sharing-flow work.

Completed work:

- Resolved the branch/worktree confusion around `codex/add-change-decision-ledger`: audits found no committed divergence from `main`/`origin/main`, preserved all uncommitted files, verified no conflict markers or obvious secret/scratch artifacts, and pushed the phone-matching source to GitHub `main` at `f5cc0cf`.
- Released the legacy distance-split and physical evidence pass at `c44efb6` after 355 package tests, physical `AIS17PM` install/launch proof, and iPhone Mirroring verification of corrected January 2019 split rows, outdoor/indoor filtering, and independent 2020/2021/2026 real-workout comparisons.
- Reconciled HealthKit split evidence semantics: laps are the documented equal-distance event, segments are period-of-interest events, distance samples are windowed contributions rather than odometer points, and whole-workout-average repeated splits must not be shown as strong normal-split evidence.
- Designed and implemented the miles/kilometers display system on `codex/run-units`, then promoted it to `main` at `c5a8035`. The app keeps meters, seconds, and canonical seconds/km internally while user preference controls runner-facing distance, pace, charts, normal split basis, and selected secondary summaries.
- Preserved authored WorkoutKit prescription provenance beside canonical meters, including mixed `400 m`, `800 m`, and `1 mi` rows; fixed Interval Library aggregate semantics so completed fixed-distance Work uses prescribed distance, shortened rows stay measured-only, and mixed/open goals avoid hybrid denominators.
- Fixed legacy cached pace-target presentation so explicit `/km` and `/mi` strings convert under the selected display policy without changing canonical target evaluation.
- Added truthful final-only mile splits for detailed sub-mile runs while retaining the established one-full-kilometer threshold for kilometer splits.
- Added display-policy and runner-facing leakage tests, then verified the final units build with 392 package tests, Simulator build/install/launch, and physical iPhone Mirroring across all four display modes.
- Started a separate run-sharing branch and drafted the core share flow: Summary, Splits, and Workout Reps cards, Story/Post sizing, route/no-route handling, pagination, system sharing, and add-only Photos saving.
- Performed a physical iPhone UI audit after the units release: 386 package tests passed for that audit source, `AIS17PM` build/install/launch and relaunch persistence passed, and the app was restored to Miles primary with secondary kilometers on.

Pending work:

- The current working tree is dirty with run-sharing source and tests; that feature still needs compilation, permission-path testing, physical UI review, and an explicit commit/push decision before it is treated as done.
- The physical unit regression matrix still needs the paused January 14 normal-split case and the full June 30 mixed Work/Recovery/Open case checked in both primary units if not covered by a later dedicated pass.
- The true first-install HealthKit path remains a physical-phone validation item: onboarding before Apple's sheet, 2019-present summary import continuation, distance-only Best Effort coverage completion, interaction, thermal state, and battery impact.
- Secondary-unit presentation is correct functionally, but the physical audit found compact cards can still feel dense with primary plus secondary values; this is a UI polish candidate, not a blocker.
- Standing physical HealthKit checks remain: limited-history authorization, observer delivery, anchored deletions, backlog continuation, interruption/resume, Low Power Mode, thermal behavior, battery impact, fresh-workout automatic processing, real city/weather, and real split/zone/interval values.

Mistakes and fixes:

- `push live` was initially blocked by an unbooted Simulator even though package tests and physical install/launch had passed. The later run used XcodeBuildMCP to satisfy the Simulator gate before committing, merging, deleting the feature branch, and pushing.
- The messy branch state was mostly uncommitted work rather than committed divergence. Future cleanup should first prove branch topology, then classify dirty files, then decide whether the source matches the installed phone build.
- A docs-only clarification was needed for history-import progress: the visible date-window counter restarts per continuation pass over remaining windows, while the persisted cursor and imported runs remain correct.
- Earlier split reasoning over-weighted segment chains. The durable rule is lap/segment/event-chain first only when fully validated against public distance evidence, then windowed distance accrual, and never fabricated repeated rows from whole-run average.
- Unit preferences could have leaked into domain math if treated as a global setting. The implemented fix keeps display preferences outside HealthKit ingestion, analytics caches, target evaluation, and Best Efforts.
- Cached target strings with explicit `/km` or `/mi` needed strict parsing and conversion; opaque text remains untouched.

Workflow improvements:

- For device/source identity questions, inspect build logs for compiled untracked files and keep a source fingerprint, because version/build `1.0/1` is not enough to prove which dirty source is installed.
- For unit work, add a self-tested runner-facing string leakage guard before exposing the picker; every visible surface must be converted before the preference is user-facing.
- For normal splits, keep source/provenance visible in diagnostics. Confidence labels are not a substitute for carrying the actual evidence path.
- For physical UI audits, record the restored display preference state and separate code changes from read-only audit findings.
- For sharing or Photos work, treat add-only photo saving and system share-sheet paths as separate permission/interaction proof channels.

Docs updated:

- `docs/project-state/daily-learning-review.md`: updated by this review with the July 17 cross-session learning summary because it consolidates strong source-session evidence while avoiding unnecessary edits to routing-critical docs.

Docs not updated:

- `docs/project-state/project-status.md` was not changed by this review because the source sessions already updated the current product state, next work, known limitations, and latest verification for July 17.
- `docs/bug-log.md` was not changed because the durable mistakes are already represented by existing bug-log categories or by source-session fixes; this review found no new recurring bug class that needed promotion beyond the daily synthesis.
- `AGENTS.md` was not changed because existing rules already cover exact-cwd routing, branch-first implementation, push-live semantics, proof-channel separation, and physical-vs-Simulator boundaries.
- `docs/project-state/current-state.md`, `docs/project-state/next-work.md`, and `docs/project-state/documentation-index.md` still do not exist in this checkout. The active authority remains `docs/project-state/project-status.md`.
