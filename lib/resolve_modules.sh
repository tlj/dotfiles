#!/usr/bin/env bash

# Idempotent include guard
if [[ -n "${NEXTGEN_RESOLVE_MODULES_LOADED:-}" ]]; then
  [[ "${VERBOSE:-0}" -eq 1 ]] && echo "resolve_modules.sh already loaded"
  return 0
fi
NEXTGEN_RESOLVE_MODULES_LOADED=1

# Determine the top-level script that started the process (last element of BASH_SOURCE)
TOP_SCRIPT="${BASH_SOURCE[$(( ${#BASH_SOURCE[@]} - 1 ))]}"
TOP_DIR="$(dirname "$(realpath "$TOP_SCRIPT")")"

# Default hosts/config file (config.sh one level above this lib directory)
HOSTS_FILE="${HOSTS_FILE:-$TOP_DIR/config.sh}"

if [[ ! -f "$HOSTS_FILE" ]]; then
  echo "hosts/config file not found at $HOSTS_FILE"
  return 1
fi

# shellcheck disable=SC1090
source "$HOSTS_FILE"

# Short hostname, normalized to lower-case for stable lookups
INSTALL_HOST="$(hostname -s 2>/dev/null || hostname)"
INSTALL_HOST="$(printf "%s" "$INSTALL_HOST" | tr '[:upper:]' '[:lower:]')"

# resolve_modules_for_host [host]
# Expands `role:<role>` in the host entry to the modules defined in
# HOST_ROLES["<role>"] and appends any explicit `module:<name>` tokens.
# Prints one `module:<name>` per line, preserving order and removing duplicates.
resolve_modules_for_host() {
  local host="${1:-$INSTALL_HOST}"
  local host_entry="${HOSTS[$host]:-}"
  local -a modules=()
  declare -A seen=()

  if [[ -z "$host_entry" ]]; then
    return 0
  fi

  local token
  for token in $host_entry; do
    if [[ "$token" == role:* ]]; then
      local role="${token#role:}"
      local role_modules="${HOST_ROLES[$role]:-}"
      for rm in $role_modules; do
        if [[ "$rm" == module:* && -z "${seen[$rm]:-}" ]]; then
          modules+=("$rm")
          seen[$rm]=1
        fi
      done
    elif [[ "$token" == module:* ]]; then
      if [[ -z "${seen[$token]:-}" ]]; then
        modules+=("$token")
        seen[$token]=1
      fi
    fi
  done

  local m
  for m in "${modules[@]}"; do
    printf "%s\n" "$m"
  done
}
