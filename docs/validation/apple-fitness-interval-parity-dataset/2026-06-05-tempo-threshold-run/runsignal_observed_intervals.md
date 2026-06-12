# RunSignal Observed Intervals

Type values exactly as shown in RunSignal. Use Raw HealthKit Debug for WorkoutKit Reconstructed Intervals until this feature is promoted.

| Row | Label | Goal | Target | RunSignal Distance | RunSignal Time | RunSignal Pace | RunSignal Avg HR | Source | Notes |
|---:|---|---|---|---:|---:|---:|---:|---|---|
| 1 | Warmup | 2 km | pace range 6:00-6:30/km | 2.01 km | 12:27 | 6:12/km | 133 bpm | WorkoutKit Reconstructed Intervals | Boundary strategy: crossing sample end; adjustment +2.5s; overshoot 5.5 m. |
| 2 | Work 1 | 2 km | pace range 4:10-4:20/km | 2.01 km | 8:32 | 4:15/km | 171 bpm | WorkoutKit Reconstructed Intervals | Boundary strategy: crossing sample end; adjustment +2.1s; overshoot 8.6 m. |
| 3 | Cooldown | 2.50 km | pace range 6:00-6:30/km | 2.51 km | 14:40 | 5:51/km | 155 bpm | WorkoutKit Reconstructed Intervals | Boundary strategy: crossing sample end; adjustment +2.5s; overshoot 7.7 m. |
| 4 | Open / Extra | Open | Target unavailable | 0.44 km | 2:38 | 5:59/km | 154 bpm | WorkoutKit Reconstructed Intervals | Extra tail after planned WorkoutKit steps. |
