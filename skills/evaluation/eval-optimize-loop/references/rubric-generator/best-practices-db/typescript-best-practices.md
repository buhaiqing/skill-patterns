# TypeScript/JavaScript 开发最佳实践

## JavaScript/TypeScript 哲学

> **Do more with less** — 简洁、表达力强、现代语法

**核心理念**:
- **简洁表达** — 箭头函数、解构、展开运算符
- **函数式编程** — map/filter/reduce 替代循环
- **不可变性** — const、展开运算、immutable 数据
- **现代语法** — ES6+，async/await，可选链

```typescript
// ✅ 简洁现代
const activeUsers = users
  .filter(u => u.active)
  .map(u => ({ id: u.id, name: u.name }));

// ❌ 冗长传统
const activeUsers = [];
for (let i = 0; i < users.length; i++) {
  const user = users[i];
  if (user.active) {
    activeUsers.push({
      id: user.id,
      name: user.name
    });
  }
}
```

## 类型安全

### 严格模式
```json
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true
  }
}
```

### 类型定义

```typescript
// ✅ 显式类型
interface User {
  id: string;
  name: string;
  email?: string; // 可选
}

function getUser(id: string): User {
  // ...
}

// ❌ 避免 any
function getUser(id: any): any { }
```

## 项目结构

```
my_project/
├── src/
│   ├── components/
│   ├── utils/
│   ├── types/
│   └── index.ts
├── tests/
├── dist/
├── package.json
├── tsconfig.json
├── jest.config.js
└── README.md
```

## 异步处理

```typescript
// ✅ async/await
try {
  const user = await fetchUser(id);
  const orders = await fetchOrders(user.id);
} catch (error) {
  console.error('Failed:', error);
}

// ✅ Promise.all 并行
const [user, orders] = await Promise.all([
  fetchUser(id),
  fetchOrders(id)
]);

// ❌ 不要用回调地狱
```

## 简洁语法

### 现代 JavaScript/TypeScript

```typescript
// ✅ 解构赋值
const { id, name } = user;
const [first, ...rest] = items;

// ✅ 展开运算
const newObj = { ...obj, extra: value };
const newArr = [...arr, newItem];

// ✅ 箭头函数
const double = x => x * 2;
items.forEach(item => console.log(item));

// ✅ 可选链
const email = user?.profile?.email;

// ✅ 空值合并
const port = process.env.PORT ?? 3000;

// ✅ 函数式编程
const doubled = numbers.map(n => n * 2);
const active = users.filter(u => u.active);
const total = prices.reduce((sum, p) => sum + p, 0);
```

### 避免冗余

```typescript
// ✅ 简洁
const isValid = items.length > 0;

// ❌ 冗余
const isValid = items.length > 0 ? true : false;

// ✅ 利用短路
const result = data || defaultValue;

// ❌ 冗余
let result;
if (data) {
  result = data;
} else {
  result = defaultValue;
}
```

## 常见陷阱

| 陷阱 | 说明 | 解决 |
|------|------|------|
| == vs === | 类型转换陷阱 | 总是用 === |
| this 绑定 | 箭头函数 vs 普通函数 | 箭头函数保 this |
| 闭包陷阱 | 循环中的异步 | let 或 forEach |
| null/undefined | 类型安全 | strictNullChecks |
| 回调地狱 | 嵌套回调 | async/await |

## 测试

```typescript
// Jest 示例
describe('UserService', () => {
  it('should fetch user', async () => {
    const user = await getUser('123');
    expect(user.id).toBe('123');
  });
  
  it('should handle error', async () => {
    await expect(getUser('invalid')).rejects.toThrow();
  });
});
```

## 性能优化

- 代码分割（Code Splitting）
- Tree Shaking
- Lazy Loading
- Memoization（React.useMemo）

## 工具链

| 工具 | 用途 |
|------|------|
| ESLint | 代码检查 |
| Prettier | 格式化 |
| TypeScript | 类型检查 |
| Jest | 测试 |
| Webpack/Vite | 构建 |

## Node.js 特定

```typescript
// ✅ 环境变量检查
const PORT = process.env.PORT || 3000;

// ✅ 优雅关闭
process.on('SIGTERM', () => {
  server.close(() => {
    console.log('Server closed');
  });
});
```
