APT_PACKAGES="zsh"
PACMAN_PACKAGES="zsh"
YAY_PACKAGES=""
BREW_PACKAGES="zsh"
UBI_PACKAGES=""
BREW_CASK_PACKAGES=""
SNAP_PACKAGES=""

install_packages

echo " - Install starship..."
cargo install -q starship --locked

echo " - Install zoxide..."
cargo install -q zoxide --locked

echo " - Install atuin..."
cargo install -q atuin --locked

echo " - Installing zsh-vi-mode..."
install_with_git ~/.zsh/zsh-vi-mode https://github.com/jeffreytse/zsh-vi-mode

echo " - Installing zsh-autosuggestions..."
install_with_git ~/.zsh/zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions

chsh -s $(which zsh)

stow_package "shell"
