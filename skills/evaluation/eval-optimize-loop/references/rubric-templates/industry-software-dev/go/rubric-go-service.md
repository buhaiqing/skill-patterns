---
industry: software-dev
scenario: go-service
language: go
version: "1.0"
generated_at: "2025-05-18"
keywords: ["go", "golang", "gin", "echo", "service"]
---

# Go 服务开发 Rubric

> Go 最佳实践：显式错误处理、Context 传播、并发安全、性能优先

## 评测项

| ID | 项 | Pass 条件 | 级别 | Go 最佳实践 |
|----|-----|----------|------|------------|
| GO1 | 格式 | `gofmt` + `golint` + `go vet` 0 errors | BLOCKER | gofmt 强制 |
| GO2 | 错误 | 错误处理显式，无忽略错误 | BLOCKER | 显式错误处理 |
| GO3 | 测试 | `go test` 0 failures，覆盖率 ≥ {COVERAGE}% | BLOCKER | 表格驱动测试 |
| GO4 | 并发 | 使用 `context.Context`，无 goroutine 泄漏 | BLOCKER | Context 传播 |
| GO5 | 性能 | `go test -bench` 基准测试通过 | normal | 性能意识 |
| GO6 | 安全 | 无 `unsafe`，输入已校验 | BLOCKER | 安全编码 |
| GO7 | 文档 | 导出函数有文档注释 | normal | godoc |
| GO8 | 模块 | `go mod` 依赖管理完整，无循环导入 | normal | 模块规范 |
| GO9 | 简洁 | 代码简洁，无过度工程，符合 Go 惯用法 | normal | Do more with less |
| GO10 | 组合 | 使用组合而非复杂继承/泛型 | normal | 组合优于继承 |
| GO11 | 高性能 | 性能基准测试通过，响应时间达标 | normal | 高性能 |
| GO12 | 内存 | 无内存泄漏，GC 压力合理 | normal | 内存优化 |

## Go 特定检查

### 代码风格检查
```bash
gofmt -l .
golint ./...
go vet ./...
```

### 测试运行
```bash
go test ./... -v -coverprofile=coverage.out
go tool cover -func=coverage.out
```

### 基准测试
```bash
go test ./... -bench=. -benchmem
```

### 竞态检测
```bash
go test ./... -race
```

## Context 检查

```go
// ✅ 正确
func handler(w http.ResponseWriter, r *http.Request) {
    ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
    defer cancel()
    
    result, err := service.Process(ctx, req)
    // ...
}

// ❌ 错误 - 无 Context
func handler(w http.ResponseWriter, r *http.Request) {
    result, err := service.Process(req)  // 无法取消！
}
```

## 简洁性检查

```go
// ✅ Go 风格 — 简洁、直接
func process(items []Item) error {
    for _, item := range items {
        if err := handle(item); err != nil {
            return err
        }
    }
    return nil
}

// ✅ 利用零值
var mu sync.Mutex  // 零值可用

// ✅ 组合设计
type Server struct {
    *http.Server
    logger *Logger
}

// ❌ 过度设计 — 复杂抽象
// 使用不必要的设计模式、过度封装
```

## 高性能检查

```go
// ✅ 基准测试
func BenchmarkProcess(b *testing.B) {
    data := prepareData()
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        Process(data)
    }
}

// ✅ 性能分析
go test -bench=. -benchmem -memprofile=mem.prof -cpuprofile=cpu.prof
go tool pprof cpu.prof

// ✅ sync.Pool 复用对象
var bufPool = sync.Pool{
    New: func() interface{} { return make([]byte, 1024) },
}

func process() {
    buf := bufPool.Get().([]byte)
    defer bufPool.Put(buf)
    // 使用 buf
}

// ✅ strings.Builder 高效拼接
var b strings.Builder
b.Grow(64)  // 预分配
for _, s := range items {
    b.WriteString(s)
}
result := b.String()

// ✅ 预分配 slice
data := make([]int, 0, len(input))  // 预分配容量
for _, x := range input {
    data = append(data, x * 2)
}

// ✅ 避免不必要的内存分配
// 使用 & 而非 * 返回大对象
func process() *Result {  // 返回指针
    result := &Result{}    // 堆分配
    return result
}

// ✅ channel 性能优化
// 有缓冲 channel 减少阻塞
ch := make(chan int, 100)

// ❌ 性能陷阱 — 频繁内存分配
// 在循环内创建大对象

// ❌ GC 压力 — 大量小对象分配
// 使用 sync.Pool 或对象复用
```

## 占位符

- `{COVERAGE}`: 如 70%
- `{BENCHMARK_THRESHOLD}`: 性能阈值
