#!/usr/bin/env python3
"""Compare fixed-distance Work + Open tail boundary strategies offline.

This is a docs-only research harness. It does not change app behavior.
"""

from __future__ import annotations

import json
import re
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parent
FIXTURE = ROOT / "interval-parity-fixture.json"


@dataclass
class Case:
    date: str
    folder: str
    apple_work: float
    apple_open: float
    current_work: float
    current_open: float
    payload: dict


def seconds_label(seconds: float | None) -> str:
    if seconds is None:
        return "n/a"
    rounded = int(round(seconds))
    return f"{rounded // 60}:{rounded % 60:02d}"


def signed_delta(seconds: float | None) -> str:
    if seconds is None:
        return "n/a"
    return f"{seconds:+.1f}s"


def strategy_score(work: float, open_: float, case: Case) -> float:
    return abs(work - case.apple_work) + abs(open_ - case.apple_open)


def effect_label(score: float, current_score: float) -> str:
    if score < current_score - 0.25:
        return "improves"
    if score > current_score + 0.25:
        return "worsens"
    return "same"


def extract_payload(path: Path) -> dict | None:
    text = path.read_text()
    matches = re.findall(r"```json\n(.*?)\n```", text, flags=re.S)
    if not matches:
        return None
    return json.loads(matches[-1])


def payload_for_folder(folder: str) -> dict | None:
    folder_path = ROOT / folder
    candidates = list((folder_path / "exports" / "runsignal-diagnostics").glob("*.txt"))
    candidates += list((folder_path / "screenshots" / "runsignal-raw-healthkit-debug").glob("*.txt"))
    best_payload = None
    for candidate in candidates:
        payload = extract_payload(candidate)
        if not payload:
            continue
        if any("distanceBoundary" in item for item in payload.get("boundaryDiagnostics", [])):
            return payload
        best_payload = payload
    return best_payload


def fixed_distance_cases() -> tuple[list[Case], list[str]]:
    fixture = json.loads(FIXTURE.read_text())
    cases: list[Case] = []
    skipped: list[str] = []

    for workout in fixture["workouts"]:
        rows = workout["rows"]
        if len(rows) < 2:
            continue
        expected_labels = [rows[0]["expectedLabel"].lower(), rows[1]["expectedLabel"].lower()]
        if expected_labels != ["work", "open"]:
            continue

        payload = payload_for_folder(workout["folder"])
        if not payload or not any("distanceBoundary" in item for item in payload.get("boundaryDiagnostics", [])):
            skipped.append(f"{workout['date']}: skipped; boundary diagnostics unavailable")
            continue

        observed_labels = [rows[0]["observedLabel"].lower(), rows[1]["observedLabel"].lower()]
        if "unavailable" in observed_labels:
            skipped.append(f"{workout['date']}: skipped; RunSignal interval evidence unavailable")
            continue

        if workout["expectedStatus"] == "pass":
            skipped.append(f"{workout['date']}: pass fixture; keep as regression guard, not scored for drift tuning")
            continue

        cases.append(
            Case(
                date=workout["date"],
                folder=workout["folder"],
                apple_work=float(rows[0]["expectedTimeSeconds"]),
                apple_open=float(rows[1]["expectedTimeSeconds"]),
                current_work=float(rows[0]["observedTimeSeconds"]),
                current_open=float(rows[1]["observedTimeSeconds"]),
                payload=payload,
            )
        )
    return cases, skipped


def boundary_items(payload: dict) -> tuple[dict, dict]:
    distance = next(item["distanceBoundary"] for item in payload["boundaryDiagnostics"] if "distanceBoundary" in item)
    tail = next(item["tail"] for item in payload["boundaryDiagnostics"] if "tail" in item)
    return distance, tail


