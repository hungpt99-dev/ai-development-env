# Security Standard (tool-agnostic)

> Who: everyone. Mandatory: yes. Violations block release.

## 1. Non-negotiables

1. Never commit secrets (API keys, tokens, passwords, private keys, connection strings). Use env vars / secret manager.
2. Validate all external input at the boundary (API, CLI, queue, file). Allowlist over denylist.
3. AuthN/AuthZ checked server-side on every request. No client-only checks. Default deny.
4. Parameterize queries / use ORM safely. No string-concatenated SQL. Escape output per context (HTML, shell, etc.).
5. Crypto: use standard libraries only. No custom crypto, no hardcoded IVs, no MD5/SHA1 for security.
6. Least privilege: service accounts, tokens, and DB users get minimum scope + expiry.

## 2. Data handling

- Classify data: `public` / `internal` / `confidential` (PII, credentials). Confidential data needs encryption in transit + at rest and access logging.
- Minimize PII: collect/store the minimum; redact in logs; mask in non-prod.
- Dependencies: check known CVEs before adding/upgrading (`npm audit`, `pip audit`, `dependabot`, etc. per stack).

## 3. AI-specific rules

- AI must flag any security-relevant change (auth, crypto, input handling, secrets, PII, permissions) under a `Security:` section in its summary — even if it believes the change is safe.
- AI must never generate fake secrets for examples that look real. Use `REPLACE_ME` / `example.invalid` placeholders.
- AI must not disable security controls (auth, TLS verify, sanitization) to "make tests pass". If a control blocks progress, stop and ask a human.
- AI must run the secret-scan check (`scripts/validate.*`) before handoff and report the result.
