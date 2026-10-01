#!/usr/bin/env bash
# Install the team AI standard into a project (macOS/Linux). See install.ps1 for docs.
set -euo pipefail
TOOL="${1:-}"
REPO_ROOT="${2:-$(pwd)}"
STANDARD_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERSION=$(grep -E 'standard_version:' "$STANDARD_ROOT/team.yaml" | sed -E 's/.*"([^"]+)".*/\1/')
echo "AI Engineering Standard v$VERSION"
echo "Standard: $STANDARD_ROOT"
echo "Target:   $REPO_ROOT"

if [ -z "$TOOL" ]; then
  echo "Select your AI tool: [1] opencode [2] claude [3] cursor [4] copilot [5] codex"
  read -rp "Enter 1-5 (default 1): " choice
  choice="${choice:-1}"
  TOOL=$(echo opencode claude cursor copilot codex | cut -d' ' -f"$choice")
fi

HEADER="<!-- Generated from ai-engineering-standard v$VERSION — do not edit by hand -->"

write_file() { mkdir -p "$REPO_ROOT/$(dirname "$1")"; printf '%s\n' "$2" > "$REPO_ROOT/$1"; echo "  wrote $1"; }

[ -f "$REPO_ROOT/project.yaml" ] || { cp "$STANDARD_ROOT/project.example.yaml" "$REPO_ROOT/project.yaml"; echo "  wrote project.yaml (from example)"; }

case "$TOOL" in
  opencode)
    write_file "AGENTS.md" "$HEADER
# Project AI instructions (OpenCode)

Core standard: $STANDARD_ROOT (v$VERSION)
Project config: ./project.yaml (precedence: project.yaml > team.yaml > standards/)

Always load before acting:
- standards/ai-usage.md (decision labels, anti-hallucination)
- roles/<active-role>.md + prompts/<task>.md (follow its front-matter read_first)
- templates/<artifact>.md for output shape; gates/<stage>.md for self-check

Human owns decisions — end outputs with the Decision log block." ;;
  claude)
    write_file "CLAUDE.md" "$HEADER
# Project AI instructions (Claude)

Core standard: $STANDARD_ROOT (v$VERSION). Project config: ./project.yaml.
Load standards/ai-usage.md + active role + prompt front-matter before acting."
    for c in analyze plan implement review debug; do
      write_file ".claude/commands/$c.md" "$HEADER
Follow $STANDARD_ROOT/prompts/$c.md and its front-matter read_first list."
    done ;;
  cursor)
    for r in ai-usage coding testing security; do
      write_file ".cursor/rules/$r.mdc" "---
globs: [\"**/*\"]
---
$HEADER
Follow $STANDARD_ROOT/standards/$r.md (team source of truth). Project overrides: ./project.yaml."
    done ;;
  copilot)
    write_file ".github/muse-instructions.md" "$HEADER
Follow $STANDARD_ROOT/standards/ai-usage.md and roles/developer.md. Output shapes: templates/*.md. Gates: gates/*.md. Overrides: ./project.yaml."
    write_file ".github/prompts/implement.prompt.md" "$HEADER
Follow $STANDARD_ROOT/prompts/implement.md and its front-matter read_first list."
    write_file ".github/prompts/review.prompt.md" "$HEADER
Follow $STANDARD_ROOT/prompts/review.md and its front-matter read_first list." ;;
  codex)
    write_file "AGENTS.md" "$HEADER
# Project AI instructions (Codex)

Core standard: $STANDARD_ROOT (v$VERSION). Project config: ./project.yaml.
Load standards/ai-usage.md + active role + prompt front-matter before acting.
Human owns decisions — end outputs with the Decision log block." ;;
  *) echo "Unknown tool: $TOOL" >&2; exit 1 ;;
esac

echo "Done. Next: read $STANDARD_ROOT/docs/getting-started.md"
echo "Validate with: bash $STANDARD_ROOT/scripts/validate.sh --root $STANDARD_ROOT"