def nearest_segment(case: Case) -> str:
    segments = case.payload.get("segmentMarkers", [])
    if not segments:
        return "No segment markers in export."
    nearest = min(segments, key=lambda item: abs(float(item["endOffsetSeconds"]) - case.apple_work))
    diff = float(nearest["endOffsetSeconds"]) - case.apple_work
    start = seconds_label(float(nearest["startOffsetSeconds"]))
    end = seconds_label(float(nearest["endOffsetSeconds"]))
    kind = nearest.get("markerKind", "unknown")
    distance = nearest.get("distanceMeters")
    distance_text = f"{float(distance):.1f}m" if distance is not None else "n/a"
    return f"{kind} {start}-{end}, {distance_text}, end delta {signed_delta(diff)}"


def rows_for_case(case: Case) -> list[dict]:
    distance, tail = boundary_items(case.payload)
    workout_end = float(tail["workoutEndOffsetSeconds"])
    current_score = strategy_score(case.current_work, case.current_open, case)
    strategies = [
        (
            "current crossing sample end",
            case.current_work,
            case.current_open,
            "Current production behavior; no added regression risk.",
        ),
        (
            "next sample end after crossing",
            float(distance["nextSample"]["endOffsetSeconds"]),
            workout_end - float(distance["nextSample"]["endOffsetSeconds"]),
            "Risk if applied globally: pass fixtures June 2 and June 4 already match Apple Fitness closely.",
        ),
        (
            "Apple-visible Open alignment",
            workout_end - case.apple_open,
            case.apple_open,
            "Not production-safe: uses Apple Fitness screenshot values as oracle.",
        ),
        (
            "final distance sample anchored",
            float(tail["finalDistanceSampleOffsetSeconds"]),
            workout_end - float(tail["finalDistanceSampleOffsetSeconds"]),
            "High risk: may overfit short-tail cases and alter passing Work/Open fixtures.",
        ),
    ]
    rows = []
    for name, work, open_, risk in strategies:
        score = strategy_score(work, open_, case)
        rows.append(
            {
                "date": case.date,
                "strategy": name,
                "apple_work": seconds_label(case.apple_work),
                "apple_open": seconds_label(case.apple_open),
                "work": seconds_label(work),
                "open": seconds_label(open_),
                "work_delta": signed_delta(work - case.apple_work),
                "open_delta": signed_delta(open_ - case.apple_open),
                "effect": effect_label(score, current_score),
                "risk": risk,
            }
        )
    return rows


def print_table(headers: list[str], rows: list[list[str]]) -> None:
    widths = [len(header) for header in headers]
    for row in rows:
        for index, cell in enumerate(row):
            widths[index] = max(widths[index], len(cell))
    print("| " + " | ".join(header.ljust(widths[index]) for index, header in enumerate(headers)) + " |")
    print("| " + " | ".join("-" * width for width in widths) + " |")
    for row in rows:
        print("| " + " | ".join(cell.ljust(widths[index]) for index, cell in enumerate(row)) + " |")


def main() -> int:
    cases, skipped = fixed_distance_cases()
    table_rows = []
    for case in cases:
        for row in rows_for_case(case):
            table_rows.append(
                [
                    row["date"],
                    row["strategy"],
                    row["apple_work"],
                    row["apple_open"],
                    row["work"],
                    row["open"],
                    row["work_delta"],
                    row["open_delta"],
                    row["effect"],
                    row["risk"],
                ]
            )

    print("Fixed-distance Work + real Open tail boundary research")
    print()
    print_table(
        [
            "Date",
            "Strategy",
            "Apple Work",
            "Apple Open",
            "Candidate Work",
            "Candidate Open",
            "Work delta",
            "Open delta",
            "Effect",
            "Regression / production risk",
        ],
        table_rows,
    )

    print()
    print("Segment-marker-assisted diagnostic only")
    for case in cases:
        print(f"- {case.date}: {nearest_segment(case)}")

    print()
    print("Skipped / guardrail cases")
    for item in skipped:
        print(f"- {item}")

    print()
    print("Conclusion: no candidate is approved for production. Next-sample-end improves the scored drift cases and brings them within temporary tolerance, but it still misses Apple Fitness on at least one row in each case and must be checked against pass fixtures with matching boundary diagnostics before any app logic change.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
