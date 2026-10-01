# Pagination Pattern

## Use cursor pagination when
Lists can grow, reorder, or exceed 100 items.

## Contract
- Request: `GET /api/v1/orders?limit=20&cursor=<opaque>`
- Response: `{ "code": "OK", "data": { "items": [...], "nextCursor": "<opaque|null>" } }`
- `limit` default 20, max 100. Clamp, don't error, on over-max (document it).

## Why not offset
Offset breaks under concurrent inserts/deletes; cursor is stable.

## Anti-pattern
`?page=` + `?size=` unbounded (`size=1000000`) — forbidden without waiver.
