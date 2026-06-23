# Custom Workout Promotion Readiness Review - 2026-06-15

## Scope

Current status note, 2026-06-23: this is now a historical Gate A readiness packet. Gate A simple `Work > Open / Extra` and the later narrow paused-repeat `Cooldown(Open)` gate have both been implemented and physically proofed. Recovery-containing Open/Extra tails, ambiguous repeat-tail cases, true Open/Extra paused-repeat tails, broad `HKWorkoutActivity` promotion, and interval-row analytics remain blocked.

Docs-only review of whether the current Custom Workout Correctness Lock evidence is ready for a later normal-detail promotion task.

This review does not approve app logic changes, production interval reconstruction changes, broad `HKWorkoutActivity` promotion, FIT runtime usage, file imports, HealthFit dependency, coaching, VDOT, training load, recovery scoring, race prediction, or interval-row analytics.

## Inputs Reviewed

- `custom-workout-correctness-lock-v1.md`
- `custom-workout-production-readiness-plan.md`
- `physical-iphone-repeat-block-proof-2026-06-14/README.md`
- `physical-iphone-gate-a-work-open-proof-2026-06-15/README.md`
- `physical-iphone-paused-repeat-proof-2026-06-15/README.md`
- `physical-iphone-recovery-tail-proof-2026-06-15/review.md`
- `physical-iphone-repeat-tail-proof-2026-06-15/review.md`

## Decision

Do not approve broad normal-detail promotion yet.

The evidence is now strong enough to plan one narrow normal-detail promotion task, but that task should be explicit and isolated. The next app-logic promotion candidate should be:

`one fixed-distance Work step > inferred Open / Extra`

This is the Gate A simple Work/Open class.

It should be promoted only for the exact shape already proven in debug/export:

- WorkoutKit plan is available.
- Expanded planned step count is exactly one.
- The single planned step is `Work`.
- The planned step goal is fixed distance.
- HealthKit activity count is exactly one.
- The activity row is complete, contiguous by definition, and distance-backed.
- The post-activity residual has positive duration or distance above the small-tail threshold.
- No repeat iteration beyond `repeatIndex == 1`.
- No warmup, recovery, cooldown, repeat block, pause/timer, missing-evidence, duplicate, no-plan, same-day extra, or guard-unknown status.

## Why This Candidate

Gate A simple Work/Open is the safest new normal-detail candidate because it has the least structure to misread:

- It does not require repeat expansion.
- It does not require Work/Recovery label alternation.
- It does not require pause-overlap timer semantics.
- It does not require separating a planned Recovery row from a post-plan tail.
- It has five physical-iPhone proof exports for the real packet shape.
- The first proof pass exposed and fixed the only observed metadata gotcha: one-step WorkoutKit blocks can carry `repeatBlockIndex: 1` / `repeatIndex: 1`.
- The fixed-build June 12 export confirms `customWorkoutComparisonSummary.status == supported` with no fallback reasons.

The existing clean no-pause repeat-tail subclass is not the next new promotion candidate because it is already one of the five internal normal-detail gates. The June 10 repeat-tail proof strengthens that existing gate and closes the debug/export proof loop, but it does not require another promotion step.

## Promotion Matrix

| Shape | Current state | Physical proof | Recommendation |
| --- | --- | --- | --- |
| Stopped-early single fixed-distance `Work` | Normal-detail gated | June 14 stopped-early control | Keep as-is; do not broaden |
| `Warmup > Work > Cooldown(Open)` | Normal-detail gated for narrow class | March 5 and April 24 screenshots/exports | Keep as-is; do not broaden |
| `Warmup > Work > fixed Cooldown > Open / Extra` | Normal-detail gated for clean subclass | Existing fixed-cooldown proof | Keep as-is; do not broaden |
| Clean no-pause repeat block ending in `Cooldown(Open)` | Normal-detail gated | May 20 and June 3 screenshots | Keep as-is |
| Clean no-pause repeat block ending in fixed `Cooldown > Open / Extra` | Normal-detail gated | June 10 screenshots plus June 15 debug/export proof | Keep as-is; proof complete |
| Simple fixed-distance `Work > Open / Extra` | Debug/export supported only | May 26, June 1, June 2, June 4, June 12; fixed-build June 12 supported | Best next new normal-detail promotion candidate |
| Recovery-containing fixed-tail | Debug/export supported only | May 1 supported, with paired pauses | Keep debug-only for now; needs at least one more guard/proof before promotion |
| Paused repeat blocks | Debug/export supported only | April 22, April 29, May 6, May 13, May 27 supported | Keep debug-only for now; timer semantics are higher risk |
| Ambiguous/no-pause repeat-tail prototype | Debug/export supported only, overlaps existing clean repeat-tail gate | June 10 supported | Treat as proof for the existing clean gate, not a new broad promotion |
| Timer-drift, missing evidence, duplicate/no-plan/guard-unknown | Blocked or excluded | Mixed | Keep blocked |

## Required Guardrails For The Next Promotion Task

If a later task explicitly approves normal-detail promotion for Gate A simple Work/Open, the implementation should:

- Add only the exact one-step fixed-distance Work gate.
- Reuse the existing debug comparison eligibility as the acceptance shape.
- Render two rows in normal detail only for the approved shape: `Work` and `Open / Extra`.
- Keep plain open Watch runs plain open runs.
- Keep warmup/work/cooldown, recovery-containing tails, repeat blocks, paused workouts, and missing-evidence cases out of this promotion.
- Preserve existing blocked-placeholder behavior for unsupported custom workouts.
- Add tests proving:
  - the exact Gate A shape promotes
  - one-step `repeatIndex == 1` promotes
  - true repeat rows stay blocked
  - warmup/work/cooldown specials stay blocked
  - recovery rows stay blocked
  - open cooldown does not become `Open / Extra`
  - missing activity rows and activity count mismatch stay blocked
- Run package tests, a Simulator smoke check, and physical-iPhone install before export proof.
- Require a fresh physical-iPhone export after the promotion build, preferably June 12 first, then optionally May 26 / June 1 / June 2 / June 4.

## Why Not Promote Paused Repeat Blocks Yet

Paused repeat-block proof is strong, but the implementation risk is higher:

- It must preserve elapsed row windows while computing active/timer duration from paired pause overlap.
- It has multiple row-level pause-overlap cases.
- Unpaired or ambiguous pause evidence must fall back cleanly.
- It is easier to create a UI that appears precise while hiding timer semantics.

At the time of this Gate A review, paused repeat blocks stayed debug/export-only until the simpler Gate A promotion proved the normal-detail promotion path was safe. That condition is now superseded for the narrow paused-repeat `Cooldown(Open)` shape only; broader paused-repeat tails remain blocked.

## Why Not Promote Recovery-Tail Yet

The May 1 recovery-tail proof passed, but it combines several sensitive concerns:

- planned Recovery row preservation
- fixed final Cooldown exhaustion
- post-plan Open/Extra separation
- paired pause evidence
- active-time subtraction

It should remain debug/export-only until at least one more guard or proof confirms the same rule does not leak into open-cooldown or non-recovery special cases.

## Next Recommended Goal

Implement one narrow normal-detail promotion for Gate A simple fixed-distance `Work > Open / Extra`, behind the exact guardrails above.

This was a code-changing Gate A task with tests and physical-device proof. Its scope did not include paused repeat blocks, recovery-containing tails, broad repeat-tail behavior, interval-row analytics, coaching, VDOT, training load, recovery scoring, or race prediction. The later narrow paused-repeat `Cooldown(Open)` gate was handled by a separate task and proof folder.
