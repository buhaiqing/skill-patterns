# Agent Design Patterns — Skill 脚手架

本目录提供 **6 个**可安装的 Agent Skill，与 [`docs/`](../docs/) 中五种设计模式一一对应。  
Skill 负责**规程、门禁与组合**；真并行、硬路由、Critic 派发、CI 评测依赖平台与脚本。

> 仓库总览：[summary.md](../summary.md)

---

## Skill 一览

| Pattern | Skill 名 | 目录 | 模式文档 |
|---------|----------|------|----------|
| Prompt Chaining | `feature-delivery-chain` | [chaining/delivery-chain](./chaining/delivery-chain/) | [01-prompt-chaining](../docs/01-prompt-chaining.md) |
| Routing | `task-router` | [routing/task-router](./routing/task-router/) | [02-routing](../docs/02-routing.md) |
| Parallelization | `parallel-dispatch` | [parallel/parallel-dispatch](./parallel/parallel-dispatch/) | [03-parallelization](../docs/03-parallelization.md) |
| Voting | `vote-synthesis` | [parallel/vote-synthesis](./parallel/vote-synthesis/) | [03-parallelization](../docs/03-parallelization.md) |
| Orchestrator-Workers | `orchestrator` | [orchestration/orchestrator](./orchestration/orchestrator/) | [04-orchestrator-workers](../docs/04-orchestrator-workers.md) |
| Evaluator-Optimizer (**Critic-Generator**) | `eval-optimize-loop` | [evaluation/eval-optimize-loop](./evaluation/eval-optimize-loop/) | [05-evaluator-optimizer](../docs/05-evaluator-optimizer.md) |

---

## 快速安装（Cursor）

在**目标项目**根目录执行（按需删减）：

```bash
REPO=/path/to/patterns
DEST=.cursor/skills

mkdir -p "$DEST"
cp -r "$REPO/skills/chaining/delivery-chain"              "$DEST/delivery-chain"
cp -r "$REPO/skills/routing/task-router"                  "$DEST/task-router"
cp -r "$REPO/skills/parallel/parallel-dispatch"           "$DEST/parallel-dispatch"
cp -r "$REPO/skills/parallel/vote-synthesis"              "$DEST/vote-synthesis"
cp -r "$REPO/skills/orchestration/orchestrator"           "$DEST/orchestrator"
cp -r "$REPO/skills/evaluation/eval-optimize-loop"        "$DEST/eval-optimize-loop"
```

如果你已经使用 `skills` CLI，也可以直接通过 `npx` 安装单个 Skill：

```bash
npx skills add https://github.com/buhaiqing/skill-patterns --skill routing/task-router
```

本仓库 Cursor Agent 预置副本： [`.agents/skills/`](../.agents/skills/)（与 `skills/` 保持同步）。

### Agno

```python
from agno.skills import Skills, LocalSkills

agent = Agent(
    skills=Skills(loaders=[
        LocalSkills("/path/to/patterns/skills/chaining"),
        LocalSkills("/path/to/patterns/skills/routing"),
        # … 按子目录加载
    ]),
)
```

---

## 推荐使用顺序

1. **先读 docs** — 理解「Skill ≠ 运行时」与三层架构（Skill / 平台 / 代码）。
2. **定制 `references/`** — 替换 `{TEST_CMD}`、`{TASK_TYPE}` 等项目占位符。
3. **按场景组合 Skill** — 见下表。
4. **硬语义外置** — 路由脚本、投票聚合、CI evalset 不写在 SKILL 里代替执行。

---

## 模式组合

| 场景 | Skill 链 |
|------|----------|
| 新功能交付 | `delivery-chain` → （实现后）`eval-optimize-loop` |
| 工单分流 | `task-router` → `orchestrator` → 领域 Worker |
| 多路独立调查 | `parallel-dispatch` → `vote-synthesis` |
| **多任务 plan 执行 + 质量门** | `orchestrator` → 每任务 `eval-optimize-loop` |
| 合并 / 宣称完成前 | `eval-optimize-loop` → `verification-before-completion`（若已安装） |

### Critic-Generator 要点（`eval-optimize-loop`）

| 角色 | 谁 | 禁止 |
|------|-----|------|
| **Generator** | 主 Agent 或 Worker subagent | 自评 rubric 通过 |
| **Critic** | 独立 Task subagent，`readonly: true` | 改代码、commit |

关键 `references/`：

- `rubric.md` — pass/fail 标准  
- `critic-prompt-template.md` / `critic-feedback-format.md` — 派发与可执行反馈  
- `generator-handoff.md` — Generator → Critic 输入包  
- `composition-orchestrator.md` — 与 orchestrator 组合规程  

### Orchestrator × Eval（推荐读）

端到端 walkthrough（基于仓库 [plan.md](../plan.md)）：

**[docs/examples/01-orchestrator-eval-optimize.md](../docs/examples/01-orchestrator-eval-optimize.md)**

```text
plan.md → orchestrator 并行 Worker → 每任务 Critic 循环 → 集成 Critic → 报告
```

组合规程：

- Orchestrator 侧：[orchestrator/references/composition-eval-loop.md](./orchestration/orchestrator/references/composition-eval-loop.md)  
- Eval 侧：[eval-optimize-loop/references/composition-orchestrator.md](./evaluation/eval-optimize-loop/references/composition-orchestrator.md)  

---

## 各 Skill 的 `references/` 摘要

| Skill | 主要 references |
|-------|-----------------|
| `delivery-chain` | 链式步骤与门禁 |
| `task-router` | 路由矩阵；`scripts/classify.py`（可选硬路由） |
| `parallel-dispatch` | 域分组、worker-packet-template |
| `vote-synthesis` | rubric；`scripts/aggregate_votes.py` |
| `orchestrator` | skills-matrix、worker-prompt、handoff-format、composition-eval-loop |
| `eval-optimize-loop` | rubric、max-iterations、blocker-conditions、critic/generator 模板、composition-orchestrator |

---

## 依赖的平台能力

| 能力 | 用于 |
|------|------|
| Task / 子 Agent | `parallel-dispatch`、`orchestrator`、**`eval-optimize-loop`（Critic）** |
| `readonly: true` | Critic 派发（eval-optimize-loop） |
| TodoWrite | `orchestrator`、`delivery-chain` |
| 并行 tool call | `parallel-dispatch` |
| 外部 Eval CI | `eval-optimize-loop` 合并前门 |

---

## 反模式（速查）

| 避免 | 改做 |
|------|------|
| 一个巨型 Skill 包打所有模式 | 按 Pattern 拆分，用组合表串联 |
| Worker / Generator 自评即 pass | Task 派发 readonly Critic |
| 无 `rubric_id` 的模糊评审 | `critic-feedback-format` 可执行缺陷 |
| 仅用 Skill 代替 CI | Skill 写 rubric，CI 跑 evalset |

更多见 [docs/06-practices.md](../docs/06-practices.md)。

---

## 文档索引

| 资源 | 链接 |
|------|------|
| 总览与架构 | [summary.md](../summary.md) |
| 模式详解 | [docs/](../docs/) |
| 术语表 | [docs/appendix.md](../docs/appendix.md) |
| 端到端示例 | [docs/examples/01-orchestrator-eval-optimize.md](../docs/examples/01-orchestrator-eval-optimize.md) |
