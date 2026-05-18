# L0 Preflight — 通用检查（所有类型）

| # | 检查项 | BLOCKER 条件 |
|---|--------|-------------|
| 1 | 任务描述非空 | 无任务文本 |
| 2 | 目标环境明确 | 生产变更但无环境说明 |
| 3 | 权限与范围 | 明确要求越权操作（删库、force push main 等） |
| 4 | 密钥安全 | 要求提交 .env、明文密码 |

**通过**：无 BLOCKER。  
**失败**：输出 `reject-templates/preflight-blocked.md`，终止路由。
