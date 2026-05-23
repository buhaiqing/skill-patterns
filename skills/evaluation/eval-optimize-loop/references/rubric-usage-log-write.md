# Rubric 使用日志 — 写入规程

复盘（`evolution-analyzer.md`）依赖本目录下的 YAML 日志。无写入则无复盘数据。

## 何时写

| 时机 | 是否必须 |
|------|----------|
| Eval-Optimize **结束**（pass / fail / escalate） | **必须** |
| 仅 Round 0 未完成、未进入 Round 1 | 不写 |
| 用户中途取消整个循环 | 建议写，`outcome: fail`，`user_feedback` 注明取消 |

## 谁写

**编排者**（父 Agent）在 Critic 结论落定后写入；Generator 与 Critic **均不得**省略此步。

## 写到哪里

```text
references/rubric-usage-logs/{template_id}-{YYYYMMDD-HHMMSS}.yaml
```

同一 `task_id` 只保留**一条**终态日志（若重跑任务，新文件新时间戳）。

**推荐**：用脚本生成，避免漏字段：

```bash
./scripts/write_usage_log.sh \
  --template-id ops-incident-response \
  --task-id T3 \
  --rubric-instance references/rubric-instances/T3-rubric.md \
  --outcome pass \
  --rounds 2 \
  --failed-ids ""
```

## 字段

严格遵循 [rubric-usage-log-schema.yaml](./rubric-usage-log-schema.yaml)。

`failed_rubric_ids`：取**最后一轮** Critic 评测表中 `fail` 的 `rubric_id`（通过则为 `[]`）。

`template_id`：来自 rubric 实例头或 Handoff 的 `template_id`（默认 rubric 用 `generic-default`）。

`write_usage_log.sh` 默认会将 `_registry.yaml` 中对应模板的 `usage_count` +1（`--no-bump-registry` 可关闭），供「推荐复盘」「≥5 次」使用。

## 写后（可选）

更新 `_registry.yaml` 中对应模板的 `usage_count`（+1）；`avg_rating` 若有 `user_rating` 则滚动平均。无法改 registry 时仅保留 YAML 即可。

## 与 SKILL 衔接

SKILL.md「循环协议」在退出循环（pass 或 escalate）后执行本规程，再进入 `verification-before-completion` 或向用户汇报。
