# Apple Fitness vs RunSignal Comparison

## Comparison Table

| Row | Label | Apple Distance | RunSignal Distance | Distance Delta | Apple Time | RunSignal Time | Time Delta | Apple Pace | RunSignal Pace | Pace Delta | Apple Avg HR | RunSignal Avg HR | HR Delta | Pass? | Notes |
|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|---|
| 1 | Work | 6.45 km | 6.45 km | about 0 m displayed | 42:44 | 42:38 | -0:06 | 6:37/km | 6:37/km | 0:00/km | 129 bpm | 129 bpm | 0 bpm | No | Planned row matches, but RunSignal boundary ends about 6 seconds earlier than Apple Fitness. |
| 2 | Open | 5 m | 0.01 km | about +7 m | 0:07 | 0:13 | +0:06 | 24:04/km | 17:05/km | not comparable | 139 bpm | 138 bpm | -1 bpm | No | Tail absorbs the missing Work time; distance is small enough that pace is noisy. |

## Tolerance Checklist

- [x] Planned structure exact
- [ ] Time-based intervals within +/- 1 second preferred
- [ ] Short distance intervals within +/- 1 second preferred, +/- 2 seconds acceptable
- [ ] Warmup/cooldown within +/- 1-2 seconds preferred, +/- 3-5 seconds temporary acceptable
- [ ] Recovery distances within +/- 10-15 meters
- [x] No HealthKit Segment Markers used as normal interval rows

## Finding

This workout is usable for parity validation, but it is not a pass. Apple Fitness and RunSignal agree on the planned Work/Open structure and total workout duration, but RunSignal places the Work/Open boundary about 6 seconds earlier than Apple Fitness.

## Boundary Diagnostics

| Diagnostic | Value |
|---|---|
| Planned Work goal | 6.45 km |
| Apple Fitness Work time | 42:44 |
| RunSignal Work time | 42:38.318 |
| Apple Fitness Open time | 0:07 |
| RunSignal Open / Extra time | 12.654 s |
| Boundary strategy used | crossing sample end |
| Boundary adjustment seconds | +0.248 s from interpolated crossing |
| Overshoot meters | 0.635 m |
| Distance sample count | 997 |
| Previous distance sample before boundary | 42:33-42:36, 6438.0 m to 6444.0 m cumulative |
| Crossing distance sample | 42:36-42:38, 6444.0 m to 6450.6 m cumulative |
| Next distance sample after boundary | 42:38-42:41, 6450.6 m to 6457.7 m cumulative |
| Final distance sample timing | 42:43.464, 6463.0 m cumulative |
| Last HR/power/cadence sample timing | HR 42:46.725; power 42:48.609; cadence 42:48.609 |
| Remaining tail seconds/meters | 12.654 s / 12.346 m |

Current read: this is a boundary-placement blocker, not a tail-label blocker. RunSignal's 6.45 km crossing is internally consistent: interpolation fraction 0.904, crossing sample end 42:38.318, overshoot only 0.635 m. Apple Fitness's 42:44 Work and 0:07 Open align more closely with the final distance sample at 42:43.464 and workout end at 42:50.972. That suggests a later Apple Fitness-private or sensor-end boundary, not a simple crossing-sample bug.

Do not add a deterministic app rule from this workout alone. A final-distance-sample, private-session, sensor-end, or tail-shrink rule would need more fixed-distance Work + tiny Open tail evidence and would need to preserve June 2 and June 4, where simple Work + Open tail parity already passes.
