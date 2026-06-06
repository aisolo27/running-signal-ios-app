# Milestone 8: Markdown Export

## Goal
Generate local coaching summaries that can be shared or pasted into ChatGPT/Codex without any API call.

## Affected Areas
- Analytics export formatter
- Data tab share action
- Latest run and race goal summary content

## Exact Tasks
- Build Markdown summary from current local snapshot.
- Include goal, latest run, training load, readiness, and data caveats.
- Add ShareLink.
- Keep export local-only.

## Acceptance Criteria
- Data tab exposes share action.
- Export includes confidence/caveats.
- No OpenAI/API integration is added.

## Test Commands
- Unit test export content.
- XcodeBuildMCP build/run.

## Simulator Checks
- Confirm share button is visible and tappable.

## Known Risks
- Share sheet behavior can vary by Simulator configuration.

## Completion Notes
- Completed. Data tab exposes a local ShareLink for a Markdown coaching brief with race goal, latest run, training load, readiness, and data caveats. No AI/API integration was added.
