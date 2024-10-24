#!/bin/bash

tmux_sessions=$(tmux ls | cut -d':' -f1)
if [ -z "$tmux_sessions" ]; then
    echo "No active tmux sessions. Start it."
    exit 1
fi

if ! type fzf > /dev/null 2>&1; then
    tmux display-message "You don't have fzf, install it and rerun."
    exit 1
fi

current_tmux_session=$(tmux display-message -p '#S')
session_names=$(echo -e "$tmux_sessions" | sort -u)
chosen=$(echo -e "$session_names" | sort -u | fzf --info inline --multi --header "Switch TMUX session. Current: ${current_tmux_session}")
if [ -z "$chosen" ]; then
    exit 1
fi

if tmux has-session -t "$chosen" 2> /dev/null; then
    tmux switch-client -t "$chosen" || tmux attach-session -t "$chosen"
else
    full_dir_path=${project_dir_paths[$chosen]}
    tmux new -s $chosen -d -c "$full_dir_path"
    tmux switch-client -t $chosen
    tmux send-keys "nvim ." "Enter"
    tmux split-window -h -c "$full_dir_path"
fi
