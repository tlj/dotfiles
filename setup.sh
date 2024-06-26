#!/bin/bash

set -e

# Print Dotfiles Logo
echo "CgogXyAuLScpIF8gICAgICAgICAgICAgICAgLi0nKSBfICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICgnLS4gICAgLi0nKSAgICAKKCAoICBPTykgKSAgICAgICAgICAgICAgKCAgT08pICkgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXyggIE9PKSAgKCBPTyApLiAgCiBcICAgICAuJ18gIC4tJyksLS0tLS0uIC8gICAgICcuXyAgICAsLS0tLS0tLiwtLi0nKSAgLC0tLiAgICAgKCwtLS0tLS0uKF8pLS0tXF8pIAogLGAnLS0uLi5fKSggT08nICAuLS4gICd8Jy0tLi4uX18pKCctfCBfLi0tLSd8ICB8T08pIHwgIHwuLScpICB8ICAuLS0tJy8gICAgXyB8ICAKIHwgIHwgIFwgICcvICAgfCAgfCB8ICB8Jy0tLiAgLi0tJyhPT3woX1wgICAgfCAgfCAgXCB8ICB8IE9PICkgfCAgfCAgICBcICA6YCBgLiAgCiB8ICB8ICAgJyB8XF8pIHwgIHxcfCAgfCAgIHwgIHwgICAvICB8ICAnLS0uIHwgIHwoXy8gfCAgfGAtJyB8KHwgICctLS4gICcuLmAnJy4pIAogfCAgfCAgIC8gOiAgXCB8ICB8IHwgIHwgICB8ICB8ICAgXF8pfCAgLi0tJyx8ICB8Xy4nKHwgICctLS0uJyB8ICAuLS0nIC4tLl8pICAgXCAKIHwgICctLScgIC8gICBgJyAgJy0nICAnICAgfCAgfCAgICAgXHwgIHxfKShffCAgfCAgICB8ICAgICAgfCAgfCAgYC0tLS5cICAgICAgIC8gCiBgLS0tLS0tLScgICAgICBgLS0tLS0nICAgIGAtLScgICAgICBgLS0nICAgIGAtLScgICAgYC0tLS0tLScgIGAtLS0tLS0nIGAtLS0tLScgIAoKCg==" | base64 -d

. scripts/lib/detect_os.sh

echo "Installing dotfiles for ${PLATFORM} ${ARCH}..."

if ! isMac; then
  # Ensure computer doesn't go to sleep or lock while installing
  gsettings set org.gnome.desktop.screensaver lock-enabled false
  gsettings set org.gnome.desktop.session idle-delay 0
fi

mkdir -p ~/.local/bin
mkdir -p ~/src

PATH=$HOME/.local/bin:$PATH

for script in scripts/install/*.sh; do source $script; done

if ! isMac; then
  # Revert to normal idle and lock settings
  gsettings set org.gnome.desktop.screensaver lock-enabled true
  gsettings set org.gnome.desktop.session idle-delay 300
fi
