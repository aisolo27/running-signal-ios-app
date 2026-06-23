#!/usr/bin/env python3
"""Build Gate B elapsed-vs-timer drift evidence for known outliers.

This is docs-only/offline validation. It reads existing row-level FIT evidence
and existing monthly debug parity packets. FIT remains an offline oracle only;
HealthKit/WorkoutKit remain the runtime source.
"""

from __future__ import annotations

import json
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parent
SOURCE = ROOT / "gate-b-row-level-fit-boundary-scorecard-2026-03-to-2026-06.json"
MONTHLY_ROLLUP = ROOT / "monthly-diagnostics-rollup-2026-03-to-2026-06.json"
JSON_REPORT = ROOT / "gate-b-timer-drift-evidence-2026-03-to-2026-06.json"
MARKDOWN_REPORT = ROOT / "gate-b-timer-drift-evidence-2026-03-to-2026-06.md"

MONTHLY_EXPORT_FOLDER = Path(
    "/Users/adrielsolorzano/Documents/Personal OS/00_Inbox_To_Sort/RunSignal testing"
)

PRIMARY_OUTLIERS = [
    "2026-05-29T11:49:28Z",
    "2026-03-10T13:49:08Z",
    "2026-04-22T11:39:58Z",
    "2026-04-29T11:49:02Z",
    "2026-05-06T12:02:13Z",
    "2026-05-13T11:52:06Z",
    "2026-05-27T11:45:47Z",
]

TIME_TOLERANCE_SECONDS = 5.0
DISTANCE_TOLERANCE_METERS = 10.0
ELAPSED_MATCH_TOLERANCE_SECONDS = 2.0
PAUSE_MATCH_TOLERANCE_SECONDS = 5.0


def generated_at() -> str:
    return datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def numeric(value: Any) -> float | None:
    if isinstance(value, (int, float)) and not isinstance(value, bool):
        return float(value)
    return None


def rounded(value: Any, places: int = 1) -> Any:
    value = numeric(value)
    return None if value is None else round(value, places)


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


def row_duration(row: dict[str, Any]) -> float | None:
    return numeric(row.get("durationSeconds"))


def pause_event_kind(event: dict[str, Any]) -> str | None:
    event_type = event.get("type") or ""
    if "rawValue: 1" in event_type:
        return "pause"
    if "rawValue: 2" in event_type:
        return "resume"
    label = (event.get("label") or event.get("displayLabel") or "").lower()
    if "pause" in label:
        return "pause"
    if "resume" in label:
        return "resume"
    return None


def monthly_records() -> dict[str, dict[str, Any]]:
    rollup = load_json(MONTHLY_ROLLUP)
    records: dict[str, dict[str, Any]] = {}
    for item in rollup.get("matchedFiles", {}).values():
        path = MONTHLY_EXPORT_FOLDER / item["json"]
        if not path.exists():
            continue
        data = load_json(path)
        for record in data.get("records", []):
            start = record.get("startDate")
            if start:
                records[start] = record
    return records


def raw_events(record: dict[str, Any] | None) -> list[dict[str, Any]]:
    if not record:
        return []
    packet = record.get("parityPacket") or {}
    return packet.get("rawWorkoutEvents") or record.get("rawWorkoutEvents") or []


def pause_resume_events(events: list[dict[str, Any]]) -> list[dict[str, Any]]:
    rows = []
    for event in events:
        kind = pause_event_kind(event)
        if not kind:
            continue
        rows.append(
            {
                "index": event.get("index"),
                "kind": kind,
                "type": event.get("type"),
                "offsetSeconds": rounded(event.get("startOffsetSeconds")),
                "metadataKeys": event.get("metadataKeys") or [],
            }
        )
    return rows


def paired_pause_intervals(events: list[dict[str, Any]]) -> list[dict[str, Any]]:
    markers = sorted(
        [
            marker
            for marker in pause_resume_events(events)
            if marker.get("offsetSeconds") is not None
        ],
        key=lambda marker: float(marker["offsetSeconds"]),
    )
    intervals = []
    active_pause: dict[str, Any] | None = None
    for marker in markers:
        if marker["kind"] == "pause":
            active_pause = marker
            continue
        if marker["kind"] == "resume" and active_pause is not None:
            start = float(active_pause["offsetSeconds"])
            end = float(marker["offsetSeconds"])
            if end >= start:
                intervals.append(
                    {
                        "startOffsetSeconds": rounded(start),
                        "endOffsetSeconds": rounded(end),
                        "durationSeconds": rounded(end - start),
                        "source": "HealthKit raw workout event pause/resume pair",
                    }
                )
            active_pause = None
    if active_pause is not None:
        intervals.append(
            {
                "startOffsetSeconds": active_pause["offsetSeconds"],
                "endOffsetSeconds": None,
                "durationSeconds": None,
                "source": "HealthKit raw workout event pause without later resume in packet",
            }
        )
    return intervals


