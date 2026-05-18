---
name: vote-synthesis
description: >-
  Aggregates N independent answers into a final decision using rubric scoring or
  majority vote. Use after parallel-dispatch or multiple subagent runs on the same
  question, when the user needs consensus, best-of-N, or disagreement analysis.
---

# Vote Synthesis

Voting 模式的聚合 Skill。须先有 **N 份独立答案**（隔离上下文的 N 次 Worker）。

> 模式文档：[docs/03-parallelization.md](../../../docs/03-parallelization.md)

## 开场白（必须）

「使用 vote-synthesis 聚合 {N} 路独立答案。」

## 前置条件

| 条件 | 要求 |
|------|------|
| 答案数量 N | ≥ 2，推荐 3 |
| 独立性 | 每路不同 subagent / 不同 seed / 隔离 prompt |
| 输入格式 | 每路标注 `source_id` |

**禁止**：同一 context 连续生成 N 次当作独立投票。

## 聚合流程

```text
1. 收集 Answer[1..N]（含 source_id）
2. Read references/rubric.md
3. 若完全一致 → 直接采用，标注 confidence=high
4. 若多数一致 → 采用多数，附少数派摘要
5. 若全部分歧 → 按 rubric 逐项打分 → 取最高
6. 仍平手 → escalate（列分歧，请求人工）
7. 可选：python scripts/aggregate_votes.py（结构化选项）
8. 输出最终答案 + 聚合报告
```

## 输出模板

```markdown
## 最终答案
{final_answer}

## 聚合元数据
| 字段 | 值 |
|------|-----|
| N | {n} |
| 策略 | unanimous / majority / rubric / escalate |
| 置信度 | high / medium / low |

## 分歧摘要（若有）
| source_id | 立场 | 关键差异 |
|-----------|------|---------|

## 采用理由
{why this answer won}
```

## 与 parallel-dispatch 的区别

| Skill | 场景 |
|-------|------|
| parallel-dispatch | N 个**不同**问题并行 |
| vote-synthesis | **同一**问题 N 路答案合并 |

## 禁止

- 未标注 source_id 的混答
- 忽略少数派中的安全 BLOCKER 信号
- 无 rubric 时凭直觉选「看起来对」的答案
