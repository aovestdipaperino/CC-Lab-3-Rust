//! Command `calc` evaluates an arithmetic expression given as its argument.
//!
//! ```text
//! calc "2 + 3 * 4"   ->   14
//! ```

use std::process::exit;

fn main() {
    let args: Vec<String> = std::env::args().skip(1).collect();
    if args.is_empty() {
        eprintln!("usage: calc \"<expression>\"");
        exit(2);
    }
    let expr = args.join(" ");
    match calc::eval(&expr) {
        Ok(v) => println!("{}", v),
        Err(e) => {
            eprintln!("error: {}", e);
            exit(1);
        }
    }
}
