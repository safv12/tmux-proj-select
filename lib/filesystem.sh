#!/bin/bash
# Filesystem utilities - generic file and directory operations

# Expand tilde and environment variables in path
# Args: $1 - path string (can contain ~, $VAR, or spaces)
# Returns: expanded path (via stdout)
expand_path() {
    local path="$1"
    eval echo "$path"
}

# Find directories at specific depth
# Args: $1 - parent directory, $2 - min depth (default 1), $3 - max depth (default 1)
# Returns: list of directories (via stdout)
find_directories() {
    local parent="$1"
    local min_depth="${2:-1}"
    local max_depth="${3:-1}"
    find "$parent" -mindepth "$min_depth" -maxdepth "$max_depth" -type d 2>/dev/null
}

# Find directories in multiple parent directories
# Args: $@ - array of parent directories
# Returns: list of directories (via stdout)
find_directories_multi() {
    local dirs=("$@")
    find "${dirs[@]}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null
}
