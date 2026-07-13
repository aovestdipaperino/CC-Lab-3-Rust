#!/usr/bin/env bash
# The verification gate. Runs, in order: fmt, build, unit/integration tests,
# and an acceptance terminal test (the built binary over cases.txt).
# Exits non-zero if any step fails.
set -uo pipefail
cd "$(dirname "$0")"

echo "== 1/4 fmt (cargo fmt --check) =="
if ! cargo fmt --check; then
  echo "CHECK FAILED (fmt)"
  exit 1
fi

echo "== 2/4 build (release) =="
if ! cargo build --release; then
  echo "CHECK FAILED (build)"
  exit 1
fi

echo "== 3/4 tests =="
if ! cargo test --release; then
  echo "CHECK FAILED (test)"
  exit 1
fi

echo "== 4/4 acceptance (calc over cases.txt) =="
bin="./target/release/calc"
fail=0
while IFS='|' read -r expr expected; do
  [ -z "${expr// }" ] && continue
  got=$("$bin" "$expr")
  if [ "$got" != "$expected" ]; then
    echo "  FAIL: '$expr' => got '$got', want '$expected'"
    fail=1
  else
    echo "  ok:   '$expr' => $got"
  fi
done < cases.txt
if [ "$fail" -ne 0 ]; then
  echo "CHECK FAILED (acceptance)"
  exit 1
fi

echo "CHECK PASSED"
exit 0
