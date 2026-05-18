# Worker Handoff 格式

Worker 完成时**必须**输出：

```markdown
## Handoff

### 摘要
（1–3 句：做了什么、结果如何）

### 变更范围
- `path/to/file1`
- `path/to/file2`

### 验证证据
\`\`\`text
$ {command}
{full output — exit code noted}
\`\`\`

### 验收自检
| 标准 | 结果 |
|------|------|
| {criterion 1} | pass / fail |
| {criterion 2} | pass / fail |

### 风险与未决
- …

### 建议 Orchestrator 下一步
- …
```

Orchestrator 收到后：
1. 核对验证证据是否新鲜完整
2. fail → 同 Worker 修复或新 Worker 接手
3. pass → TodoWrite 标记完成 → 下一任务
