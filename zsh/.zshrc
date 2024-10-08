# If you come from bash you might have to change your $PATH.
export PATH=$HOME/Library/Python/3.11/bin:/opt/homebrew/lib/ruby/gems/3.3.0/bin:/opt/homebrew/opt/ruby/bin:$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:$HOME/dotfiles/bin:/opt/homebrew/bin:/usr/local/bin:$PATH

# Make sure the XDG config home is set to a place where we expect it to be
export XDG_CONFIG_HOME="$HOME/.config"

# Set up the Starship prompt
eval "$(~/.cargo/bin/starship init zsh)"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# Don't auto update Homebrew on every command
export HOMEBREW_NO_AUTO_UPDATE=1

# Set up Homebrew
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

ulimit -S -n 4096

# NeoVim for the win
export EDITOR='nvim'

# Set up some nice aliases
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

# Bind C-x to clear-screen, as C-l is used for navigation inside of tmux
bindkey "^X"  clear-screen

# Git diff with fzf and preview
gs() {
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview $preview
}

# Connect to a tmux session or create a new one, based on zoxide
t() {
  sesh connect $(sesh list | fzf)
  #zellij attach $(zellij list-sessions -s | fzf)
}

# Create a new tmux session from current directory
nt() {
  #zellij -s $(pwd | sed 's/.*\///')
  tmux new -s $(pwd | sed 's/.*\///')
}

function zr() {
  # If a session name is provided as an argument, attach to or create it
  if [[ -n $1 ]]; then
      if zellij ls -n | grep -E -q "^$1( \(current\))?$"; then
        # Attach to the specified session if it exists
        zellij a "$1"
      else
        # Create a new session with the specified name if it doesn't exist
        zellij -s "$1"
      fi
  fi

  while true; do
    local sessions_list=("New session" "Exit")
    local existing_sessions=($(zellij ls -s | sed 's/ (current)//'))

    if [[ ${#existing_sessions[@]} -gt 0 ]]; then
      sessions_list=("${existing_sessions[@]}" "${sessions_list[@]}")
    fi

    local choice=$(printf '%s\n' "${sessions_list[@]}" | fzf --prompt="Select an option: ")

    # If the choice is empty, assume the user wants to exit
    if [[ -z $choice ]]; then
      break
    fi

    case $choice in
      "New session")
        local dir_options=("No directory" "Exit")
        local dirs=($(zoxide query -l))
        if [[ ${#dirs[@]} -gt 0 ]]; then
          dir_options=("${dirs[@]}" "${dir_options[@]}")
        fi
        local dir_choice=$(printf '%s\n' "${dir_options[@]}" | fzf --prompt="Select a directory or choose 'No directory': ")

        # If the dir_choice is empty or invalid, continue to the next iteration of the loop
        if [[ -z $dir_choice || $dir_choice == "Exit" ]]; then
          continue
        fi

        case $dir_choice in
          "No directory")
            zellij
            ;;
          *)
            local session_name="$(basename $dir_choice)"
            if [[ " ${existing_sessions[@]} " =~ " ${session_name} " ]]; then
              # Attach to existing session
              zellij a $session_name
            else
              # Create new session and change directory
              (cd "$dir_choice" && zellij -s "$session_name")
            fi
            ;;
        esac
        ;;
      "Exit")
        break
        ;;
      *)
        zellij a $choice
        ;;
    esac
  done
}

git_show() {
  git show ${1:0:7}
}

# Git log with fzf and preview
glog() {
  git log --oneline | fzf --preview "~/dotfiles/bin/preview.sh {}" --preview-window=right:60%
}

# Load mise
eval "$(mise activate)"

# Put host specific configuration in this file - don't check it into git
[ -f $HOME/.zshrc-local ] && source $HOME/.zshrc-local

# Load zoxide, and alias it to cd
eval "$(~/.cargo/bin/zoxide init zsh)"
alias cd="z"

# If we are inside of a tmux session, we need to export the KITTY_LISTEN_ON variable
if [[ ! -z $TMUX && -z $WSL_DISTRO_NAME ]]; then
  export $(tmux show-environment | grep "^KITTY_LISTEN_ON")
fi

# Load vim mode
source ~/.zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# The plugin will auto execute this zvm_after_init function, we do this because the
# zsh vim mode overrides some bindings, and we want to make sure it doesn't.
function zvm_after_init() {
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}
