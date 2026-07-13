//! Lab 3 — the feature to build.
//!
//! Right now [`eval`] is a stub: it parses a single bare number but does not
//! understand operators, parentheses, or unary minus. Your task is to make
//! `eval` a full expression evaluator so that `./check.sh` passes.
//!
//! Target grammar (standard precedence, left-associative):
//!
//! ```text
//! expr    = term   (('+' | '-') term)*
//! term    = factor (('*' | '/') factor)*
//! factor  = '-' factor | primary
//! primary = number | '(' expr ')'
//! ```
//!
//! Numbers may be integers or decimals. Whitespace is insignificant.
//! Malformed input (empty, unbalanced parens, dangling operators, garbage)
//! must return `Err`, not a bogus value.

/// Evaluate an arithmetic expression and return its value.
///
/// TODO(lab3): implement operator precedence, parentheses, and unary minus.
pub fn eval(expr: &str) -> Result<f64, String> {
    let s = expr.trim();
    s.parse::<f64>()
        .map_err(|_| format!("eval: not implemented for {:?}", expr))
}
