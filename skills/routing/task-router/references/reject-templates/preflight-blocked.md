# Preflight 未通过 — 输出模板

```markdown
> **⛔ Preflight 未通过（不通过）** — {one_line_reason}

## Preflight 结论

| 字段 | 值 |
|------|-----|
| Preflight 结论 | 未通过 |
| 可否进入执行 | 否 |
| BLOCKER | {list} |

## 详情

{table of failed checks}

## 建议下一步

{what user needs to provide or fix}
```

**禁止**在 BLOCKER 存在时加载执行类 Skill 或调用破坏性工具。
