<#
.SYNOPSIS
  Install the team AI standard into a project (one command onboarding).
.DESCRIPTION
  Generates thin adapter pointer files that reference this standard repo.
  Never duplicates rules.
.EXAMPLE
  ./scripts/install.ps1
  ./scripts/install.ps1 -Tool cursor -RepoRoot C:\code\my-api
#>
param(
  [string]$Tool = "",
  [string]$RepoRoot = (Get-Location).Path,
  [string]$StandardRoot = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = "Stop"

function Get-StandardVersion($root) {
  $team = Get-Content (Join-Path $root "team.yaml") -Raw
  if ($team -match 'standard_version:\s*"(.*?)"') { return $Matches[1] }
  throw "standard_version not found in team.yaml"
}

$version = Get-StandardVersion $StandardRoot
Write-Host "AI Engineering Standard v$version"
Write-Host "Standard: $StandardRoot"
Write-Host "Target:   $RepoRoot"

if (-not $Tool) {
  Write-Host ""
  Write-Host "Select your AI tool:"
  Write-Host "  [1] opencode  [2] claude  [3] cursor  [4] copilot  [5] codex"
  $choice = Read-Host "Enter 1-5 (default 1)"
  if (-not $choice) { $choice = "1" }
  $Tool = @("opencode","claude","cursor","copilot","codex")[[int]$choice - 1]
}

$header = "<!-- Generated from ai-engineering-standard v$version - do not edit by hand -->"
$std = $StandardRoot -replace '\\','/'

function Write-File($rel, $content) {
  $full = Join-Path $RepoRoot $rel
  $dir = Split-Path $full -Parent
  if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
  Set-Content -LiteralPath $full -Value $content -Encoding UTF8
  Write-Host "  wrote $rel"
}

# Project config bootstrap (only if missing - never overwrite)
if (-not (Test-Path (Join-Path $RepoRoot "project.yaml"))) {
  Copy-Item (Join-Path $StandardRoot "project.example.yaml") (Join-Path $RepoRoot "project.yaml")
  Write-Host "  wrote project.yaml (from example - edit for your stack)"
} else {
  Write-Host "  kept existing project.yaml"
}

if ($Tool -eq "opencode") {
  $body = $header + "`n# Project AI instructions (OpenCode)`n`nCore standard: " + $std + " (v" + $version + ")`nProject config: ./project.yaml (precedence: project.yaml over team.yaml over standards/)`n`nAlways load before acting:`n- standards/ai-usage.md (decision labels, anti-hallucination)`n- roles/<active-role>.md + prompts/<task>.md (follow its front-matter read_first)`n- templates/<artifact>.md for output shape; gates/<stage>.md for self-check`n`nHuman owns decisions - end outputs with the Decision log block.`n"
  Write-File "AGENTS.md" $body
}
elseif ($Tool -eq "claude") {
  Write-File "CLAUDE.md" ($header + "`n# Project AI instructions (Claude)`n`nCore standard: " + $std + " (v" + $version + "). Project config: ./project.yaml.`nLoad standards/ai-usage.md + active role + prompt front-matter before acting.`n")
  foreach ($c in @("analyze","plan","implement","review","debug")) {
    Write-File ".claude/commands/$c.md" ($header + "`nFollow " + $std + "/prompts/" + $c + ".md and its front-matter read_first list.`n")
  }
}
elseif ($Tool -eq "cursor") {
  foreach ($r in @("ai-usage","coding","testing","security")) {
    $mdc = "---`nglobs: [`"**/*`"]`n---`n" + $header + "`nFollow " + $std + "/standards/" + $r + ".md (team source of truth). Project overrides: ./project.yaml.`n"
    Write-File ".cursor/rules/$r.mdc" $mdc
  }
}
elseif ($Tool -eq "copilot") {
  Write-File ".github/muse-instructions.md" ($header + "`nFollow " + $std + "/standards/ai-usage.md and roles/developer.md. Output shapes: templates/*.md. Gates: gates/*.md. Overrides: ./project.yaml.`n")
  Write-File ".github/prompts/implement.prompt.md" ($header + "`nFollow " + $std + "/prompts/implement.md and its front-matter read_first list.`n")
  Write-File ".github/prompts/review.prompt.md" ($header + "`nFollow " + $std + "/prompts/review.md and its front-matter read_first list.`n")
}
elseif ($Tool -eq "codex") {
  Write-File "AGENTS.md" ($header + "`n# Project AI instructions (Codex)`n`nCore standard: " + $std + " (v" + $version + "). Project config: ./project.yaml.`nLoad standards/ai-usage.md + active role + prompt front-matter before acting.`nHuman owns decisions - end outputs with the Decision log block.`n")
}
else { throw "Unknown tool: $Tool (expected opencode|claude|cursor|copilot|codex)" }

Write-Host ""
Write-Host "Done. Next: read the getting-started guide in docs/."
Write-Host "Validate with: powershell ./scripts/validate.ps1"
