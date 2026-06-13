#!/usr/bin/env python3
"""Score Gate B custom workouts against the FIT reference rollup.

This is docs-only/offline validation. It reads the existing March-June FIT
reference rollup and writes a custom-workout scorecard. It does not read FIT
files at runtime and does not change app behavior.
"""

from __future__ import annotations

import json
from collections import Counter
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parent
FIT_ROLLUP = ROOT / "fit-reference-rollup-2026-03-to-2026-06.json"
JSON_REPORT = ROOT / "gate-b-custom-workout-fit-scorecard-2026-03-to-2026-06.json"
MARKDOWN_REPORT = ROOT / "gate-b-custom-workout-fit-scorecard-2026-03-to-2026-06.md"

MATERIAL_DISTANCE_METERS = 10.0
MATERIAL_TIME_SECONDS = 5.0


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def is_gate_b(row: dict[str, Any]) -> bool:
    return row.get("_group") == "structuredAndSpecialWorkouts"


def class_key(row: dict[str, Any]) -> str:
    classification = row.get("classification")
    if classification == "structured interval workout":
        return "structured_interval"
    if classification == "warmup/work/cooldown special":
        return "warmup_work_cooldown"
    return "unknown_gate_b"


def material_shift(row: dict[str, Any]) -> bool:
    if row.get("currentRowCount") != row.get("candidateRowCount"):
        return True
    for key in (
        "workDeltaDistanceMeters",
        "workDeltaDurationSeconds",
        "workDeltaEndOffsetSeconds",
        "openDeltaDistanceMeters",
        "openDeltaDurationSeconds",
        "openDeltaEndOffsetSeconds",
    ):
        value = row.get(key)
        if value is None:
            continue
        threshold = MATERIAL_DISTANCE_METERS if "Distance" in key else MATERIAL_TIME_SECONDS
        if abs(float(value)) > threshold:
            return True
    return False


def has_open_tail(row: dict[str, Any]) -> bool:
    return (
        row.get("candidateOpenDistanceMeters") is not None
        or row.get("currentOpenDistanceMeters") is not None
        or row.get("candidateRowCount", 0) > row.get("plannedStepCount", 0)
        or row.get("currentRowCount", 0) > row.get("plannedStepCount", 0)
    )


def row_decision(row: dict[str, Any]) -> str:
    # The rollup does not yet include Gate B row-level FIT label/error support.
    # Equivalent here means current and candidate are not materially different,
    # not that either is production-approved.
    return "inconclusive" if material_shift(row) else "equivalent"


def summarize(rows: list[dict[str, Any]], key: str) -> dict[str, Any]:
    subset = [row for row in rows if class_key(row) == key]
    decisions = Counter(row_decision(row) for row in subset)
    fit_lap_activity_matches = sum(
        1 for row in subset if row.get("fitLapCount") == row.get("activityCount")
    )
    activity_plan_matches = sum(
        1 for row in subset if row.get("activityCount") == row.get("plannedStepCount")
    )
    fit_step_plan_matches = sum(
        1 for row in subset if row.get("fitWorkoutStepCount") == row.get("plannedStepCount")
    )
    open_tail_rows = [row for row in subset if has_open_tail(row)]
    repeat_like_rows = [
        row
        for row in subset
        if row.get("fitWorkoutStepCount") != row.get("plannedStepCount")
        or row.get("plannedStepCount", 0) > row.get("fitWorkoutStepCount", 0)
    ]
    material_rows = [row for row in subset if material_shift(row)]

    return {
        "total": len(subset),
        "fitMatchedCount": len(subset),
        "activityPlannedCountAlignment": activity_plan_matches,
        "fitLapActivityCountAlignment": fit_lap_activity_matches,
        "fitWorkoutStepPlannedCountAlignment": fit_step_plan_matches,
        "fitLapCounts": dict(sorted(Counter(row.get("fitLapCount") for row in subset).items())),
        "fitWorkoutStepCounts": dict(
            sorted(Counter(row.get("fitWorkoutStepCount") for row in subset).items())
        ),
        "plannedStepCounts": dict(
            sorted(Counter(row.get("plannedStepCount") for row in subset).items())
        ),
        "currentCandidateRowCountPairs": {
            f"{left}->{right}": count
            for (left, right), count in sorted(
                Counter(
                    (row.get("currentRowCount"), row.get("candidateRowCount"))
                    for row in subset
                ).items()
            )
        },
        "candidateBetterCount": decisions.get("candidate_better", 0),
        "currentBetterCount": decisions.get("current_better", 0),
        "equivalentCount": decisions.get("equivalent", 0),
        "inconclusiveCount": decisions.get("inconclusive", 0),
        "materialRowShiftCount": len(material_rows),
        "openExtraTailCount": len(open_tail_rows),
        "repeatBlockNeedsRuleCount": len(repeat_like_rows),
        "labelMappingNeedsRuleCount": len(subset),
        "decision": "blocked_pending_gate_b_row_level_fit_scoring",
    }


