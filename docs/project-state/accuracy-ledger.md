# RunSignal Accuracy Ledger

Last updated: 2026-06-28

## Purpose

This is the first-read status board for RunSignal workout accuracy.

Use this ledger to answer:

- Which workout shapes are trusted in normal workout detail?
- Which shapes are debug-only?
- Which shapes are intentionally blocked?
- Which future analytics are allowed to use reconstructed interval rows?
- Which older docs are source evidence rather than the daily roadmap?

The product standard is not "perfectly clone Apple Fitness." Apple does not expose every private Fitness calculation or display rule. The product standard is: every supported row is proven from public HealthKit/WorkoutKit evidence, every unsupported row has a clear fallback reason, and the app never presents guessed interval analytics as certain.

## Source Rules

- HealthKit is the runtime source of truth for completed workouts.
- HealthKit access remains read-only.
- WorkoutKit plan data is used when available to understand planned structure.
- HealthKit samples and `HKWorkout.workoutActivities` provide measured stats and public boundary evidence.
- HealthKit segment markers stay raw/debug-only.
- FIT and HealthFit files are offline validation evidence only. They are never app inputs, runtime truth, imports, backups, or production dependencies.
- Apple Fitness screenshots are optional sanity evidence. They are not the main promotion gate.

## Status Labels

| Status | Meaning | Normal workout detail | Analytics allowed |
| --- | --- | --- | --- |
| `Proven` | Exact shape has enough proof and guard coverage for the approved narrow behavior | Yes, only for the exact approved shape | Yes, only after the analytics readiness bar is met |
| `Debug-only` | Evidence is promising, but proof or guard coverage is not enough for normal UI | No, except debug/Parity Lab output | No |
| `Blocked` | Shape must not promote because a rule, proof packet, tolerance, or guard is missing | No | No |
| `Whole-run only` | Workout can be analyzed as a normal completed run, but not as custom interval rows | Whole-run detail, splits, route, and safe summaries only | Whole-run analytics only |
| `Excluded` | Not valid promotion evidence because data is duplicate, no-plan, summary-only, stale, or unknown | Safe fallback only | No row-level analytics |
| `Parked` | Future product area waiting for the truth layer | No new behavior | No |

## Promotion Ladder

Every workout shape moves through this ladder. A shape cannot skip rungs.

### 1. Shape Named

Concrete bar:

- The shape has one ledger row.
- The row names the exact planned structure, not a broad family label.
- The row says whether it depends on pauses, repeat expansion, fixed cooldown exhaustion, or `Open / Extra` tail inference.
- The row names the expected fallback when the exact shape does not match.

### 2. Evidence Available

Concrete bar:

- At least one current Raw HealthKit Debug export exists for the exact shape.
- At least one parity packet or equivalent structured export exists for the exact shape.
- WorkoutKit plan status is explicit: present, unavailable, or intentionally not required for the shape.
- Matching FIT evidence is available when the claim depends on row boundaries, tails, elapsed/timer comparison, or repeat mapping.
- Apple Fitness screenshots may help, but cannot be the only promotion evidence.

### 3. Debug-Supported

Concrete bar:

- Recurring shapes need at least 2 positive real-workout examples before a debug-supported label.
- Rare control shapes may use 1 positive example only when the ledger marks them `rare-control` and blocks broad generalization.
- At least 1 similar unsupported guard case must remain blocked.
- Debug exports must agree on row count, labels, elapsed duration, active/timer duration when pauses exist, pause overlap, distance, tail status, fallback reasons, row confidence, and safety flags.
- For no-pause distance-boundary rows, row distance error must be inside the current working tolerance of 10 meters unless the shape-specific evidence doc sets a stricter rule.
- For no-pause elapsed rows, row elapsed-time error must be inside the current working tolerance of 5 seconds unless the shape-specific evidence doc sets a stricter rule.
- Paused rows cannot pass from elapsed time alone. They need an approved pause/timer rule and paired pause evidence.
- Tail rows cannot pass from count alignment alone. They need an explicit shape-specific `Open / Extra` rule.

### 4. Proven For Normal Detail

Concrete bar:

- The shape is already `Debug-supported`.
- Recurring shapes need at least 2 physical-iPhone proof workouts from the current app behavior.
- Rare controls can use 1 physical-iPhone proof workout only when the ledger marks them `rare-control` and the UI behavior stays narrow.
- At least 1 similar unsupported guard case must be covered by tests or proof and must still block.
- Package tests must include at least 1 positive and 1 negative/guard assertion for the shape family.
- `swift test --package-path RunningWorkoutAnalysisPackage` must pass.
- If normal UI behavior changes, a Simulator smoke check is required.
- If real HealthKit behavior is being proven, physical-iPhone export proof is required.
- FIT must remain offline validation only.

