# If you come from bash you might have to change your $PATH.
export PATH=$HOME/Library/Python/3.11/bin:/opt/homebrew/lib/ruby/gems/3.3.0/bin:/opt/homebrew/opt/ruby/bin:$HOME/nvim-macos/bin:$HOME/bin:$HOME/.local/bin:$HOME/go/bin:$HOME/dotfiles/bin:/opt/homebrew/bin:/usr/local/bin:$PATH

export XDG_CONFIG_HOME="$HOME/.config"

eval "$(starship init zsh)"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

ulimit -S -n 4096

export EDITOR='nvim'

alias ibrew="arch -x86_64 /usr/local/bin/brew"
alias n="nvim"
alias nv="~/dotfiles/bin/neovide.applescript $PWD "
alias vim="nvim"
alias cat="bat"
alias l="lsd"
alias ll="lsd -l"
alias la="lsd -a"
alias lla="lsd -la"
alias lt="lsd --tree"
alias lta="lsd -a --tree"
alias lg="lazygit"
alias s="kitty +kitten ssh"
alias d="cd ~/dotfiles && nvim && cd -"
alias dv="~/dotfiles/bin/neovide.applescript $PWD ~/dotfiles"
alias op="cd ~/Documents/Obsidian/Privat && nvim && cd -"
alias ow="cd ~/Documents/Obsidian/Work && nvim && cd -"

gs() {
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview $preview
}

t() {
  sesh connect $(sesh list | fzf)
}

nt() {
  tmux new -s $(pwd | sed 's/.*\///')
}

git_show() {
  git show ${1:0:7}
}

glog() {
  git log --oneline | fzf --preview "~/dotfiles/bin/preview.sh {}" --preview-window=right:60%
}

source $HOME/.zshrc-local


eval "$(zoxide init zsh)"
alias cd="z"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ ! -z $TMUX ]]; then
  export $(tmux show-environment | grep "^KITTY_LISTEN_ON")
fi

source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# The plugin will auto execute this zvm_after_init function
function zvm_after_init() {
  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
  [[ ! -r /Users/thomas/.opam/opam-init/init.zsh ]] || source /Users/thomas/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
  [ -f ~/.asdf/asdf.sh ] && source ~/.asdf/asdf.sh
  [ -f ~/.asdf/completions/asdf.zsh ] && source ~/.asdf/completions/asdf.zsh
  #eval "$(atuin init zsh --disable-up-arrow)"
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}
