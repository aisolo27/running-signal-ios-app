# June 26, 2026 Paused Repeat Fixed-Tail Open/Extra Proof

Archived: 2026-06-26

Scope: evidence closeout only. This folder does not change Swift code, does not promote Gate B, and does not promote normal workout detail. FIT remains offline validation evidence only, never runtime truth or an app input.

## Inputs

- `apple-fitness-screenshots/2026-06-26-workout-template.PNG`
- `apple-fitness-screenshots/2026-06-26-apple-fitness-intervals.PNG`
- `apple-fitness-screenshots/2026-06-26-apple-fitness-summary.PNG`
- `raw-exports/2026-06-26-raw-healthkit-debug.txt`
- `parity-packets/2026-06-26-parity-packet.json`
- `healthfit-fit/2026-06-26-080611-Outdoor-Running-Adriels-Apple-Watch.fit`

## FIT Source

- Google Drive folder: `https://drive.google.com/drive/u/0/folders/1QUo6CaiRIBtgV0sk37Uc4wOhFmINyQyf`
- Google Drive file: `2026-06-26-080611-Outdoor Running-Adriel’s Apple Watch.fit`
- Google Drive file ID: `1SnKS_fuf3NKkgshfNlXA3bCTZoYhF9iJ`
- Google Drive file URL: `https://drive.google.com/file/d/1SnKS_fuf3NKkgshfNlXA3bCTZoYhF9iJ/view?usp=drivesdk`
- Local synced source: `/Users/adrielsolorzano/Library/Mobile Documents/iCloud~com~altifondo~HealthFit/Documents/2026-06-26-080611-Outdoor Running-Adriel’s Apple Watch.fit`

## Apple Fitness Shape

- Workout: `Friday Interval (Codex)`, Outdoor Run, Jun 26, 2026, 8:06-8:46.
- Template: `Warmup` 2 km, repeat 5x `Work` 200 m plus `Recovery` 2:00, fixed `Cooldown` 1 km.
- Apple Fitness rows: `Warmup` 2.00 km, five `Work` rows, five `Recovery` rows, `Cooldown` 1.00 km, final `Open` 715 m / 4:33.
- Summary screenshot: 5.71 km distance, 36:30 workout time, 39:52 elapsed time.

## RunSignal Evidence

- Target shape: `Warmup(2 km) > repeated Work/Recovery rows > fixed final Cooldown > inferred Open / Extra`, with paired pause evidence.
- `plannedExpandedRowCount`: 12
- `candidateRowCount`: 13
- `openTailRowCount`: 1
- `pairedPauseCount`: 3
- `totalPairedPauseSeconds`: 201.627
- `fixedRowExhaustionStatus`: `fixed-rows-exhausted-before-tail`
- `tailStatus`: `open-extra-tail-present`
- Tail distance: 715.214 m
- Tail elapsed duration: 272.818 s
- `customWorkoutComparisonSummary.status`: `supported`
- `fallbackReasons`: `[]`
- `fallbackReasonLabels`: `[]`
- `scope`: `debug/export-only`
- `usesFITRuntimeTruth`: `false`
- `promotesProductionBehavior`: `false`

Candidate rows:

| # | Row | Distance | Elapsed | Active/timer | Pause overlap |
| ---: | --- | ---: | ---: | ---: | ---: |
| 1 | Warmup | 1999.85 m | 735.19 s | 735.19 s | 0.00 s |
| 2 | Work 1 | 212.47 m | 47.59 s | 47.59 s | 0.00 s |
| 3 | Recovery 1 | 189.84 m | 207.82 s | 119.78 s | 88.04 s |
| 4 | Work 2 | 210.30 m | 39.13 s | 39.13 s | 0.00 s |
| 5 | Recovery 2 | 201.86 m | 176.94 s | 119.91 s | 57.02 s |
| 6 | Work 3 | 207.35 m | 42.15 s | 42.15 s | 0.00 s |
| 7 | Recovery 3 | 188.49 m | 175.74 s | 119.17 s | 56.57 s |
| 8 | Work 4 | 203.08 m | 39.12 s | 39.12 s | 0.00 s |
| 9 | Recovery 4 | 191.09 m | 119.35 s | 119.35 s | 0.00 s |
| 10 | Work 5 | 210.70 m | 37.62 s | 37.62 s | 0.00 s |
| 11 | Recovery 5 | 180.30 m | 119.30 s | 119.30 s | 0.00 s |
| 12 | Cooldown | 1003.74 m | 379.82 s | 379.82 s | 0.00 s |
| 13 | Open / Extra | 715.21 m | 272.82 s | 272.82 s | 0.00 s |

