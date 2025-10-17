#!/bin/bash
# History utility - tracks recently used projects (MRU - Most Recently Used)

# Default history file location
readonly DEFAULT_HISTORY_FILE="${HOME}/.tmux-proj-select-history"

# Get history file path
# Returns: history file path (via stdout)
history_get_file() {
    echo "${TMUX_PROJ_SELECT_HISTORY_FILE:-$DEFAULT_HISTORY_FILE}"
}

# Initialize history file if it doesn't exist
history_init() {
    local history_file=$(history_get_file)
    if [[ ! -f "$history_file" ]]; then
        touch "$history_file"
    fi
}

# Add project to history (most recent at top)
# Args: $1 - project directory path
history_add() {
    local project_dir="$1"
    local history_file=$(history_get_file)

    history_init

    # Remove existing entry if present
    if [[ -f "$history_file" ]]; then
        grep -v "^${project_dir}$" "$history_file" > "${history_file}.tmp" 2>/dev/null || true
        mv "${history_file}.tmp" "$history_file"
    fi

    # Add to top of file
    echo "$project_dir" | cat - "$history_file" > "${history_file}.tmp"
    mv "${history_file}.tmp" "$history_file"

    # Keep only last 100 entries
    head -n 100 "$history_file" > "${history_file}.tmp"
    mv "${history_file}.tmp" "$history_file"
}

# Get all history entries
# Returns: list of project paths (via stdout)
history_list() {
    local history_file=$(history_get_file)
    history_init

    if [[ -f "$history_file" ]]; then
        cat "$history_file"
    fi
}

# Get recent projects that still exist
# Returns: list of existing project paths (via stdout)
history_list_existing() {
    history_list | while read -r dir; do
        if [[ -d "$dir" ]]; then
            echo "$dir"
        fi
    done
}

# Clear history file
history_clear() {
    local history_file=$(history_get_file)
    rm -f "$history_file"
    history_init
}

# Check if project is in history
# Args: $1 - project directory path
# Returns: 0 if in history, 1 if not
history_contains() {
    local project_dir="$1"
    local history_file=$(history_get_file)

    if [[ -f "$history_file" ]]; then
        grep -q "^${project_dir}$" "$history_file"
    else
        return 1
    fi
}

# Get history rank for a project (0 = most recent)
# Args: $1 - project directory path
# Returns: rank number (via stdout), empty if not in history
history_rank() {
    local project_dir="$1"
    local history_file=$(history_get_file)
    local rank=0

    if [[ ! -f "$history_file" ]]; then
        return
    fi

    while read -r dir; do
        if [[ "$dir" == "$project_dir" ]]; then
            echo "$rank"
            return
        fi
        rank=$((rank + 1))
    done < "$history_file"
}
