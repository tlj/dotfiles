#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/install_with_git.sh
. scripts/lib/install_github_release.sh
. scripts/lib/print_utils.sh

print_header "Nerd Fonts"

if isMac; then
  brew install -q --cask font-hack-nerd-font font-fira-code-nerd-font font-symbols-only-nerd-font font-jetbrains-mono
else
  wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip \
    && cd ~/.local/share/fonts \
    && unzip -o JetBrainsMono.zip \
    && rm JetBrainsMono.zip \
    && fc-cache -fv > /dev/null \
    && cd -
fi
