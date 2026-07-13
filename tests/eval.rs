use calc::eval;

/// The spec: these expressions must evaluate to these values.
#[test]
fn evaluates_expressions() {
    let cases = [
        ("42", 42.0),
        ("2 + 3 * 4", 14.0),
        ("(2 + 3) * 4", 20.0),
        ("10 / 4", 2.5),
        ("2 * -4", -8.0),
        ("-3 + 5", 2.0),
        ("1 + 2 + 3 + 4", 10.0),
        ("2 * (3 + 4) - 1", 13.0),
        ("100 / 5 / 2", 10.0),
        ("3.5 * 2", 7.0),
        ("-(2 + 3)", -5.0),
        ("((1))", 1.0),
    ];
    for (expr, want) in cases {
        match eval(expr) {
            Ok(got) => assert!(
                (got - want).abs() < 1e-9,
                "eval({:?}) = {}, want {}",
                expr,
                got,
                want
            ),
            Err(e) => panic!("eval({:?}) returned error: {}", expr, e),
        }
    }
}

/// Malformed input must be rejected, not silently accepted.
#[test]
fn rejects_malformed() {
    for expr in ["", "1 +", "(1 + 2", "2 * * 3", "abc"] {
        assert!(eval(expr).is_err(), "eval({:?}) should have errored", expr);
    }
}
