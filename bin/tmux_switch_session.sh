#!/bin/bash

if ! type fzf > /dev/null 2>&1; then
	echo "You don't have fzf, install it and rerun."
	exit 1
fi

tmux_sessions=$(tmux ls | cut -d':' -f1)
if [ -z "$tmux_sessions" ]; then
	echo "No active tmux sessions."
	exit 1
fi

current_session=$(tmux display-message -p '#S')
selected_session=$(tmux ls | cut -d':' -f1 | fzf --info inline --multi --header "Switch TMUX session. Current: ${current_session}")
if [ -z "$selected_session" ]; then
	echo "No tmux session selected."
	exit 1
fi

tmux switch-client -t $selected_session
