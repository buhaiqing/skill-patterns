---
industry: software-dev
scenario: rust-service
language: rust
version: "1.0"
generated_at: "2025-05-18"
keywords: ["rust", "tokio", "axum", "actix", "service"]
---

# Rust 服务开发 Rubric

> Rust 最佳实践：内存安全、零成本抽象、高性能、fearless concurrency

## 评测项

| ID | 项 | Pass 条件 | 级别 | Rust 最佳实践 |
|----|-----|----------|------|--------------|
| RS1 | 编译 | `cargo check` 0 errors/warnings | BLOCKER | 编译即证明 |
| RS2 | 代码检查 | `cargo clippy` 0 warnings | BLOCKER | 代码质量 |
| RS3 | 测试 | `cargo test` 0 failures，覆盖率 ≥ {COVERAGE}% | BLOCKER | 测试驱动 |
| RS4 | 格式 | `cargo fmt` 格式化通过 | normal | 代码风格 |
| RS5 | 安全 | `cargo audit` 无漏洞，无 unsafe（或已评审） | BLOCKER | 安全优先 |
| RS6 | 异步 | 正确使用 `async/await`，无阻塞调用 | BLOCKER | fearless concurrency |
| RS7 | 所有权 | 无所有权借用冲突，生命周期正确 | BLOCKER | 所有权系统 |
| RS8 | 文档 | 导出函数有文档注释（`cargo doc`） | normal | 文档即代码 |
| RS9 | 简洁 | 使用 Rust 惯用法，避免过度工程 | normal | Do more with less |
| RS10 | 性能 | 基准测试通过，无明显性能问题 | normal | 高性能 |
| RS11 | 零分配 | 热点路径无不必要的内存分配 | normal | 零成本抽象 |
| RS12 | 并发 | 并发代码安全，无数据竞争 | BLOCKER | 并发安全 |

## Rust 特定检查

### 编译检查
```bash
cargo check --all-targets --all-features
cargo clippy -- -D warnings
```

### 测试运行
```bash
cargo test --release
cargo test -- --nocapture
```

### 安全检查
```bash
cargo audit
```

### 基准测试
```bash
cargo bench
```

### 性能分析
```bash
cargo flamegraph
```

## 所有权检查

```rust
// ✅ 正确的所有权管理
fn process(data: Vec<Item>) -> Result<Output, Error> {
    let result = data
        .iter()
        .filter(|i| i.valid)
        .map(|i| transform(i))
        .collect::<Result<Vec<_>, _>>()?;
    Ok(Output::new(result))
}

// ✅ 借用检查
fn calculate(data: &[Item]) -> i32 {
    data.iter().map(|i| i.value).sum()
}

// ❌ 编译错误 - 所有权冲突
// fn bad(data: &Vec<Item>) {
//     data.push(item);  // 错误：不可变借用下修改
// }
```

## 异步检查

```rust
// ✅ 正确的异步代码
async fn fetch_data() -> Result<Data, Error> {
    let response = client
        .get(url)
        .send()
        .await?
        .json::<Data>()
        .await?;
    Ok(response)
}

// ✅ 并发处理
async fn process_all(items: Vec<Item>) -> Vec<Result<Output, Error>> {
    let futures = items.into_iter().map(|i| process(i));
    futures::future::join_all(futures).await
}

// ❌ 阻塞异步运行时
async fn bad() {
    std::thread::sleep(Duration::from_secs(1));  // 阻塞！
}

// ✅ 正确的阻塞处理
async fn good() {
    tokio::task::spawn_blocking(|| {
        std::thread::sleep(Duration::from_secs(1));
    }).await;
}
```

## 高性能检查

```rust
// ✅ 零成本抽象
let sum: i32 = (0..100)
    .filter(|x| x % 2 == 0)
    .map(|x| x * x)
    .sum();

// ✅ 避免分配
fn process_slice(data: &[u8]) {  // 借用而非拥有
    // ...
}

// ✅ 使用合适的数据结构
use smallvec::SmallVec;  // 小数组优化
use hashbrown::HashMap;   // 更快的 HashMap

// ✅ SIMD（谨慎使用）
#[cfg(target_arch = "x86_64")]
pub fn fast_sum(data: &[i32]) -> i32 {
    // 使用 SIMD 指令优化
}

// ❌ 过度分配
// let vec = (0..1000).collect::<Vec<_>>();  // 不必要的分配
```

## 并发安全检查

```rust
// ✅ 编译时保证线程安全
use std::sync::Arc;
use tokio::sync::Mutex;

async fn safe_concurrent(data: Arc<Mutex<Data>>) {
    let mut guard = data.lock().await;
    guard.process();  // 编译时保证互斥访问
}

// ✅ Send + Sync trait
fn spawn_task<T>(data: T) where T: Send + 'static {
    tokio::spawn(async move {
        process(data).await;
    });
}
```

## 占位符

- `{COVERAGE}`: 如 80%
- `{PERFORMANCE_THRESHOLD}`: 如 P99 < 10ms
- `{ALLOCATION_LIMIT}`: 如 0 allocations in hot path
