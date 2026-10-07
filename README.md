# ai-development-env

Guide to set up an AI coding agent for best performance and productivity,
with the full install manifest in detail. One file. Follow top to bottom.
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
- [ ] Skills installed (§3: 48 + 30 + 220 + caveman)
- [ ] Agents installed (§4: 20)
- [ ] MCPs live (§5: 11)
- [ ] Runtime: herdr; ralph-tui + Beads optional
- [ ] Knowledge: Graphify index built; open-ontologies binary present

## 2. Plugins (detail)

| Plugin | Detail | Install |
|---|---|---|
| `@dietrichgebert/ponytail` | Lazy build mode: shortest working diff wins, stdlib/native first, no unrequested abstractions. Levels `/ponytail lite\|full\|ultra`, off: `stop ponytail`. | `"plugin": ["@dietrichgebert/ponytail"]` in `opencode.json` |
| `@omniroute/opencode-plugin` | Model gateway: 1100+ models, effort tiers `none\|low\|medium\|high\|xhigh\|max`, combos. Needs gateway on `http://localhost:20128`. | `["./plugins/omniroute/dist/index.js", {"providerId":"omniroute","baseURL":"http://localhost:20128","features":{"combos":false,"autoCombos":false}}]` |

Model routing (same file): `model` = `opencode/muse-spark-1.3-contributor-free`,
`small_model` = `opencode-omniroute/auto/best-fast` (titles only),
`agent.build` = same model + `variant: xhigh` (hard reasoning; use
`low/minimal/none` for trivial edits). Restart opencode after config change.

## 3. Skills (detail)

### 3a. SDLC bundle — 48 skills (aitmpl.com → `~/.claude/skills`, auto-loaded)

```bash
npx claude-code-templates@latest --skill development/java-pro,development/backend-dev-guidelines,development/senior-backend,development/backend-architect,development/cc-skill-backend-patterns,development/senior-frontend,development/frontend-dev-guidelines,development/cc-skill-frontend-patterns,creative-design/frontend-design,development/senior-architect
npx claude-code-templates@latest --skill development/architecture-patterns,creative-design/c4-architecture,development/api-design-principles,development/api-patterns,development/code-reviewer,development/code-review-checklist,development/cc-skill-security-review,security/security-best-practices,development/e2e-testing-patterns,development/javascript-testing-patterns
npx claude-code-templates@latest --skill development/k6-load-testing,development/playwright-java,development/docker-expert,development/cloud-devops,development/devops-iac-engineer,development/kubernetes-architect,development/helm-chart-scaffolding,workflow-automation/gitops-workflow,development/github-actions-creator,development/github-workflow-automation
npx claude-code-templates@latest --skill database/database-architect,database/database-migration,database/database-optimizer,database/postgres-schema-design,database/postgresql-optimization,database/sql-pro,development/git-commit-helper,development/git-pushing,development/gh-fix-ci,development/changelog-generator,git/commit-smart,development/using-git-worktrees
npx claude-code-templates@latest --skill development/flutter-expert,creative-design/mobile-design,development/android-cicd,development/swift-concurrency-expert
```

