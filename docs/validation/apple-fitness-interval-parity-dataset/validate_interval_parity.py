#!/usr/bin/env python3
"""Validate the Apple Fitness interval parity fixture.

This harness intentionally allows known blocked workouts to remain in the
fixture. It fails only when the fixture no longer reproduces the expected
current status or violates structural rules such as using segment markers.
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent
FIXTURE = ROOT / "interval-parity-fixture.json"


def normalized_label(label: str) -> str:
    text = label.lower().strip()
    text = re.sub(r"\s+\d+$", "", text)
    if text == "open / extra":
        return "open"
    return text


def row_status(row: dict) -> tuple[str, list[str]]:
    issues: list[str] = []
    expected_label = normalized_label(row["expectedLabel"])
    observed_label = normalized_label(row["observedLabel"])
    if expected_label != observed_label:
        issues.append(f"label {row['observedLabel']!r} != {row['expectedLabel']!r}")

    time_delta = abs(float(row["observedTimeSeconds"]) - float(row["expectedTimeSeconds"]))
    distance_delta = abs(float(row["observedDistanceMeters"]) - float(row["expectedDistanceMeters"]))

    time_preferred = time_delta <= float(row["preferredTimeToleranceSeconds"])
    distance_preferred = distance_delta <= float(row["preferredDistanceToleranceMeters"])
    time_temporary = time_delta <= float(row["temporaryTimeToleranceSeconds"])
    distance_temporary = distance_delta <= float(row["temporaryDistanceToleranceMeters"])

    if not time_temporary:
        issues.append(f"time delta {time_delta:.1f}s > {row['temporaryTimeToleranceSeconds']}s")
    if not distance_temporary:
        issues.append(f"distance delta {distance_delta:.1f}m > {row['temporaryDistanceToleranceMeters']}m")

    if issues:
        return "blocked", issues
    if not time_preferred or not distance_preferred:
        return "temporary pass", []
    return "pass", []


def workout_status(workout: dict) -> tuple[str, list[str]]:
    row_results = [row_status(row) for row in workout["rows"]]
    issues = [f"row {row['row']}: {issue}" for row, (_, row_issues) in zip(workout["rows"], row_results) for issue in row_issues]
    statuses = [status for status, _ in row_results]
    if "blocked" in statuses:
        return "blocked", issues
    if "temporary pass" in statuses:
        return "temporary pass", issues
    return "pass", issues


def main() -> int:
    fixture = json.loads(FIXTURE.read_text())
    if fixture["rules"].get("segmentMarkersUsedAsNormalRows") is not False:
        print("ERROR: fixture must keep HealthKit Segment Markers out of normal interval rows")
        return 1

    failures: list[str] = []
    print("Apple Fitness interval parity fixture")
    for workout in fixture["workouts"]:
        computed, issues = workout_status(workout)
        expected = workout["expectedStatus"]
        print(f"- {workout['date']} {workout['workoutType']}: {computed}")
        for issue in issues:
            print(f"  - {issue}")
        if computed != expected:
            failures.append(f"{workout['date']}: computed {computed}, expected {expected}")

    if failures:
        print("\nERROR: fixture status drifted")
        for failure in failures:
            print(f"- {failure}")
        return 1

    print("\nFixture matches expected current statuses. Promotion remains blocked.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
