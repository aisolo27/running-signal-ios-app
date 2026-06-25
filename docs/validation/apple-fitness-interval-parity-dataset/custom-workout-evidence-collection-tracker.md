# Custom Workout Evidence Collection Tracker

Last updated: 2026-06-25

## Purpose

Track balanced custom-workout evidence without asking for files that are already proven or no longer useful.

This tracker is docs/debug validation only. It does not change Swift, production interval behavior, normal workout UI, `HKWorkoutActivity` promotion status, FIT import behavior, HealthFit dependency status, runtime FIT usage, Phase 3 implementation status, or production custom-workout reconstruction behavior.

HealthKit/WorkoutKit remain runtime truth. FIT remains an offline validation oracle only. Apple Fitness screenshots remain sanity evidence when row labels or visual parity need confirmation.

## Current Coverage

Eight narrow normal-detail gates are already implemented and physically proven. Do not recollect these unless a later implementation changes behavior.

| Class | Status | Representative evidence | Notes |
| --- | --- | --- | --- |
| Stopped-early single fixed-distance `Work` | Complete | `2026-06-14-stopped-early-and-open-run/` | Partial `Work` row maps to one complete partial HealthKit activity row. Plain open-run control remains a normal workout without custom rows. |
| Simple fixed-distance `Work > Open / Extra` | Complete | `physical-iphone-gate-a-work-open-proof-2026-06-15/` | Gate A is closed only for one fixed-distance Work step, one complete activity row, and positive Open/Extra tail. |
| `Warmup(2 km) > one Work step > Cooldown(Open)` | Complete | March 5 and April 24 structured comparison exports and screenshots | Narrow no-tail warmup/work/open-cooldown class is supported; broad Gate B remains blocked. |
| `Warmup(2 km) > one Work step > fixed Cooldown > Open / Extra` | Complete | June 5 evidence in `physical-iphone-parity-lab-proof-2026-06-13/` and current normal-detail gate state | Fixed-cooldown exhaustion and tail handling are approved only for the exact clean subclass. |
| Clean no-pause repeat ending in `Cooldown(Open)` | Complete | `physical-iphone-repeat-block-proof-2026-06-14/` | May 20 and June 3 prove expanded Work/Recovery rows plus final Cooldown. |
| Clean no-pause repeat with fixed cooldown plus `Open / Extra` | Complete | `physical-iphone-repeat-tail-proof-2026-06-15/` | June 10 proves the clean fixed-cooldown repeat-tail subclass. June 25 user-supplied evidence in `user-supplied-repeat-tail-review-2026-06-25/` matches the shape, passes fresh readable-label validation after re-export, and includes FIT offline tail evidence. |
| Paused repeat ending in `Cooldown(Open)` | Complete | `physical-iphone-paused-repeat-normal-detail-promotion-proof-2026-06-23/` | Apr 22, Apr 29, May 6, May 13, and May 27 prove active/timer display for paused rows. |
| May 1-style recovery-containing fixed cooldown plus `Open / Extra` | Complete | `physical-iphone-recovery-tail-normal-detail-promotion-proof-2026-06-23/` | Preserves planned Recovery row and infers Open/Extra only after fixed planned rows. |

## Still Blocked

These are not collection gaps by themselves. They need explicit rule decisions or implementation tasks before new artifacts become useful.

| Class | Current status | Useful future evidence |
| --- | --- | --- |
| Broad Gate B structured intervals | Blocked | Only after a task approves a debug prototype or a specific subclass. |
| True Open/Extra paused-repeat tails | Blocked | A real paused repeat with fixed final row and unambiguous post-final-row Open/Extra tail, plus Raw HealthKit Debug export, parity packet, FIT, and Apple Fitness rows. The June 25 user-supplied tail run had `pairedPauseCount == 0`, so it does not qualify for this row. |
| Ambiguous repeat-tail cases outside the clean June 10 shape | Blocked | Only if a later task names a new exact candidate shape. |
| Broad recovery-containing tails outside May 1 style | Blocked | Only if a later task defines a narrower recovery-tail subclass. |
| March 19 distance-drift warmup/work/cooldown | Blocked | Re-capture only if a later distance-drift task needs exact Apple Fitness Work-row distance. |
| May 29 paused warmup/work/open-cooldown | Blocked for broad Gate B | Candidate only for a future paused warmup/work/open-cooldown timer-rule task. |
| Timer-drift repeat outliers | Blocked for broad Gate B | AIS-29 classifies pause-explained drift as non-material for boundary timing, but repeat/tail/shape blockers still apply. |

