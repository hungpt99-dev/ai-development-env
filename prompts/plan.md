---
id: plan
role: roles/architect.md
read_first: [standards/architecture.md, standards/security.md, standards/ai-usage.md, templates/technical-design.md, templates/task-breakdown.md, gates/architecture.md]
output: templates/technical-design.md + templates/task-breakdown.md
---

# Plan (Architect)

Produce a design doc + task breakdown in the shape of the templates.

Rules:
1. Read role + standards + templates FIRST.
2. If current-system facts are missing, write `Unknown — needs human confirmation (owner: …)`. Do not guess.
3. Where trade-off exists, present ≥2 options with pros/cons, then a clearly-marked `Proposed by AI` recommendation. Human selects.
4. Security + Observability + Failure handling sections mandatory (justify "None" if truly none).
5. Tasks: each <1 day, with acceptance criteria + test requirements + dependencies + sequencing.
6. End with Decision log. Self-check against `gates/architecture.md`.

Input: <paste approved requirement doc link/path below>
