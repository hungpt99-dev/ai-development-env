# Versioning

Source of truth: `team.yaml` → `standard_version` (SemVer `MAJOR.MINOR.PATCH`). History: `CHANGELOG.md`.

## What bumps what
- **MAJOR**: gate item added/removed, template required-field rename/removal, role authority change, precedence change, adapter contract change.
- **MINOR**: new optional template/prompt/knowledge/adapter, new additive rule, new tightening option.
- **PATCH**: wording, examples, script fixes, doc clarifications.

## Breaking-change protocol
1. Bump MAJOR + add `CHANGELOG.md` entry with `Migration:` steps (old → new, script if possible).
2. Update `adapters/*/mapping.yaml` `standard_version`.
3. Projects pin via `project.yaml`: `extends_standard` + `compatible_with: ">=1.0.0 <2.0.0"` blocks silent major drift; installer warns on mismatch.
4. Keep old major branch (`v1.x`) for 3 months with security fixes only.

## CI suggestion (optional, no infra required)
Run `scripts/validate.*` on PR + on schedule. Fail on: missing files, dangling adapter refs, secret heuristic hit, version mismatch.
