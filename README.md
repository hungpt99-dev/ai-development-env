# ai-development-env

Guide to set up an AI coding agent for best performance and productivity.
One file. Follow top to bottom. AI assists — humans own decisions.

## 0. Principles

- Smallest context that can do the job. Skills load on demand; rules stay off unless needed.
- Right model per task, not one model for everything.
- Verify every change: build → typecheck → lint → test → review.
- Parallelize agents; never poll terminals by hand.

## 1. Base install checklist

- [ ] Node 18+, Git, Bun, Rust toolchain (optional, for Rust binaries)
- [ ] OpenCode (`opencode --version`)
- [ ] Model gateway reachable (OmniRoute `http://localhost:20128` or provider keys)
- [ ] Default model + `small_model` set in `opencode.json`
- [ ] Skills installed (aitmpl SDLC bundle + ECC)
- [ ] MCPs live (Playwright, Context7, Git + extras)
- [ ] Runtime: herdr (daily) + ralph-tui (autonomous runs)
- [ ] Knowledge: Graphify index built; open-ontologies binary present

## 2. Model routing (biggest perf lever)

```json
{
  "model": "opencode/muse-spark-1.3-contributor-free",
  "small_model": "opencode-omniroute/auto/best-fast",
  "agent": { "build": { "model": "opencode/muse-spark-1.3-contributor-free",
                        "variant": "xhigh" } }
}
```

- `xhigh`/`high` variants: hard reasoning (architecture, debugging). Slow, best quality.
- `low`/`minimal`/`none`: edits, renames, boilerplate. Fast, cheap.
- `small_model`: titles/summaries only — never spend flagship tokens there.
- Override per run, not in config: `opencode -m provider/model`.
- Restart opencode after any config change (no hot-reload).

## 3. Context budget

- Prefer **skills** over always-loaded rules. Rules cost tokens every turn.
- Keep `references` (docs/SDK repos) described but `hidden` until needed.
- Compaction safety net: `compaction: { auto: true, tail_turns: 15 }`.
- Cap runaway output: `tool_output: { max_lines: 200, max_bytes: 8192 }`.
- Per-command check: if explanation > code, delete explanation.

## 4. Agents and skills

Install once (aitmpl.com: 890 skills · 422 agents · 288 commands):

```bash
npx claude-code-templates@latest --skill development/java-pro
npx claude-code-templates@latest --agent programming-languages/spring-boot-engineer
npx claude-code-templates@latest --command utilities/code-review
```

- Skills live in `~/.claude/skills` — OpenCode auto-loads them.
- Agents/commands copied to `~/.config/opencode/agents|commands` must have
  Claude-only frontmatter stripped (`tools:`, `model: sonnet`, `color:`,
  `allowed-tools:`) or OpenCode refuses to start.
- My standing set: 46 skills, 20 agents, 114 commands covering
  Java/Go/Swift/Flutter/Python/JS SDLC end to end.
- ECC harness (`npx ecc-universal@2.2.3 setup`): 68 agents, 293 skills,
  hooks/memory/learning. One install method only (plugin XOR manual).

## 5. Modes: Ponytail + Caveman

- **Ponytail** (what to build): laziest solution that works. Stdlib → native →
  installed dep → one-liner → new code. Plugin `@dietrichgebert/ponytail`,
  `/ponytail lite|full|ultra`.
- **Caveman** (how to talk): terse output, exact code (`npx skills add
  JuliusBrussee/caveman`, `/caveman lite|full|ultra`). Together they cut
  65-75% of tokens. Drop both for security warnings and destructive confirms.

## 6. MCP servers

Minimal productive set (`opencode.json`, `command` is always an array):

```json
"playwright":  { "type": "local", "command": ["npx","-y","@playwright/mcp@latest"], "enabled": true },
"context7":    { "type": "local", "command": ["npx","-y","@upstash/context7-mcp@latest"], "enabled": true },
"git":         { "type": "local", "command": ["uvx","mcp-server-git","--repository","<repo>"], "enabled": true },
"open-ontologies": { "type": "local", "command": ["<home>/.local/bin/open-ontologies","serve"], "enabled": true }
```

- One MCP per job; disable inherited ones with `enabled: false`.
- Slow/remote MCPs: raise timeouts (`mcp-timeouts` setting).
- Secrets via `{env:VAR}` in headers, never pasted in config.

## 7. Knowledge: Graphify + Open Ontologies

- **Graphify**: index repo → `graphify-out/graph.json`, query graph *before*
  grep. Answers "what calls X" in one call.
- **Open Ontologies** (`~/.local/bin/open-ontologies`): plan ontology changes
  with blast-radius + Lean-checkable proof before applying. `validate`,
  `reason --profile rdfs|owl-rl`, `plan`. MCP `serve` exposes `onto_*` tools.

## 8. Runtime: parallel + autonomous

- **herdr** (daily driver): agent-aware terminal multiplexer. Panes marked
  working/blocked/idle, survives lid-close/SSH-drop, multi-machine.
  `curl -fsSL https://herdr.dev/install.sh | sh`, then `herdr`.
  Fallback: plain tmux/Zellij (persistence, no agent awareness).
- **ralph-tui** (autonomous backlog): `bun install -g ralph-tui`,
  `ralph-tui setup → create-prd --chat → run --prd ./prd.json`.
  Simple `prd.json` or **Beads** (git-backed, dependency-aware) for task lists.
- Rule: 2+ independent tasks → parallel agents in herdr. Overnight backlog →
  ralph-tui. Never babysit one terminal.

## 9. Definition of done (every task)

1. `build` passes, 2. typecheck/lint clean, 3. tests green (new regression test
   for bugfixes), 4. self-review from fresh context, 5. smallest diff that
   holds. Benchmark latency/cost before/after when perf matters.

## 10. Troubleshooting

| Symptom | Fix |
|---|---|
| OpenCode won't start, `ConfigInvalidError` | bad field shape — check against `https://opencode.ai/config.json`; strip Claude frontmatter from agents/commands |
| `Expected object, got "Read, Write..." tools` | delete `tools:` line in that agent file |
| GitHub API 403 installing aitmpl | rate limit — wait or `git clone davila7/claude-code-templates` and copy dirs |
| MCP silent fail | wrong `command` shape (must be array) or missing binary/env key |
| Slow/weak answers | variant too low, or context bloated — trim rules, route task to right agent |
| Agent loops forever | tighten prompt scope, add rails (ralph-tui quality gates / hooks) |

## Stack reference

aitmpl · Ponytail · Caveman · OmniRoute · ECC · Agent Skills · MCP
(Playwright/Context7/Git) · Graphify · Open Ontologies · herdr · Beads · ralph-tui
