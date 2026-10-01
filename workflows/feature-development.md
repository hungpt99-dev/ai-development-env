# Workflow: Feature Development (BA → Architect → Developer → QA → Reviewer → DevOps)

> Default workflow (`team.yaml` → `defaults.workflow`). Each stage has a gate in `gates/`.
> Handoff = artifact + gate self-check. Human approves gates marked 🔒.

```text
[BA] requirement.md ──🔒gate:requirement──▶ [Architect] design + tasks ──🔒gate:architecture──▶
[Developer] code+tests ──gate:implementation──▶ [QA] test report ──gate:qa──▶
[Reviewer] review ──🔒gate:review──▶ [DevOps] release ──gate:release──▶ done
```

## 1. BA — clarify
- Role: `roles/ba.md`. Prompt: `prompts/analyze.md`. Template: `templates/requirement.md`.
- Output: requirement doc. Gate: `gates/requirement.md` 🔒 human approves.

## 2. Architect — design
- Role: `roles/architect.md`. Prompt: `prompts/plan.md`. Templates: `technical-design.md` + `task-breakdown.md`.
- Output: design + sequenced tasks. Gate: `gates/architecture.md` 🔒 human approves.

## 3. Developer — implement
- Role: `roles/developer.md`. Prompt: `prompts/implement.md`.
- Output: minimal diff + tests. Gate: `gates/implementation.md` (AI self-check + CI).

## 4. QA — verify
- Role: `roles/qa.md`. Template: `templates/test-plan.md`.
- Output: test report. Gate: `gates/qa.md`. Blocking defects → back to Developer.

## 5. Reviewer — review
- Role: `roles/reviewer.md`. Prompt: `prompts/review.md`. Template: `templates/code-review.md`.
- Output: review verdict. Gate: `gates/review.md` 🔒 human approves.

## 6. DevOps — release
- Role: `roles/devops.md`. Workflow: `workflows/release.md`.
- Output: release record. Gate: `gates/release.md`.

## Anti-patterns this workflow kills
- Repeated prompting → prompts compose role+standards+template automatically (see `prompts/`).
- Context loss → handoff artifacts carried forward, never re-derived.
- Hallucinated requirements → BA quotes sources; Architect marks Unknown; gates enforce Decision log.
