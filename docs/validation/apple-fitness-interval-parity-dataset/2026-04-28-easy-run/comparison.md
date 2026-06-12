# Apple Fitness vs RunSignal Comparison

## Comparison Table

| Row | Label | Apple Distance | RunSignal Distance | Distance Delta | Apple Time | RunSignal Time | Time Delta | Pass? | Notes |
|---:|---|---:|---:|---:|---:|---:|---:|---|---|
| 1 | Work | 7.25 km | unavailable | unavailable | 46:12 | unavailable | unavailable | No | Apple Fitness shows the row, but RunSignal has no reconstructed interval or boundary diagnostics. |
| 2 | Open | 46 m | unavailable | unavailable | 0:20 | unavailable | unavailable | No | Apple Fitness shows the row, but RunSignal has no reconstructed interval or boundary diagnostics. |

## Finding

This is not a usable boundary-parity case yet. Apple Fitness visually confirms Work plus Open, but RunSignal has no WorkoutKit audit and no usable sample evidence in the export.

Treat April 28 as an evidence-coverage issue. Do not tune interval reconstruction from this workout until a usable Raw HealthKit Debug export is available.

## Evidence Coverage Issue

Investigate whether the missing evidence comes from old workout data availability, HealthKit query coverage, filtering, sample association, WorkoutKit plan availability, app-side export behavior, or another limitation.
