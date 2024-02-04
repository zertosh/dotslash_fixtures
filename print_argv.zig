// Copyright (c) Meta Platforms, Inc. and affiliates.
//
// This source code is licensed under both the MIT license found in the
// LICENSE-MIT file in the root directory of this source tree and the Apache
// License, Version 2.0 found in the LICENSE-APACHE file in the root directory
// of this source tree.

const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa = general_purpose_allocator.allocator();

    const self_exe = try std.fs.selfExePathAlloc(gpa);
    try stdout.print("exe: {s}\n", .{self_exe});

    const args = try std.process.argsAlloc(gpa);
    defer std.process.argsFree(gpa, args);
    for (args, 0..) |arg, i| {
        try stdout.print("{}: {s}\n", .{ i, arg });
    }
}
