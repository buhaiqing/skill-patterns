---
industry: software-dev
scenario: database-migration
version: "1.0"
generated_at: "2025-05-18"
keywords: ["database", "migration", "数据库", "迁移"]
---

# 数据库迁移 Rubric

> 最佳实践：数据库迁移是高危操作，必须谨慎

## 评测项

| ID | 项 | Pass 条件 | 级别 | 最佳实践 |
|----|-----|----------|------|---------|
| D1 | 回滚 | 有回滚脚本且已测试 | BLOCKER | 可逆操作 |
| D2 | 备份 | 迁移前已全量备份 | BLOCKER | 数据安全第一 |
| D3 | 兼容性 | 迁移前后应用兼容 | BLOCKER | 零停机部署 |
| D4 | 性能 | 大表迁移已评估性能影响 | BLOCKER | 避免锁表 |
| D5 | 幂等 | 迁移脚本可重复执行 | normal | 幂等设计 |
| D6 | 回滚测试 | 回滚脚本已测试 | normal | 演练回滚 |
| D7 | 监控 | 迁移过程有监控 | normal | 可观测 |
| D8 | 灰度 | 大变更灰度执行 | normal | 降低风险 |

## 迁移策略

| 策略 | 适用场景 | 风险 |
|------|---------|------|
| 在线迁移 | 小表/低风险 | 低 |
| 双写 + 切换 | 大表/高可用 | 中 |
| 影子表 + 切换 | 超大表 | 高 |

## DDL 注意事项

```sql
✅ ALTER TABLE users ADD COLUMN age INT DEFAULT 0;
   -- 有默认值，避免全表更新

❌ ALTER TABLE users ADD COLUMN age INT;
   -- 无默认值，大表锁表时间长
```

## 占位符

- `{TABLE_SIZE}`: 表大小，如 1GB
- `{DOWNTIME}`: 可接受停机时间，如 0s
