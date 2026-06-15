# Custom Workout Correctness Lock v1

Last updated: 2026-06-15

## Goal

Lock the next RunSignal milestone around custom Apple Watch running workout correctness before expanding interval-row analytics.

This milestone keeps the app focused on trusted completed-workout analysis:

- HealthKit remains the only runtime workout source.
- WorkoutKit plan data remains optional planned-structure evidence.
- FIT remains an offline validation oracle only.
- Apple Fitness screenshots remain sanity evidence, not the main gate.
- Coaching, VDOT, training load, race prediction, recovery scoring, backend sync, and file import remain out of scope.

## Decision

Do not broaden normal workout detail interval promotion yet.

Keep the existing five narrow normal-detail gates as the only approved custom-workout interval classes:

1. Stopped-early single fixed-distance `Work` mapped to one complete partial HealthKit activity row.
2. `Warmup(2 km) > one Work step > Cooldown(Open)`.
3. `Warmup(2 km) > one Work step > fixed Cooldown > inferred Open / Extra tail`.
4. Clean no-pause repeat blocks shaped as `Warmup(2 km) > repeated Work/Recovery rows > Cooldown(Open)`.
5. Clean no-pause repeat blocks shaped as `Warmup(2 km) > repeated Work/Recovery rows > fixed Cooldown > inferred Open / Extra tail`.

Everything else stays blocked, debug-only, or whole-workout-only until its exact workout shape has evidence and fallback behavior.

## Acceptance Matrix

| Workout shape | Current app behavior | Evidence status | Allowed UI behavior | Blocker / next evidence |
| --- | --- | --- | --- | --- |
| Plain open Watch run | Readable normal run with splits and whole-run analysis; no custom interval reconstruction | FIT can contain split laps and HealthKit activity rows, but zero WorkoutKit planned steps | Show normal workout detail, splits, route, and whole-run stats. Do not invent Warmup/Work/Recovery/Cooldown rows | Keep as open-run control when validating custom workout logic |
| Stopped-early single fixed-distance `Work` | Internally gated into normal detail as partial `Work` only for the exact one-step/one-activity shape | June 14 stopped-early control has one FIT lap and one active distance target | Show one partial `Work` row when one planned Work step maps to one complete partial HealthKit activity row | Do not generalize to broad simple Work/Open promotion |
| Simple fixed-distance `Work + Open` | Gate A says eligible for a narrow feature-flagged prototype, but implementation is parked | FIT-backed Gate A supports the candidate class | Keep whole-workout behavior unless a later task explicitly approves a feature-flagged debug prototype | Needs explicit prototype approval and guard cases proving unsupported shapes stay blocked |
| `Warmup > Work > Cooldown(Open)` | Internally gated for the narrow supported no-tail class | Row-level FIT support exists for the exact no-tail candidate class | Show Warmup/Work/Cooldown rows only when planned rows map one-to-one to complete contiguous HealthKit activity rows | Inconclusive outliers still need separate review before broad warmup/work/cooldown promotion |
| `Warmup > Work > fixed Cooldown > Open / Extra` | Internally gated for the clean fixed-cooldown tail class | Current evidence supports final extra activity as `Open / Extra` only when it is the only extra row after fixed cooldown | Show planned rows plus inferred final `Open / Extra` tail for the exact clean subclass | Recovery-containing tails and ambiguous tails remain blocked |
| Clean no-pause repeat blocks ending in `Cooldown(Open)` | Internally gated into normal detail | Physical iPhone proof confirms expanded repeat rows with final Cooldown and no Open/Extra tail | Show expanded Work/Recovery rows and final Cooldown when activity rows are complete and contiguous | Paused repeat blocks and material row shifts are not approved |
| Clean no-pause repeat blocks ending in fixed cooldown plus `Open / Extra` | Internally gated into normal detail | Physical iPhone proof confirms expanded repeat rows, fixed Cooldown, and final Open/Extra | Show expanded Work/Recovery rows, fixed Cooldown, and final Open/Extra for the exact clean subclass | Repeat-block tail ambiguity remains a separate blocker |
| Paused repeat blocks | Blocked from normal-detail interval promotion | `paused-repeat-block-timer-rule-2026-06-15.md` defines a docs/debug timer rule: keep elapsed row windows, subtract paired pause overlap for active/timer duration, and require repeat mapping plus guards before any prototype | Keep debug/Parity Lab evidence visible; normal detail should fall back or show blocked placeholder | Needs explicit debug prototype approval proving row count, labels, elapsed duration, active/timer duration, pause overlap, distance, tail behavior, and unsupported guard fallbacks |
| Recovery-containing Open/Extra tail | Blocked from normal-detail interval promotion | `recovery-containing-open-tail-rule-2026-06-15.md` defines a docs/debug separator rule for the May 1-style shape: preserve planned Recovery, map all fixed planned rows, and create Open/Extra only after fixed planned rows are exhausted | Keep debug/Parity Lab evidence visible; normal detail should fall back or show blocked placeholder | Needs explicit debug prototype approval proving Recovery mapping, final fixed-step exhaustion, tail threshold, open-cooldown guards, and unsupported fallbacks |
| Ambiguous repeat-tail cases | Blocked from normal-detail interval promotion | `ambiguous-repeat-tail-rule-2026-06-15.md` defines a docs/debug separator rule: expand repeat rows, map every planned row, keep open cooldown as Cooldown, and create Open/Extra only after a resolved fixed final row | Keep debug/Parity Lab evidence visible; normal detail should fall back or show blocked placeholder | Needs explicit debug prototype approval proving repeat expansion, final fixed-row exhaustion, tail threshold, open-cooldown guards, and unsupported fallbacks |
| Timer-drift or pause-heavy outliers | Blocked unless covered by an approved narrow gate | Gate B timer-drift docs show elapsed-vs-timer and pause-event artifacts | Preserve elapsed, timer, and pause diagnostics; avoid collapsing to one derived duration | Needs per-shape timer decision and material-error threshold before any UI promotion |
| No-plan, duplicate, same-day extra, or guard-unknown workouts | Excluded from approval scoring | Not reliable promotion evidence | Treat as normal workouts or debug evidence only, depending on available HealthKit detail | Keep excluded unless a later task reclassifies the workout with fresh evidence |

