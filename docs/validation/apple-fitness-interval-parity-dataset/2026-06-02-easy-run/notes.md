# Notes

## Screenshot Filenames Added

- Apple Fitness: `IMG_6970.PNG`, `IMG_6971.PNG`
- RunSignal workout detail:
- RunSignal Raw HealthKit Debug: `text-B1E5770683EF-1.txt`

## Validation Notes

- Apple Fitness showed intervals or only splits: custom interval rows, Work and Open.
- WorkoutKit plan available in RunSignal: yes, `Tuesday Easy 5.65km`.
- Reconstructed intervals appeared: yes.
- Raw HealthKit Segment Markers appeared: yes; debug source says they are not used as Apple Fitness interval rows.
- Visible mismatch: Work is 36:15 in Apple Fitness vs 36:13 in RunSignal; Open is 0:28 in Apple Fitness vs 0:30 in RunSignal.
- Pause, GPS weirdness, treadmill/manual edit, or extra tail behavior: Open tail exists in both and is close.
