<#
.SYNOPSIS
  Kamui Skills installer for Windows (PowerShell) — Claude Code, Codex, and Cursor.

.DESCRIPTION
  SKILL.md is a cross-tool standard, so the same skill folders work everywhere;
  only the install directory differs. This script copies the skills into the
  per-user directories each tool reads on Windows:
    Claude Code -> %USERPROFILE%\.claude\skills
    Codex/Cursor-> %USERPROFILE%\.agents\skills

.PARAMETER Tool
  all (default) | claude | codex | cursor

.PARAMETER Dest
  Install into a single explicit directory instead of the per-tool defaults
  (e.g. a project-local .cursor\skills).

.EXAMPLE
  # One-line install (reads from the public GitHub repo):
  irm https://raw.githubusercontent.com/kamui-project/kamui-skills/main/install.ps1 | iex

.EXAMPLE
  # From a cloned repo, only for Codex:
  .\install.ps1 -Tool codex
#>
[CmdletBinding()]
param(
  [ValidateSet('all','claude','codex','cursor')]
  [string]$Tool   = 'all',
  [string]$Dest   = '',
  [string]$Repo   = 'kamui-project/kamui-skills',
  [string]$Branch = 'main'
)

$ErrorActionPreference = 'Stop'
$Skills = @('kamui-github-setup','kamui-deploy-workflows','kamui-mcp-setup','kamui-troubleshooting')

function Say($m) { Write-Host "› $m" -ForegroundColor Cyan }
function Err($m) { Write-Host "✗ $m" -ForegroundColor Red }

# --- resolve destination directories ---------------------------------------
$home_ = $env:USERPROFILE
if (-not $home_) { $home_ = $HOME }
$claudeDir = Join-Path $home_ '.claude\skills'
$agentsDir = Join-Path $home_ '.agents\skills'

if ($Dest) {
  $Dests = @($Dest)
} else {
  switch ($Tool) {
    'claude' { $Dests = @($claudeDir) }
    'codex'  { $Dests = @($agentsDir) }
    'cursor' { $Dests = @($agentsDir) }
    'all'    { $Dests = @($claudeDir, $agentsDir) }
  }
}

# --- resolve source skills\ dir: local checkout, else download zip ---------
$scriptDir = $null
if ($PSScriptRoot) { $scriptDir = $PSScriptRoot }
elseif ($PSCommandPath) { $scriptDir = Split-Path -Parent $PSCommandPath }

if ($scriptDir -and (Test-Path (Join-Path $scriptDir 'skills'))) {
  $Src = Join-Path $scriptDir 'skills'
  Say "Installing from local checkout: $Src"
} else {
  $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("kamui-skills-" + [System.Guid]::NewGuid().ToString('N'))
  New-Item -ItemType Directory -Path $tmp -Force | Out-Null
  $zip = Join-Path $tmp 'repo.zip'
  $url = "https://codeload.github.com/$Repo/zip/refs/heads/$Branch"
  Say "Downloading $Repo@$Branch …"
  try {
    Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing
    Expand-Archive -Path $zip -DestinationPath $tmp -Force
  } catch {
    Err "Download failed. Check the repo name: $Repo"
    throw
  }
  $found = Get-ChildItem -Path $tmp -Recurse -Directory -Filter 'skills' |
           Where-Object { Test-Path (Join-Path $_.FullName 'kamui-mcp-setup') } |
           Select-Object -First 1
  if (-not $found) { Err "Could not find a skills\ directory in the downloaded repo."; throw }
  $Src = $found.FullName
}

# --- install ---------------------------------------------------------------
foreach ($dest in $Dests) {
  New-Item -ItemType Directory -Path $dest -Force | Out-Null
  Say "Installing into: $dest"
  foreach ($s in $Skills) {
    $from = Join-Path $Src $s
    if (Test-Path $from) {
      $to = Join-Path $dest $s
      if (Test-Path $to) { Remove-Item $to -Recurse -Force }
      Copy-Item $from $to -Recurse -Force
      Write-Host "   ✓ $s" -ForegroundColor Green
    } else {
      Err "Skipping $s (not found in source)"
    }
  }
}

Say "Done. Restart your AI tool (Claude Code: /skills · Codex: /skills · Cursor: reload workspace)."
