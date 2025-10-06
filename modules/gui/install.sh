APT_PACKAGES="1password libnotify-bin"
PACMAN_PACKAGES="niri waybar waylock swayidle mako ghostty zen-browser-bin obsidian libnotify"
YAY_PACKAGES="1password 1password-cli localsend-bin plymouth-theme-sweet-arch-git light"
BREW_PACKAGES="font-victor-mono-nerd-font obsidian"
BREW_CASK_PACKAGES="ghostty 1password-cli localsend"
SNAP_PACKAGES="localsend ghostty"
UBI_PACKAGES=""

if isLinux && ! isArch; then
  echo "WARNING: not installing Ghostty on apt based platforms due to missing packaging."
  echo "WARNING: not installing Niri, etc, due to... arch is better?"
  echo "WARNING: not installing Zen Browser on apt based platforms due to missing packaging."
fi

if isMac; then
  echo "WARNING: not installing Obsidian on brew based platforms due to missing packaging."
fi

if isLinux; then
  echo " - Installing fonts..."
  wget -q -P "$HOME/.local/share/fonts" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/VictorMono.zip
  (cd "$HOME/.local/share/fonts" && unzip -qq -o VictorMono.zip && rm -f VictorMono.zip)
  fc-cache -fv >/dev/null 2>&1
fi

if command -v apt >/dev/null 2>&1 && [ ! -f /etc/apt/sources.list.d/1password.list ]; then
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
  sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
	curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
	sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
	curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

  sudo apt update
fi

echo " - Install tickrs..."
cargo install -q tickrs --locked

if isArch && [ ! -d /usr/share/sddm/themes/tlj ]; then
  sudo mkdir -p /etc/sddm.conf.d /usr/share/sddm/themes/tlj
  sudo cp -r "$TOP_DIR/modules/gui/files/sddm-theme/*" /usr/share/sddm/themes/tlj
  cat <<EOF | safe_write_root /etc/sddm.conf.d/90-tlj.conf
[Theme]
Current=tlj
EOF
fi

if isArch && [ ! -d /usr/share/plymouth/themes/sweet-arch ]; then
  yay -S plymouth-theme-sweet-arch-git
  sudo plymouth-set-default-theme -R sweet-arch
fi

install_packages

stow_package "gui"
