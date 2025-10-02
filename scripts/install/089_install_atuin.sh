#!/usr/bin/env bash

install() {
  require_trait "client" "Skipping Atuin install — host is not client" || return 0

  print_header "Atuin"

  if isMac; then
    brew install -q atuin || true
  else
    cargo install atuin || true
  fi

  stow --target="$HOME" --adopt --dotfiles -v --restow atuin/ || true
}

# No actions on source — setup.sh calls install()
