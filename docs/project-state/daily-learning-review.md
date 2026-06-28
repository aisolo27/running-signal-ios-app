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

- Archived and reviewed June 25 user-supplied `Thursday Interval 5km` repeat fixed-cooldown/Open-tail evidence in `docs/validation/apple-fitness-interval-parity-dataset/user-supplied-repeat-tail-review-2026-06-25/`.
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
