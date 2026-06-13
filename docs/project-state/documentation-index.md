# Documentation Index

Last updated: 2026-06-13

## Active Docs To Read First

- `docs/project-state/current-state.md`: first project-context file for every task.
- `docs/project-state/next-work.md`: short priority list and out-of-scope guardrails.
- `AGENTS.md`: repo rules, tool routing, and context-loading policy.
- `docs/bug-log.md`: selective gotcha index; read only the relevant section.
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
- `docs/validation/apple-fitness-interval-parity-dataset/gate-b-repeat-block-evidence-2026-03-to-2026-06.md`: generated docs/debug repeat-block evidence scorecard.
- `docs/validation/apple-fitness-interval-parity-dataset/gate-b-open-tail-evidence-2026-03-to-2026-06.md`: generated docs/debug Open/Extra tail evidence scorecard.
- `docs/validation/apple-fitness-interval-parity-dataset/gate-b-narrow-warmup-work-cooldown-candidate-scorecard-2026-03-to-2026-06.md`: generated docs/debug narrow warmup/work/open-cooldown candidate scorecard.
- `docs/validation/apple-fitness-interval-parity-dataset/gate-b-timer-drift-evidence-2026-03-to-2026-06.md`: generated docs/debug elapsed-vs-timer and pause-event evidence for Gate B outliers.
- `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-shape-coverage-audit-2026-03-to-2026-06.md`: generated docs/debug custom-workout shape inventory across easy, tempo, interval, tail, and pause/timer cases.
- `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-balanced-evidence-collection-plan.md`: docs-only balanced collection plan for easy, tempo, interval, tail, paused, and clean no-pause custom workout evidence.
- `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-evidence-collection-tracker.md`: active docs-only tracker for target templates, completed evidence, screenshots, FIT exports, diagnostics refreshes, and parity packet exports in the next custom workout validation cycle.
- `docs/validation/apple-fitness-interval-parity-dataset/apple-fitness-screenshot-confirmed-rows-2026-03-to-2026-06.json`: manually typed Apple Fitness screenshot rows for selected March-June custom workouts; validation fixture only.
- `docs/validation/apple-fitness-interval-parity-dataset/apple-fitness-screenshot-confirmed-scorecard-2026-03-to-2026-06.md`: generated docs/debug scorecard comparing screenshot-confirmed rows with RunSignal current rows, `HKWorkoutActivity` candidate rows, WorkoutKit planned rows, FIT laps, and pause-drift evidence.
- `docs/validation/apple-fitness-interval-parity-dataset/may-1-open-tail-pause-evidence-2026-05-01.md`: focused May 1 evidence report showing paired HealthKit pause intervals and matching FIT timer-vs-elapsed deltas support active-time row comparison plus Open/Extra tail classification.
- `docs/validation/apple-fitness-interval-parity-dataset/score_candidate_reconstruction_rules.py`: docs/debug script that scores candidate reconstruction rules against screenshot-confirmed rows, Gate B row-level FIT evidence, and pause evidence.
- `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-candidate-reconstruction-rule-scorecard-2026-03-to-2026-06.md`: generated docs/debug scorecard for active/timer duration, pause subtraction, repeat expansion, and Open/Extra tail rules across all screenshot-confirmed fixtures.
- `docs/validation/apple-fitness-interval-parity-dataset/fresh-iphone-parity-lab-export-review-2026-06-13.md`: latest-debug-build iPhone export review confirming selected parity packets and May monthly diagnostics match the docs/debug candidate reconstruction scorecard.

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
