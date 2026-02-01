---
name: power-of-ten-go
description: NASA/JPL Power of Ten rules adapted for Go
user-invocable: false
---

# Power of Ten - Go

Go-specific implementation guidance for NASA/JPL's safety-critical code rules. See `power-of-ten-reviewer` for core principles.

## 1. Simple Control Flow

Avoid `goto` and unbounded recursion. Convert recursive functions to iteration; if necessary, add depth limits. Early returns for errors are fine.

## 2. Bounded Loops

All loops must have fixed, provable upper bounds. Add explicit limits on channels, data traversal, and network operations.

**Go - Channels**:
```go
// Bad: unbounded channel receive
for item := range channel { }  // Will block forever if no close

// Good: use context timeout
ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
defer cancel()
for {
  select {
  case item, ok := <-channel:
    if !ok {
      return nil  // channel closed
    }
    // process item
  case <-ctx.Done():
    return fmt.Errorf("timeout: processing took too long")
  }
}

// Good: bound by received count
const maxItems = 10000
count := 0
for item := range channel {
  if count >= maxItems {
    return fmt.Errorf("exceeded max items: %d", maxItems)
  }
  // process item
  count++
}

// Good: explicit close signal channel
done := make(chan struct{})
for {
  select {
  case item, ok := <-channel:
    if !ok {
      return nil
    }
    // process item
  case <-done:
    return nil
  }
}
```

**Go - Data Traversal**:
```go
// Bad: unbounded iteration
for node != nil { node = node.Next }

// Good: explicit bound
const maxNodes = 10000
for i := 0; node != nil && i < maxNodes; i++ {
  node = node.Next
}
if node != nil {
  return fmt.Errorf("traversal exceeded %d nodes", maxNodes)
}
```

## 3. No Dynamic Allocation After Init

Pre-allocate in hot paths. Go has GC, but allocation unpredictability affects latency.

**Go**:
- Pre-allocate slices: `make([]T, 0, expectedSize)`
- Use `sync.Pool` for frequently allocated objects
- Avoid allocations in tight loops
- Watch hidden allocations: string concat, interface boxing, closures

## 4. Function Length

Max ~60 lines per function. If a function needs section comments, split it. Each function should do one thing.

## 5. Assertion Density

Minimum 2 assertions per function. Validate inputs at boundaries and check postconditions.

**Go**:
```go
func Process(data []byte, limit int) error {
    // Precondition: validate inputs
    if data == nil {
        return errors.New("data cannot be nil")
    }
    if limit <= 0 || limit > MaxLimit {
        return fmt.Errorf("limit out of range: %d (must be [1, %d])", limit, MaxLimit)
    }

    // ... logic ...

    // Postcondition: verify invariants
    if result < 0 {
        return errors.New("invariant violated: result must be non-negative")
    }
    return nil
}
```

## 6. Minimal Scope

Declare data at smallest possible scope. Avoid package-level mutable state.

**Go**:
- Declare variables at point of first use
- Use short-lived variables in tight scopes
- Avoid package-level variables (except true constants)
- Don't reuse variables for different purposes

## 7. Check All Returns

Always check error returns. Never use blank identifier for error values.

**Go**:
```go
// Bad: ignoring errors
result, _ := SomeFunc()
io.Copy(dst, src)

// Good: handle all errors
result, err := SomeFunc()
if err != nil {
    return fmt.Errorf("SomeFunc: %w", err)
}

n, err := io.Copy(dst, src)
if err != nil {
    return fmt.Errorf("copy failed: %w", err)
}
if n == 0 {
    return errors.New("no data written")
}
```

## 8. Limited Code Generation

Minimize `go generate` and build tags. Code generation obscures what's running.

**Go**:
- Minimize `//go:build` tags
- Keep generated code simple and auditable
- Avoid complex `go generate` pipelines

## 9. Pointer Discipline

Restrict indirection. No `**T` (pointer to pointer). Limit interfaces to deliberate abstractions.

**Go**:
- Avoid `**T` - if needed, document why
- Be explicit about nil - check at trust boundaries
- Prefer value receivers unless mutation is necessary
- Use interfaces deliberately, not as default practice
- Document when `interface{}`/`any` is necessary

## 10. Zero Warnings

Use linters with zero warnings. Fix confusing code, don't ignore errors.

**Go**:
```bash
go vet ./...
golangci-lint run --no-new-issues .
staticcheck ./...
```

Never use `// nolint` or `//lint:ignore` - fix the code instead. Enable strict checks in your CI.

**Channels - Best Practices**:
```go
// Bad: unbounded receive without signal
for item := range channel {
    process(item)  // What stops this?
}

// Good: explicit shutdown signal
done := make(chan struct{})
for {
    select {
    case item, ok := <-channel:
        if !ok {  // channel closed by sender
            return nil
        }
        process(item)
    case <-done:
        return nil
    }
}

// Good: context cancellation
ctx, cancel := context.WithCancel(context.Background())
defer cancel()
for {
    select {
    case item, ok := <-channel:
        if !ok {
            return nil
        }
        process(item)
    case <-ctx.Done():
        return ctx.Err()
    }
}

// Good: always check if channel is open
func SafeReceive(ch <-chan Item) (Item, error) {
    select {
    case item, ok := <-ch:
        if !ok {
            return Item{}, errors.New("channel closed")
        }
        return item, nil
    case <-time.After(5 * time.Second):
        return Item{}, errors.New("timeout")
    }
}
```
