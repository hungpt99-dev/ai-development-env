# Error Handling Pattern

## Use this when
Any service boundary (API, queue consumer, scheduled job).

## Pattern
1. Validate at boundary → return typed error (`code`, `message`, offending field).
2. Log once with correlation ID: what, expected, next action.
3. Retry only idempotent ops with backoff + jitter; else DLQ / manual queue.
4. Never swallow: `catch {}` forbidden. Rethrow with context if unhandled.

```text
GOOD: throw new OrderError("ORDER_NOT_FOUND", `order ${id} not found`, { orderId: id });
BAD:  throw new Error("not found");
```

## Sources
- `standards/coding.md`, `standards/security.md` (no PII in messages)
