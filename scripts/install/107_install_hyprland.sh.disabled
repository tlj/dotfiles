#!/usr/bin/env bash

install() {
  require_trait "arch" "Skipping Hyprland install — host is not arch" || return 0

  print_header "Hyprland"

  if isArch; then
    if isOmarchy; then
      echo "Installing Omarchy stuff"

      if has_trait "laptop"; then
        echo "Installing ACPI"
        sudo pacman -S --noconfirm --quiet --needed acpid || true
        sudo systemctl enable --now acpid || true

        sudo stow -v -t /etc etc || true

        cat <<'EOF' | safe_write_root /etc/sudoers.d/check-lid-on-startup || true
ALL ALL=(root) NOPASSWD: /etc/acpi/check-lid-on-startup.sh
EOF
        sudo chmod 0440 /etc/sudoers.d/check-lid-on-startup || true
      fi

      echo "Installing dotfiles"
      stow --target="$HOME" --dotfiles -v --restow --ignore ".*\.bak.*" omarchy/ || true

      hyprctl reload || true

      if ! hyprpm list | grep -q split-monitor-workspaces; then
        echo "Installing split-monitor-workspaces plugin"
        sudo pacman -S --noconfirm --quiet meson cpio || true

        hyprpm update || true
        hyprpm add https://github.com/shezdy/hyprsplit || true
        hyprpm enable hyprsplit || true
      else
        hyprpm update || true
      fi

      hyprpm reload -n || true

      # Configure Hypr config files based on traits (laptop vs desktop)
      local hypr_conf_dir="$HOME/.config/hypr"
      local autostart_file="$hypr_conf_dir/autostart.conf"
      local monitors_file="$hypr_conf_dir/monitors.conf"

      # Determine repo root (two levels up from this script: scripts/install -> repo root)
      local script_dir
      script_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
      local repo_root
      repo_root="$(realpath "$script_dir/../..")"

      local repo_autostart_laptop="$repo_root/omarchy/dot-config/hypr/autostart.laptop.conf"
      local repo_autostart_desktop="$repo_root/omarchy/dot-config/hypr/autostart.desktop.conf"
      local repo_monitors_laptop="$repo_root/omarchy/dot-config/hypr/monitors.laptop.conf"
      local repo_monitors_desktop="$repo_root/omarchy/dot-config/hypr/monitors.desktop.conf"

      safe_mkdir "$hypr_conf_dir"

      # Helper: use safe helpers to link a variant
      _link_variant() {
        local dest="$1"
        local src="$2"
        if [ ! -f "$src" ]; then
          [[ ${DEBUG:-0} -eq 1 ]] && echo "Variant not found: $src"
          return 0
        fi
        # If dest is already a symlink to src, nothing to do
        if [ -L "$dest" ] && [ "$(readlink -f "$dest")" = "$(readlink -f "$src")" ]; then
          return 0
        fi
        # Backup existing dest if it's a regular file
        if [ -f "$dest" ] && [ ! -L "$dest" ]; then
          safe_backup "$dest" || true
        elif [ -L "$dest" ]; then
          safe_rm "$dest" || true
        fi
        safe_symlink "$src" "$dest" || true
      }

      if has_trait "laptop"; then
        # Point autostart.conf and monitors.conf to laptop variants so the repo files remain unchanged
        _link_variant "$autostart_file" "$repo_autostart_laptop"
        _link_variant "$monitors_file" "$repo_monitors_laptop"
      else
        # Desktop: link to desktop variants (or leave existing)
        _link_variant "$autostart_file" "$repo_autostart_desktop"
        _link_variant "$monitors_file" "$repo_monitors_desktop"
      fi
    else
      sudo pacman -S --noconfirm --quiet hyprland waybar wofi || true
      stow --target="$HOME" --dotfiles -v --restow hypr/ waybar/ wofi/ || true
    fi
  fi
}

# No actions on source — setup.sh calls install()
