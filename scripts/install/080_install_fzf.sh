#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/install_github_release.sh
. scripts/lib/print_utils.sh

print_header "Fzf"

install_github_release junegunn/fzf fzf-:VERSION_NUM:-${PLATFORM}_${ARCH}.tar.gz

[[ $VERBOSE -eq 1 ]] && echo "Installing fzf from git to get bin/ scripts..."
install_with_git ~/.fzf https://github.com/junegunn/fzf.git