### 5. Analytics Allowed

Concrete bar:

- The workout shape is `Proven`, or it is explicitly `Whole-run only`.
- Normal workout detail rows and Raw HealthKit Debug/parity rows agree on labels, row count, elapsed duration, active/timer duration, pause overlap, distance, tail status, and fallback reasons.
- At least 1 supported fixture and 1 blocked guard fixture exist for each analytics family that depends on custom rows.
- Analytics UI must show confidence or fallback state instead of filling gaps with inferred custom rows.
- `DerivedAnalyticsEngine.intervalCandidates` cannot be used as trusted interval analytics until it is rewired through approved reconstruction, pause-window resolution, and regression tests.

## Current Accuracy Ledger

### Proven Or Whole-Run Safe

| Shape | Status | Allowed behavior | Proof basis | Do not broaden into |
| --- | --- | --- | --- | --- |
| Plain open Watch run | `Whole-run only` | Show normal workout detail, splits, route, and whole-run stats. Do not invent custom interval rows. | Plain open-run controls have no WorkoutKit planned steps; FIT may contain split laps but not custom plan rows. | Custom Warmup/Work/Recovery/Cooldown rows |
| Stopped-early single fixed-distance `Work` | `Proven` narrow, `rare-control` | Show one partial `Work` row only when one planned fixed-distance Work step maps to one complete partial HealthKit activity row. | June 14 stopped-early control with matching FIT one-lap/one-step evidence. | Completed Work/Open, repeat, paused, tail, or analytics behavior |
| Simple fixed-distance `Work > Open / Extra` | `Proven` narrow | Show `Work 1` plus inferred `Open / Extra` only for exactly one fixed-distance Work step, one complete activity row, and positive tail. | Gate A March-June FIT support plus physical-iPhone June 12 post-promotion proof. | Structured/special workouts, paused workouts, recovery rows, repeat rows, missing evidence, broad `HKWorkoutActivity` promotion |
| `Warmup(2 km) > one Work step > Cooldown(Open)` | `Proven` narrow | Show Warmup, Work, and final Cooldown rows when planned rows map one-to-one to complete contiguous HealthKit activity rows. | Narrow normal-detail gate and supported row-level examples such as March 5 and April 24. | Broad warmup/work/cooldown promotion or paused timer outliers |
| `Warmup(2 km) > one Work step > fixed Cooldown > Open / Extra` | `Proven` narrow | Show planned rows plus final inferred `Open / Extra` only for the clean fixed-cooldown tail subclass. | Current narrow normal-detail gate and fixed-cooldown tail proof. | Recovery-containing tails, repeat tails, or ambiguous tails |
| Clean no-pause repeat block ending in `Cooldown(Open)` | `Proven` narrow | Show expanded Work/Recovery rows and final Cooldown. | Physical-iPhone repeat proof with complete expanded rows and no tail. | Paused repeats, ambiguous tails, missing rows, or broad repeat promotion |
| Clean no-pause repeat block ending in fixed Cooldown plus `Open / Extra` | `Proven` narrow | Show expanded Work/Recovery rows, fixed Cooldown, and final `Open / Extra` for the exact clean subclass. | Physical-iPhone repeat-tail proof for the clean fixed-cooldown subclass. | Ambiguous repeat tails or paused fixed-tail repeats |
| Narrow paused repeat block ending in `Cooldown(Open)` | `Proven` narrow | Show expanded Work/Recovery rows and final Cooldown; paused rows display active/timer duration while diagnostics keep elapsed and pause overlap. | Physical-iPhone paused-repeat proof for Apr 22, Apr 29, May 6, May 13, and May 27. | Broad paused tails, unpaired pauses, cross-row pauses, missing rows |
| Narrow paused repeat block ending in fixed Cooldown plus `Open / Extra` | `Proven` narrow | Show expanded Work/Recovery rows, fixed Cooldown, and final inferred `Open / Extra` when paired pause windows are assignable to one reconstructed row; paused rows display active/timer duration. | June 26 proof plus June 28 Priority 1 proof and guard coverage for zero-pause fixed-tail control, cross-row pause rejection, and open-cooldown counter-case. | Broad paused tails, ambiguous repeat tails, unpaired pauses, cross-row pauses, missing rows, or broad Gate B promotion |
| Narrow May 1-style recovery-containing fixed-cooldown `Open / Extra` | `Proven` exact narrow | Preserve `Recovery 1`, fixed `Cooldown`, inferred final `Open / Extra`, and paired pause-overlap subtraction. | Current-build physical-iPhone May 1-style proof. | General recovery-tail support |

### Debug-Only

