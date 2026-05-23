# Rubric 选择器指南

## 1. 匹配流程

**L1 确定性匹配（优先）**：

```bash
./scripts/match_rubric_template.py "用户任务描述"
# 或: make match-rubric QUERY='修复订单 bug'
```

脚本输出 `action`（direct / confirm / generate）、`template_id`、`score`。  
Agent **不得**自行估算 0.73 等相似度覆盖脚本结果；仅可在 `confirm` 时辅助用户选择。

```text
用户输入 → match_rubric_template.py（L1）
    ↓
┌─────────────────────────────────────┐
│ 决策（与脚本 action 一致）            │
│ - direct:  score ≥ 0.8              │
│ - confirm: 0.5 ≤ score < 0.8       │
│ - generate: score < 0.5             │
└─────────────────────────────────────┘
    ↓
L1 无命中或 generate → 意图识别 + 动态生成（generator-prompt.md）
```

## 2. 匹配规则

### 2.1 行业识别

| 关键词 | 行业 |
|--------|------|
| 故障, 告警, 部署, 配置, 监控, 线上问题 | ops |
| 交易, 资金, 风控, 清算, 对账, 监管 | finance |
| 策略, 回测, 因子, 实盘, 夏普, VaR | quant |
| bug, feature, refactor, 开发 | generic |

### 2.2 场景识别

| 行业 | 关键词 | 场景 |
|------|--------|------|
| ops | 故障, 告警, 响应, P0, P1 | incident-response |
| ops | 配置, 参数, 修改 | config-change |
| ops | 部署, 上线, 发布 | deployment |
| finance | 交易, 撮合, 订单 | trade-system |
| finance | 风控, 限额, 拦截 | risk-control |
| quant | 回测, 策略, 因子 | strategy-backtest |
| quant | 实盘, 成交, 滑点 | live-trading |
| generic | bug, 修复, 缺陷 | bug-fix |
| generic | 功能, 特性, 开发 | feature |

### 2.3 相似度计算（L1 实现）

```text
score = 命中关键词数 / 该模板 keywords 总数
若 命中数 ≥ 2 → score = max(score, 0.85)

阈值: ≥0.8 direct | ≥0.5 confirm | <0.5 generate
```

实现：`scripts/match_rubric_template.py`。语义向量匹配**不作为**默认路径。

## 3. 用户交互

### 3.1 精确匹配

```text
AI: 已识别为「运维-应急响应」场景，使用 rubric-incident-response.md
     [确认] [查看详情] [换其他]
```

### 3.2 模糊匹配

```text
AI: 找到以下匹配项，请选择：
     1. ops-incident-response (相似度 0.85)
     2. ops-config-change (相似度 0.65)
     3. 生成新模板
     
用户: 1
```

### 3.3 无匹配

```text
AI: 未找到匹配的 rubric 模板。
     输入场景描述，我将为您生成新模板。
     
用户: 「AI模型推理服务上线，需要A/B测试和特征监控」
     ↓
     触发 generator-prompt.md 生成新模板
```

## 4. 复盘触发

### 4.1 手动触发

```text
用户: 「复盘」
AI: 可复盘模板：
     1. ai-ml-model-deployment (使用 5 次)
     2. finance-trade-system (使用 3 次)
     
用户: 「复盘 ai-ml-model-deployment」
     ↓
     触发 evolution-analyzer.md
```

### 4.2 自动建议

```text
AI: 模板「ops-incident-response」已使用 5 次，建议复盘优化。
     是否执行复盘？[Y/n]
```

## 5. 进化流程

```text
使用模板 → 记录日志 → 达到阈值 → 触发复盘 → 生成建议
                                            ↓
                              用户决策：[应用/编辑/忽略]
                                            ↓
                              更新模板 → 版本+1 → 继续循环
```
