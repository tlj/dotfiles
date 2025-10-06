#!/usr/bin/env bash
# Helper to install packages depending on detected OS

# shellcheck disable=SC1090
source "$(dirname "${BASH_SOURCE[0]}")/detect_os.sh"

install_packages() {
  # The module should set variables like APT_PACKAGES, PACMAN_PACKAGES, YAY_PACKAGES,
  # BREW_PACKAGES and UBI_PACKAGES in its scope before calling this function.

  local apt_pkgs="${APT_PACKAGES:-}"
  local pacman_pkgs="${PACMAN_PACKAGES:-}"
  local yay_pkgs="${YAY_PACKAGES:-}"
  local brew_pkgs="${BREW_PACKAGES:-}"
  local brew_cask_pkgs="${BREW_CASK_PACKAGES:-}"
  local ubi_pkgs="${UBI_PACKAGES:-}"

  # APT (Debian/Ubuntu)
  if [[ -n "$apt_pkgs" ]] && command -v apt-get >/dev/null 2>&1; then
    echo " - Installing APT packages: $apt_pkgs"
    sudo apt-get update -y
    sudo apt-get install -y $apt_pkgs
  fi

  # Arch: pacman
  if [[ -n "$pacman_pkgs" ]] && command -v pacman >/dev/null 2>&1; then
    echo " - Installing pacman packages: $pacman_pkgs"
    sudo pacman -S --noconfirm --quiet --needed $pacman_pkgs
  fi

  # Arch AUR: yay (user-managed)
  if [[ -n "$yay_pkgs" ]]; then
    if command -v yay >/dev/null 2>&1; then
      echo " - Installing AUR packages with yay: $yay_pkgs"
      yay -S --noconfirm --quiet --needed $yay_pkgs
    else
      echo " - yay not found; skipping AUR packages: $yay_pkgs"
    fi
  fi

  # Brew (macOS)
  if [[ -n "$brew_pkgs" ]] && command -v brew >/dev/null 2>&1; then
    echo " - Installing brew packages: $brew_pkgs"
    brew install $brew_pkgs
  fi

  # Brew casks (macOS)
  if [[ -n "$brew_cask_pkgs" ]] && command -v brew >/dev/null 2>&1; then
    echo " - Installing brew cask packages: $brew_cask_pkgs"
    for pkg in $brew_pkgs; do
      brew install --cask $pkg
    done
  fi

  # UBI-packages (packageless installers)
  if [[ -n "$ubi_pkgs" ]]; then
    if command -v ubi >/dev/null 2>&1; then
      local p
      for p in $ubi_pkgs; do
        echo " - Installing ubi package: $p"
        ubi -i "$HOME/.local/bin" -p "$p"
      done
    else
      echo " - ubi not found; try installing ubi first. Skipping: $ubi_pkgs"
    fi
  fi
}
