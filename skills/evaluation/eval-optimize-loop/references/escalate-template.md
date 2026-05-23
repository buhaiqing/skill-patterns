# Escalate 输出模板

```markdown
> **⛔ Eval-Optimize 未通过 — 已达最大迭代次数（{MAX_ITER}）**

## 状态

| 字段 | 值 |
|------|-----|
| 轮次 | {n} / {MAX_ITER} |
| 可否合并/完成 | 否 |
| BLOCKER | {list} |

## 仍失败的 Rubric 项（Critic 最后一轮评测表）

| ID | 项 | Critic 失败原因 | Generator 已尝试修复 |
|----|-----|----------------|---------------------|
| … | … | … | … |

## Critic / Generator 分歧（若有）

| rubric_id | Critic | Generator 声称 | 建议 |
|-----------|--------|---------------|------|
| … | fail | fixed | 人工复现验证 |

## 建议下一步

1. {人工选项 A：澄清 spec}
2. {人工选项 B：放宽非 BLOCKER 项}
3. {人工选项 C：拆分任务}

## 附件证据

\`\`\`text
{last verify command output}
\`\`\`

## 编排者（escalate 后仍须执行）

- [ ] `scripts/write_usage_log.sh --outcome escalate ...`（见 rubric-usage-log-write.md）
- [ ] 未写日志不得标记本 Skill 流程结束
```
