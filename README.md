# tlj dotfiles

## Install the dotfiles and dependencies

The make script support MacOS and Linux and will install dotfiles, dependencies and common tools, like fd, ripgrep, neovim and homebrew.

```shell
./install.sh
```

## Features

| Tool | Description |
|------|-------------|
| [homebrew](https://brew.sh) | Homebrew |
| [neovim](https://neovim.io) | editor |
| [bat](https://github.com/sharkdp/bat) | cat replacement |
| [lsd](https://github.com/peltoche/lsd) | ls -l replacement |
| [kitty](https://sw.kovidgoyal.net/kitty/) | terminal emulator |
| [lazygit](https://github.com/jesseduffield/lazygit) | simple terminal UI for git commands |
| [git cz](https://github.com/lintingzhen/commitizen-go) | git commit tool to enforce conventional commit standard |
| [autojump](https://github.com/wting/autojump) | a cd command that learns |
| [nerd fonts](https://github.com/ryanoasis/nerd-fonts) | nerd fonts |
| [jetbrains mono font](https://www.jetbrains.com/lp/mono/) | Jetbrains Mono font |
| [catppuccin themes](https://github.com/catppuccin/catppuccin) | catppuccin themes for neovim, bat, etc) |
| [oh-my-zsh](https://ohmyz.sh) | shell customization |
| [powerlevel 10k](https://github.com/romkatv/powerlevel10k) | a zsh theme |
| [zsh-syntaz-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | Fish shell like syntax highlighting for zsh |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | Fish-like autosuggestions for zsh |
| [fzf](https://github.com/junegunn/fzf) | A command-line fuzzy finder |
| [yabai](https://github.com/koekeishiya/yabai) | A tiling window manager for macOS |
| [skhd](https://github.com/koekeishiya/skhd) | Simple hotkey daemon for MacOS |
| [ubersicht](https://tracesof.net/uebersicht/) | Widget manager for MacOS |
| [simple-bar](https://github.com/Jean-Tinland/simple-bar) | A yabai status bar widget for Ubersicht |


## Dependencies

### Zsh

The .zshrc installed by stow will try to load a ~/.zshrc-local file which has any special zsh config for the local computer, which shouldn't be shared. This file needs to be reated to avoid a warning on startup.

## Known issues

### Ubersicht / yabai load order

If yabai is loaded after Ubersicht, the space indicators stop working. If this happens, just restart Ubersicht.

