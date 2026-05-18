---
name: orchestrator
description: >-
  Decomposes implementation plans into tasks and dispatches isolated worker
  subagents with structured handoffs. Use when executing multi-task plans,
  subagent-driven development, or when independent plan items need Task dispatch.
---

# Orchestrator

Orchestrator-Workers 模式的 meta-skill。

> 模式文档：[docs/04-orchestrator-workers.md](../../../docs/04-orchestrator-workers.md)

## 开场白（必须）

「使用 orchestrator 按 plan 派发 Worker 子任务。」

## Orchestrator 职责

```text
1. 读取 plan（plan.md 或用户给定），提取**全部任务全文**
2. 分析任务依赖 → 构建执行顺序（无依赖可并行）
3. 创建 TodoWrite，每项任务一条
4. 按序或并行派发 Worker（Task + 隔离 prompt）
5. 审查每份 handoff → 冲突检测 → 合并
6. 全部完成后：全量验证 + 可选 code-reviewer
```

## 硬性约束

| 约束 | 说明 |
|------|------|
| 上下文隔离 | Worker **不得**继承父会话完整历史 |
| 单一职责 | 每 Worker 一个任务、明确文件边界 |
| Handoff 必填 | 见 [handoff-format.md](references/handoff-format.md) |
| 验证证据 | 无命令输出不得 mark complete |

## 派发流程

### 单任务

1. Read [worker-prompt-template.md](references/worker-prompt-template.md)
2. 填充 `{task_full_text}`、`{allowed_paths}` 等
3. `Task(description=..., prompt=..., subagent_type=...)`
4. 收到 handoff → 对照验收标准 → pass/fail

### 无依赖的多任务

- 同一轮 **并行** Task × N（配合 `parallel-dispatch` 分组规则）
- 全部返回后再集成

### 有依赖的多任务

- 严格按拓扑序串行
- 前置 handoff 中的产物路径传入后置 Worker

## 任务类型 → Worker（可选）

见 [skills-matrix.md](references/skills-matrix.md)。可按 `subagent_type` 或专用 Skill 名派发。

## 评审策略

| 策略 | 何时 |
|------|------|
| 每任务后双评审 | 高风险、大团队（spec + quality） |
| 全量结束后一次评审 | 小改动、任务高度相关 |

双评审流程参考 `subagent-driven-development`（若已安装）。

## 与 eval-optimize-loop 组合

每 Worker handoff 通过后，对该任务运行 **Critic-Generator**（独立 Critic，非 Worker 自评）。

- 规程：[composition-eval-loop.md](references/composition-eval-loop.md)
- 端到端示例：[docs/examples/01-orchestrator-eval-optimize.md](../../../docs/examples/01-orchestrator-eval-optimize.md)

## 完成输出

```markdown
## Orchestrator 执行报告

| 任务 | Worker | 状态 | 验证 |
|------|--------|------|------|
| …    | …      | done | pass |

## 集成验证
{full test command output}

## 未决 / Escalate
- …
```

## 禁止

- 不把 plan 全文交给 Worker 却期望其只做子任务
- 跳过 handoff 审查直接下一任务
- Worker 越界改动未授权路径
