# Critic Subagent 选型矩阵（Cursor Task）

> **单一事实来源**：`SKILL.md` 与 `critic-prompt-template.md` 均引用本文件。  
> Critic **必须** `readonly: true`，且 prompt 使用 `critic-prompt-template.md` 填充版。

## 可用于 Critic（只评不改）

| subagent_type | 适用 rubric 侧重 | 典型 template_id / 场景 |
|---------------|------------------|-------------------------|
| `code-reviewer` | 代码质量、逻辑、可维护性、diff 范围 | generic-bug-fix, software-dev-code-review, *-service |
| `quality-reviewer` | 规格/plan 对齐、rubric 符合度、可执行反馈质量 | generic-feature, software-dev-api-design |
| `security-reviewer` | 安全 BLOCKER（密钥、注入、危险 API） | 任意含安全项；finance/ops 生产变更 |
| `test-engineer` | 测试证据、覆盖率、断言与 CI 命令 | generic-bug-fix, *-service（含 PY3/R1 等测试项） |
| `verifier` | 完成门禁、证据链、是否可声称 pass | 与 verification-before-completion 组合时 |
| `generalPurpose` | 无专用 reviewer 时的 fallback | prompt **必须**强调 Critic 角色 + readonly |

## 禁止用于 Critic（会改代码或与角色冲突）

| subagent_type | 原因 |
|---------------|------|
| `executor` | 实现者，非评审者 |
| `build-fixer` | 修复导向，违反只评不改 |
| `debugger` | 排查+常伴随修改 |
| `deep-executor` | 执行实现 |
| `code-simplifier` | 会改代码 |
| `planner` / `architect` | 规划/架构，非 rubric 打分 |
| `explore` | 搜索用，非评审 |
| `shell` | 命令执行，非评审 |
| `writer` | 文档生成，非评审 |
| `designer` | UI 设计，非评审 |
| `git-master` | Git 操作 |
| `qa-tester` | 交互测试执行；若只读评审测试**计划**可用 `test-engineer` |

## 按 rubric 行业/场景的快速映射

| 行业/场景 | 首选 Critic | 次选 |
|-----------|------------|------|
| generic bug-fix | `code-reviewer` | `test-engineer` |
| generic feature | `quality-reviewer` | `code-reviewer` |
| ops incident / deployment | `quality-reviewer` | `verifier` |
| finance / quant（合规、风控） | `quality-reviewer` | `security-reviewer` |
| 语言 *-service | `code-reviewer` | `test-engineer` |
| 明确安全/合规审计 | `security-reviewer` | — |

## 双 Critic（可选，高风险任务）

```text
Round N:
  1) quality-reviewer — 对照 spec / rubric 符合度
  2) code-reviewer 或 security-reviewer — 代码/安全（仅当 1) pass）
任一步 fail → 回到 Generator，计同一 MAX_ITER 轮次。
```

## Task 调用模板

```text
description: "Critic R{n} — {focus}"
subagent_type: {上表选定}
readonly: true
prompt: {critic-prompt-template 填充版，含 {rubric_path}}
```

## Generator 侧（非 Critic）

| 角色 | subagent_type |
|------|---------------|
| 实现/修复 | 主 Agent 或 `executor` |
| Round 0 仅选型 | 主 Agent（不必派发 subagent） |
