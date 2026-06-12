# Apple Fitness vs RunSignal Comparison

## Comparison Table

| Row | Label | Apple Distance | RunSignal Distance | Distance Delta | Apple Time | RunSignal Time | Time Delta | Apple Pace | RunSignal Pace | Apple Avg HR | RunSignal Avg HR | HR Delta | Pass? | Notes |
|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|---|
| 1 | Work | 5.00 km | 5.00 km | about +1.6 m raw overshoot | 32:03 | 31:59 | -0:04 | 6:24/km | 6:24/km | 127 bpm | 127 bpm | 0 bpm | No | RunSignal boundary ends about 4 seconds earlier than Apple Fitness. |
| 2 | Open | 36 m | 0.04 km | about +7 m raw | 0:17 | 0:22 | +0:05 | 7:51/km | 8:34/km | 138 bpm | 138 bpm | 0 bpm | No | Open / Extra absorbs the missing Work time. |

## Finding

This is a boundary-research sample, not a pass. It repeats the same drift direction as May 26 and June 1: Apple Fitness keeps the fixed-distance Work row running slightly longer than RunSignal's public HealthKit cumulative-distance crossing boundary, and RunSignal's Open / Extra row becomes longer by roughly the same amount.

The Apple Fitness Open row is real post-goal running and should not be hidden or merged into Work. The parity issue is boundary timing.

## Boundary Diagnostics

| Diagnostic | Value |
|---|---|
| Planned Work goal | 5.00 km |
| Apple Fitness Work time | 32:03 |
| RunSignal Work time | 31:58.547 |
| Apple Fitness Open time | 0:17 |
| RunSignal Open / Extra time | 22.210 s |
| Boundary strategy used | crossing sample end |
| Boundary adjustment seconds | +0.6 s |
| Overshoot meters | 1.6 m |
| Previous distance sample before boundary | 31:53-31:56, 4987.6 m to 4994.9 m cumulative |
| Crossing distance sample | 31:56-31:59, 4994.9 m to 5001.6 m cumulative |
| Next distance sample after boundary | 31:59-32:01, 5001.6 m to 5008.8 m cumulative |
| Remaining tail seconds/meters | 22.210 s / 43.233 m |
| Final distance sample timing | 32:13.983, 5044.8 m cumulative |

Do not derive a deterministic rule from this sample alone. Add it to the boundary drift research set and test candidate strategies against May 26, June 1, June 12, and existing pass/temporary-pass fixtures.
