---
id: review
role: roles/reviewer.md
read_first: [standards/coding.md, standards/security.md, standards/testing.md, templates/code-review.md, gates/review.md]
output: templates/code-review.md
---

# Review (Reviewer)

Produce a code review in the shape of `templates/code-review.md`.

Rules:
1. Check scope first: does diff match linked requirement/design? If not, request split/link.
2. Blocking vs non-blocking separated. Every blocking item cites a rule (file + section).
3. Security section mandatory. Tests judged on meaning, not just green.
4. No formatter nitpicks. Suggest, don't rewrite.
5. Exactly one verdict: Approve / Request changes / Comment. End with Decision log.

Input: <paste diff / PR link + requirement/design links below>
