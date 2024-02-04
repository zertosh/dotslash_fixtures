// Copyright (c) Meta Platforms, Inc. and affiliates.
//
// This source code is licensed under both the MIT license found in the
// LICENSE-MIT file in the root directory of this source tree and the Apache
// License, Version 2.0 found in the LICENSE-APACHE file in the root directory
// of this source tree.

const std = @import("std");

pub fn main() !void {
    var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa = general_purpose_allocator.allocator();

    var args_iterator = try std.process.ArgIterator.initWithAllocator(gpa);
    defer args_iterator.deinit();

    // Skip arg0.
    _ = args_iterator.next();

    const arg1 = args_iterator.next() orelse
        std.debug.panic("first argument is missing.\n", .{});

    const exit_code = std.fmt.parseInt(u8, arg1, 10) catch
        std.debug.panic("first argument is not a number.\n", .{});

    std.os.exit(exit_code);
}
