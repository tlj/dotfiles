#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/install_github_release.sh

LOWPLATFORM=$(echo $PLATFORM | tr '[:upper:]' '[:lower:]')

echo "Installing fzf binary..."
install_github_release junegunn/fzf fzf-:VERSION_NUM:-${LOWPLATFORM}_${ARCH}.zip

echo "Installing fzf from git to get bin/ scripts..."
install_with_git ~/.fzf https://github.com/junegunn/fzf.git

