---
name: task-router
description: >-
  Classifies incoming tasks by type and routes to the correct skill chain via
  a skills matrix. Use when handling multi-type workflows, support tickets, ops
  tasks, or when the user needs task-type-based dispatch before execution.
---

# Task Router

L0（description 触发）+ L1（本 Skill 内分型）双层路由。

> 模式文档：[docs/02-routing.md](../../../docs/02-routing.md)

## 开场白（必须）

「使用 task-router 对任务进行分型与路由。」

## 硬性门禁

| 条件 | 动作 |
|------|------|
| 无法归入 [keyword-scoring](references/keyword-scoring.md) 中任一类型 | **终止**：说明原因，不调用执行类工具 |
| 置信度 < 阈值（默认 0.6） | 列出候选类型，请用户选择 |
| Preflight BLOCKER | 按 [reject-templates/preflight-blocked.md](references/reject-templates/preflight-blocked.md) 输出后终止 |
| 路由通过 | 按 [skills-matrix](references/skills-matrix.md) 加载下游 Skill |

## 分型流程

```text
1. 读取用户请求 / 工单 / 任务描述
2. Read references/keyword-scoring.md → 计算分型 + 置信度
3. 输出「分型结果」表（见下方模板）
4. Read references/preflight-common.md → L0 Preflight
5. 若存在类型专属 Preflight → Read references/preflight/T{n}-*.md
6. 通过 → Read references/skills-matrix.md → 加载 Skill 链
7. 失败 → 拒绝模板 → 终止
```

## 分型结果输出模板

```markdown
## 任务分型

| 字段 | 值 |
|------|-----|
| 类型 ID | T{n} |
| 类型名称 | {name} |
| 置信度 | {0.0–1.0} |
| 依据 | {keywords / rules matched} |

## Preflight
| 检查项 | 结果 |
|--------|------|
| … | pass / fail |

## 路由决策
- 下游 Skill 链：{from skills-matrix}
- 可否进入执行：是 / 否
```

## 确定性分类（可选）

高风险的 L1 分型可并行运行：

```bash
python scripts/classify.py --input /tmp/task.txt
```

脚本输出优先于纯 LLM 推断；冲突时以脚本为准并记录原因。

## 定制

1. 编辑 `references/keyword-scoring.md` — 增加任务类型与关键词
2. 编辑 `references/skills-matrix.md` — 类型 → Skill 链映射
3. 在 `references/preflight/` 下增加 `T{n}-*.md`

## 禁止

- 低置信度时猜测类型并直接执行
- Preflight 未通过仍加载 `executing-plans` / 写库 / 部署类工具
- 跳过 skills-matrix 随意加载 Skill
