# Setup fzf
# ---------
if [[ ! "$PATH" == */.fzf/bin* ]]; then
  PATH="${HOME}/.fzf/bin:${PATH:+${PATH}:}"
fi

FZF_DEFAULT_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"

# Auto-completion
# ---------------
source "${HOME}/.fzf/shell/completion.zsh"

# Key bindings
# ------------
source "${HOME}/.fzf/shell/key-bindings.zsh"
