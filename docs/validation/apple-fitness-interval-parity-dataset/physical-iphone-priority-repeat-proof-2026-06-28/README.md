# Physical iPhone Priority Repeat Proof - 2026-06-28

Date archived: 2026-06-28

This folder archives the completed priority custom-workout evidence from the June 28-29 physical iPhone/Apple Watch run set. It is validation evidence only. It does not approve new interval analytics, broaden runtime data sources, or change production boundary logic by itself.

## Scope

| Priority | Apple Fitness title | Workout ID | Status | Shape |
| --- | --- | --- | --- | --- |
| 1 | Priority 1 (pause work2, recovery3, cooldown) | `C75E6F78-0762-450A-94F6-72878DA8EC55` | Archived | Warmup, 4x Work/Recovery, fixed cooldown, Open/Extra tail, paused workout |
| 2 | Priority 2 (no pause) | `376F0E84-E296-4F64-9B07-4D9AA085B817` | Archived | Warmup, 4x Work/Recovery, fixed cooldown, Open/Extra tail, no pause |
| 3 | Priority 3 (no pause, open cooldown) | `8B07CF82-0778-4A83-B862-486275CCA923` | Archived | Warmup, 4x Work/Recovery, open cooldown, no pause |
| 4 | Priority 4 (no pause) | `B2227876-F1EA-4A3D-937B-F5D988986539` | Archived | Warmup, Work, Recovery, Work, fixed Cooldown, Open/Extra tail, no pause |
| 5 | Priority 5 (pause everything) | `9C084DCE-3CCF-4401-8B99-CFB58EF0AC82` | Archived | Warmup, paused/skipped Work, fixed Cooldown, Open/Extra tail |

## Evidence Files

Screenshots:

- `screenshots/priority-1-overview-v1.png`
- `screenshots/priority-1-intervals-v2.png`
- `screenshots/priority-2-overview-v1.png`
- `screenshots/priority-2-intervals-v2.png`
- `screenshots/priority-3-overview-v1.png`
- `screenshots/priority-3-intervals-v2.png`
- `screenshots/priority-4-overview-v1.png`
- `screenshots/priority-4-intervals-v2.png`
- `screenshots/priority-5-overview-v1.png`
- `screenshots/priority-5-intervals-v2.png`

RunSignal exports:

- `exports/priority-1-raw-healthkit-debug-2026-06-28.md`
- `exports/priority-1-candidate-json-snippet-2026-06-28.txt`
- `exports/priority-2-raw-healthkit-debug-2026-06-28.md`
- `exports/priority-2-candidate-json-snippet-2026-06-28.txt`
- `exports/priority-3-raw-healthkit-debug-2026-06-28.md`
- `exports/priority-3-candidate-json-snippet-2026-06-28.txt`
- `exports/priority-4-raw-healthkit-debug-2026-06-29.md`
- `exports/priority-4-candidate-json-snippet-2026-06-29.txt`
- `exports/priority-5-raw-healthkit-debug-2026-06-29.md`
- `exports/priority-5-candidate-json-snippet-2026-06-29.txt`

Typed Apple Fitness rows:

- `apple-fitness-manual-rows-priority-1-2026-06-28.json`
- `apple-fitness-manual-rows-priority-2-2026-06-28.json`
- `apple-fitness-manual-rows-priority-3-2026-06-28.json`
- `apple-fitness-manual-rows-priority-4-2026-06-29.json`
- `apple-fitness-manual-rows-priority-5-2026-06-29.json`

Unmatched or pending material:

- `pending-unmatched/june-26-raw-healthkit-debug-unmatched.md`
- `pending-unmatched/text-533051439EB8-1-unmatched.txt`

## Read

- Priority 1 is the pause/timer case. Apple Fitness shows workout time `0:38:39`, elapsed time `0:43:32`, distance `6.03 km`, and an Open row after the fixed cooldown.
- Priority 2 is the clean no-pause fixed-cooldown-plus-tail case. Apple Fitness shows workout time `0:40:30`, distance `5.94 km`, and an Open row after the fixed cooldown.
- Priority 3 is the clean no-pause open-cooldown case. Apple Fitness shows workout time `0:35:19`, distance `4.95 km`, and no separate Open row after cooldown.
- Priority 4 is a clean no-pause Work/Recovery/Work fixed-cooldown-plus-tail case. Apple Fitness shows workout time `0:31:44`, distance `5.03 km`, and rows that align with the exported activity-boundary candidate rows.
- Priority 5 is a paused and manually skipped Work guard case. Apple Fitness shows workout time `0:26:19`, elapsed time `0:28:07`, distance `3.90 km`, and Work as `1.21 km` in `07:40` at `6'20"/km`.

## Priority 5 Timing Note

Priority 5 confirms that Apple Fitness uses active/timer pace for the paused/skipped Work row: `07:40` over `1.21 km` is approximately `6'20"/km`. The exported activity-boundary candidate row matches that basis with `activeDurationSeconds` around `460.5`, `elapsedDurationSeconds` around `568.7`, and `pauseOverlapSeconds` around `108.2`.

The plan-derived reconstructed row is not the trusted row source for this case: it reconstructs Work as a full `2.00 km` row over `14:40`, then reports an Open/Extra tail and a missing-cooldown warning. For this shape, compare Apple Fitness against HealthKit activity-boundary candidate rows and the normal-detail resolved-row path, not raw segment-marker or plan-derived reconstruction output.

## Guardrails

- Apple Fitness screenshots and typed rows are visual/manual validation references only.
- Raw HealthKit Debug and Parity Lab candidate rows are debug/export evidence.
- HealthFit/FIT, if added later, remains offline validation evidence and must not become app runtime input.
- Priority 5 is useful as a paused/manual-skip guard case; it should not be used to broaden interval-row analytics until the analytics gate is separately reopened.
