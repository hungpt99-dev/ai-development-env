# ai-development-env

Guide to set up an AI coding agent for best performance and productivity,
with the full install manifest. One file. Follow top to bottom.
AI assists — humans own decisions.

## 0. Principles

- Smallest context that can do the job. Skills load on demand; rules stay off.
- Right model per task, not one model for everything.
- Verify every change: build → typecheck → lint → test → review.
- Parallelize agents; never poll terminals by hand.

## 1. Checklist

- [ ] Node 18+, Git, Bun, `uv`/`uvx`
- [ ] OpenCode installed
- [ ] Model gateway reachable (OmniRoute `:20128` or provider keys)
- [ ] Default model + `small_model` set, opencode restarted
- [ ] Plugins installed (§2)
- [ ] Skills installed (§3: 48 + 29 + 220 + caveman)
- [ ] Agents installed (§4: 20)
- [ ] MCPs live (§5: 11)
- [ ] Runtime: herdr; ralph-tui + Beads optional
- [ ] Knowledge: Graphify index built; open-ontologies binary present

## 2. Plugins (opencode.json)

```json
"plugin": [
  "@dietrichgebert/ponytail",
  ["./plugins/omniroute/dist/index.js",
    { "providerId": "omniroute", "baseURL": "http://localhost:20128",
      "features": { "combos": false, "autoCombos": false } }]
]
```

| Plugin | What | Notes |
|---|---|---|
| `@dietrichgebert/ponytail` | Lazy build mode: shortest working diff, stdlib first | `/ponytail lite\|full\|ultra`, off: `stop ponytail` |
| `@omniroute/opencode-plugin` | Model gateway, 1100+ models, effort tiers `none\|low\|medium\|high\|xhigh\|max` | Local plugin file; needs gateway on `:20128` |

Model routing (same file):

```json
{ "model": "opencode/muse-spark-1.3-contributor-free",
  "small_model": "opencode-omniroute/auto/best-fast",
  "agent": { "build": { "model": "opencode/muse-spark-1.3-contributor-free",
                        "variant": "xhigh" } } }
```

`xhigh` for hard reasoning, `low/minimal/none` for trivial edits,
`small_model` for titles only. Restart opencode after config change.

## 3. Skills

### 3a. SDLC bundle — 48 skills (aitmpl.com → `~/.claude/skills`, auto-loaded)

```bash
npx claude-code-templates@latest --skill development/java-pro,development/backend-dev-guidelines,development/senior-backend,development/backend-architect,development/cc-skill-backend-patterns,development/senior-frontend,development/frontend-dev-guidelines,development/cc-skill-frontend-patterns,creative-design/frontend-design,development/senior-architect
npx claude-code-templates@latest --skill development/architecture-patterns,creative-design/c4-architecture,development/api-design-principles,development/api-patterns,development/code-reviewer,development/code-review-checklist,development/cc-skill-security-review,security/security-best-practices,development/e2e-testing-patterns,development/javascript-testing-patterns
npx claude-code-templates@latest --skill development/k6-load-testing,development/playwright-java,development/docker-expert,development/cloud-devops,development/devops-iac-engineer,development/kubernetes-architect,development/helm-chart-scaffolding,workflow-automation/gitops-workflow,development/github-actions-creator,development/github-workflow-automation
npx claude-code-templates@latest --skill database/database-architect,database/database-migration,database/database-optimizer,database/postgres-schema-design,database/postgresql-optimization,database/sql-pro,development/git-commit-helper,development/git-pushing,development/gh-fix-ci,development/changelog-generator,git/commit-smart,development/using-git-worktrees
npx claude-code-templates@latest --skill development/flutter-expert,creative-design/mobile-design,development/android-cicd,development/swift-concurrency-expert
```

