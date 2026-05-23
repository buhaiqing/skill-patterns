# Rubric 模板库使用指南

## 快速开始

### 1. 选择 Rubric

```bash
# 用户输入
「修复订单金额计算 Bug」

# AI 识别
行业: generic
场景: bug-fix
匹配模板: generic-bug-fix
```

### 2. 实例化 Rubric

```bash
# 填充占位符
{TEST_CMD} → pytest tests/order/test_calc.py
{BUG_ID} → #123
{LINT_CMD} → eslint src/order/
```

### 3. 执行 Eval-Optimize

```
Round 1: Generate → Critic → Fail
Round 2: Optimize → Critic → Pass
```

## 模板分类

### 按行业

| 行业 | 模板数 | 说明 |
|------|--------|------|
| generic | 3 | 通用软件开发 |
| ops | 4 | 运维/监控/部署/配置 |
| finance | 4 | 金融交易/风控/清算 |
| quant | 4 | 量化策略/实盘/数据 |
| software-dev | 8 | 代码审查/API/数据库/前端 + 4 语言服务 |

### 按语言

| 语言 | 模板数 | 说明 |
|------|--------|------|
| Python | 1 | Flask/FastAPI/Django |
| Go | 1 | Gin/Echo |
| TypeScript | 1 | Node.js/Express |
| Rust | 1 | Tokio/Axum/Actix |

### 完整模板列表

```
generic/
├── rubric-bug-fix.md
├── rubric-feature.md
└── rubric-refactor.md

ops/
├── rubric-incident-response.md
├── rubric-config-change.md
├── rubric-deployment.md
└── rubric-monitoring.md

finance/
├── rubric-trade-system.md
├── rubric-risk-control.md
├── rubric-settlement.md
└── rubric-reporting.md

quant/
├── rubric-strategy-backtest.md
├── rubric-live-trading.md
├── rubric-data-pipeline.md
└── rubric-risk-model.md

software-dev/
├── rubric-code-review.md
├── rubric-api-design.md
├── rubric-database-migration.md
├── rubric-frontend-component.md
├── python/rubric-python-service.md
├── go/rubric-go-service.md
├── typescript/rubric-ts-service.md
└── rust/rubric-rust-service.md
```

## 使用示例

### 示例 1: Bug 修复

**用户输入**: 「修复订单金额精度 Bug」

**流程**:
```
Step 1: 匹配 generic-bug-fix
Step 2: 实例化
  - {TEST_CMD} = pytest tests/order/test_calc.py
  - {BUG_ID} = #456
Step 3: 开始 Round 1
Step 4: 3 轮后通过
```

### 示例 2: Python API 开发

**用户输入**: 「用 FastAPI 开发用户管理 API」

**流程**:
```
Step 1: 匹配 python-service
Step 2: 实例化
  - {COVERAGE} = 85%
Step 3: 开始 Round 1
```

### 示例 3: 动态生成

**用户输入**: 「上线区块链交易服务」

**流程**:
```
Step 1: 匹配失败（无区块链模板）
Step 2: 触发模板生成
Step 3: 生成 blockchain-trade rubric
Step 4: 用户确认
Step 5: 沉淀到 rubric-templates/
Step 6: 开始 Round 1
```

## 复盘

### 触发复盘

```bash
「复盘」                          # 查看可复盘模板
「复盘 python-service」          # 复盘特定模板
「推荐复盘」                      # AI 推荐
```

### 复盘流程

```
1. AI 分析使用日志
2. 生成优化建议
3. 用户决策：[应用/编辑/忽略]
4. 更新模板，版本+1
```

## 自定义模板

### 1. 复制现有模板

```bash
cp rubric-bug-fix.md rubric-custom.md
```

### 2. 修改评测项

```markdown
| ID | 项 | Pass 条件 | 级别 |
|----|-----|----------|------|
| C1 | 自定义项 | 条件 | BLOCKER |
```

### 3. 添加到注册表

```yaml
- id: "custom-template"
  industry: "custom"
  scenario: "custom"
  path: "rubric-custom.md"
```

## 最佳实践

1. **从现有模板开始**: 不要从零创建
2. **适度定制**: 不要过度修改
3. **保持 BLOCKER 数量**: 2-4 个
4. **可执行性**: Pass 条件可验证
5. **复盘沉淀**: 定期复盘优化

## 支持

- 模板生成: `references/rubric-generator/`
- 使用日志: `references/rubric-usage-logs/`（schema: `rubric-usage-log-schema.yaml`，写入: `rubric-usage-log-write.md`）
- 全量校验（提交前）: `scripts/validate_all.sh`
- 注册表 path: `scripts/validate_rubric_registry.sh`
- 最佳实践: `references/rubric-generator/best-practices-db/`
