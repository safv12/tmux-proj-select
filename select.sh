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

session_exists() {
    # checks if the $session_name exists
    tmux has-session -t "=$session_name"
}

create_detached_session() {
    (TMUX=''
    tmux new-session -Ad -s "$session_name" -c $path_name;
    tmux send-keys -t "$session_name" "nvim '+Telescope find_files'" Enter;
    )
 }

create_if_needed_and_attach() {
    if not_in_tmux; then
        tmux new-session -As "$session_name" -c $path_name
    else
        if ! session_exists; then
        create_detached_session
        fi
        tmux switch-client -t "$session_name"
    fi
}

 attach_to_first_session() {
     tmux attach -t $(tmux list-sessions -F "${session_name}" | head -n 1)
     tmux choose-tree -Za
}

create_if_needed_and_attach || attach_to_first_session
