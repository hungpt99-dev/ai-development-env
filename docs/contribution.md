# Contribution Guide

## What goes where
- Team-wide rule → `standards/`. Project-only rule → that project's `project.yaml` / knowledge, never this repo.
- New reusable output shape → `templates/`. New check → `gates/`. New stepwise instruction → `prompts/` (with front-matter).
- Tool-specific glue → `adapters/<tool>/` only. Rule text in adapters = reject.

## Bar for acceptance
1. Small + focused (<150 lines preferred for knowledge; standards state rules, not essays).
2. Includes: purpose header (who uses it, mandatory?), Decision log where decisions appear, Sources/Related.
3. Registered: knowledge docs in `knowledge/index.yaml`; adapter refs in `adapters/<tool>/mapping.yaml`.
4. `pwsh ./scripts/validate.ps1` (or `bash ./scripts/validate.sh`) passes.

## PR shape
- Title: `<scope>: <change>` (e.g. `gates: tighten release smoke-test`).
- Body: why, what AI tools were tested with, version impact (major/minor/patch per `docs/versioning.md`).
- Breaking change: include `Migration:` section + CHANGELOG entry.

## Reviews
One human approval minimum. Standards/security changes need tech-lead approval.
