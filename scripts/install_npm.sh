#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_github_release.sh

echo "Installing nodejs..."
asdf plugin add nodejs
asdf install nodejs

stow --target=$HOME --restow lazygit/
