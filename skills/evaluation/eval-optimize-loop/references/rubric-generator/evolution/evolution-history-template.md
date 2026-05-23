# Rubric 模板进化历史

## 模板信息

- rubric_id: {RUBRIC_ID}
- industry: {INDUSTRY}
- scenario: {SCENARIO}
- created_at: {CREATED_AT}

## 版本历史

### v1.0 (初始版本)

- created_at: {TIMESTAMP}
- generated_by: rubric-generator
- trigger: 新场景识别
- changes: 初始创建

### v1.1 (第一次优化)

- updated_at: {TIMESTAMP}
- trigger: 复盘分析
- usage_count: 5
- avg_rating: 4.2
- changes:
  - 调整 O1 止损时间要求
  - 补充 O3 回滚方案示例
- optimized_by: evolution-analyzer

### v2.0 (重大更新)

- updated_at: {TIMESTAMP}
- trigger: 行业规范更新
- changes:
  - 新增 O9 监控项
  - O2 升级 BLOCKER
- optimized_by: manual

## 使用统计

| 版本 | 使用次数 | 平均评分 | 平均轮次 |
|------|---------|---------|---------|
| v1.0 | 5 | 4.0 | 2.8 |
| v1.1 | 10 | 4.5 | 2.2 |
| v2.0 | 3 | 4.8 | 2.0 |

## 常见问题

1. O1 止损时间争议
   - 原因: 不同业务 SLA 不同
   - 解决: 占位符化，用户自定义
   
2. O7 沟通要求模糊
   - 原因: 通知渠道不明确
   - 解决: 补充具体通知方式
