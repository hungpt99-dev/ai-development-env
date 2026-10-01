# System Overview (EXAMPLE — replace with your real map)

> Projects replace this file or add their own under `knowledge/architecture/`.
> Keep it to one page + links.

## Services
- `web-api` → `orders` → `postgres` + `queue`
- `worker` consumes `queue` for notifications

## Data stores
- Postgres (source of truth), Redis (cache only, evictable)

## Decisions
- See `decisions/` (copy `templates/decision-log.md`, e.g. `001-postgres-over-mongo.md`)

## Further reading
- Error codes: `error-codes.md` (create per project)
