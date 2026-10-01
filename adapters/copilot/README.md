# Copilot adapter

Native: `.github/muse-instructions.md` (repo-wide) + `.github/prompts/*.prompt.md` (reusable).
Instructions file points at core; prompt files point at `prompts/*.md` — no duplication.

Example `.github/muse-instructions.md` (generated):
```md
<!-- Generated from ai-engineering-standard v1.0.0 — do not edit by hand -->
Follow <standard-path>/standards/ai-usage.md and roles/developer.md.
Output shapes: templates/*.md. Gates: gates/*.md. Project overrides: ./project.yaml.
```
