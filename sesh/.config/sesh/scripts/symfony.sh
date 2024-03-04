#/usr/bin/env bash

CURRENT_WINDOW=$(tmux display-message -p '#I')

tmux new-window -d -n 'Server' 'make symfony-local; zsh'

tmux select-window -t $CURRENT_WINDOW

tmux send-keys -t $CURRENT_WINDOW 'nvim' C-m
