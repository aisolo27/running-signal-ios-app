# RunSignal Observed Intervals

Current values from `exports/runsignal-diagnostics/runsignal-raw-healthkit-debug-2026-04-28.md` and `exports/runsignal-diagnostics/runsignal-parity-packet-2026-04-28.json`.

RunSignal summary:

- Duration: 46:32.
- Distance: 7.30 km.
- Avg pace: 6:22/km.
- Avg HR: 133 bpm.
- Max HR: 145 bpm.
- Power: 192 W.
- Top-level evidence events: 14.

Physical-device force re-enrich result:

- `authorizationState`: authorized.
- `invalidatedCache`: true.
- `freshQueryReturnedWorkout`: true.
- `cacheWasPresent`: false.
- `evidenceSource`: freshQuery.
- `diagnosticsWarnings`: none.

| Row | Label | Goal | Target | RunSignal Distance | RunSignal Time | RunSignal Pace | RunSignal Avg HR | Source | Notes |
|---:|---|---|---|---:|---:|---:|---:|---|---|
| 1 | Work 1 | 7.25 km | pace range 6:00-6:30/km | 7.26 km / 7256.3 m | 46:09 / 2768.8 s | 6:22/km | 133 bpm | WorkoutKit + HealthKit reconstructed | Crossing sample end, +2.2 s adjustment, 6.3 m overshoot, high confidence. |
| 2 | Open / Extra | Open | Target unavailable | 0.05 km / 48.3 m | 0:23 / 23.0 s | 7:56/km | 139 bpm | WorkoutKit + HealthKit reconstructed | Extra tail after planned WorkoutKit steps, medium confidence. |

## Event Count Note

The raw evidence count reports 14 events. The force re-enrich result reports 13 events because that result uses the summarized `CanonicalWorkout.intervalCount`, which is built from HealthKit segment/lap events. The raw segment marker table also renders 13 rows because `DerivedAnalyticsEngine.intervalCandidates` filters raw events to valid in-workout event windows before displaying marker rows. This is expected diagnostic counting, not a production interval behavior change.
