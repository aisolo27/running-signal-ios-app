# RunSignal Daily Learning Review

## 2026-06-23

Scope: reviewed Codex session logs from the prior local day whose `cwd` exactly matched this repo. Found 19 matching RunSignal sessions.

### Completed Work

- Created the `runsignal-daily-learning-review` daily automation and verified its repo-scoped prompt guardrails.
- Closed the Gate B recovery/tail cleanup wave: AIS-30 through AIS-35 were reported complete, AIS-14 was marked Done in Linear, and `main` was reported clean and aligned with `origin/main`.
- Added or updated Gate B evidence docs around repeat-tail taxonomy, broad recovery tails, paused repeat `Open / Extra` tails, ambiguous repeat-tail decision rules, timer drift materiality, and interval analytics readiness.
- Updated app/debug surfaces for custom-workout comparison and diagnostics, then pushed the repo through the latest documented state.
- Built, installed, and launched the app on physical iPhone `AIS17PM` with bundle id `com.adrielsolorzano.runninganalysis`.

### Pending Work

- Use `ambiguous-repeat-tail-decision-rules-2026-06-24.md` before any repeat-tail prototype or scorecard work.
- Next implementation should stay narrow: paused repeat fixed-tail `Open / Extra` first, then broader recovery-tail variants, then warmup/work/cooldown special cases.
- Keep interval-row analytics blocked until row reconstruction, diagnostics agreement, and regression fixtures are stable for the relevant custom-workout shapes.

### Mistakes, Fixes, And Friction

- A read-only audit found a loose/stale `next-work.md` phrase around fixed-cooldown repeat tails; later state docs now distinguish approved clean fixed-tail cases from still-blocked ambiguous tails.
- Several scouts explicitly avoided running write-producing validation refresh scripts until the scope required them. Keep treating `score_gate_b_custom_workout_fit.py` and scorecard refreshes as artifact-writing checks.
- Physical-device proof succeeded only after using the device workflow with explicit iPhone targeting; keep reporting whether proof came from Simulator or the physical iPhone.

### Durable Workflow Lessons

- Start Gate B work from the current project-state docs, then the specific decision/evidence doc for the candidate shape. Avoid broad Gate B implementation prompts.
- Keep FIT/HealthFit as offline validation evidence only; runtime product behavior remains HealthKit and WorkoutKit sourced.
- For daily learning review output, prefer this note when an observation is useful but already covered by routing-critical docs or not strong enough for `AGENTS.md`, `current-state.md`, `next-work.md`, or `bug-log.md`.

### Docs Updated By This Review

- Added this daily review note to preserve the compact prior-day summary without rewriting already-current routing docs.
- Updated `docs/project-state/documentation-index.md` to list this review log.

No `AGENTS.md`, `docs/bug-log.md`, `docs/project-state/current-state.md`, or `docs/project-state/next-work.md` edits were made by this review because the durable June 23 lessons were already represented there.

## 2026-06-25

Scope: reviewed seven completed Codex session logs whose `session_meta.payload.cwd` exactly matched this repo. Excluded the active review session even though it was stored in the June 25 session folder.

### Completed Work

- Archived and reviewed June 25 user-supplied `Thursday Interval 5km` repeat fixed-cooldown/Open-tail evidence in `docs/archive/old-validation/user-supplied-repeat-tail-review-2026-06-25/`.
- Confirmed the re-exported proof folder passes fresh readable-label validation and that FIT offline evidence shows a session-minus-laps tail residual.
- Confirmed the active paired-pause fixed-tail blocker remains open because the June 25 evidence reports `pairedPauseCount == 0`.
- Scanned the Jan-Jun HealthFit FIT archive and documented 124 parsed outdoor running FIT files with zero exact paired-pause fixed-tail repeat matches.
- Created and validated the external reviewer context-packet skill outside this repo.

### Pending Work

- The next qualifying proof still needs a deliberate exact-shape workout: `Warmup(2 km) > repeated Work/Recovery rows > fixed final Cooldown > inferred Open / Extra`, plus real paired pause/resume evidence, Raw HealthKit Debug export, parity packet, FIT, and Apple Fitness rows.
- Do not request broad Jan-Jun Raw HealthKit Debug/parity exports unless a future task names a specific edge case; the broad FIT scan did not find the active blocker.
- Keep Parity Lab/debug candidates separate from production normal-detail support until exact-shape tests and proof tools agree.

### Mistakes, Fixes, And Friction

- Stale on-device exports can look structurally useful but fail the fresh-proof gate when `fallbackReasonLabels` are absent; current-build re-export is required before treating proof as current.
- Independent read-only audits found proof-tool risks: candidate-only proof could be summarized as target evidence, validator exit-code semantics were muddy, and unfenced `.md` parity JSON could be skipped.
- Independent read-only audits also flagged product/data risks: HealthKit authorization completion wording can overstate grants, source/date sample fallback needs explicit provenance, and clear-first refresh can erase cached debug evidence if the fresh query fails.
- Custom-workout audit reminders: unpaired pause evidence must not satisfy no-pause gates, debug/export comparison predicates must stay narrower than exact-shape contracts, and Parity Lab labels should not contradict real normal-detail eligibility.

### Docs Updated By This Review

- Updated `docs/bug-log.md` with durable June 25 audit lessons around HealthKit authorization/provenance, refresh cache safety, and proof summarizer/validator contracts.
- Added this June 25 daily review note. No `AGENTS.md`, `docs/project-state/current-state.md`, `docs/project-state/next-work.md`, or `docs/project-state/documentation-index.md` changes were needed because current routing already reflects the stable blocker and validation state.

## 2026-06-26

Scope: reviewed 15 Codex session logs whose `session_meta.payload.cwd` exactly matched this repo for June 26 local work. The day was dominated by external-review/Claude closeout checks, multi-agent consensus, and proof-folder/state-doc hardening around the paused repeat fixed-tail `Open / Extra` case.

### Completed Work

- Added June 26 physical-iPhone proof for the exact paired-pause repeat fixed-tail `Open / Extra` row in `docs/validation/apple-fitness-interval-parity-dataset/physical-iphone-paused-repeat-fixed-tail-open-extra-proof-2026-06-26/`.
- Updated the project state docs to route that proof as rung 2 `Evidence Available` only: evidence is strong for the exact shape, but it does not promote normal detail, broaden Gate B, or change Swift behavior.
- Added normal-detail guard audit tests and landed the proof/state-doc work on `main` in commits `7cafb35` and `283f349`.
- Used external-review and multi-agent passes to check Claude closeout feedback; consensus was to keep the patch lightweight, cite the proof folder and negative-scope docs, and avoid converting reviewer suggestions into broad promotion.

