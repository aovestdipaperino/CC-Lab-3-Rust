# CC-Lab-3-Rust — `calc`

Lab 3 (Rust): implement a feature in stages and let a verification-gated loop
confirm each one.

`calc` is a command-line arithmetic evaluator. Its core, `eval`, ships as a stub
that only understands a single number. You grow it over **five steps**, each
harder than the last:

1. Core arithmetic (`+ - * /`, parentheses, unary minus, decimals)
2. Modulo (`%`)
3. Power (`^`, right-associative)
4. Functions (`sqrt`, `abs`, `min`, `max`, `pow`)
5. Error messages that report the column of a bad character

## Steps

1. **Set the goal gate** so Claude keeps working until the gate is green — nothing to
   pre-configure, just type in Claude Code:
   ```
   /goal the check script (check.sh or check.ps1) exits 0 with no failures, or stop after 15 turns
   ```
   Run a bare `/goal` to confirm it's active (`/goal clear` removes it).

2. **Ask Claude:** "make check.sh pass" (`check.ps1` on Windows). Watch the loop:
   the gate runs the steps in order and stops at the first failure, so Claude
   works its way up one step at a time.

3. **Read the diff** as it goes. Did it implement each step for real?

Getting through every step is not required — the later steps are there so a fast
run doesn't finish with time to spare.

## The gate

`./check.sh` (or `.\check.ps1`) runs `cargo fmt --check` → `cargo build` →
step 1 → … → step 5. Each step is its test plus an acceptance run of the built
binary over `cases-stepN.txt`. Prints `CHECK PASSED` / `CHECK FAILED (step N)`
and exits with the matching status.

## Reset

`./reset.sh` (or `.\reset.ps1`) restores the repo to its starting state.

## Requirements

- Rust (stable) with `cargo` and `rustfmt`
