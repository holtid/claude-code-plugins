---
name: power-of-ten-ts
description: NASA/JPL Power of Ten rules adapted for TypeScript/React
user-invocable: false
---

# Power of Ten - TypeScript

TypeScript-specific implementation guidance for NASA/JPL's safety-critical code rules. See `power-of-ten-reviewer` for core principles.

## 1. Simple Control Flow

Avoid `eval()`, dynamic code execution, and unbounded recursion. Use depth limits when recursion is necessary.

**TypeScript**:
```typescript
// Bad: unbounded recursion
function traverse(node: Node): void {
  node.children.forEach(traverse);
}

// Good: bounded with depth limit
function traverse(node: Node, depth = 0, maxDepth = 100): void {
  if (depth >= maxDepth) {
    throw new Error(`Max depth ${maxDepth} exceeded`);
  }
  node.children.forEach(child => traverse(child, depth + 1, maxDepth));
}
```

Avoid deeply nested callbacks - use async/await. Keep promise chains flat.

## 2. Bounded Loops

All loops must have fixed, provable upper bounds. Add explicit limits on dynamic operations (data traversal, network requests).

**TypeScript**:
```typescript
// Bad: unbounded
while (await hasMore()) {
  items.push(await fetchNext());
}

// Good: bounded with limit
const MAX_ITEMS = 10000;
while (await hasMore() && items.length < MAX_ITEMS) {
  items.push(await fetchNext());
}
if (items.length >= MAX_ITEMS) {
  throw new Error(`Exceeded maximum items: ${MAX_ITEMS}`);
}

// Bad: unbounded fetch
await fetch(url);

// Good: bounded with timeout
const controller = new AbortController();
const timeout = setTimeout(() => controller.abort(), 30000);
try {
  await fetch(url, { signal: controller.signal });
} finally {
  clearTimeout(timeout);
}
```

## 3. No Dynamic Allocation After Init

Avoid allocations in hot paths. Memoize computed values and reuse objects where possible.

**TypeScript**:
```typescript
// Bad: allocation in render loop
function Component({ items }) {
  return items.map(item => ({ ...item, selected: false })); // new object each render
}

// Good: memoized
function Component({ items }) {
  const processed = useMemo(
    () => items.map(item => ({ ...item, selected: false })),
    [items]
  );
  return processed;
}

// Bad: allocation in event handler called frequently
onScroll={() => {
  const rect = { x: 0, y: scrollY }; // new object each scroll
}}

// Good: reuse or pool objects
const rect = useRef({ x: 0, y: 0 });
onScroll={() => {
  rect.current.y = scrollY; // mutate existing
}}
```

Watch for memory leaks in closures and event listeners - always clean up in useEffect.

## 4. Function Length

Max ~60 lines per function. Long functions indicate poor structure.

**TypeScript**:
- Keep components under 500 lines
- Extract custom hooks for reusable logic
- If a function needs section comments, split it
- Each function/component should do one thing

## 5. Assertion Density

Minimum 2 assertions per function. Validate inputs at trust boundaries and check postconditions.

**TypeScript**:
```typescript
// Validate at trust boundaries with Zod
const UserSchema = z.object({
  id: z.string().uuid(),
  email: z.string().email(),
  age: z.number().int().positive().max(150),
});

async function processUser(input: unknown): Promise<Result> {
  // Precondition: validate external data
  const user = UserSchema.parse(input);

  // Precondition: business rule
  if (user.age < 18) {
    throw new Error('User must be 18 or older');
  }

  const result = await doSomething(user);

  // Postcondition: invariant check
  if (result.processedAt > Date.now()) {
    throw new Error('Invariant violated: processedAt cannot be in future');
  }

  return result;
}
```

## 6. Minimal Scope

Declare data at smallest possible scope. Prefer `const` and hide state in closures.

**TypeScript**:
```typescript
// Bad: broad scope
let result: string;
if (condition) {
  result = 'a';
} else {
  result = 'b';
}

// Good: minimal scope
const result = condition ? 'a' : 'b';

// Bad: module-level mutable state
let cache: Map<string, Data> = new Map();

// Good: encapsulated
function createCache() {
  const cache = new Map<string, Data>();
  return { get: (k) => cache.get(k), set: (k, v) => cache.set(k, v) };
}
```

- Prefer `const` over `let`
- Keep React state minimal - compute derived values
- Avoid module-level mutable state

## 7. Check All Returns

Always handle promise rejections and check for undefined/null. Propagate errors up the call chain.

**TypeScript**:
```typescript
// Bad: ignoring promise rejection
fetch('/api/data');

// Bad: ignoring possible undefined
const user = users.find(u => u.id === id);
console.log(user.name); // might crash

// Good: handle all cases
try {
  const response = await fetch('/api/data');
  if (!response.ok) {
    throw new Error(`HTTP ${response.status}`);
  }
  const data = await response.json();
} catch (error) {
  logger.error('Fetch failed', error);
  throw error;
}

// Good: handle undefined
const user = users.find(u => u.id === id);
if (!user) {
  throw new Error(`User ${id} not found`);
}
console.log(user.name);
```

## 8. Type Discipline

No `any` or unsafe type assertions. Use `unknown` with runtime validation. Enable strict mode in tsconfig.

**TypeScript**:
```typescript
// Bad
const data: any = await response.json();
const user = data as User;

// Good
const data: unknown = await response.json();
const user = UserSchema.parse(data); // runtime validation

// Bad: optional fields hide states
interface User {
  name?: string;
  email?: string;
}

// Good: discriminated union makes states explicit
type User =
  | { status: 'guest' }
  | { status: 'registered'; name: string; email: string };
```

Use `strict: true` in tsconfig. Zero `@ts-ignore`.

## 9. Reference Discipline

Limit optional chaining to one level. Handle nulls explicitly at boundaries. Prefer immutability.

**TypeScript**:
```typescript
// Bad: deep optional chain hides nulls
const city = user?.address?.city?.name;

// Good: explicit handling at boundary
if (!user?.address?.city) {
  throw new Error('User address incomplete');
}
const city = user.address.city.name;

// Bad: mutation
function process(user: User) {
  user.processed = true; // side effect
}

// Good: immutable
function process(user: User): User {
  return { ...user, processed: true };
}
```

Destructure with defaults at trust boundaries. Prefer immutable patterns.

## 10. Zero Warnings

Use static analyzers with zero warnings. Fix confusing code, don't ignore errors.

**TypeScript**:
```json
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true
  }
}
```

```bash
tsc --noEmit
eslint --max-warnings 0 .
```

Never use `// eslint-disable` or `@ts-ignore` - fix the code instead.
