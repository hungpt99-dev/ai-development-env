# AI Development Environment — Universal Agent Setup Guide

Source: https://github.com/hungpt99-dev/ai-development-env
Scope: OpenCode (primary) + Claude Code, Cursor, Copilot, any OpenAI-compatible agent.
Principle: one task prompt in, full engineering team out. No duplicate agents, skills, or MCPs — orchestration reuses what exists.

> AI assists — humans own decisions.

---

## 0. Principles

1. Smallest context that can do the job. Skills load on demand; global rules stay lean.
2. Right model per task, not one model for everything. Cheap model for titles/scouting, strong reasoning for build/review.
3. Verify every change: build → typecheck → lint → test → review. Never trust "tests pass" without output.
4. Parallelize read-only investigation; serialize all writes (one writer per file set).
5. Orchestration coordinates existing capabilities. It never reimplements them.

---

## 1. Checklist

- [ ] Node 18+, Git, Bun, `uv`/`uvx` installed
- [ ] Agent CLI installed (OpenCode, and optionally Claude Code / Cursor / Copilot CLI)
- [ ] Model gateway reachable (OmniRoute `:20128` or provider API keys)
- [ ] Default model + small model set, agent restarted
- [ ] Plugins installed (§2)
- [ ] Skills installed (§3: SDLC 48 + global 30 + ECC 220 + caveman)
- [ ] Agents installed (§4: 23 in this environment)
- [ ] MCPs live (§5)
- [ ] Runtime: herdr; ralph-tui + Beads optional
- [ ] Knowledge: Graphify index built (`graphify-out/graph.json`)
- [ ] `/team` pipeline verified (§6)

---

## 2. Plugins and Model Routing

### OpenCode (`~/.config/opencode/opencode.json` / `./opencode.json`)

```json
{
  "model": "opencode/muse-spark-1.3-contributor-free",
  "small_model": "opencode/muse-spark-1.3-contributor-free",
  "default_agent": "build",
  "plugin": ["@dietrichgebert/ponytail", "./plugins/caveman/plugin.js"],
  "agent": { "build": { "model": "opencode/muse-spark-1.3-contributor-free", "variant": "xhigh" } }
}
```

| Plugin | What it does | Install |
|---|---|---|
| `@dietrichgebert/ponytail` | Lazy build: shortest working diff, stdlib/native first, no unrequested abstractions. `/ponytail lite\|full\|ultra`, off with `stop ponytail` | `"plugin": ["@dietrichgebert/ponytail"]` |
| caveman (local `./plugins/caveman/plugin.js`) | Terse output mode, ~65-75% fewer tokens. Code/commands/errors stay byte-exact. `/caveman`, off with `stop caveman` | local plugin path in `opencode.json` |
| `@omniroute/opencode-plugin` | Model gateway: 1100+ models, effort tiers `none\|low\|medium\|high\|xhigh\|max` | `["./plugins/omniroute/dist/index.js", {"providerId":"omniroute","baseURL":"http://localhost:20128"}]` |

Routing rule: `build` agent = strong model + `variant: xhigh` for hard reasoning; use `low/minimal/none` for trivial edits. Small model handles titles/scouting only. Restart the agent after config change.

### Other tools (same idea, different file)

| Tool | Where models/plugins live | Notes |
|---|---|---|
| Claude Code | `~/.claude/settings.json`, `~/.claude/skills/`, `~/.claude/agents/` | Strip nothing; Claude frontmatter (`tools:`, `model:`, `color:`) is native here |
| Cursor | `.cursor/rules/`, `.cursor/skills/`, `cursor mcp.json` | Keep rules short; skills on demand, not always-on |
| Copilot / generic | repo `AGENTS.md` + `.agents/skills/` | `AGENTS.md` = global rules only (see §7); skills referenced by name |
| OpenCode | `~/.config/opencode/agents/`, `commands/`, `skills/`, `opencode.json` | **Strip Claude-only frontmatter** (`tools:`, `model: sonnet`, `color:`, `allowed-tools:`) or OpenCode refuses to start |

---

## 3. Skills (procedures, loaded on demand)

### 3a. SDLC bundle — 48 skills

Install (Claude path shown; copy to the equivalent dir for your tool):