Full list: android-cicd, api-design-principles, api-patterns,
architecture-patterns, backend-architect, backend-dev-guidelines,
c4-architecture, cc-skill-backend-patterns, cc-skill-frontend-patterns,
cc-skill-security-review, changelog-generator, cloud-devops,
code-review-checklist, code-reviewer, commit-smart, database-architect,
database-migration, database-optimizer, devops-iac-engineer, docker-expert,
e2e-testing-patterns, flutter-expert, frontend-design, frontend-dev-guidelines,
gh-fix-ci, git-commit-helper, git-pushing, github-actions-creator,
github-workflow-automation, gitops-workflow, helm-chart-scaffolding, java-pro,
javascript-testing-patterns, k6-load-testing, kubernetes-architect,
mobile-design, playwright-java, postgres-schema-design,
postgresql-optimization, security-best-practices, senior-architect,
senior-backend, senior-frontend, sql-pro, swift-concurrency-expert,
using-git-worktrees, plus `open-ontologies` + `ontology-engineering` (§6).

Notes: GitHub API rate-limits (~60/hr unauth) — if hit,
`git clone https://github.com/davila7/claude-code-templates.git` and copy
`cli-tool/components/skills/<cat>/<name>` → `~/.claude/skills/<name>`.

### 3b. Global agent skills — 29 (`~/.agents/skills`, auto-loaded)

brainstorming, differential-review, dispatching-parallel-agents,
executing-plans, find-skills, finishing-a-development-branch, frontend-design,
insecure-defaults, orca-cli, orchestration, playwright-best-practices,
receiving-code-review, requesting-code-review, shadcn, skill-creator,
subagent-driven-development, systematic-debugging, test-driven-development,
turborepo, typescript-advanced-types, using-git-worktrees, using-superpowers,
vercel-composition-patterns, vercel-react-best-practices,
verification-before-completion, web-design-guidelines, web-quality-audit,
webapp-testing, writing-plans, writing-skills.
Install pattern: `npx skills add <owner/repo>` (Agent Skills registry).

### 3c. ECC skills — 220 (`~/.config/opencode/skills`, one command)

```bash
npx ecc-universal@2.2.3 setup   # Global + Standard hooks; full profile
```

Covers TDD, security, research, docs, frontend, data, ML, ops and more.
One install method only (plugin XOR manual). State:
`~/.config/opencode/ecc-install-state.json`. Docs: https://ecc.tools

### 3d. Caveman — terse talk mode

```bash
npx skills add JuliusBrussee/caveman
```

Pairs with Ponytail (what to build vs how to talk). `/caveman lite|full|ultra`,
off: `stop caveman`. Drop for security warnings and destructive confirms.

## 4. Agents — 20 (`~/.config/opencode/agents`)

```bash
npx claude-code-templates@latest --agent development-team/backend-developer,development-team/backend-architect,development-team/frontend-developer,development-team/fullstack-developer,development-team/mobile-developer,development-team/mobile-app-developer
npx claude-code-templates@latest --agent programming-languages/flutter-expert,programming-languages/spring-boot-engineer,programming-languages/java-architect,development-tools/code-reviewer,development-tools/qa-expert,development-tools/test-automator
npx claude-code-templates@latest --agent development-team/devops-engineer,devops-infrastructure/kubernetes-specialist,security/platform-sre-kubernetes,database/database-architect,database/database-administrator,business-marketing/project-manager,api-graphql/api-designer,devops-infrastructure/security-engineer
```

Then **strip Claude-only frontmatter** from the OpenCode copies
(`tools:`, `model: sonnet`, `color:`, `allowed-tools:`) or OpenCode refuses
to start. Verify: `opencode agent list`.

## 5. MCP servers — 11 (opencode.json)

