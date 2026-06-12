# Milestone 3: Normalization And Persistence

## Goal
Normalize HealthKit/sample workouts into canonical app models and store them locally.

## Affected Areas
- Canonical workout model
- SwiftData model
- Persistence service
- History and detail views

## Exact Tasks
- Store normalized workouts in SwiftData.
- Preserve manual fields during refresh.
- Use seconds/km internally for pace.
- Show basic History and detail screens from normalized state.

## Acceptance Criteria
- App stores workouts locally.
- Refreshes preserve manual labels and notes.
- History can open workout detail.
- Duplicate workouts are not counted in analytics.

## Test Commands
- Unit tests for pace, persistence-safe merge behavior, duplicate detection.
- XcodeBuildMCP build/run.

## Simulator Checks
- Open History.
- Open a workout detail.
- Save a label/note.

## Known Risks
- SwiftData schema is v1-only and may need migration if fields change later.

## Completion Notes
- Completed. Canonical models, seconds/km pace normalization, SwiftData persistence, manual-field preservation, History, and workout detail are implemented and verified in Simulator.
