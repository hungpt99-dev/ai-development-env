---
# Front-matter: how any adapter composes this prompt. Tool-agnostic.
id: analyze
role: roles/ba.md
read_first: [standards/ai-usage.md, templates/requirement.md, gates/requirement.md]
output: templates/requirement.md
---

# Analyze (BA)

Produce a requirement doc in the shape of `templates/requirement.md`.

Rules:
1. Read role + standards + template FIRST (see front-matter).
2. Quote sources for key requirements. Never invent.
3. Number FR/BR/AC. Each AC must be testable.
4. List edge cases; if none, justify why.
5. Separate Assumptions from Open questions. Mark blocking questions.
6. End with the Decision log block (all five lines, `None` if empty).
7. Self-check against `gates/requirement.md` and report pass/fail per item.

Input: <paste raw request / ticket / transcript below>
