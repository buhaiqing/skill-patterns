# 复盘与模板进化

> 从 `SKILL.md` 渐进披露。规则变更后必须 [rubric-change-gate.md](./rubric-change-gate.md)。

## 触发

| 输入 | 行为 |
|------|------|
| 「复盘」 | 列出可复盘模板（有 usage log 者） |
| 「复盘 {template-id}」 | 分析该模板 |
| 「推荐复盘」 | 推荐 usage_count 最高者 |
| 自动建议 | 使用 ≥5 次或距上次复盘 >30 天 |

## 流程

```text
Step 1: 读取 rubric-usage-logs/{template-id}-*.yaml
Step 2: 统计分析（次数/成功率/评分/高频 fail 项）
Step 3: evolution-analyzer.md 生成报告
Step 4: 用户决策 [应用] [编辑] [忽略]
Step 5: 若改模板/registry → run_rubric_change_gate.sh "post-retrospective"
Step 6: 更新 _registry.yaml version
```

**只读复盘**（[忽略]）不跑 validate_all。  
分析 Prompt 全文见 [rubric-generator/evolution-analyzer.md](./rubric-generator/evolution-analyzer.md)。

## 进化周期

```text
v1.0 → 使用积累 → 复盘 → [应用] → validate 全绿 → v1.1 → …
```
