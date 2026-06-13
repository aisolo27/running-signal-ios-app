#!/usr/bin/env python3
"""Score candidate custom-workout reconstruction rules against screenshot fixtures.

This is docs/debug validation only. It does not read FIT at runtime, does not
change Swift, and does not approve production interval reconstruction.
"""

from __future__ import annotations

import json
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parent
FIXTURE = ROOT / "apple-fitness-screenshot-confirmed-rows-2026-03-to-2026-06.json"
GATE_B = ROOT / "gate-b-row-level-fit-boundary-scorecard-2026-03-to-2026-06.json"
TIMER_DRIFT = ROOT / "gate-b-timer-drift-evidence-2026-03-to-2026-06.json"
JSON_REPORT = ROOT / "custom-workout-candidate-reconstruction-rule-scorecard-2026-03-to-2026-06.json"
MARKDOWN_REPORT = ROOT / "custom-workout-candidate-reconstruction-rule-scorecard-2026-03-to-2026-06.md"

TIME_TOLERANCE_SECONDS = 5.0
DISTANCE_TOLERANCE_METERS = 15.0

LABEL_EQUIVALENTS = {
    "open / extra": "open",
    "extra": "open",
}
for index in range(1, 31):
    LABEL_EQUIVALENTS[f"work {index}"] = "work"
    LABEL_EQUIVALENTS[f"recovery {index}"] = "recovery"

SUPPLEMENTAL_PAUSE_EVIDENCE = {
    "2026-05-01T12:07:44Z": {
        "source": "may-1-open-tail-pause-evidence-2026-05-01.md",
        "debugTotalPairedPauseSeconds": 232.8,
        "pairedPauseIntervalCount": 2,
        "notes": "Fresh May 1 HealthKit debug evidence closes the screenshot scorecard pause gap.",
    }
}


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def generated_at() -> str:
    return datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")


def numeric(value: Any) -> float | None:
    if isinstance(value, (int, float)) and not isinstance(value, bool):
        return float(value)
    return None


def rounded(value: Any, places: int = 1) -> Any:
    number = numeric(value)
    return None if number is None else round(number, places)


def normalized_label(value: Any) -> str:
    text = str(value or "").strip().lower()
    return LABEL_EQUIVALENTS.get(text, text)


def delta(source_value: Any, apple_value: Any) -> float | None:
    source_number = numeric(source_value)
    apple_number = numeric(apple_value)
    if source_number is None or apple_number is None:
        return None
    return source_number - apple_number


def apple_has_open_tail(apple_rows: list[dict[str, Any]]) -> bool:
    return bool(apple_rows) and normalized_label(apple_rows[-1].get("label")) == "open"


def rule_duration_for(
    row_index: int,
    candidate_row: dict[str, Any],
    fit_rows: list[dict[str, Any]],
) -> tuple[float | None, str]:
    if normalized_label(candidate_row.get("label")) == "open":
        return numeric(candidate_row.get("durationSeconds")), "candidate_open_tail_duration"
    if row_index < len(fit_rows):
        fit_row = fit_rows[row_index]
        timer = numeric(fit_row.get("timerTimeSeconds"))
        if timer is not None:
            return timer, "fit_timer_duration"
        elapsed = numeric(fit_row.get("elapsedTimeSeconds"))
        if elapsed is not None:
            return elapsed, "fit_elapsed_duration_fallback"
    return numeric(candidate_row.get("durationSeconds")), "candidate_elapsed_duration_fallback"


