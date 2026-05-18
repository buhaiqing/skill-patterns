# 附录：术语表与延伸阅读

> [← 返回总览](../summary.md)

---

## 术语表

| 术语 | 含义 |
|------|------|
| **软路由** | 依赖 LLM 根据 `description` 语义选择 Skill |
| **硬门禁** | 明确写出的 BLOCKER 条件，未满足则终止流程 |
| **渐进披露** | 先加载 metadata，再按需读取 references/scripts |
| **Pattern-as-Policy** | 用 Skill 表达模式策略，而非用 Skill 替代运行时 |
| **Evals-as-Code** | 可回归、可 CI 的确定性评测，而非仅靠 LLM 自评 |
| **Handoff** | Worker 完成工作后交给 Orchestrator 的结构化摘要 |
| **Generator** | Critic-Generator 中只负责实现与按反馈修复的角色 |
| **Critic** | 只评测、不改代码的独立 Evaluator subagent（`readonly`） |
| **Critic-Generator** | Generator + Critic 双角色迭代；同 Evaluator-Optimizer |
| **meta-skill** | 编排多个下游 Skill 顺序与门禁的顶层 Skill |
| **skills-matrix** | 任务类型 → Skill 组合的对照表 |
| **L0 / L1 路由** | L0=description 触发；L1=Router Skill 内部分型 |

## 五种模式速览

| # | 模式 | 文档 |
|---|------|------|
| — | Agent Skill 基础 | [00-foundation.md](./00-foundation.md) |
| 1 | Prompt Chaining | [01-prompt-chaining.md](./01-prompt-chaining.md) |
| 2 | Routing | [02-routing.md](./02-routing.md) |
| 3 | Parallelization + Voting | [03-parallelization.md](./03-parallelization.md) |
| 4 | Orchestrator-Workers | [04-orchestrator-workers.md](./04-orchestrator-workers.md) |
| 5 | Evaluator-Optimizer | [05-evaluator-optimizer.md](./05-evaluator-optimizer.md) |
| — | 实践与反模式 | [06-practices.md](./06-practices.md) |

### 示例

| 示例 | 文档 |
|------|------|
| Plan → Orchestrator → Critic-Generator | [examples/01-orchestrator-eval-optimize.md](./examples/01-orchestrator-eval-optimize.md) |

## 延伸阅读

| 资源 | 路径 / 说明 |
|------|------------|
| Cursor Skill 创作 | `~/.cursor/skills-cursor/create-skill/SKILL.md` |
| Agno Skills 与 SkillOps | `agno-best-practices/references/24_agno_skills_and_skillops.md` |
| 并行派发 | `superpowers/dispatching-parallel-agents` |
| 子 Agent 驱动开发 | `superpowers/subagent-driven-development` |
| 完成前验证 | `superpowers/verification-before-completion` |
| DOPS 路由范例 | `dops-task-router` |
| 文件型规划 | `planning-with-files` |

## 文档版本

| 版本 | 日期 | 说明 |
|------|------|------|
| 1.0 | 2026-05-18 | 初版单文件 summary.md |
| 1.1 | 2026-05-18 | 拆分为 docs/ 多文件结构 |
| 1.2 | 2026-05-18 | Pattern 5 对齐 Critic-Generator；eval-optimize-loop 双角色 Skill |
