#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "Homebrew"

if isMac; then
  brew=$(which brew)
  if [[ -z $brew ]]; then
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
