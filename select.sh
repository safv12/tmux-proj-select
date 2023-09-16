#!/bin/bash

DIR=$1
CMD=$2

echo "Projects directory: $DIR"
echo "Default command: $CMD"
if [ -z "$DIR" ]; then
  echo "Project directory is required."
  exit 1
fi

if [ -z "$CMD" ]; then
  echo "The launcher command was not provided."
  exit 1
fi

# Selecting a project
_session_name=$(cd $DIR && ls -d */ | sed "s|/||g" | fzf --reverse --header="Select project from $(basename $DIR) >")
session_name=${_session_name//./_}
path_name=$DIR/$_session_name

echo Creating new session: \"$session_name\"
echo Session path: $path_name

if [ -z "$session_name" ]; then
    echo Session name must not be empty
    exit 1
fi

session_exists() {
    tmux has-session -t "=$session_name"
}

create_detached_session() {
    (TMUX=''
    tmux new-session -Ad -s "$session_name" -c $path_name;
    tmux send-keys -t "$session_name" $CMD Enter;
    )
 }

create_if_needed_and_attach() {
    if [ -z "$TMUX" ]; then
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