### Pending Work

- Decide whether the exact June 26 row is enough for rung 3 `Debug-Supported`, or whether a second qualifying physical example is required before Swift prototype work.
- Keep adjacent guard coverage explicit before any promotion attempt: zero-pause same-template control, cross-boundary pause rejection, and `Cooldown(Open)` counter-case.
- Continue treating ambiguous repeat tails, broad recovery tails, and paused warmup/work/cooldown timer outliers as blocked unless a later task names one exact shape and walks the promotion ladder.

### Mistakes, Fixes, Friction

- Review friction came from citation asymmetry: positive proof was easy to cite, but negative scope needed explicit links back to blocked ambiguity/recovery/outlier docs so Claude-style feedback could not be read as promotion approval.
- The repeated lesson is to label June 26 as `Evidence Available`, not `Debug-Supported`, and to keep FIT/HealthFit evidence validation-only rather than runtime truth.

### Workflow Improvements

- Faster future closeouts should start with `docs/project-state/accuracy-ledger.md`, then the proof-folder `README.md`, then `current-state.md`/`next-work.md`; avoid reopening broad validation archives unless the exact proof folder or ledger points there.
- For outside review packets, include both the exact positive row and the negative-scope citations in the same packet so reviewer feedback cannot drift into broad Gate B claims.

### Docs Updated

- Added this June 26 daily review note.
- No new `docs/bug-log.md` entry was needed: June 26 reinforced existing proof validation, pause-gating, and scope-control lessons already captured in the bug log.
- No `AGENTS.md`, `docs/project-state/current-state.md`, `docs/project-state/next-work.md`, or `docs/project-state/documentation-index.md` changes were needed during this review because those docs already reflect the stable June 26 rung 2 state and routing.

## 2026-06-27

Scope: reviewed 20 Codex session logs from June 27 whose `cwd` exactly matched the RunSignal iOS repo. Treated this as a docs-only learning review and did not run Xcode, device installs, HealthKit queries, or provider mutations.

### Completed Work

- Health Context work reached `main` in `d34d75f Add read-only health context signals`: VO2 Max/Cardio Fitness and Resting Heart Rate are optional read-only signals, neutral unavailable wording is in place, package tests passed, and the app was installed/launched on physical iPhone `AIS17PM`.
- Physical-device follow-up found an important proof boundary: a successful `build_run_device` is not enough when the phone shows the black launch screen and returns Home. Treat that as a launch crash until logs or app-visible proof say otherwise.
- Best Efforts work clarified that visible official PR buckets must come from exact evidence-backed records, while summary-only whole-run estimates stay out of the official all-time list. Historical PR misses can be evidence-coverage problems before they are math problems.
- Cached-first HealthKit refresh work moved from critique/planning into implementation evidence: monthly refresh preserves existing cached evidence when replacement queries fail or return empty/no-evidence, persists month/job item checkpoints, retries failed items without rerunning successes, and recomputes stale derived analytics when cached raw-evidence signatures drift.
- Raw HealthKit Debug/monthly diagnostics were expanded to expose refresh job state, progress/failure counts, resume/retry controls, derived refresh metadata, interrupted-relaunch recovery proof text, and a physical interruption proof checklist.

### Pending Work

- Verify VO2 Max/Cardio Fitness and Resting Heart Rate on the physical iPhone after Apple Health read access. Missing values remain unavailable Apple Health data, not proof of denied permission.
- Run the refresh interruption proof on the physical iPhone and archive diagnostics/log evidence before claiming observer delivery, background tasks, or full lifecycle behavior.
- Keep observer delivery and background refresh blocked until the cached-first foreground/resumable path has physical proof.
- Add or confirm a PR-candidate enrichment path for older benchmark runs before changing visible Best Efforts math.
- Address the read-only QA finding that repeated completed-month refresh behavior needs a clear contract: repeated completed runs should either create a new job intentionally or have documented idempotent reuse semantics.

### Mistakes, Fixes, And Friction

- Do not equate install/build success with app-visible physical proof. Black-screen-to-Home must be handled as a crash signal, especially when real HealthKit cache size can expose work the Simulator misses.
- Avoid heavy analytics or refresh work directly in SwiftUI body paths; prefer cached store recompute/update paths.
- Keep HealthKit runtime truth separate from FIT, HealthFit, screenshots, and web comparison evidence. June 27 work did not change the no-FIT-runtime-ingestion direction.
- Multi-agent refresh review was useful, but broad raw transcript/search output can pull unrelated sessions. Future reviews should filter by exact `turn_context.cwd` before text searching for topic phrases.

### Docs Updated By This Review

- Added this June 27 section to `docs/project-state/daily-learning-review.md`.
- Did not edit `docs/bug-log.md`, `docs/project-state/current-state.md`, `docs/project-state/next-work.md`, `AGENTS.md`, or `docs/project-state/documentation-index.md` in this review because those routing-critical docs already had uncommitted June 27 edits. The daily review records the durable lessons without overwriting unrelated work.

## 2026-06-28

Scope: reviewed 16 Codex session logs from June 28 whose `session_meta.payload.cwd` or `turn_context.cwd` exactly matched this RunSignal repo. Treated this as a docs-only learning review: no Xcode builds, device installs, HealthKit queries, provider mutations, commits, pushes, or broad repo scans.

### Completed Work

- Landed resumable HealthKit refresh in `ab3d97b`: month-scoped job/item checkpoints, resume/retry UI, diagnostics export fields, interrupted-relaunch proof text, and package tests for the new refresh flow.
- Landed foreground HealthKit sync performance fixes in `31bb7a5`: app-active sync remains lightweight, bounded, and anchored instead of becoming an unbounded first-history query or full recompute path.
- Landed paused repeat-tail normal-detail support in `5b5ce0e` with physical-iPhone Priority proof fixtures for the narrow fixed-cooldown `Open / Extra` class.
- Consolidated `docs/project-state/current-state.md` and `docs/project-state/next-work.md` into `docs/project-state/project-status.md` in `3fa8e75`, then updated routing docs to point at the single project-status file.
- Landed resolved custom-workout interval rows in `bd645f1`: normal detail can use generalized evidence-gated resolved rows while Parity Lab/debug views remain available for inspection.
- Ran multiple read-only architecture/HealthKit/cache audits around thermal risk, background behavior, and foreground return behavior; consensus was that RunSignal has local cache, anchored incremental sync, resumable foreground refresh, prioritization, checkpointing, and derived recompute, but not a proven true iOS background-processing pipeline.

### Pending Work

