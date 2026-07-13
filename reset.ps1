#!/usr/bin/env pwsh
# Restore the repo to its starting state. PowerShell equivalent of reset.sh.
$ErrorActionPreference = 'Continue'
Set-Location -Path $PSScriptRoot

git checkout -- . 2>$null
git clean -fdx --exclude=.git 2>$null
Remove-Item .claude\settings.json -ErrorAction SilentlyContinue

$tmp = if ($env:TEMP) { $env:TEMP } else { [System.IO.Path]::GetTempPath() }
Remove-Item (Join-Path $tmp 'calc-verify-stop.count') -ErrorAction SilentlyContinue
Remove-Item (Join-Path $tmp 'calc-verify-stop.log') -ErrorAction SilentlyContinue

Write-Host "Reset to starting state."
