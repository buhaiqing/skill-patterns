# Orchestrator × eval-optimize-loop 组合规程

> 端到端示例：[docs/examples/01-orchestrator-eval-optimize.md](../../../../docs/examples/01-orchestrator-eval-optimize.md)

## 何时挂载 Critic

| 策略 | 做法 |
|------|------|
| **每任务后**（推荐，本仓库示例） | Worker handoff 粗审通过 → 对该任务 `allowed_paths` 跑 eval-optimize-loop |
| **全量结束后** | 全部 Worker done → 仅一次集成 eval-optimize-loop |
| **双阶段** | 每任务 Critic + 集成 Critic（高 stakes） |

## 编排者流程（每任务）

```text
1. Task 派发 Worker（worker-prompt-template.md）
2. 收 Worker handoff → 粗审（证据、越界、验收字面）
3. 粗审 pass → 将 handoff 转为 generator-handoff.md 格式
4. Task 派发 Critic（eval-optimize-loop / critic-prompt-template.md, readonly）
5. Critic pass → TodoWrite 标记该任务 done
6. Critic fail → 同一 Worker 或新 Task 仅修 rubric_id → 回到 3（该任务独立 MAX_ITER）
```

## 并行 plan

- 无依赖任务：并行 Worker（`parallel-dispatch`）
- **每个任务的 Critic 循环独立**，不可共用 round 计数
- 全部任务 done 后：集成验证 + 可选全量 Critic

## 职责边界

| 组件 | 做什么 | 不做什么 |
|------|--------|---------|
| Worker | 实现/审计子任务，输出 handoff | 代替 Critic 宣布 rubric pass |
| 编排者 | 派发、粗审、转 handoff、派 Critic、Todo | 替 Critic 填评测表 |
| Critic | rubric 评测、可执行缺陷 | 改代码、mark plan 完成 |

## 完成条件

- 所有 plan 任务 Todo done
- 每项均经 Critic pass（或 escalate 已人工处理）
- 集成 eval-optimize-loop pass（若采用双阶段）
- `verification-before-completion`（若已安装）
