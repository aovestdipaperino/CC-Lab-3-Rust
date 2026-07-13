#!/usr/bin/env bash
# Restore the repo to its starting state.
set -uo pipefail
cd "$(dirname "$0")"
git checkout -- . 2>/dev/null || true
git clean -fdx --exclude=.git 2>/dev/null || true
rm -f .claude/settings.json
rm -f "${TMPDIR:-/tmp}/calc-verify-stop.count" "${TMPDIR:-/tmp}/calc-verify-stop.log"
echo "Reset to starting state."