def overlap_seconds(start: float, end: float, intervals: list[dict[str, Any]]) -> float:
    total = 0.0
    for interval in intervals:
        interval_start = numeric(interval.get("startOffsetSeconds"))
        interval_end = numeric(interval.get("endOffsetSeconds"))
        if interval_start is None or interval_end is None:
            continue
        total += max(0.0, min(end, interval_end) - max(start, interval_start))
    return total


def row_evidence(
    workout: dict[str, Any],
    record: dict[str, Any] | None,
) -> list[dict[str, Any]]:
    events = raw_events(record)
    pause_intervals = paired_pause_intervals(events)
    rows = []
    for index, (candidate, current, lap, error) in enumerate(
        zip(
            workout.get("hkWorkoutActivityCandidateRows", []),
            workout.get("runSignalCurrentRows", []),
            workout.get("fitLapRows", []),
            workout.get("candidateRowErrorsVsFITLaps", []),
        ),
        start=1,
    ):
        candidate_duration = row_duration(candidate)
        current_duration = row_duration(current)
        fit_elapsed = numeric(lap.get("elapsedTimeSeconds"))
        fit_timer = numeric(lap.get("timerTimeSeconds"))
        fit_start = numeric(lap.get("startOffsetSeconds"))
        elapsed_end = None
        if fit_start is not None and fit_elapsed is not None:
            elapsed_end = fit_start + fit_elapsed
        timer_end = numeric(lap.get("endOffsetSeconds"))
        pause_overlap = None
        if fit_start is not None and elapsed_end is not None:
            pause_overlap = overlap_seconds(fit_start, elapsed_end, pause_intervals)
        elapsed_timer_delta = (
            fit_elapsed - fit_timer if fit_elapsed is not None and fit_timer is not None else None
        )
        candidate_vs_elapsed = (
            candidate_duration - fit_elapsed
            if candidate_duration is not None and fit_elapsed is not None
            else None
        )
        candidate_vs_timer = (
            candidate_duration - fit_timer
            if candidate_duration is not None and fit_timer is not None
            else error.get("timeErrorSeconds")
        )
        rows.append(
            {
                "rowIndex": index,
                "label": candidate.get("label") or error.get("rowLabel"),
                "fitLapIndex": lap.get("lapIndex"),
                "fitStartOffsetSeconds": rounded(fit_start),
                "fitTimerEndOffsetSeconds": rounded(timer_end),
                "fitElapsedEndOffsetSeconds": rounded(elapsed_end),
                "candidateDurationSeconds": rounded(candidate_duration),
                "currentDurationSeconds": rounded(current_duration),
                "fitElapsedDurationSeconds": rounded(fit_elapsed),
                "fitTimerDurationSeconds": rounded(fit_timer),
                "elapsedMinusTimerSeconds": rounded(elapsed_timer_delta),
                "candidateMinusFITElapsedSeconds": rounded(candidate_vs_elapsed),
                "candidateMinusFITTimerSeconds": rounded(candidate_vs_timer),
                "candidateDistanceErrorMeters": error.get("distanceErrorMeters"),
                "pauseOverlapSeconds": rounded(pause_overlap),
                "pauseOverlapMatchesElapsedTimerDelta": pause_overlap_matches(
                    pause_overlap,
                    elapsed_timer_delta,
                ),
            }
        )
    return rows


def pause_overlap_matches(pause_overlap: float | None, elapsed_timer_delta: float | None) -> bool:
    if pause_overlap is None or elapsed_timer_delta is None:
        return False
    return abs(pause_overlap - elapsed_timer_delta) <= PAUSE_MATCH_TOLERANCE_SECONDS


def max_abs_row(rows: list[dict[str, Any]], key: str) -> dict[str, Any] | None:
    candidates = [row for row in rows if numeric(row.get(key)) is not None]
    if not candidates:
        return None
    return max(candidates, key=lambda row: abs(float(row[key])))


