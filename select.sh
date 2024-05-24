#!/bin/bash

DIRS=$1
CMD=$2

if [ -z "$DIRS" ]; then
    echo "Received empty DIRS"
    exit 1
fi

if [ -z "$CMD" ]; then
    echo "Received empty CMD"
    exit 1
fi

expanded_dirs=$(eval echo $DIRS)

IFS=' ' read -r -a DIR_ARRAY <<< "$expanded_dirs"
selected_directory=$(find "${DIR_ARRAY[@]}" -mindepth 1 -maxdepth 1 -type d | fzf)
session_name=$(basename "$selected_directory" | tr . _)

if [ -z "$session_name" ]; then
    exit 1
fi

session_exists() {
    tmux has-session -t "=$session_name"
}

create_detached_session() {
  tmux new-session -Ad -s "$session_name" -c $selected_directory;
  tmux send-keys -t "$session_name" "nvim '+Telescope find_files'" Enter;
}

create_if_needed_and_attach() {
  if ! session_exists; then
    create_detached_session
  fi

  tmux switch-client -t "$session_name"
}

 attach_to_first_session() {
     tmux attach -t $(tmux list-sessions -F "${session_name}" | head -n 1)
     tmux choose-tree -Za
}
 
create_if_needed_and_attach || attach_to_first_session
