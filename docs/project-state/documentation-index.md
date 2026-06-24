# Documentation Index

Last updated: 2026-06-24

## Active Docs To Read First

- `docs/project-state/current-state.md`: first project-context file for every task.
- `docs/project-state/next-work.md`: short priority list and out-of-scope guardrails.
- `AGENTS.md`: repo rules, tool routing, and context-loading policy.
- `docs/bug-log.md`: selective gotcha index; read only the relevant section.
- `docs/claude-runsignal-architecture-handoff.md`: Claude-oriented app architecture, HealthKit data map, analytics/UI handoff, and review prompts.
- `docs/milestones/09-healthkit-evidence-contract.md`: active milestone and Step 7 status.

## Active Validation Docs

Keep active validation lean. Once a date-specific parity investigation is complete, move it to `docs/archive/old-validation/` unless it is still the latest active investigation, latest active evidence review, or current blocker.

- `docs/validation/2026-06-10-apple-fitness-parity.md`: current Jun 10 Apple Fitness parity note.
- `docs/validation/apple-fitness-interval-model-research.md`: current WorkoutKit/HealthKit interval reconstruction research.
- `docs/validation/golden-apple-fitness-checklist.md`: manual Apple Fitness parity checklist.
- `docs/validation/healthkit-permission-review.md`: current read-only permission summary.
- `docs/validation/apple-fitness-interval-parity-dataset/README.md`: active interval parity dataset contract.
- `docs/validation/apple-fitness-interval-parity-dataset/analysis-summary.md`: current dataset findings and blockers.
- `docs/validation/apple-fitness-interval-parity-dataset/next-boundary-validation-plan.md`: next evidence plan before boundary logic changes.
- `docs/validation/apple-fitness-interval-parity-dataset/apple-docs-research.md`: public API constraints for interval validation.
- `docs/validation/apple-fitness-interval-parity-dataset/fit-comparison-summary.md`: completed docs/debug HealthFit FIT pilot summary; research evidence only, not production truth.
- `docs/validation/apple-fitness-interval-parity-dataset/fit-lap-boundary-source-investigation.md`: docs/debug source investigation for FIT lap boundary timing versus public HealthKit/WorkoutKit evidence.
- `docs/validation/apple-fitness-interval-parity-dataset/hkworkoutactivity-boundary-investigation.md`: current docs/debug review of regenerated physical-device `HKWorkoutActivity` boundary evidence.
- `docs/validation/apple-fitness-interval-parity-dataset/hkworkoutactivity-boundary-scorecard.md`: current docs/debug scorecard for the archived on-device activity-boundary candidate exports; no production promotion approved.
- `docs/validation/apple-fitness-interval-parity-dataset/gate-b-phase-3-readiness-review.md`: docs-only Gate B decision table by exact workout shape before any Phase 3 prototype discussion.
- `docs/validation/apple-fitness-interval-parity-dataset/gate-b-agent-findings-2026-03-to-2026-06.md`: consolidated Gate B sub-agent findings, root-cause matrix, and no-production-change decision.
- `docs/validation/apple-fitness-interval-parity-dataset/gate-b-scoring-refresh-2026-06-23.md`: AIS-27 historical refresh note; AIS-41 later linked the count-level scorecard to row-level FIT label/error evidence, so current Gate B blockers are exact-shape label/tail/fallback rules.
- `docs/validation/apple-fitness-interval-parity-dataset/gate-b-warmup-work-cooldown-outlier-review-2026-06-23.md`: AIS-28 review classifying March 19, May 29, June 5, and high-drift repeat rows; no broad Gate B promotion approved.
- `docs/validation/apple-fitness-interval-parity-dataset/gate-b-repeat-block-evidence-2026-03-to-2026-06.md`: generated docs/debug repeat-block evidence scorecard.
- `docs/validation/apple-fitness-interval-parity-dataset/gate-b-open-tail-evidence-2026-03-to-2026-06.md`: generated docs/debug Open/Extra tail evidence scorecard.
- `docs/validation/apple-fitness-interval-parity-dataset/gate-b-narrow-warmup-work-cooldown-candidate-scorecard-2026-03-to-2026-06.md`: generated docs/debug narrow warmup/work/open-cooldown candidate scorecard.
- `docs/validation/apple-fitness-interval-parity-dataset/gate-b-timer-drift-evidence-2026-03-to-2026-06.md`: generated docs/debug elapsed-vs-timer, active/timer, pause-event, and material timer policy evidence for Gate B outliers.
- `docs/validation/apple-fitness-interval-parity-dataset/paused-repeat-block-timer-rule-2026-06-15.md`: docs/debug timer rule for paused repeat blocks; preserves elapsed row windows and active/timer duration from paired HealthKit pause overlap. The narrow open-cooldown shape is now promoted, while broader paused tails remain blocked.
- `docs/validation/apple-fitness-interval-parity-dataset/paused-repeat-open-extra-tail-rule-2026-06-23.md`: AIS-39 docs/debug separator rule for true paused repeat fixed-tail `Open / Extra` cases; keeps them blocked unless paired pauses, fixed-row exhaustion, tail thresholding, and open-cooldown controls are proven.
- `docs/validation/apple-fitness-interval-parity-dataset/broad-recovery-tail-boundaries-2026-06-23.md`: AIS-40 boundary note; keeps broad recovery-containing `Open / Extra` tails blocked outside the narrow May 1-style proven gate.
- `docs/validation/apple-fitness-interval-parity-dataset/paused-repeat-block-promotion-readiness-review-2026-06-15.md`: docs-only readiness review concluding paused repeat blocks should not enter normal detail until interval timing semantics can carry elapsed, pause-overlap, and active/timer duration separately.
- `docs/validation/apple-fitness-interval-parity-dataset/recovery-containing-open-tail-rule-2026-06-15.md`: docs/debug separator rule for recovery-containing Open/Extra tails; preserves planned Recovery rows and requires fixed-step exhaustion before post-plan Open/Extra.
- `docs/validation/apple-fitness-interval-parity-dataset/interval-analytics-readiness-handoff-2026-06-23.md`: AIS-46 handoff; parks interval-row analytics until supported and blocked workout styles have stable rows, diagnostics agreement, and regression fixtures.
- `docs/validation/apple-fitness-interval-parity-dataset/ambiguous-repeat-tail-rule-2026-06-15.md`: repeat-tail taxonomy and docs/debug separator rule; separates the approved clean no-pause fixed-cooldown repeat-tail gate from unresolved ambiguous cases that still require fixed final-row exhaustion, tail threshold, and open-cooldown guards.
- `docs/validation/apple-fitness-interval-parity-dataset/ambiguous-repeat-tail-evidence-decision-2026-06-23.md`: AIS-24 decision; no new broad repeat-tail gate, clean June 10-style shape is already closed, and AIS-25 should harden fallback/tests for unresolved cases.
- `docs/validation/apple-fitness-interval-parity-dataset/ambiguous-repeat-tail-decision-rules-2026-06-24.md`: AIS-47 operational decision rules for repeat-block end detection, fixed cooldown exhaustion, Open/Extra tail inference, tie-breakers, fallback reasons, and scoring commands.
- `docs/validation/apple-fitness-interval-parity-dataset/repeat-tail-tests-and-proof-closure-2026-06-23.md`: AIS-26 closure; AIS-25 was test/docs-only, existing June 10 plus May 20/June 3 physical proof remains sufficient, and no new app artifacts are required.
- `docs/validation/apple-fitness-interval-parity-dataset/simple-work-open-prototype-decision-2026-06-15.md`: Gate A boundary for exactly one fixed-distance Work step plus Open/Extra tail; this exact shape now has narrow normal-detail support while broader shapes remain blocked.
- `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-shape-coverage-audit-2026-03-to-2026-06.md`: generated docs/debug custom-workout shape inventory across easy, tempo, interval, tail, and pause/timer cases.
- `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-balanced-evidence-collection-plan.md`: docs-only balanced collection plan for easy, tempo, interval, tail, paused, and clean no-pause custom workout evidence.
- `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-evidence-collection-tracker.md`: AIS-30 refreshed docs-only tracker for completed proof, blocked classes, optional future collection, and the do-not-recollect list.
- `docs/validation/apple-fitness-interval-parity-dataset/validate_parity_export_consistency.py`: offline proof-folder check for debug-only custom workout candidate/comparison row-count consistency in JSON and Raw HealthKit Debug markdown exports.
- `docs/validation/apple-fitness-interval-parity-dataset/apple-fitness-screenshot-confirmed-rows-2026-03-to-2026-06.json`: manually typed Apple Fitness screenshot rows for selected March-June custom workouts; validation fixture only.
- `docs/validation/apple-fitness-interval-parity-dataset/apple-fitness-screenshot-confirmed-scorecard-2026-03-to-2026-06.md`: generated docs/debug scorecard comparing screenshot-confirmed rows with RunSignal current rows, `HKWorkoutActivity` candidate rows, WorkoutKit planned rows, FIT laps, and pause-drift evidence.
- `docs/validation/apple-fitness-interval-parity-dataset/may-1-open-tail-pause-evidence-2026-05-01.md`: focused May 1 evidence report showing paired HealthKit pause intervals and matching FIT timer-vs-elapsed deltas support active-time row comparison plus Open/Extra tail classification.
- `docs/validation/apple-fitness-interval-parity-dataset/score_candidate_reconstruction_rules.py`: docs/debug script that scores candidate reconstruction rules against screenshot-confirmed rows, Gate B row-level FIT evidence, and pause evidence.
- `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-candidate-reconstruction-rule-scorecard-2026-03-to-2026-06.md`: generated docs/debug scorecard for active/timer duration, pause subtraction, repeat expansion, and Open/Extra tail rules across all screenshot-confirmed fixtures.
- `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-correctness-lock-v1.md`: current milestone acceptance matrix for workout-style support, blocked classes, debug-prototype order, interval-analytics prerequisites, and explicit non-goals such as coaching, VDOT, and training load.
- `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-promotion-readiness-review-2026-06-15.md`: docs-only promotion-readiness decision after physical proof batches; its Gate A simple fixed-distance Work/Open recommendation has been implemented and proven on physical iPhone exports.
- `docs/validation/apple-fitness-interval-parity-dataset/fresh-iphone-parity-lab-export-review-2026-06-13.md`: latest-debug-build iPhone export review confirming selected parity packets and May monthly diagnostics match the docs/debug candidate reconstruction scorecard.
- `docs/validation/apple-fitness-interval-parity-dataset/balanced-evidence-batch-review-2026-06-13.md`: complete balanced evidence batch review across all 12 screenshot-confirmed fixtures, including local source paths, the repo screenshot archive, and the external HealthFit FIT archive link.
- `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-production-readiness-plan.md`: current docs-only plan for moving debug-only Parity Lab rows toward a future debug prototype and later production UI gate.
- `docs/validation/apple-fitness-interval-parity-dataset/apple-fitness-screenshot-archive-2026-06-13/`: repo-local archive of Apple Fitness screenshots for the 12 screenshot-confirmed fixtures.
- `docs/validation/apple-fitness-interval-parity-dataset/physical-iphone-parity-lab-proof-2026-06-13/`: repo-local archive and summary for physical iPhone `AIS17PM` Raw HealthKit Debug/parity packet proof exports for May 1, Jun 5, and Jun 10.
- `docs/validation/apple-fitness-interval-parity-dataset/physical-iphone-interval-timing-semantics-proof-2026-06-23/`: repo-local archive and summary for physical iPhone paused-repeat exports confirming elapsed row-window, paired pause-overlap, active/timer semantics, and post-install reconstructed-interval display fields remain debug/export-only with no normal UI promotion.
- `docs/validation/apple-fitness-interval-parity-dataset/2026-06-14-stopped-early-and-open-run/`: docs/evidence capture for a stopped-early `Test Race Day 5k` custom workout and a plain open Watch run; matching FIT files are linked from the saved external HealthFit archive folder, copied locally, decoded, and used as controls for the narrow stopped-early Work gate plus open-run fallback behavior.

