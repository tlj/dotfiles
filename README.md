# tlj dotfiles

## Install the dotfiles and dependencies

The make script support MacOS and Linux and will install dotfiles, dependencies and common tools, like fd, ripgrep, neovim and homebrew.

```shell
./install.sh
```

## Dependencies

### Zsh

The .zshrc installed by stow will try to load a ~/.zshrc-local file which has any special zsh config for the local computer, which shouldn't be shared. This file needs to be reated to avoid a warning on startup.

## Known issues

### Ubersicht / yabai load order

If yabai is loaded after Ubersicht, the space indicators stop working. If this happens, just restart Ubersicht.

