#!/usr/bin/env bash
set -euo pipefail

# nextgen/setup.sh - main entrypoint (always executed, not sourced)

# Determine top-level directory for nextgen (this file lives in nextgen/)
TOP_SCRIPT="${BASH_SOURCE[0]}"
TOP_DIR="$(dirname "$(realpath "$TOP_SCRIPT")")"

# Source all library scripts under nextgen/lib
if [[ -d "$TOP_DIR/lib" ]]; then
  # avoid literal pattern if no matches
  shopt -s nullglob
  for lib in "$TOP_DIR"/lib/*.sh; do
    # shellcheck disable=SC1090
    [[ -f "$lib" ]] && source "$lib"
  done
  shopt -u nullglob
fi

# Ensure resolve_modules_for_host is available
if ! declare -f resolve_modules_for_host >/dev/null; then
  echo "resolve_modules_for_host not found after sourcing libs"
  exit 1
fi

# Get modules for current host (one token per line like "module:name")
mapfile -t module_tokens < <(resolve_modules_for_host)

# Optional: allow selecting a single module to install via -m/--module or NEXTGEN_MODULE env var
MODULE_FILTER="${NEXTGEN_MODULE:-}"
# Parse CLI args for module filter
while [[ $# -gt 0 ]]; do
  case "$1" in
    -m|--module)
      if [[ -n "${2:-}" ]]; then
        MODULE_FILTER="$2"
        shift 2
      else
        echo "Missing value for $1"
        exit 1
      fi
      ;;
    --module=*)
      MODULE_FILTER="${1#*=}"
      shift
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

if [[ -n "$MODULE_FILTER" ]]; then
  # Filter module_tokens to only the requested module (match tokens like module:name)
  filtered=()
for tok in "${module_tokens[@]}"; do
    if [[ "$tok" == "module:$MODULE_FILTER" ]]; then
      filtered+=("$tok")
    fi
  done
  if [[ ${#filtered[@]} -eq 0 ]]; then
    echo "No modules to install for host matching: $MODULE_FILTER"
    exit 0
  fi
  module_tokens=("${filtered[@]}")
fi

# Function to run stow for a module. Module install scripts should call this
# when they want the stow step to run (instead of setup.sh running it
# automatically). The function accepts a single argument: the module name.
stow_package() {
  local module_name="$1"
  if [[ -z "$module_name" ]]; then
    echo "stow_package requires a module name"
    return 1
  fi
  local pkg_dir="$TOP_DIR/modules/$module_name"
  local stow_pkg_dir="$pkg_dir/stow"
  if [[ -d "$stow_pkg_dir" ]]; then
    if ! command -v stow >/dev/null 2>&1; then
      echo "stow not found; skipping stow for module $module_name"
      return 0
    fi
    check_and_backup_links "$stow_pkg_dir"
    echo " - Running stow for module $module_name"
    stow --dir="$pkg_dir" --target="$HOME" --dotfiles --adopt stow
  fi
}

if [[ ${#module_tokens[@]} -eq 0 ]]; then
  echo "No modules to install for host"
  exit 0
fi

# Track installed modules to display post-install instructions
installed_modules=()

# Call each module's install.sh by sourcing it so they have access to the libs
for tok in "${module_tokens[@]}"; do
  if [[ "$tok" != module:* ]]; then
    echo "Skipping unexpected token: $tok"
    continue
  fi

  module_name="${tok#module:}"
  install_sh="$TOP_DIR/modules/$module_name/install.sh"
  if [[ ! -f "$install_sh" ]]; then
    echo "Module install script not found: $install_sh"
    exit 1
  fi

  echo "Sourcing module install: $install_sh"
  # shellcheck disable=SC1090
  source "$install_sh"

  # Previously we ran stow automatically here. Instead modules should call
  # the helper function `stow_package "$module_name"` from their install
  # scripts when they want the stow step to run. This allows module install
  # scripts to perform follow-up actions that depend on stowed files.
  : # no-op placeholder to keep diff minimal
  installed_modules+=("$module_name")
done

# Show any post-install instructions provided by modules
for m in "${installed_modules[@]}"; do
  post="$TOP_DIR/modules/$m/post-install.txt"
  if [[ -f "$post" ]]; then
    echo
    echo "Post-install instructions for module $m:"
    echo "--------------------------------------------------"
    cat "$post"
    echo "--------------------------------------------------"
  fi
done

echo "Setup completed."

exit 0
