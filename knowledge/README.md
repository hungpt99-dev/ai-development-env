# Knowledge Base — how to add and retrieve team knowledge

> Rule: many small focused docs beat one giant README. Each doc answers ONE question.

## Layout

- `engineering/` — stack-agnostic how-tos (logging, error handling, API design, migrations)
- `architecture/` — system maps, ADRs in `decisions/`, error catalogs
- `patterns/` — reusable code/API patterns with good/bad examples
- `glossary/` — domain + engineering terms (one term = 2-4 lines)
- `examples/` — redacted real examples (never secrets / never real PII)

## Index for tools (optional RAG/MCP future)

`index.yaml` lists every doc with title, tags, and path so adapters / RAG / MCP / Dify
can retrieve slices without dumping the whole base. File-based lookup works today;
vector search is an upgrade, not a requirement.

## Adding knowledge

1. One topic per file, `<kebab-case>.md`, <150 lines preferred.
2. Start with: when to use / when NOT to use.
3. End with: Source / Related links.
4. Register in `index.yaml` (validated by `scripts/validate.*`).
5. Never commit secrets or real customer data — use `example.invalid` / `REPLACE_ME`.
