# OpenCode adapter — reference only, no rule duplication

> Native mechanism: `AGENTS.md` (repo root) + optional `opencode.json` commands.
> Installer (`scripts/install.ps1 -Tool opencode`) generates these by referencing core files.

## mapping.yaml
See `mapping.yaml` in this directory. Validated by `scripts/validate.*`.

## Generated `AGENTS.md` shape (installer writes this; do not hand-edit)

```md
<!-- Generated from ai-engineering-standard v1.0.0 — do not edit by hand -->
# Project AI instructions (OpenCode)

Core standard: <path-to-standard-repo> (version 1.0.0)
Project config: ./project.yaml (overrides team defaults)

Always load before acting:
- standards/ai-usage.md (decision labels, anti-hallucination)
- roles/<active-role>.md + prompts/<task>.md (front-matter read_first)
- templates/<artifact>.md for output shape; gates/<stage>.md for self-check

Precedence: project.yaml > team.yaml > standards/
Human owns decisions — end outputs with the Decision log block.
```

## Commands (optional `opencode.json`)
Installer maps prompts 1:1 — `analyze` → `prompts/analyze.md`, `plan` → `prompts/plan.md`, etc.
Commands contain only a pointer (`Read prompts/implement.md and follow it`), never prompt text copies.
