# RunSignal Observed Intervals

Type values exactly as shown in RunSignal. Use Raw HealthKit Debug for WorkoutKit Reconstructed Intervals until this feature is promoted.

| Row | Label | Goal | Target | RunSignal Distance | RunSignal Time | RunSignal Pace | RunSignal Avg HR | Source | Notes |
|---:|---|---|---|---:|---:|---:|---:|---|---|
| 1 | Warmup | 2 km | pace range 6:00-6:30/km | 2.00 km | 12:42 | 6:21/km | 126 bpm | WorkoutKit Reconstructed Intervals | Boundary strategy: crossing sample end; adjustment +0.6s; overshoot 1.5 m. |
| 2 | Work 1 | 1 km | pace 4:00/km | 1.00 km | 4:12 | 4:12/km | 166 bpm | WorkoutKit Reconstructed Intervals | Boundary strategy: crossing sample end; adjustment +0.5s; overshoot 1.9 m. |
| 3 | Recovery 1 | 150 s | Target unavailable | 0.22 km | 2:30 | 11:28/km | 147 bpm | WorkoutKit Reconstructed Intervals | Time-goal row. |
| 4 | Work 2 | 1 km | pace 4:00/km | 1.00 km | 4:06 | 4:06/km | 167 bpm | WorkoutKit Reconstructed Intervals | Boundary strategy: crossing sample end; adjustment +0.4s; overshoot 1.7 m. |
| 5 | Recovery 2 | 150 s | Target unavailable | 0.21 km | 2:30 | 11:54/km | 154 bpm | WorkoutKit Reconstructed Intervals | Time-goal row. |
| 6 | Work 3 | 1 km | pace 4:00/km | 1.00 km | 4:01 | 4:00/km | 172 bpm | WorkoutKit Reconstructed Intervals | Boundary strategy: crossing sample end; adjustment +0.9s; overshoot 4.0 m. |
| 7 | Recovery 3 | 150 s | Target unavailable | 0.20 km | 2:30 | 12:33/km | 161 bpm | WorkoutKit Reconstructed Intervals | Time-goal row. |
| 8 | Cooldown | Open | pace range 6:00-6:30/km | 1.03 km | 6:25 | 6:13/km | 156 bpm | WorkoutKit Reconstructed Intervals | Planned open cooldown extended to workout end. Confirmed by fresh export `exports/runsignal-diagnostics/text-340B7765A007-1.txt`. |
