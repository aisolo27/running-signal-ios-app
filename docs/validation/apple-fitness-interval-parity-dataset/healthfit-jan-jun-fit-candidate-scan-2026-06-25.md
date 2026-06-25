# HealthFit Jan-Jun FIT Candidate Scan - 2026-06-25

Purpose: mine local HealthFit FIT files for historical candidates matching the active blocked row:

`Warmup(2 km) > repeated Work/Recovery rows > fixed final Cooldown > inferred Open / Extra`, with paired pause evidence.

This scan is offline validation only. FIT files do not become app runtime truth.

## Source

- Source folder: `/Users/adrielsolorzano/Library/Mobile Documents/iCloud~com~altifondo~HealthFit/Documents`
- Date range: January 1, 2026 through June 30, 2026
- Filter: outdoor running `.fit` files
- Parser path: local FIT scan using the web app's installed `@garmin/fitsdk` dependency

## Summary

- Outdoor running FIT files scanned: 124
- Parsed successfully: 124
- Parse errors: 0
- Exact target matches: 0
- Near matches: 2

No scanned FIT had all required target properties at once:

- 2 km warmup
- repeated Work/Recovery block
- fixed final cooldown
- positive post-final-row tail
- paired pause evidence

## Near Matches

| Date | Workout | Why it is close | Why it does not close the blocker |
| --- | --- | --- | --- |
| 2026-06-10 | `Wednesday Interval (6kmm)` | Repeat fixed-cooldown tail; 10 laps, 5 workout steps, 5.641 s tail | No paired pause evidence: `pauseGap=0`, `pairedPauseCount=0` |
| 2026-06-25 | `Thursday Interval 5km` | Repeat fixed-cooldown tail; 12 laps, 5 workout steps, 8.255 s tail | No paired pause evidence: `pauseGap=0`, `pairedPauseCount=0` |

## Paused Controls Found

These files show paired pause evidence, but they do not include the required fixed-cooldown tail shape:

| Date | Workout | FIT shape notes |
| --- | --- | --- |
| 2026-04-22 | `9km Interval` | Paused repeat, open cooldown, no tail |
| 2026-04-29 | `Wednesday Interval (10k)` | Paused repeat, open cooldown, no tail |
| 2026-05-06 | `Wednesday Interval (9.7k)` | Paused repeat, open cooldown, no tail |
| 2026-05-13 | `Wednesday Interval (9.7k)` | Paused repeat, open cooldown, no tail |
| 2026-05-27 | `Wednesday Interval (8.5km)` | Paused repeat, open cooldown, no tail |
| 2026-05-01 | `Friday Tempo 9km` | Paused fixed-tail evidence, but not the repeated Work/Recovery target shape |

## Decision

Do not request broad Jan-Jun Raw HealthKit Debug and parity packet exports. The FIT scan did not find an exact historical candidate.

The useful evidence path is now narrow:

1. Keep June 10 and June 25 as no-pause fixed-cooldown repeat-tail controls.
2. Keep April 22, April 29, May 6, May 13, and May 27 as paused open-cooldown controls.
3. Collect a future deliberate workout with the same repeat fixed-cooldown tail shape plus a real pause/resume pair before or during the repeated rows.