```bash
npx claude-code-templates@latest --skill development/java-pro,development/backend-dev-guidelines,development/senior-backend,development/backend-architect,development/cc-skill-backend-patterns,development/senior-frontend,development/frontend-dev-guidelines,development/cc-skill-frontend-patterns,creative-design/frontend-design,development/senior-architect
npx claude-code-templates@latest --skill development/architecture-patterns,creative-design/c4-architecture,development/api-design-principles,development/api-patterns,development/code-reviewer,development/code-review-checklist,development/cc-skill-security-review,security/security-best-practices,development/e2e-testing-patterns,development/javascript-testing-patterns
npx claude-code-templates@latest --skill development/k6-load-testing,development/playwright-java,development/docker-expert,development/cloud-devops,development/devops-iac-engineer,development/kubernetes-architect,development/helm-chart-scaffolding,workflow-automation/gitops-workflow,development/github-actions-creator,development/github-workflow-automation
npx claude-code-templates@latest --skill database/database-architect,database/database-migration,database/database-optimizer,database/postgres-schema-design,database/postgresql-optimization,database/sql-pro,development/git-commit-helper,development/git-pushing,development/gh-fix-ci,development/changelog-generator,git/commit-smart,development/using-git-worktrees
npx claude-code-templates@latest --skill development/flutter-expert,creative-design/mobile-design,development/android-cicd,development/swift-concurrency-expert
```

Rate-limit note: GitHub API allows ~60/hr unauthenticated. If hit, `git clone https://github.com/davila7/claude-code-templates.git` and copy `cli-tool/components/skills/<cat>/<name>` → skills dir manually.

### 3b. Global agent skills — 30 (`~/.agents/skills`, auto-loaded)

Key ones the pipeline actually calls: `test-driven-development`, `systematic-debugging`, `verification-before-completion`, `requesting-code-review`, `receiving-code-review`, `dispatching-parallel-agents`, `subagent-driven-development`, `executing-plans`, `writing-plans`, `playwright-best-practices`, `webapp-testing`, `using-git-worktrees`, `orchestration`.

Install pattern: `npx skills add <owner/repo>` (Agent Skills registry).

### 3c. ECC skills — 220 (`~/.config/opencode/skills`, one command)

```bash
npx ecc-universal@2.2.3 setup   # Global + Standard hooks; full profile
```

Pipeline-relevant subset (do not install separately — they come with the bundle): `tdd-workflow`, `debugging`, `code-review`, `verification-loop`, `ai-regression-testing`, `e2e-testing`, `browser-qa`, `error-handling`, `production-audit`, `planning`, `orch-add-feature`, `orch-fix-defect`, `orch-change-feature`, `orch-review`, `plan-orchestrate`, `team-agent-orchestration`, `council`, `santa-method`, `delivery-gate`, `codehealth-mcp`, `graphify`.

One install method only (plugin XOR manual). State file: `~/.config/opencode/ecc-install-state.json`. Docs: https://ecc.tools

### 3d. Caveman — terse talk mode

```bash
npx skills add JuliusBrussee/caveman
```

Pairs with Ponytail (what to build vs how to talk). Drop it for security warnings and destructive confirmations.

### Skill paths per tool

| Tool | Skills dir |
|---|---|
| OpenCode | `~/.config/opencode/skills/<name>/SKILL.md` |
| Claude Code | `~/.claude/skills/<name>/SKILL.md` |
| Cursor / generic | `.agents/skills/<name>/SKILL.md` or `.cursor/skills/` |

---

## 4. Agents (workers, reused — never duplicated)

Location in this environment: `~/.config/opencode/agents/` (23 files). Install via:

```bash
npx claude-code-templates@latest --agent development-team/backend-developer,development-team/backend-architect,development-team/frontend-developer,development-team/fullstack-developer,development-team/mobile-developer,development-team/mobile-app-developer
npx claude-code-templates@latest --agent programming-languages/flutter-expert,programming-languages/spring-boot-engineer,programming-languages/java-architect,development-tools/code-reviewer,development-tools/qa-expert,development-tools/test-automator
npx claude-code-templates@latest --agent development-team/devops-engineer,devops-infrastructure/kubernetes-specialist,security/platform-sre-kubernetes,database/database-architect,database/database-administrator,business-marketing/project-manager,api-graphql/api-designer,devops-infrastructure/security-engineer
```

Then strip Claude-only frontmatter from OpenCode copies. Verify with `opencode agent list`.

