# Architecture — why this shape

## Principles
1. **Root is the source of truth.** `standards/`, `roles/`, `workflows/`, `gates/`, `templates/`, `prompts/`, `knowledge/` are tool-agnostic Markdown+YAML. No tool syntax in core.
2. **Adapters are thin.** `adapters/<tool>/` contains only pointers (`mapping.yaml` + generated pointer files). Rule change = core change; adapters keep working.
3. **Humans own decisions.** Decision log (Decided/Proposed/Assumption/Open Q/Trade-off) is mandatory; three gates require human sign-off (requirement, architecture, review).
4. **Small slices, not dumps.** Knowledge is many <150-line docs + `index.yaml` for slice retrieval (file-based today, RAG/MCP/Dify tomorrow — none mandatory).
5. **Boring tech.** Markdown + YAML + small scripts + Git + each tool's native config mechanism. No custom platform.

## Why no `core/` wrapper (deliberate deviation from the brief)
The brief suggested `core/standards/...` + `adapters/...`. We flattened to root-level `standards/...` + `adapters/...` because:
- Shorter paths and relative links (fewer `../../` errors for AI and humans)
- `git sparse-checkout` and per-tool packaging simpler (adapters are the only exception)
- Root README *is* the contract; an extra `core/` level adds navigation without adding meaning
- If monorepo growth ever demands it, `core/` can be reintroduced as a pure move (paths in `mapping.yaml` + installer updated once, validated by script)

## Alternatives considered
- **Git submodules per project**: rejected — version pinning via `extends_standard` + `compatible_with` in `project.yaml` is simpler and survives offline copies.
- **Single mega-prompt**: rejected — unreviewable, unversionable, model-specific. Composable prompts with front-matter win.
- **Custom CLI/platform**: rejected — violates "minimal infrastructure". Scripts are dependency-free (`pwsh`/`bash` only).

## Data flow
```text
team.yaml (defaults+version) + project.yaml (overrides)
  → roles/*.md + standards/*.md + prompts/*.md[front-matter]
    → templates/*.md artifacts → gates/*.md checks → workflows/*.md sequencing
      → adapters/<tool>/* (native pointer files in the consuming project)
```
