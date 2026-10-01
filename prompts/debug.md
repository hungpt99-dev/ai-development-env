---
id: debug
role: roles/developer.md
read_first: [standards/coding.md, standards/testing.md, standards/ai-usage.md]
output: root cause + regression test + minimal fix
---

# Debug

1. Reproduce first: write/extend a failing test that captures the bug BEFORE fixing.
2. Explain root cause (5-whys, 2-4 lines). Cite code paths / logs.
3. Minimal fix, no unrelated refactors. If fix touches architecture, STOP and escalate.
4. Verify: failing test now passes + adjacent regression area checked. Report commands + results.
5. Prevention: why did this escape (missing test? unclear requirement?) + one follow-up action.
6. End with Decision log (esp. Assumptions about environment/data).

Input: <paste error, logs, repro steps, suspected area below>