- Run the refresh interruption and activation/scroll/thermal proof on the physical iPhone before promoting observer delivery, background tasks, or full lifecycle behavior.
- Keep automatic foreground/open work limited to cheap anchored deltas and paused-job state repair; keep monthly evidence refresh, route/evidence backfill, parity re-enrichment, stale-derived recompute, failed-item retry, and debug/proof export behind explicit user-visible controls.
- Finish or schedule the PR-candidate historical evidence backfill so older benchmark Best Efforts can move from summary-only gaps to exact HealthKit distance-window evidence.
- Future background work should start as a separate, cancellable, checkpointed worker only after the foreground resumable path has physical proof.

### Mistakes, Fixes, And Friction

- Several prompts and prior daily-review wording still referenced the deleted `current-state.md`/`next-work.md` split. The current routing file is `docs/project-state/project-status.md`; future automations should start there unless this repo reintroduces split state docs.
- The repeated performance lesson is that app launch/return must not do broad HealthKit history pulls, route loading, evidence normalization, monthly refresh, derived cache maintenance, or whole-store recompute by accident.
- Read-only audit output can be useful but noisy when parent/subagent sessions and copied repo paths are mixed together. Exact `session_meta.payload.cwd`/`turn_context.cwd` filtering remains the right first pass.

### Docs Updated By This Review

- Added this June 28 section to `docs/project-state/daily-learning-review.md`.
- Did not edit `docs/bug-log.md`, `docs/project-state/project-status.md`, `AGENTS.md`, or `docs/project-state/documentation-index.md` because the durable June 28 foreground-sync, refresh, interval-row, and routing lessons were already captured there by the June 28 implementation/doc commits.

## 2026-06-29

Scope: reviewed the June 29 Codex session logs whose `cwd` exactly matched this RunSignal repo. Excluded the active automation session. Treated this as a documentation-only learning review: no Xcode builds, device installs, HealthKit/provider mutations, commits, pushes, or broad repo scans.

### Completed Work

- Landed stopped-early Parity Lab/debug cleanup in `7bdf160`: completed-prefix row labels, structured comparison against the completed prefix, summary-level shared caveats, and package-test coverage. Physical iPhone install/run on `AIS17PM` had succeeded before the push.
- Clarified the current Parity Lab status for planning: resolved activity-boundary rows are now aligned across Parity Lab, Raw Debug, and normal detail when evidence gates pass, while broad promotion remains blocked by missing/invalid public evidence.
- Reviewed Priority 4/5 physical proof direction: Priority 4 remains a clean control, and Priority 5 is useful specifically because it combines a paired pause inside a planned Work row with a manual skip before natural completion.
- Verified the Priority 5 Raw Debug UI source mismatch was fixed in commit `1bd675c`: the recording showed `Candidate activity boundaries`, coherent Work/Cooldown/Open rows, and raw HealthKit segment markers still labeled raw-debug-only.
- Parsed the Jan-Jun monthly diagnostics sweep: `136/136` refreshes completed, `114/114` planned custom workouts had scoreable HealthKit activity-boundary rows, and `0` planned workouts were non-scoreable in the activity-boundary summary.
- Created a paste-ready handoff for approving the generalized WorkoutKit planned rows plus HealthKit activity-boundary resolver as the v1 official custom-workout row source under evidence gates.
- Began implementing that handoff in a later session: docs/app/export wording was updated, supported structured comparisons now set production-promotion metadata, focused regressions and the full package suite passed, and a Simulator smoke check rendered the Runs tab successfully. Those changes remain uncommitted at review time.

### Pending Work

- Commit/push or otherwise finish review of the late June 29 uncommitted resolver-wording and export-metadata changes after confirming the current dirty worktree still matches intent.
- Keep Raw HealthKit Debug as audit/evidence tooling, but remove stale `debug-only`, `candidate`, `not production`, and `normal UI unchanged` wording where it refers to resolved activity-boundary rows that now feed normal detail when evidence gates pass.
- Keep fallback guards for missing plans, missing/incomplete/non-contiguous activity rows, rows exceeding the plan, unpaired/cross-row pauses, duplicates, plain open runs, and stale summary-only evidence.
- Move next product work toward interval analysis only after the v1 row-source wording and metadata cleanup is stable: target hit/miss, repeat consistency, work/recovery pacing, HR response, cadence/power by interval, and warmup/cooldown quality.

### Mistakes, Fixes, And Friction

- The automation prompt still referenced deleted `current-state.md` and `next-work.md`; this repo now routes current state and next work through `docs/project-state/project-status.md`.
- iPhone Mirroring screen recording did not reliably capture semantic UI proof. For physical-iPhone diagnostics, exported files and screenshots are the reliable evidence path; event-stream/screen-mirror capture can be supplemental only.
- The same bug pattern repeated: correct resolver math can be hidden by stale UI/export metadata. Supported comparison status and `promotesProductionBehavior` must stay derived from the same resolver status.
- Do not ask for more examples once a representative real-workout diagnostics sweep clears the bar; use the sweep to update wording and move into product features.

### Workflow Improvements

- Start future custom-workout state answers with `docs/project-state/project-status.md`, then `docs/project-state/accuracy-ledger.md` only for shape/promotion specifics.
- For paused/custom interval proof, compare the same row across normal detail, Raw Debug resolved rows, exported JSON, and Apple Fitness evidence; check row source, header, duration basis, pause overlap, active/timer duration, distance, pace, and label together.
- When reviewing diagnostics exports, aggregate the machine-readable fields first, then inspect exceptions so no-plan, duplicate, and plain open runs are not mistaken for custom-workout failures.

### Docs Updated By This Review

- Added this June 29 section to `docs/project-state/daily-learning-review.md`.
- Did not edit `docs/bug-log.md`, `docs/project-state/project-status.md`, `docs/project-state/accuracy-ledger.md`, `AGENTS.md`, or `docs/project-state/documentation-index.md` in this review because those routing-critical docs already had unrelated active edits from the late implementation session, and the durable bug-log/status changes were already present in that dirty worktree.

## 2026-06-30

Scope: reviewed June 30 Codex session logs whose `session_meta.payload.cwd` or `turn_context.cwd` exactly matched this RunSignal repo. Excluded copied repo paths inside prompts and the active automation session. Treated this as documentation-only review: no Xcode builds, device installs, HealthKit/provider mutations, commits, pushes, or broad repo scans.

### Completed Work

