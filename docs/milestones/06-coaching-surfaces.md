# Milestone 6: Coaching Surfaces

## Goal
Wire real analytics into Today, Latest Run, and Race Goal.

## Affected Areas
- Today tab
- Latest Run tab
- Race Goal tab
- Shared insight components

## Exact Tasks
- Show readiness and next focus on Today.
- Show latest outdoor run execution review.
- Show race goal pace, best 5K evidence, pace gap, and readiness bands.
- Keep every card confidence-aware.

## Acceptance Criteria
- First screen answers what matters before the next run.
- Latest Run answers execution quality without overclaiming.
- Race Goal answers sub-20 progress with missing evidence visible.

## Test Commands
- XcodeBuildMCP build/run.
- UI test smoke launch.

## Simulator Checks
- Check Today, Latest Run, and Race Goal on small and large iPhone simulators.

## Known Risks
- Layout must stay compact enough for one-handed iPhone use.

## Completion Notes
- Completed. Today, Latest Run, and Race Goal render analytics and confidence states in the iPhone 17 Simulator with no blank screens or obvious text overlap.
