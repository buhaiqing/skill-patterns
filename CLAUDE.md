# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目性质

这是一个 **Agent Design Patterns 的 Skill 化落地指南与脚手架仓库**，不是传统代码项目。核心产出是 `skills/` 目录下的 6 个可安装 Skill 脚手架，以及 `docs/` 目录下的模式详解文档。

## 核心架构概念

### 三层架构（理解 Skill 边界的关键）

```
Skill层（规程/门禁）→ 平台层（Task/子Agent）→ 代码层（确定性）
```

- **Skill 能做的**：描述流程、约束行为、步骤顺序、门禁、组合矩阵、`description` 软路由
- **Skill 不能做的**：保证真并行、持久化、硬循环上限、确定性路由、投票聚合
- **必须外置到代码**：路由脚本、投票聚合、Eval CI、状态机

### Pattern 与 Skill 的正交关系

- **Pattern** = 控制流拓扑（链、叉、并行、环）
- **Skill** = 可版本化的规程与知识包
- 同一 Skill 可参与多种 Pattern

## Skill 文件结构

每个 Skill 目录包含：
- `SKILL.md` — 核心：YAML frontmatter + 分步指令
- `references/` — 渐进披露：模板、rubric、组合规程
- 可选 `scripts/` — 外置硬语义脚本

YAML frontmatter 必须字段：
- `name` — Skill 标识
- `description` — 软路由触发描述

## 6 个 Skill 与模式对应

| Pattern | Skill | 安装路径 |
|---------|-------|----------|
| Prompt Chaining | `delivery-chain` | `skills/chaining/delivery-chain/` |
| Routing | `task-router` | `skills/routing/task-router/` |
| Parallelization | `parallel-dispatch` | `skills/parallel/parallel-dispatch/` |
| Voting | `vote-synthesis` | `skills/parallel/vote-synthesis/` |
| Orchestrator-Workers | `orchestrator` | `skills/orchestration/orchestrator/` |
| Evaluator-Optimizer | `eval-optimize-loop` | `skills/evaluation/eval-optimize-loop/` |

## Skill 组合链（常见场景）

| 场景 | 组合 |
|------|------|
| 新功能交付 | `delivery-chain` → `eval-optimize-loop` |
| 工单分流 | `task-router` → `orchestrator` |
| 多路调查 | `parallel-dispatch` → `vote-synthesis` |
| Plan执行+质量门 | `orchestrator` → 每任务 `eval-optimize-loop` |
| 合并前检查 | `eval-optimize-loop` → `verification-before-completion` |

## 关键约束（修改 Skill 时必须遵守）

### Orchestrator 约束
- Worker **不得**继承父会话完整历史（上下文隔离）
- 每 Worker 一个任务、明确文件边界
- Handoff 必填（见 `references/handoff-format.md`）
- 无命令输出不得 mark complete

### Eval-Optimize-Loop 约束（最重要）
- **Critic 必须独立**：Task 派发 readonly subagent
- **Generator 禁止自评 pass**
- MAX_ITER = 3，超过需 escalate
- Critic 只评不改，Generator 只改不评
- 禁止 scope creep、「顺便重构」
- 每项修复必须注明 `rubric_id`

> **v2.0 更新**: `eval-optimize-loop` 现为 **Rubric 工厂 + 硬校验脚本**：
> - **Round 0**: L1 `scripts/match_rubric_template.py`（或 `make match-rubric`）→ `instantiate_rubric.sh` → `check_round0_gate.sh`；Critic **只读** `rubric-instances/{task-id}-rubric.md`
> - **模板库**: 5 行业，**23** 个模板（`_registry.yaml` 为准）；选型见 `references/critic-subagent-matrix.md`
> - **复盘**: 只读分析不写模板；**[应用]/改规则** 后必须 `make validate-eval-gate`（`references/rubric-change-gate.md`）
> - **usage_count**: `write_usage_log.sh` 默认 bump registry，供「≥5 次推荐复盘」
> - **校验**: 仓库根 `make validate-eval` = `scripts/validate_all.sh`（含 match fixtures、test-prompts）；PR 有 CI

### Parallelization 约束
- 真并行依赖平台（Task 并行调用）
- 投票聚合必须外置脚本（`scripts/aggregate_votes.py`）
- Skill 只描述并发规程，不保证并发执行

## 文档组织

