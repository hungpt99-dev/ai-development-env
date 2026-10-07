# ai-development-env

One-file checklist + setup notes for my AI agent stack.
AI assists. Humans own decisions.

## Checklist

- [ ] Node 18+, Git, Bun (`bun --version`)
- [ ] OpenCode installed (`opencode --version`)
- [ ] OmniRoute gateway running (`http://localhost:20128`)
- [ ] Default model set (`opencode/muse-spark-1.3-contributor-free`, build `xhigh`)
- [ ] aitmpl SDLC bundle installed (46 skills, 20 agents, 14 commands)
- [ ] Ponytail plugin enabled
- [ ] Caveman skill installed
- [ ] ECC installed (`npx ecc-universal@2.2.3 setup`)
- [ ] MCPs live: Playwright, Context7, Git
- [ ] Graphify index built (`graphify-out/graph.json`)
- [ ] herdr installed (or tmux fallback)
- [ ] ralph-tui installed (optional, autonomous loops)
- [ ] Beads tracker ready (optional, pairs with ralph-tui)

## Setup notes

### aitmpl.com — component catalog
890 skills · 422 agents · 288 commands · 72 settings · 62 hooks · 105 MCPs.
Installs to `.claude/` (OpenCode auto-loads `~/.claude/skills`).

```bash
npx claude-code-templates@latest --skill development/java-pro
npx claude-code-templates@latest --agent programming-languages/spring-boot-engineer
npx claude-code-templates@latest --command utilities/code-review
npx claude-code-templates@latest --mcp devtools/markitdown
```
Note: GitHub API rate-limits (~60/hr unauth). If hit, `git clone
https://github.com/davila7/claude-code-templates.git` and copy dirs manually.
Claude agent/command frontmatter (`tools:`, `model: sonnet`, `allowed-tools:`)
breaks OpenCode validation — strip those lines from OpenCode copies.

### Ponytail — lazy build mode
Shortest working diff wins. Stdlib/native first. No unrequested abstractions.
Opencode plugin (already in `opencode.json`):

```json
"plugin": ["@dietrichgebert/ponytail"]
```
Levels: `/ponytail lite|full|ultra`. Off: `stop ponytail`. Mark deliberate
shortcuts with `# ponytail: <ceiling>, <upgrade path>`.

### Caveman — terse talk mode
Pairs with Ponytail (Ponytail = what to build, Caveman = how to talk).
Cuts output ~65-75%, code/commands/errors stay byte-exact.

```bash
npx skills add JuliusBrussee/caveman
```
Levels `/caveman lite|full|ultra`. Off: `stop caveman`. Drop for security
warnings and irreversible confirmations, resume after.

### OmniRoute — model gateway
One gateway, 1100+ models, effort tiers (`none|low|medium|high|xhigh|max`).

```bash
# gateway at http://localhost:20128, plugin in opencode.json:
["./plugins/omniroute/dist/index.js",
  { "providerId": "omniroute", "baseURL": "http://localhost:20128",
    "features": { "combos": false, "autoCombos": false } }]
```
Model format: `provider/model`, e.g. `opencode/muse-spark-1.3-contributor-free`.
Default in `opencode.json`: top-level `model` + `agent.build.{model,variant}`.
Restart opencode after config change (no hot-reload).

### ECC — agent harness (affaan-m/ECC)
68 agents · 293 skills · 94 commands. Skills, instincts, memory, AgentShield.

```bash
npx ecc-universal@2.2.3 setup          # guided, pick Global + Standard hooks
```
Do not stack install methods (plugin XOR manual). State:
`~/.config/opencode/ecc-install-state.json`. Docs: https://ecc.tools

### Agent Skills — the standard
Every skill = folder + `SKILL.md` with `name`/`description` frontmatter.
OpenCode auto-loads `~/.claude/skills`, `~/.agents/skills`; extra paths via
`skills.paths` in `opencode.json`. Keep `description` concrete (what + when).

### MCP — Playwright, Context7, Git
In `opencode.json` (`mcp.<name>` needs `type`; `command` is an array):

```json
"playwright": { "type": "local",
  "command": ["npx", "-y", "@playwright/mcp@latest"], "enabled": true },
"context7": { "type": "local",
  "command": ["npx", "-y", "@upstash/context7-mcp@latest"], "enabled": true },
"git": { "type": "local",
  "command": ["uvx", "mcp-server-git", "--repository", "<repo>"], "enabled": true }
```
`{env:VAR}` interpolates env in headers. `enabled: false` disables inherited.

### Graphify — codebase knowledge graph
Query graph before grep. Build index → `graphify-out/graph.json`, MCP reads it:

```json
"graphify": { "type": "local",
  "command": ["graphify-mcp", "--graph", "<root>/graphify-out/graph.json"],
  "enabled": true }
```

### herdr — agent runtime
Tmux that understands agents. Panes marked working/blocked/idle, survives
lid-close/SSH-drop, multi-machine over SSH, agents drive it via CLI/socket.

```bash
curl -fsSL https://herdr.dev/install.sh | sh
herdr            # run agents inside, ctrl+b q detaches, herdr reattaches
```
Supports Claude Code, Codex, Cursor, opencode, Grok, 20+ CLIs. Apache-2.0.
Alternative: plain **tmux**/**Zellij** (persistent sessions, zero agent
awareness) — use when herdr is overkill for one quick agent.

### Beads — git-backed task tracker (pairs with herdr/ralph)
Dependency-aware issues that live in git, no server. Ralph-tui reads it
directly (`beads` / `beads-bv` trackers). Use instead of `prd.json` when tasks
have dependencies. Alternative to hosted trackers (Linear/Jira) for agent loops.

### ralph-tui — autonomous agent loop (optional)
Feeds task list to OpenCode/Claude Code until empty. Select → prompt →
execute → detect `<promise>COMPLETE</promise>`.

```bash
bun install -g ralph-tui
ralph-tui setup && ralph-tui create-prd --chat && ralph-tui run --prd ./prd.json
```
Trackers: `prd.json` (simple) or Beads (dependencies). Needs Bun runtime.
