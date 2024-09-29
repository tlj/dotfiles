#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/install_github_release.sh

YAZI_PLATFORM="unknown-linux-musl"
if isMac; then
  YAZI_PLATFORM="apple-darwin"
fi

YAZI_ARCH="x86_64"
if isArm64; then
  YAZI_ARCH="aarch64"
fi

echo "Installing yazi binary..."
install_github_release sxyazi/yazi yazi-${YAZI_ARCH}-${YAZI_PLATFORM}.zip
mv ~/.local/bin/yazi-${YAZI_ARCH}-${YAZI_PLATFORM}/ya* ~/.local/bin/


