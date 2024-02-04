/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under both the MIT license found in the
 * LICENSE-MIT file in the root directory of this source tree and the Apache
 * License, Version 2.0 found in the LICENSE-APACHE file in the root directory
 * of this source tree.
 */

//! Exit the program with an exit code passed as the first argument.

fn main() {
    let exit_code = std::env::args_os()
        .nth(1)
        .expect("first argument is missing")
        .into_string()
        .expect("first argument is not UTF-8")
        .parse::<i32>()
        .expect("first argument is not a number");
    std::process::exit(exit_code);
}