- Landed interval status agreement in `3c18f01`: normal detail now uses a cleaner `Intervals under review` fallback with a `View Interval Evidence` path, Raw Debug/export labels distinguish `Official Interval Rows`, `Resolved Row Evidence`, and `Not promoted yet`, and the zero-pause June 30 fixed-cooldown `Open / Extra` review no longer implies unpaired-pause evidence.
- Landed first-pass analytics and chart surfaces in `7303369`: an `Analytics` tab with weekly distance/run/pace summaries, daily bars and purpose totals, plus Swift Charts-backed workout detail cards and interval drill-down behavior limited to official promoted rows.
- Landed repo cleanup in `fac8936`: removed unrouted legacy SwiftUI screens and an unused workout-series wrapper, updated README routing away from deleted `current-state.md` / `next-work.md`, and expanded `.gitignore` for local generated Xcode/test scratch outputs while preserving validation evidence.
- Read-only cleanup subagents produced useful source/test and artifact hygiene recommendations before the cleanup commit; evidence archives, screenshots, exports, diagnostics, and validation fixtures remained preserved.

### Pending Work

- Physical-iPhone proof is still needed for real HealthKit weekly analytics, chart rendering, and one official interval drill-down before treating the new analytics slice as app-visible validated behavior.
- Re-export the June 30 fixed-cooldown `Open / Extra` workout from a current build to confirm visible and exported status labels agree with the official resolved-row source.
- Continue treating repo cleanup as an audit track: inventory and classify before any archive/delete move, and do not delete curated validation evidence without explicit approval.

### Mistakes, Fixes, And Friction

- Exact-cwd review must parse JSON fields, not plain `rg` path hits: one June 30 subagent log contained the RunSignal path in a prompt but had a different `cwd`, so text-search alone would have overcounted it.
- The daily automation prompt still names deleted `current-state.md` and `next-work.md`; the current router is `docs/project-state/project-status.md`, with this file as the lower-risk place for dated review notes.
- UI evidence wording can look contradictory when normal detail, Raw Debug, and export labels do not share the same support status. Keep status summary, visible labels, and export copy aligned in the same change.

### Workflow Improvements

- For daily reviews, start with `project-status.md` when the legacy split state files are absent, then only read `accuracy-ledger.md` if the day involves shape/promotion specifics.
- For cleanup requests, run separate code and repo-artifact audits first, then remove only low-risk stale code/artifacts with tests; keep evidence/history folders out of deletion scope unless explicitly approved.
- For product proof, keep simulator/package success separate from physical-iPhone app-visible proof, especially for real HealthKit analytics and interval drill-down behavior.

### Docs Updated By This Review

- Added this June 30 section to `docs/project-state/daily-learning-review.md`.
- Did not edit `docs/bug-log.md`, `AGENTS.md`, or `docs/project-state/documentation-index.md`: June 30 durable state and bug-log lessons were already captured by commits `3c18f01`, `7303369`, and `fac8936`. Removed the unrelated malformed duplicate `docs/project-state/project-status 2.md` before publishing this review.

## 2026-07-01

Scope: reviewed July 1 Codex session logs with JSON-field `session_meta.payload.cwd` or `turn_context.cwd` exactly equal to this RunSignal repo. Excluded copied repo paths inside unrelated prompts and excluded the active automation session. Treated this as documentation-only review: no Xcode builds, device installs, HealthKit/provider mutations, commits, pushes, or broad repo scans.

### Completed Work

- Landed interactive interval-analysis charts in `0c05222`: workout detail now shows a HealthFit-inspired `Interval Analysis` overview for official promoted interval rows, including work-row aggregate metrics, per-row bars for pace, heart rate, power, cadence, duration, and distance, shared chart scrub selection, pause-aware active-timer pace, and the existing Apple-Fitness-like row list/drill-down below it.
- Kept interval analysis source-gated: official promoted rows are chart/drill-down eligible, while under-review evidence rows and raw/debug candidates stay out of product drill-down.
- Added model/view and test coverage in `AnalyticsSummary.swift`, `AnalyticsViews.swift`, `Views.swift`, and `AnalyticsSummaryTests.swift`.
- Updated `docs/project-state/project-status.md` during implementation to record the July 1 interval-analysis slice and remaining proof boundary.

### Pending Work

- Run fresh physical-iPhone semantic proof for the new interval charts on a workout whose official resolved rows are promoted, comparing visible chart values, scrub selection, and drill-down values against Raw Debug/exported resolved rows.
- Keep the July 1 implementation status separate from physical HealthKit proof: `swift test`, whitespace checks, commit, push, and an earlier physical launch do not prove the new interval chart semantics on real data.

### Mistakes, Fixes, And Friction

- Text search for the RunSignal repo path overcounted July 1 sessions because unrelated prompts copied the RunSignal AGENTS block. Use JSON-field cwd filtering first, then inspect matched logs.
- The automation prompt still names deleted `current-state.md` and `next-work.md`; the active router is `docs/project-state/project-status.md`. Lower-confidence dated review notes belong here.

### Workflow Improvements

- For future daily reviews, filter session logs by exact JSON cwd before grepping for topics or final summaries.
- For interval-chart work, keep the proof checklist tied to one promoted-row workout: normal detail chart, interval row list, interval drill-down, Raw Debug/exported resolved rows, and Apple Fitness evidence where available.

### Docs Updated By This Review

- Added this July 1 section to `docs/project-state/daily-learning-review.md`.
- Did not edit `docs/bug-log.md`, `AGENTS.md`, or `docs/project-state/documentation-index.md`: no new recurring gotcha or routing rule was stronger than existing bug-log/project-status entries.

## 2026-07-02

Scope: reviewed July 2 Codex session logs with JSON-field `session_meta.payload.cwd` or `turn_context.cwd` exactly equal to this RunSignal repo. Excluded copied repo paths inside unrelated prompts and excluded the active automation session. Treated this as a documentation-only review: no Xcode builds, device installs, HealthKit/provider mutations, commits, pushes, or broad repo scans.

### Completed Work

- Landed interval-analysis and analytics-period expansion in `b0776f0`: the HealthFit-inspired interval analysis moved toward a dedicated touch-first view, period summaries expanded beyond week-only to Week, Month, Year, and All-Time, and `docs/validation/healthfit-interval-ui-reference.md` was added as the local reference-note companion to ignored screen-recording media.
- Fixed terminal pause interval promotion in `b53a2cc`: a zero-duration terminal `HKWorkoutEventType(rawValue: 1)` no longer blocks otherwise valid fixed-cooldown plus `Open / Extra` custom-workout promotion, while real dangling/cross-row pause evidence remains blocked.
- Hardened custom-workout interval promotion in `0700f04`: generalized resolved activity-boundary promotion, export/status alignment, fallback wording, and regression coverage for the six-work-repeat fixed-cooldown plus `Open / Extra` shape. The push-live run reported `swift test --package-path RunningWorkoutAnalysisPackage` passing with `225 tests`, committed on `main`, pushed to `origin/main`, and left the working tree clean.
- Physical iPhone build/install/launch proof was reported for `AIS17PM`, but visible semantic UI snapshot proof was Simulator-only because the available snapshot tool still targeted the Simulator after the device run.

