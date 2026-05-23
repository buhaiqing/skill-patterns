---
industry: software-dev
scenario: frontend-component
version: "1.0"
generated_at: "2025-05-18"
keywords: ["frontend", "component", "UI", "组件"]
---

# 前端组件开发 Rubric

> 最佳实践：组件是 UI 的基石，要可复用、可测试、可访问

## 评测项

| ID | 项 | Pass 条件 | 级别 | 最佳实践 |
|----|-----|----------|------|---------|
| F1 | 功能 | 组件功能完整，与需求对齐 | BLOCKER | 功能正确 |
| F2 | 测试 | 组件测试覆盖率 ≥ {COVERAGE}% | BLOCKER | 测试驱动 |
| F3 | 文档 | Storybook/文档已更新 | normal | 文档即示例 |
| F4 | 可访问 | WCAG 2.1 AA 标准 | normal | a11y |
| F5 | 响应式 | 支持移动端/桌面端 | normal | 响应式设计 |
| F6 | 性能 | 渲染时间 < {RENDER_TIME}ms | normal | 性能优化 |
| F7 | 复用 | 无业务逻辑耦合 | normal | 纯组件 |
| F8 | 类型 | TypeScript 类型完整 | normal | 类型安全 |

## 组件设计原则

| 原则 | 说明 |
|------|------|
| 单一职责 | 一个组件做一件事 |
| 可组合 | 支持组合使用 |
| 受控/非受控 | 支持两种模式 |
| Props 透明 | 文档化所有 props |

## 测试要求

```javascript
// 必须测试
- 渲染
- 交互（点击、输入）
- 边界条件（空值、超长内容）
- 快照（可选）
```

## 占位符

- `{COVERAGE}`: 如 80%
- `{RENDER_TIME}`: 如 16ms（1帧）
