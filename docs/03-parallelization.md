# Pattern 3：Parallelization（并行 + Voting）

> [← 返回总览](../summary.md) · 适配度：⭐⭐⭐ · Skill 写规程，平台与脚本做执行与聚合

---

## 原理

### 3.1 并行子任务

多个**相互独立**的子任务同时执行，由协调者（父 Agent）汇总、去冲突、集成。

### 3.2 Voting（表决）

对同一问题启动 N 路独立求解，再按 rubric 或多数票合成最终答案。

---

## 并行子任务

### Skill 与平台分工

| 角色 | 职责 | 实现 |
|------|------|------|
| **Skill** | 识别独立域、构造隔离上下文、规定 handoff | `dispatching-parallel-agents` |
| **平台** | 真正并行执行 | `Task` 工具、多子 Agent、并行 tool call |
| **父 Agent** | 汇总、冲突检测、集成 | 主会话协调 |

### 生态内范例

`dispatching-parallel-agents` 核心原则：

- 每个独立问题域派**一个** Agent
- 子 Agent **不继承**父会话历史，只给精心构造的上下文
- 仅在问题**相互独立**时使用

### 推荐实现形态

```text
parallel/
├── parallel-dispatch/
│   └── SKILL.md          # 何时并行、如何隔离、handoff 格式
└── vote-synthesis/
    └── SKILL.md          # 聚合 rubric、分歧处理
```

### parallel-dispatch SKILL.md 要点

```markdown
## 何时并行
- 3+ 个独立失败（不同测试文件 / 子系统）
- 子任务之间无共享可变状态
- 不需要先理解全局才能动手

## 何时禁止并行
- 失败可能同源（修一个可能修全部）
- 会改同一文件 / 同一配置

## 派发协议
1. 按域分组
2. 每域构造独立 prompt（含范围、目标、约束）
3. 同一 message 内并行 Task × N
4. 收集摘要 → 检查冲突 → 集成
```

### Skill 单独做不到

- 不会自动 fork 进程
- 不会自动 merge 冲突代码
- 共享状态场景需 `using-git-worktrees` 等约定

---

## Voting（多路生成 + 表决）

### Skill 可定义的协议

```markdown
## Voting 协议
1. 用同一 prompt 启动 N=3 次独立子任务（不同 subagent / 隔离上下文）
2. 收集 N 份答案
3. 加载 vote-synthesis skill：按 rubric 打分或 majority vote
4. 输出最终答案 + 分歧说明
```

### 更适合脚本化的部分

| 能力 | 实现 |
|------|------|
| 票数统计 | `scripts/aggregate_votes.py` |
| 加权合并 | Eval 服务 / 规则引擎 |
| 一致性检验 | 结构化 diff / 单元测试 |

### vote-synthesis SKILL.md 要点

```markdown
## 输入
- N 份独立答案（须标注来源 subagent id）

## 聚合规则
1. 完全一致 → 直接采用
2. 多数一致 → 采用多数，列出少数派理由
3. 全部分歧 → 按 rubric 逐项打分，取最高分；仍平手则 escalate

## 输出格式
- 最终答案
- 置信度
- 分歧摘要表
```

### 局限

| 局限 | 说明 |
|------|------|
| 成本 × N | token、延迟成倍 |
| 样本相关性 | 同 context 重复调用 ≠ 独立样本 |
| 无内置 Vote 运行时 | 需显式派发 + 聚合步骤 |

---

## 还需什么（除 Skill 外）

| 组件 | 用途 |
|------|------|
| **Task / 子 Agent** | 真并行 |
| **vote-synthesis Skill** | 聚合规程 |
| **aggregate 脚本** | 确定性计票 |
| **git worktree** | 并行改代码时隔离 |

## 结论

**适合「编排 Skill + 平台并行 + 聚合脚本」三位一体；不宜声称仅靠一个 Skill 文件即可实现。**

---

**相关文档**：[04 - Orchestrator-Workers](./04-orchestrator-workers.md) · [03 与 04 常组合使用]
