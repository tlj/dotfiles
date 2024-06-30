#!/usr/bin/env bash

. scripts/lib/detect_os.sh

if isMac; then
  PLATFORM=macos
else
  PLATFORM=linux
fi

echo "Installing mise for ${PLATFORM} ${ARCH}..."
if [[ "$ARCH" == "aarch64" ]]; then
  curl -so ~/.local/bin/mise https://mise.jdx.dev/mise-latest-${PLATFORM}-arm64
else
  curl -so ~/.local/bin/mise https://mise.jdx.dev/mise-latest-${PLATFORM}-${ARCH}
fi
chmod a+rx ~/.local/bin/mise

eval "$(mise activate bash)"

stow --target=$HOME --restow mise/

mise install

