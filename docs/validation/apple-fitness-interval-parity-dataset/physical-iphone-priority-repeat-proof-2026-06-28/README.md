# Physical iPhone Priority Repeat Proof - 2026-06-28

Date archived: 2026-06-28

This folder archives the completed priority custom-workout evidence from the June 28 physical iPhone/Apple Watch run set. It is validation evidence only. It does not approve normal workout detail interval UI, broaden Gate B, or change production boundary logic.

## Scope

| Priority | Apple Fitness title | Workout ID | Status | Shape |
| --- | --- | --- | --- | --- |
| 1 | Priority 1 (pause work2, recovery3, cooldown) | `C75E6F78-0762-450A-94F6-72878DA8EC55` | Archived | Warmup, 4x Work/Recovery, fixed cooldown, Open/Extra tail, paused workout |
| 2 | Priority 2 (no pause) | `376F0E84-E296-4F64-9B07-4D9AA085B817` | Archived | Warmup, 4x Work/Recovery, fixed cooldown, Open/Extra tail, no pause |
| 3 | Priority 3 (no pause, open cooldown) | `8B07CF82-0778-4A83-B862-486275CCA923` | Archived | Warmup, 4x Work/Recovery, open cooldown, no pause |
| 4 | Not yet run | Pending | Pending | Planned priority run still needed |
| 5 | Not yet run | Pending | Pending | Planned priority run still needed |

## Evidence Files

Screenshots:

- `screenshots/priority-1-overview-v1.png`
- `screenshots/priority-1-intervals-v2.png`
- `screenshots/priority-2-overview-v1.png`
- `screenshots/priority-2-intervals-v2.png`
- `screenshots/priority-3-overview-v1.png`
- `screenshots/priority-3-intervals-v2.png`

RunSignal exports:

- `exports/priority-1-raw-healthkit-debug-2026-06-28.md`
- `exports/priority-1-candidate-json-snippet-2026-06-28.txt`
- `exports/priority-2-raw-healthkit-debug-2026-06-28.md`
- `exports/priority-2-candidate-json-snippet-2026-06-28.txt`
- `exports/priority-3-raw-healthkit-debug-2026-06-28.md`
- `exports/priority-3-candidate-json-snippet-2026-06-28.txt`

Typed Apple Fitness rows:

- `apple-fitness-manual-rows-priority-1-2026-06-28.json`
- `apple-fitness-manual-rows-priority-2-2026-06-28.json`
- `apple-fitness-manual-rows-priority-3-2026-06-28.json`

Unmatched or pending material:

- `pending-unmatched/june-26-raw-healthkit-debug-unmatched.md`
- `pending-unmatched/text-533051439EB8-1-unmatched.txt`

## Initial Read

- Priority 1 is the pause/timer case. Apple Fitness shows workout time `0:38:39`, elapsed time `0:43:32`, distance `6.03 km`, and an Open row after the fixed cooldown.
- Priority 2 is the clean no-pause fixed-cooldown-plus-tail case. Apple Fitness shows workout time `0:40:30`, distance `5.94 km`, and an Open row after the fixed cooldown.
- Priority 3 is the clean no-pause open-cooldown case. Apple Fitness shows workout time `0:35:19`, distance `4.95 km`, and no separate Open row after cooldown.

## Guardrails

- Apple Fitness screenshots and typed rows are visual/manual validation references only.
- Raw HealthKit Debug and Parity Lab candidate rows are debug/export-only evidence.
- HealthFit/FIT, if added later, remains offline validation evidence and must not become app runtime input.
- Runs 4 and 5 remain pending; do not mark the five-run priority set complete from this folder.
