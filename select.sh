#!/bin/bash

DIRS=$1
CMD=$2

expanded_dirs=$(eval echo $DIRS)

IFS=' ' read -r -a DIR_ARRAY <<< "$expanded_dirs"
selected_directory=$(find "${DIR_ARRAY[@]}" -mindepth 1 -maxdepth 1 -type d | fzf)
session_name=$(basename "$selected_directory" | tr . _)

if [ -z "$session_name" ]; then
    exit 1
fi

if ! tmux has-session -t=$session_name 2> /dev/null; then
    tmux new-session -ds $session_name -c $selected_directory
    tmux send-keys -t "$session_name" "$CMD" Enter;
fi

tmux switch-client -t $selected_name
