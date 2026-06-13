#!/usr/bin/env python3
"""Build focused Gate B evidence scorecards from the row-level FIT artifact.

This is docs-only/offline validation. It reads the existing Gate B row-level
scorecard and writes derived evidence reports for repeat blocks, Open/Extra
tails, and the narrow warmup/work/open-cooldown candidate class. It does not
change app runtime behavior and does not make FIT a runtime dependency.
"""

from __future__ import annotations

import json
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parent
SOURCE = ROOT / "gate-b-row-level-fit-boundary-scorecard-2026-03-to-2026-06.json"

REPEAT_JSON = ROOT / "gate-b-repeat-block-evidence-2026-03-to-2026-06.json"
REPEAT_MD = ROOT / "gate-b-repeat-block-evidence-2026-03-to-2026-06.md"
TAIL_JSON = ROOT / "gate-b-open-tail-evidence-2026-03-to-2026-06.json"
TAIL_MD = ROOT / "gate-b-open-tail-evidence-2026-03-to-2026-06.md"
CANDIDATE_JSON = ROOT / "gate-b-narrow-warmup-work-cooldown-candidate-scorecard-2026-03-to-2026-06.json"
CANDIDATE_MD = ROOT / "gate-b-narrow-warmup-work-cooldown-candidate-scorecard-2026-03-to-2026-06.md"

TIME_TOLERANCE_SECONDS = 5.0
DISTANCE_TOLERANCE_METERS = 10.0
MATERIAL_TAIL_DISTANCE_METERS = 25.0
MATERIAL_TAIL_TIME_SECONDS = 10.0


def load_source() -> dict[str, Any]:
    return json.loads(SOURCE.read_text(encoding="utf-8"))


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


def fmt_seconds(value: Any) -> str:
    return "n/a" if value is None else f"{float(value):.1f}s"


def fmt_meters(value: Any) -> str:
    return "n/a" if value is None else f"{float(value):.1f}m"


def md_table(rows: list[list[Any]]) -> str:
    return "\n".join("| " + " | ".join(str(cell) for cell in row) + " |" for row in rows)


def shape(workout: dict[str, Any]) -> str:
    parts = []
    for row in workout.get("workoutKitPlannedRows", []):
        label = row.get("label") or "Unknown"
        goal = row.get("goal") or "Unavailable"
        parts.append(f"{label}({goal})")
    return " > ".join(parts)


def source_counts(workout: dict[str, Any]) -> str:
    scores = workout["scores"]
    return (
        f"{scores['currentRowCount']}/{scores['candidateRowCount']}/"
        f"{scores['fitLapCount']}/{scores['plannedStepCount']}/"
        f"{scores['fitWorkoutStepCount']}"
    )


def max_errors(workout: dict[str, Any], prefix: str) -> tuple[float | None, float | None]:
    scores = workout["scores"]
    return (
        numeric(scores.get(f"max{prefix}TimingErrorVsFITLapsSeconds")),
        numeric(scores.get(f"max{prefix}DistanceErrorVsFITLapsMeters")),
    )


def candidate_within_tolerance(workout: dict[str, Any]) -> bool:
    time_error, distance_error = max_errors(workout, "Candidate")
    labels = workout["scores"]["labelMappingCorrectness"]
    return (
        time_error is not None
        and distance_error is not None
        and time_error <= TIME_TOLERANCE_SECONDS
        and distance_error <= DISTANCE_TOLERANCE_METERS
        and labels.get("candidateMismatches") == 0
    )


def current_within_tolerance(workout: dict[str, Any]) -> bool:
    time_error, distance_error = max_errors(workout, "Current")
    labels = workout["scores"]["labelMappingCorrectness"]
    return (
        time_error is not None
        and distance_error is not None
        and time_error <= TIME_TOLERANCE_SECONDS
        and distance_error <= DISTANCE_TOLERANCE_METERS
        and labels.get("currentMismatches") == 0
    )