| Shape | Status | Current allowed behavior | Missing bar before normal detail |
| --- | --- | --- | --- |
| Broader no-tail warmup/work/cooldown candidate review | `Debug-only` | Use row-level evidence for future discussion of exact no-tail W/W/C shapes. | More proof or explicit decision that the current examples are enough; outliers such as March 19 and May 29 stay excluded |
| Recovery-containing tail debug separator outside May 1 exact shape | `Debug-only` | Use debug output to preserve Recovery rows and explain fallback. | Exact new shape rule, fixed-row exhaustion proof, pause handling, guard coverage |

### Blocked

| Shape | Status | Why blocked | Next action |
| --- | --- | --- | --- |
| Unresolved ambiguous repeat-tail cases | `Blocked` | Count alignment or FIT session-minus-lap residuals alone are not enough. Need expanded repeat mapping, fixed final-row exhaustion, tail threshold/status, and guard behavior. | Keep fallback tests locked; approve only a new exact narrow shape if future evidence supports it |
| Broad paused repeat fixed-tail or ambiguous paused-tail cases | `Blocked` | The narrow paired-pause fixed-cooldown/`Open / Extra` shape is proven, but broad paused-tail behavior and ambiguous repeat tails still lack exact shape rules and guard coverage. | Promote only exact shapes through this ledger; keep broad behavior blocked |
| Broad recovery-containing `Open / Extra` tails | `Blocked` | Recovery rows must not be merged into residual movement. May 1-style is the only proven narrow recovery-tail gate. | Define exact shape rules one at a time or keep whole-run/debug fallback |
| Paused warmup/work/cooldown timer outlier, including May 29-style cases | `Blocked` | Distance/labels may look close, but elapsed-vs-timer behavior needs a shape-specific paused W/W/C timer rule. | Create timer rule and guard tests before any promotion |
| March 19-style warmup/work/cooldown distance drift | `Blocked` | Candidate timing aligns, but warmup distance drift remains too large for promotion. | Keep blocked unless renewed evidence resolves the distance drift |
| Duplicate, same-day extra, no-plan, guard-unknown, stale summary-only, or missing-detail workouts | `Excluded` | They are not reliable promotion evidence. | Use as fallback/debug evidence only unless fresh proof reclassifies them |
| Broad `HKWorkoutActivity` boundary promotion | `Blocked` | Nine narrow gates are proven; broad production promotion is not approved. | Promote exact shapes only through this ledger |

### Parked Until Structure Is Stable

| Feature area | Status | Unlock condition |
| --- | --- | --- |
| Per-row pace analytics | `Parked` | Relevant shape is `Proven`; normal-detail and export rows agree |
| Per-row heart-rate response | `Parked` | Relevant shape is `Proven`; row windows and sample coverage are reliable |
| Cadence and power by interval | `Parked` | Relevant shape is `Proven`; samples map to approved row windows |
| Repeat consistency | `Parked` | Repeat-block shapes are `Proven` and guard cases remain blocked |
| Warmup and cooldown quality | `Parked` | W/W/C and cooldown-tail shapes are `Proven` or intentionally blocked with stable fallback |
| Workout-fit scoring | `Parked` | Custom row labels, row windows, pause semantics, and confidence states are stable |
| Coaching, VDOT, training load, recovery scoring, race prediction, AI summaries, backend sync, file import/export | `Parked` or out of scope for v1 | Truth layer complete enough to avoid confident guesses |

## Current Execution Order

1. Keep the `Proven` rows frozen unless evidence shows a real bug.
2. Keep exact paused repeat fixed-tail `Open / Extra` support narrow and covered by its guard cases.
3. Keep ambiguous repeat tails, broad recovery tails, broad paused tails, and paused W/W/C timer outliers blocked unless a later task names one exact shape and walks the promotion ladder.
4. Before any interval-row analytics task, check the ledger row for the workout shape being analyzed.
5. If a task cannot point to one ledger row, split the task before coding.

Latest rung check, 2026-06-28:

