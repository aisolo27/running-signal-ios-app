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

## Physical-Device Parity Packet

- Packet: `exports/runsignal-diagnostics/runsignal-parity-packet-2026-06-02.json`
- Raw debug markdown export: not included in this batch.
- Packet source: freshQuery.
- Force re-enrich returned workout: true.
- Diagnostics warnings: none.
- Event count split: top-level evidence events 11, force-result segment/lap events 10. This matches the known diagnostics counting split documented for April 28.
- Classification: temporary pass, single fixed-distance Work plus Open / Extra tail guard. Exact packet Work time is 2.4 seconds from Apple Fitness, outside the preferred 2-second tolerance and inside the temporary tolerance.
- Current packet rows: Work 1 5651.865399219561 m / 2172.5804797410965 s; Open / Extra 57.0151992009487 m / 30.089375257492065 s.
