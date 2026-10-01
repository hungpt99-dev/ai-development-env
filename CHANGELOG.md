# Changelog

All notable changes to the AI Engineering Standard.

Format follows [Keep a Changelog](https://keepachangelog.com/) + SemVer.
Version source of truth: `team.yaml` → `standard_version`.

## [1.0.0] - 2026-10-01

### Added
- Initial tool-agnostic standard: `standards/`, `roles/`, `workflows/`, `gates/`
- Templates: requirement, technical-design, task-breakdown, test-plan, code-review, decision-log
- Prompts: analyze, plan, implement, review, debug (composable, front-matter)
- Knowledge skeleton + `knowledge/index.yaml` for future RAG/MCP
- Adapters: opencode, claude, cursor, copilot, codex (reference-only, no rule duplication)
- Scripts: `install.ps1` / `install.sh`, `validate.ps1` / `validate.sh`
- Docs: getting-started, architecture, contribution, customization, versioning
- `team.yaml` + `project.example.yaml` precedence model

### Rules for future entries
- MAJOR (X.0.0): gate changes, template field removal/rename, role authority change, precedence change.
- MINOR (1.X.0): new optional template/prompt/adapter, new additive standard.
- PATCH (1.0.X): wording, examples, script fixes.
- Every MAJOR must include a `Migration:` subsection.
