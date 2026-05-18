# 实践建议、反模式与 Skill 目录规划

> [← 返回总览](../summary.md)

---

## 按优先级 Skill 化

| 优先级 | 模式 | 理由 |
|--------|------|------|
| P0 | Prompt Chaining | ROI 最高，Skill 主战场 |
| P0 | Routing | 企业 SOP 集中、可审计 |
| P0 | Evaluator-Optimizer | 质量门禁、与 CI 衔接 |
| P1 | Orchestrator-Workers | 复杂任务拆工，需配套 Task |
| P2 | Parallelization + Voting | 需平台与脚本，成本较高 |

## 推荐仓库目录

```text
patterns/
├── summary.md                          # 总览索引
├── docs/                               # 模式文档（本目录）
│   ├── 00-foundation.md
│   ├── 01-prompt-chaining.md
│   ├── 02-routing.md
│   ├── 03-parallelization.md
│   ├── 04-orchestrator-workers.md
│   ├── 05-evaluator-optimizer.md
│   ├── 06-practices.md
│   └── appendix.md
│
└── skills/                             # ✅ 可落地的 Skill 脚手架 → [skills/README.md](../skills/README.md)
    ├── chaining/delivery-chain/
    ├── routing/task-router/
    ├── parallel/
    │   ├── parallel-dispatch/
    │   └── vote-synthesis/
    ├── orchestration/orchestrator/
    └── evaluation/eval-optimize-loop/
```

## 反模式（避免）

| 反模式 | 风险 | 正确做法 |
|--------|------|---------|
| 一个巨型 Skill 包打五种模式 | 难维护、难触发、description 模糊 | 按 Pattern 拆 Skill，用 matrix 组合 |
| 用 Skill 代替 Eval CI | 无法回归、标准漂移 | Skill 写 rubric，CI 跑 evalset |
| 并行却不隔离上下文 | 投票/子任务 correlated | 每 Worker 独立 prompt，不继承父历史 |
| 仅靠 description 做高风险路由 | 误路由成本高 | L1 规则脚本 + 低置信度人工确认 |
| 无中间文件的 Prompt Chain | context 爆、跳步 | plan.md / findings.md 等文件态 |
| Generator 自评即 pass（无 Critic） | 自我偏好 | Critic-Generator：`eval-optimize-loop` + readonly Critic subagent |

## 模式组合速查

| 场景 | 推荐组合 |
|------|---------|
| 新功能从零交付 | Chaining → Evaluator |
| 运维工单分流 | Routing → Orchestrator → 领域 Worker |
| 多文件独立测试失败 | Parallelization → Orchestrator 汇总 |
| 高 stakes 答案 | Voting → Evaluator 聚合 |
| 大计划分步实现 | Orchestrator → 每步 Evaluator |

## 生态内参考 Skill 一览

| Pattern | Skill / 机制 |
|---------|-------------|
| Prompt Chaining | `brainstorming` → `writing-plans` → `executing-plans` |
| Routing | `dops-task-router` |
| Parallelization | `dispatching-parallel-agents` + Task |
| Orchestrator-Workers | `subagent-driven-development`、`executing-plans` |
| Evaluator-Optimizer (Critic-Generator) | `eval-optimize-loop`、`verification-before-completion`、`code-reviewer` |

## 最终结论表

| 模式 | 契合度 | 一句话 |
|------|--------|--------|
| Prompt Chaining | 极高 | Skill 主战场 |
| Routing | 极高 | Router Skill + 可选确定性分类器 |
| Parallelization + Voting | 中等 | Skill 规程 + 平台并行 + 聚合脚本 |
| Orchestrator-Workers | 高 | meta-skill + Worker Skill + Task |
| Evaluator-Optimizer | 高 | Skill rubric + Harness 硬评测 |

**五种模式都应使用 Agent Skill 承载策略层与组合层；生产级可靠运行必须叠加平台能力与代码化硬语义。**

---

**附录**：[术语表与延伸阅读](./appendix.md)
