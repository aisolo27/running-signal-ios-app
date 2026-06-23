# Gate B Warmup/Work/Cooldown Outlier Review

Last updated: 2026-06-23

## Scope

AIS-28 reviews the remaining warmup/work/cooldown outliers after the Gate B scoring refresh.

This is offline validation only. It does not change runtime reconstruction, normal workout detail gates, HealthKit reads, FIT usage, or app UI.

Sources reviewed:

- `gate-b-row-level-fit-boundary-scorecard-2026-03-to-2026-06.md`
- `gate-b-phase-3-readiness-review.md`
- `gate-b-agent-findings-2026-03-to-2026-06.md`
- `gate-b-narrow-warmup-work-cooldown-candidate-scorecard-2026-03-to-2026-06.md`
- `gate-b-timer-drift-evidence-2026-03-to-2026-06.md`
- `custom-workout-candidate-reconstruction-rule-scorecard-2026-03-to-2026-06.md`

## Classification Summary

Gate B remains blocked for broad warmup/work/cooldown promotion.

| Start | Shape | Evidence read | AIS-28 classification |
| --- | --- | --- | --- |
| `2026-03-05T14:37:43Z` | `Warmup(2 km) > Work(900 s) > Cooldown(Open)` | Candidate timing error `0.0 s`, distance error `7.5 m`, exact `3/3/3/3/3` row counts. | Candidate, no-tail warmup/work/open-cooldown only. |
| `2026-03-19T16:51:00Z` | `Warmup(2 km) > Work(1500 s) > Cooldown(Open)` | Candidate timing aligns, but warmup distance drift is `24.0 m`, outside the `10 m` row tolerance. | Blocked. |
| `2026-04-24T12:02:30Z` | `Warmup(2 km) > Work(4 km) > Cooldown(Open)` | Candidate timing error `0.0 s`, distance error `6.7 m`, exact `3/3/3/3/3` row counts. | Candidate, no-tail warmup/work/open-cooldown only. |
| `2026-05-29T11:49:28Z` | `Warmup(2 km) > Work(3 km) > Cooldown(Open)` | Distance error is close at `6.6 m`, but elapsed-vs-timer drift is `158.9 s`; paired HealthKit pause overlap is `159.0 s`. | Blocked from broad Gate B/no-tail promotion; future paused warmup/work/open-cooldown timer rule candidate only. |
| `2026-06-05T11:53:53Z` | `Warmup(2 km) > Work(2 km) > fixed Cooldown + Open/Extra tail` | Candidate timing error `0.0 s`, distance error `6.6 m`, but it depends on fixed-cooldown exhaustion plus Open/Extra tail handling. | Blocked from broad Gate B promotion; already separated fixed-cooldown/Open-tail subclass candidate only. |

## High-Drift Rows

The high-drift rows in `gate-b-timer-drift-evidence-2026-03-to-2026-06.md` are not broad Gate B candidates.

| Start | Gate B decision | Drift read | AIS-28 classification |
| --- | --- | --- | --- |
| `2026-03-10T13:49:08Z` | `repeat_block_needs_rule` | Candidate duration matches FIT elapsed, not FIT timer; paired pause overlap explains the delta. | Blocked for Gate B until repeat expansion and timer policy are explicitly approved. |
| `2026-04-22T11:39:58Z` | `repeat_block_needs_rule` | Timer drift is explained by paired pause overlap. | Blocked for broad Gate B; already handled only by the separate narrow paused-repeat open-cooldown gate. |
| `2026-04-29T11:49:02Z` | `repeat_block_needs_rule` | Timer drift is explained by paired pause overlap. | Blocked for broad Gate B; already handled only by the separate narrow paused-repeat open-cooldown gate. |
| `2026-05-06T12:02:13Z` | `repeat_block_needs_rule` | Timer drift is explained by paired pause overlap. | Blocked for broad Gate B; already handled only by the separate narrow paused-repeat open-cooldown gate. |
| `2026-05-13T11:52:06Z` | `repeat_block_needs_rule` | Timer drift is explained by paired pause overlap, with row tolerance still not a broad-rule pass. | Blocked for broad Gate B; already handled only by the separate narrow paused-repeat open-cooldown gate. |
| `2026-05-27T11:45:47Z` | `repeat_block_needs_rule` | Timer drift is explained by paired pause overlap, with row tolerance still not a broad-rule pass. | Blocked for broad Gate B; already handled only by the separate narrow paused-repeat open-cooldown gate. |

## Decision

Do not start a broad Gate B prototype from these outliers.

Safe next work:

1. Define a material-error timer-drift policy that keeps elapsed row-window, paired pause overlap, and active/timer duration visible separately.
2. Keep March 19 blocked unless new evidence specifically resolves the `24.0 m` warmup distance drift.
3. Treat May 29 as a paused timer-rule candidate only; do not mix it into the no-pause warmup/work/open-cooldown candidate class.
4. Keep June 5 tied to the fixed-cooldown/Open-tail subclass, not a broad Gate B warmup/work/cooldown rule.
5. Keep high-drift repeat rows separate from warmup/work/cooldown promotion; repeat expansion and timer policy both need explicit approval.

## Boundaries

- HealthKit remains read-only runtime truth.
- WorkoutKit remains optional planned-structure evidence.
- FIT remains offline validation evidence only.
- No FIT import, file ingestion, HealthFit dependency, new HealthKit permissions, coaching, VDOT, training load, recovery scoring, race prediction, WeatherKit, or interval-row analytics.
