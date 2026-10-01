---
id: implement
role: roles/developer.md
read_first: [standards/coding.md, standards/testing.md, standards/security.md, standards/ai-usage.md, gates/implementation.md]
output: code diff + test report summary
---

# Implement (Developer)

Implement the approved tasks with the smallest diff that satisfies acceptance criteria.

Rules:
1. Read role + standards + linked design/tasks FIRST. State project conventions followed.
2. Follow the design. Any deviation → `Deviation:` + reason; architectural deviation → STOP and ask.
3. Add tests: happy + edge + ≥1 failure case. State run command + result (or `Not run — needs human verification`).
4. Run formatter/lint/typecheck; report secret-scan.
5. Summary shape: what changed / why / how to verify / Security section / Decision log.
6. Never commit/push without explicit human approval. Never invent APIs.

Input: <paste task IDs + design doc path below>
