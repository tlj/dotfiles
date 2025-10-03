#!/usr/bin/env bash

set -e

# Define flags with default values
DEBUG=0
VERBOSE=0
DRY_RUN=0

# Parse command line arguments
while getopts "dvn-:" opt; do
  case $opt in
  d) DEBUG=1 ;;
  v) VERBOSE=1 ;;
  n) DRY_RUN=1 ;;
  -)
    case "$OPTARG" in
      dry-run) DRY_RUN=1 ;;
      *) echo "Unknown option --$OPTARG" >&2; exit 1 ;;
    esac ;;
  *)
    echo "Usage: $0 [-d] [-v] [-n|--dry-run] [script_filter]" >&2
    exit 1
    ;;
  esac
done

# Shift the options so $1 becomes the first non-option argument
shift $((OPTIND - 1))

# Export DRY_RUN so sourced scripts can see it
export DRY_RUN

. scripts/lib/dry_run.sh

. scripts/lib/safe_helpers.sh

# Print Dotfiles Logo
echo "CgogXyAuLScpIF8gICAgICAgICAgICAgICAgLi0nKSBfICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICgnLS4gICAgLi0nKSAgICAKKCAoICBPTykgKSAgICAgICAgICAgICAgKCAgT08pICkgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXyggIE9PKSAgKCBPTyApLiAgCiBcICAgICAuJ18gIC4tJyksLS0tLS0uIC8gICAgICcuXyAgICAsLS0tLS0tLiwtLi0nKSAgLC0tLiAgICAgKCwtLS0tLS0uKF8pLS0tXF8pIAogLGAnLS0uLi5fKSggT08nICAuLS4gICd8Jy0tLi4uX18pKCctfCBfLi0tLSd8ICB8T08pIHwgIHwuLScpICB8ICAuLS0tJy8gICAgXyB8ICAKIHwgIHwgIFwgICcvICAgfCAgfCB8ICB8Jy0tLiAgLi0tJyhPT3woX1wgICAgfCAgfCAgXCB8ICB8IE9PICkgfCAgfCAgICBcICA6YCBgLiAgCiB8ICB8ICAgJyB8XF8pIHwgIHxcfCAgfCAgIHwgIHwgICAvICB8ICAnLS0uIHwgIHwoXy8gfCAgfGAtJyB8KHwgICctLS4gICcuLmAnJy4pIAogfCAgfCAgIC8gOiAgXCB8ICB8IHwgIHwgICB8ICB8ICAgXF8pfCAgLi0tJyx8ICB8Xy4nKHwgICctLS0uJyB8ICAuLS0nIC4tLl8pICAgXCAKIHwgICctLScgIC8gICBgJyAgJy0nICAnICAgfCAgfCAgICAgXHwgIHxfKShffCAgfCAgICB8ICAgICAgfCAgfCAgYC0tLS5cICAgICAgIC8gCiBgLS0tLS0tLScgICAgICBgLS0tLS0nICAgIGAtLScgICAgICBgLS0nICAgIGAtLScgICAgYC0tLS0tLScgIGAtLS0tLS0nIGAtLS0tLScgIAoKCg==" | base64 -d | printf "\033[34m%s\033[0m" "$(cat -)"

echo ""

. scripts/lib/detect_os.sh
. scripts/lib/print_utils.sh
. scripts/lib/traits.sh
. scripts/lib/install_with_git.sh

echo "Installing dotfiles for ${PLATFORM} ${ARCH}..."

# Example of using the flags
[[ $DEBUG -eq 1 ]] && echo "Debug mode enabled"
[[ $VERBOSE -eq 1 ]] && echo "Verbose mode enabled"

if ! isMac && ! isArch; then
  # Ensure computer doesn't go to sleep or lock while installing
  gsettings set org.gnome.desktop.screensaver lock-enabled false
  gsettings set org.gnome.desktop.session idle-delay 0
fi

mkdir -p ~/.local/bin
mkdir -p ~/src

if has_trait "client"; then
  echo "Installing nvim config..." 
  NVIM_CONFIG_LOCATION="$XDG_CONFIG_HOME/nvim"
  if [[ ! -d "$NVIM_CONFIG_LOCATION" ]]; then
    git clone -b master https://github.com/tlj/nvim.git "$NVIM_CONFIG_LOCATION" > /dev/null
  fi
else
  echo "Skipping nvim install - host is not client"
fi

PATH=$HOME/.local/bin:$PATH

run_install_script() {
  local script="$1"
  [[ $DEBUG -eq 1 ]] && echo "Loading: $script"
  # shellcheck disable=SC1090
  source "$script"
  if declare -f install >/dev/null 2>&1; then
    [[ $DEBUG -eq 1 ]] && echo "Running install() from: $script"
    install
    unset -f install
  else
    [[ $DEBUG -eq 1 ]] && echo "No install() function found in $script — skipping"
  fi
}

if [ $# -eq 0 ]; then
  # No arguments provided, run all scripts
  for script in scripts/install/*.sh; do
    run_install_script "$script"
  done
else
  # Filter script by argument
  for script in scripts/install/*${1}*.sh; do
    if [ -f "$script" ]; then
      run_install_script "$script"
    else
      echo "No installation script found matching: ${1}"
      exit 1
    fi
  done
fi

if ! isMac && ! isArch; then
  # Revert to normal idle and lock settings
  gsettings set org.gnome.desktop.screensaver lock-enabled true
  gsettings set org.gnome.desktop.session idle-delay 300
fi