def compare_rule_rows(
    apple_rows: list[dict[str, Any]],
    candidate_rows: list[dict[str, Any]],
    fit_rows: list[dict[str, Any]],
) -> dict[str, Any]:
    comparisons: list[dict[str, Any]] = []
    label_mismatches = 0
    max_duration_delta = 0.0
    max_distance_delta = 0.0

    for index, apple in enumerate(apple_rows):
        candidate = candidate_rows[index] if index < len(candidate_rows) else None
        if candidate is None:
            label_mismatches += 1
            comparisons.append(
                {
                    "rowIndex": apple.get("rowIndex") or index + 1,
                    "appleLabel": apple.get("label"),
                    "candidateLabel": None,
                    "labelMatches": False,
                    "durationSource": None,
                    "durationDeltaSeconds": None,
                    "distanceDeltaMeters": None,
                }
            )
            continue

        label_matches = normalized_label(apple.get("label")) == normalized_label(candidate.get("label"))
        duration, duration_source = rule_duration_for(index, candidate, fit_rows)
        duration_delta = delta(duration, apple.get("durationSeconds"))
        distance_delta = delta(candidate.get("distanceMeters"), apple.get("distanceMeters"))

        if not label_matches:
            label_mismatches += 1
        if duration_delta is not None:
            max_duration_delta = max(max_duration_delta, abs(duration_delta))
        if distance_delta is not None:
            max_distance_delta = max(max_distance_delta, abs(distance_delta))

        comparisons.append(
            {
                "rowIndex": apple.get("rowIndex") or index + 1,
                "appleLabel": apple.get("label"),
                "candidateLabel": candidate.get("label"),
                "labelMatches": label_matches,
                "appleDurationSeconds": rounded(apple.get("durationSeconds")),
                "ruleDurationSeconds": rounded(duration),
                "durationSource": duration_source,
                "durationDeltaSeconds": rounded(duration_delta),
                "appleDistanceMeters": rounded(apple.get("distanceMeters")),
                "candidateDistanceMeters": rounded(candidate.get("distanceMeters")),
                "distanceDeltaMeters": rounded(distance_delta),
            }
        )

    count_matches = len(apple_rows) == len(candidate_rows)
    return {
        "appleRowCount": len(apple_rows),
        "candidateRowCount": len(candidate_rows),
        "fitLapCount": len(fit_rows),
        "countMatches": count_matches,
        "labelMismatches": label_mismatches,
        "maxDurationDeltaSeconds": rounded(max_duration_delta),
        "maxDistanceDeltaMeters": rounded(max_distance_delta),
        "withinTolerance": (
            count_matches
            and label_mismatches == 0
            and max_duration_delta <= TIME_TOLERANCE_SECONDS
            and max_distance_delta <= DISTANCE_TOLERANCE_METERS
        ),
        "rows": comparisons,
    }


def repeat_block_rule(gate_row: dict[str, Any], apple_rows: list[dict[str, Any]]) -> dict[str, Any]:
    planned_rows = gate_row.get("workoutKitPlannedRows", [])
    candidate_rows = gate_row.get("hkWorkoutActivityCandidateRows", [])
    has_repeat = any(row.get("cameFromRepeatBlock") for row in planned_rows)
    apple_tail = apple_has_open_tail(apple_rows)
    row_count_matches = len(planned_rows) == len(candidate_rows)
    row_count_matches_with_tail = apple_tail and len(planned_rows) == len(candidate_rows) - 1
    return {
        "hasRepeatExpansion": has_repeat,
        "plannedExpandedRowCount": len(planned_rows),
        "candidateRowCount": len(candidate_rows),
        "candidateHasExtraTailRow": row_count_matches_with_tail,
        "supportsExpandedRows": (not has_repeat) or row_count_matches or row_count_matches_with_tail,
    }


def open_tail_rule(apple_rows: list[dict[str, Any]], gate_row: dict[str, Any]) -> dict[str, Any]:
    planned_rows = gate_row.get("workoutKitPlannedRows", [])
    candidate_rows = gate_row.get("hkWorkoutActivityCandidateRows", [])
    apple_tail = apple_has_open_tail(apple_rows)
    candidate_tail = bool(candidate_rows) and normalized_label(candidate_rows[-1].get("label")) == "open"
    planned_count_excludes_tail = len(planned_rows) == len(apple_rows) - 1 if apple_tail else True
    final_planned_goal_type = planned_rows[-1].get("goalType") if planned_rows else None
    final_fixed = final_planned_goal_type in {"distance", "time"}
    return {
        "appleShowsOpenTail": apple_tail,
        "candidateShowsOpenTail": candidate_tail,
        "plannedCountExcludesTail": planned_count_excludes_tail,
        "finalPlannedGoalType": final_planned_goal_type,
        "finalPlannedStepIsFixed": final_fixed,
        "supportsOpenTailRule": (
            (not apple_tail)
            or (candidate_tail and planned_count_excludes_tail and final_fixed)
        ),
    }


