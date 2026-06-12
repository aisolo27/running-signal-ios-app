# Fixed-Distance Boundary Strategy Research

Status: research only. Do not change production reconstruction behavior from this note alone.

Normal WorkoutKit Reconstructed Intervals promotion remains blocked.

## Evidence Scope

Valid fixed-distance Work plus real Open tail drift examples:

| Date | Apple Fitness | Current RunSignal | Current read |
|---|---|---|---|
| 2026-06-01 | Work 6.45 km / 42:44; Open 5 m / 0:07 | Work about 42:38; Open / Extra about 0:13 | RunSignal exact crossing is internally consistent, but Apple Fitness appears later. |
| 2026-05-26 | Work 6.45 km / 42:11; Open 94 m / 0:41 | Work about 42:07; Open / Extra about 0:45 | Same drift direction as June 1. |
| 2026-06-12 | Work 5.00 km / 32:03; Open 36 m / 0:17 | Work about 31:59; Open / Extra about 0:22 | Same drift direction at a second goal distance. |

The Open rows are real post-goal running. Do not hide or merge Open into Work. The issue is Work boundary timing, not Open existence.

April 28 is not included in boundary scoring. Physical-device force re-enrich recovered WorkoutKit plan data, rich HealthKit samples, reconstructed intervals, and boundary diagnostics, but this workout is being kept as an evidence-recovery and fresh-query/cache-invalidation validation fixture rather than a main drift-tuning fixture.

Physical-device parity packets are now archived for May 26, June 1, June 2, June 3, June 4, June 5, and June 12. These packets should feed a future debug-only candidate boundary scorer; this research note still does not approve production behavior changes.

## Candidate Strategies

### A. Current Strategy

Use exact/interpolated crossing, or crossing sample end if within overshoot tolerance.

Current status:

- June 1: internally consistent, but about 5-6 seconds earlier than Apple Fitness.
- May 26: internally consistent, but about 4 seconds earlier than Apple Fitness.
- June 12: internally consistent, but about 4 seconds earlier than Apple Fitness.
- June 2 is a temporary-pass simple Work/Open guard and June 4 passes with current behavior, so any new rule must avoid regressing them.

### B. Next-Sample-End Strategy

For fixed-distance Work followed by real Open, end Work at the next distance sample end after the crossing sample.

Current evidence:

- June 1 moves from about 42:38 to about 42:41, improving but still short of Apple Fitness 42:44.
- May 26 moves from about 42:07 to about 42:10, improving but still short of Apple Fitness 42:11.
- June 12 moves from about 31:59 to about 32:01, improving but still short of Apple Fitness 32:03.

This is the strongest simple public-sample candidate so far, but it still does not fully explain Apple Fitness and does not get all three drift cases within preferred tolerance. It also needs pass-case boundary diagnostics before it can be considered safe.

### C. Apple-Visible Open Alignment Strategy

Choose the boundary that makes Open duration closest to the visible Apple Fitness Open row.

This explains the screenshots by construction, but it is not production-safe because it uses Apple Fitness as an external oracle. It can help label target behavior in research docs, not app logic.

### D. Final-Distance-Sample Anchored Strategy

If Apple Fitness Open is real and short, use final distance sample timing to infer the Work/Open transition.

This aligns June 1 closely because Apple Fitness's Work boundary appears near the final distance sample. It does not explain May 26 or June 12: the final distance sample is much later than Apple Fitness's Work row and would make Open too short. This is likely an overfit to short-tail cases where Apple Fitness happens to be near the final sample.

### E. Segment-Marker-Assisted Diagnostic Only

Inspect whether any raw HealthKit marker appears near Apple Fitness's visible Work/Open boundary.

This remains diagnostic only:

- HealthKit Segment Markers must not be used as production Apple Fitness interval rows.
- Segment markers can report whether a raw event window is near Apple Fitness's visible transition.
- Current exports show raw/overlapping segment markers near the tail, but they do not provide a clean repeatable Apple Fitness Work/Open boundary source.

## Offline Harness

Run:

```bash
python3 docs/validation/apple-fitness-interval-parity-dataset/analyze_fixed_distance_boundaries.py
```

The harness reads `interval-parity-fixture.json` and the Raw HealthKit Debug exports, then compares current, next-sample-end, Apple-visible Open alignment, and final-distance-sample anchored timings.

## Current Conclusion

Fixed-distance Work plus real Open tail drift now has at least three valid examples across two goal distances: 6.45 km and 5.00 km. June 1 is no longer isolated.

No deterministic rule is approved yet. The next-sample-end strategy improves all three scored drift examples but does not fully explain them, and it could regress existing pass/temporary-pass guards if applied globally. A production rule would need fresh boundary diagnostics for the passing Work/Open fixtures, more examples, or a narrow gate that preserves June 2, June 3, June 4, and June 5.

Normal WorkoutKit interval UI promotion remains blocked.