- Exact row: `Warmup(2 km) > repeated Work/Recovery rows > fixed final Cooldown > inferred Open / Extra`, with paired pause evidence.
- Promotion rung attempted: rung 4, `Proven For Normal Detail`.
- Result: promoted as a narrow normal-detail gate. June 26 proof in `docs/validation/apple-fitness-interval-parity-dataset/physical-iphone-paused-repeat-fixed-tail-open-extra-proof-2026-06-26/` provides current Raw HealthKit Debug, parity packet, Apple Fitness screenshots, and FIT offline evidence for the exact paired-pause fixed-tail `Open / Extra` row. June 28 Priority 1 proof adds the second current-behavior physical-iPhone instance.
- Archive audit: parsed 64 debug/parity payloads; 36 were repeat-like, 4 had repeat-tail `Open / Extra`, and 32 had paired paused-repeat evidence, but 0 had both paired pauses and a cooldown-before-`Open / Extra` tail. Existing archives do not satisfy this exact row.
- June 25 user-supplied `Thursday Interval 5km` evidence is archived in `docs/validation/apple-fitness-interval-parity-dataset/user-supplied-repeat-tail-review-2026-06-25/`. The current-build re-export passes the fresh readable-label validator and the FIT file confirms an offline session-minus-laps tail residual, but it reports `pairedPauseCount == 0`, so it is not rung 2 paired-pause evidence.
- HealthFit Jan-Jun FIT scan: `docs/validation/apple-fitness-interval-parity-dataset/healthfit-jan-jun-fit-candidate-scan-2026-06-25.md` parsed 124 outdoor running FITs from January 1 through June 30, 2026 and found 0 exact paired-pause fixed-tail repeat matches. June 10 and June 25 are no-pause fixed-tail controls, not paired-pause evidence.
- June 26 proof summary: `TARGET EVIDENCE PRESENT`, `plannedExpandedRowCount == 12`, `candidateRowCount == 13`, `openTailRowCount == 1`, `pairedPauseCount == 3`, fixed cooldown exhausted before tail, `comparison status == supported`, readable fallback labels present, and `usesFITRuntimeTruth == false`.
- Evidence hardening added: fresh exact-shape proof folders should pass `docs/validation/apple-fitness-interval-parity-dataset/validate_parity_export_consistency.py --require-readable-fallback-labels <proof-folder>` before promotion review.
- Implementation check: exact paused repeat fixed-tail `Open / Extra` is now a narrow normal-detail gate when WorkoutKit plan rows match complete contiguous HealthKit activity rows, fixed cooldown is exhausted before the Open tail, paired pause windows are assignable to one reconstructed row, and paused rows use active/timer display. Guard coverage includes zero-pause fixed-tail control, cross-row pause rejection, and open-cooldown counter-case where `Cooldown(Open)` must not become `Open / Extra`. Broader ambiguous repeat tails remain blocked.

## Replacement And Archive Policy

This ledger replaces the scattered day-to-day status reading across these docs:

- `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-correctness-lock-v1.md`
- `docs/validation/apple-fitness-interval-parity-dataset/gate-b-phase-3-readiness-review.md`
- `docs/validation/apple-fitness-interval-parity-dataset/gate-b-agent-findings-2026-03-to-2026-06.md`
- `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-shape-coverage-audit-2026-03-to-2026-06.md`
- `docs/validation/apple-fitness-interval-parity-dataset/fit-backed-two-gate-validation-plan-2026-03-to-2026-06.md`
- `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-production-readiness-plan.md`
- `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-implementation-plan.md`

Those files still matter as source evidence, acceptance details, generated scorecards, or historical decision records. Do not delete or move them during normal feature work.

Archive candidates after explicit approval:

- Move completed date-specific proof folders and historical generated scorecards to `docs/archive/old-validation/` once the ledger and current scorecards point to their summaries.
- Move superseded planning docs to `docs/archive/completed-plans/` only after this ledger fully captures their active decision content.
- Keep `project-status.md`, `documentation-index.md`, `bug-log.md`, active scorecard scripts, current evidence trackers, and current shape-specific rule docs active.

## One-Line Rule

If a future task cannot say which ledger row it moves and which promotion rung it satisfies, it is not ready for Swift changes.


## 2026-06-28 Generalized Resolved Row Contract

Status: `Proven` for normal detail when the evidence gate passes.

Resolved custom workout rows are no longer limited to a fixed shape whitelist. A custom running workout may show interval rows in normal detail when all of these are true:

- WorkoutKit planned rows are available and expanded in order.
- HealthKit activity rows are complete, contiguous, and map one-to-one to planned rows.
- Partial repeat context is rejected; repeat evidence must include the full mapped expanded context.
- Pause/resume streams are paired and every pause window is contained in exactly one resolved row.
- Open / Extra tails are inferred only from the deterministic workout tail after mapped planned rows.
- Missing plans, missing activity rows, non-contiguous rows, unpaired pauses, cross-row pauses, stale summary-only evidence, and material distance drift remain fallback/blocked paths.

Boundary source: complete HealthKit activity rows mapped to WorkoutKit planned rows, matching the Parity Lab candidate-row formula validated against archived Apple Fitness screenshots/manual rows.

Display semantics:

- Primary row duration uses active/timer duration when pause overlap exists.
- Pause overlap and elapsed row-window duration are shown as RunSignal-only detail.
- Average HR, max HR, average running power, and cadence are aggregated from HealthKit samples over each resolved row window.

Regression fixture families: Apr 22, Apr 29, May 27 paused repeat blocks; May 1 recovery/tail; May 13 paused repeat; Jun 25 and Jun 26 repeat-tail controls; Jun 28 priority 1-3.
