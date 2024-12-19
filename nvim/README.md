# dotfiles/nvim/.config/nvim

## Install Instructions

 > Install requires Neovim 0.11+. Always review the code before installing a configuration.

Clone the repository and install the plugins:

```
cd nvim/dot-config/nvim
./update.sh
```

## Philosophy

*Simplicity*. Don't use a package manager when it's not really needed. We don't need all the configuration and options and bloat which comes with it.

*Specific features, not generic*. Don't use a plugin for something which can be done simpler. For example we don't need a hugely configurable statusline plugin, when we can make a very specific one for what we need.

*Beskope plugin loader*. Plugins are just submodules. Use a bespoke plugin loader to load only some plugins on startup and others on triggers. This makes the setup lightweight and fast.

*Be contrarian*. We don't use Neovim to be like everyone else. If everyone uses Lazy.nvim, let's do something else. Neovim should be a personal development environment which we control ourselves. 

*Bleeding edge*. Use the nighly builds of Neovim and use the new features as they become available. Use the new lsp configuration, and use already installed lsps, instead of using plugins for lsp-config, mason, etc.

