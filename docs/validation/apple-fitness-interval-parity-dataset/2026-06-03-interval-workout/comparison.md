# Apple Fitness vs RunSignal Comparison

## Comparison Table

| Row | Label | Apple Distance | RunSignal Distance | Distance Delta | Apple Time | RunSignal Time | Time Delta | Apple Pace | RunSignal Pace | Pace Delta | Apple Avg HR | RunSignal Avg HR | HR Delta | Pass? | Notes |
|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|---|
| 1 | Warmup | 2.00 km | 2.00 km | about +1 m | 12:47 | 12:42 | -0:05 | 6:24/km | 6:21/km | -0:03/km | 127 bpm | 126 bpm | -1 bpm | Temporary | Boundary is still about 5 seconds early. |
| 2 | Work 1 | 1.00 km | 1.00 km | about +2 m | 4:12 | 4:12 | 0:00 | 4:12/km | 4:12/km | 0:00/km | 168 bpm | 166 bpm | -2 bpm | Yes | Strong match. |
| 3 | Recovery 1 | 209 m | 0.22 km | about +9 m | 2:30 | 2:30 | 0:00 | 11:56/km | 11:28/km | -0:28/km | 143 bpm | 147 bpm | +4 bpm | Yes | Distance within short recovery tolerance; pace differs because distance is rounded. |
| 4 | Work 2 | 1.00 km | 1.00 km | about +2 m | 4:06 | 4:06 | 0:00 | 4:06/km | 4:06/km | 0:00/km | 170 bpm | 167 bpm | -3 bpm | Yes | Strong match. |
| 5 | Recovery 2 | 207 m | 0.21 km | about +3 m | 2:30 | 2:30 | 0:00 | 12:04/km | 11:54/km | -0:10/km | 149 bpm | 154 bpm | +5 bpm | Yes | Distance within short recovery tolerance. |
| 6 | Work 3 | 1.00 km | 1.00 km | about +4 m | 4:00 | 4:01 | +0:01 | 4:00/km | 4:00/km | 0:00/km | 173 bpm | 172 bpm | -1 bpm | Yes | Within short distance interval tolerance. |
| 7 | Recovery 3 | 197 m | 0.20 km | about +2 m | 2:30 | 2:30 | 0:00 | 12:41/km | 12:33/km | -0:08/km | 156 bpm | 161 bpm | +5 bpm | Yes | Distance within short recovery tolerance. |
| 8 | Cooldown | 1.03 km | 1.03 km | about 0 m | 6:22 | 6:25 | +0:03 | 6:11/km | 6:13/km | +0:02/km | 157 bpm | 156 bpm | -1 bpm | Temporary | Planned open cooldown now keeps the Cooldown label and extends to workout end. Time is within temporary cooldown tolerance. |

## Tolerance Checklist

- [x] Planned structure exact
- [x] Time-based intervals within +/- 1 second preferred
- [x] Short distance intervals within +/- 1 second preferred, +/- 2 seconds acceptable
- [ ] Warmup/cooldown within +/- 1-2 seconds preferred, +/- 3-5 seconds temporary acceptable
- [x] Recovery distances within +/- 10-15 meters
- [x] No HealthKit Segment Markers used as normal interval rows

## Finding

This is the strongest interval validation sample. After the planned-open-cooldown refinement, RunSignal should label the final 1.03 km / 6:25 row as `Cooldown`, matching Apple Fitness's visible final row label.

The prior analysis was not a screenshot misread: Apple Fitness does show `Cooldown`, and no separate `Open` row is visible after it. The important correction is interpretive. This workout has `Cooldown: goal open` in the WorkoutKit plan, so this is a planned open cooldown case, not a post-completed-cooldown tail merge case.

Current status: temporary pass. The label/structure blocker is resolved, and the fresh Raw HealthKit Debug export confirms the final RunSignal row is now `Cooldown`. Warmup remains about 5 seconds early and the final Cooldown row remains 3 seconds longer than Apple Fitness.

Do not use this row to justify a broad rule that relabels final `Open / Extra` tails as `Cooldown`.
