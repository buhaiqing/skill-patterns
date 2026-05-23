---
name: eval-optimize-loop
description: >-
  Critic-Generator 质量门：独立 readonly Critic 按 rubric 评测，Generator 实现与修复，MAX_ITER=3。
  Use before merge/claiming done. 合并前检查、质量门、评审循环、eval optimize、rubric 评测、复盘模板。
---

# Eval-Optimize Loop（Critic-Generator）

> 模式文档：[docs/05-evaluator-optimizer.md](../../../docs/05-evaluator-optimizer.md)

## 开场白（必须）

「使用 eval-optimize-loop：Generator 实现，独立 Critic subagent 按 rubric 实例评测。」

## 流程概览

```text
Round 0  →  rubric 选型/实例化（见 round-0-rubric-factory.md）
Round 1..MAX_ITER  →  Generate → Handoff → Critic → pass|fail|escalate
结束  →  write_usage_log.sh →（pass）verification-before-completion
复盘  →  retrospective-evolution.md（改规则后 run_rubric_change_gate）
```

## 角色（不可混用）

| 角色 | 主体 | 职责 |
|------|------|------|
| **Generator** | 主 Agent / `executor` | 实现与按 Critic 反馈修复 |
| **Critic** | **Task 独立 subagent**，`readonly: true` | 只评不改；选型见 [critic-subagent-matrix.md](references/critic-subagent-matrix.md) |
| **Rubric Factory** | Round 0 编排 | 匹配/生成模板并实例化 |

编排者：派发 Critic、填 Handoff、禁止 Generator 自评 pass。

## Round 0

规程：[round-0-rubric-factory.md](references/round-0-rubric-factory.md)

- L1 匹配：`scripts/match_rubric_template.py "用户描述"` 或 `make match-rubric QUERY='…'`
- 实例化：`instantiate_rubric.sh` → `check_round0_gate.sh`
- 默认/trivial：`instantiate_rubric.sh {task-id} --default`

## 循环协议

`MAX_ITER = 3`（[max-iterations.md](references/max-iterations.md)）

```text
for round in 1..MAX_ITER:
  Generate → Handoff（含 Active Rubric，generator-handoff.md）
  → Task Critic（critic-prompt-template.md + {rubric_path}）
  → pass 退出 | fail 仅修 fail 项 | 第3轮仍 fail → escalate
结束后: [write_usage_log.sh](references/rubric-usage-log-write.md) → verification-before-completion（若已安装）
```

## Critic 派发（必须）

1. Read [critic-prompt-template.md](references/critic-prompt-template.md) + [critic-subagent-matrix.md](references/critic-subagent-matrix.md)
2. 选定 `subagent_type`（**禁止** executor/build-fixer/debugger 等，见矩阵）
3. Task：`readonly: true`，prompt 含 `{rubric_path}`（与 Handoff 一致）
4. 输出 [critic-feedback-format.md](references/critic-feedback-format.md)；编排者不得代填

## Generator Optimize

- 只修 Critic 列出的 `fail` 项，注明 `rubric_id`
- 禁止 scope creep；每轮必须再跑 Critic

## 硬性门禁

| 门禁 | 规则 |
|------|------|
| 角色 | Critic 不改代码；Generator 不自评 pass |
| Rubric | 只读 `rubric-instances/{task-id}-rubric.md`（[rubric-resolution.md](references/rubric-resolution.md)） |
| 证据 | 无验证输出 → 依赖命令项不得 pass |
| BLOCKER | [blocker-conditions.md](references/blocker-conditions.md) |
| 轮次 | 超 MAX_ITER → [escalate-template.md](references/escalate-template.md) |

## 编排者输出（每轮）

```markdown
## Eval-Optimize — Round {n}/{MAX_ITER}
**Critic**：{subagent_type} · readonly
**结论**：通过 / 未通过 | **BLOCKER**：… | **待修**：{rubric_id…}
```

## 组合与 CI

- Orchestrator：[composition-orchestrator.md](references/composition-orchestrator.md)
- 示例：[docs/examples/01-orchestrator-eval-optimize.md](../../../docs/examples/01-orchestrator-eval-optimize.md)
- Harness：Skill 定 rubric；CI evalset 定硬门禁

## 复盘与维护

- 复盘：[retrospective-evolution.md](references/retrospective-evolution.md)
- 规则变更后：`make validate-eval-gate REASON=…`（[rubric-change-gate.md](references/rubric-change-gate.md)）
- 仓库维护：[maintenance-checklist.md](references/maintenance-checklist.md) · 测试用例：[test-prompts.json](test-prompts.json)

## 禁止

- Generator 无 Critic 输出即宣布 pass
- Critic 改仓库 / 同一 context 扮演双角色
- 无 `rubric_id` 的模糊反馈
- 超 MAX_ITER 静默重试
