#!/usr/bin/env bash

install() {
  require_all_traits "client arch" "Skipping Zen Browser install — host is not arch client" || return 0

  sudo pacman -Syu --noconfirm --quiet zen-browser-bin
}


# No actions on source — setup.sh calls install()