| Skill | Detail |
|---|---|
| java-pro | Java 21+ (virtual threads, pattern matching), Spring Boot 3.x, GraalVM, Project Loom |
| backend-dev-guidelines | Backend guide for Node/Express/TS microservices: routes, controllers, services, middleware |
| senior-backend | Scalable backends in Node/Express/Go/Python + Postgres/GraphQL/REST, API scaffolding |
| backend-architect | Scalable API design, microservices, distributed systems |
| cc-skill-backend-patterns | Backend patterns for Node/Express/Next.js API routes, DB optimization |
| senior-frontend | Modern performant web apps: React/Next.js/TS/Tailwind, component scaffolding |
| frontend-dev-guidelines | React/TS patterns: Suspense, lazy loading, file organization |
| cc-skill-frontend-patterns | React/Next.js patterns: state, performance, UI best practices |
| frontend-design | Distinctive visual design direction: aesthetics, typography, anti-template choices |
| senior-architect | Scalable systems across React/Next/Node/Express/RN/Swift/Kotlin/Flutter |
| architecture-patterns | Clean/Hexagonal architecture, DDD: maintainable, testable backends |
| c4-architecture | C4-model architecture docs as Mermaid diagrams |
| api-design-principles | Intuitive, scalable REST/GraphQL APIs that age well |
| api-patterns | REST vs GraphQL vs tRPC selection, versioning, pagination |
| code-reviewer | Code review for TS/JS/Python/Swift/Kotlin/Go + security scanning |
| code-review-checklist | Review checklist: functionality, security, performance, maintainability |
| cc-skill-security-review | Auth, input handling, secrets, API endpoints, payments: review before ship |
| security-best-practices | Language/framework-specific security review (explicit request only) |
| e2e-testing-patterns | Reliable fast E2E suites that catch regressions pre-user |
| javascript-testing-patterns | Robust JS/TS testing strategies with modern frameworks |
| k6-load-testing | k6 scenarios for API/browser/scale testing + CI integration |
| playwright-java | Enterprise Playwright in Java: POM, JUnit 5, Allure, parallel runs |
| docker-expert | Multi-stage builds, image diet, container security, Compose, prod deploys |
| cloud-devops | AWS/Azure/GCP + K8s/Terraform/CI/CD/monitoring, cloud-native dev |
| devops-iac-engineer | IaC with Terraform/K8s, scalable arch, pipelines, observability |
| kubernetes-architect | Cloud-native infra, GitOps (ArgoCD/Flux), enterprise orchestration |
| helm-chart-scaffolding | Create/organize/manage Helm charts for K8s apps |
| gitops-workflow | GitOps with ArgoCD/Flux for automated K8s deploys |
| github-actions-creator | Generate GitHub Actions: CI/CD, testing, lint, security, releases |
| github-workflow-automation | AI-assisted PR reviews, issue triage, CI/CD, GitOps |
| database-architect | Data layer from scratch: tech selection, modeling, scalable arch |
| database-migration | Schema/data migrations (Sequelize/TypeORM/Prisma), rollback, zero-downtime |
| database-optimizer | Performance tuning, query optimization, scalable arch |
| postgres-schema-design | Postgres table design: types, indexes, constraints, advanced features |
| postgresql-optimization | Query tuning, indexing strategy, production PG management |
| sql-pro | Modern SQL on cloud DBs, OLTP/OLAP tuning, modeling |
| git-commit-helper | Commit messages from git diffs |
| git-pushing | Stage/commit/push with conventional commits |
| gh-fix-ci | Pull failing Actions logs via `gh`, plan fix, implement on approval |
| changelog-generator | User-facing changelogs from commit history |
| commit-smart | Semantic conventional commits capturing WHY, type/scope auto-detected |
| using-git-worktrees | Isolated git worktrees for feature work / plan execution |
| flutter-expert | Flutter + Dart 3, advanced widgets, multi-platform deploy |
| mobile-design | Mobile-first iOS/Android thinking: touch, perf, platform conventions |
| android-cicd | Automated Play Store pipeline (TWA/RN/Flutter/native), keystore + versionCode bump |
| swift-concurrency-expert | Fix actor isolation and Sendable violations |
| open-ontologies | Ontology engineering via 110 MCP tools on Oxigraph: build/validate/query/govern RDF/OWL |
| ontology-engineering | Create/modify/query/manage ontologies and knowledge graphs via MCP |

Rate-limit note: GitHub API allows ~60/hr unauth — if hit,
`git clone https://github.com/davila7/claude-code-templates.git` and copy
`cli-tool/components/skills/<cat>/<name>` → `~/.claude/skills/<name>`.

### 3b. Global agent skills — 30 (`~/.agents/skills`, auto-loaded)

