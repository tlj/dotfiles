#!/usr/bin/env bash

install() {
  print_header "Fzf"

  ubi -v -i "$HOME/.local/bin" -p junegunn/fzf || true

  [[ ${VERBOSE:-0} -eq 1 ]] && echo "Installing fzf from git to get bin/ scripts..."
  install_with_git ~/.fzf https://github.com/junegunn/fzf.git || true
}

# No actions on source — setup.sh calls install()
