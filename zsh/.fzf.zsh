# Setup fzf
# ---------
if [[ ! "$PATH" == */.fzf/bin* ]]; then
  PATH="${HOME}/.fzf/bin:${PATH:+${PATH}:}"
fi

#FZF_DEFAULT_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
FZF_DEFAULT_OPTS="--reverse --border rounded --no-info --pointer='>' --marker='+' --ansi --color='16,bg+:-1,gutter:-1,prompt:5,pointer:5,marker:6,border:4,label:4'"
FZF_CTRL_R_OPTS="--preview 'echo {}' --border-label=' history ' --prompt '🕑 '"

# Auto-completion
# ---------------
source "${HOME}/.fzf/shell/completion.zsh"

# Key bindings
# ------------
source "${HOME}/.fzf/shell/key-bindings.zsh"
