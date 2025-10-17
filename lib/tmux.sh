#!/bin/bash
# TMUX utilities - generic, reusable tmux functions

# Check if a tmux session exists
# Args: $1 - session name
# Returns: 0 if exists, 1 if not
tmux_session_exists() {
    local session_name="$1"
    tmux has-session -t "=$session_name" 2>/dev/null
}

# Create a new detached tmux session
# Args: $1 - session name, $2 - directory path
tmux_create_session() {
    local session_name="$1"
    local directory="$2"
    tmux new-session -Ad -s "$session_name" -c "$directory"
}

# Send keys to a tmux session
# Args: $1 - session name, $2 - keys/command to send
tmux_send_keys() {
    local session_name="$1"
    local keys="$2"
    tmux send-keys -t "$session_name" "$keys" Enter
}

# Switch tmux client to a session
# Args: $1 - session name
tmux_switch_to() {
    local session_name="$1"
    tmux switch-client -t "$session_name"
}

# Attach to tmux session
# Args: $1 - session name
tmux_attach() {
    local session_name="$1"
    tmux attach -t "$session_name"
}

# List tmux sessions with format
# Args: $1 - format string (optional, defaults to session name)
# Returns: list of sessions (via stdout)
tmux_list_sessions() {
    local format="${1:-#{session_name}}"
    tmux list-sessions -F "$format"
}

# Show tmux session chooser
tmux_choose_tree() {
    tmux choose-tree -Za
}

# Get first session name
# Returns: first session name (via stdout)
tmux_get_first_session() {
    tmux_list_sessions | head -n 1
}
