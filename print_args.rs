/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under both the MIT license found in the
 * LICENSE-MIT file in the root directory of this source tree and the Apache
 * License, Version 2.0 found in the LICENSE-APACHE file in the root directory
 * of this source tree.
 */

//! Print arg0 to stdout and the rest to stderr.

fn main() {
    let mut it = std::env::args_os().enumerate();
    // arg0 to stdout
    if let Some((idx, arg)) = it.next() {
        println!("{}:{}", idx, arg.to_string_lossy());
    }
    // rest to stderr
    for (idx, arg) in it {
        eprintln!("{}:{}", idx, arg.to_string_lossy());
    }
}
