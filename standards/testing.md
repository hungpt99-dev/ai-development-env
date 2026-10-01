# Testing Standard (tool-agnostic)

> Who: Developer + QA. Mandatory: yes.

## 1. Levels

- Unit: pure logic, fast, no I/O. Required for new business rules.
- Integration: DB/queue/API boundaries with real collaborators (testcontainers or equivalent where practical).
- E2E / contract: happy path + one failure path for public APIs / critical flows.

## 2. Rules

1. New behavior => new/updated test. Bug fix => regression test that failed before the fix.
2. Tests assert behavior, not implementation: prefer public API over privates/mocks of internals.
3. No snapshots without approval for UI/text output; snapshots must be reviewed like code.
4. Flaky test = bug: quarantine + file issue, do not `@skip` silently.
5. Coverage gate (team default): >=70% on new/changed lines. Projects may tighten (see `project.example.yaml`).

## 3. AI-specific rules

- AI must generate: happy path + edge cases + at least one failure scenario per change.
- AI must state how to run the tests (`<cmd>`) and report pass/fail. If it cannot run them, say `Not run — needs human verification`.
- AI must not lower coverage gates or delete failing tests to turn green. Failing test => investigate, don't erase.
