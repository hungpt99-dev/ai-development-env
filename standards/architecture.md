# Architecture Standard (tool-agnostic)

> Who: Architect role + Reviewer. Mandatory: yes for any non-trivial change.

## 1. When a design doc is required

Required if ANY is true: new service/table/queue, public API change, auth change,
cross-team dependency, migration, or >3 days of work. Otherwise a task breakdown suffices.

## 2. Required design content

Use `templates/technical-design.md`. At minimum: context, proposed solution,
API/data changes, failure handling, security, observability, trade-offs, risks.

## 3. Principles

1. Explicit over implicit: data flow, ownership, and failure modes must be written down.
2. Boring technology preferred: use what the team already operates unless a design doc justifies otherwise.
3. Boundaries first: define module/service contracts before internals.
4. Evolution over revolution: prefer incremental, backward-compatible changes (expand → migrate → contract).

## 4. AI-specific rules

- AI may **propose** options (minimum 2 where trade-off exists) with pros/cons, but must not **select** the final option. Mark: `Proposed by AI — awaiting human decision`.
- AI must list dependencies, API/data changes, and security considerations explicitly. "No changes" is a claim that must be justified, not defaulted.
- AI must not invent existing system behavior. If the current system is unknown, write `Unknown — needs human confirmation` instead of guessing.
