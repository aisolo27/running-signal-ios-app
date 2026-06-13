# Gate B Open/Extra Tail Evidence: March-June 2026

Generated: 2026-06-13T13:33:41.060686Z

## Executive Summary

Open/Extra tail cases remain blocked until the tail rule is explicit. The current evidence uses FIT session-minus-lap residuals, not explicit FIT tail laps, so it can support offline validation but cannot become runtime truth.

FIT remains offline validation only. No production interval behavior, normal workout UI, or runtime data source changed.

## Summary

| Metric | Value |
| --- | ---: |
| Tail rows | 4 |
| Explicit FIT tail lap rows | 0 |
| Session-minus-lap only rows | 4 |

## Classification Counts

| Classification | Count |
| --- | ---: |
| session_minus_lap_tail_candidate | 3 |
| ambiguous_fixed_step_exhaustion | 1 |

## Rule Needed

- Classify tail only after fixed planned steps are exhausted.
- Keep final open cooldown labeled Cooldown through workout end.
- Use session-minus-lap tail evidence only for offline validation when FIT lacks an explicit tail lap.
- Fallback when fixed-step exhaustion or FIT session totals are internally ambiguous.

## Rows

| Start | Final planned step | Fixed steps exhausted | Explicit FIT tail lap | Tail evidence | Tail | Decision |
| --- | --- | ---: | ---: | --- | ---: | --- |
| 2026-04-12T16:01:33Z | work/distance/2.50 km | True | False | FIT session minus lap sum | 63.2s / 179.6m | session_minus_lap_tail_candidate |
| 2026-05-01T12:07:44Z | cooldown/distance/2 km | False | False | FIT session minus lap sum | 0.0s / 31.4m | ambiguous_fixed_step_exhaustion |
| 2026-06-05T11:53:53Z | cooldown/distance/2.50 km | True | False | FIT session minus lap sum | 159.2s / 465.2m | session_minus_lap_tail_candidate |
| 2026-06-10T11:27:51Z | cooldown/distance/2.50 km | True | False | FIT session minus lap sum | 5.6s / 43.0m | session_minus_lap_tail_candidate |

## No-Production-Change Statement

This scorecard is docs/debug validation only. It does not approve Open/Extra tail production reconstruction or `HKWorkoutActivity` promotion.
