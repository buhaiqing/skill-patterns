# Python 开发最佳实践

## 代码风格

### Pythonic 哲学

> **Do more with less** — 简洁胜于复杂，优雅胜于丑陋

```python
# ✅ Pythonic — 简洁、优雅
result = [x * 2 for x in numbers if x > 0]

# ❌ 非 Pythonic — 冗长、命令式
result = []
for x in numbers:
    if x > 0:
        result.append(x * 2)
```

**核心原则**（The Zen of Python）:
- 简洁胜于复杂（Simple is better than complex）
- 显式胜于隐式（Explicit is better than implicit）
- 可读性很重要（Readability counts）
- 用一种显而易见的方式（There should be one obvious way）

### PEP 8
- 4 空格缩进
- 行长度 ≤ 79 字符（或团队约定的 100/120）
- 命名规范：snake_case（函数/变量），PascalCase（类）

### Type Hints
```python
# ✅ 推荐
def calculate(x: int, y: int) -> int:
    return x + y

# ❌ 不推荐
def calculate(x, y):
    return x + y
```

## 项目结构

```
my_project/
├── src/
│   └── my_package/
│       ├── __init__.py
│       ├── module.py
│       └── utils.py
├── tests/
│   ├── __init__.py
│   ├── test_module.py
│   └── conftest.py
├── docs/
├── pyproject.toml
├── README.md
└── requirements.txt
```

## 依赖管理

| 工具 | 用途 | 推荐 |
|------|------|------|
| pip + requirements.txt | 基础依赖 | ⭐ |
| poetry | 现代依赖管理 | ⭐⭐⭐ |
| pipenv | 虚拟环境 + 依赖 | ⭐⭐ |
| conda | 科学计算 | ⭐⭐ |

## 测试

```python
# pytest 示例
def test_calculate():
    assert calculate(1, 2) == 3

# 参数化测试
@pytest.mark.parametrize("x,y,expected", [
    (1, 2, 3),
    (0, 0, 0),
    (-1, 1, 0),
])
def test_calculate_param(x, y, expected):
    assert calculate(x, y) == expected
```

## Pythonic 实践

### 用更 Pythonic 的方式

| 非 Pythonic | Pythonic | 说明 |
|------------|---------|------|
| `for i in range(len(list)):` | `for item in list:` | 直接迭代 |
| `if x == True:` | `if x:` | 真值判断 |
| `dict[key]` | `dict.get(key)` | 安全获取 |
| `file = open(...)` | `with open(...) as f:` | 上下文管理 |
| `try/except Exception` | `try/except SpecificError` | 精确捕获 |
| `map(lambda x: x*2, items)` | `[x*2 for x in items]` | 推导式 |
| `if x: return a` else `return b` | `return a if x else b` | 条件表达式 |

### 标准库优先

```python
# ✅ 使用标准库
from collections import defaultdict, Counter
from itertools import groupby
from functools import partial, reduce
import pathlib  # 替代 os.path

# ❌ 重复造轮子
# 自己实现计数、分组等功能
```

## 常见陷阱

| 陷阱 | 说明 | 解决 |
|------|------|------|
| 可变默认参数 | `def f(x=[])` 的坑 | 使用 `None` + `if x is None` |
| 循环导入 | 模块 A import B，B import A | 重构或延迟导入 |
| GIL 限制 | CPU 密集型多线程无效 | 使用 multiprocessing |
| 内存泄漏 | 循环引用 | 使用 weakref 或重构 |

## 性能优化

- 使用 `cProfile` 分析热点
- 列表推导式 vs 生成器（内存考虑）
- `@functools.lru_cache` 缓存
- `numba` / `cython` 关键路径

## 异步编程

```python
# ✅ asyncio
import asyncio

async def fetch_data():
    await asyncio.sleep(1)
    return "data"

# ❌ 不要在 async 里用 time.sleep
```