def candidate_better_distance_but_worse_time(workout: dict[str, Any]) -> bool:
    current_time, current_distance = max_errors(workout, "Current")
    candidate_time, candidate_distance = max_errors(workout, "Candidate")
    if None in {current_time, current_distance, candidate_time, candidate_distance}:
        return False
    return candidate_distance < current_distance and candidate_time > current_time


def tail(workout: dict[str, Any]) -> dict[str, Any] | None:
    return workout["scores"]["openExtraTailHandling"].get("fitInferredTail")


def final_plan_row(workout: dict[str, Any]) -> dict[str, Any] | None:
    rows = workout.get("workoutKitPlannedRows", [])
    return rows[-1] if rows else None


def final_step_description(workout: dict[str, Any]) -> str:
    row = final_plan_row(workout)
    if not row:
        return "missing"
    role = row.get("stepType") or row.get("label") or "unknown"
    goal_type = row.get("goalType") or "unknown"
    goal = row.get("goal") or "unavailable"
    return f"{role}/{goal_type}/{goal}"


def final_step_is_open_cooldown(workout: dict[str, Any]) -> bool:
    row = final_plan_row(workout) or {}
    return row.get("stepType") == "cooldown" and row.get("goalType") == "open"


def tail_materiality(tail_row: dict[str, Any] | None) -> str:
    if not tail_row:
        return "none"
    distance = numeric(tail_row.get("distanceMeters")) or 0.0
    duration = numeric(tail_row.get("durationSeconds")) or 0.0
    if distance >= MATERIAL_TAIL_DISTANCE_METERS or duration >= MATERIAL_TAIL_TIME_SECONDS:
        return "material"
    return "tiny-session-minus-lap-residual"


def has_explicit_tail_lap(workout: dict[str, Any]) -> bool:
    return len(workout.get("fitLapRows", [])) > len(workout.get("workoutKitPlannedRows", []))


def fixed_steps_exhausted(workout: dict[str, Any]) -> bool:
    plan_rows = workout.get("workoutKitPlannedRows", [])
    if not plan_rows:
        return False
    if final_step_is_open_cooldown(workout):
        return False
    return candidate_within_tolerance(workout) or current_within_tolerance(workout)


def tail_classification(workout: dict[str, Any]) -> str:
    if not tail(workout):
        return "no_tail_evidence"
    if final_step_is_open_cooldown(workout):
        return "open_cooldown_absorbs_tail_residual"
    if not fixed_steps_exhausted(workout):
        return "ambiguous_fixed_step_exhaustion"
    if has_explicit_tail_lap(workout):
        return "explicit_tail_lap_candidate"
    if tail_materiality(tail(workout)) == "material":
        return "session_minus_lap_tail_candidate"
    return "tiny_residual_do_not_classify"