## Validation

Strict folder validation:

```bash
python3 docs/validation/apple-fitness-interval-parity-dataset/validate_parity_export_consistency.py \
  --require-readable-fallback-labels \
  docs/validation/apple-fitness-interval-parity-dataset/physical-iphone-paused-repeat-fixed-tail-open-extra-proof-2026-06-26
```

Result:

```text
Validated 2 parity export payload(s) in 2 file(s); skipped 1 JSON/text file(s) without debug parity fields.
```

Target-shape summary:

```bash
python3 docs/validation/apple-fitness-interval-parity-dataset/summarize_parity_proof_folder.py \
  --require-readable-fallback-labels \
  docs/validation/apple-fitness-interval-parity-dataset/physical-iphone-paused-repeat-fixed-tail-open-extra-proof-2026-06-26
```

Result:

```text
Validator: PASS
Validator output: Validated 2 parity export payload(s) in 2 file(s); skipped 1 JSON/text file(s) without debug parity fields.
Parsed payloads: 2
Unique payloads: 1
Candidate row count: 13
Planned expanded row count: 12
Open tail row count: 1
Paired pause count: 3
Fixed cooldown exhausted before tail: yes
Tail present: yes
Comparison status: supported
Readable fallback labels: yes
Result: TARGET EVIDENCE PRESENT
```

## Closeout Decision

This folder satisfies rung 2, `Evidence Available`, for the exact paused repeat fixed-tail `Open / Extra` row.

It does not promote the row to rung 3 `Debug-Supported`, does not change Swift behavior, does not promote normal workout detail, does not broaden Gate B, and does not prove visual rendering correctness.

## Negative Scope Citations

This proof is useful because it separates one exact evidence-available shape from nearby still-blocked families:

- Unresolved ambiguous repeat-tail cases remain blocked in `docs/project-state/accuracy-ledger.md`, with operational rules in `docs/validation/apple-fitness-interval-parity-dataset/ambiguous-repeat-tail-decision-rules-2026-06-24.md`. June 26 is an exact paired-pause fixed-tail shape with fixed cooldown exhaustion and a positive post-fixed-row tail; it does not approve broad repeat-tail ambiguity or count-only tail residuals.
- Broad recovery-containing `Open / Extra` tails outside the narrow May 1-style gate remain blocked in `docs/project-state/accuracy-ledger.md`, with boundary rules in `docs/validation/apple-fitness-interval-parity-dataset/broad-recovery-tail-boundaries-2026-06-23.md`. Recovery rows inside this repeat proof do not approve broad recovery-tail subclasses or merge recovery rows into residual movement.
- Paused warmup/work/cooldown timer outliers, including May 29-style cases, remain blocked in `docs/project-state/accuracy-ledger.md`, with outlier review in `docs/validation/apple-fitness-interval-parity-dataset/gate-b-warmup-work-cooldown-outlier-review-2026-06-23.md`. This is not a paused W/W/C timer-rule proof; May 29-style behavior still needs a shape-specific timer rule and guard tests.
- Broad paused repeat fixed-tail or ambiguous paused-tail cases remain blocked in `docs/project-state/accuracy-ledger.md`, with exact debug/export prototype boundaries in `docs/validation/apple-fitness-interval-parity-dataset/paused-repeat-open-extra-debug-prototype-plan-2026-06-24.md`. June 26 only covers the exact paired-pause fixed-tail shape; it does not approve unpaired pauses, cross-row pauses, ambiguous tails, or broad paused-tail behavior.

## Rung 3 Guardrails

Before any rung 3 `Debug-Supported` label, Swift prototype, normal-detail promotion, or broader Gate B claim, decide whether the recurring-shape bar requires a second qualifying physical example and adjacent guard coverage. The guard set should include at least:

- Zero-pause same-template control.
- Cross-boundary pause case.
- Open-cooldown counter-case where `Cooldown(Open)` must not be converted into `Open / Extra`.
