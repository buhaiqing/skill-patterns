# Worker 派发包模板

复制到 Task `prompt`，替换 `{占位符}`。

```markdown
## 任务域
{domain_name}

## 你的目标
{one_sentence_goal}

## 背景（仅本域相关）
{minimal_context}

## 范围
- 允许修改：{allowed_paths}
- 禁止修改：{forbidden_paths}

## 验收标准
{acceptance_criteria}

## 验证命令
{commands_to_run}

## 约束
- 不要改动范围外文件
- 完成后输出 handoff（摘要 / 文件列表 / 验证输出 / 风险）

## 预期输出
修复或调查结论 + 验证证据
```
