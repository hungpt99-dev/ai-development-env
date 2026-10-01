#!/usr/bin/env bash
# Validate the standard repo (bash port of validate.ps1). Heuristic, dependency-free.
set -uo pipefail
ROOT="${1:-}"; if [[ "$1" == "--root" ]]; then ROOT="$2"; fi
ROOT="${ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
fail=0
ok() { echo "OK:   $1"; }
bad() { echo "FAIL: $1"; fail=1; }

for f in README.md CHANGELOG.md team.yaml project.example.yaml \
  standards/coding.md standards/architecture.md standards/security.md standards/testing.md standards/git.md standards/ai-usage.md \
  roles/ba.md roles/architect.md roles/developer.md roles/qa.md roles/reviewer.md roles/devops.md \
  workflows/feature-development.md workflows/bug-fix.md workflows/code-review.md workflows/incident.md workflows/release.md \
  gates/requirement.md gates/architecture.md gates/implementation.md gates/qa.md gates/review.md gates/release.md \
  templates/requirement.md templates/technical-design.md templates/task-breakdown.md templates/test-plan.md templates/code-review.md templates/decision-log.md \
  prompts/analyze.md prompts/plan.md prompts/implement.md prompts/review.md prompts/debug.md \
  knowledge/README.md knowledge/index.yaml adapters/README.md \
  docs/getting-started.md docs/architecture.md docs/contribution.md docs/customization.md docs/versioning.md; do
  [[ -f "$ROOT/$f" ]] && ok "$f" || bad "missing $f"
done

grep -Eq 'standard_version:\s*"[0-9]+\.[0-9]+\.[0-9]+"' "$ROOT/team.yaml" && ok "standard_version SemVer" || bad "team.yaml standard_version must be SemVer"

for t in requirement technical-design task-breakdown test-plan code-review; do
  grep -q "Decision log" "$ROOT/templates/$t.md" && ok "template $t has Decision log" || bad "template $t missing Decision log"
done

if grep -rEI 'AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{20,}|sk-[A-Za-z0-9]{10,}|BEGIN (RSA )?PRIVATE KEY' --include='*.md' --include='*.yaml' --include='*.json' --include='*.sh' "$ROOT" >/dev/null; then
  bad "possible secrets found"
else
  ok "no secrets detected (heuristic)"
fi

# adapter refs + index refs exist
grep -rhoE '"((standards|roles|workflows|gates|templates|prompts|knowledge)/[^"]+)"' "$ROOT/adapters" "$ROOT/knowledge/index.yaml" 2>/dev/null | tr -d '"' | sort -u | while read -r ref; do
  [[ -f "$ROOT/$ref" ]] && ok "ref -> $ref" || bad "dangling ref $ref"
  [[ "$ref" == */* ]] || true
done
# propagate failures from subshell via re-check
dangling=$(grep -rhoE '"((standards|roles|workflows|gates|templates|prompts|knowledge)/[^"]+)"' "$ROOT/adapters" "$ROOT/knowledge/index.yaml" 2>/dev/null | tr -d '"' | sort -u | while read -r ref; do [[ -f "$ROOT/$ref" ]] || echo "$ref"; done)
[[ -n "$dangling" ]] && fail=1

[[ $fail -eq 0 ]] && echo "VALIDATION PASSED" || { echo "VALIDATION FAILED"; exit 1; }
