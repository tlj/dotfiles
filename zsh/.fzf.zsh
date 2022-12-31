# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/tjohnsen/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/tjohnsen/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/tjohnsen/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/Users/tjohnsen/.fzf/shell/key-bindings.zsh"
