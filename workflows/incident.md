# Workflow: Incident

> Priority: mitigate → communicate → resolve → learn. AI assists, human commands.

1. **Mitigate** (DevOps + Developer): stop bleeding (rollback, scale, feature-flag off). AI suggests options; human selects.
2. **Communicate**: status page / channel update with impact + ETA. No blame, no speculation — mark unknowns.
3. **Resolve**: fix via `bug-fix.md` fast-track. Every prod hotfix gets a regression test.
4. **Learn**: blameless postmortem within 3 days — timeline, root cause, contributing factors, action items with owners.
5. **Record**: decision log (`templates/decision-log.md`) — what AI proposed vs what human decided.

AI must never execute destructive prod ops alone. Escalation is mandatory for data loss / auth outage / payment impact.