| Agent | Use for |
|---|---|
| `cavecrew-investigator` | Read-only explore: file:line maps, callers, entry points |
| `cavecrew-builder` | Surgical 1–2 file edits (typos, single-function rewrites) |
| `cavecrew-reviewer` | Diff review, one line per finding |
| `backend-architect` | Service boundaries, REST/gRPC/GraphQL selection, observability |
| `api-designer` | OpenAPI 3.2 contracts, versioning, protocol picks |
| `database-architect` | Schema design, polyglot selection, decomposition plans |
| `backend-developer` | Backend implementation (Node 22+/Python 3.12+/Go 1.24+) |
| `frontend-developer` | React/Vue/Angular apps, migrations, Vitest |
| `fullstack-developer` | DB→API→UI feature as one unit |
| `mobile-developer` / `mobile-app-developer` / `flutter-expert` | Cross-platform / native / Flutter implementation |
| `java-architect` + `spring-boot-engineer` | Java design + Spring Boot 3 implementation |
| `code-reviewer` | Quality gate: correctness, security, perf, maintainability |
| `security-engineer` | Auth/payment/secrets/PII/SQL paths |
| `qa-expert` | Test strategy, coverage targets, go/no-go |
| `test-automator` | Test frameworks, flakiness, CI wiring |
| `database-administrator` | Query perf, HA/failover, large migrations |
| `devops-engineer` / `kubernetes-specialist` / `platform-sre-kubernetes` | Pipelines, clusters, safe rollouts |
| `project-manager` | Plans, risks, schedule/budget, closure |

For Claude Code: same agent markdown files go in `~/.claude/agents/` with frontmatter kept. For Cursor: convert each to a Custom Mode / slash command referencing the same prompt body.

---

## 5. MCPs (capabilities, least privilege per agent)

This environment (`opencode.json` → `mcp`): `workspace-mcp` (Drive/Docs read-only), `internal-docs` (fetch), `trello`, `notion` (+ `notion-2`), `playwright`, `context7`, `filesystem` (scoped to workdir), `shell`, `pywinauto` (Windows desktop).

Reference layout from upstream (adapt to your secrets):

| MCP | Config |
|---|---|
| linear | remote `https://mcp.linear.app/mcp` |
| notion | remote `https://mcp.notion.com/mcp` |
| github | remote `https://api.githubcopilot.com/mcp/` + `Authorization: Bearer {env:GITHUB_PERSONAL_ACCESS_TOKEN}` |
| context7 | local `npx -y @upstash/context7-mcp@latest` (fresh library docs) |
| filesystem | local `npx -y @modelcontextprotocol/server-filesystem <workdir>` |
| git | local `uvx mcp-server-git --repository <repo> …` |
| shell | local `npx -y @mako10k/mcp-shell-server@latest` |
| playwright | local `npx -y @playwright/mcp@latest` (E2E, visual checks) |
| agent-browser | local `npx -y agent-browser@latest mcp` |
| graphify | local `graphify-mcp --graph <root>/graphify-out/graph.json` |
| open-ontologies | local `~/.local/bin/open-ontologies serve` |

Rules: `command` is always an array; secrets via `{env:VAR}`; `enabled: false` disables inherited servers. Least privilege: developer gets filesystem/terminal/git; reviewer gets read/diff; tester gets terminal/test tools/Playwright only when UI is involved. Never hand every MCP to every agent.

---

## 6. The `/team` Pipeline (single entry point — already installed)

File: `~/.config/opencode/commands/team.md`. Usage:

```text
/team <your task in plain words>
```

Examples:

```text
/team Implement idempotency for the payment creation API.
/team Add pagination to the customer API.
/team Login returns 500 when email has a plus sign.
```

### How it flows

```text
USER TASK (/team <task>)
  → Classify: Feature | Bug | Refactor | Perf (one line)
  → Select smallest team from §4 (drop agents with no work)
  → Phase A: parallel read-only investigate (investigator + design scout)
  → Phase B: one architect owns minimal plan (files, interfaces, acceptance, test plan)
  → Phase C: one developer owns all edits (TDD where logic exists, small diff)
  → Phase D: independent review (code-reviewer + cavecrew-reviewer; +security-engineer on sensitive paths)
  → Phase E: tests with real output (qa-expert defines, test-automator runs)
  → Phase F: failure loop, max 3 rounds (findings + failing output → same implementer → re-review → re-test)
  → Phase G: final verification (diff stat, status, typecheck/lint/build/test, secret grep, coverage)
  → Done report
```

Per-type teams:

