#!/usr/bin/env bash

install() {
  require_trait "client" "Skipping Fonts install — host is not client" || return 0

  print_header "Nerd Fonts"

  if isMac; then
    brew install -q --cask font-hack-nerd-font font-fira-code-nerd-font font-symbols-only-nerd-font font-jetbrains-mono font-victor-mono-nerd-font || true
  elif isArch; then
    sudo pacman -S --noconfirm --quiet ttf-victor-mono-nerd || true
    fc-cache -fv >/dev/null 2>&1 || true
  elif isLinux; then
    wget -q -P "$HOME/.local/share/fonts" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip || true
    (cd "$HOME/.local/share/fonts" && unzip -qq -o JetBrainsMono.zip && rm -f JetBrainsMono.zip) || true
    fc-cache -fv >/dev/null 2>&1 || true
  fi
}

# No actions on source — setup.sh calls install()
