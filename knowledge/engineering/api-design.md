# API Design Conventions (team default; projects may tighten in project.yaml)

## Use this when
Designing REST endpoints.

## Rules
1. Version in path: `/api/v1/...`. Breaking change → new version.
2. Envelope: `{ "code": "<ERROR_CODE|OK>", "message": "...", "data": ... }`.
3. Errors: stable `code` + human `message` + `traceId`. Catalog codes in `knowledge/architecture/error-codes.md`.
4. Pagination: cursor preferred; `?limit=&cursor=`; response `{ items, nextCursor }`. See `patterns/pagination.md`.
5. Idempotency: `Idempotency-Key` header for POST that creates/mutates money-critical resources.

## When NOT to use
Public webhooks / third-party-mandated schemas — document the exception in the design doc.

## Sources
- Related: `knowledge/patterns/pagination.md`, `standards/security.md`
