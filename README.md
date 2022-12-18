# tlj dotfiles

## Install the dotfiles and dependencies

The make script support MacOS and Linux and will install dotfiles, dependencies and common tools, like fd, ripgrep, neovim and homebrew.

```shell
make 
```

If you only want to install the dotfiles there is a command for just doing that:

```shell
make dotfiles
```

## Dependencies

### Ubersicht

https://tracesof.net/uebersicht/

### Simple bar lite

https://github.com/Jean-Tinland/simple-bar-lite

### Patched font

Clone https://github.com/Karmenzind/monaco-nerd-fonts and set the font for your terminal to use the correct Monaco Nerd Font.

### Terminal color theme

Find the correct repo for your terminal on https://github.com/catppuccin/catppuccin. Clone it and set the terminal colors to the catppuccin-mocha theme.

### Zsh and oh-my-zsh

https://ohmyz.sh/#install

The .zshrc installed by stow will try to load a ~/.zshrc-local file which has any special zsh config for the local computer, which shouldn't be shared. This file needs to be reated to avoid a warning on startup.

## Known issues

### Neovim

On first run of NeoVim you might get an error regarding "Not an editor command: TSUpdate" when packer is first installing plugins. Start Neovim again and run :PackerSync. This fixes the issue.

## Remove the dotfiles

```shell
make delete
```