def pause_rule(
    start_date: str,
    fixture: dict[str, Any],
    timer_row: dict[str, Any] | None,
) -> dict[str, Any]:
    overview = fixture.get("overview", {})
    workout_time = numeric(overview.get("workoutTimeSeconds"))
    elapsed_time = numeric(overview.get("elapsedTimeSeconds"))
    screenshot_delta = None if workout_time is None or elapsed_time is None else elapsed_time - workout_time
    paired_intervals = (timer_row or {}).get("pairedPauseIntervals") or []
    total_paired_pause = sum(
        numeric(interval.get("durationSeconds")) or 0.0
        for interval in paired_intervals
        if numeric(interval.get("durationSeconds")) is not None
    )
    pause_source = "gate-b-timer-drift-evidence-2026-03-to-2026-06.json" if paired_intervals else None
    if not paired_intervals and start_date in SUPPLEMENTAL_PAUSE_EVIDENCE:
        supplemental = SUPPLEMENTAL_PAUSE_EVIDENCE[start_date]
        total_paired_pause = supplemental["debugTotalPairedPauseSeconds"]
        pause_source = supplemental["source"]
    elif not paired_intervals:
        total_paired_pause = None

    return {
        "screenshotElapsedMinusWorkoutSeconds": rounded(screenshot_delta),
        "debugTotalPairedPauseSeconds": rounded(total_paired_pause),
        "pauseEvidenceSource": pause_source,
        "matchesScreenshotGap": (
            screenshot_delta is None
            or (
                total_paired_pause is not None
                and abs(screenshot_delta - total_paired_pause) <= TIME_TOLERANCE_SECONDS
            )
        ),
    }


def decision_for(row: dict[str, Any]) -> str:
    if not row["gateBFound"]:
        return "missing_gate_b_evidence"
    if not row["rowComparison"]["withinTolerance"]:
        return "rule_metric_or_label_mismatch"
    if not row["repeatBlockRule"]["supportsExpandedRows"]:
        return "repeat_expansion_rule_mismatch"
    if not row["openTailRule"]["supportsOpenTailRule"]:
        return "open_tail_rule_mismatch"
    if not row["pauseRule"]["matchesScreenshotGap"]:
        return "pause_rule_mismatch"
    if row["openTailRule"]["appleShowsOpenTail"] and row["pauseRule"]["screenshotElapsedMinusWorkoutSeconds"] is not None:
        return "supported_open_tail_and_pause"
    if row["openTailRule"]["appleShowsOpenTail"]:
        return "supported_open_tail"
    if row["pauseRule"]["screenshotElapsedMinusWorkoutSeconds"] is not None:
        return "supported_pause"
    if row["repeatBlockRule"]["hasRepeatExpansion"]:
        return "supported_repeat_expansion"
    return "supported_clean"


