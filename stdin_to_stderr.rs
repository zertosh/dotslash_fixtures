/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under both the MIT license found in the
 * LICENSE-MIT file in the root directory of this source tree and the Apache
 * License, Version 2.0 found in the LICENSE-APACHE file in the root directory
 * of this source tree.
 */

//! Read stdin and send it to stderr.

fn main() {
    std::io::copy(&mut std::io::stdin().lock(), &mut std::io::stderr().lock())
        .expect("read stdin and write to stderr");
}