## Optional Future Collection

Use this only when new workouts naturally occur. Do not create abnormal workouts just to fill the table.

| Target | Minimum useful count | Why |
| --- | ---: | --- |
| Plain open-run controls | 2 more | Confirms custom-workout gates do not leak into ordinary runs. |
| Clean no-pause easy Work/Open controls | Optional | Gate A already has sufficient proof; collect only if a future edit touches Gate A. |
| Future paused warmup/work/open-cooldown | 1-2 | Useful only if a later task proposes that exact timer-rule subclass. |
| Future true paused repeat fixed-tail Open/Extra | 1-2 | Useful only if collected workout has paired pauses and an unambiguous post-fixed-row tail. |
| Future broad recovery-tail variants | 1-2 | Useful only after a later task defines the exact subclass. |

2026-06-25 ledger check: the exact paused repeat fixed-tail `Open / Extra` row is named, but it does not yet satisfy `Evidence Available`; existing paused-repeat proof is the open-cooldown control shape, and FIT session-minus-lap tail evidence is offline validation only. Fresh exact-shape proof folders should pass `validate_parity_export_consistency.py --require-readable-fallback-labels <proof-folder>` before they are treated as rung 2 evidence.

2026-06-25 archive audit: 64 parsed debug/parity payloads contained 36 repeat-like payloads, 4 repeat-tail `Open / Extra` payloads, and 32 paired paused-repeat payloads, but 0 payloads with both paired pauses and a cooldown-before-`Open / Extra` tail.

2026-06-25 user-supplied review: `user-supplied-repeat-tail-review-2026-06-25/` archives Raw HealthKit Debug, parity packet, Apple Fitness screenshots, and FIT for `Thursday Interval 5km`. The current-build re-export passes strict readable-label validation. The candidate scorer reports 12 planned rows, 13 candidate rows, 1 Open/Extra tail, and 0 paired pauses; FIT offline evidence shows 12 laps, 5 unexpanded workout steps, and an 8.255 s session-minus-laps tail. This is useful no-pause tail context but not active paired-pause fixed-tail evidence.

2026-06-25 HealthFit Jan-Jun scan: `healthfit-jan-jun-fit-candidate-scan-2026-06-25.md` parsed 124 outdoor running FIT files from January 1 through June 30, 2026. It found 0 exact paired-pause fixed-tail repeat matches. June 10 and June 25 are the only repeat fixed-cooldown tail near matches, and both have `pairedPauseCount == 0`; the paired-pause exact shape still needs a future deliberate workout.

## Do Not Recollect

These workouts already have enough evidence for the current correctness-lock milestone:

- `2026-03-05T14:37:43Z`
- `2026-04-22T11:39:58Z`
- `2026-04-24T12:02:30Z`
- `2026-04-29T11:49:02Z`
- `2026-05-01T12:07:44Z`
- `2026-05-06T12:02:13Z`
- `2026-05-13T11:52:06Z`
- `2026-05-20T11:43:00Z`
- `2026-05-27T11:45:47Z`
- `2026-05-29T11:49:28Z`
- `2026-06-03T11:45:08Z`
- `2026-06-05T11:53:53Z`
- `2026-06-10T11:27:51Z`
- June 12 Gate A fixed-build proof set
- June 14 stopped-early and plain open-run controls

## Collection Checklist

When a later task asks for new physical evidence, collect the smallest named artifact set:

1. RunSignal Raw HealthKit Debug export.
2. RunSignal selected-workout parity packet export.
3. Apple Fitness summary screenshot.
4. Apple Fitness interval-row screenshots when row labels or row totals matter.
5. HealthFit FIT file only for offline validation, never runtime use.
6. Note exact Apple Watch template, planned pause status, and whether the workout was stopped early.

## Acceptance Rule

Evidence collection stays balanced across easy, tempo, interval, tail, paused, stopped-early, and plain open-run controls. New evidence should only be requested when it can close a named blocked class, verify a changed implementation, or provide a real control for a planned prototype.
