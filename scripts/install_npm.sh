#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_github_release.sh

echo "Installing nodejs..."
mise install -qy node

stow --target=$HOME --restow lazygit/
