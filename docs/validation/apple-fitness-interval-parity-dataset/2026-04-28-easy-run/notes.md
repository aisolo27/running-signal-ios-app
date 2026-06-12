# Notes

## Files Added

- Apple Fitness: `IMG_6982.PNG`, `IMG_6983.PNG`
- RunSignal diagnostics export: `exports/runsignal-diagnostics/text-5DF517D06F26-1.txt`
- Physical-device raw debug export: `exports/runsignal-diagnostics/runsignal-raw-healthkit-debug-2026-04-28.md`
- Physical-device parity packet: `exports/runsignal-diagnostics/runsignal-parity-packet-2026-04-28.json`

## Validation Notes

- Apple Fitness workout name: `Tuesday Easy 7.25km`.
- Workout time: 46:31.
- Distance: 7.30 km.
- Apple Fitness visible intervals: Work and Open.
- Physical-device force re-enrich completed at `2026-06-12T16:06:26Z`.
- Force re-enrich authorization state: authorized.
- Force re-enrich invalidated cache: true.
- Force re-enrich cache present before refresh: false.
- Force re-enrich returned workout from fresh query: true.
- WorkoutKit Plan Audit: available.
- WorkoutKit display name: `Tuesday Easy 7.25km`.
- WorkoutKit plan ID: `64073E58-E063-455E-B866-76A369213980`.
- WorkoutKit structure: no warmup, one 7.25 km Work step, target pace range 6:00-6:30/km, no cooldown.
- WorkoutKit Reconstructed Intervals: Work 1 plus Open / Extra.
- Boundary Diagnostics: available.
- Evidence counts: heart rate 554, speed 1083, distance 1082, active energy 1085, power 1083, cadence 1083, step count 1083, stride length 513, vertical oscillation 512, ground contact 512, route points 2792, top-level events 14.
- Event count note: the force re-enrich summary reports 13 events because it uses the summarized segment/lap `CanonicalWorkout.intervalCount`; the raw debug export top-level count reports all attached evidence events. The segment marker table also renders 13 rows after filtering to valid in-workout event windows. This is expected diagnostics behavior.

## Evidence Coverage Research

Apple Fitness shows interval rows for this older custom workout, and the physical-device fresh query path now retrieves the planned structure, measured sample evidence, route data, reconstructed intervals, and boundary diagnostics needed for parity comparison.

The previous April 28 failure was likely cache/enrichment/query-path related, but stale cache is not proven because `cacheWasPresent` was false during force re-enrich.

Do not use April 28 for production boundary-rule tuning. Keep it as an evidence-recovery fixture, fresh-query/cache-invalidation validation fixture, and single fixed-distance Work plus Open / Extra tail fixture.
