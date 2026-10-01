# Workflow: Bug Fix (short-circuit)

> Roles: Developer → QA → Reviewer. BA/Architect only if scope unclear.

1. **Reproduce first**: Developer writes failing regression test BEFORE fix (`prompts/debug.md`).
2. **Root cause**: 5-whys in the fix summary; no "fixed by tweaking".
3. **Minimal fix**: no refactors, no feature creep. Deviation from surrounding design → escalate.
4. **QA**: verify fix + regression suite + one adjacent area (regression risk).
5. **Review**: must explain why bug escaped (missing test? unclear requirement?) + prevention.

Gate: `gates/implementation.md` + `gates/qa.md`. Human approves review.
Template: `templates/task-breakdown.md` (single task) + defect section in test report.
