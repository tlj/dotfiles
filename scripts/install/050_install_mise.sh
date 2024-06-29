#!/usr/bin/env bash

. scripts/lib/detect_os.sh

if isMac; then
  PLATFORM=macos
else
  PLATFORM=linux
fi

echo "Installing mise for ${PLATFORM} ${ARCH}..."
curl -o ~/.local/bin/mise https://mise.jdx.dev/mise-latest-${PLATFORM}-${ARCH}

eval "$(mise activate bash)"

stow --target=$HOME --restow mise/

mise install

