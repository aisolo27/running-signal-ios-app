# Comparison

Use this after Apple Fitness screenshots and the RunSignal Raw HealthKit Debug export have been added.

## Key Question

Does RunSignal place the fixed-distance Work boundary earlier than Apple Fitness by more than 2 seconds, and does that make Open / Extra too long?

## Comparison Table

| Row | Label | Apple Distance | RunSignal Distance | Distance Delta | Apple Time | RunSignal Time | Time Delta | Pass? | Notes |
|---:|---|---:|---:|---:|---:|---:|---:|---|---|
| 1 | Work |  |  |  |  |  |  |  |  |
| 2 | Open |  |  |  |  |  |  |  |  |

## Decision

- If this repeats June 1's drift pattern, add it to the boundary-rule research set.
- If this matches Apple Fitness within tolerance, keep it as evidence that June 1 may be a one-off.
- Do not change app logic from this single future example alone.
