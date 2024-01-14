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

if [ -z "$GIT_FOLDER_PATH" ] || [ ! -d "$GIT_FOLDER_PATH" ]; then
    tmux display-message "Git folder path faulty: $GIT_FOLDER_PATH"
    exit 1
fi


chosen_dir=$(find "$GIT_FOLDER_PATH" -maxdepth 1 -type d -printf "%f\n" | tail -n +2 | fzf --info inline --multi --header "Start and go to TMUX session.")
if [ -z "$chosen_dir" ]; then
    tmux display-message "No directory chosen."
    exit 1
fi

if tmux has-session -t "$chosen_dir" 2>/dev/null; then
    tmux switch-client -t "$chosen_dir" || tmux attach-session -t "$chosen_dir"
else
    full_dir_path="${GIT_FOLDER_PATH%/}/$chosen_dir"
    tmux display-message "$full_dir_path"
    tmux new -s $chosen_dir -d
    tmux send-keys -t "$chosen_dir" "cd \"$full_dir_path\"" C-m
    tmux send-keys -t "$chosen_dir" "nvim ." C-m
    tmux split-window -h -t "$chosen_dir"
    tmux send-keys -t "$chosen_dir" "cd \"$full_dir_path\"" C-m
    tmux switch-client -t "$chosen_dir"
fi
