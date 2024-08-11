#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/install_github_release.sh

echo "Installing fzf binary..."
install_github_release junegunn/fzf fzf-:VERSION_NUM:-${PLATFORM}_${ARCH}.tar.gz

echo "Installing fzf from git to get bin/ scripts..."
install_with_git ~/.fzf https://github.com/junegunn/fzf.git