## Reference Docs To Read Selectively

- `README.md`: setup and architecture only when unclear.
- `docs/healthkit-reference/00-START-HERE-CODEX.md`: HealthKit reference router.
- `docs/healthkit-reference/13-codex-rules-for-healthkit.md`: required before HealthKit logic changes.
- `docs/healthkit-reference/[numbered topic].md`: read only the topic needed for the task.
- `docs/healthkit-reference/references/apple-healthkit-links.md`: Apple docs link lookup.
- `docs/healthkit-reference/references/api-symbol-index.md`: symbol lookup only.
- `docs/healthkit-reference/references/claude-drive-folder-index.md`: supplemental reference only.
- `docs/project-state/do-not-read-by-default.md`: explicit archive and history skip-list.

## Archived Completed Plans

- `docs/archive/completed-plans/01-project-scaffold.md`: completed scaffold milestone.
- `docs/archive/completed-plans/02-healthkit-foundation.md`: completed v1 HealthKit foundation milestone.
- `docs/archive/completed-plans/03-normalization-persistence.md`: completed normalization/persistence milestone.
- `docs/archive/completed-plans/04-manual-classification-dedupe.md`: completed manual labels and dedupe milestone.
- `docs/archive/completed-plans/05-analytics-engine.md`: completed conservative analytics milestone.
- `docs/archive/completed-plans/06-coaching-surfaces.md`: completed current surface wiring milestone.
- `docs/archive/completed-plans/07-deeper-analysis.md`: completed v1 detail/gating milestone.
- `docs/archive/completed-plans/08-export.md`: completed local Markdown export milestone.
- `docs/archive/completed-plans/09-healthkit-physical-verification.md`: completed physical iPhone verification note.

## Archived Stale Or Generated Docs

- `docs/archive/stale-plans/CLAUDE.md`: generic template-era assistant rules that no longer match the lean Codex routing policy.
- `docs/archive/stale-plans/copilot-instructions.md`: hidden template-era Copilot rules with stale package names and old tool guidance.
- `docs/archive/old-research/COMBINED-HEALTHKIT-CODEX-REFERENCE.md`: generated combined HealthKit pack; too large for routine context.
- `docs/archive/old-research/codex-healthkit-reference-prompt.md`: prompt wrapper superseded by `AGENTS.md` and the HealthKit start-here router.

## Needs Human Review

- `README.md`: still contains useful setup details, but some template-era sections may be worth trimming later.

## Intentionally Not Archived

- `AGENTS.md`, `README.md`, and `docs/bug-log.md`.
- Current HealthKit start/rules files and numbered HealthKit reference topics.
- Current Apple Fitness parity validation docs and the interval parity dataset.
- `docs/milestones/09-healthkit-evidence-contract.md`, because Step 7 is still active.
