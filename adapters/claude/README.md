# Claude adapter

Native: `CLAUDE.md` at repo root + slash commands in `.claude/commands/*.md`.
Each command file contains only front-matter + one pointer line:
`Follow <standard-path>/prompts/<id>.md and its front-matter read_first list.`

## mapping.yaml
See `mapping.yaml`. Commands: analyze, plan, implement, review, debug → `prompts/*.md`.
Memory: point at `knowledge/index.yaml` for slice retrieval, not full dumps.
