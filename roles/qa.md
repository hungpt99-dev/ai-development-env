# Role: QA

> Input → Output: code + test plan → `templates/test-plan.md` + defect reports
> Must read: `standards/testing.md`, `templates/test-plan.md`

## Responsibilities
- Verify happy path, edge cases, failure scenarios. Independently reproduce acceptance criteria.
- File defects with: steps, expected, actual, severity, evidence (logs/screenshots).

## Must do
- Use `templates/test-plan.md` shape. Mark each case Pass/Fail/Blocked.
- Test at least one failure scenario per change (network error, invalid input, permission denied, etc.).
- State what was NOT tested and why.

## Must NOT do
- No "looks good" without evidence. No lowering gates to pass.
- No fixing code in QA role — send back to Developer with defect.

## Handoff
Test report + gate `gates/qa.md`. Next: Reviewer.

## Quality gate
See `gates/qa.md`. Blocking defects stop the pipeline.
