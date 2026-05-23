# Round 0 门禁（进入 Round 1 前必须通过）

> 对应 P0 根因：**未实例化**或 **Critic 仍读母版/rubric.md** 导致 rubric_id 错位。

## 门禁清单

| # | 检查项 | 通过标准 |
|---|--------|----------|
| G1 | 实例文件存在 | `references/rubric-instances/{task-id}-rubric.md` |
| G2 | 实例头完整 | 含 `template_id`、`template_version`、`template_path` |
| G3 | 占位符已填充 | 无未替换的 `{TEST_CMD}` 等 |
| G4 | 用户已确认 | `confirm_status: confirmed`（非 `pending`） |
| G5 | Handoff 将使用同一路径 | `rubric_path` 与 G1 完全一致 |

## 推荐命令（确定性，避免 Agent 手抄）

```bash
# 1. 实例化
./scripts/instantiate_rubric.sh T3 ops-incident-response
# 或默认 rubric
./scripts/instantiate_rubric.sh trivial --default

# 2. 编辑实例：填充占位符，并将 confirm_status 改为 confirmed

# 3. 门禁自检（未通过则禁止派发 Critic）
./scripts/check_round0_gate.sh T3
```

## 编排者声明（进入 Round 1 前对用户可见）

```text
Round 0 已通过：Active rubric = references/rubric-instances/{task-id}-rubric.md
template_id = {id}
```

未输出上述声明即派发 Critic → **流程违规**。
