# Workflow: Release

> Role: `roles/devops.md`. Gate: `gates/release.md`.

1. **Freeze**: `main` green (build+lint+tests+secret-scan). Changelog updated.
2. **Migrate safely**: DB migrations reversible or backup verified. Expand→migrate→contract for breaking changes.
3. **Tag**: `git tag vX.Y.Z` per SemVer; release notes from CHANGELOG + PR titles.
4. **Deploy**: staged (canary → % → full) where possible. Secrets from manager, never in image/env file.
5. **Verify**: smoke test + dashboards/alerts watched for 30 min (or team SLA). Rollback plan rehearsed or documented.
6. **Record**: release notes + decision log. Failed release → incident workflow.
