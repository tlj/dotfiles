# tlj dotfiles

## Requirements

*GNU stow*

```shell
brew install stow
```

## Install the dotfiles

```shell
make 
```

## Dependencies

### Patched font

Clone https://github.com/Karmenzind/monaco-nerd-fonts and set the font for your terminal to use the correct Monaco Nerd Font.

### Terminal color theme

Find the correct repo for your terminal on https://github.com/catppuccin/catppuccin. Clone it and set the terminal colors to the catppuccin-mocha theme.

### Zsh and oh-my-zsh

https://ohmyz.sh/#install

The .zshrc installed by stow will try to load a ~/.zshrc-local file which has any special zsh config for the local computer, which shouldn't be shared. This file needs to be reated to avoid a warning on startup.

### Neovim

```shell
brew install ripgrep fd
```

## Known issues

### Neovim

On first run of NeoVim you might get an error regarding "Not an editor command: TSUpdate" when packer is first installing plugins. Start Neovim again and run :PackerSync. This fixes the issue.

## Remove the dotfiles

```shell
make delete
```

