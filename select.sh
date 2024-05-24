#!/bin/bash

DIRS=$1
CMD=$2

# Selecting a project
expanded_dirs=$(eval echo $DIRS)

IFS=' ' read -r -a DIR_ARRAY <<< "$expanded_dirs"
path_name=$(find "${DIR_ARRAY[@]}" -mindepth 1 -maxdepth 1 -type d | fzf)
session_name=$(basename "$path_name" | tr . _)
tmux_running=$(pgrep tmux)

if [ -z "$session_name" ]; then
    exit 1
fi

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $session_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$session_name 2> /dev/null; then
    tmux new-session -ds $session_name -c $path_name
fi

tmux switch-client -t $selected_name
