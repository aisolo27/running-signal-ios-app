# Notes

## Screenshot Filenames Added

- Apple Fitness: `IMG_6974.PNG`, `IMG_6975.PNG`
- RunSignal workout detail:
- RunSignal Raw HealthKit Debug: `text-43A9773F2CFB-1.txt`

## Validation Notes

- Apple Fitness showed intervals or only splits: custom interval rows, Work and Open.
- WorkoutKit plan available in RunSignal: yes, `Thursday Recovery 5.65k`.
- Reconstructed intervals appeared: yes.
- Raw HealthKit Segment Markers appeared: yes; debug source says they are not used as Apple Fitness interval rows.
- Visible mismatch: Work is 36:36 in Apple Fitness vs 36:34 in RunSignal; Open is 0:21 in Apple Fitness vs 0:22 in RunSignal.
- Pause, GPS weirdness, treadmill/manual edit, or extra tail behavior: Open tail exists in both and is close.