def repeat_evidence(source: dict[str, Any]) -> dict[str, Any]:
    workouts = [
        workout
        for workout in source["workouts"]
        if workout["scores"]["classification"] == "repeat_block_needs_rule"
        if workout["scores"]["repeatBlockExpansionCorrectness"]["expandedPlanHasRepeatRows"]
        and workout["scores"]["fitWorkoutStepCount"] < workout["scores"]["plannedStepCount"]
    ]
    rows = []
    for workout in workouts:
        rows.append(
            {
                "startDate": workout["startDate"],
                "classification": workout["classification"],
                "shape": shape(workout),
                "rowsCurrentCandidateFitPlanFitStep": source_counts(workout),
                "fitWorkoutStepsAreUnexpanded": True,
                "candidateWithinTolerance": candidate_within_tolerance(workout),
                "currentWithinTolerance": current_within_tolerance(workout),
                "candidateBetterDistanceButWorseTime": candidate_better_distance_but_worse_time(workout),
                "maxCurrentTimingErrorSeconds": workout["scores"]["maxCurrentTimingErrorVsFITLapsSeconds"],
                "maxCurrentDistanceErrorMeters": workout["scores"]["maxCurrentDistanceErrorVsFITLapsMeters"],
                "maxCandidateTimingErrorSeconds": workout["scores"]["maxCandidateTimingErrorVsFITLapsSeconds"],
                "maxCandidateDistanceErrorMeters": workout["scores"]["maxCandidateDistanceErrorVsFITLapsMeters"],
                "fitInferredTail": tail(workout),
                "decision": (
                    "close_but_repeat_rule_required"
                    if candidate_within_tolerance(workout)
                    else "excluded_until_timing_or_distance_drift_explained"
                ),
            }
        )
    return {
        "generatedAt": generated_at(),
        "source": SOURCE.name,
        "runtimeSource": "HealthKit/WorkoutKit only",
        "validationOracle": "FIT offline reference only",
        "fitRuntimeUseAllowed": False,
        "productionBehaviorChanged": False,
        "summary": {
            "repeatBlockRows": len(rows),
            "candidateWithinTolerance": sum(1 for row in rows if row["candidateWithinTolerance"]),
            "candidateDistanceCloserButTimeWorse": sum(
                1 for row in rows if row["candidateBetterDistanceButWorseTime"]
            ),
            "decisionCounts": dict(Counter(row["decision"] for row in rows)),
        },
        "ruleNeeded": [
            "Use expanded WorkoutKit planned rows as label/order source.",
            "Treat FIT workout_step rows as unexpanded planned-structure evidence.",
            "Compare FIT laps against expanded planned rows.",
            "Require row-level timing, distance, and label tolerance before support.",
            "Fallback on missing activities, count mismatch, non-contiguity, tail ambiguity, or high row error.",
        ],
        "rows": rows,
    }


def tail_evidence(source: dict[str, Any]) -> dict[str, Any]:
    workouts = [
        workout
        for workout in source["workouts"]
        if workout["scores"]["classification"] == "open_tail_needs_rule"
        or (
            tail(workout)
            and workout["scores"]["candidateRowCount"] != workout["scores"]["fitLapCount"]
        )
    ]
    rows = []
    for workout in workouts:
        tail_row = tail(workout)
        rows.append(
            {
                "startDate": workout["startDate"],
                "classification": workout["classification"],
                "shape": shape(workout),
                "rowsCurrentCandidateFitPlanFitStep": source_counts(workout),
                "finalPlannedStep": final_step_description(workout),
                "finalCooldownOpen": final_step_is_open_cooldown(workout),
                "fixedPlannedStepsExhausted": fixed_steps_exhausted(workout),
                "fitHasExplicitTailLap": has_explicit_tail_lap(workout),
                "fitTailEvidenceSource": tail_row.get("source") if tail_row else None,
                "fitTailDistanceMeters": tail_row.get("distanceMeters") if tail_row else None,
                "fitTailDurationSeconds": tail_row.get("durationSeconds") if tail_row else None,
                "tailMateriality": tail_materiality(tail_row),
                "candidateWithinToleranceForPlannedRows": candidate_within_tolerance(workout),
                "tailClassification": tail_classification(workout),
            }
        )
    return {
        "generatedAt": generated_at(),
        "source": SOURCE.name,
        "runtimeSource": "HealthKit/WorkoutKit only",
        "validationOracle": "FIT offline reference only",
        "fitRuntimeUseAllowed": False,
        "productionBehaviorChanged": False,
        "summary": {
            "tailRows": len(rows),
            "explicitTailLapRows": sum(1 for row in rows if row["fitHasExplicitTailLap"]),
            "sessionMinusLapOnlyRows": sum(
                1 for row in rows if row["fitTailEvidenceSource"] == "FIT session minus lap sum"
            ),
            "classificationCounts": dict(Counter(row["tailClassification"] for row in rows)),
        },
        "ruleNeeded": [
            "Classify tail only after fixed planned steps are exhausted.",
            "Keep final open cooldown labeled Cooldown through workout end.",
            "Use session-minus-lap tail evidence only for offline validation when FIT lacks an explicit tail lap.",
            "Fallback when fixed-step exhaustion or FIT session totals are internally ambiguous.",
        ],
        "rows": rows,
    }


