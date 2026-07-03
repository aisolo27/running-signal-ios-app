# Physical iPhone Paused Repeat-Block Proof

Captured: 2026-06-15

## Source Files

These files were copied from `/Users/adrielsolorzano/Downloads/` so the Downloads copies can be deleted after review.

| Workout date | Workout | Archived files |
| --- | --- | --- |
| 2026-04-22 | 9km Interval | `raw-exports/2026-04-22-raw-healthkit-debug.txt`, `raw-exports/2026-04-22-parity-packet.txt` |
| 2026-04-29 | Wednesday Interval (10k) | `raw-exports/2026-04-29-raw-healthkit-debug.txt`, `raw-exports/2026-04-29-parity-packet.txt` |
| 2026-05-06 | Wednesday Interval (9.7k) | `raw-exports/2026-05-06-raw-healthkit-debug.txt`, `raw-exports/2026-05-06-parity-packet.txt` |
| 2026-05-13 | Wednesday Interval (9.7k) | `raw-exports/2026-05-13-raw-healthkit-debug.txt`, `raw-exports/2026-05-13-parity-packet.txt` |
| 2026-05-27 | Wednesday Interval (8.5km) | `raw-exports/2026-05-27-raw-healthkit-debug.txt`, `raw-exports/2026-05-27-parity-packet.txt` |

## Review Result

All five fixed-build exports confirm the debug-only paused repeat-block prototype path:

- `customWorkoutComparisonSummary.status == supported`
- fallback reasons are empty / `None`
- row confidences are `supported`
- candidate rule scorer reports `candidate-rule-scoreable`
- tail ambiguity is `plannedOpenCooldownContinuesToWorkoutEnd`
- normal workout UI and production interval behavior remain unchanged

## Pause-Overlap Rows

The exports preserve elapsed row windows while subtracting paired pause overlap to compute active/timer duration:

| Workout date | Row | Elapsed | Pause overlap | Active/timer |
| --- | --- | ---: | ---: | ---: |
| 2026-04-22 | Recovery 3 | 219.7 s | 99.8 s | 119.9 s |
| 2026-04-22 | Recovery 4 | 198.1 s | 78.3 s | 119.8 s |
| 2026-04-29 | Recovery 3 | 182.0 s | 62.9 s | 119.1 s |
| 2026-04-29 | Recovery 4 | 229.1 s | 110.1 s | 119.0 s |
| 2026-05-06 | Warmup | 900.9 s | 126.4 s | 774.5 s |
| 2026-05-13 | Recovery 7 | 172.0 s | 52.6 s | 119.4 s |
| 2026-05-27 | Recovery 8 | 150.0 s | 60.8 s | 89.2 s |

## Current Status

The minimum physical proof for the paused repeat-block debug comparison gate is complete. This does not approve normal workout detail UI promotion. The next correctness step should stay debug/export-only and move to the next unresolved class from the correctness lock.
