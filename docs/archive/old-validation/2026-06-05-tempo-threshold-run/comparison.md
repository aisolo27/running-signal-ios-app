# Apple Fitness vs RunSignal Comparison

## Comparison Table

| Row | Label | Apple Distance | RunSignal Distance | Distance Delta | Apple Time | RunSignal Time | Time Delta | Apple Pace | RunSignal Pace | Pace Delta | Apple Avg HR | RunSignal Avg HR | HR Delta | Pass? | Notes |
|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|---|
| 1 | Warmup | 2.00 km | 2.01 km | about +6 m | 12:30 | 12:27 | -0:03 | 6:15/km | 6:12/km | -0:03/km | 133 bpm | 133 bpm | 0 bpm | Temporary | Within temporary warmup tolerance; preferred target is closer. |
| 2 | Work | 2.00 km | 2.01 km | about +9 m | 8:30 | 8:32 | +0:02 | 4:15/km | 4:15/km | 0:00/km | 171 bpm | 171 bpm | 0 bpm | Yes | Within acceptable distance-step tolerance. |
| 3 | Cooldown | 2.49 km | 2.51 km | about +18 m | 14:36 | 14:40 | +0:04 | 5:51/km | 5:51/km | 0:00/km | 155 bpm | 155 bpm | 0 bpm | Temporary | Time is within temporary tolerance; displayed distance delta is slightly above the 10-15 m target. |
| 4 | Open | 453 m | 0.44 km | about -13 m | 2:40 | 2:38 | -0:02 | 5:52/km | 5:59/km | +0:07/km | 154 bpm | 154 bpm | 0 bpm | Yes | Tail is close; distance likely affected by the cooldown boundary difference. |

## Tolerance Checklist

- [x] Planned structure exact
- [ ] Time-based intervals within +/- 1 second preferred
- [ ] Short distance intervals within +/- 1 second preferred, +/- 2 seconds acceptable
- [x] Warmup/cooldown within +/- 1-2 seconds preferred, +/- 3-5 seconds temporary acceptable
- [ ] Recovery distances within +/- 10-15 meters
- [x] No HealthKit Segment Markers used as normal interval rows

## Finding

This workout is a useful tempo validation sample. The structure matches, Work is close, and the Open tail is close. Warmup and Cooldown are still only temporary passes because they are off by 3-4 seconds, and the displayed Cooldown distance differs by roughly 18 m.

## Warmup/Cooldown Diagnostics

| Diagnostic | Current evidence |
|---|---|
| Warmup | Apple 2.00 km / 12:30; RunSignal 2.006 km / 12:26.609; crossing sample end; +2.5 s adjustment; 5.5 m overshoot |
| Work | Apple 2.00 km / 8:30; RunSignal 2.009 km / 8:31.928; crossing sample end; +2.1 s adjustment; 8.6 m overshoot |
| Cooldown | Apple 2.49 km / 14:36; RunSignal 2.508 km / 14:39.837; crossing sample end; +2.5 s adjustment; 7.7 m overshoot |
| Open tail | Apple 453 m / 2:40; RunSignal 440.0 m / 2:37.762 |
| Distance sample count | 892 |

Current read: the structure is correct and the Open tail exists in both Apple Fitness and RunSignal. The remaining issue is most likely boundary/display/sample granularity rather than final cooldown/tail merge policy. Do not tune only to June 5 if it harms the other four workouts.