| Type | Pipeline |
|---|---|
| Feature | Investigate → Architect → Developer → Reviewer → Tester → Verify |
| Bug | Investigate → Root cause (`debugging` skill) → Developer → Reviewer → Regression test (`ai-regression-testing`) → Verify |
| Refactor | Investigate → Design → Developer → Reviewer → Tests → Verify |
| Perf | Investigate → Analysis → Developer → Benchmark → Reviewer → Verify |

### Orchestration rules (enforced by the command)

1. One writer per file set per phase. Investigators/reviewers are read-only.
2. Independent reads run in parallel via the Task tool; writes never run concurrently on the same files.
3. Evidence over claims: every "passes / fixed / approved" must quote command output, diff, or log.
4. Review `BLOCK` or test `FAIL` returns to the same implementer with findings + failing output; loop until `APPROVE` + green or 3 rounds, then report the blocker.
5. No commit unless the user asks.

### Related commands (already present, use directly when needed)

`/orch-add-feature`, `/orch-fix-defect`, `/orch-change-feature`, `/orch-refine-code`, `/orch-review`, `/verify`, `/code-review`, `/tdd`, `/test-coverage`, `/security-scan`, `/multi-workflow`, `/orchestrate`.

### Porting `/team` to other tools

- Claude Code: copy `team.md` body to `.claude/commands/team.md` (keep `$ARGUMENTS`), subagents via `Task(subagent_type=...)` with the same agent names from `~/.claude/agents/`.
- Cursor: same body as a Custom Command; map each phase to Composer sub-tasks with the same agent prompts.
- Generic: the phase list + team table + failure loop is tool-agnostic — any runner that can dispatch subagents and pass evidence forward works.

---

## 7. Knowledge + Runtime

| Tool | What it does | Install |
|---|---|---|
| Graphify | Codebase knowledge graph; ask "what calls X" before grep | index → `graphify-out/graph.json`, queried via MCP/CLI |
| herdr | Agent-aware multiplexer: working/blocked/idle panes, survives drops | `curl -fsSL https://herdr.dev/install.sh \| sh` |
| ralph-tui | Autonomous backlog loop: select→prompt→execute→`<promise>COMPLETE</promise>` | `bun install -g ralph-tui` |
| Beads | Git-backed dependency-aware tasks; feeds ralph/herdr | pairs with both; alternative to Linear/Jira for loops |

Global rules live in `AGENTS.md` (context efficiency, smallest diff, verification, no secrets, concise output). Project overrides go in `<repo>/AGENTS.md`.

---

## 8. Definition of Done

Build → typecheck → lint → tests green (new regression test for every bugfix) → fresh-context self-review → smallest diff. Perf work adds before/after benchmark. Pre-ship sensitive paths add `security-scan` + `production-audit`.

Final verification table (from `verification-loop`):

| Check | Command example | Gate |
|---|---|---|
| Typecheck | `npx tsc --noEmit` | zero errors |
| Lint | `npm run lint` | zero warnings |
| Tests | `npm test` / `npm run test:integration` | all green, coverage ≥ 80% |
| Build | `npm run build` | succeeds |
| Secrets | grep `api_key\|secret\|password\|token` | no hits |
| Diff | `git diff --stat`, `git status --short` | minimal, no stray files |

---

## 9. Troubleshooting

| Symptom | Fix |
|---|---|
| `ConfigInvalidError` on start | Validate against `https://opencode.ai/config.json`; strip Claude frontmatter from OpenCode agents |
| `Expected object, got "Read, Write..." tools` | Delete the `tools:` line in that agent file |
| GitHub API 403 on template install | Wait, or clone + copy manually (§3a note) |
| MCP silent fail | `command` must be an array; check binary path and env key |
| Weak answers | Variant too low or context bloated — trim rules, reroute agent |
| Agent loops forever | Tighten scope, enforce Phase F max 3 rounds + gates |
| `/team` with empty task | It asks for the task and stops — re-invoke with `/team <task>` |

---

## 10. What changed in this setup (no duplicates)

- Added: this guide (`AI_DEVELOPMENT_ENV_GUIDE.md`). Nothing else.
- Reused: 21/21 agent references in `/team` resolve to existing files in `~/.config/opencode/agents/` (2 spares untouched: `cavecrew-builder`, `project-manager`); 10/10 skill references resolve to existing dirs in `~/.config/opencode/skills/`; all MCPs unchanged in `opencode.json`.
- Preserved: existing agents, skills, MCPs, plugins, `AGENTS.md` rules. No new agent/skill/MCP created, no config overwritten.
- Entry point: `/team <task>` (file `~/.config/opencode/commands/team.md`).
