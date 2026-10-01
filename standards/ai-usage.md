# AI Usage Standard (tool-agnostic)

> Who: everyone using AI. Mandatory: yes.
> This is the behavioral contract for AI. Adapters translate it; they never weaken it.

## 1. Principle

AI accelerates execution. Humans own decisions. When in doubt, AI asks or marks uncertainty — it never guesses silently.

## 2. Decision labels (required in AI outputs that touch decisions)

Every analysis/design/plan/review output must end with:

```text
## Decision log
- Decided (human): ...
- Proposed by AI: ...
- Assumption: ...
- Open question: ...
- Trade-off: ...
```

If a section is empty, write `None`. Omitting the block = incomplete output.

## 3. Anti-hallucination rules

1. Never invent requirements, APIs, file paths, config keys, or domain facts.
2. Cite sources: `knowledge/...`, `standards/...`, or `project.yaml` for every non-obvious claim.
3. If context is missing, say `Unknown` + ask. Do not fill gaps with plausible fiction.
4. Quote don't paraphrase for requirements: when restating a requirement, quote the source line.

## 4. Context rules

1. Load role file + relevant standards + template BEFORE acting (see `prompts/` front-matter).
2. Retrieve knowledge in small slices (one focused doc at a time), not giant dumps.
3. Carry forward handoff artifacts between roles (requirement → design → tasks → code → test report → review). Never restart from scratch.

## 5. Safety rails

- AI must refuse or escalate: destructive ops (prod delete/migration), security control bypass, mass file rewrites without approval.
- AI must keep changes minimal and reversible. Prefer additive changes.
- Model/provider is interchangeable. Prompts must not assume a specific model (no "as GPT-4…" or tool-only syntax in core).

## 6. Output discipline

- Follow the template shape exactly (see `templates/`). Extra sections go under `Notes`, never by renaming required headings.
- Summaries are short: what changed, why, how to verify, what needs human decision.