```json
"linear":    { "type": "remote", "url": "https://mcp.linear.app/mcp" },
"notion":    { "type": "remote", "url": "https://mcp.notion.com/mcp", "enabled": true },
"github":    { "type": "remote", "url": "https://api.githubcopilot.com/mcp/",
               "enabled": true,
               "headers": { "Authorization": "Bearer {env:GITHUB_PERSONAL_ACCESS_TOKEN}" } },
"context7":  { "type": "local", "command": ["npx","-y","@upstash/context7-mcp@latest"], "enabled": true },
"filesystem":{ "type": "local", "command": ["npx","-y","@modelcontextprotocol/server-filesystem","<workdir>"], "enabled": true },
"git":       { "type": "local", "command": ["uvx","mcp-server-git","--repository","<repo>", "..."], "enabled": true },
"shell":     { "type": "local", "command": ["npx","-y","@mako10k/mcp-shell-server@latest"], "enabled": true,
               "environment": { "MCP_SHELL_DEFAULT_WORKDIR": "<workdir>",
                                "MCP_SHELL_ALLOWED_WORKDIRS": "<workdir>" } },
"playwright":{ "type": "local", "command": ["npx","-y","@playwright/mcp@latest"], "enabled": true },
"agent-browser": { "type": "local", "command": ["npx","-y","agent-browser@latest","mcp"], "enabled": true },
"graphify":  { "type": "local", "command": ["<home>/.local/bin/graphify-mcp","--graph","<root>/graphify-out/graph.json"], "enabled": true },
"open-ontologies": { "type": "local", "command": ["<home>/.local/bin/open-ontologies","serve"], "enabled": true }
```

Rules: `command` is always an array; secrets via `{env:VAR}`;
`enabled: false` disables inherited servers. Staged but unwired (need docker):
`markitdown`, `github-official` in `~/.claude/mcps`.

## 6. Knowledge tools

- **Graphify**: index repo → `graphify-out/graph.json`; query graph *before* grep.
- **Open Ontologies** (fabio-rovai/open-ontologies, MIT): blast-radius +
  Lean-checkable proof for ontology changes.
  ```bash
  curl -LO https://github.com/fabio-rovai/open-ontologies/releases/latest/download/open-ontologies-aarch64-apple-darwin
  chmod +x open-ontologies-aarch64-apple-darwin && mv $_ ~/.local/bin/open-ontologies
  ```
  Skills: copy repo `SKILL.md` → `~/.claude/skills/open-ontologies/SKILL.md`,
  repo `skills/ontology-engineering` → `~/.claude/skills/ontology-engineering`.

## 7. Runtime

- **herdr** (daily): agent-aware multiplexer, working/blocked/idle panes,
  survives lid-close/SSH-drop, multi-machine.
  `curl -fsSL https://herdr.dev/install.sh | sh` → `herdr`.
  Fallback: tmux/Zellij (persistence, no agent awareness).
- **ralph-tui** (autonomous backlog): `bun install -g ralph-tui` →
  `setup → create-prd --chat → run --prd ./prd.json`.
- **Beads**: git-backed, dependency-aware task lists; pairs with both.

## 8. Definition of done

Build → typecheck → lint → tests green (new regression test for bugfixes) →
fresh-context self-review → smallest diff. Benchmark before/after for perf work.

## 9. Troubleshooting

| Symptom | Fix |
|---|---|
| `ConfigInvalidError` on start | shape vs `https://opencode.ai/config.json`; strip Claude frontmatter |
| `Expected object, got "Read, Write..." tools` | delete `tools:` line in that agent file |
| GitHub API 403 on aitmpl install | wait, or clone + copy manually |
| MCP silent fail | `command` must be array; check binary/env key |
| Weak answers | variant too low or context bloated — trim rules, reroute agent |
| Agent loops forever | tighten scope, add gates/hooks |

Stack: aitmpl · Ponytail · Caveman · OmniRoute · ECC · Agent Skills · MCP
(linear/notion/github/context7/filesystem/git/shell/playwright/agent-browser/graphify/open-ontologies)
· Graphify · Open Ontologies · herdr · Beads · ralph-tui
