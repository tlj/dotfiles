#!/usr/bin/env bash

install() {
  require_trait "mac" "Skipping Homebrew install — host is not mac" || return 0

  print_header "Homebrew"

  if isMac; then
    local brew_cmd
    brew_cmd=$(command -v brew)
    if [[ -z $brew_cmd ]]; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/opt/homebrew/bin/brew shellenv)"
      PATH="/opt/homebrew/bin:$PATH"
    else
      echo "Homebrew already installed - upgrading."
      brew update
      brew upgrade
      brew cleanup
    fi
  fi
}

# No actions run on source — setup.sh calls install()
