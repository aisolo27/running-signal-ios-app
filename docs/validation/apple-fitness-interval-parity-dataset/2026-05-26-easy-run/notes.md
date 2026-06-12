# Notes

## Files Added

- Apple Fitness: `IMG_6980.PNG`, `IMG_6981.PNG`
- RunSignal diagnostics export: `exports/runsignal-diagnostics/text-6D5CCBA82A13-1.txt`

## Validation Notes

- Apple Fitness workout name: `Tuesday Easy 6.45km`.
- Workout time: 42:52.
- Distance: 6.55 km.
- WorkoutKit plan available in RunSignal: yes.
- Plan type: custom workout.
- Planned structure: one Work step with goal 6.45 km, no warmup, no cooldown.
- Reconstructed intervals appeared: yes.
- Raw HealthKit Segment Markers appeared: yes; they remain raw/debug-only and must not be used as Apple Fitness interval rows.
- Visible mismatch: Work is 42:11 in Apple Fitness vs 42:07 in RunSignal; Open is 0:41 in Apple Fitness vs 0:45 in RunSignal.

## Boundary Research Interpretation

May 26 repeats the June 1 drift direction. RunSignal's public HealthKit cumulative-distance crossing boundary ends Work a few seconds earlier than Apple Fitness's visible Work row, and Open / Extra becomes longer by roughly the same amount.

This supports treating June 1 as not completely isolated. It still is not enough evidence to change app logic. More fixed-distance Work plus real Open tail examples are needed before defining a deterministic boundary rule.

Do not hide or merge Open. The Open row is real post-goal running.

## Physical-Device Parity Packet

- Packet: `exports/runsignal-diagnostics/runsignal-parity-packet-2026-05-26.json`
- Raw debug markdown export: not included in this batch.
- Packet source: freshQuery.
- Force re-enrich returned workout: true.
- Diagnostics warnings: none.
- Event count split: top-level evidence events 13, force-result segment/lap events 12. This matches the known diagnostics counting split documented for April 28.
- Classification: drift case, fixed-distance Work plus real Open / Extra tail.
- Current packet rows: Work 1 6454.226661636261 m / 2527.4671412706375 s; Open / Extra 97.22817968856543 m / 45.21510171890259 s.