def classify(workout: dict[str, Any], rows: list[dict[str, Any]]) -> tuple[str, list[str]]:
    reasons = []
    if not rows:
        return "missing_required_evidence", ["missing row-level candidate/FIT evidence"]

    max_time_row = max_abs_row(rows, "candidateMinusFITTimerSeconds")
    max_distance_row = max_abs_row(rows, "candidateDistanceErrorMeters")
    max_timer_error = abs(float(max_time_row["candidateMinusFITTimerSeconds"])) if max_time_row else 0.0
    max_distance_error = (
        abs(float(max_distance_row["candidateDistanceErrorMeters"])) if max_distance_row else 0.0
    )
    max_elapsed_error = (
        abs(float(max_time_row["candidateMinusFITElapsedSeconds"]))
        if max_time_row and numeric(max_time_row.get("candidateMinusFITElapsedSeconds")) is not None
        else None
    )
    elapsed_timer_delta = (
        abs(float(max_time_row["elapsedMinusTimerSeconds"]))
        if max_time_row and numeric(max_time_row.get("elapsedMinusTimerSeconds")) is not None
        else 0.0
    )
    pause_overlap_match = bool(max_time_row and max_time_row.get("pauseOverlapMatchesElapsedTimerDelta"))

    if workout["scores"]["classification"] == "open_tail_needs_rule":
        reasons.append("tail rule is still required")
    if workout["scores"]["classification"] == "repeat_block_needs_rule":
        reasons.append("repeat-block rule is still required")

    if (
        max_timer_error > TIME_TOLERANCE_SECONDS
        and max_elapsed_error is not None
        and max_elapsed_error <= ELAPSED_MATCH_TOLERANCE_SECONDS
        and elapsed_timer_delta > TIME_TOLERANCE_SECONDS
    ):
        reasons.append("candidate duration matches FIT elapsed but not FIT timer")
        if pause_overlap_match:
            reasons.append("paired HealthKit pause/resume overlap matches elapsed-minus-timer delta")
        return "likely_timer_time_drift", reasons

    if max_distance_error > DISTANCE_TOLERANCE_METERS and max_timer_error <= TIME_TOLERANCE_SECONDS:
        reasons.append("distance error exceeds tolerance while timer error is small")
        return "likely_distance_boundary_drift", reasons

    if workout["scores"]["classification"] == "open_tail_needs_rule":
        return "likely_tail_ambiguity", reasons

    if workout["scores"]["classification"] == "repeat_block_needs_rule":
        return "likely_repeat_block_rule_blocker", reasons

    return "missing_required_evidence", reasons or ["no classifier reached support"]


def material_timer_status(rows: list[dict[str, Any]]) -> str:
    if not rows:
        return "missing_required_evidence"

    max_time_row = max_abs_row(rows, "candidateMinusFITTimerSeconds")
    if not max_time_row:
        return "missing_required_evidence"

    max_timer_error = abs(float(max_time_row["candidateMinusFITTimerSeconds"]))
    max_elapsed_error = abs(float(max_time_row["candidateMinusFITElapsedSeconds"]))
    elapsed_timer_delta = abs(float(max_time_row["elapsedMinusTimerSeconds"]))
    pause_overlap_match = bool(max_time_row.get("pauseOverlapMatchesElapsedTimerDelta"))

    if max_timer_error <= TIME_TOLERANCE_SECONDS:
        return "within_timer_tolerance"

    if (
        max_elapsed_error <= ELAPSED_MATCH_TOLERANCE_SECONDS
        and elapsed_timer_delta > TIME_TOLERANCE_SECONDS
        and pause_overlap_match
    ):
        return "pause_explained_not_material_boundary_error"

    return "material_timer_error"


def existing_report_rows() -> dict[str, dict[str, Any]]:
    if not JSON_REPORT.exists():
        return {}

    try:
        report = load_json(JSON_REPORT)
    except json.JSONDecodeError:
        return {}

    return {
        row["startDate"]: row
        for row in report.get("rows", [])
        if row.get("startDate")
    }


