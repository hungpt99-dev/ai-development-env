# Adapters — thin translators, never rule duplicates

> Core rule: adapters REFERENCE core artifacts. They never copy-paste rules.
> If a rule changes, only `standards/` / `roles/` / `workflows/` change; adapters keep working.

## Contract (enforced by `scripts/validate.*`)

1. Each `adapters/<tool>/` has `README.md` + `mapping.yaml` listing which core files it exposes and the native mechanism (e.g. `AGENTS.md`, `.cursor/rules`, `CLAUDE.md`, MCP, slash command).
2. `mapping.yaml` must reference only existing core paths + the standard version it was tested against.
3. Generated / copied output must contain a header: `Generated from ai-engineering-standard vX.Y.Z — do not edit by hand`.
4. No engineering rule text inside adapters except 1-2 line pointers (links/paths).

## How to add a new tool

1. Copy `adapters/_template/` to `adapters/<new-tool>/`.
2. Fill `mapping.yaml` + `README.md`. Keep it <50 lines.
3. Run `./scripts/install.ps1 -Tool <new-tool> -RepoRoot <your-project>` in a test project.
4. Run validation; open PR.

## Current adapters

| Tool | Native mechanism | Entry point |
|------|------------------|-------------|
| opencode | `AGENTS.md` + `opencode.json` commands | `adapters/opencode/` |
| claude | `CLAUDE.md` + slash commands | `adapters/claude/` |
| cursor | `.cursor/rules/` + `.cursorignore` | `adapters/cursor/` |
| copilot | `.github/muse-instructions.md` + `.github/prompts/` | `adapters/copilot/` |
| codex | `AGENTS.md` + `codex` prompts | `adapters/codex/` |
