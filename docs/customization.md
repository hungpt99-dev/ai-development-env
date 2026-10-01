# Customization — team vs project

## Precedence
```
project.yaml  (project overrides — highest)
  > team.yaml (team defaults)
    > standards/ (team rules — base)
```

## Team standard (this repo)
Edit for all projects: coding/security/testing baselines, roles, workflows, gates, templates, prompts.

## Project config (`project.yaml` in the consuming project)
- Copy from `project.example.yaml`.
- `extends_standard` pins what you tested against; `compatible_with` declares drift tolerance.
- `conventions/*`: additive stack rules (Java/Spring, DB, API envelope, etc.).
- `tighten`: stricter gates freely (e.g. coverage 70→80).
- `waivers`: loosen ONLY with `rule + reason + approved_by + expires`. Expired waiver = validation warning (extend or fix).

## Example: Spring Boot project
```yaml
extends_standard: "1.0.0"
project: { name: "billing-api", language_stack: [java-17, spring-boot-3] }
conventions:
  api: ["Envelope {code,message,data}", "Error codes in knowledge/architecture/error-codes.md"]
tighten: { testing: ["Coverage >=80% on new/changed lines"] }
```

## Anti-patterns
- Forking the standard per project (loses updates — use `project.yaml` + waivers instead).
- Pasting project conventions into `team.yaml` (pollutes other stacks).
- Duplicating rules into adapters (breaks single-source-of-truth — adapters point, never copy).