def is_exact_narrow_candidate_shape(workout: dict[str, Any]) -> bool:
    plan_rows = workout.get("workoutKitPlannedRows", [])
    if workout["classification"] != "warmup/work/cooldown special":
        return False
    if len(plan_rows) != 3:
        return False
    roles = [row.get("stepType") for row in plan_rows]
    if roles != ["warmup", "work", "cooldown"]:
        return False
    if plan_rows[0].get("goalType") != "distance" or rounded(plan_rows[0].get("goalValue")) != 2000.0:
        return False
    if plan_rows[1].get("goalType") not in {"time", "distance"}:
        return False
    if plan_rows[2].get("goalType") != "open":
        return False
    return True


def candidate_evidence(source: dict[str, Any]) -> dict[str, Any]:
    workouts = [workout for workout in source["workouts"] if is_exact_narrow_candidate_shape(workout)]
    rows = []
    for workout in workouts:
        scores = workout["scores"]
        exact_counts = (
            scores["currentRowCount"] == 3
            and scores["candidateRowCount"] == 3
            and scores["fitLapCount"] == 3
            and scores["plannedStepCount"] == 3
            and scores["fitWorkoutStepCount"] == 3
        )
        no_recovery = all(row.get("stepType") != "recovery" for row in workout["workoutKitPlannedRows"])
        no_fixed_cooldown_tail = final_step_is_open_cooldown(workout)
        support = (
            exact_counts
            and no_recovery
            and no_fixed_cooldown_tail
            and candidate_within_tolerance(workout)
            and scores["classification"] == "candidate_row_level_supported"
        )
        rows.append(
            {
                "startDate": workout["startDate"],
                "shape": shape(workout),
                "rowsCurrentCandidateFitPlanFitStep": source_counts(workout),
                "exactThreeByThreeCounts": exact_counts,
                "noRecoveryRows": no_recovery,
                "openCooldownThroughWorkoutEnd": final_step_is_open_cooldown(workout),
                "candidateWithinTolerance": candidate_within_tolerance(workout),
                "currentWithinTolerance": current_within_tolerance(workout),
                "maxCandidateTimingErrorSeconds": scores["maxCandidateTimingErrorVsFITLapsSeconds"],
                "maxCandidateDistanceErrorMeters": scores["maxCandidateDistanceErrorVsFITLapsMeters"],
                "labelMismatches": scores["labelMappingCorrectness"]["candidateMismatches"],
                "tailClassification": tail_classification(workout),
                "decision": (
                    "narrow_debug_candidate_supported"
                    if support
                    else "excluded_from_narrow_candidate"
                ),
            }
        )
    return {
        "generatedAt": generated_at(),
        "source": SOURCE.name,
        "runtimeSource": "HealthKit/WorkoutKit only",
        "validationOracle": "FIT offline reference only",
        "fitRuntimeUseAllowed": False,
        "productionBehaviorChanged": False,
        "summary": {
            "exactShapeRows": len(rows),
            "supportedRows": sum(
                1 for row in rows if row["decision"] == "narrow_debug_candidate_supported"
            ),
            "excludedRows": sum(
                1 for row in rows if row["decision"] == "excluded_from_narrow_candidate"
            ),
        },
        "requiredChecks": [
            "Warmup fixed 2 km, one Work step fixed time or fixed distance, final Cooldown open.",
            "Exactly 3 planned rows, 3 current rows, 3 activity candidate rows, 3 FIT laps, and 3 FIT workout_step rows.",
            "No recovery rows and no fixed-cooldown tail.",
            "Candidate labels map from expanded WorkoutKit order with zero mismatches.",
            "Candidate timing error <= 5 s and distance error <= 10 m for every row.",
            "Fallback first: missing evidence, ambiguous tail, repeat rows, or row-level drift excludes the workout.",
        ],
        "rows": rows,
    }