## Execution Order

1. Freeze current normal-detail gates.

   Do not broaden `HKWorkoutActivity` promotion or normal-detail interval UI while blocked classes remain unresolved.

2. Use this matrix as the routing table for the next validation cycle.

   Every candidate change should name the exact workout shape it affects and the row-level evidence it relies on.

3. Close blocked classes one at a time.

   Priority order:

   1. Paused repeat blocks. Timer rule is defined for docs/debug work, but prototype/UI promotion is still blocked.
   2. Recovery-containing Open/Extra tails. Separator rule is defined for docs/debug work, but prototype/UI promotion is still blocked.
   3. Ambiguous repeat-tail cases. Separator rule is defined for docs/debug work, but prototype/UI promotion is still blocked.
   4. Simple fixed-distance Work/Open prototype discussion.

4. Keep a debug-only prototype between evidence and production UI.

   A future prototype must first run through Parity Lab/export paths and prove:

   - row count agreement
   - label agreement
   - elapsed duration, active duration, pause overlap, and distance tolerance
   - unsupported cases remain blocked
   - plain open runs remain plain open runs
   - FIT is not used as runtime truth

5. Add interval-row analytics only after structure stability.

   Per-row pace, heart-rate response, cadence, power, repeat consistency, warmup quality, and cooldown quality should wait until the relevant workout-style matrix rows are supported or intentionally blocked.

## Promotion Checklist

A workout shape can move from blocked/debug-only toward normal-detail UI only when all of these are true:

- The exact shape is named in the acceptance matrix.
- Planned WorkoutKit rows are present or the fallback reason is explicit.
- HealthKit activity rows are complete, contiguous, and have distance evidence when used for display boundaries.
- FIT row-level evidence supports label, timing, and distance within the working tolerance.
- Pause/resume evidence is either absent or handled by an approved timer rule.
- Open/Extra tail handling is explicit and does not rely on label guesswork.
- At least one guard fixture proves a similar unsupported shape still blocks.
- Parity Lab/export output reports the status, fallback reasons, row confidences, tail ambiguity, and safety flags.
- Normal workout detail behavior is approved separately after debug/export proof.

## Non-Goals

- No coaching expansion.
- No VDOT.
- No training load expansion.
- No race prediction.
- No recovery scoring.
- No backend sync.
- No FIT import, FIT backup, HealthFit export feature, or file-based workout ingestion.
- No HealthFit production dependency.
- No broad custom-workout promotion from count alignment alone.
