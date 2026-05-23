# Rust 开发最佳实践

## Rust 哲学

> **Do more with less** — 零成本抽象、内存安全、 fearless concurrency

**核心原则**:
- **内存安全** — 编译时保证，无运行时开销
- **零成本抽象** — 高级特性不牺牲性能
- **所有权系统** — 编译时管理资源生命周期
- **并发安全** — 编译时防止数据竞争

```rust
// ✅ Rust 风格 — 安全、高效、表达力强
fn process(items: &[Item]) -> Result<Vec<Processed>, Error> {
    items
        .iter()
        .filter(|i| i.is_valid())
        .map(|i| transform(i))
        .collect()
}

// 编译时保证：无空指针、无数据竞争、无内存泄漏
```

## 代码风格

### rustfmt
- 强制使用 `rustfmt` 格式化
- `cargo fmt` 一键格式化

### 命名规范

| 类型 | 规范 | 示例 |
|------|------|------|
| 模块/函数/变量 | snake_case | `process_data` |
| 类型/结构体/枚举 | PascalCase | `UserData` |
| 常量/静态 | SCREAMING_SNAKE_CASE | `MAX_SIZE` |
| 生命周期 | 短名称 | `'a`, `'ctx` |

## 项目结构

```
my_project/
├── Cargo.toml
├── Cargo.lock
├── src/
│   ├── main.rs        # 可执行文件
│   ├── lib.rs         # 库入口
│   ├── models/
│   ├── utils/
│   └── errors.rs
├── tests/
│   └── integration_test.rs
├── benches/
│   └── bench.rs
├── examples/
└── README.md
```

## 所有权与借用

```rust
// ✅ 所有权转移
fn take_ownership(s: String) {
    // s 被移动进来
}

// ✅ 借用
fn borrow(s: &String) {
    // 只读借用
}

// ✅ 可变借用
fn mutate(s: &mut String) {
    s.push_str("modified");
}

// ❌ 编译错误 - 悬空引用
let r = {
    let x = 5;
    &x  // x 在这里被释放
};  // r 指向无效内存
```

## 错误处理

```rust
// ✅ Result 显式处理
fn may_fail() -> Result<T, Error> {
    let data = fetch_data()?;  // ? 传播错误
    process(data)?;
    Ok(result)
}

// ✅ match 处理
match result {
    Ok(data) => process(data),
    Err(e) => log_error(e),
}

// ✅ unwrap 仅在确定时
let config = Config::from_env().expect("CONFIG must be set");

// ❌ 避免裸 unwrap
let data = fetch_data().unwrap();  // 危险！
```

## 并发与异步

```rust
// ✅ 线程安全 - 编译时检查
use std::sync::Arc;
use tokio::sync::Mutex;

async fn concurrent(data: Arc<Mutex<Data>>) {
    let mut guard = data.lock().await;
    guard.process();
    // 锁自动释放
}

// ✅ fearless concurrency
let handles: Vec<_> = (0..10)
    .map(|i| tokio::spawn(async move { process(i).await }))
    .collect();

for handle in handles {
    handle.await?;
}
```

## 性能优化

### 零成本抽象

```rust
// ✅ 迭代器链 - 编译成高效代码
let sum: i32 = (0..100)
    .filter(|x| x % 2 == 0)
    .map(|x| x * x)
    .sum();

// ✅ 避免分配
let slice = &vec[0..10];  // 借用，不分配

// ✅ 使用 &str 而非 String
fn process_name(name: &str) {  // 借用
    // ...
}
```

### 内存布局

```rust
// ✅ 使用合适的数据结构
use smallvec::SmallVec;      // 小数组优化
use hashbrown::HashMap;      // 更快的 HashMap

// ✅ 避免克隆
#[derive(Clone)]  // 仅在需要时
struct Config { }
```

### SIMD 和 Unsafe（谨慎使用）

```rust
// ✅ 安全封装下的 unsafe
pub fn fast_process(data: &[u8]) -> u32 {
    assert!(!data.is_empty());  // 前置条件检查
    
    unsafe {
        // 安全的 unsafe 代码块
        core::ptr::read_volatile(data.as_ptr())
    }
}
```

## 测试

```rust
// ✅ 单元测试
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_calculate() {
        assert_eq!(calculate(2, 3), 5);
    }

    #[test]
    #[should_panic(expected = "divide by zero")]
    fn test_divide_by_zero() {
        divide(1, 0);
    }
}

// ✅ 基准测试
#[bench]
fn bench_process(b: &mut Bencher) {
    let data = prepare_data();
    b.iter(|| process(&data));
}
```

## 常见陷阱

| 陷阱 | 说明 | 解决 |
|------|------|------|
| 所有权借用冲突 | 同时借用可变和不可变 | 重新设计借用范围 |
| 生命周期过长 | 引用比数据活得久 | 使用 Arc 或克隆 |
| 递归深度过大 | 栈溢出 | 使用循环或尾递归优化 |
| 阻塞异步运行时 | 在 async 中执行阻塞操作 | 使用 spawn_blocking |
| 过度 clone | 不必要的内存分配 | 使用引用、Cow |

## 工具链

| 工具 | 用途 |
|------|------|
| cargo fmt | 格式化 |
| cargo clippy | 代码检查 |
| cargo check | 快速检查 |
| cargo test | 测试 |
| cargo bench | 基准测试 |
| cargo audit | 安全检查 |

## 高性能模式

### 编译优化

```toml
# Cargo.toml
[profile.release]
opt-level = 3
lto = true          # 链接时优化
panic = "abort"     # 不展开栈
```

### 异步运行时

```rust
// ✅ tokio - 生产级异步运行时
#[tokio::main]
async fn main() {
    // 高效 I/O
}
```

## 惯用法

```rust
// ✅ 使用 if let 简化匹配
if let Some(value) = optional {
    process(value);
}

// ✅ 使用 ? 传播错误
let data = fetch_data()?;

// ✅ 使用 map/and_then 链式操作
let result = optional
    .map(|v| v * 2)
    .filter(|v| *v > 10);
```
