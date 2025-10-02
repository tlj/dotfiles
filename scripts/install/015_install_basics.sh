#!/usr/bin/env bash

install() {
  print_header "Basic tools and libraries"

  mkdir -p "$HOME/.local/bin"

  if isMac; then
    brew install -q stow btop bat sqlite cmake fortune cowsay

  elif isArch; then
    sudo pacman -Syu --noconfirm --quiet

    sudo pacman -S --noconfirm --quiet \
      curl stow fuse3 bat sqlite3 cmake ca-certificates lsd btop interception-caps2esc

    sudo tee /etc/udevmon.yaml >/dev/null <<'EOF'
- JOB: "intercept -g $DEVNODE | caps2esc -m 1 | uinput -d $DEVNODE"
  DEVICE:
    EVENTS:
      EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
EOF

    sudo tee /etc/systemd/system/udevmon.service >/dev/null <<'EOF'
[Unit]
Description=udevmon
Wants=systemd-udev-settle.service
After=systemd-udev-settle.service

[Service]
ExecStart=/usr/bin/nice -n 20 /usr/bin/udevmon -c /etc/udevmon.yaml

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl enable --now udevmon.service

  elif isLinux; then
    sudo apt-get update -qq

    echo "Installing basics..."
    sudo apt-get install -y -qq \
      curl stow fuse3 bat sqlite3 cmake ca-certificates fortune cowsay
    sudo install -m 0755 -d /etc/apt/keyrings

    echo "Installing btop..."
    ubi -v -i "$HOME/.local/bin" -p aristocratos/btop || true

    ln -sfn /usr/bin/batcat "$HOME/.local/bin/bat" || true

    echo "Install LSD..."
    local lsd_deb
    lsd_deb="$(mktemp -u /tmp/lsdXXXXXX).deb"
    curl -fsSL -o "$lsd_deb" "https://github.com/Peltoche/lsd/releases/download/v1.1.2/lsd-musl_1.1.2_${ARCH}.deb" || lsd_deb=""
    if [[ -n "$lsd_deb" && -f "$lsd_deb" ]]; then
      sudo dpkg -i "$lsd_deb" || true
    fi
  fi

  echo "Building bat cache..."
  bat cache --build >/dev/null 2>&1 || true

  stow --target="$HOME" --dotfiles -v --restow btop/ bat/ lsd/ || true
}

# No actions on source — setup.sh calls install()
