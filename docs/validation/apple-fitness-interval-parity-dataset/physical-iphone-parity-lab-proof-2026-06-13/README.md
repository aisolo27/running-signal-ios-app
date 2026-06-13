# Physical iPhone Parity Lab Proof - 2026-06-13

Status: physical-iPhone debug/export validation evidence only. This does not change production interval behavior, normal workout UI, FIT runtime use, or HealthFit dependency status.

## Source

User-supplied files exported from the latest RunSignal debug build installed on physical iPhone `AIS17PM`.

Repo-local archive:

- `docs/validation/apple-fitness-interval-parity-dataset/physical-iphone-parity-lab-proof-2026-06-13/exports/`

## Files

| File | Type | Workout |
| --- | --- | --- |
| `text-DED73A876645-1.txt` | Raw HealthKit Debug markdown | May 1, 2026 |
| `text-9A562B484053-1.txt` | selected-workout parity JSON | `2026-05-01T12:07:44Z` |
| `text-94FEA549B344-1.txt` | Raw HealthKit Debug markdown | Jun 5, 2026 |
| `text-015A5E57E827-1.txt` | selected-workout parity JSON | `2026-06-05T11:53:53Z` |
| `text-3FFFD2281E0F-1.txt` | Raw HealthKit Debug markdown | Jun 10, 2026 |
| `text-BD5153FCB5EE-1.txt` | selected-workout parity JSON | `2026-06-10T11:27:51Z` |

## Result

| Start | Class | Rows Apple/Candidate | Open tail | Paired pause | Max active dt | Max distance delta | Result |
| --- | --- | ---: | ---: | ---: | ---: | ---: | --- |
| `2026-05-01T12:07:44Z` | fixed_cooldown_open_tail | 5/5 | 1 | `232.8 s` | `0.48 s` | `9.06 m` | matches |
| `2026-06-05T11:53:53Z` | fixed_cooldown_open_tail | 4/4 | 1 | `0.0 s` | `0.45 s` | `6.57 m` | matches |
| `2026-06-10T11:27:51Z` | repeat_block_fixed_cooldown_open_tail | 11/11 | 1 | `0.0 s` | `0.90 s` | `8.92 m` | matches |

The parity JSON exports preserved the debug-only safety flags:

- `productionIntervalBehaviorChanged=false`
- `normalWorkoutUIChanged=false`
- `usesFITRuntimeTruth=false`
- `usesAppleFitnessManualRuntimeLogic=false`
- `scope=debug/export-only`

## Decision

The physical iPhone exports confirm the debug-only Parity Lab scorer is still producing the expected candidate rows for the three requested Open-tail proof dates. This supports keeping the Raw HealthKit Debug / Parity Lab comparison workflow active, but it does not approve normal workout detail UI promotion.
