#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh

echo "Installing fzf from git..."
install_with_git ~/.fzf https://github.com/junegunn/fzf.git