### Pending Work

- On the physical iPhone, use `Settings > Load HealthKit Runs` after a fresh install before judging real-data screens such as Best Efforts, analytics periods, or custom workout interval promotion.
- Capture fresh app-visible physical-iPhone proof for the July 2 interval/analytics changes: promoted official interval rows, touch/scrub behavior, period summaries, and values compared against Raw Debug/exported resolved rows where available.
- Continue keeping supported official rows and under-review evidence distinct: official custom-workout blocks should appear only when `CustomWorkoutNormalDetailGate.supportedIntervals` returns rows; unsupported or incomplete evidence should remain whole-run/under-review.

### Mistakes, Fixes, And Friction

- A terminal zero-duration rawValue 1 marker looked like a dangling pause when the resolver considered pause events without enough workout-end context. The durable rule is now in `docs/bug-log.md`: ignore only zero-duration rawValue 1 markers at the exact workout end, while preserving blocks for real dangling/cross-row pause streams.
- Several read-only subagent findings were useful, but their outputs mixed current-source behavior, exported proof, and possible stale installed-build evidence. Future reviews should separate source inspection, current-build export evidence, and physical UI proof before calling a UI gate broken.
- `push live` followed repo policy correctly for this project: verify, commit to `main`, push `main`, and report no feature branch cleanup when already on `main`.

### Workflow Improvements

- For custom-workout promotion bugs, start with the structured export fields: candidate row count/source, comparison status, `promotesProductionBehavior`, `normalWorkoutUIChanged`, fallback reasons, tail ambiguity, and pause-event exclusions. Then inspect source only where those fields disagree.
- For physical-device proof, keep build/install/launch success, Simulator screenshot proof, and actual physical-iPhone semantic proof as separate evidence levels in summaries.
- When a screen recording or HealthFit reference drives UI direction, keep runtime ingestion out of scope; use it as a design reference only and store tracked metadata/notes rather than committing local media.

### Docs Updated By This Review

- Added this July 2 section to `docs/project-state/daily-learning-review.md`.
- Did not edit `docs/bug-log.md` or `docs/project-state/project-status.md`: July 2's durable terminal-pause rule, interval-promotion state, and analytics-period state were already captured by the landed commits.
- Did not edit `AGENTS.md` or `docs/project-state/documentation-index.md`: no new routing rule or doc classification stronger than the existing entries emerged from this review.

## 2026-07-03

Scope: reviewed July 3 Codex session logs with JSON-field `session_meta.payload.cwd` or `turn_context.cwd` exactly equal to this RunSignal repo. Excluded copied repo paths inside prompts and excluded the active July 4 daily-learning automation session. Treated this as a documentation-only review: no Xcode builds, device installs, HealthKit/provider mutations, commits, pushes, or broad repo scans.

### Completed Work

- Improved recording-driven UI readability and interaction: dark-mode run metadata contrast was raised, workout charts gained scrub/clamped sample-range behavior plus interval-boundary markers, Interval Analysis now starts with the whole official-row breakdown, and Best Effort rows can navigate to source workout detail when loaded.
- Added manual run categorization for Analytics: visible per-row category controls, period year/current-period navigation, bulk Select actions, persisted `manualRunType` writes, and batched bulk apply to avoid all-history UI freezes.
- Added trust-first workout review UX: Runs readiness, workout-detail review, plain-language Best Effort trust labels, and interval execution summary behavior, with package tests plus Simulator proof and physical iPhone install/run reported.
- Cleaned repo evidence shape: ignored local junk and the large local HealthFit video were removed, completed validation archives moved under `docs/archive/old-validation/`, and active validation folders stayed focused.
- Hardened HealthKit data quality and ingestion: full-history summary loading replaced the newest-250 ceiling, impossible best-effort segment paces are rejected, indoor/outdoor expected-data capability profiles were added, native `HKWorkoutActivity` stats are preferred when reconciled, and foreground/background-ready ingestion now has batch/deletion/anchor/import-job hardening.

### Pending Work

- Real HealthKit semantic proof still needs on-phone checking after installs because available UI snapshot paths can still target Simulator after a physical-device run.
- After fresh installs or when all-time history looks incomplete, use `Settings > Load HealthKit Runs` before judging Best Efforts, Analytics year navigation, or custom-workout screens.
- Measure the new import/foreground/background-ready ingestion path on the physical iPhone: large history duration, observer delivery, anchored deletions, scroll responsiveness, Low Power Mode, thermal behavior, cancellation, and battery impact.
- Keep target-vs-actual, deeper trend claims, and interval analytics expansion gated until the new typed target metadata, native activity stats, and evidence-quality provenance have physical proof and regression coverage.

### Mistakes, Fixes, And Friction

- Bulk Analytics categorization initially risked freezing multi-year histories because selection writes could save/recompute per row; the durable fix is batch persistence plus one analytics recompute.
- Simulator sample data hid physical-phone risks: visual UI proof, install success, and real HealthKit semantic proof must remain separate evidence levels.
- All-Time Best Efforts can look wrong for two different reasons: incomplete detailed distance-series enrichment or corrupt/bursty distance samples. Fix evidence coverage first, but reject impossible exact segment paces when the loaded series itself is bad.
- Pull-to-refresh and app-active sync can become expensive if they drift into full history/detailed-evidence work. Foreground deltas should stay summary-only and anchored; full history remains explicit and resumable through `Load HealthKit Runs`.

### Workflow Improvements

- For UI polish from screen recordings, record the visible complaint first, then update only the app surface that proves it; do not turn design-reference media into runtime import scope.
- For HealthKit ingestion work, inspect deletion handling, anchor-after-persist semantics, route/detail probes, and test seams before adding background delivery.
- For repo cleanup, classify active evidence, archived evidence, generated scorecards, local ignored media, and future templates before moving anything; do not delete tracked evidence.

### Docs Updated By This Review

- Added this July 3 section to `docs/project-state/daily-learning-review.md`.
- Did not edit `docs/project-state/project-status.md`, `docs/bug-log.md`, or `docs/project-state/documentation-index.md`: July 3 implementation commits already captured the stable state, durable gotchas, and data-ingestion doc classification.
- Did not edit `AGENTS.md`: no new routing/tooling rule stronger than the existing RunSignal guidance emerged from this review.

## 2026-07-04

Scope: reviewed July 4 Codex session logs whose JSON `session_meta.payload.cwd` exactly matched this RunSignal repo. Excluded unrelated sessions and the active daily-learning automation session. Treated this as documentation-only review: no Xcode builds, device installs, HealthKit/provider mutations, commits, pushes, or broad repo scans.

