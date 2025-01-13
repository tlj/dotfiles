# tlj dotfiles

## Install the dotfiles and dependencies

The make script support MacOS and Linux and will install dotfiles, dependencies and common tools, like fd, ripgrep, neovim and homebrew.

### Install directly from Github.

#### With Curl

```shell
curl -s https://raw.githubusercontent.com/tlj/dotfiles/master/install.sh | bash
```

#### With wget

```shell
wget -qO- https://raw.githubusercontent.com/tlj/dotfiles/master/install.sh | bash
```
### Check out the repository instead, then run:

```shell
./setup.sh
```

You can re-run `./setup.sh` to update everything, or run `./setup.sh neovim` to install/update just one app (in this case neovim).

## Features

| Tool | Description |
|------|-------------|
| [neovim](https://neovim.io) | editor (see [nvim/README.md](nvim/README.md) |


## Dependencies

### Zsh

The .zshrc installed by stow will try to load a ~/.zshrc-local file which has any special zsh config for the local computer, which shouldn't be shared. This file needs to be reated to avoid a warning on startup.

## Known issues

### Steps to install on a new Mac

```bash
git clone git@github.com:tlj/dotfiles
```

If xcode is not installed, accept the install, and re-run the git clone after xcode is installed. If you get an error about `inactive developer path`, you need to run
```bash
xcode-select --install
```

From ~/dotfiles/ do:

```bash
./install.sh
```


