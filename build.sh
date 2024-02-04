#!/bin/bash
# Copyright (c) Meta Platforms, Inc. and affiliates.
#
# This source code is licensed under both the MIT license found in the
# LICENSE-MIT file in the root directory of this source tree and the Apache
# License, Version 2.0 found in the LICENSE-APACHE file in the root directory
# of this source tree.

set -euo pipefail

THIS_DIR=$(cd -P -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)

SCRATCH_DIR=$(mktemp -d)
trap 'rm -rf "$SCRATCH_DIR"' EXIT

###

: "${ZIG_BIN:=zig}"
: "${OUT_DIR:=$THIS_DIR/dist}"

# https://reproducible-builds.org/docs/archives/
_deterministic_tar() {
  gtar \
    --sort=name \
    --mtime=2030-01-01T00:00:00Z \
    --owner=0 --group=0 --numeric-owner \
    -cf- \
    "$@"
}

deterministic_tar_gz() {
  _deterministic_tar "${@:2}" | gzip -9n > "$1"
}

deterministic_tar_zst() {
  _deterministic_tar "${@:2}" | zstd -19 > "$1"
}

zig_build_exe() {
  local target=$1
  local source=$2
  local out=$3

  local emit_bin
  emit_bin=$SCRATCH_DIR/$(basename "$out")

  (set -x
    "$ZIG_BIN" build-exe \
      "$source" \
      -femit-bin="$emit_bin" \
      -target "$target" \
      -OReleaseSmall \
      -fsingle-threaded
  )

  # Zig does not yet have an option to set deterministic PE/COFF timestamps.
  # Manually set it to "Sun Jan 01 2023 05:00:00 GMT+0000"
  # https://github.com/ziglang/zig/issues/9432
  # https://github.com/ziglang/zig/issues/14924
  # https://0xc0decafe.com/malware-analyst-guide-to-pe-timestamps
  if [[ $target == *-windows-gnu ]]; then
    (set -x
      printf '\x50\x13\xB1\x63' \
        | dd "of=$emit_bin" bs=1 seek=128 count=4 conv=notrunc status=none
    )
  fi

  mv "$emit_bin" "$out"
}

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

(
  cd "$OUT_DIR"

  for name in \
    exit_code \
    print_args \
    print_argv \
    stdin_to_stderr \
    stdin_to_stdout \
  ; do
    src_file=$THIS_DIR/$name.zig
    zig_build_exe   aarch64-linux-gnu "$src_file" "$name.linux.aarch64"
    zig_build_exe    x86_64-linux-gnu "$src_file" "$name.linux.x86_64"
    zig_build_exe  aarch64-macos-none "$src_file" "$name.macos.aarch64"
    zig_build_exe   x86_64-macos-none "$src_file" "$name.macos.x86_64"
    zig_build_exe aarch64-windows-gnu "$src_file" "$name.windows.aarch64.exe"
    zig_build_exe  x86_64-windows-gnu "$src_file" "$name.windows.x86_64.exe"
  done
)

deterministic_tar_gz "$SCRATCH_DIR/pack.tar.gz" -C "$OUT_DIR" .
deterministic_tar_zst "$SCRATCH_DIR/pack.tar.zst" -C "$OUT_DIR" .

mv "$SCRATCH_DIR/pack.tar.gz" "$OUT_DIR"
mv "$SCRATCH_DIR/pack.tar.zst" "$OUT_DIR"