### Completed Work

- Reviewed Apple Fitness screenshots, RunSignal debug exports, and interval code for a fixed-distance Work-row discrepancy where Apple Fitness showed a `400 m` row while RunSignal measured about `409.6 m`.
- Confirmed the likely distinction is not a missing HealthKit boundary: WorkoutKit provides the planned goal, while HealthKit `HKWorkoutActivity` rows provide measured distance/time. Apple Fitness appears goal-normalized for fixed-distance rows; RunSignal should be explicit about goal vs measured basis.
- Added goal-vs-measured interval display support across official interval detail, Raw Debug official rows, and selected Interval Analysis rows. Distance-goal rows now expose goal distance, measured distance, measured time, goal-normalized pace, and measured pace; time-goal and open rows stay measured-first.
- Added focused formatter/test coverage for distance-goal, time-goal, and open interval rows.
- Validation reported in the session: `swift test --package-path RunningWorkoutAnalysisPackage`, `git diff --check`, and an iPhone 17 Simulator build/run/screenshot smoke check all passed; the simulator app was stopped afterward.

### Pending Work

- Physical-iPhone semantic proof is still needed before claiming the goal-vs-measured interval UI is validated against real HealthKit workout data and Apple Fitness screens.
- Continue keeping resolver boundaries unchanged: do not reverse-engineer Apple Fitness rows or replace measured HealthKit distance with planned goal distance.
- Use current-build exports plus Apple Fitness screenshots when checking whether labels, goal-normalized pace, measured pace, and row timing agree for warmup, work, recovery, cooldown, and `Open / Extra` rows.

### Mistakes, Fixes, And Friction

- Debug/export wording could make official resolved activity-boundary rows look contradictory when a separate structured-comparison summary was inconclusive. The fix was wording/status clarity, not a resolver change.
- The daily-review prompt still names deleted `current-state.md` and `next-work.md`; this repo currently routes state through `docs/project-state/project-status.md`.
- XcodeBuildMCP session defaults were empty during the implementation session, so the workflow needed workspace/scheme/simulator defaults set before the Simulator smoke run. `stop_app_sim` also needed the bundle id added to session defaults.

### Workflow Improvements

- For Apple Fitness vs RunSignal interval discrepancies, first separate planned goal, measured HealthKit activity stats, displayed duration basis, goal-normalized pace, and measured pace before changing resolver logic.
- For future UI validation, keep evidence levels separate: package tests, Simulator nonblank smoke, physical-device install, and physical iPhone real-data semantic proof.

### Docs Updated By This Review

- Added this July 4 section to `docs/project-state/daily-learning-review.md`.
- Did not edit `docs/project-state/project-status.md` or `docs/bug-log.md` in this review because existing dirty edits already captured the strong July 4 durable state: interval goal-vs-measured display and the HealthKit planned-vs-measured pace-basis gotcha.
- Did not edit `AGENTS.md` or `docs/project-state/documentation-index.md`: no new durable routing rule or document classification change was stronger than existing guidance.

## 2026-07-05

Scope: reviewed July 5 Codex session logs whose JSON `session_meta.payload.cwd` exactly matched this RunSignal repo. Excluded the active July 5 daily-learning automation session. Treated as documentation-only review: no Xcode builds, device installs, HealthKit/provider mutations, commits, pushes, or broad repo scans.

### Completed Work

- Confirmed RunSignal was already installed on physical iPhone `AIS17PM` as bundle `com.adrielsolorzano.runninganalysis`, then reinstalled/launched the current build without uninstalling so app data/cache stayed intact. Validation before the device run included `swift test --package-path RunningWorkoutAnalysisPackage` passing with `254` tests and an iPhone 17 Simulator smoke reaching the Runs screen.
- Reviewed the July 5 physical recording and measured two long black-screen/transition spans: about `13.28 s` and `14.25 s`. The recording also showed Analytics manual category taps feeling blocked and WorkoutKit plan details being hidden behind technical details.
- Added optimistic single-row Analytics tagging with delayed guarded persistence and a per-row saving indicator, so manual category taps acknowledge immediately instead of making the screen feel frozen.
- Added a normal user-facing Workout Plan card in workout detail from structured WorkoutKit planned rows, before Workout Intervals, so users can see the prescribed plan without opening Developer Tools.
- Moved HealthKit background-delivery registration and foreground sync out of first-render launch work, skipped the first duplicate `.active` scene-phase sync, and added startup log markers for future profiling. Simulator build/run reached Runs cleanly after the patch.
- Installed/launched the patched build on `AIS17PM`, then pushed commit `5c367c4 Improve RunSignal launch and workout review UX` to `origin/main` after package tests and Simulator smoke passed.
- Later tightened the GitHub-facing README with an External Review Guide for David; that README change remains uncommitted at review time.
- Checked GitHub repo share-readiness: public repo access had no outside collaborators, deploy keys, webhooks, listed repo secrets, local workflows, or write access beyond the owner. Added a narrow active ruleset protecting `main` from deletion and non-fast-forward pushes, without requiring PRs, reviews, or status checks.

### Pending Work

- Capture a fresh physical-iPhone recording/proof after the July 5 launch-path patch to confirm black-screen duration improves on real HealthKit cache pressure; Simulator sample data cannot prove this.
- On the phone, verify Analytics tag changes feel immediate, row-level saving is visible, and category persistence survives force-quit/reopen.
- Verify the new Workout Plan card on a real planned-workout detail screen and compare its prescribed rows with official interval rows/Raw Debug when available.
- Decide whether to commit the later `README.md` External Review Guide edit or revise it before sharing the repo link.
- Keep repo sharing safe by leaving collaborators empty unless direct write access is intentionally wanted; branch protection now blocks destructive updates to `main`, but public forks/clones still need normal review before any PR merge.

### Mistakes, Fixes, And Friction

- The first July 5 recording confirmed that simulator success did not expose the real phone's launch/cache pressure. Continue separating package tests, Simulator nonblank smoke, physical install/launch, and physical real-data semantic proof.
- Manual category writes had already been made lighter, but they still felt blocking because the interactive tap path waited on enough persistence/recompute work to make the menu appear frozen. The next fix moved the user-visible state change ahead of delayed persistence.
- WorkoutKit plan data existed, but presenting it mainly through Raw HealthKit Debug/Developer Tools made a normal user workflow feel incomplete. Durable UX rule: prescribed plan belongs near executed intervals when structured plan rows are available.
- XcodeBuildMCP session defaults were empty again for the Simulator/device workflow; set workspace, scheme, simulator/device, and bundle id explicitly before build/run/stop steps.
- GitHub API form quoting for rulesets was brittle with shell bracket syntax; using a JSON payload was the reliable path.

