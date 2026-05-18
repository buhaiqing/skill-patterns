---
name: parallel-dispatch
description: >-
  Identifies independent problem domains and dispatches parallel worker subagents
  with isolated context. Use when 2+ unrelated failures or subtasks exist, when
  investigations can run without shared mutable state, or when the user asks for
  parallel agent execution.
---

# Parallel Dispatch

Parallelization 模式的编排 Skill。**真并行依赖 Task / 子 Agent 平台能力。**

> 模式文档：[docs/03-parallelization.md](../../../docs/03-parallelization.md)

## 开场白（必须）

「使用 parallel-dispatch 并行派发独立子任务。」

## 何时使用

**使用**（须同时满足）：
- 2+ 个**相互独立**的问题域（不同测试文件、不同子系统、不同 bug）
- 理解一个域**不需要**另一个域的上下文
- 无共享可变状态（或已用 worktree 隔离）

**禁止使用**：
- 失败可能同源（修一个可能修全部）
- 会改同一文件 / 同一配置
- 需要先全局理解再动手

## 决策流程

```text
1. 列出所有子问题
2. 按「域」分组（见 references/domain-grouping.md）
3. 若仅 1 域 → 单 Agent，不并行
4. 若 2+ 域且独立 → 进入并行派发
5. 为每域构造隔离 prompt（references/worker-packet-template.md）
6. 同一轮中并行 Task × N（禁止串行假装并行）
7. 收集 handoff → 冲突检测 → 集成
```

## 并行派发协议

对每个独立域：

```text
Task(
  description="简短标题",
  prompt=<按 worker-packet-template 填充>,
  subagent_type=<按域选择，如 generalPurpose / explore / build-fixer>
)
```

**硬性约束**：
- Worker **不得**继承父会话完整历史
- 每 Worker 只给：目标、范围、约束、验收标准
- 同一 message 内发起多个 Task（真并行）

## Handoff 要求

每个 Worker 返回须含：
- 摘要（1–3 句）
- 变更文件列表
- 验证命令输出
- 风险与未决项

## 集成（父 Agent）

1. 读取所有 Worker 摘要
2. 检查文件冲突 — 有冲突则串行解决或 escalate
3. 运行集成验证（全量测试）
4. 输出「并行派发结果」表

```markdown
## 并行派发结果

| 域 | Worker | 状态 | 摘要 |
|----|--------|------|------|
| A  | …      | ok   | …    |
```

## 与 vote-synthesis 的关系

若需对**同一问题**多路求解后表决 → 用 `vote-synthesis`，**不是**本 Skill。

## 禁止

- 共享上下文下重复调用冒充多路并行
- 并行改同一分支同一文件且无 worktree
- 未收集全部 Worker 结果即宣称整体完成
