# Generator → Critic Handoff 包

Generator 每轮结束、请求 Critic 评测前**必须**组装（编排者可代填）：

```markdown
## Generator Handoff — Round {n}

### 任务与 spec
{task_or_plan_excerpt — 验收标准原文}

### 变更范围
- `path/to/file1` — {one-line purpose}
- `path/to/file2` — …

### Diff 摘要（可选）
{关键逻辑变更 3–5 条，非全文 dump}

### 验证证据（必须）
\`\`\`text
$ {TEST_CMD}
{output + exit code}

$ {LINT_CMD}
{output + exit code}
\`\`\`

### Generator 自检（仅供参考，不作 pass 依据）
| rubric_id | 自评 | 说明 |
|-----------|------|------|
| R1 | pass/fail | … |

### 上轮 Critic 待修项（round > 1）
| rubric_id | 上轮状态 | 本轮声称 |
|-----------|---------|---------|
| R2 | fail | fixed — {evidence} |
```

## 规则

1. **验证证据必须新鲜**：Critic 评测前 Generator 已跑过约定命令
2. Handoff **不得**包含 Generator 与用户的完整闲聊历史；只保留 spec + 产物 + 证据
3. Critic **不得**采信 Generator 自检为 pass；须独立对照 rubric 与证据
