# Stopped-Early Fixed-Distance Work

Captured: 2026-06-14

This physical-iPhone case is a custom workout stopped before its fixed-distance Work goal completed.

Retained evidence:

- `raw-healthkit-debug.json`: HealthKit/WorkoutKit evidence for the stopped-early row.
- `apple-fitness-intervals.png`: essential Apple Fitness interval view.

Expected behavior:

- One complete partial HealthKit activity maps to the planned Work row.
- Display the measured partial Work only.
- Do not invent planned completion, later planned rows, or `Open / Extra`.
- Keep this distinct from a completed fixed Work followed by real extra activity.
