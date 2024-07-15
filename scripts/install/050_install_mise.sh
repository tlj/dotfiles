#!/usr/bin/env bash

. scripts/lib/detect_os.sh

if isMac; then
  MISE_PLATFORM=macos
else
  MISE_PLATFORM=linux
fi

echo "Installing mise for ${MISE_PLATFORM} ${ARCH}..."
curl -so ~/.local/bin/mise https://mise.jdx.dev/mise-latest-${MISE_PLATFORM}-${ARCH}
chmod a+rx ~/.local/bin/mise

eval "$(mise activate bash)"

stow --target=$HOME --restow mise/

mise install

