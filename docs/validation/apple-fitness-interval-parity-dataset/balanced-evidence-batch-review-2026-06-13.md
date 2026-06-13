# Balanced Evidence Batch Review

Generated: 2026-06-13

Status: docs/debug validation evidence only. This does not change Swift, production interval behavior, normal workout UI, `HKWorkoutActivity` promotion, FIT runtime use, HealthFit dependency status, or Phase 3 implementation.

## Source Locations

User-supplied local source folders:

| Evidence | Source |
| --- | --- |
| Apple Fitness screenshots | `/Users/adrielsolorzano/Documents/Personal OS/00_Inbox_To_Sort/RunSignal testing/Images` |
| Monthly RunSignal exports | `/Users/adrielsolorzano/Documents/Personal OS/00_Inbox_To_Sort/RunSignal testing/monthly runs txt files` |
| Individual RunSignal exports | `/Users/adrielsolorzano/Documents/Personal OS/00_Inbox_To_Sort/RunSignal testing/indivudal runs txt files` |
| HealthFit FIT archive | `https://drive.google.com/drive/u/0/folders/1QUo6CaiRIBtgV0sk37Uc4wOhFmINyQyf` |

Repo-local screenshot archive:

- `docs/validation/apple-fitness-interval-parity-dataset/apple-fitness-screenshot-archive-2026-06-13/`

The screenshot archive contains the Apple Fitness screenshots for the 12 screenshot-confirmed fixtures. FIT files remain external/offline validation evidence and are not a runtime app input.

## Export Inventory

Monthly exports:

| Month | JSON source | Workout records | Records with scorer rows |
| --- | --- | ---: | ---: |
| March 2026 | `text-CB1855DFCDF5-1.txt` | 27 | 26 |
| April 2026 | `text-257C05E71140-1.txt` | 23 | 17 |
| May 2026 | `text-C53172129764-1.txt` | 26 | 25 |
| June 2026 | `text-55AD218E07CD-1.txt` | 11 | 10 |

Individual selected-workout exports supplied direct parity JSON for 11 of the 12 screenshot-confirmed fixtures. The supplied Jun 3 individual JSON was for `2026-06-03T12:25:05Z` and had no scorer rows, so the Jun 3 screenshot-confirmed workout `2026-06-03T11:45:08Z` was checked from the June monthly JSON record instead.

## Fixture Comparison

Comparison rules:

- Row labels must match after allowing numbered debug labels such as `Work 1` for Apple Fitness `Work`.
- Active duration is compared against Apple Fitness row duration.
- Distance is compared against Apple Fitness displayed row distance.
- Current working tolerance is about `1 s` per row and `10-15 m` per row.

| Start | Class | Source | Rows Apple/Candidate | Open tail | Paired pause | Max active dt | Max distance delta | Result |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | --- |
| `2026-03-05T14:37:43Z` | narrow_warmup_work_open_cooldown | `text-FD101510E6D0-1.txt` | 3/3 | 0 | `0.0 s` | `0.79 s` | `7.52 m` | matches |
| `2026-04-22T11:39:58Z` | paused_repeat_block | `text-B019AE803C15-1.txt` | 12/12 | 0 | `178.1 s` | `0.64 s` | `8.14 m` | matches |
| `2026-04-24T12:02:30Z` | narrow_warmup_work_open_cooldown | `text-749E17A91C6B-1.txt` | 3/3 | 0 | `0.0 s` | `0.40 s` | `6.72 m` | matches |
| `2026-04-29T11:49:02Z` | paused_repeat_block | `text-564A1DD3633D-1.txt` | 12/12 | 0 | `173.0 s` | `0.98 s` | `7.58 m` | matches |
| `2026-05-01T12:07:44Z` | fixed_cooldown_open_tail | `text-9361D81BA274-1.txt` | 5/5 | 1 | `232.8 s` | `0.48 s` | `9.06 m` | matches |
| `2026-05-06T12:02:13Z` | paused_repeat_block | `text-13D58DC7F80B-1.txt` | 14/14 | 0 | `126.4 s` | `0.92 s` | `8.11 m` | matches |
| `2026-05-13T11:52:06Z` | paused_repeat_block | `text-80BD3E49D901-1.txt` | 18/18 | 0 | `52.6 s` | `0.76 s` | `11.20 m` | matches |
| `2026-05-20T11:43:00Z` | clean_repeat_block | `text-78EF504B1127-1.txt` | 10/10 | 0 | `0.0 s` | `0.95 s` | `8.73 m` | matches |
| `2026-05-29T11:49:28Z` | paused_warmup_work_open_cooldown | `text-6E942583BB5B-1.txt` | 3/3 | 0 | `159.0 s` | `0.15 s` | `9.09 m` | matches |
| `2026-06-03T11:45:08Z` | clean_repeat_block | `text-55AD218E07CD-1.txt` record | 8/8 | 0 | `0.0 s` | `0.96 s` | `8.62 m` | matches |
| `2026-06-05T11:53:53Z` | fixed_cooldown_open_tail | `text-5CE91A768AB2-1.txt` | 4/4 | 1 | `0.0 s` | `0.45 s` | `6.57 m` | matches |
| `2026-06-10T11:27:51Z` | repeat_block_fixed_cooldown_open_tail | `text-AA49E6BFCCFC-1.txt` | 11/11 | 1 | `0.0 s` | `0.90 s` | `8.92 m` | matches |

## Findings

- The balanced evidence batch matches the current docs/debug candidate reconstruction scorecard across all 12 screenshot-confirmed fixtures.
- Pause subtraction remains supported for paused repeat blocks and paused warmup/work/cooldown shapes.
- Open/Extra tail detection remains supported for May 1, Jun 5, and Jun 10.
- Clean repeat-block controls remain stable for May 20 and Jun 3.
- The evidence now covers the main weekly workout patterns: easy/simple, tempo-like warmup/work/cooldown, repeat-block intervals, paused workouts, no-pause workouts, and fixed-cooldown Open tails.

## Decision

This batch is enough to move to a debug-only in-app comparison view if that work is explicitly requested. It is not enough to broadly promote custom workout reconstruction into the normal workout detail UI.

The next safe implementation slice would show candidate rows only in Raw HealthKit Debug / Parity Lab, side by side with existing production rows and with elapsed duration, active duration, pause overlap, and Open/Extra tail status visible.
