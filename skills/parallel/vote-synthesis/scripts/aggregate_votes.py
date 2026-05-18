#!/usr/bin/env python3
"""
Majority vote for structured choices (optional supplement to vote-synthesis).

Usage:
  python scripts/aggregate_votes.py --votes '["A","B","A"]'
  python scripts/aggregate_votes.py --file votes.json

votes.json: ["answer1", "answer2", "answer3"]
"""
from __future__ import annotations

import argparse
import json
import sys
from collections import Counter


def majority(votes: list[str]) -> dict:
    if not votes:
        return {"winner": None, "confidence": 0.0, "counts": {}}
    counts = Counter(votes)
    winner, top = counts.most_common(1)[0]
    total = len(votes)
    confidence = top / total
    return {
        "winner": winner,
        "confidence": round(confidence, 3),
        "counts": dict(counts),
        "unanimous": len(counts) == 1,
        "tie": len([c for c in counts.values() if c == top]) > 1,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--votes", type=str, help='JSON array, e.g. \'["A","B","A"]\'')
    group.add_argument("--file", type=str, help="Path to JSON array file")
    args = parser.parse_args()

    if args.votes:
        votes = json.loads(args.votes)
    else:
        votes = json.loads(open(args.file, encoding="utf-8").read())

    print(json.dumps(majority(votes), ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
