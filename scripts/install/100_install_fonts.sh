#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "Nerd Fonts"

if isMac; then
  brew install -q --cask font-hack-nerd-font font-fira-code-nerd-font font-symbols-only-nerd-font font-jetbrains-mono font-victor-mono-nerd-font
elif isArch; then
  sudo pacman -S --noconfirm --quiet ttf-victor-mono-nerd
  fc-cache -fv > /dev/null
else
  wget -q -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip \
    && cd ~/.local/share/fonts \
    && unzip -qq -o JetBrainsMono.zip \
    && rm JetBrainsMono.zip \
    && fc-cache -fv > /dev/null \
    && cd -
fi
