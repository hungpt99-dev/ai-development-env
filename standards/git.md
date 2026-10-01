# Git Standard (tool-agnostic)

> Who: everyone. Mandatory: yes.

## 1. Branches

- `main` is always releasable. Short-lived branches: `feat/<slug>`, `fix/<slug>`, `chore/<slug>`.
- Rebase/squash before merge to keep history readable (follow project convention).

## 2. Commits

- Format: `<type>(<scope>): <subject>` — types: `feat|fix|docs|refactor|test|chore`.
- Subject <=72 chars, imperative ("add", not "added"). Body explains WHY, not WHAT.
- One logical change per commit. AI-generated commits must be reviewed (`git diff`) before push.

## 3. PRs

- Small PRs (<400 changed lines preferred). PR description links requirement + design + test evidence.
- Required checks: build, lint, tests, secret-scan pass before human review.
- No direct push to `main`. No force-push to shared branches.

## 4. AI-specific rules

- AI must never `push`, `merge`, or `publish` without explicit human approval.
- AI must never commit secrets (see `security.md`). Run validation before commit.