| Skill | Detail |
|---|---|
| brainstorming | Mandatory pre-step before creative work: intent, requirements, design |
| differential-review | Security-focused diff review (PRs/commits), depth adapts to size |
| dispatching-parallel-agents | Fan out 2+ independent tasks without shared state |
| executing-plans | Execute written plans in separate session with review checkpoints |
| find-skills | Discover/install skills for "how do I do X" questions |
| finishing-a-development-branch | Decide merge vs PR vs cleanup when work is green |
| frontend-design | Sameudio as §3a frontend-design (global copy) |
| insecure-defaults | Audit fail-open defaults: hardcoded secrets, weak auth |
| orca-cli | Operate Orca worktrees, terminals, browser, artifacts via CLI |
| orchestration | Multi-agent coordination: threads, ask/reply, DAGs, gates |
| playwright-best-practices | Full Playwright guide: POM, CI, flaky tests, auth, a11y, uploads |
| receiving-code-review | Verify review feedback (technical rigor) before implementing |
| requesting-code-review | Verify work meets requirements before merge |
| shadcn | shadcn/ui components: add/search/fix/style/compose |
| skill-creator | Create/edit/benchmark skills |
| subagent-driven-development | Run plan tasks with independent in-session subagents |
| systematic-debugging | Debug methodically before proposing fixes |
| test-driven-development | Failing test first, always |
| turborepo | Monorepo pipelines, caching, `--filter/--affected` |
| typescript-advanced-types | Generics, conditional/mapped/template-literal types |
| using-git-worktrees | Isolated workspace via worktrees before implementation |
| using-superpowers | Skill-first protocol: invoke Skill tool before any response |
| vercel-composition-patterns | Compound components, render props, providers (React 19) |
| vercel-react-best-practices | React/Next.js perf from Vercel engineering |
| verification-before-completion | Run verifications, confirm output before claiming done |
| web-design-guidelines | UI review vs Web Interface Guidelines (a11y/UX) |
| web-quality-audit | Lighthouse-style audit: perf/a11y/SEO/best practices |
| webapp-testing | Playwright toolkit for local web apps + screenshots/logs |
| writing-plans | Write spec/plan before touching code |
| writing-skills | Create/edit/verify skills before deploy |

Install pattern: `npx skills add <owner/repo>` (Agent Skills registry).

### 3c. ECC skills — 220 (`~/.config/opencode/skills`, one command)

```bash
npx ecc-universal@2.2.3 setup   # Global + Standard hooks; full profile
```

<details><summary>All 220 names</summary>

agent-architecture-audit, agent-eval, agent-harness-construction,
agent-introspection-debugging, agent-payment-x402, agent-self-evaluation,
agent-sort, agentic-engineering, agentic-os, ai-first-engineering,
ai-regression-testing, api-connector-builder, architecture-decision-records,
article-writing, automation-audit-ops, autonomous-agent-harness,
autonomous-loops, benchmark, benchmark-methodology, benchmark-optimization-loop,
blender-motion-state-inspection, blueprint, brand-discovery, brand-voice,
browser-qa, canary-watch, carrier-relationship-management, cisco-ios-patterns,
ck, claude-devfleet, click-path-audit, clickhouse-io, code-tour,
codebase-onboarding, codehealth-mcp, competitive-platform-analysis,
competitive-report-structure, config-gc, configure-ecc, connections-optimizer,
content-engine, content-hash-cache-pattern, context-budget, continuous-agent-loop,
continuous-learning, continuous-learning-v2, cost-aware-llm-pipeline,
cost-tracking, council, council-multi-model, counterparty-channel-discipline,
crosspost, customer-billing-ops, customs-trade-compliance, dashboard-builder,
data-scraper-agent, data-throughput-accelerator, database-migrations,
deep-research, defi-amm-security, delivery-gate, deployment-patterns, dev-team,
django-security, dmux-workflows, docker-patterns, documentation-lookup,
dynamic-workflow-mode, e2e-testing, ecc-guide, ecc-recipes, ecc-tools-cost-audit,
email-ops, energy-procurement, enterprise-agent-ops, error-handling,
esign-field-placement, eval-harness, evm-token-decimals, exa-search, fal-ai-media,
finance-billing-ops, flox-environments, foundation-models-on-device,
gan-style-harness, gateguard, git-workflow, github-ops, google-workspace-ops,
graphify, growth-log, healthcare-cdss-patterns, healthcare-emr-patterns,
healthcare-eval-harness, healthcare-phi-compliance, hermes-imports,
hipaa-compliance, homelab-network-readiness, homelab-network-setup,
homelab-pihole-dns, homelab-vlan-segmentation, homelab-wireguard-vpn,
hookify-rules, inherit-legacy-style, intent-driven-development,
inventory-demand-planning, investor-materials, investor-outreach, ios-icon-gen,
iterative-retrieval, ito-baskets, ito-compute, ito-inference, ito-training,
jira-integration, jpa-patterns, knowledge-ops, kubernetes-patterns,
laravel-security, latency-critical-systems, lead-intelligence,
liquid-glass-design, living-docs-governance, llm-trading-agent-security,
logistics-exception-management, loop-design-check, mailtrap-email-integration,
manim-video, market-research, marketing-campaign, master-agreement-generator,
messages-ops, mysql-patterns, nanoclaw-repl, nasiko-control-plane,
netmiko-ssh-automation, network-bgp-diagnostics, network-config-validation,
network-interface-health, nodejs-keccak256, nutrient-document-processing,
openclaw-persona-forge, opensource-pipeline, operator-approval-loop,
orch-add-feature, orch-build-mvp, orch-change-feature, orch-fix-defect,
orch-pipeline, orch-refine-code, parallel-execution-optimizer, perl-security,
plan-canvas, plan-orchestrate, plankton-code-quality, postgres-patterns,
prediction-market-oracle-research, prediction-market-risk-review, prisma-patterns,
product-capability, product-lens, production-audit, production-scheduling,
project-flow-ops, prompt-optimizer, quality-nonconformance, quarkus-security,
ralphinho-rfc-pipeline, recursive-decision-ledger, redis-patterns,
regex-vs-llm-structured-text, remotion-video-creation, repo-scan, research-ops,
returns-reverse-logistics, rules-distill, safety-guard, santa-method,
scientific-db-pubmed-database, scientific-db-uspto-database,
scientific-pkg-gget, scientific-thinking-literature-review,
scientific-thinking-scholar-evaluation, search-first, security-bounty-hunter,
security-review, security-scan, seo, skill-comply, skill-scout, skill-stocktake,
social-graph-ranker, social-publisher, springboot-security, strategic-compact,
swift-actor-persistence, swift-concurrency-6-2, swift-protocol-di-testing,
swiftui-patterns, taste, taste-application, taste-distillation, tasteforge-video,
tdd-workflow, team-agent-orchestration, team-builder, terminal-opener,
terminal-ops, token-budget-advisor, ui-demo, uncloud, unified-memory,
unified-notifications-ops, verification-loop, video-editing, videodb,
visa-doc-translate, windows-desktop-e2e, workspace-surface-audit, x-api.

