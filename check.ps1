#!/usr/bin/env pwsh
# The verification gate. Runs fmt, build, tests, and an acceptance terminal
# test (the built binary over cases.txt). PowerShell equivalent of check.sh.
$ErrorActionPreference = 'Continue'
Set-Location -Path $PSScriptRoot

Write-Host "== 1/4 fmt (cargo fmt --check) =="
cargo fmt --check
if ($LASTEXITCODE -ne 0) { Write-Host "CHECK FAILED (fmt)"; exit 1 }

Write-Host "== 2/4 build (release) =="
cargo build --release
if ($LASTEXITCODE -ne 0) { Write-Host "CHECK FAILED (build)"; exit 1 }

Write-Host "== 3/4 tests =="
cargo test --release
if ($LASTEXITCODE -ne 0) { Write-Host "CHECK FAILED (test)"; exit 1 }

Write-Host "== 4/4 acceptance (calc over cases.txt) =="
$bin = Join-Path $PSScriptRoot 'target\release\calc.exe'
$fail = 0
foreach ($line in Get-Content cases.txt) {
    if (-not $line.Trim()) { continue }
    $parts = $line -split '\|', 2
    $expr = $parts[0]; $expected = $parts[1]
    $got = (& $bin $expr | Out-String).Trim()
    if ($got -ne $expected) {
        Write-Host "  FAIL: '$expr' => got '$got', want '$expected'"
        $fail = 1
    } else {
        Write-Host "  ok:   '$expr' => $got"
    }
}
if ($fail -ne 0) { Write-Host "CHECK FAILED (acceptance)"; exit 1 }

Write-Host "CHECK PASSED"
exit 0
