---
industry: software-dev
scenario: api-design
version: "1.0"
generated_at: "2025-05-18"
keywords: ["api", "接口设计", "REST", "接口"]
---

# API 设计 Rubric

> 最佳实践：API 是产品的用户界面，设计要面向开发者

## 评测项

| ID | 项 | Pass 条件 | 级别 | 最佳实践 |
|----|-----|----------|------|---------|
| A1 | RESTful | 符合 REST 规范 | BLOCKER | 标准 HTTP 方法 |
| A2 | 版本 | 有明确版本策略（v1/v2） | BLOCKER | 向后兼容 |
| A3 | 安全 | 认证/授权/输入校验完整 | BLOCKER | API 安全第一 |
| A4 | 文档 | OpenAPI/Swagger 文档完整 | BLOCKER | 文档即契约 |
| A5 | 错误 | 统一错误码，清晰错误信息 | normal | 错误可处理 |
| A6 | 性能 | 响应时间 P99 < {LATENCY}ms | normal | 性能可接受 |
| A7 | 限流 | 有速率限制策略 | normal | 防滥用 |
| A8 | 幂等 | 关键接口幂等设计 | BLOCKER | 防止重复 |

## REST 检查清单

| HTTP 方法 | 用途 | 幂等性 |
|-----------|------|--------|
| GET | 获取资源 | ✅ 幂等 |
| POST | 创建资源 | ❌ 非幂等 |
| PUT | 全量更新 | ✅ 幂等 |
| PATCH | 部分更新 | ✅ 幂等 |
| DELETE | 删除资源 | ✅ 幂等 |

## URL 规范

```
✅ /api/v1/users/{id}
❌ /api/v1/getUserById
❌ /api/v1/users/{id}/get
```

## 错误码规范

| 状态码 | 含义 | 场景 |
|--------|------|------|
| 200 | OK | 成功 |
| 201 | Created | 创建成功 |
| 400 | Bad Request | 参数错误 |
| 401 | Unauthorized | 未认证 |
| 403 | Forbidden | 无权限 |
| 404 | Not Found | 资源不存在 |
| 409 | Conflict | 资源冲突 |
| 500 | Internal Error | 服务器错误 |

## 占位符

- `{LATENCY}`: 如 100ms
