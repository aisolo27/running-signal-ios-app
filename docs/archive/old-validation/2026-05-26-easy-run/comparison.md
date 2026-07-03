# Apple Fitness vs RunSignal Comparison

## Comparison Table

| Row | Label | Apple Distance | RunSignal Distance | Distance Delta | Apple Time | RunSignal Time | Time Delta | Apple Pace | RunSignal Pace | Apple Avg HR | RunSignal Avg HR | HR Delta | Pass? | Notes |
|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|---|
| 1 | Work | 6.45 km | 6.45 km | about +4 m raw overshoot | 42:11 | 42:07 | -0:04 | 6:32/km | 6:32/km | 132 bpm | 131 bpm | -1 bpm | No | RunSignal boundary ends about 4 seconds earlier than Apple Fitness. |
| 2 | Open | 94 m | 0.10 km | about +3 m raw | 0:41 | 0:45 | +0:04 | 7:20/km | 7:45/km | 137 bpm | 137 bpm | 0 bpm | No | Open / Extra absorbs the missing Work time. |

## Finding

This is a boundary-research sample, not a pass. It repeats the same drift direction as June 1: Apple Fitness keeps the fixed-distance Work row running slightly longer than RunSignal's public HealthKit cumulative-distance crossing boundary, and RunSignal's Open / Extra row becomes longer by roughly the same amount.

The Apple Fitness Open row is real post-goal running and should not be hidden or merged into Work. The parity issue is boundary timing.

## Boundary Diagnostics

| Diagnostic | Value |
|---|---|
| Planned Work goal | 6.45 km |
| Apple Fitness Work time | 42:11 |
| RunSignal Work time | 42:07.467 |
| Apple Fitness Open time | 0:41 |
| RunSignal Open / Extra time | 45.215 s |
| Boundary strategy used | crossing sample end |
| Boundary adjustment seconds | +1.5 s |
| Overshoot meters | 4.2 m |
| Previous distance sample before boundary | 42:02-42:05, 6441.0 m to 6446.8 m cumulative |
| Crossing distance sample | 42:05-42:07, 6446.8 m to 6454.2 m cumulative |
| Next distance sample after boundary | 42:07-42:10, 6454.2 m to 6460.8 m cumulative |
| Remaining tail seconds/meters | 45.215 s / 97.228 m |
| Final distance sample timing | 42:46.057, 6551.5 m cumulative |

Do not derive a deterministic rule from this sample alone. Add it to the boundary drift research set and test any future rule against June 1-5.
