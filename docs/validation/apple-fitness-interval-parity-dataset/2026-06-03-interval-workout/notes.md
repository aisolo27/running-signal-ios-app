# Notes

## Screenshot Filenames Added

- Apple Fitness: `IMG_6972.PNG`, `IMG_6973.PNG`
- RunSignal workout detail:
- RunSignal Raw HealthKit Debug: `text-D34BE423AE87-1.txt`
- New RunSignal diagnostics export: `exports/runsignal-diagnostics/text-340B7765A007-1.txt`

## Validation Notes

- Apple Fitness showed intervals or only splits: custom interval rows, Warmup, three Work rows, three Recovery rows, and Cooldown.
- WorkoutKit plan available in RunSignal: yes, `Wednesday Interval (7.5km)`.
- Reconstructed intervals appeared: yes.
- Raw HealthKit Segment Markers appeared: yes; debug source says they are not used as Apple Fitness interval rows.
- Visible mismatch: Warmup is 12:47 in Apple Fitness vs 12:42 in RunSignal. After the planned-open-cooldown refinement, RunSignal should label the final 1.03 km / 6:25 row as Cooldown.
- Pause, GPS weirdness, treadmill/manual edit, or extra tail behavior: WorkoutKit cooldown goal is open; RunSignal now treats that planned open cooldown as extending to workout end.

## June 3 Label Re-check

1. Apple Fitness shows a `Cooldown` row.
2. Apple Fitness does not show a separate `Open` row after `Cooldown` in the provided screenshots.
3. Apple Fitness shows the final extra activity as `Cooldown`.
4. The previous `analysis-summary.md` correctly identified the final visible Apple Fitness row label, but it overstated the interpretation by implying an open cooldown tail should generally become `Cooldown`.
5. The prior statement was not a screenshot interpretation mistake. It should be narrowed to this workout's open planned cooldown behavior.

The label/structure blocker is resolved by the targeted app rule and confirmed by the fresh export. This workout is now a temporary pass pending only the remaining warmup/final-row timing tolerance review. Do not automatically merge post-completed-cooldown activity into Cooldown in other workouts.

## Physical-Device Parity Packet

- Packet: `exports/runsignal-diagnostics/runsignal-parity-packet-2026-06-03.json`
- Raw debug markdown export: not included in this batch.
- Packet source: freshQuery.
- Force re-enrich returned workout: true.
- Diagnostics warnings: none.
- Event count split: top-level evidence events 13, force-result segment/lap events 12. This matches the known diagnostics counting split documented for April 28.
- Classification: temporary/pass regression fixture for planned open cooldown handling; repeated interval structure.
- Current packet structure: Warmup, three 1 km Work rows, three 150 s Recovery rows, and planned open Cooldown extended to workout end.
