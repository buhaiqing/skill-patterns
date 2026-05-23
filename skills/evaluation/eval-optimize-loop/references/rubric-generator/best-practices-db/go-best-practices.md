# Go 开发最佳实践

## Go 哲学

> **Do more with less** — 简洁、清晰、高效

**Go 的设计原则**:
- **简洁性** — 语法简单，特性克制
- **清晰性** — 代码意图明确，可读性优先
- **正交性** — 组件独立，组合使用
- **少即是多** — 没有泛型（1.18前）、没有继承，用组合

```go
// ✅ Go 风格 — 简洁、明确
func process(items []Item) error {
    for _, item := range items {
        if err := handle(item); err != nil {
            return err
        }
    }
    return nil
}

// ❌ 过度设计 — 复杂抽象
// 使用继承、泛型过度等
```

## 代码风格

### gofmt
- 强制使用 `gofmt` 格式化
- 不接受任何格式争议

### 命名规范

| 类型 | 规范 | 示例 |
|------|------|------|
| 包名 | 小写，简短 | `net/http` |
| 变量 | camelCase | `userName` |
| 常量 | CamelCase 或 全大写 | `MaxRetries` |
| 接口 | -er 后缀 | `Reader`, `Writer` |

## 项目结构

```
my_project/
├── cmd/
│   └── myapp/
│       └── main.go
├── internal/
│   └── pkg/
├── pkg/
│   └── public/
├── api/
├── configs/
├── deployments/
├── docs/
├── go.mod
├── go.sum
└── README.md
```

## 错误处理

```go
// ✅ 显式错误处理
if err != nil {
    return err
}

// ✅ 包装错误
if err != nil {
    return fmt.Errorf("failed to fetch user: %w", err)
}

// ❌ 不要忽略错误
_ = doSomething() // 危险！
```

## 并发模式

```go
// ✅ Channel 通信
go func() {
    resultChan <- result
}()

// ✅ Context 取消
ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()

// ❌ 不要共享内存，用 channel 通信
```

## Go  idioms（惯用法）

### 简洁优先

```go
// ✅ 简洁
if err != nil {
    return err
}

// ✅ 利用零值
var mu sync.Mutex  // 零值可用，无需初始化

// ✅ 短变量声明
name := user.Name

// ✅ 利用 range
for i, v := range items {
    // ...
}
```

### 标准库优先

```go
// ✅ 使用标准库
import (
    "net/http"
    "encoding/json"
    "context"
)

// ✅ 简单实现优于依赖
// 简单缓存用 map + sync.RWMutex，而非 Redis（除非必要）
```

### 组合优于继承

```go
// ✅ 组合
type Server struct {
    *http.Server
    logger *Logger
}

// ❌ Go 没有继承
```

## 常见陷阱

| 陷阱 | 说明 | 解决 |
|------|------|------|
| 闭包变量捕获 | for 循环里用 goroutine | 传参复制 |
| nil pointer | interface nil 陷阱 | 检查 nil |
| slice 共享 | append 导致共享底层 | make 新 slice |
| defer 参数 | defer 立即求值 | 传指针或闭包 |
| 过度工程 | 复杂抽象、过早优化 | KISS 原则 |

## 测试

```go
// 表格驱动测试
func TestCalculate(t *testing.T) {
    tests := []struct {
        name     string
        x, y     int
        expected int
    }{
        {"positive", 1, 2, 3},
        {"zero", 0, 0, 0},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := Calculate(tt.x, tt.y)
            if result != tt.expected {
                t.Errorf("got %d, want %d", result, tt.expected)
            }
        })
    }
}
```

## 性能优化

- `sync.Pool` 复用对象
- `strings.Builder` 替代 `+` 拼接
- `pprof` 分析性能
- `benchmark` 对比优化

## 工具链

| 工具 | 用途 |
|------|------|
| gofmt | 格式化 |
| golint | 代码检查 |
| go vet | 静态分析 |
| go test | 测试 |
| go mod | 依赖管理 |