</details>

One install method only (plugin XOR manual). State:
`~/.config/opencode/ecc-install-state.json`. Docs: https://ecc.tools

### 3d. Caveman — terse talk mode

```bash
npx skills add JuliusBrussee/caveman
```

Cuts output ~65-75%, code/commands/errors stay byte-exact. Pairs with Ponytail
(what to build vs how to talk). `/caveman lite|full|ultra`, off: `stop caveman`.
Drop for security warnings and destructive confirms.

## 4. Agents — 20 (detail, `~/.config/opencode/agents`)

```bash
npx claude-code-templates@latest --agent development-team/backend-developer,development-team/backend-architect,development-team/frontend-developer,development-team/fullstack-developer,development-team/mobile-developer,development-team/mobile-app-developer
npx claude-code-templates@latest --agent programming-languages/flutter-expert,programming-languages/spring-boot-engineer,programming-languages/java-architect,development-tools/code-reviewer,development-tools/qa-expert,development-tools/test-automator
npx claude-code-templates@latest --agent development-team/devops-engineer,devops-infrastructure/kubernetes-specialist,security/platform-sre-kubernetes,database/database-architect,database/database-administrator,business-marketing/project-manager,api-graphql/api-designer,devops-infrastructure/security-engineer
```

Then **strip Claude-only frontmatter** from OpenCode copies (`tools:`,
`model: sonnet`, `color:`, `allowed-tools:`) or OpenCode refuses to start.
Verify: `opencode agent list`.

| Agent | Detail |
|---|---|
| backend-developer | Implements APIs/microservices: persistence, auth, caching, 10k-RPS class targets |
| backend-architect | Service boundaries, monolith decomposition, REST/gRPC/GraphQL selection, observability |
| frontend-developer | Full React/Vue/Angular apps + migrations, TanStack/Pinia, a11y, Vitest |
| fullstack-developer | DB→API→UI features as one unit (auth, realtime, event-driven refactors) |
| mobile-developer | Cross-platform (RN/Flutter): offline-first, biometrics, deep links, store CI/CD |
| mobile-app-developer | Native iOS (SwiftUI) + Android (Compose): perf targets, crash-rate goals |
| flutter-expert | Flutter 3+: BLoC/Riverpod, platform channels, 60fps, migrations from v2 |
| spring-boot-engineer | Spring Boot 3 microservices: Cloud Gateway, Eureka, Resilience4j, WebFlux |
| java-architect | Java 11→21 + Boot 2.7→3.x migrations, DDD boundaries, Kafka, GraalVM |
| code-reviewer | PR quality gates: security, correctness, performance, maintainability |
| qa-expert | QA strategy, coverage targets, defect analysis, release go/no-go |
| test-automator | Builds test frameworks, kills flakiness, wires CI reporting |
| devops-engineer | Pipelines, provisioning, monitoring, deployment optimization |
| kubernetes-specialist | Prod clusters: HA, CIS compliance, RBAC, autoscaling, multi-tenancy |
| platform-sre-kubernetes | Reliability-first K8s: safe rollouts/rollbacks, security defaults |
| database-architect | Greenfield schema, polyglot selection, zero-downtime decomposition plans |
| database-administrator | Perf triage, HA/failover, backup/recovery, 200GB+ migrations |
| project-manager | Plans, WBS, risks, budget/schedule control, closure + lessons learned |
| api-designer | OpenAPI 3.2 contracts, versioning, protocol picks before implementation |
| security-engineer | Security arch, compliance, vuln management, automation, incident response |

