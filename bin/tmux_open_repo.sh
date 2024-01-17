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

# Declare an associative array
declare -A project_dir_paths

# Split GIT_FOLDER_PATH into an array
IFS=':' read -ra git_folder_paths <<< "$GIT_FOLDER_PATH"

echo $git_folder_paths

for path in "${git_folder_paths[@]}"; do
    if [ -d "$path" ]; then
        while IFS= read -r dir; do
            dir_name=$(basename "$dir")
            project_dir_paths["$dir_name"]="$dir"
        done < <(find "$path" -maxdepth 1 -type d | tail -n +2)
    else
        tmux display-message "Git folder path faulty: $path"
        continue
    fi
done

echo ${project_dir_paths[@]}

project_directory_names=$(printf '%s\n' "${!project_dir_paths[@]}")

echo ${project_directory_names}

current_tmux_session=$(tmux display-message -p '#S')
active_tmux_sessions=$(tmux ls | cut -d':' -f1)
combined_list=$(echo -e "$active_tmux_sessions\n${project_directory_names}" | sort -u)

chosen=$(echo -e "$combined_list" | fzf --info inline --multi --header "Switch TMUX session. Current: ${current_tmux_session}")
if [ -z "$chosen" ]; then
    tmux display-message "No directory chosen."
    exit 1
fi

if tmux has-session -t "$chosen" 2>/dev/null; then
    tmux switch-client -t "$chosen" || tmux attach-session -t "$chosen"
else
    full_dir_path=${project_dir_paths[$chosen]}
    tmux display-message "$full_dir_path"
    tmux new -s $chosen -d
    tmux send-keys -t "$chosen" "cd \"$full_dir_path\"" C-m
    tmux send-keys -t "$chosen" "nvim ." C-m
    tmux split-window -h -t "$chosen"
    tmux send-keys -t "$chosen" "cd \"$full_dir_path\"" C-m
    tmux switch-client -t "$chosen"
fi

