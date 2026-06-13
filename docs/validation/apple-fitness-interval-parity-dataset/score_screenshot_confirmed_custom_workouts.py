#!/usr/bin/env python3
"""Score screenshot-confirmed Apple Fitness custom-workout rows.

This is docs/debug validation only. It compares manually typed Apple Fitness
screenshots against existing RunSignal current rows, HKWorkoutActivity
candidate rows, WorkoutKit planned rows, FIT lap rows, and pause-drift evidence.
It does not read screenshots at runtime, does not read FIT at runtime, and does
not change app behavior.
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
JSON_REPORT = ROOT / "apple-fitness-screenshot-confirmed-scorecard-2026-03-to-2026-06.json"
MARKDOWN_REPORT = ROOT / "apple-fitness-screenshot-confirmed-scorecard-2026-03-to-2026-06.md"

TIME_TOLERANCE_SECONDS = 5.0
DISTANCE_TOLERANCE_METERS = 15.0
LABEL_EQUIVALENTS = {
    "work": "work",
    "work 1": "work",
    "work 2": "work",
    "work 3": "work",
    "work 4": "work",
    "work 5": "work",
    "work 6": "work",
    "work 7": "work",
    "work 8": "work",
    "work 9": "work",
    "work 10": "work",
    "recovery": "recovery",
    "recovery 1": "recovery",
    "recovery 2": "recovery",
    "recovery 3": "recovery",
    "recovery 4": "recovery",
    "recovery 5": "recovery",
    "recovery 6": "recovery",
    "recovery 7": "recovery",
    "recovery 8": "recovery",
    "recovery 9": "recovery",
    "recovery 10": "recovery",
    "open / extra": "open",
    "extra": "open",
}


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def generated_at() -> str:
    return datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")


def rounded(value: Any, places: int = 1) -> Any:
    if isinstance(value, (int, float)) and not isinstance(value, bool):
        return round(float(value), places)
    return value


def numeric(value: Any) -> float | None:
    if isinstance(value, (int, float)) and not isinstance(value, bool):
        return float(value)
    return None


def normalized_label(value: Any) -> str:
    text = str(value or "").strip().lower()
    return LABEL_EQUIVALENTS.get(text, text)


def compare_rows(apple_rows: list[dict[str, Any]], source_rows: list[dict[str, Any]]) -> dict[str, Any]:
    count_matches = len(apple_rows) == len(source_rows)
    comparisons: list[dict[str, Any]] = []
    label_mismatches = 0
    max_duration_delta = 0.0
    max_distance_delta = 0.0

    for index, apple in enumerate(apple_rows):
        source = source_rows[index] if index < len(source_rows) else None
        if source is None:
            comparisons.append(
                {
                    "rowIndex": apple["rowIndex"],
                    "appleLabel": apple["label"],
                    "sourceLabel": None,
                    "labelMatches": False,
                    "durationDeltaSeconds": None,
                    "distanceDeltaMeters": None,
                }
            )
            label_mismatches += 1
            continue

        source_label = source.get("label") or source.get("inferredLabel")
        label_matches = normalized_label(apple.get("label")) == normalized_label(source_label)
        duration_delta = delta(source.get("durationSeconds") or source.get("elapsedTimeSeconds"), apple.get("durationSeconds"))
        distance_delta = delta(source.get("distanceMeters") or source.get("totalDistanceMeters"), apple.get("distanceMeters"))
        if not label_matches:
            label_mismatches += 1
        if duration_delta is not None:
            max_duration_delta = max(max_duration_delta, abs(duration_delta))
        if distance_delta is not None:
            max_distance_delta = max(max_distance_delta, abs(distance_delta))
        comparisons.append(
            {
                "rowIndex": apple["rowIndex"],
                "appleLabel": apple["label"],
                "sourceLabel": source_label,
                "labelMatches": label_matches,
                "appleDurationSeconds": apple.get("durationSeconds"),
                "sourceDurationSeconds": rounded(source.get("durationSeconds") or source.get("elapsedTimeSeconds")),
                "durationDeltaSeconds": rounded(duration_delta),
                "appleDistanceMeters": apple.get("distanceMeters"),
                "sourceDistanceMeters": rounded(source.get("distanceMeters") or source.get("totalDistanceMeters")),
                "distanceDeltaMeters": rounded(distance_delta),
            }
        )

    extra_source_rows = max(0, len(source_rows) - len(apple_rows))
    return {
        "appleRowCount": len(apple_rows),
        "sourceRowCount": len(source_rows),
        "countMatches": count_matches,
        "extraSourceRows": extra_source_rows,
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


def delta(source_value: Any, apple_value: Any) -> float | None:
    source_number = numeric(source_value)
    apple_number = numeric(apple_value)
    if source_number is None or apple_number is None:
        return None
    return source_number - apple_number


def apple_has_open_tail(apple_rows: list[dict[str, Any]]) -> bool:
    return any(normalized_label(row.get("label")) == "open" for row in apple_rows)


def planned_label_check(apple_rows: list[dict[str, Any]], planned_rows: list[dict[str, Any]]) -> dict[str, Any]:
    comparable_apple_rows = apple_rows
    has_tail = apple_has_open_tail(apple_rows)
    if has_tail and planned_rows and normalized_label(apple_rows[-1].get("label")) == "open":
        comparable_apple_rows = apple_rows[:-1]
    return {
        "appleRowCount": len(apple_rows),
        "plannedRowCount": len(planned_rows),
        "countMatches": len(comparable_apple_rows) == len(planned_rows),
        "appleHasExtraOpenTailRow": has_tail and len(comparable_apple_rows) != len(apple_rows),
        "labelMismatches": sum(
            1
            for apple, planned in zip(comparable_apple_rows, planned_rows)
            if normalized_label(apple.get("label")) != normalized_label(planned.get("label"))
        ),
        "plannedRowsIncludeRepeatExpansion": any(row.get("cameFromRepeatBlock") for row in planned_rows),
    }


def open_tail_check(apple_rows: list[dict[str, Any]], gate_b_row: dict[str, Any] | None) -> dict[str, Any]:
    apple_has_open = apple_has_open_tail(apple_rows)
    planned_rows = (gate_b_row or {}).get("workoutKitPlannedRows", [])
    final_plan = planned_rows[-1] if planned_rows else {}
    final_plan_fixed = final_plan.get("goalType") in {"distance", "time"}
    score_tail = ((gate_b_row or {}).get("scores") or {}).get("openExtraTailHandling", {}).get("fitInferredTail")
    return {
        "appleShowsOpenTail": apple_has_open,
        "finalPlanGoalType": final_plan.get("goalType"),
        "finalPlanIsFixed": final_plan_fixed,
        "scorecardFITInferredTail": score_tail,
        "supportsOpenTailRule": apple_has_open and final_plan_fixed,
    }


def pause_check(fixture: dict[str, Any], timer_row: dict[str, Any] | None) -> dict[str, Any]:
    overview = fixture.get("overview", {})
    workout_time = numeric(overview.get("workoutTimeSeconds"))
    elapsed_time = numeric(overview.get("elapsedTimeSeconds"))
    screenshot_delta = None if workout_time is None or elapsed_time is None else elapsed_time - workout_time
    max_timer_row = (timer_row or {}).get("maxTimerDriftRow") or {}
    paired_intervals = (timer_row or {}).get("pairedPauseIntervals") or []
    total_paired_pause = sum(
        numeric(interval.get("durationSeconds")) or 0.0
        for interval in paired_intervals
        if numeric(interval.get("durationSeconds")) is not None
    )
    total_paired_pause = total_paired_pause if paired_intervals else None
    pause_overlap = numeric(max_timer_row.get("pauseOverlapSeconds"))
    return {
        "screenshotWorkoutTimeSeconds": workout_time,
        "screenshotElapsedTimeSeconds": elapsed_time,
        "screenshotElapsedMinusWorkoutSeconds": rounded(screenshot_delta),
        "debugTotalPairedPauseSeconds": rounded(total_paired_pause),
        "debugPauseOverlapSeconds": rounded(pause_overlap),
        "debugElapsedMinusTimerSeconds": rounded(max_timer_row.get("elapsedMinusTimerSeconds")),
        "pauseDriftMatchesScreenshot": (
            screenshot_delta is not None
            and total_paired_pause is not None
            and abs(screenshot_delta - total_paired_pause) <= TIME_TOLERANCE_SECONDS
        ),
        "timerDriftClassification": (timer_row or {}).get("driftClassification"),
    }


def decision_for(row: dict[str, Any]) -> str:
    candidate = row["candidateComparison"]
    planned = row["plannedRows"]
    pause = row["pauseDrift"]
    tail = row["openTail"]
    if row["gateBFound"] is False:
        return "missing_gate_b_debug_evidence"
    if tail["appleShowsOpenTail"] and not tail["supportsOpenTailRule"]:
        return "open_tail_needs_rule"
    if pause["screenshotElapsedMinusWorkoutSeconds"] is not None and pause["debugTotalPairedPauseSeconds"] is None:
        if tail["supportsOpenTailRule"]:
            return "open_tail_supported_pause_debug_missing"
        return "pause_debug_evidence_missing"
    if pause["screenshotElapsedMinusWorkoutSeconds"] is not None and not pause["pauseDriftMatchesScreenshot"]:
        return "pause_drift_needs_review"
    if tail["supportsOpenTailRule"] and planned["countMatches"] and planned["labelMismatches"] == 0:
        if candidate["withinTolerance"]:
            return "open_tail_screenshot_supported"
        return "open_tail_supported_metric_drift_needs_review"
    if planned["countMatches"] and planned["labelMismatches"] == 0 and candidate["withinTolerance"]:
        return "screenshot_candidate_supported"
    if planned["countMatches"] and planned["labelMismatches"] == 0:
        return "structure_supported_metric_drift_needs_review"
    return "structure_mismatch_needs_review"


def build_scorecard() -> dict[str, Any]:
    fixtures = load_json(FIXTURE)
    gate_b = load_json(GATE_B)
    timer = load_json(TIMER_DRIFT)
    gate_by_start = {row["startDate"]: row for row in gate_b.get("workouts", [])}
    timer_by_start = {row["startDate"]: row for row in timer.get("rows", [])}
    rows: list[dict[str, Any]] = []

    for fixture in fixtures["workouts"]:
        start = fixture["startDate"]
        gate_row = gate_by_start.get(start)
        apple_rows = fixture["rows"]
        row = {
            "startDate": start,
            "localDateLabel": fixture["localDateLabel"],
            "fixtureClass": fixture["fixtureClass"],
            "screenshotFiles": fixture["screenshotFiles"],
            "screenshotFinding": fixture["screenshotFinding"],
            "gateBFound": gate_row is not None,
            "plannedRows": planned_label_check(apple_rows, (gate_row or {}).get("workoutKitPlannedRows", [])),
            "currentComparison": compare_rows(apple_rows, (gate_row or {}).get("runSignalCurrentRows", [])),
            "candidateComparison": compare_rows(apple_rows, (gate_row or {}).get("hkWorkoutActivityCandidateRows", [])),
            "fitLapComparison": compare_rows(apple_rows, (gate_row or {}).get("fitLapRows", [])),
            "openTail": open_tail_check(apple_rows, gate_row),
            "pauseDrift": pause_check(fixture, timer_by_start.get(start)),
            "rawHealthKitWorkoutEventEvidence": {
                "availableInTimerDriftScorecard": start in timer_by_start,
                "pauseResumeMarkerCount": (timer_by_start.get(start) or {}).get("pauseResumeMarkerCount"),
                "pairedPauseIntervalCount": (timer_by_start.get(start) or {}).get("pairedPauseIntervalCount"),
            },
            "fitEvidence": {
                "fitFileFound": (gate_row or {}).get("fitFileFound"),
                "fitFilename": (gate_row or {}).get("fitFilename"),
                "fitLapCount": ((gate_row or {}).get("scores") or {}).get("fitLapCount"),
                "fitWorkoutStepCount": ((gate_row or {}).get("scores") or {}).get("fitWorkoutStepCount"),
            },
        }
        row["decision"] = decision_for(row)
        rows.append(row)

    return {
        "generatedAt": generated_at(),
        "fixtureSource": FIXTURE.name,
        "gateBSource": GATE_B.name,
        "timerDriftSource": TIMER_DRIFT.name,
        "status": "docs/debug screenshot-confirmed scorecard",
        "runtimeUseAllowed": False,
        "fitRuntimeUseAllowed": False,
        "productionBehaviorChanged": False,
        "normalWorkoutUIChanged": False,
        "hkWorkoutActivityPromoted": False,
        "phase3Implemented": False,
        "summary": {
            "workoutCount": len(rows),
            "decisionCounts": dict(Counter(row["decision"] for row in rows)),
            "appleExpandedRepeatBlockCount": sum(
                1 for row in rows if row["fixtureClass"] in {
                    "paused_repeat_block",
                    "clean_repeat_block",
                    "repeat_block_fixed_cooldown_open_tail",
                }
            ),
            "plannedRowsIncludeRepeatExpansionCount": sum(
                1 for row in rows if row["plannedRows"]["plannedRowsIncludeRepeatExpansion"]
            ),
            "appleOpenTailCount": sum(1 for row in rows if row["openTail"]["appleShowsOpenTail"]),
            "pauseDriftScreenshotCount": sum(
                1 for row in rows if row["pauseDrift"]["screenshotElapsedMinusWorkoutSeconds"] is not None
            ),
            "pauseDriftMatchesScreenshotCount": sum(
                1 for row in rows if row["pauseDrift"]["pauseDriftMatchesScreenshot"]
            ),
        },
        "rulesSupportedByScreenshots": [
            "Apple Fitness presents expanded Work/Recovery rows for repeat blocks.",
            "Apple Fitness labels post-fixed-step residual movement as Open when fixed planned steps are exhausted.",
            "Apple Fitness overview distinguishes workout time from elapsed time for paused workouts.",
            "Paused row duration must be checked against active timer time and cannot be collapsed to wall-clock elapsed time.",
        ],
        "rows": rows,
        "noProductionChangeStatement": (
            "This scorecard is docs/debug validation only. It does not change Swift, "
            "production interval behavior, normal workout UI, HKWorkoutActivity promotion, "
            "FIT import/runtime usage, HealthFit dependency status, or Phase 3 implementation."
        ),
    }


def fmt_bool(value: Any) -> str:
    return "yes" if value else "no"


def fmt_seconds(value: Any) -> str:
    return "n/a" if value is None else f"{float(value):.1f}s"


def fmt_meters(value: Any) -> str:
    return "n/a" if value is None else f"{float(value):.1f}m"


def md_table(rows: list[list[Any]]) -> str:
    return "\n".join("| " + " | ".join(str(cell) for cell in row) + " |" for row in rows)


def write_markdown(report: dict[str, Any]) -> None:
    table = [
        [
            "Start",
            "Class",
            "Rows Apple/Plan/Candidate/FIT",
            "Candidate max dt/dd",
            "Open tail",
            "Pause screenshot/debug",
            "Decision",
        ],
        ["---", "---", "---:", "---:", "---", "---", "---"],
    ]
    for row in report["rows"]:
        candidate = row["candidateComparison"]
        planned = row["plannedRows"]
        fit = row["fitLapComparison"]
        pause = row["pauseDrift"]
        table.append(
            [
                row["startDate"],
                row["fixtureClass"],
                f"{candidate['appleRowCount']}/{planned['plannedRowCount']}/{candidate['sourceRowCount']}/{fit['sourceRowCount']}",
                f"{fmt_seconds(candidate['maxDurationDeltaSeconds'])} / {fmt_meters(candidate['maxDistanceDeltaMeters'])}",
                fmt_bool(row["openTail"]["appleShowsOpenTail"]),
                f"{fmt_seconds(pause['screenshotElapsedMinusWorkoutSeconds'])} / {fmt_seconds(pause['debugTotalPairedPauseSeconds'])}",
                row["decision"],
            ]
        )

    lines = [
        "# Apple Fitness Screenshot-Confirmed Custom Workout Scorecard",
        "",
        f"Generated: {report['generatedAt']}",
        "",
        "This scorecard compares manually typed Apple Fitness screenshot rows against existing docs/debug evidence: RunSignal current rows, `HKWorkoutActivity` candidate rows, WorkoutKit planned rows, FIT lap rows, and pause-drift evidence.",
        "",
        "It is validation-only. Screenshots and FIT are not runtime inputs, and this does not approve production interval reconstruction.",
        "",
        "## Summary",
        "",
        md_table(
            [
                ["Metric", "Value"],
                ["---", "---:"],
                ["Screenshot fixture workouts", report["summary"]["workoutCount"]],
                ["Apple expanded repeat-block examples", report["summary"]["appleExpandedRepeatBlockCount"]],
                ["WorkoutKit planned rows with repeat expansion", report["summary"]["plannedRowsIncludeRepeatExpansionCount"]],
                ["Apple Open-tail examples", report["summary"]["appleOpenTailCount"]],
                ["Pause-drift screenshots", report["summary"]["pauseDriftScreenshotCount"]],
                ["Pause-drift screenshot/debug matches", report["summary"]["pauseDriftMatchesScreenshotCount"]],
            ]
        ),
        "",
        "## Decision Counts",
        "",
        md_table(
            [["Decision", "Count"], ["---", "---:"]]
            + [[decision, count] for decision, count in sorted(report["summary"]["decisionCounts"].items())]
        ),
        "",
        "## Workout Rows",
        "",
        md_table(table),
        "",
        "## Screenshot-Supported Rules",
        "",
    ]
    lines.extend(f"- {rule}" for rule in report["rulesSupportedByScreenshots"])
    lines.extend(
        [
            "",
            "## Recommendation",
            "",
            "Keep this as a debug-only validation fixture. The next implementation discussion should use these screenshot-confirmed rows plus parity packets/monthly diagnostics to score any proposed rule before touching the normal workout UI.",
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
