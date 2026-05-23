# Eval-Optimize Loop（Rubric 工厂模式 v2.0）

> **Critic-Generator 评估-优化循环** — 现已升级为 Rubric 工厂模式

---

## 快速校验（仓库根目录）

```bash
# 全量校验（提交前 / Rubric 规则变更后）
make validate-eval

# 复盘 [应用] 或改模板后
make validate-eval-gate REASON=post-retrospective-ops-incident-response

make help   # 更多目标
```

---

## 新特性（v2.0）

### 1. Rubric 工厂

从单一 rubric 升级为**多行业、多场景、多语言的 rubric 模板库**。

| 维度 | 数量 | 说明 |
|------|------|------|
| 行业分类 | 5 个 | generic / ops / finance / quant / software-dev |
| 场景模板 | 23 个 | Bug修复、应急响应、交易系统、策略回测等（以 `_registry.yaml` 为准） |
| Critic 选型 | 矩阵 | [critic-subagent-matrix.md](references/critic-subagent-matrix.md) |
| L1 模板匹配 | 脚本 | `make match-rubric QUERY='…'` |
| 语言特定 | 4 种 | Python / Go / TypeScript / Rust |
| 最佳实践库 | 8 个 | 各语言详细最佳实践文档 |

### 2. Round 0: Rubric 选择/生成

```
用户输入 → 意图识别 → 匹配模板 → 实例化 → 开始 Round 1
                    ↓（无匹配）
              动态生成新模板 → 用户确认 → 沉淀
```

### 3. 自进化机制

```
使用 5 次 → 触发复盘 → AI 分析日志 → 生成优化建议
                              ↓
              用户决策：[应用] [编辑] [忽略]
                              ↓
              更新模板 → 版本+1 → 继续循环
```

### 4. 语言特定模板

Python / Go / TypeScript / Rust 服务模板含性能与内存相关评测项；其他行业模板按场景定义，见各 `rubric-*.md`。

---

## 快速开始

### 使用现有模板

```bash
用户: 「修复订单金额计算 Bug」
AI:   识别 → 匹配 generic-bug-fix → 实例化 → 开始 Round 1
```

### 动态生成模板

```bash
用户: 「上线区块链交易服务」
AI:   识别 → 无匹配 → 生成 blockchain-trade rubric → 确认 → 沉淀
```

### 复盘优化

```bash
用户: 「复盘 python-service」
AI:   分析使用日志 → 生成报告 → 等待用户决策
```

---

## 模板分类

### 按行业

| 行业 | 场景 | 模板数 |
|------|------|--------|
| **generic** | Bug修复、新功能、重构 | 3 |
| **ops** | 应急响应、配置变更、部署、监控 | 4 |
| **finance** | 交易系统、风控、清算、报表 | 4 |
| **quant** | 策略回测、实盘、数据管道、风险模型 | 4 |
| **software-dev** | 代码审查、API、库迁移、前端 + 4 语言服务 | 8 |

### 按语言（software-dev）

| 语言 | 评测项数 | 特色 |
|------|---------|------|
| **Python** | 12 | Pythonic、Type Hints、高性能 |
| **Go** | 12 | 简洁、组合、Context、高性能 |
| **TypeScript** | 12 | 现代语法、函数式、高性能 |
| **Rust** | 12 | 内存安全、零成本抽象、fearless concurrency |

---

## 目录结构

```
eval-optimize-loop/
├── SKILL.md                    # 核心规程（渐进披露入口）
├── test-prompts.json           # 效果回归用例（CI 校验 match）
├── scripts/                    # validate_all、match、bump usage_count
└── references/
    ├── rubric-templates/       # 23 模板 + _registry.yaml
    ├── rubric-instances/       # 任务实例（gitignore）
    ├── rubric-usage-logs/      # 使用日志（gitignore）
    ├── critic-subagent-matrix.md
    ├── round-0-rubric-factory.md
    ├── retrospective-evolution.md
    ├── rubric-change-gate.md
    └── rubric-generator/
```

---

## 核心流程

### Round 0: Rubric 选择/生成

1. **L1 匹配**: `make match-rubric QUERY='…'`（确定性，优先于 Agent 自算）
2. **实例化**: `instantiate_rubric.sh` → `check_round0_gate.sh`
3. **动态生成**（action=generate）: 见 generator-prompt.md → `validate-eval-gate`

### Round 1+: Eval-Optimize 循环

标准 Critic-Generator 循环（见 SKILL.md）。

### 复盘进化

1. **触发**: 用户输入「复盘」或使用次数 ≥ 5
2. **分析**: 读取 `rubric-usage-logs/`，统计分析
3. **建议**: 生成优化建议（失败率、评分、问题项）
4. **决策**: 用户选择应用/编辑/忽略
5. **沉淀**: 更新模板，版本+1

---

## 关键文件

| 文件 | 用途 |
|------|------|
| `SKILL.md` | 核心规程，含 Round 0 和复盘流程 |
| `rubric-templates/_registry.yaml` | 模板索引、版本、质量追踪 |
| `rubric-templates/README.md` | 模板库使用指南 |
| `rubric-selector.md` | 选择器指南（匹配算法） |
| `rubric-generator/generator-prompt.md` | 动态生成器 prompt |
| `rubric-generator/evolution-analyzer.md` | 复盘分析器 |
| `instance-template.md` | 实例化模板 |

---

## 最佳实践

1. **从现有模板开始**: 不要从零创建
2. **适度定制**: 填充占位符，不过度修改
3. **保持 BLOCKER 数量**: 2-4 个，避免过严
4. **定期复盘**: 使用 5 次后触发复盘
5. **沉淀知识**: 新场景生成后及时复盘优化

---

## 与其他 Skill 组合

| 场景 | 组合 |
|------|------|
| 新功能交付 | `delivery-chain` → `eval-optimize-loop` |
| Plan 执行 + 质量门 | `orchestrator` → 每任务 `eval-optimize-loop` |
| 合并前检查 | `eval-optimize-loop` → `verification-before-completion` |

---

## 文档

- [模式文档](../../../docs/05-evaluator-optimizer.md)
- [使用指南](./references/rubric-templates/README.md)
- [总览](../../../summary.md)
