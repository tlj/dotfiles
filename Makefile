STOW := $(shell command -v stow 2> /dev/null)
BREW := $(shell command -v brew 2> /dev/null)
UNAME := $(shell uname)

all: deps dotfiles

dotfiles:
ifndef STOW
		$(error "stow is not available, please install stow.")
endif
	stow --verbose --target=$$HOME --restow */
	rm ~/Library/Application\ Support/Übersicht/widgets/simple-bar-lite/custom-settings.json
	ln -s `pwd`/ubersicht/custom-settings.json ~/Library/Application\ Support/Übersicht/widgets/simple-bar-lite/custom-settings.json

delete:
ifndef STOW
		$(error "stow is not available, please install stow.")
endif
	stow --verbose --target=$$HOME --delete */

deps:
ifeq ($(UNAME), Darwin)
ifndef BREW
	@echo "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
endif
	@echo "Installing ripgrep, fd and neovim"
	brew install ripgrep fd neovim git lazygit composer
	@echo "Installing kitty terminal"
	brew install --cask kitty ubersicht
	@echo "Installing simple-bar-lite"
	if [ ! -d "${HOME}/Library/Application Support/Übersicht/widgets/simple-bar-lite" ]; then git clone https://github.com/Jean-Tinland/simple-bar-lite ${HOME}/Library/Application\ Support/Übersicht/widgets/simple-bar-lite; fi
endif
ifeq ($(UNAME), Linux)
	@echo "Installing ripgrep, fd-find and neovim"
	sudo apt install riprep fd-find neovim
endif

