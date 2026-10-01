# AI Engineering Standard — Team Kit

> **AI accelerates execution. Humans own decisions.**

One version-controlled source of truth for how this team uses AI during software development.
Tool-agnostic. Model-agnostic. Provider-agnostic.

AI tools (OpenCode, Claude Code, Cursor, Copilot, Codex, …) are **clients/adapters** of this standard — never the standard itself.

## Start here

1. Read `docs/getting-started.md` (5-minute onboarding)
2. Check `team.yaml` (team defaults + standard version)
3. Pick your adapter: `adapters/<your-tool>/README.md`
4. Run the installer: `./scripts/install.ps1` (Windows) or `./scripts/install.sh` (macOS/Linux)

## What's inside

| Path | Purpose |
|---|---|
| `standards/` | Non-negotiable engineering rules (coding, architecture, security, testing, git, AI usage) |
| `roles/` | What each AI role may / must / must-not do (BA → Architect → Developer → QA → Reviewer → DevOps) |
| `workflows/` | End-to-end SDLC workflows with handoffs and quality gates |
| `gates/` | Pass/fail checklists per stage — used by humans and AI alike |
| `templates/` | Reusable output shapes (requirement, design, tasks, test plan, review) |
| `prompts/` | Small composable AI instructions (analyze, plan, implement, review, debug) |
| `knowledge/` | Small focused docs: engineering, architecture, patterns, glossary, examples |
| `adapters/` | Thin per-tool translations. No rules duplicated here. |
| `scripts/` | `install.*` + `validate.*` — onboarding and CI checks |
| `docs/` | Architecture, contribution, customization, versioning |
| `team.yaml` | Team identity, defaults, standard version |
| `project.example.yaml` | How a project overrides/extends team rules without forking |

## Core principle

- AI **assists** with: analysis, documentation, implementation, testing, review, debugging, refactoring.
- AI **must not** silently make product or architectural decisions.
- Every AI output that touches a decision must label:
  `Decided (human)` · `Proposed by AI` · `Assumption` · `Open question` · `Trade-off`

## Precedence (highest wins)

```
project.yaml (project overrides)
  > team.yaml (team defaults)
    > standards/ (team rules)
```

A project may **add** rules or **tighten** rules. It may only **loosen** a rule with an explicit waiver (`waivers:` in project config + expiry + approver).

## Version

Current standard version: see `team.yaml` → `standard_version` (now `1.0.0`).
Versioning policy: `docs/versioning.md`. Changelog: `CHANGELOG.md`.
Validation: `pwsh ./scripts/validate.ps1` or `bash ./scripts/validate.sh`.

## Design choice: no `core/` wrapper

This repo keeps the standard at the **root** (`standards/`, `roles/`, …) and isolates tool specifics under `adapters/`.
Rationale: less nesting, shorter relative links, easier `git sparse-checkout`, and the root *is* the source of truth by default.
See `docs/architecture.md` for justification and alternatives considered.
