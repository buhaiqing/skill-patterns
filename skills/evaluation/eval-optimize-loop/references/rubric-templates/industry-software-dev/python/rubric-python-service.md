---
industry: software-dev
scenario: python-service
language: python
version: "1.0"
generated_at: "2025-05-18"
keywords: ["python", "flask", "fastapi", "django", "service"]
---

# Python 服务开发 Rubric

> Python 最佳实践：PEP 8、类型提示、异步编程、性能优化

## 评测项

| ID | 项 | Pass 条件 | 级别 | Python 最佳实践 |
|----|-----|----------|------|----------------|
| PY1 | 类型 | 类型提示完整，`mypy` 0 errors | BLOCKER | Type Hints |
| PY2 | 格式 | `black` + `isort` 格式化通过 | normal | 代码风格 |
| PY3 | 测试 | `pytest` 0 failures，覆盖率 ≥ {COVERAGE}% | BLOCKER | 测试驱动 |
| PY4 | 异步 | 异步代码使用 `async/await`，无阻塞调用 | BLOCKER | asyncio |
| PY5 | 依赖 | `requirements.txt` 或 `pyproject.toml` 完整 | normal | 依赖管理 |
| PY6 | 文档 | Docstring 完整（Google/NumPy 风格） | normal | 文档即代码 |
| PY7 | 性能 | 热点代码已优化，无 obvious 性能问题 | normal | 性能意识 |
| PY8 | 安全 | 无 `eval()`，`shell=True` 慎用，输入已校验 | BLOCKER | 安全编码 |
| PY9 | Pythonic | 代码符合 Pythonic 风格，简洁优雅 | normal | Do more with less |
| PY10 | 标准库 | 优先使用标准库，避免重复造轮子 | normal | Batteries included |
| PY11 | 高性能 | 性能基准测试通过，响应时间达标 | normal | 高性能 |
| PY12 | 内存 | 无内存泄漏，内存使用合理 | normal | 内存优化 |

## Python 特定检查

### 类型提示检查
```bash
mypy src/ --strict
```

### 格式化检查
```bash
black --check src/
isort --check-only src/
```

### 测试运行
```bash
pytest tests/ -v --cov=src --cov-report=term-missing
```

### 安全检查
```bash
bandit -r src/
safety check
```

## 异步代码检查

```python
# ✅ 正确
async def fetch_data():
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as response:
            return await response.json()

# ❌ 错误 - 阻塞调用
async def fetch_data():
    response = requests.get(url)  # 阻塞！
    return response.json()
```

## Pythonic 检查

```python
# ✅ Pythonic — 简洁、优雅
result = [x * 2 for x in numbers if x > 0]

# ✅ Pythonic — 标准库优先
from collections import Counter
counts = Counter(items)

# ✅ Pythonic — 真值判断
if items:  # 而非 if len(items) > 0:

# ✅ Pythonic — 上下文管理
with open('file.txt') as f:
    content = f.read()

# ❌ 非 Pythonic — 冗长
result = []
for x in numbers:
    if x > 0:
        result.append(x * 2)

# ❌ 非 Pythonic — 重复造轮子
# 自己实现计数、排序等标准库功能
```

## 高性能检查

```python
# ✅ 性能分析
# python -m cProfile -s time script.py

# ✅ 使用合适的数据结构
from collections import deque  # 队列操作 O(1)
from heapq import heapify     # 堆操作 O(log n)

# ✅ 避免重复计算
from functools import lru_cache

@lru_cache(maxsize=128)
def fibonacci(n):
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

# ✅ 生成器节省内存
def large_dataset():
    for i in range(1000000):
        yield i  # 惰性求值

# ✅ NumPy 向量化计算
import numpy as np
result = np.array(data) * 2  # 比列表推导快 10-100 倍

# ✅ 异步 I/O
async def fetch_all(urls):
    async with aiohttp.ClientSession() as session:
        tasks = [fetch(session, url) for url in urls]
        return await asyncio.gather(*tasks)

# ❌ 性能陷阱 — 低效循环
result = []
for i in range(len(data)):
    result.append(process(data[i]))

# ❌ 内存泄漏 — 循环引用
class Node:
    def __init__(self):
        self.parent = None
        self.children = []
        # 需要 weakref 避免循环引用
```

## 占位符

- `{COVERAGE}`: 如 80%
- `{PERFORMANCE_THRESHOLD}`: 如 P99 < 100ms
