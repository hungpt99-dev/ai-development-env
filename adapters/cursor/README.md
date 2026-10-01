# Cursor adapter

Native: `.cursor/rules/*.mdc` (one per concern) + project root `.cursorignore`.
Each `.mdc` has `globs:` + one-line pointer to the core file — rule text stays in core.

Example `.cursor/rules/ai-usage.mdc`:
```md
---
globs: ["**/*"]
---
<!-- Generated from ai-engineering-standard v1.0.0 — do not edit by hand -->
Follow standards/ai-usage.md (decision labels + anti-hallucination). See <standard-path>.
```