def compact_row(row: dict[str, Any]) -> dict[str, Any]:
    return {
        "workoutID": row.get("workoutID"),
        "month": row.get("month"),
        "startDate": row.get("startDate"),
        "classification": row.get("classification"),
        "goal": row.get("goal"),
        "fitFilename": row.get("fitFilename"),
        "activityCount": row.get("activityCount"),
        "plannedStepCount": row.get("plannedStepCount"),
        "fitLapCount": row.get("fitLapCount"),
        "fitWorkoutStepCount": row.get("fitWorkoutStepCount"),
        "currentRowCount": row.get("currentRowCount"),
        "candidateRowCount": row.get("candidateRowCount"),
        "hasOpenExtraTail": has_open_tail(row),
        "materialRowShift": material_shift(row),
        "comparisonDecision": row_decision(row),
        "workDeltaDistanceMeters": row.get("workDeltaDistanceMeters"),
        "workDeltaDurationSeconds": row.get("workDeltaDurationSeconds"),
        "openDeltaDistanceMeters": row.get("openDeltaDistanceMeters"),
        "openDeltaDurationSeconds": row.get("openDeltaDurationSeconds"),
    }


def build_scorecard() -> dict[str, Any]:
    data = load_json(FIT_ROLLUP)
    rows = [row for row in data.get("matches", []) if is_gate_b(row)]
    structured = [row for row in rows if class_key(row) == "structured_interval"]
    warmup = [row for row in rows if class_key(row) == "warmup_work_cooldown"]
    open_tail_rows = [row for row in rows if has_open_tail(row)]
    repeat_rows = [
        row
        for row in rows
        if row.get("fitWorkoutStepCount") != row.get("plannedStepCount")
        or row.get("plannedStepCount", 0) > row.get("fitWorkoutStepCount", 0)
    ]
    material_rows = [row for row in rows if material_shift(row)]

    return {
        "generatedAt": data.get("summary", {}).get("generatedAt"),
        "source": str(FIT_ROLLUP.name),
        "runtimeSource": "HealthKit/WorkoutKit",
        "validationOracle": "FIT offline reference",
        "fitRuntimeUseAllowed": False,
        "productionBehaviorChanged": False,
        "swiftSourceChanged": False,
        "gateBTotal": len(rows),
        "structuredIntervalFindings": summarize(rows, "structured_interval"),
        "warmupWorkCooldownFindings": summarize(rows, "warmup_work_cooldown"),
        "comparisonSummary": {
            "candidateBetterCount": 0,
            "currentBetterCount": 0,
            "equivalentCount": sum(1 for row in rows if row_decision(row) == "equivalent"),
            "inconclusiveCount": sum(1 for row in rows if row_decision(row) == "inconclusive"),
            "reason": "Gate B rollup has count/tail/current-vs-candidate deltas, but not full row-level FIT label/error extraction.",
        },
        "openExtraTailFindings": {
            "totalWithOpenExtraTail": len(open_tail_rows),
            "structuredIntervalWithOpenExtraTail": sum(1 for row in structured if has_open_tail(row)),
            "warmupWorkCooldownWithOpenExtraTail": sum(1 for row in warmup if has_open_tail(row)),
            "needsRule": True,
            "ruleNeeded": "Detect Open/Extra only after planned steps are exhausted, preserve cooldown labels, and avoid folding extra tail into the final planned step.",
            "rows": [compact_row(row) for row in open_tail_rows],
        },
        "repeatBlockFindings": {
            "repeatBlockNeedsRule": True,
            "rowsWhereFitWorkoutStepCountDiffersFromExpandedPlan": len(repeat_rows),
            "structuredRowsWhereFitWorkoutStepCountDiffersFromExpandedPlan": sum(
                1 for row in structured if row in repeat_rows
            ),
            "warmupRowsWhereFitWorkoutStepCountDiffersFromExpandedPlan": sum(
                1 for row in warmup if row in repeat_rows
            ),
            "ruleNeeded": "Use WorkoutKit expanded planned steps for row order; use FIT workout steps only as unexpanded-plan reference evidence.",
        },
        "labelMappingFindings": {
            "labelMappingNeedsRule": True,
            "rowsNeedingLabelMappingRule": len(rows),
            "ruleNeeded": "Map labels from WorkoutKit planned step order, including Warmup, Work, Recovery, Cooldown, Open, and Extra; do not infer production labels from FIT at runtime.",
        },
        "safeSubclasses": [],
        "promisingButBlockedSubclasses": [
            {
                "shape": "structured intervals with activityCount == plannedStepCount == FIT lap count and no material current/candidate shift",
                "count": sum(
                    1
                    for row in structured
                    if row.get("activityCount") == row.get("plannedStepCount")
                    and row.get("fitLapCount") == row.get("activityCount")
                    and not material_shift(row)
                ),
                "blockedReason": "needs row-level FIT label/error extraction and repeat-block label rules",
            },
            {
                "shape": "three-step warmup/work/cooldown with activityCount == plannedStepCount == FIT lap count and no Open/Extra tail",
                "count": sum(
                    1
                    for row in warmup
                    if row.get("activityCount") == row.get("plannedStepCount")
                    and row.get("fitLapCount") == row.get("activityCount")
                    and not has_open_tail(row)
                    and not material_shift(row)
                ),
                "blockedReason": "needs label mapping proof for Warmup, Work, and Cooldown",
            },
        ],
        "blockedSubclasses": [
            "structured_interval_repeat_blocks",
            "structured_interval_work_recovery_mapping",
            "warmup_work_cooldown_label_mapping",
            "warmup_work_cooldown_open_or_extra_tail_after_cooldown",
            "any_gate_b_case_without_row_level_fit_label_error_extraction",
        ],
        "gateBDecision": {
            "supportsAnyFuturePrototype": True,
            "futurePrototypeScope": "debug-only Gate B scorer/prototype may be useful for class-specific validation",
            "approvesProductionPromotion": False,
            "approvesSwiftPrototypeNow": False,
            "reason": "Counts align strongly, but row-level FIT label/error extraction is not available yet for Gate B.",
        },
        "materialRows": [compact_row(row) for row in material_rows],
        "workouts": [compact_row(row) for row in rows],
    }


