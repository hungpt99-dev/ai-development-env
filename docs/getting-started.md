# Getting Started (5 minutes)

## 1. Clone
```powershell
git clone <standard-repo-url> ai-engineering-standard
cd ai-engineering-standard
```

## 2. Install into your project (one command)
```powershell
# Windows — run from your PROJECT directory, pointing at the standard:
pwsh <path-to-standard>/scripts/install.ps1 -Tool opencode
# macOS/Linux:
bash <path-to-standard>/scripts/install.sh cursor
```
What it does: writes thin pointer files (`AGENTS.md`, `.cursor/rules/*`, …) + bootstraps `project.yaml` if missing. It never copies rules.

When prompted, pick your tool: `opencode | claude | cursor | copilot | codex`.
Re-run anytime to switch tools — pointer files are regenerable.

## 3. Configure your project (2 minutes)
Edit `project.yaml` (in your project, not the standard repo):
- `language_stack`, `conventions/*`, `glossary`
- Tighten gates if needed (e.g. coverage 80%)
- Waivers (loosen only with approver + expiry)

## 4. Run your first workflow
1. `prompts/analyze.md` → fill requirement (`templates/requirement.md`) → human approves (gate 🔒)
2. `prompts/plan.md` → design + tasks → human approves (gate 🔒)
3. `prompts/implement.md` → code + tests
4. QA → Review → Release per `workflows/feature-development.md`

## Daily use
- Start every AI session with the role + prompt front-matter `read_first` list.
- End every decision-touching output with the Decision log block.
- Carry handoff artifacts forward; never re-derive.