def build_report() -> dict[str, Any]:
    source = load_json(SOURCE)
    records = monthly_records()
    existing_rows = existing_report_rows()
    by_start = {workout["startDate"]: workout for workout in source["workouts"]}
    rows = []
    for start in PRIMARY_OUTLIERS:
        workout = by_start[start]
        record = records.get(start)
        existing_row = existing_rows.get(start, {})
        if record is None and existing_row.get("rowEvidence"):
            events = []
            pause_markers = existing_row.get("pauseResumeMarkers") or []
            pause_intervals = existing_row.get("pairedPauseIntervals") or []
            evidence_rows = existing_row.get("rowEvidence") or []
        else:
            events = raw_events(record)
            pause_markers = pause_resume_events(events)
            pause_intervals = paired_pause_intervals(events)
            evidence_rows = row_evidence(workout, record)
        classification, reasons = classify(workout, evidence_rows)
        material_status = material_timer_status(evidence_rows)
        raw_event_count = len(events) or existing_row.get("rawHealthKitEventCount", 0)
        max_time_row = max_abs_row(evidence_rows, "candidateMinusFITTimerSeconds")
        max_distance_row = max_abs_row(evidence_rows, "candidateDistanceErrorMeters")
        rows.append(
            {
                "startDate": start,
                "classification": workout["classification"],
                "gateBDecision": workout["scores"]["classification"],
                "shape": shape(workout),
                "fitFilename": workout.get("fitFilename"),
                "rawHealthKitEventCount": raw_event_count,
                "pauseResumeMarkerCount": len(pause_markers),
                "pairedPauseIntervalCount": len(
                    [interval for interval in pause_intervals if interval.get("durationSeconds") is not None]
                ),
                "pauseResumeMarkers": pause_markers,
                "pairedPauseIntervals": pause_intervals,
                "maxTimerDriftRow": max_time_row,
                "maxDistanceDriftRow": max_distance_row,
                "rowEvidence": evidence_rows,
                "driftClassification": classification,
                "materialTimerStatus": material_status,
                "reasons": reasons,
                "recommendation": "exclude_from_phase_3_candidate",
            }
        )

    return {
        "generatedAt": generated_at(),
        "source": SOURCE.name,
        "monthlyDiagnosticsRollup": MONTHLY_ROLLUP.name,
        "runtimeSource": "HealthKit/WorkoutKit only",
        "validationOracle": "FIT offline reference only",
        "fitRuntimeUseAllowed": False,
        "productionBehaviorChanged": False,
        "normalWorkoutUIChanged": False,
        "hkWorkoutActivityPromoted": False,
        "phase3Implemented": False,
        "summary": {
            "outlierCount": len(rows),
            "classificationCounts": dict(Counter(row["driftClassification"] for row in rows)),
            "materialTimerStatusCounts": dict(Counter(row["materialTimerStatus"] for row in rows)),
            "excludedFromNarrowPhase3Candidate": sum(
                1 for row in rows if row["recommendation"] == "exclude_from_phase_3_candidate"
            ),
        },
        "rows": rows,
            "recommendation": "Keep all timer-drift outliers excluded from any narrow Phase 3 candidate until elapsed-vs-timer semantics and repeat/tail rules are explicitly approved.",
            "materialTimerPolicy": {
                "timeToleranceSeconds": TIME_TOLERANCE_SECONDS,
                "elapsedMatchToleranceSeconds": ELAPSED_MATCH_TOLERANCE_SECONDS,
                "pauseMatchToleranceSeconds": PAUSE_MATCH_TOLERANCE_SECONDS,
                "distanceToleranceMeters": DISTANCE_TOLERANCE_METERS,
                "pauseExplainedStatus": "pause_explained_not_material_boundary_error",
                "blockedStatus": "material_timer_error",
            },
    }


