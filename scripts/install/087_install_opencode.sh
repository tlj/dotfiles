#!/usr/bin/env bash

install() {
  require_trait "client" "Skipping Opencode install — host is not client" || return 0

  print_header "Opencode"

  echo "Installing OpenCode..."
  ubi -v -i "$HOME/.local/bin" -p sst/opencode || true
  
  echo "Installing pplx (Perplexity cli)..."
  ubi -v -i ~/.local/bin -p sgaunet/pplx

  stow --target="$HOME" --dotfiles -v --restow opencode/ || true
}

# No actions on source — setup.sh calls install()
