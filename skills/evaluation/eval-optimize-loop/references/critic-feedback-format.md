# Critic → Generator 反馈格式

Critic **必须**输出以下结构（编排者转交 Generator）：

```markdown
## Critic 评测 — Round {n}

| 字段 | 值 |
|------|-----|
| 结论 | 通过 / 未通过 |
| BLOCKER fail | {rubric_id 列表 or 无} |
| 可否进入 merge/完成 | 是 / 否 |

## 评测表

| rubric_id | 项 | 结果 | 证据 |
|-----------|-----|------|------|
| {实例ID} | 测试 | pass/fail | {command + 摘要} |
| {实例ID} | 规格 | … | … |
| … | … | … | … |

## 可执行缺陷（fail 项必填）

| rubric_id | 严重度 | 位置 | 问题 | 建议修复 |
|-----------|--------|------|------|---------|
| {实例ID} | BLOCKER | `path:line` 或 plan § | {具体 gap} | {最小修复方向，不写完整 patch} |
| {实例ID} | normal | `path` | {scope creep 说明} | 回滚 / 移出 diff |

## Generator 下一步

- [ ] 仅修复上表中的 fail 项
- [ ] 修复后重新跑验证命令并更新 Handoff
- [ ] **禁止**扩大范围

## Critic 元数据
- subagent: {type}
- readonly: true
- 未改任何文件: 是
- active_rubric: {与 Handoff rubric_path 一致}
```

## 编排者事后清单（Critic 返回后、回复用户前）

- [ ] 评测表 `rubric_id` 与 **rubric 实例** 表中 ID 一致（不得混用 R1/B1 除非实例即 R 系）
- [ ] 已运行 `scripts/write_usage_log.sh`（pass / fail / escalate 均要写，见 rubric-usage-log-write.md）
- [ ] escalate 时仍写日志，`outcome: escalate`

## 质量要求

| 差 | 好 |
|----|-----|
| 「测试有问题」 | `R1 fail`：`go test ./...` exit 1，`pkg/foo_test.go:42` 断言失败 |
| 「不符合 spec」 | `R2 fail`：plan.md §3.2 要求分页，实现未传 `page` 参数 |
| 「再看看安全」 | `R5 BLOCKER`：`config.yaml:12` 硬编码 API key |

无 `rubric_id`、无位置、无证据的条目视为**无效反馈**——编排者应要求 Critic 重写。
