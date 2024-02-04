/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under both the MIT license found in the
 * LICENSE-MIT file in the root directory of this source tree and the Apache
 * License, Version 2.0 found in the LICENSE-APACHE file in the root directory
 * of this source tree.
 */

//! Print current executable and all args to stdout.

fn main() {
    let current_exe = std::env::current_exe().expect("current_exe");
    println!("exe: {}", current_exe.display());
    for (idx, arg) in std::env::args_os().enumerate() {
        println!("{}: {}", idx, arg.to_string_lossy());
    }
}