def write_markdown(report: dict[str, Any]) -> None:
    rows = report["rows"]
    lines = [
        "# Gate B Timer Drift Evidence: March-June 2026",
        "",
        f"Generated: {report['generatedAt']}",
        "",
        "## Executive Summary",
        "",
        "The known timer-drift outliers should stay excluded from any narrow Phase 3 candidate. In each primary outlier, the largest candidate timing error is explained by FIT elapsed duration diverging from FIT timer duration. Existing HealthKit debug packets also expose pause/resume markers whose paired pause interval overlaps match the elapsed-minus-timer deltas.",
        "",
        "This is docs/debug validation only. FIT remains an offline validation oracle. Runtime source remains HealthKit/WorkoutKit. No production interval behavior, normal workout UI, `HKWorkoutActivity` promotion, or runtime FIT usage changed.",
        "",
        "## Summary",
        "",
        md_table(
            [
                ["Metric", "Value"],
                ["---", "---:"],
                ["Outliers reviewed", report["summary"]["outlierCount"]],
                ["Excluded from narrow Phase 3 candidate", report["summary"]["excludedFromNarrowPhase3Candidate"]],
                ["Material timer policy", "pause-explained drift is not a material boundary error"],
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
        "## Material Timer Status Counts",
        "",
        md_table(
            [
                ["Material timer status", "Count"],
                ["---", "---:"],
                *[[key, value] for key, value in report["summary"]["materialTimerStatusCounts"].items()],
            ]
        ),
        "",
        "## Outlier Rows",
        "",
        md_table(
            [
                [
                    "Start",
                    "Gate B decision",
                    "Max drift row",
                    "FIT elapsed/timer",
                    "Candidate - elapsed",
                    "Candidate - timer",
                    "Pause overlap",
                    "Pause markers",
                    "Decision",
                    "Material timer status",
                ],
                ["---", "---", "---", "---:", "---:", "---:", "---:", "---:", "---", "---"],
                *[
                    [
                        row["startDate"],
                        row["gateBDecision"],
                        row_label(row["maxTimerDriftRow"]),
                        fit_elapsed_timer(row["maxTimerDriftRow"]),
                        fmt_seconds((row["maxTimerDriftRow"] or {}).get("candidateMinusFITElapsedSeconds")),
                        fmt_seconds((row["maxTimerDriftRow"] or {}).get("candidateMinusFITTimerSeconds")),
                        fmt_seconds((row["maxTimerDriftRow"] or {}).get("pauseOverlapSeconds")),
                        row["pauseResumeMarkerCount"],
                        row["driftClassification"],
                        row["materialTimerStatus"],
                    ]
                    for row in rows
                ],
            ]
        ),
        "",
        "## Per-Workout Notes",
        "",
    ]

    for row in rows:
        max_row = row["maxTimerDriftRow"] or {}
        lines.extend(
            [
                f"### {row['startDate']}",
                "",
                f"- Shape: `{row['shape']}`",
                f"- Gate B decision: `{row['gateBDecision']}`.",
                f"- Drift classification: `{row['driftClassification']}`.",
                f"- Material timer status: `{row['materialTimerStatus']}`.",
                f"- Max timer-drift row: {row_label(max_row)}.",
                f"- FIT elapsed/timer: {fit_elapsed_timer(max_row)}.",
                f"- Candidate duration minus FIT elapsed: {fmt_seconds(max_row.get('candidateMinusFITElapsedSeconds'))}.",
                f"- Candidate duration minus FIT timer: {fmt_seconds(max_row.get('candidateMinusFITTimerSeconds'))}.",
                f"- Pause overlap in FIT elapsed row window: {fmt_seconds(max_row.get('pauseOverlapSeconds'))}.",
                f"- Pause/resume markers: {row['pauseResumeMarkerCount']} markers, {row['pairedPauseIntervalCount']} paired intervals.",
                f"- Reasons: {', '.join(row['reasons'])}.",
                "- Recommendation: keep excluded from any narrow Phase 3 candidate.",
                "",
            ]
        )

    lines.extend(
        [
            "## Recommendation",
            "",
            report["recommendation"],
            "",
            "Material timer policy: a large candidate-vs-FIT-timer delta is not a material boundary error when candidate elapsed matches FIT elapsed, paired HealthKit pause overlap matches elapsed-minus-timer drift, and unresolved repeat/tail/shape blockers remain separately enforced.",
            "",
            "Before any Phase 3 discussion, the scorer/debug export should keep both elapsed and timer duration visible by row and preserve pause/resume marker evidence. Repeat-block and tail rules remain separately blocked.",
            "",
            "## Explicit No-Production-Change Statement",
            "",
            "This artifact is docs/debug validation only. It does not change production interval behavior, normal workout UI, `HKWorkoutActivity` promotion status, FIT import behavior, HealthFit dependency status, runtime FIT usage, or custom workout reconstruction behavior.",
        ]
    )
    MARKDOWN_REPORT.write_text("\n".join(lines) + "\n", encoding="utf-8")


def row_label(row: dict[str, Any] | None) -> str:
    if not row:
        return "n/a"
    return f"{row.get('rowIndex')} {row.get('label')}"


def fit_elapsed_timer(row: dict[str, Any] | None) -> str:
    if not row:
        return "n/a"
    return (
        f"{fmt_seconds(row.get('fitElapsedDurationSeconds'))} / "
        f"{fmt_seconds(row.get('fitTimerDurationSeconds'))}"
    )


def main() -> int:
    report = build_report()
    JSON_REPORT.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    write_markdown(report)
    print(f"Wrote {JSON_REPORT.name}")
    print(f"Wrote {MARKDOWN_REPORT.name}")
    print(f"Classification counts: {report['summary']['classificationCounts']}")
    print(f"Material timer status counts: {report['summary']['materialTimerStatusCounts']}")
    print("Timer-drift outliers remain excluded from Phase 3 candidates.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