### Workflow Improvements

- For physical recordings, measure obvious visual stalls in seconds/frames before changing code; the July 5 video made the black-screen issue concrete enough to tie to launch-path work.
- For app launch issues, inspect first-render tasks and first `.active` scene-phase hooks together. Duplicate startup sync can hide behind otherwise clean Simulator launches.
- For "push it through my iPhone," keep interpreting it as physical-device install/run, not git push, unless the user later says `push` in the git/GitHub sense.
- For sharing the repo with an external reviewer, a minimal `main` ruleset that blocks deletion and force-pushes is a useful low-friction guard; do not add PR/review/status-check requirements unless the workflow needs them.

### Docs Updated By This Review

- Added this July 5 section to `docs/project-state/daily-learning-review.md`.
- Did not edit `docs/project-state/project-status.md` or `docs/bug-log.md`: commit `5c367c4` and the current docs already capture the durable July 5 launch, manual-tag freeze, workout-plan-card, and foreground-sync lessons.
- Did not edit `AGENTS.md` or `docs/project-state/documentation-index.md`: no new durable routing or document-classification rule was stronger than existing repo guidance.
- Did not edit `README.md` because it already has unrelated active edits from the external-review guide pass.

## 2026-07-06

Scope: reviewed July 6 Codex session logs whose JSON `session_meta.payload.cwd` or `turn_context.cwd` exactly matched this RunSignal repo. Found eight exact-cwd logs and excluded the active daily-learning automation session from the lessons. Treated this as documentation-only review: no Xcode builds, device installs, HealthKit/provider mutations, commits, pushes, or broad repo scans.

### Completed Work

- Multiple independent researcher passes converged on the same local-only direction for Joshua's feedback: do not add accounts, CloudKit, backend sync, FIT import, or remote state; add a disposable SwiftData materialized analytics summary cache over HealthKit-derived local workouts.
- Landed and pushed commit `cd1fe63 Add local analytics cache and run date display`. The session reported `swift test --package-path RunningWorkoutAnalysisPackage` passing with `257` tests, physical iPhone `AIS17PM` build/install/launch success, installed app confirmation for `RunSignal com.adrielsolorzano.runninganalysis`, and a clean `main...origin/main`.
- The July 6 analytics cache slice made Week, Month, Year, and All-Time period summaries cache-backed through local SwiftData while keeping HealthKit as runtime truth and the pure summary builder as fallback/oracle.
- Completed Runs rows now show year-inclusive dates such as `Jun 24, 2024`, reducing ambiguity when browsing older HealthKit history.
- A later physical-recording follow-up implemented startup/relaunch polish: explicit branded `LaunchScreen.storyboard`, generated launch-screen output disabled, and a lightweight SwiftUI `RunSignalStartupView` while store bootstrap completes. The session reported `257` package tests passing, iPhone 17 Simulator build/install/launch success, bundle proof for `UILaunchStoryboardName = LaunchScreen`, and compiled `LaunchScreen.storyboardc`.
- `docs/project-state/project-status.md` and `docs/bug-log.md` already have uncommitted entries from the startup/relaunch pass recording the black-screen lesson, launch-screen fix, Simulator proof, and remaining physical-iPhone timing proof need.

### Pending Work

- Capture a fresh physical-iPhone install/recording after the launch-screen/startup overlay change to confirm perceived black-screen duration improves on real HealthKit cache pressure.
- Smoke the analytics cache on the phone with a large real HealthKit history: launch, Analytics tab render, Week/Month/Year/All-Time changes, manual category edits, and force-quit/reopen persistence.
- Keep local analytics summaries disposable: any cached period summary must be deletable and rebuildable from local HealthKit-derived SwiftData workouts without changing product meaning.
- Re-export or re-check older real-data screens after fresh installs with `Settings > Load HealthKit Runs` before judging Best Efforts, older-history dates, or analytics completeness.

### Mistakes, Fixes, And Friction

- The recurring daily-review prompt still names deleted `docs/project-state/current-state.md` and `docs/project-state/next-work.md`; this repo currently routes stable state and next work through `docs/project-state/project-status.md`.
- Raw log inspection is noisy because session files embed full instruction payloads. Use structured JSONL extraction of `session_meta`, `turn_context`, user prompts, final assistant messages, and command/edit evidence instead of broad text dumps.
- Several researcher sessions validated the same conclusion independently: the main performance risk is stale or expensive local analytics recomputation, not missing remote sync. The strongest objection remains cache correctness; stale totals after deletes, manual category changes, anchored updates, or day-boundary period comparisons are worse than a slower pure calculation.
- Simulator sample data remains insufficient for startup/cache-pressure proof. Keep package tests, Simulator smoke, physical install/launch, and real HealthKit semantic timing proof as separate evidence levels.

### Workflow Improvements

- For local analytics cache work, keep `TrainingPeriodAnalyticsSummary.make` as the canonical pure builder and test oracle; persisted period summaries should be versioned materialized views, not a second source of truth.
- Recompute or dirty-mark only affected periods after import windows, anchored sync additions/updates/deletions, manual category edits, and local day-boundary changes; avoid immediate all-time recompute during every import batch.
- For launch complaints, compare the user-recorded perceived stall against native launch-screen behavior and first SwiftUI frame visibility before assuming the underlying HealthKit/cache work has to be fully eliminated.

### Docs Updated By This Review

- Added this July 6 section to `docs/project-state/daily-learning-review.md`.
- Did not further edit `docs/project-state/project-status.md` or `docs/bug-log.md`: both already have uncommitted July 6 startup/relaunch entries from the implementation session, and this review should not overwrite in-flight doc work.
- Did not edit `AGENTS.md` or `docs/project-state/documentation-index.md`: no new durable routing or document-classification rule was stronger than existing repo guidance.

## 2026-07-07

Scope: reviewed July 7 Codex session logs whose JSON `session_meta.payload.cwd` or `turn_context.cwd` exactly matched this RunSignal repo. Found three exact-cwd logs and excluded the active daily-learning automation session from the lessons. Treated this as documentation-only review: no Xcode builds, device installs, HealthKit/provider mutations, commits, pushes, or broad repo scans.

### Completed Work

