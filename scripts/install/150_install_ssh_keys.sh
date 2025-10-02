#!/usr/bin/env bash

install() {
  # Only run on 'internal' hosts
  require_trait "internal" "Skipping SSH key install — host is not internal" || return 0

  print_header "Install SSH keys from GitHub"

  local url="https://github.com/tlj.keys"
  local sshdir="$HOME/.ssh"
  local auth="$sshdir/authorized_keys"
  local tmp

  mkdir -p "$sshdir"
  chmod 700 "$sshdir" || true

  # Ensure authorized_keys exists with correct perms
  touch "$auth"
  chmod 600 "$auth" || true

  tmp=$(mktemp) || return 1
  trap 'rm -f "$tmp"' RETURN

  if ! curl -fsSL "$url" -o "$tmp"; then
    echo "Failed to download keys from $url"
    return 1
  fi

  local line norm
  while IFS= read -r line || [[ -n "$line" ]]; do
    # skip empty lines and comments
    [[ -z "${line//[[:space:]]/}" ]] && continue
    [[ "$line" =~ ^# ]] && continue

    # Normalize to "<type> <key>" to ignore trailing comments
    norm=$(printf "%s" "$line" | awk '{print $1 " " $2}')
    if awk '{print $1 " " $2}' "$auth" | grep -F -x -q -- "$norm"; then
      [[ ${DEBUG:-0} -eq 1 ]] && echo "Key already present: $norm"
      else
      if [[ ${DRY_RUN:-0} -eq 1 ]]; then
        printf "[DRY-RUN] append to %s: %s\n" "$auth" "$line"
      else
        echo "$line" >> "$auth"
      fi
      echo "Added SSH key: $norm"
    fi
  done < "$tmp"

  chmod 600 "$auth" || true
}


# No actions on source — setup.sh calls install()