def write_repeat_markdown(report: dict[str, Any]) -> None:
    lines = [
        "# Gate B Repeat-Block Evidence: March-June 2026",
        "",
        f"Generated: {report['generatedAt']}",
        "",
        "## Executive Summary",
        "",
        "Repeat-block workouts remain blocked. FIT `workout_step` rows are unexpanded planned-structure evidence, while FIT laps and WorkoutKit planned rows are expanded. Several rows are close, but count alignment and low errors are not enough without an explicit repeat mapping rule.",
        "",
        "FIT remains offline validation only. No production interval behavior, normal workout UI, or runtime data source changed.",
        "",
        "## Summary",
        "",
        md_table(
            [
                ["Metric", "Value"],
                ["---", "---:"],
                ["Repeat-block rows", report["summary"]["repeatBlockRows"]],
                ["Candidate within row tolerance", report["summary"]["candidateWithinTolerance"]],
                [
                    "Candidate distance closer but time worse",
                    report["summary"]["candidateDistanceCloserButTimeWorse"],
                ],
            ]
        ),
        "",
        "## Rule Needed",
        "",
        *[f"- {item}" for item in report["ruleNeeded"]],
        "",
        "## Rows",
        "",
        md_table(
            [
                ["Start", "Rows current/candidate/FIT/plan/FIT step", "Candidate ok", "Current ok", "Candidate worse time", "Current max err", "Candidate max err", "Decision"],
                ["---", "---", "---:", "---:", "---:", "---:", "---:", "---"],
                *[
                    [
                        row["startDate"],
                        row["rowsCurrentCandidateFitPlanFitStep"],
                        row["candidateWithinTolerance"],
                        row["currentWithinTolerance"],
                        row["candidateBetterDistanceButWorseTime"],
                        f"{fmt_seconds(row['maxCurrentTimingErrorSeconds'])} / {fmt_meters(row['maxCurrentDistanceErrorMeters'])}",
                        f"{fmt_seconds(row['maxCandidateTimingErrorSeconds'])} / {fmt_meters(row['maxCandidateDistanceErrorMeters'])}",
                        row["decision"],
                    ]
                    for row in report["rows"]
                ],
            ]
        ),
        "",
        "## No-Production-Change Statement",
        "",
        "This scorecard is docs/debug validation only. It does not approve repeat-block production reconstruction or `HKWorkoutActivity` promotion.",
    ]
    REPEAT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_tail_markdown(report: dict[str, Any]) -> None:
    lines = [
        "# Gate B Open/Extra Tail Evidence: March-June 2026",
        "",
        f"Generated: {report['generatedAt']}",
        "",
        "## Executive Summary",
        "",
        "Open/Extra tail cases remain blocked until the tail rule is explicit. The current evidence uses FIT session-minus-lap residuals, not explicit FIT tail laps, so it can support offline validation but cannot become runtime truth.",
        "",
        "FIT remains offline validation only. No production interval behavior, normal workout UI, or runtime data source changed.",
        "",
        "## Summary",
        "",
        md_table(
            [
                ["Metric", "Value"],
                ["---", "---:"],
                ["Tail rows", report["summary"]["tailRows"]],
                ["Explicit FIT tail lap rows", report["summary"]["explicitTailLapRows"]],
                ["Session-minus-lap only rows", report["summary"]["sessionMinusLapOnlyRows"]],
            ]
        ),
        "",
        "## Classification Counts",
        "",
        md_table(
            [
                ["Classification", "Count"],
                ["---", "---:"],
                *[[key, value] for key, value in report["summary"]["classificationCounts"].items()],
            ]
        ),
        "",
        "## Rule Needed",
        "",
        *[f"- {item}" for item in report["ruleNeeded"]],
        "",
        "## Rows",
        "",
        md_table(
            [
                ["Start", "Final planned step", "Fixed steps exhausted", "Explicit FIT tail lap", "Tail evidence", "Tail", "Decision"],
                ["---", "---", "---:", "---:", "---", "---:", "---"],
                *[
                    [
                        row["startDate"],
                        row["finalPlannedStep"],
                        row["fixedPlannedStepsExhausted"],
                        row["fitHasExplicitTailLap"],
                        row["fitTailEvidenceSource"] or "none",
                        f"{fmt_seconds(row['fitTailDurationSeconds'])} / {fmt_meters(row['fitTailDistanceMeters'])}",
                        row["tailClassification"],
                    ]
                    for row in report["rows"]
                ],
            ]
        ),
        "",
        "## No-Production-Change Statement",
        "",
        "This scorecard is docs/debug validation only. It does not approve Open/Extra tail production reconstruction or `HKWorkoutActivity` promotion.",
    ]
    TAIL_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_candidate_markdown(report: dict[str, Any]) -> None:
    lines = [
        "# Gate B Narrow Warmup/Work/Open-Cooldown Candidate Scorecard: March-June 2026",
        "",
        f"Generated: {report['generatedAt']}",
        "",
        "## Executive Summary",
        "",
        "Only two warmup/work/open-cooldown workouts meet the narrow debug-candidate evidence checks. This supports a future discussion only; it does not approve Phase 3, production interval behavior, normal workout UI changes, or `HKWorkoutActivity` promotion.",
        "",
        "FIT remains offline validation only. Runtime source remains HealthKit/WorkoutKit.",
        "",
        "## Summary",
        "",
        md_table(
            [
                ["Metric", "Value"],
                ["---", "---:"],
                ["Exact shape rows", report["summary"]["exactShapeRows"]],
                ["Supported rows", report["summary"]["supportedRows"]],
                ["Excluded rows", report["summary"]["excludedRows"]],
            ]
        ),
        "",
        "## Required Checks",
        "",
        *[f"- {item}" for item in report["requiredChecks"]],
        "",
        "## Rows",
        "",
        md_table(
            [
                ["Start", "Shape", "Rows current/candidate/FIT/plan/FIT step", "Candidate max err", "Tail class", "Decision"],
                ["---", "---", "---", "---:", "---", "---"],
                *[
                    [
                        row["startDate"],
                        row["shape"],
                        row["rowsCurrentCandidateFitPlanFitStep"],
                        f"{fmt_seconds(row['maxCandidateTimingErrorSeconds'])} / {fmt_meters(row['maxCandidateDistanceErrorMeters'])}",
                        row["tailClassification"],
                        row["decision"],
                    ]
                    for row in report["rows"]
                ],
            ]
        ),
        "",
        "## No-Production-Change Statement",
        "",
        "This scorecard is docs/debug validation only. It identifies a future narrow discussion candidate and does not implement or approve Phase 3.",
    ]
    CANDIDATE_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_json(path: Path, data: dict[str, Any]) -> None:
    path.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")


def main() -> int:
    source = load_source()
    repeat_report = repeat_evidence(source)
    tail_report = tail_evidence(source)
    candidate_report = candidate_evidence(source)

    write_json(REPEAT_JSON, repeat_report)
    write_repeat_markdown(repeat_report)
    write_json(TAIL_JSON, tail_report)
    write_tail_markdown(tail_report)
    write_json(CANDIDATE_JSON, candidate_report)
    write_candidate_markdown(candidate_report)

    print(f"Wrote {REPEAT_JSON.name}")
    print(f"Wrote {REPEAT_MD.name}")
    print(f"Wrote {TAIL_JSON.name}")
    print(f"Wrote {TAIL_MD.name}")
    print(f"Wrote {CANDIDATE_JSON.name}")
    print(f"Wrote {CANDIDATE_MD.name}")
    print("Gate B remains docs/debug-only; no production behavior changed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
