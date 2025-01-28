#!/bin/bash

set -e

# Define flags with default values
DEBUG=0
VERBOSE=0

# Parse command line arguments
while getopts "dv" opt; do
  case $opt in
  d) DEBUG=1 ;;
  v) VERBOSE=1 ;;
  *)
    echo "Usage: $0 [-d] [-v] [script_filter]" >&2
    exit 1
    ;;
  esac
done

# Shift the options so $1 becomes the first non-option argument
shift $((OPTIND - 1))

# Print Dotfiles Logo
echo "CgogXyAuLScpIF8gICAgICAgICAgICAgICAgLi0nKSBfICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICgnLS4gICAgLi0nKSAgICAKKCAoICBPTykgKSAgICAgICAgICAgICAgKCAgT08pICkgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXyggIE9PKSAgKCBPTyApLiAgCiBcICAgICAuJ18gIC4tJyksLS0tLS0uIC8gICAgICcuXyAgICAsLS0tLS0tLiwtLi0nKSAgLC0tLiAgICAgKCwtLS0tLS0uKF8pLS0tXF8pIAogLGAnLS0uLi5fKSggT08nICAuLS4gICd8Jy0tLi4uX18pKCctfCBfLi0tLSd8ICB8T08pIHwgIHwuLScpICB8ICAuLS0tJy8gICAgXyB8ICAKIHwgIHwgIFwgICcvICAgfCAgfCB8ICB8Jy0tLiAgLi0tJyhPT3woX1wgICAgfCAgfCAgXCB8ICB8IE9PICkgfCAgfCAgICBcICA6YCBgLiAgCiB8ICB8ICAgJyB8XF8pIHwgIHxcfCAgfCAgIHwgIHwgICAvICB8ICAnLS0uIHwgIHwoXy8gfCAgfGAtJyB8KHwgICctLS4gICcuLmAnJy4pIAogfCAgfCAgIC8gOiAgXCB8ICB8IHwgIHwgICB8ICB8ICAgXF8pfCAgLi0tJyx8ICB8Xy4nKHwgICctLS0uJyB8ICAuLS0nIC4tLl8pICAgXCAKIHwgICctLScgIC8gICBgJyAgJy0nICAnICAgfCAgfCAgICAgXHwgIHxfKShffCAgfCAgICB8ICAgICAgfCAgfCAgYC0tLS5cICAgICAgIC8gCiBgLS0tLS0tLScgICAgICBgLS0tLS0nICAgIGAtLScgICAgICBgLS0nICAgIGAtLScgICAgYC0tLS0tLScgIGAtLS0tLS0nIGAtLS0tLScgIAoKCg==" | base64 -d | printf "\033[34m%s\033[0m" "$(cat -)"

echo ""

. scripts/lib/detect_os.sh

echo "Installing dotfiles for ${PLATFORM} ${ARCH}..."

# Example of using the flags
[[ $DEBUG -eq 1 ]] && echo "Debug mode enabled"
[[ $VERBOSE -eq 1 ]] && echo "Verbose mode enabled"

if ! isMac; then
  # Ensure computer doesn't go to sleep or lock while installing
  gsettings set org.gnome.desktop.screensaver lock-enabled false
  gsettings set org.gnome.desktop.session idle-delay 0
fi

mkdir -p ~/.local/bin
mkdir -p ~/src

echo "Installing nvim config..." 
NVIM_CONFIG_LOCATION="$XDG_CONFIG_HOME/nvim"
if ! cd "$NVIM_CONFIG_LOCATION" &> /dev/null; then
  git clone -b master https://github.com/tlj/nvim.git "$NVIM_CONFIG_LOCATION" > /dev/null
fi

PATH=$HOME/.local/bin:$PATH

if [ $# -eq 0 ]; then
  # No arguments provided, run all scripts
  for script in scripts/install/*.sh; do
    [[ $DEBUG -eq 1 ]] && echo "Sourcing: $script"
    source "$script"
  done
else
  # Filter script by argument
  for script in scripts/install/*${1}*.sh; do
    if [ -f "$script" ]; then
      [[ $DEBUG -eq 1 ]] && echo "Sourcing: $script"
      source "$script"
    else
      echo "No installation script found matching: ${1}"
      exit 1
    fi
  done
fi

if ! isMac; then
  # Revert to normal idle and lock settings
  gsettings set org.gnome.desktop.screensaver lock-enabled true
  gsettings set org.gnome.desktop.session idle-delay 300
fi
