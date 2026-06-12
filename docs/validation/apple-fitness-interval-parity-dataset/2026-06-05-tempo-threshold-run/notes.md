# Notes

## Screenshot Filenames Added

- Apple Fitness: `IMG_6976.PNG`, `IMG_6977.PNG`
- RunSignal workout detail:
- RunSignal Raw HealthKit Debug: `text-CF0A7AF3AD53-1.txt`

## Validation Notes

- Apple Fitness showed intervals or only splits: custom interval rows, Warmup, Work, Cooldown, and Open.
- WorkoutKit plan available in RunSignal: yes, `Friday Tempo 6.5km`.
- Reconstructed intervals appeared: yes.
- Raw HealthKit Segment Markers appeared: yes; debug source says they are not used as Apple Fitness interval rows.
- Visible mismatch: Warmup is 12:30 in Apple Fitness vs 12:27 in RunSignal; Cooldown is 14:36 / 2.49 km in Apple Fitness vs 14:40 / 2.51 km in RunSignal; Open is 2:40 / 453 m in Apple Fitness vs 2:38 / 0.44 km in RunSignal.
- Pause, GPS weirdness, treadmill/manual edit, or extra tail behavior: Open tail exists in both; RunSignal cooldown boundary appears slightly later than Apple Fitness.

## Temporary-Pass Investigation

- Warmup is within temporary tolerance but not preferred tolerance.
- Cooldown is within temporary time tolerance, but the displayed distance delta is about 18 m.
- Because Apple Fitness and RunSignal both show an Open tail, this is not evidence for merging the tail into Cooldown.
- Possible causes remain Apple-style rounding, boundary strategy, display formatting, HealthKit sample granularity, or Apple Fitness using data not available to third-party apps.
