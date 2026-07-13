#!/usr/bin/env bash
# The verification gate. Runs fmt and build, then each lab STEP in order,
# stopping at the first step that fails. Each step is checked by its test
# plus (where present) an acceptance run of the built binary over
# cases-stepN.txt. The gate passes only when every step is green.
set -uo pipefail
cd "$(dirname "$0")"

echo "== fmt (cargo fmt --check) =="
if ! cargo fmt --check; then
  echo "CHECK FAILED (fmt)"
  exit 1
fi

echo "== build (release) =="
if ! cargo build --release; then
  echo "CHECK FAILED (build)"
  exit 1
fi
bin="./target/release/calc"

run_cases() {
  local f="$1" fail=0 got
  [ -f "$f" ] || return 0
  while IFS='|' read -r expr expected; do
    [ -z "${expr// }" ] && continue
    got=$("$bin" "$expr")
    if [ "$got" != "$expected" ]; then
      echo "    FAIL: '$expr' => got '$got', want '$expected'"
      fail=1
    fi
  done < "$f"
  return $fail
}

# num | title | test name | cases file (optional)
steps=(
  "1|Core arithmetic (+ - * /, parens, unary minus, decimals)|step1_core|cases-step1.txt"
  "2|Modulo operator %|step2_modulo|cases-step2.txt"
  "3|Power operator ^ (right-associative, binds tighter than * /)|step3_power|cases-step3.txt"
  "4|Built-in functions: sqrt abs min max pow|step4_functions|cases-step4.txt"
  "5|Error messages carry the column of the bad character|step5_error_positions|"
)

for entry in "${steps[@]}"; do
  IFS='|' read -r num title testname casefile <<< "$entry"
  echo "== STEP $num/5: $title =="
  if ! cargo test --release --test eval "$testname" -- --exact >/dev/null 2>&1; then
    cargo test --release --test eval "$testname" -- --exact 2>&1 | sed 's/^/    /'
    echo "CHECK FAILED (step $num)"
    exit 1
  fi
  if [ -n "$casefile" ]; then
    if ! run_cases "$casefile"; then
      echo "CHECK FAILED (step $num)"
      exit 1
    fi
  fi
  echo "  STEP $num PASSED"
done

echo "CHECK PASSED"
exit 0
