# Coding Standard (tool-agnostic)

> Who: humans + every AI role. Mandatory: yes.
> Purpose: small, enforceable rules that keep AI-generated code consistent.

## 1. General

1. Prefer clarity over cleverness. Boring code wins.
2. Follow the project's formatter/linter. If none exists, state the assumption and pick one — do not mix styles in one change.
3. Max function length ~50 lines; extract helper if longer. Max file length ~500 lines; split by responsibility.
4. No dead code, no commented-out code, no `TODO` without owner + date (`TODO(@user, 2026-10-01): ...`).
5. No magic values — name constants. No silent `catch {}` — log or rethrow with context.

## 2. Naming & structure

- Names reveal intent: `calculateOverdueFee()`, not `doCalc()`.
- Booleans read as assertions: `isActive`, `hasPermission`, `shouldRetry`.
- One concept per module/function. Side effects must be visible in the name (`saveAndNotify`, not `save`).

## 3. Errors & logging

- Fail fast with actionable messages: what happened, what was expected, what to do next.
- Log at boundaries (API, queue, job), not inside tight loops. Include correlation/request ID when available.
- Never log secrets, tokens, PII beyond the minimum. See `security.md`.

## 4. Dependencies

- Do not add a dependency without: (a) why stdlib is insufficient, (b) license check, (c) maintenance signal. Record in the design doc.
- Pin versions in manifests. No `latest` in production code.

## 5. AI-specific rules

- AI must state which project conventions it followed (`project.yaml` / knowledge files) at the top of its summary.
- AI must not invent APIs, config keys, or domain terms. If unsure, mark `Assumption:` and ask.
- AI must keep diffs minimal: no unrelated refactors, no drive-by formatting of untouched files.
- AI must run (or state) formatter + typecheck/lint before handing off. If it cannot run them, say so explicitly.

## 6. Examples (good vs bad)

```text
BAD:  catch (e) {}
GOOD: catch (e) { logger.warn("payment retry failed, will requeue", { orderId }); throw e; }
```
