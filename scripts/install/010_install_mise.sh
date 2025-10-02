#!/usr/bin/env bash

install() {
  print_header "Mise"

  local mise_platform
  if isMac; then
    mise_platform=macos
  else
    mise_platform=linux
  fi

  local target="$HOME/.local/bin/mise"
  mkdir -p "$(dirname "$target")"

  curl -fsSL -o "$target" "https://mise.jdx.dev/mise-latest-${mise_platform}-${ARCH}"
  chmod a+rx "$target"

  # Activate mise in the current shell using the newly installed binary
  eval "$("$target" activate bash)"

  stow --target="$HOME" --dotfiles -v --restow mise/

  # Call mise (now available in PATH or via $target)
  if command -v mise >/dev/null 2>&1; then
    mise install
  else
    "$target" install
  fi
}

# No actions on source: setup.sh calls install()
