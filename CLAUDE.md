# calc — Rust

A tiny command-line arithmetic evaluator.

```
calc "2 + 3 * 4"   ->   14
```

## The task

`eval` in `src/lib.rs` is a stub: it parses a single bare number and errors on
everything else. Build it out into a real expression evaluator that supports:

- the four binary operators `+ - * /` with standard precedence
- parentheses
- unary minus (e.g. `-3`, `2 * -4`, `-(2 + 3)`)
- integer and decimal numbers
- whitespace anywhere

Malformed input (empty string, unbalanced parentheses, dangling operators,
non-numeric junk) must return `Err`, not a wrong answer.

## The spec and the gate

The tests in `tests/eval.rs` are the specification. `./check.sh`
(`.\check.ps1` on Windows) is the gate — it runs, in order:

1. `cargo fmt --check`
2. `cargo build --release`
3. `cargo test --release`
4. an acceptance test: the built `calc` binary run over every line in `cases.txt`

The gate passes only when all four stages are green.
