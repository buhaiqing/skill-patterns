#!/usr/bin/env python3
"""
Deterministic task classifier for task-router (optional L1 supplement).

Usage:
  python scripts/classify.py --text "fix login 500 error"
  python scripts/classify.py --input /path/to/task.txt

Exit 0 always; prints JSON to stdout.
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

# Customize: type_id -> (keywords, weight per hit)
RULES: dict[str, list[tuple[str, int]]] = {
    "T1": [
        (r"\b(bug|fix|error|报错|异常|regression)\b", 2),
        (r"\b(failed test|测试失败)\b", 3),
    ],
    "T2": [
        (r"\b(feature|新功能|implement|add)\b", 2),
        (r"\b(需求|story)\b", 2),
    ],
    "T3": [
        (r"\b(deploy|部署|config|巡检|ops|k8s|release)\b", 2),
    ],
    "T4": [
        (r"\b(how|why|explain|是什么|怎么用)\b", 2),
        (r"\b(document|文档)\b", 2),
    ],
}

THRESHOLD_MIN_SCORE = 2
THRESHOLD_CONFIDENCE = 0.6


def score(text: str) -> dict[str, int]:
    text_lower = text.lower()
    scores: dict[str, int] = {tid: 0 for tid in RULES}
    for tid, patterns in RULES.items():
        for pattern, weight in patterns:
            if re.search(pattern, text_lower, re.IGNORECASE):
                scores[tid] += weight
    return scores


def classify(text: str) -> dict:
    scores = score(text)
    ranked = sorted(scores.items(), key=lambda x: -x[1])
    top_id, top_score = ranked[0]
    second_score = ranked[1][1] if len(ranked) > 1 else 0

    if top_score < THRESHOLD_MIN_SCORE:
        return {
            "type_id": None,
            "type_name": None,
            "confidence": 0.0,
            "scores": scores,
            "reason": "below_min_score",
        }

    confidence = min(1.0, top_score / (top_score + second_score + 1))
    names = {"T1": "bugfix", "T2": "feature", "T3": "ops", "T4": "question"}

    return {
        "type_id": top_id,
        "type_name": names.get(top_id, top_id),
        "confidence": round(confidence, 3),
        "scores": scores,
        "low_confidence": confidence < THRESHOLD_CONFIDENCE,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description="Classify task text for task-router")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--text", type=str, help="Task description text")
    group.add_argument("--input", type=Path, help="Path to task description file")
    args = parser.parse_args()

    if args.text:
        text = args.text
    else:
        text = args.input.read_text(encoding="utf-8")

    result = classify(text)
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