def md_table(rows: list[list[Any]]) -> str:
    return "\n".join("| " + " | ".join(str(cell) for cell in row) + " |" for row in rows)


def write_markdown(scorecard: dict[str, Any]) -> None:
    structured = scorecard["structuredIntervalFindings"]
    warmup = scorecard["warmupWorkCooldownFindings"]
    comparison = scorecard["comparisonSummary"]
    open_tail = scorecard["openExtraTailFindings"]
    repeat = scorecard["repeatBlockFindings"]
    labels = scorecard["labelMappingFindings"]

    lines = [
        "# Gate B Custom Workout FIT Scorecard: March-June 2026",
        "",
        f"Generated: {scorecard['generatedAt']}",
        "",
        "## Executive Summary",
        "",
        "Gate B remains blocked for production and for Swift implementation. FIT matching shows strong count alignment for structured intervals and warmup/work/cooldown specials, but the current FIT rollup does not yet extract full row-level label/error evidence for custom multi-step workouts.",
        "",
        "FIT remains an offline validation oracle only. HealthKit/WorkoutKit remains the runtime source.",
        "",
        "## Class Findings",
        "",
        md_table(
            [
                [
                    "Class",
                    "Total",
                    "FIT matched",
                    "activity==planned",
                    "FIT lap==activity",
                    "FIT step==planned",
                    "Equivalent",
                    "Inconclusive",
                    "Decision",
                ],
                ["---", "---:", "---:", "---:", "---:", "---:", "---:", "---:", "---"],
                [
                    "Structured interval",
                    structured["total"],
                    structured["fitMatchedCount"],
                    structured["activityPlannedCountAlignment"],
                    structured["fitLapActivityCountAlignment"],
                    structured["fitWorkoutStepPlannedCountAlignment"],
                    structured["equivalentCount"],
                    structured["inconclusiveCount"],
                    "Blocked pending row-level FIT labels/errors",
                ],
                [
                    "Warmup/work/cooldown",
                    warmup["total"],
                    warmup["fitMatchedCount"],
                    warmup["activityPlannedCountAlignment"],
                    warmup["fitLapActivityCountAlignment"],
                    warmup["fitWorkoutStepPlannedCountAlignment"],
                    warmup["equivalentCount"],
                    warmup["inconclusiveCount"],
                    "Blocked pending label/tail rules",
                ],
            ]
        ),
        "",
        "## Candidate vs Current",
        "",
        md_table(
            [
                ["Candidate better", "Current better", "Equivalent", "Inconclusive"],
                ["---:", "---:", "---:", "---:"],
                [
                    comparison["candidateBetterCount"],
                    comparison["currentBetterCount"],
                    comparison["equivalentCount"],
                    comparison["inconclusiveCount"],
                ],
            ]
        ),
        "",
        "Equivalent means current and candidate are not materially different in the current rollup. It does not mean production approval.",
        "",
        "## Open / Extra Tail Findings",
        "",
        f"- Gate B rows with Open/Extra tail evidence: {open_tail['totalWithOpenExtraTail']}",
        f"- Structured interval rows with Open/Extra tail evidence: {open_tail['structuredIntervalWithOpenExtraTail']}",
        f"- Warmup/work/cooldown rows with Open/Extra tail evidence: {open_tail['warmupWorkCooldownWithOpenExtraTail']}",
        f"- Rule needed: {open_tail['ruleNeeded']}",
        "",
        "## Repeat Block Findings",
        "",
        f"- Rows where FIT workout-step count differs from expanded planned steps: {repeat['rowsWhereFitWorkoutStepCountDiffersFromExpandedPlan']}",
        f"- Structured rows with this mismatch: {repeat['structuredRowsWhereFitWorkoutStepCountDiffersFromExpandedPlan']}",
        f"- Warmup/work/cooldown rows with this mismatch: {repeat['warmupRowsWhereFitWorkoutStepCountDiffersFromExpandedPlan']}",
        f"- Rule needed: {repeat['ruleNeeded']}",
        "",
        "## Label Mapping Findings",
        "",
        f"- Rows needing a label mapping rule: {labels['rowsNeedingLabelMappingRule']}",
        f"- Rule needed: {labels['ruleNeeded']}",
        "",
        "## Safe Subclasses",
        "",
        "None approved yet.",
        "",
        "## Promising But Blocked Subclasses",
        "",
        md_table(
            [
                ["Shape", "Count", "Blocked reason"],
                ["---", "---:", "---"],
                *[
                    [item["shape"], item["count"], item["blockedReason"]]
                    for item in scorecard["promisingButBlockedSubclasses"]
                ],
            ]
        ),
        "",
        "## Blocked Subclasses",
        "",
        *[f"- `{item}`" for item in scorecard["blockedSubclasses"]],
        "",
        "## Recommendation",
        "",
        "- Do not approve Gate B production promotion.",
        "- Do not implement a Gate B Swift prototype yet.",
        "- Next Gate B work should extract row-level FIT lap labels/timing/distance and compare them to current and candidate rows.",
        "- Gate A must remain separate and must not approve structured or warmup/work/cooldown workouts.",
    ]
    MARKDOWN_REPORT.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    scorecard = build_scorecard()
    JSON_REPORT.write_text(json.dumps(scorecard, indent=2), encoding="utf-8")
    write_markdown(scorecard)
    print(f"Wrote {JSON_REPORT.name}")
    print(f"Wrote {MARKDOWN_REPORT.name}")
    print("Gate B remains blocked pending row-level FIT label/error extraction.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
