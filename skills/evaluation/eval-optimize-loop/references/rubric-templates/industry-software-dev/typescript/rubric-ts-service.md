---
industry: software-dev
scenario: ts-service
language: typescript
version: "1.0"
generated_at: "2025-05-18"
keywords: ["typescript", "ts", "nodejs", "express", "nestjs"]
---

# TypeScript 服务开发 Rubric

> TypeScript 最佳实践：严格类型、ESLint、异步处理、Node.js 优化

## 评测项

| ID | 项 | Pass 条件 | 级别 | TS/Node 最佳实践 |
|----|-----|----------|------|----------------|
| TS1 | 类型 | `tsc --noEmit` 0 errors，`strict` 模式 | BLOCKER | 严格类型 |
| TS2 | 格式 | `eslint` + `prettier` 0 errors | normal | 代码风格 |
| TS3 | 测试 | `jest` 0 failures，覆盖率 ≥ {COVERAGE}% | BLOCKER | 测试驱动 |
| TS4 | 异步 | 正确使用 `async/await`，无 unhandled rejection | BLOCKER | 异步安全 |
| TS5 | 依赖 | `package.json` + `package-lock.json` 完整 | normal | 依赖锁定 |
| TS6 | 性能 | 无 memory leak，Event Loop 未阻塞 | normal | Node.js 优化 |
| TS7 | 安全 | 无 `eval()`，`shell` 命令已转义，输入已校验 | BLOCKER | 安全编码 |
| TS8 | 构建 | `tsc` 编译通过，`dist/` 输出正确 | normal | 构建验证 |
| TS9 | 简洁 | 使用现代语法，避免冗余代码 | normal | Do more with less |
| TS10 | 函数式 | 优先使用 map/filter/reduce，避免命令式循环 | normal | 函数式编程 |
| TS11 | 高性能 | 性能基准测试通过，响应时间达标 | normal | 高性能 |
| TS12 | 内存 | 无内存泄漏，V8 GC 压力合理 | normal | 内存优化 |

## TypeScript 特定检查

### 类型检查
```bash
tsc --noEmit --strict
```

### 代码检查
```bash
eslint src/ --ext .ts
prettier --check "src/**/*.ts"
```

### 测试运行
```bash
jest --coverage --coverageThreshold={"global":{"branches":80}}
```

### 安全检查
```bash
npm audit
```

## 异步处理检查

```typescript
// ✅ 正确 - try/catch
async function handler(req: Request, res: Response) {
  try {
    const user = await getUser(req.params.id);
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

// ❌ 错误 - 未处理
async function handler(req: Request, res: Response) {
  const user = await getUser(req.params.id);  // 可能抛出！
  res.json(user);
}
```

## Node.js 特定

```typescript
// ✅ 环境变量验证
const PORT = process.env.PORT || '3000';
if (!process.env.DATABASE_URL) {
  throw new Error('DATABASE_URL is required');
}

// ✅ 优雅关闭
process.on('SIGTERM', async () => {
  await server.close();
  await db.disconnect();
  process.exit(0);
});
```

## 简洁性检查

```typescript
// ✅ 现代简洁语法
const doubled = numbers.map(n => n * 2);
const active = users.filter(u => u.active);
const total = prices.reduce((sum, p) => sum + p, 0);

// ✅ 解构赋值
const { id, name } = user;
const [first, ...rest] = items;

// ✅ 可选链 + 空值合并
const email = user?.profile?.email ?? 'no-email';

// ❌ 冗长传统
const doubled = [];
for (let i = 0; i < numbers.length; i++) {
  doubled.push(numbers[i] * 2);
}

// ❌ 冗余判断
const isValid = items.length > 0 ? true : false;
```

## 高性能检查

```typescript
// ✅ 使用 Set/Map 优化查找
const userMap = new Map(users.map(u => [u.id, u]));
const user = userMap.get(id);  // O(1) 查找

// ✅ 避免重复计算 — 使用 Memoization
import { memoize } from 'lodash';

const expensiveFn = memoize((data: Data) => {
  return heavyComputation(data);
});

// ✅ React 中使用 useMemo/useCallback
const processed = useMemo(() => {
  return data.filter(d => d.active).map(d => d.value);
}, [data]);

// ✅ 流式处理大文件
import { createReadStream } from 'fs';
import { createInterface } from 'readline';

const processLargeFile = async () => {
  const stream = createReadStream('large-file.txt');
  const rl = createInterface({ input: stream });
  
  for await (const line of rl) {
    processLine(line);  // 逐行处理，不占内存
  }
};

// ✅ 避免阻塞 Event Loop
const heavyTask = () => {
  return new Promise((resolve) => {
    setImmediate(() => {
      // 将大任务拆分到下一次事件循环
      resolve(computeHeavy());
    });
  });
};

// ✅ Worker Threads 处理 CPU 密集型任务
import { Worker } from 'worker_threads';

const processInWorker = (data: Data) => {
  return new Promise((resolve, reject) => {
    const worker = new Worker('./worker.js');
    worker.postMessage(data);
    worker.on('message', resolve);
    worker.on('error', reject);
  });
};

// ✅ 使用 Buffer 高效处理二进制
const buf = Buffer.from(data);
const chunk = buf.slice(0, 1024);  // 零拷贝切片

// ❌ 性能陷阱 — 大量小对象创建
// 在循环内创建新对象

// ❌ 内存泄漏 — 未清理的监听器
// EventEmitter 未移除监听器

// ❌ 阻塞操作
// 在 async 函数中使用同步阻塞 API
```

## 占位符

- `{COVERAGE}`: 如 80%
- `{NODE_VERSION}`: 如 18.x
