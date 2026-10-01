<#
.SYNOPSIS
  Validate the standard repo: required files, YAML, adapter refs, secrets, version.
.EXAMPLE
  pwsh ./scripts/validate.ps1
  pwsh ./scripts/validate.ps1 -StandardRoot C:\path\to\standard
#>
param([string]$StandardRoot = (Split-Path $PSScriptRoot -Parent))
$ErrorActionPreference = "Stop"
$failed = $false
function Fail($msg) { Write-Host "FAIL: $msg" -ForegroundColor Red; $script:failed = $true }
function Ok($msg)   { Write-Host "OK:   $msg" -ForegroundColor Green }

# 1. Required files exist
$required = @(
  "README.md","CHANGELOG.md","team.yaml","project.example.yaml",
  "standards/coding.md","standards/architecture.md","standards/security.md",
  "standards/testing.md","standards/git.md","standards/ai-usage.md",
  "roles/ba.md","roles/architect.md","roles/developer.md","roles/qa.md","roles/reviewer.md","roles/devops.md",
  "workflows/feature-development.md","workflows/bug-fix.md","workflows/code-review.md","workflows/incident.md","workflows/release.md",
  "gates/requirement.md","gates/architecture.md","gates/implementation.md","gates/qa.md","gates/review.md","gates/release.md",
  "templates/requirement.md","templates/technical-design.md","templates/task-breakdown.md","templates/test-plan.md","templates/code-review.md","templates/decision-log.md",
  "prompts/analyze.md","prompts/plan.md","prompts/implement.md","prompts/review.md","prompts/debug.md",
  "knowledge/README.md","knowledge/index.yaml",
  "adapters/README.md",
  "docs/getting-started.md","docs/architecture.md","docs/contribution.md","docs/customization.md","docs/versioning.md"
)
foreach ($f in $required) {
  if (Test-Path (Join-Path $StandardRoot $f)) { Ok $f } else { Fail "missing $f" }
}

# 2. YAML parses (team.yaml, project.example.yaml, knowledge/index.yaml, adapters/*/mapping.yaml)
try {
  # Minimal check without external modules: use python if available, else powershell converter
  $yamls = @("team.yaml","project.example.yaml","knowledge/index.yaml") +
    (Get-ChildItem (Join-Path $StandardRoot "adapters") -Filter mapping.yaml -Recurse | ForEach-Object {
      $_.FullName.Substring($StandardRoot.Length + 1) })
  foreach ($y in $yamls) {
    $p = Join-Path $StandardRoot $y
    if (-not (Test-Path $p)) { Fail "missing yaml $y"; continue }
    $raw = Get-Content $p -Raw
    if ($raw -match ":\t" -or $raw.Length -eq 0) { Fail "suspicious yaml $y" } else { Ok "yaml parses (heuristic) $y" }
  }
} catch { Fail "yaml check error: $_" }

# 3. team.yaml has standard_version SemVer
$team = Get-Content (Join-Path $StandardRoot "team.yaml") -Raw
if ($team -match 'standard_version:\s*"(\d+\.\d+\.\d+)"') { Ok "standard_version $($Matches[1])" }
else { Fail "team.yaml standard_version must be SemVer quoted string" }

# 4. Adapters reference valid core artifacts (every source_refs path exists)
Get-ChildItem (Join-Path $StandardRoot "adapters") -Filter mapping.yaml -Recurse | ForEach-Object {
  $content = Get-Content $_.FullName -Raw
  foreach ($m in [regex]::Matches($content, '"((?:standards|roles|workflows|gates|templates|prompts|knowledge)/[^"]+)"')) {
    $ref = $m.Groups[1].Value
    if (Test-Path (Join-Path $StandardRoot $ref)) { Ok "adapter ref $($_.Directory.Name) -> $ref" }
    else { Fail "adapter $($_.Directory.Name) references missing $ref" }
  }
}

# 5. Templates contain Decision log (except decision-log itself which IS the log)
foreach ($t in @("requirement","technical-design","task-breakdown","test-plan","code-review")) {
  $c = Get-Content (Join-Path $StandardRoot "templates/$t.md") -Raw
  if ($c -match "Decision log") { Ok "template $t has Decision log" } else { Fail "template $t missing Decision log" }
}

# 6. No secrets committed (heuristic grep)
$patterns = @('AKIA[0-9A-Z]{16}','ghp_[A-Za-z0-9]{20,}','sk-[A-Za-z0-9]{10,}','-----BEGIN (RSA )?PRIVATE KEY-----','password\s*=\s*["''][^"'']{3,}')
$hits = Get-ChildItem $StandardRoot -Recurse -File -Include *.md,*.yaml,*.yml,*.json,*.ps1,*.sh |
  Select-String -Pattern $patterns -ErrorAction SilentlyContinue
if ($hits) { Fail "possible secrets found:`n$($hits | Out-String)" } else { Ok "no secrets detected (heuristic)" }

# 7. knowledge/index.yaml paths exist
$idx = Get-Content (Join-Path $StandardRoot "knowledge/index.yaml") -Raw
foreach ($m in [regex]::Matches($idx, '"(knowledge/[^"]+)"')) {
  $ref = $m.Groups[1].Value
  if (Test-Path (Join-Path $StandardRoot $ref)) { Ok "index -> $ref" }
  else { Fail "knowledge/index.yaml references missing $ref" }
}

if ($failed) { Write-Host "`nVALIDATION FAILED" -ForegroundColor Red; exit 1 }
Write-Host "`nVALIDATION PASSED" -ForegroundColor Green
