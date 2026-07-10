# Paused Repeat With Fixed Tail

Captured: 2026-06-26

This physical-iPhone case contains expanded Work/Recovery repeats, reliable paired pauses inside rows, a fixed cooldown, and deterministic `Open / Extra` activity.

Retained evidence:

- `parity-packet.json`: structured HealthKit/WorkoutKit comparison packet.
- `apple-fitness-intervals.png`: essential Apple Fitness interval view.

Expected behavior:

- Map complete contiguous HealthKit activities to expanded WorkoutKit rows.
- Use elapsed row windows minus paired pause overlap for active/timer duration.
- Keep elapsed, pause, active, and display basis distinct.
- Infer `Open / Extra` only after the fixed cooldown is exhausted.
- Block unpaired, ambiguous, duplicate, or cross-row pauses.

This case proves the exact evidence-gated behavior; it does not authorize guessed rows when the gate fails.
