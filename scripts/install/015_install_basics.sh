#!/usr/bin/env bash

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh

print_header "Basic tools and libraries"

if isMac; then
  brew install -q stow btop bat sqlite cmake fortune cowsay
elif isArch; then
  sudo pacman -Syu --noconfirm --quiet

  sudo pacman -S --noconfirm --quiet curl stow fuse3 bat sqlite3 cmake ca-certificates lsd btop interception-caps2esc

  cat << EOF | sudo tee /etc/udevmon.yaml
- JOB: "intercept -g \$DEVNODE | caps2esc -m 1 | uinput -d \$DEVNODE"
  DEVICE:
    EVENTS:
      EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
EOF
  cat << EOF | sudo tee /etc/systemd/system/udevmon.service
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
else
  sudo apt-get -qq update -y -q

  echo "Installing basics..."
  sudo apt-get -qq install -y -q curl stow fuse3 bat sqlite3 cmake ca-certificates fortune cowsay
  sudo install -m 0755 -d /etc/apt/keyrings

  echo "Installing btop..."
  ubi -v -i ~/.local/bin -p aristocratos/btop

  ln -sfn /usr/bin/batcat ~/.local/bin/bat

  echo "Install LSD..."
  curl -sLo /tmp/lsd.deb https://github.com/Peltoche/lsd/releases/download/v1.1.2/lsd-musl_1.1.2_${ARCH}.deb

  sudo dpkg -i /tmp/lsd.deb
fi

echo "Building bat cache..."
bat cache --build > /dev/null

stow --target=$HOME --dotfiles -v --restow btop/ bat/ lsd/