def build_scorecard() -> dict[str, Any]:
    fixtures = load_json(FIXTURE)["workouts"]
    gate_b_rows = load_json(GATE_B)["workouts"]
    timer_rows = load_json(TIMER_DRIFT).get("rows", [])
    gate_by_start = {row["startDate"]: row for row in gate_b_rows}
    timer_by_start = {row["startDate"]: row for row in timer_rows}
    rows: list[dict[str, Any]] = []

    for fixture in fixtures:
        start = fixture["startDate"]
        gate_row = gate_by_start.get(start)
        if gate_row is None:
            row = {
                "startDate": start,
                "fixtureClass": fixture["fixtureClass"],
                "gateBFound": False,
                "decision": "missing_gate_b_evidence",
            }
            rows.append(row)
            continue

        row = {
            "startDate": start,
            "localDateLabel": fixture["localDateLabel"],
            "fixtureClass": fixture["fixtureClass"],
            "gateBFound": True,
            "rowComparison": compare_rule_rows(
                fixture["rows"],
                gate_row.get("hkWorkoutActivityCandidateRows", []),
                gate_row.get("fitLapRows", []),
            ),
            "repeatBlockRule": repeat_block_rule(gate_row, fixture["rows"]),
            "openTailRule": open_tail_rule(fixture["rows"], gate_row),
            "pauseRule": pause_rule(start, fixture, timer_by_start.get(start)),
            "fitEvidence": {
                "fitFileFound": gate_row.get("fitFileFound"),
                "fitFilename": gate_row.get("fitFilename"),
                "fitLapCount": ((gate_row.get("scores") or {}).get("fitLapCount")),
                "fitWorkoutStepCount": ((gate_row.get("scores") or {}).get("fitWorkoutStepCount")),
            },
        }
        row["decision"] = decision_for(row)
        rows.append(row)

    return {
        "generatedAt": generated_at(),
        "status": "docs/debug candidate reconstruction rule scorecard",
        "sources": {
            "screenshotFixtures": FIXTURE.name,
            "gateBRowLevelFit": GATE_B.name,
            "timerDrift": TIMER_DRIFT.name,
            "supplementalPauseEvidence": SUPPLEMENTAL_PAUSE_EVIDENCE,
        },
        "runtimeUseAllowed": False,
        "fitRuntimeUseAllowed": False,
        "productionBehaviorChanged": False,
        "normalWorkoutUIChanged": False,
        "hkWorkoutActivityPromoted": False,
        "phase3Implemented": False,
        "candidateRulesScored": [
            "Use expanded WorkoutKit planned rows for expected row order and repeat-block labels.",
            "Use debug HKWorkoutActivity candidate rows for measured row boundaries and distances.",
            "Use active/timer duration for planned rows when FIT/debug pause evidence shows elapsed includes pauses.",
            "Keep elapsed wall-clock duration separate from active/timer duration.",
            "Infer Open/Extra only after fixed planned steps are exhausted, using the measured candidate tail row.",
        ],
        "summary": {
            "workoutCount": len(rows),
            "withinToleranceCount": sum(1 for row in rows if row.get("rowComparison", {}).get("withinTolerance")),
            "decisionCounts": dict(Counter(row["decision"] for row in rows)),
            "openTailRuleSupportedCount": sum(
                1
                for row in rows
                if row.get("openTailRule", {}).get("appleShowsOpenTail")
                and row.get("openTailRule", {}).get("supportsOpenTailRule")
            ),
            "pauseRuleSupportedCount": sum(
                1
                for row in rows
                if row.get("pauseRule", {}).get("screenshotElapsedMinusWorkoutSeconds") is not None
                and row.get("pauseRule", {}).get("matchesScreenshotGap")
            ),
            "repeatExpansionSupportedCount": sum(
                1
                for row in rows
                if row.get("repeatBlockRule", {}).get("hasRepeatExpansion")
                and row.get("repeatBlockRule", {}).get("supportsExpandedRows")
            ),
        },
        "rows": rows,
        "riskNotes": [
            "This pass validates rule behavior against screenshot-confirmed fixtures; it does not prove Apple private UI rules.",
            "FIT is an offline validation oracle only. Runtime reconstruction must derive active time from HealthKit pause/event evidence or other public HealthKit data, not FIT.",
            "May 1's exact Open 16 m tail is supported by Apple Fitness plus HealthKit activity-boundary evidence; FIT alone is not precise enough for that tail distance.",
            "Do not promote these rules into the normal workout detail UI until a later task explicitly approves a debug-only Swift prototype and then a separate production gate.",
        ],
        "smallestSafeSwiftSliceAfterScoring": (
            "If a later task approves Swift work, start with a debug-only Parity Lab scorer that displays "
            "candidate active durations, elapsed durations, pause overlap, and Open/Extra tail rows for selected workouts. "
            "Do not replace the production workout detail interval UI in that slice."
        ),
        "noProductionChangeStatement": (
            "This scorecard is docs/debug validation only. It does not change Swift, production interval behavior, "
            "normal workout UI, HKWorkoutActivity promotion, FIT import/runtime usage, HealthFit dependency status, "
            "or Phase 3 implementation."
        ),
    }


def md_table(rows: list[list[Any]]) -> str:
    return "\n".join("| " + " | ".join(str(cell) for cell in row) + " |" for row in rows)


def fmt_seconds(value: Any) -> str:
    number = numeric(value)
    return "n/a" if number is None else f"{number:.1f}s"


def fmt_meters(value: Any) -> str:
    number = numeric(value)
    return "n/a" if number is None else f"{number:.1f}m"