- `summary.md` — 总览索引，从这开始
- `docs/00-foundation.md` — Skill 能力边界定义
- `docs/01-06.md` — 各模式详解
- `docs/06-practices.md` — 反模式速查
- `docs/examples/` — 端到端 walkthrough
- `skills/README.md` — 安装指南

## 修改 Skill 的检查清单

1. YAML frontmatter 的 `name`/`description` 是否更新
2. 关联的 `docs/` 文档是否同步版本
3. 新增 `references/` 是否在 SKILL.md 中正确引用
4. 是否违反关键约束（Critic独立、MAX_ITER、handoff必填）
5. 组合规程（`composition-*.md`）是否同步更新
6. 若改动 `eval-optimize-loop`：仓库根 `make validate-eval`（或 `make validate-eval-gate REASON=…`）；新增/改 rubric 须同步 `_registry.yaml` 且 path 有对应 `.md` 文件

## 反模式速查

| 避免 | 改做 |
|------|------|
| 一个巨型 Skill 包打所有模式 | 按 Pattern 拆分，用组合矩阵串联 |
| Worker / Generator 自评即 pass | Task 派发 readonly Critic |
| 无 rubric ID 的模糊评审 | `critic-feedback-format` 可执行缺陷 |
| 仅靠 `description` 做高风险路由 | L1 脚本兜底（如 `match_rubric_template.py`、`task-router` 的 classify）→ 低置信人工确认 |
| Skill 代替 CI evalset | Skill 写 rubric，CI 跑 evalset |

## 各 Skill 的 references/ 摘要

| Skill | 主要 references 文件 | 用途 |
|-------|---------------------|------|
| `delivery-chain` | 链式步骤与门禁模板 | 步骤顺序、中间产物验证 |
| `task-router` | 路由矩阵；`scripts/classify.py` | 软路由 + 确定性分类器兜底 |
| `parallel-dispatch` | 域分组、worker-packet-template | 并发规程描述 |
| `vote-synthesis` | rubric；`scripts/aggregate_votes.py` | 投票标准 + 外置聚合 |
| `orchestrator` | skills-matrix、worker-prompt、handoff-format、composition-eval-loop | 分派策略 + 组合规程 |
| `eval-optimize-loop` | rubric 工厂、`critic-subagent-matrix`、`round-0-rubric-factory`、`rubric-change-gate`、`scripts/`（match/validate/gate）、`composition-orchestrator` | 评审标准 + Critic 派发 + CI 校验 |

## 依赖的平台能力

| 能力 | 用于哪个 Skill |
|------|---------------|
| Task / 子 Agent | `parallel-dispatch`、`orchestrator`、`eval-optimize-loop`（Critic） |
| `readonly: true` 派发 | `eval-optimize-loop`（Critic 必须独立） |
| TodoWrite | `orchestrator`、`delivery-chain` |
| 并行 tool call | `parallel-dispatch` |
| 外部 Eval CI | `eval-optimize-loop` 合并前门 |

## 推荐使用顺序

1. **先读 docs** — 理解「Skill ≠ 运行时」与三层架构
2. **定制 `references/`** — 替换 `{TEST_CMD}`、`{TASK_TYPE}` 等项目占位符
3. **按场景组合 Skill** — 见 Skill 组合链表
4. **硬语义外置** — 路由脚本、投票聚合、CI evalset 不写在 SKILL 里代替执行

## 平台兼容性

| 平台 | 安装路径 | 说明 |
|------|---------|------|
| Cursor | `.cursor/skills/<skill-name>/` | 原生支持 |
| Claude Code | `.agents/skills/` 或 `~/.claude/skills/` | 原生支持 |
| OpenCode | 按软件包规范放置 | 原生支持 |
| Agno | `LocalSkills()` loader | SDK 加载 |

## 安装 Skill 到目标项目

Cursor 用户：
```bash
# 复制单个 Skill
mkdir -p .cursor/skills/<skill-name>
cp -r skills/<pattern>/<skill-name> .cursor/skills/<skill-name>

# 或使用 npx
npx skills add https://github.com/buhaiqing/skill-patterns --skill routing/task-router
```

Claude Code 用户：
```bash
# 放到 .agents/skills/ 或 ~/.claude/skills/
```

Agno 用户：
```python
from agno.skills import Skills, LocalSkills

agent = Agent(
    skills=Skills(loaders=[
        LocalSkills("/path/to/patterns/skills/chaining"),
        LocalSkills("/path/to/patterns/skills/routing"),
    ]),
)
```