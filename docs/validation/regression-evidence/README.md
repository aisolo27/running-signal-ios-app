# Canonical Regression Evidence

This folder retains one compact real-device packet for each behavior that public Apple documentation and code fixtures cannot prove alone. Current behavior and exact test mappings live in `docs/project-state/regression-cases.md`.

Retained cases:

- `clean-repeat-fixed-tail`: clean repeated Work/Recovery with fixed cooldown and deterministic `Open / Extra`.
- `paused-repeat-fixed-tail`: paired pauses inside repeated rows, fixed cooldown, and deterministic extra tail.
- `planned-open-cooldown`: an open cooldown remains Cooldown through workout end.
- `manual-skip-shortened-work`: Priority 5 paused/manual-skip measured-row semantics and pace-target result.
- `stopped-early-work`: partial fixed-distance Work maps to a completed HealthKit activity row.
- `blocked-distance-drift`: plausible alignment that remains intentionally blocked because boundary drift is unsafe.

Do not add routine workouts, generated scorecards, duplicate screenshots, FIT files, or speculative plans here. Add evidence only when a new real-device behavior cannot be represented by an existing case and its guard tests.
