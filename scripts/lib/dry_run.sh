# Dry-run stub functions: when DRY_RUN=1 these functions print intended actions instead of executing them.
# Exported so subshells/source-scripts inherit dry-run behavior.

if [[ ${DRY_RUN:-0} -eq 1 ]]; then
  _dry_echo() { printf "[DRY-RUN] %s\n" "$*"; }

  sudo() { _dry_echo "sudo $*"; return 0; }
  pacman() { _dry_echo "pacman $*"; return 0; }
  systemctl() { _dry_echo "systemctl $*"; return 0; }
  stow() { _dry_echo "stow $*"; return 0; }
  hyprpm() { _dry_echo "hyprpm $*"; return 0; }
  hyprctl() { _dry_echo "hyprctl $*"; return 0; }
  git() { _dry_echo "git $*"; return 0; }
  ln() { _dry_echo "ln $*"; return 0; }
  mv() { _dry_echo "mv $*"; return 0; }
  rm() { _dry_echo "rm $*"; return 0; }
  cp() { _dry_echo "cp $*"; return 0; }
  tee() { _dry_echo "tee $*"; return 0; }
  chmod() { _dry_echo "chmod $*"; return 0; }
  chown() { _dry_echo "chown $*"; return 0; }
  touch() { _dry_echo "touch $*"; return 0; }
  curl() { _dry_echo "curl $*"; return 0; }
  mkdir() { _dry_echo "mkdir $*"; return 0; }
  gsettings() { _dry_echo "gsettings $*"; return 0; }
  bat() { _dry_cache "bat $*"; return 0; }

  # Build/package manager/tooling wrappers
  makepkg() { _dry_echo "makepkg $*"; return 0; }
  gpg() { _dry_echo "gpg $*"; return 0; }
  yay() { _dry_echo "yay $*"; return 0; }
  brew() { _dry_echo "brew $*"; return 0; }
  apt() { _dry_echo "apt $*"; return 0; }
  apt-get() { _dry_echo "apt-get $*"; return 0; }
  dnf() { _dry_echo "dnf $*"; return 0; }
  snap() { _dry_echo "snap $*"; return 0; }
  pip() { _dry_echo "pip $*"; return 0; }
  pip3() { _dry_echo "pip3 $*"; return 0; }
  npm() { _dry_echo "npm $*"; return 0; }
  cargo() { _dry_echo "cargo $*"; return 0; }
  go() { _dry_echo "go $*"; return 0; }
  rustup() { _dry_echo "rustup $*"; return 0; }
  wget() { _dry_echo "wget $*"; return 0; }
  unzip() { _dry_echo "unzip $*"; return 0; }
  tar() { _dry_echo "tar $*"; return 0; }
  makepkg() { _dry_echo "makepkg $*"; return 0; }
  add-apt-repository() { _dry_echo "add-apt-repository $*"; return 0; }
  dpkg() { _dry_echo "dpkg $*"; return 0; }
  ubi() { _dry_echo "ubi $*"; return 0; }
  mise() { _dry_echo "mise $*"; return 0; }
  sh() { _dry_echo "sh $*"; return 0; }
  fc-cache() { _dry_echo "sh $*"; return 0; }

  # Export wrapper functions so subshells inherit dry-run behavior
  export -f sudo pacman systemctl stow hyprpm hyprctl git ln mv rm cp tee chmod chown touch curl mkdir gsettings \
    makepkg gpg yay brew apt apt-get dnf snap pip pip3 npm cargo go rustup wget unzip tar add-apt-repository dpkg \
    ubi mise sh fc-cache bat
fi