## 5. MCP servers — 11 (detail, opencode.json)

| MCP | Detail | Config |
|---|---|---|
| linear | Issues/projects via Linear remote MCP | remote `https://mcp.linear.app/mcp` |
| notion | Docs/notes via Notion remote MCP | remote `https://mcp.notion.com/mcp` |
| github | Repos/issues/PRs via Copilot API proxy, token from env | remote `https://api.githubcopilot.com/mcp/`, `Authorization: Bearer {env:GITHUB_PERSONAL_ACCESS_TOKEN}` |
| context7 | Fresh library docs (beats training cutoff) | local `npx -y @upstash/context7-mcp@latest` |
| filesystem | Scoped file access (single workdir) | local `npx -y @modelcontextprotocol/server-filesystem <workdir>` |
| git | Multi-repo git ops (15 repos) | local `uvx mcp-server-git --repository <repo> …` |
| shell | Sandboxed shell in workdir | local `npx -y @mako10k/mcp-shell-server@latest` + `MCP_SHELL_*WORKDIR` env |
| playwright | Real browser automation (E2E, visual checks) | local `npx -y @playwright/mcp@latest` |
| agent-browser | Second lightweight browser driver | local `npx -y agent-browser@latest mcp` |
| graphify | Codebase knowledge-graph queries | local `graphify-mcp --graph <root>/graphify-out/graph.json` |
| open-ontologies | Ontology `onto_*` tools (validate/reason/plan) | local `<home>/.local/bin/open-ontologies serve` |

Rules: `command` is always an array; secrets via `{env:VAR}`;
`enabled: false` disables inherited servers. Staged but unwired (need docker):
`markitdown` (file→md), `github-official` (official GitHub MCP) in `~/.claude/mcps`.

## 6. Knowledge + runtime (detail)

| Tool | Detail | Install |
|---|---|---|
| Graphify | Codebase knowledge graph; ask "what calls X" before grep | index → `graphify-out/graph.json`, MCP reads it |
| Open Ontologies | Blast-radius + Lean-checkable proof for ontology changes (MIT, Rust, no JVM) | binary → `~/.local/bin`; skills copied to `~/.claude/skills` |
| herdr | Agent-aware multiplexer: working/blocked/idle panes, survives drops, multi-machine SSH | `curl -fsSL https://herdr.dev/install.sh \| sh` → `herdr` (fallback: tmux/Zellij) |
| ralph-tui | Autonomous backlog loop: select→prompt→execute→`<promise>COMPLETE</promise>` | `bun install -g ralph-tui` → `setup → create-prd --chat → run` |
| Beads | Git-backed dependency-aware tasks; feeds ralph-tui/herdr; no server | pairs with both; alternative to Linear/Jira for loops |

## 7. Definition of done

Build → typecheck → lint → tests green (new regression test for bugfixes) →
fresh-context self-review → smallest diff. Benchmark before/after for perf work.

## 8. Troubleshooting

| Symptom | Fix |
|---|---|
| `ConfigInvalidError` on start | shape vs `https://opencode.ai/config.json`; strip Claude frontmatter |
| `Expected object, got "Read, Write..." tools` | delete `tools:` line in that agent file |
| GitHub API 403 on aitmpl install | wait, or clone + copy manually |
| MCP silent fail | `command` must be array; check binary/env key |
| Weak answers | variant too low or context bloated — trim rules, reroute agent |
| Agent loops forever | tighten scope, add gates/hooks |
