# Gate: Review (🔒 human approval required)

- [ ] Scope matches linked requirement/design (or split requested)
- [ ] Correctness: logic + edge + error handling verified
- [ ] Security: auth/input/secrets/PII reviewed, `Security:` section in summary
- [ ] Performance: no obvious N+1, unbounded loop, or blocking I/O on hot path (or justified)
- [ ] Maintainability: naming, size, no dead code
- [ ] Tests meaningful (assert behavior, cover failure path); no gamed coverage
- [ ] Regression risk assessed (what adjacent areas could break + how verified)
- [ ] Verdict exactly one: Approve / Request changes / Comment; blocking items cite a rule
