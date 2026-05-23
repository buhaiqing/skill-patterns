# eval-optimize-loop × Orchestrator 组合规程

> 端到端示例：[docs/examples/01-orchestrator-eval-optimize.md](../../../../docs/examples/01-orchestrator-eval-optimize.md)

## 输入从哪来

| 来源 | 用作 |
|------|------|
| Worker handoff | 转为 `generator-handoff.md` 的「变更范围」「验证证据」 |
| plan.md 任务条 | handoff 中「任务与 spec」、Critic 评 R2 |
| Worker `allowed_paths` | Critic 允许读取范围、范围类 rubric 项 |
| Round 0 实例 | `rubric-instances/{task-id}-rubric.md` → Handoff Active Rubric（见 rubric-resolution.md） |

Worker handoff **不等于** Critic 通过；必须再走 Critic Task（Critic 只读 rubric **实例**）。

## 每任务 vs 集成

| 类型 | generator-handoff 标题 | rubric 侧重 |
|------|------------------------|------------|
| 单任务 | `Round {n} — Task {id}` | 该任务验收 + 任务内 diff |
| 集成 | `Integration` | plan 全覆盖、跨任务越界、全量验证命令 |

## 编排者调用本 Skill 的开场白

```text
对 Task {id} 运行 eval-optimize-loop：
Worker handoff 已附；allowed_paths={paths}；
派发 readonly Critic，禁止 Generator 自评 pass。
```

## MAX_ITER 作用域

- **每个 plan 任务**单独计数 MAX_ITER（默认 3）
- 集成阶段视为**新的一次** eval-optimize-loop，重新从 round 1 开始

## escalate 时

- 编排者停止标记后续 plan 任务为 done
- 输出 escalate-template，列出 plan 任务 ID
- 可选：在 plan.md 追加子任务「人工澄清后重跑 T3」
