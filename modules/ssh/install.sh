APT_PACKAGES=""
PACMAN_PACKAGES=""
YAY_PACKAGES=""
BREW_PACKAGES=""
UBI_PACKAGES=""
BREW_CASK_PACKAGES=""
SNAP_PACKAGES=""

url="https://github.com/tlj.keys"
sshdir="$HOME/.ssh"
auth="$sshdir/authorized_keys"

mkdir -p "$sshdir"
chmod 700 "$sshdir"

# Ensure authorized_keys exists with correct perms
touch "$auth"
chmod 600 "$auth"

tmp=$(mktemp) || return 1
trap 'rm -f "$tmp"' RETURN

if ! curl -fsSL "$url" -o "$tmp"; then
  echo "Failed to download keys from $url"
  return 1
fi

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

chmod 600 "$auth"

stow_package "ssh"
