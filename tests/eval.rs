use calc::eval;

fn check_table(cases: &[(&str, f64)]) {
    for &(expr, want) in cases {
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

// ---- Step 1: core arithmetic --------------------------------------------

#[test]
fn step1_core() {
    check_table(&[
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
    ]);
    for bad in ["", "1 +", "(1 + 2", "2 * * 3", "abc"] {
        assert!(eval(bad).is_err(), "eval({:?}) should have errored", bad);
    }
}

// ---- Step 2: modulo operator --------------------------------------------

#[test]
fn step2_modulo() {
    check_table(&[
        ("10 % 3", 1.0),
        ("17 % 5", 2.0),
        ("20 % 4", 0.0),
        ("2 + 9 % 4", 3.0), // % binds like * and /
        ("9 % 4 * 3", 3.0),
    ]);
}

// ---- Step 3: power operator (right-associative, binds tighter than * /) --

#[test]
fn step3_power() {
    check_table(&[
        ("2 ^ 10", 1024.0),
        ("2 ^ 3 ^ 2", 512.0), // right associative
        ("2 * 3 ^ 2", 18.0),  // ^ before *
        ("(1 + 1) ^ 8", 256.0),
        ("9 ^ 0.5", 3.0),
    ]);
}

// ---- Step 4: built-in functions -----------------------------------------

#[test]
fn step4_functions() {
    check_table(&[
        ("sqrt(16)", 4.0),
        ("abs(-5)", 5.0),
        ("max(3, 7)", 7.0),
        ("min(4, 2)", 2.0),
        ("pow(2, 10)", 1024.0),
        ("sqrt(2 * 8)", 4.0),
        ("max(1 + 1, 3)", 3.0),
        ("abs(2 - 9)", 7.0),
    ]);
}

// ---- Step 5: error messages carry the column of the offending character --

#[test]
fn step5_error_positions() {
    for (expr, want) in [
        ("2 @ 3", "column 3"),
        ("1 # 2", "column 3"),
        ("12 ~ 5", "column 4"),
    ] {
        match eval(expr) {
            Ok(v) => panic!("eval({:?}) = {}, expected an error", expr, v),
            Err(e) => assert!(
                e.contains(want),
                "eval({:?}) error = {:?}, want it to contain {:?}",
                expr,
                e,
                want
            ),
        }
    }
}
