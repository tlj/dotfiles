#!/usr/bin/env bash

install() {
  require_trait "client" "Skipping git install — host is not client" || return 0

  print_header "Git and LazyGit"

  if isMac; then
    brew install -q git gh
    brew install -q --cask git-credential-manager

    echo "Installing commitizen-go"
    brew tap lintingzhen/tap
    brew install -q commitizen-go
    commitizen-go install || true

  elif isArch; then
    echo "Not installing anything for arch..."
    sudo pacman -S --noconfirm --quiet git-delta || true

  elif isLinux; then
    echo "Installing git and gh..."
    sudo mkdir -p -m 755 /etc/apt/keyrings
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt-get -qq update -y
    sudo apt-get -qq install -y git gh || true
  fi

  ubi -v -i "$HOME/.local/bin" -p lintingzhen/commitizen-go || true
  ubi -v -i "$HOME/.local/bin" -p jesseduffield/lazygit || true
  ubi -v -i "$HOME/.local/bin" -p mislav/hub || true

  echo "Installing gh cli extensions..."
  if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "  * GITHUB_TOKEN is not set. Set it and rerun if github extensions are needed."
  else
    gh extension install dlvhdr/gh-dash || true
    gh extension install meiji163/gh-notify || true
  fi

  stow --target="$HOME" --dotfiles -v --restow lazygit/ || true
}

# No actions on source — setup.sh calls install()
