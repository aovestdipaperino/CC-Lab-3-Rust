# CC-Lab-3-Rust — `calc`

Lab 3 (Rust): implement a complex feature and let a verification-gated loop confirm it.

`calc` is a command-line arithmetic evaluator. Its core, `eval`, ships as a stub
that only understands a single number. Your job is to grow it into a full
expression evaluator (operator precedence, parentheses, unary minus, decimals).

## Steps

1. **Enable the Stop hook** so Claude keeps working until the gate is green:
   ```sh
   cp .claude/settings.json.disabled .claude/settings.json      # macOS / Linux
   cp .claude/settings.windows.json.disabled .claude/settings.json   # Windows
   ```
   Run `/hooks` to confirm it registered.

2. **Ask Claude:** "make check.sh pass" (`check.ps1` on Windows). Then watch the
   loop iterate: each time Claude tries to stop, the hook re-runs the gate and
   feeds any failures back until everything is green.

3. **Read the diff.** Did it implement a real evaluator, or take a shortcut?

## The gate

`./check.sh` (or `.\check.ps1`) runs fmt → build → tests → an acceptance test
that runs the built binary over `cases.txt`. Prints `CHECK PASSED` /
`CHECK FAILED` and exits with the matching status.

## Reset

`./reset.sh` (or `.\reset.ps1`) restores the repo to its starting state.

## Requirements

- Rust (stable) with `cargo` and `rustfmt`
