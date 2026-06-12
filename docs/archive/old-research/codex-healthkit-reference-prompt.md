# Codex Prompt: Use HealthKit Reference Pack

Use this when starting a Codex task related to HealthKit, Apple Watch workouts, or running app metrics.

```text
Before making changes, read the HealthKit reference pack in this folder.

Start with:
1. 13-codex-rules-for-healthkit.md
2. references/apple-healthkit-links.md
3. The topic-specific file relevant to the task.

Apple documentation is the source of truth. The local markdown files are implementation guidance and summaries only.

For any HealthKit change:
- Preserve raw HealthKit identity and metadata.
- Separate raw data from derived metrics.
- Use optional fields for metrics that may not exist.
- Do not assume Apple Fitness display fields are available directly in HealthKit.
- Add or update tests for unit conversion, missing data, dedupe, and derived calculations.
- Explain which values are read directly from HealthKit and which values are calculated by the app.
```
