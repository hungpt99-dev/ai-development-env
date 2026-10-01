# Workflow: Code Review

> Role: `roles/reviewer.md`. Prompt: `prompts/review.md`. Template: `templates/code-review.md`.

1. **Triage**: scope check — does diff match linked requirement/design? If not, request split or link.
2. **Correctness**: logic, edge cases, error handling match acceptance criteria.
3. **Security**: auth, input, secrets, PII per `standards/security.md`. Any doubt = blocking.
4. **Tests**: meaningful assertions? Failure path covered? No deleted/coverage-gamed tests?
5. **Verdict**: exactly one — Approve / Request changes / Comment. Blocking items cite a rule.

SLA (team default): first review within 1 business day. AI pre-review is advisory; human verdict is binding.
