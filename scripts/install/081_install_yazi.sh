#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "Yazi"

YAZI_PLATFORM="unknown-linux-musl"
if isMac; then
  YAZI_PLATFORM="apple-darwin"
fi

YAZI_ARCH="x86_64"
if isArm64; then
  YAZI_ARCH="aarch64"
fi

ubi -v -i ~/.local/bin -p sxyazi/yazi


