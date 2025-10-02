#!/usr/bin/env bash

install() {
  print_header "Yazi"

  ubi -v -i "$HOME/.local/bin" -p sxyazi/yazi || true
}

# No actions on source — setup.sh calls install()
