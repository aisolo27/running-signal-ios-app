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
