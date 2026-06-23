#!/usr/bin/env python3
"""Validate Raw HealthKit Debug/parity packet export summary consistency.

This is offline proof-folder validation only. It checks that debug/export-only
custom workout summary counts agree with the exported row arrays.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parent
JSON_FENCE_RE = re.compile(r"```json\s*\n(.*?)\n```", re.DOTALL)
SUMMARY_KEY = "customWorkoutCandidateRuleSummary"
ROWS_KEY = "customWorkoutCandidateRuleRows"
COMPARISON_KEY = "customWorkoutComparisonSummary"
RELEVANT_KEYS = (SUMMARY_KEY, ROWS_KEY, COMPARISON_KEY)


def load_json(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def markdown_payloads(path: Path) -> list[Any]:
    text = path.read_text(encoding="utf-8")
    payloads: list[Any] = []
    for match in JSON_FENCE_RE.finditer(text):
        raw = match.group(1)
        if not any(key in raw for key in RELEVANT_KEYS):
            continue
        try:
            payloads.append(json.loads(raw))
        except json.JSONDecodeError as error:
            raise ValueError(f"invalid JSON fence containing parity export fields: {error}") from error
    return payloads


def candidate_row_count(payload: dict[str, Any]) -> int | None:
    summary = payload.get(SUMMARY_KEY)
    if summary is None:
        return None
    if not isinstance(summary, dict):
        raise ValueError(f"{SUMMARY_KEY} must be an object")

    rows = payload.get(ROWS_KEY)
    if not isinstance(rows, list):
        raise ValueError(f"{ROWS_KEY} must be an array when {SUMMARY_KEY} is present")

    expected = summary.get("candidateRowCount")
    if expected != len(rows):
        raise ValueError(
            f"candidateRowCount is {expected}, but {ROWS_KEY} has {len(rows)} rows"
        )

    open_tail_count = sum(1 for row in rows if isinstance(row, dict) and row.get("isOpenTail") is True)
    expected_open_tail_count = summary.get("openTailRowCount")
    if expected_open_tail_count != open_tail_count:
        raise ValueError(
            f"openTailRowCount is {expected_open_tail_count}, but {open_tail_count} rows have isOpenTail=true"
        )

    return len(rows)


def comparison_row_count(payload: dict[str, Any]) -> int | None:
    summary = payload.get(COMPARISON_KEY)
    if summary is None:
        return None
    if not isinstance(summary, dict):
        raise ValueError(f"{COMPARISON_KEY} must be an object")

    row_confidences = summary.get("rowConfidences")
    if not isinstance(row_confidences, list):
        raise ValueError(f"{COMPARISON_KEY}.rowConfidences must be an array")

    expected = summary.get("rowCount")
    if expected != len(row_confidences):
        raise ValueError(
            f"comparison rowCount is {expected}, but rowConfidences has {len(row_confidences)} rows"
        )

    return len(row_confidences)


def validate_payload(payload: Any) -> bool:
    if not isinstance(payload, dict):
        return False
    if not any(key in payload for key in RELEVANT_KEYS):
        return False

    if ROWS_KEY in payload and SUMMARY_KEY not in payload:
        raise ValueError(f"{ROWS_KEY} is present without {SUMMARY_KEY}")

    candidate_row_count(payload)
    comparison_row_count(payload)
    return True


def iter_paths(roots: list[Path]) -> list[Path]:
    paths: list[Path] = []
    for root in roots:
        if root.is_file():
            paths.append(root)
            continue
        for suffix in ("*.json", "*.md"):
            paths.extend(root.rglob(suffix))
    return sorted(set(paths))


def validate_path(path: Path) -> tuple[int, list[str]]:
    payloads: list[Any]
    try:
        if path.suffix == ".json":
            payloads = [load_json(path)]
        elif path.suffix == ".md":
            payloads = markdown_payloads(path)
        else:
            return 0, []
    except (OSError, json.JSONDecodeError, ValueError) as error:
        return 0, [f"{path}: {error}"]

    checked = 0
    failures: list[str] = []
    for index, payload in enumerate(payloads, start=1):
        try:
            if validate_payload(payload):
                checked += 1
        except ValueError as error:
            suffix = f" JSON fence #{index}" if path.suffix == ".md" else ""
            failures.append(f"{path}{suffix}: {error}")
    return checked, failures


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Validate debug-only custom workout row counts in proof-folder JSON and markdown exports."
    )
    parser.add_argument(
        "paths",
        nargs="*",
        type=Path,
        default=[ROOT],
        help="Files or folders to scan. Defaults to the parity dataset folder.",
    )
    args = parser.parse_args()

    paths = iter_paths([path.resolve() for path in args.paths])
    checked_payloads = 0
    checked_files = 0
    failures: list[str] = []

    for path in paths:
        checked, path_failures = validate_path(path)
        if checked:
            checked_files += 1
            checked_payloads += checked
        failures.extend(path_failures)

    if failures:
        for failure in failures:
            print(f"FAIL: {failure}", file=sys.stderr)
        return 1

    skipped_files = len(paths) - checked_files
    print(
        f"Validated {checked_payloads} parity export payload(s) in {checked_files} file(s); "
        f"skipped {skipped_files} JSON/Markdown file(s) without debug parity fields."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