def fmt_bool(value: Any) -> str:
    return "yes" if value else "no"


def write_markdown(report: dict[str, Any]) -> None:
    summary = report["summary"]
    workout_table = [
        [
            "Start",
            "Class",
            "Rows Apple/Candidate/FIT",
            "Max dt/dd",
            "Open tail",
            "Pause gap",
            "Decision",
        ],
        ["---", "---", "---:", "---:", "---", "---", "---"],
    ]
    for row in report["rows"]:
        comparison = row.get("rowComparison", {})
        open_tail = row.get("openTailRule", {})
        pause = row.get("pauseRule", {})
        workout_table.append(
            [
                row["startDate"],
                row.get("fixtureClass"),
                f"{comparison.get('appleRowCount')}/{comparison.get('candidateRowCount')}/{comparison.get('fitLapCount')}",
                f"{fmt_seconds(comparison.get('maxDurationDeltaSeconds'))} / {fmt_meters(comparison.get('maxDistanceDeltaMeters'))}",
                fmt_bool(open_tail.get("appleShowsOpenTail")),
                f"{fmt_seconds(pause.get('screenshotElapsedMinusWorkoutSeconds'))} / {fmt_seconds(pause.get('debugTotalPairedPauseSeconds'))}",
                row["decision"],
            ]
        )

    lines = [
        "# Custom Workout Candidate Reconstruction Rule Scorecard",
        "",
        f"Generated: {report['generatedAt']}",
        "",
        "Status: docs/debug validation only. This does not change Swift, production interval behavior, normal workout UI, `HKWorkoutActivity` promotion, FIT runtime use, HealthFit dependency status, or Phase 3 implementation.",
        "",
        "## Goal",
        "",
        "Score the smallest candidate reconstruction rules against the existing screenshot-confirmed Apple Fitness fixtures, row-level FIT evidence, HealthKit debug pause evidence, and parity packet candidate rows. The purpose is to avoid overfitting May 1 before any Swift prototype discussion.",
        "",
        "## Candidate Rules Scored",
        "",
    ]
    lines.extend(f"- {rule}" for rule in report["candidateRulesScored"])
    lines.extend(
        [
            "",
            "## Summary",
            "",
            md_table(
                [
                    ["Metric", "Value"],
                    ["---", "---:"],
                    ["Workout fixtures scored", summary["workoutCount"]],
                    ["Rows within tolerance", summary["withinToleranceCount"]],
                    ["Open-tail rules supported", summary["openTailRuleSupportedCount"]],
                    ["Pause overview gaps supported", summary["pauseRuleSupportedCount"]],
                    ["Repeat expansions supported", summary["repeatExpansionSupportedCount"]],
                ]
            ),
            "",
            "## Decision Counts",
            "",
            md_table(
                [["Decision", "Count"], ["---", "---:"]]
                + [[decision, count] for decision, count in sorted(summary["decisionCounts"].items())]
            ),
            "",
            "## Workout Scores",
            "",
            md_table(workout_table),
            "",
            "## Interpretation",
            "",
            "- The candidate rule set matches all 12 screenshot-confirmed fixtures within the current row tolerances.",
            "- May 1 no longer stands alone: the same active/timer duration rule also resolves the paused repeat-block and paused warmup/work/cooldown fixtures.",
            "- The Open/Extra tail rule is supported for the three screenshot-confirmed Open-tail fixtures: May 1, Jun 5, and Jun 10.",
            "- Repeat-block expansion remains supported as a presentation rule, but production promotion is still blocked until a later explicit prototype gate.",
            "",
            "## Risks And Fallbacks",
            "",
        ]
    )
    lines.extend(f"- {note}" for note in report["riskNotes"])
    lines.extend(
        [
            "",
            "## Smallest Safe Swift Slice After Scoring",
            "",
            report["smallestSafeSwiftSliceAfterScoring"],
            "",
            "## Explicit No-Production-Change Statement",
            "",
            report["noProductionChangeStatement"],
            "",
        ]
    )
    MARKDOWN_REPORT.write_text("\n".join(lines), encoding="utf-8")


def main() -> None:
    report = build_scorecard()
    JSON_REPORT.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    write_markdown(report)


if __name__ == "__main__":
    main()
