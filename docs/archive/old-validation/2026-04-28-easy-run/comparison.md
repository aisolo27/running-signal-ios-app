# Apple Fitness vs RunSignal Comparison

## Comparison Table

| Row | Label | Apple Distance | RunSignal Distance | Distance Delta | Apple Time | RunSignal Time | Time Delta | Pass? | Notes |
|---:|---|---:|---:|---:|---:|---:|---:|---|---|
| 1 | Work | 7.25 km | 7.26 km | +6.3 m | 46:12 | 46:09 | -3.2 s | Temporary | Fresh physical-device query recovered WorkoutKit plan and distance boundary diagnostics. |
| 2 | Open | 46 m | 48.3 m | +2.3 m | 0:20 | 0:23 | +3.0 s | Temporary | Open / Extra is real post-goal tail evidence; do not hide or merge from this fixture alone. |

## Finding

April 28 is no longer evidence unavailable. The physical-device force re-enrich recovered the WorkoutKit plan, rich HealthKit samples, route data, reconstructed Work/Open rows, and boundary diagnostics.

Treat April 28 as an evidence-recovery and fresh-query validation fixture. It is a temporary pass candidate under the current fixture tolerances, but it is not a main repeated-interval boundary tuning fixture.

## Force Re-Enrich Result

- Workout UUID: `9AD88333-024B-4476-B81F-7D15A8E0FC89`
- Authorization: authorized.
- Cache invalidated: true.
- Cache present before refresh: false.
- Fresh query returned workout: true.
- Evidence source after export: freshQuery.
- Diagnostics warnings: none.

The previous failure was likely cache/enrichment/query-path related, but stale cache is not proven because `cacheWasPresent` was false during force re-enrich.