- Reviewed the July 7 physical-iPhone recording for workout-detail public-app polish. The session found the branded startup surface was visible on-device, but still needed perceived-progress polish; route and sample-count evidence cards were too developer-facing for the normal happy path; the Workout Plan card needed a runner-facing prescription summary; interval row counts were too prominent; and `Goal Pace` sounded like a prescribed target instead of Apple-Fitness-comparable planned-distance pace.
- Implemented and pushed commit `63e9b68 Polish workout detail experience`. Reported validation was `swift test --package-path RunningWorkoutAnalysisPackage` with `257` passing tests, iPhone 17 Simulator build/install/launch, physical iPhone `AIS17PM` build/install/launch, and installed bundle confirmation for `RunSignal com.adrielsolorzano.runninganalysis`.
- Added a follow-up Workout Plan layout shaped like the user-supplied reference: warm-up, work target, indented recovery, and cool-down, with raw WorkoutKit plan rows still behind disclosure. The follow-up reported `257` package tests passing, iPhone 17 Simulator launch/screenshot checks, and physical iPhone install/launch.
- Fixed the same-day typography regression after the user screenshot showed the work prescription row was oversized and bold compared with the rest of the app. The active local diff changes the plan summary to compact uniform `.subheadline` styling and updates `docs/project-state/project-status.md` to describe compact uniform typography.

### Pending Work

- Check the stacked Workout Plan card against a real structured workout on the physical iPhone. Simulator sample data did not include a WorkoutKit plan, so it could prove nonblank layout only, not exact real-plan visual parity.
- Confirm the physical phone's perceived startup experience after the July 7 polish: the app mark/startup shell appears, but user-facing progress/motion may still matter if first real content takes multiple seconds.
- The typography fix and `project-status.md` note are still local uncommitted changes at review time: `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/Views.swift` and `docs/project-state/project-status.md`.

### Mistakes, Fixes, And Friction

- Product-facing cards can inherit technically correct labels that are confusing in runner language. `Goal Pace` matched Apple Fitness because it normalized measured time to planned distance; the clearer durable label is `Planned-Distance Pace`, with HealthKit measured pace remaining secondary.
- The first stacked plan implementation used `.title3` and bold emphasis for the work prescription, which made `12 x 200 m` visually overpower neighboring detail rows. Compact cards should use the same small typography scale as nearby workout-detail sections unless there is an intentional hierarchy change.
- Simulator visual proof remains limited for WorkoutKit plan UI because sample workouts may not include structured plans. Real structured-workout visual checks still need the physical phone or cached real-data fixture path.

### Workflow Improvements

- For user-recorded UX complaints, first split the issue into product-language cleanup, information hierarchy, visual hierarchy, and proof level. That made it easier to improve visible cards without touching interval resolver math.
- When the user compares Apple Fitness to RunSignal, verify whether the apparent mismatch is source semantics: planned-distance pace can intentionally match Apple Fitness while measured HealthKit pace explains distance drift.
- For same-day UI follow-ups, keep a screenshot-driven typography pass separate from the larger UX patch; it makes the final diff smaller and avoids reworking resolver or data paths.

### Docs Updated By This Review

- Added this July 7 section to `docs/project-state/daily-learning-review.md`.
- Did not further edit `docs/project-state/project-status.md`: it already has an active uncommitted July 7 Workout Detail UX section and this review should not overwrite in-flight status edits.
- Did not edit `docs/bug-log.md`: the oversized plan typography was a fixed one-off UI regression, not a recurring bug, toolchain gotcha, or durable verification rule beyond the daily note above.
- Did not edit `AGENTS.md` or `docs/project-state/documentation-index.md`: no new durable routing or document-classification rule was stronger than existing repo guidance.

## 2026-07-08

Scope: reviewed July 8 Codex session logs whose JSON `session_meta.payload.cwd` or `turn_context.cwd` exactly matched this RunSignal repo. Found two exact-cwd logs and excluded the active daily-learning automation session from lessons. Treated this as documentation-only review: no Xcode builds, device installs, HealthKit/provider mutations, commits, pushes, or broad repo scans.

### Completed Work

- Reviewed user-supplied workout-detail recording `/Users/adrielsolorzano/Downloads/RPReplay_Final1783552147.MP4` for redundant workout summary, runner-facing Workout Plan value, and interval display mismatches against Apple Fitness.
- Implemented and pushed commit `b75fbfe Update interval metrics for planned distance`. The slice uses goal-distance windows for fixed-distance interval rows so time, pace, heart rate, power, and cadence align to the planned target distance while official measured activity rows remain the validation totals.
- The same slice removed/reduced redundant workout-detail UI, simplified runner-facing plan/status copy, and kept measured HealthKit pace/distance available where it explains overrun or drift.
- Reported verification: `swift test --package-path RunningWorkoutAnalysisPackage` passed with `259` tests, XcodeBuildMCP Simulator build/install/launch passed on iPhone 17, physical iPhone `AIS17PM` build/install/launch passed, and `main` was pushed to `origin/main`.

### Pending Work

- On the physical iPhone, open a real structured interval workout and verify fixed-distance rows show the planned target distance/time/pace and that interval detail HR/cadence/power come from the goal-distance window.
- Continue treating Simulator screenshots as layout proof only for this specific area; sample data cannot prove real WorkoutKit plan row semantics or HealthKit goal-window metrics.
- Keep an eye on user-facing confusion between planned-distance pace and measured pace: the app should explain both without making validation totals look like they changed.

### Mistakes, Fixes, And Friction

- The key semantic trap was letting HealthKit activity-row overrun distance dominate runner-facing fixed-distance intervals. The fix is not to change official validation rows; it is to add a provable planned-distance metric window for display metrics.
- A prior interpolation bug produced impossible short planned-distance durations when a distance sample ended exactly at an interval boundary. The durable fix was to use each distance sample start/end window so row-start cumulative distance is not double-counted.
- The final working tree intentionally left `docs/project-state/daily-learning-review.md` modified and unpushed; code, tests, `docs/bug-log.md`, and `docs/project-state/project-status.md` were included in `b75fbfe`.

### Workflow Improvements

- For Apple Fitness interval comparisons, separate four concepts before editing: planned target distance, HealthKit measured activity distance, goal-window metrics, and official validation totals.
- When the user asks for Apple-Fitness-like interval display, first verify whether the requested match is a product display choice or a resolver promotion rule. This avoids weakening evidence gates to satisfy UI parity.
- For fixed-distance interval metrics, keep regression tests around both the display metric window and the measured official-row totals so one cannot silently replace the other.

### Docs Updated By This Review

- Added this July 8 section to `docs/project-state/daily-learning-review.md`.
- Did not further edit `docs/project-state/project-status.md`: commit `b75fbfe` already updated current state, next work, and known limitation text for the July 8 goal-distance window slice.
- Did not further edit `docs/bug-log.md`: commit `b75fbfe` already added the durable goal-distance interpolation gotcha, and the existing bug-log index covers the related recurring proof/validation lessons.
- Did not edit `AGENTS.md` or `docs/project-state/documentation-index.md`: no new durable routing, tooling, or document-classification rule was stronger than existing guidance.
