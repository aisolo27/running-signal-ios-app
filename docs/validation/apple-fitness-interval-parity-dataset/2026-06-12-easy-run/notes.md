# Notes

## Files Added

- Apple Fitness: `IMG_6999.PNG`
- RunSignal diagnostics export: `exports/runsignal-diagnostics/text-973BFDCDC777-1.txt`

## Validation Notes

- Apple Fitness workout name: `Friday Easy 5km`.
- Workout time: 32:20 visible in Apple Fitness; RunSignal duration export shows 32:21.
- Distance: 5.04 km.
- WorkoutKit plan available in RunSignal: yes.
- Plan type: custom workout.
- Planned structure: one Work step with goal 5 km, no warmup, no cooldown.
- Reconstructed intervals appeared: yes.
- Raw HealthKit Segment Markers appeared: yes; they remain raw/debug-only and must not be used as Apple Fitness interval rows.
- Visible mismatch: Work is 32:03 in Apple Fitness vs 31:59 in RunSignal; Open is 0:17 in Apple Fitness vs 0:22 in RunSignal.

## Boundary Research Interpretation

June 12 repeats the May 26 and June 1 drift direction at a 5.00 km goal distance. RunSignal's public HealthKit cumulative-distance crossing boundary ends Work a few seconds earlier than Apple Fitness's visible Work row, and Open / Extra becomes longer by roughly the same amount.

This means the pattern is no longer isolated to one 6.45 km workout or one goal distance. It still does not approve a production boundary rule. Candidate strategies should be scored with June 12 included, and existing pass/temporary-pass fixtures must remain protected.

Do not hide or merge Open. The Open row is real post-goal running.

## Physical-Device Parity Packet

- Packet: `exports/runsignal-diagnostics/runsignal-parity-packet-2026-06-12.json`
- Raw debug markdown export: not included in this batch.
- Packet source: freshQuery.
- Force re-enrich returned workout: true.
- Diagnostics warnings: none.
- Event count split: top-level evidence events 11, force-result segment/lap events 10. This matches the known diagnostics counting split documented for April 28.
- Classification: drift case, fixed-distance Work plus real Open / Extra tail.
- Current packet rows: Work 1 5001.583504582988 m / 1918.5470229387283 s; Open / Extra 43.23277691495605 m / 22.209920048713684 s.
