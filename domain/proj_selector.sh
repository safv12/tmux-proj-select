#!/bin/bash
# Project selector domain logic - feature-specific functionality

DOMAIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$DOMAIN_DIR/../lib"

# Source core libraries
source "$LIB_DIR/string.sh"
source "$LIB_DIR/tmux.sh"
source "$LIB_DIR/validation.sh"
source "$LIB_DIR/filesystem.sh"
source "$LIB_DIR/history.sh"

# Configuration defaults for project selector
readonly DEFAULT_LAUNCH_KEY="C-p"
readonly DEFAULT_CMD="nvim"
readonly DEFAULT_DIR="~/dev"
readonly DEFAULT_HISTORY_FILE="${HOME}/.tmux-proj-select-history"

# Get project selector configuration
# Args: $1 - config variable name, $2 - default value
# Returns: configuration value (via stdout)
proj_selector_get_config() {
    local var_name="$1"
    local default_value="$2"
    local value="${!var_name}"
    echo "${value:-$default_value}"
}

# Load project selector configuration from environment
proj_selector_load_config() {
    export TMUX_PROJ_SELECT_LAUNCH_KEY=$(proj_selector_get_config "TMUX_PROJ_SELECT_LAUNCH_KEY" "$DEFAULT_LAUNCH_KEY")
    export TMUX_PROJ_SELECT_CMD=$(proj_selector_get_config "TMUX_PROJ_SELECT_CMD" "$DEFAULT_CMD")
    export TMUX_PROJ_SELECT_DIR=$(proj_selector_get_config "TMUX_PROJ_SELECT_DIR" "$DEFAULT_DIR")
    export TMUX_PROJ_SELECT_HISTORY_FILE=$(proj_selector_get_config "TMUX_PROJ_SELECT_HISTORY_FILE" "$DEFAULT_HISTORY_FILE")
}

# Convert project directory to session name
# Args: $1 - project directory path
# Returns: sanitized session name (via stdout)
proj_selector_session_name() {
    local project_dir="$1"
    local basename=$(get_basename "$project_dir")
    sanitize_identifier "$basename"
}

# Find all projects in configured directories
# Args: $@ - array of parent directories
# Returns: list of project directories (via stdout), prioritized by recent usage
proj_selector_find_projects() {
    local dirs=("$@")
    local all_projects=$(find_directories_multi "${dirs[@]}")

    # Get recent projects that exist in current search results
    local recent_projects=$(history_list_existing | grep -Fx -f <(echo "$all_projects") 2>/dev/null || true)

    # Get projects not in history
    local other_projects=$(echo "$all_projects" | grep -Fxv -f <(echo "$recent_projects") 2>/dev/null || echo "$all_projects")

    # Output recent projects first, then others
    if [[ -n "$recent_projects" ]]; then
        echo "$recent_projects"
    fi
    if [[ -n "$other_projects" ]]; then
        echo "$other_projects"
    fi
}

# Present project list with fzf for selection
# Args: $@ - array of parent directories
# Returns: selected project path (via stdout)
proj_selector_select_with_fzf() {
    local dirs=("$@")
    proj_selector_find_projects "${dirs[@]}" | fzf
}

# Create or switch to project session
# Args: $1 - project directory, $2 - command to run after session creation
# Returns: 0 if successful, 1 if failed
proj_selector_open_project() {
    local project_dir="$1"
    local cmd="$2"

    local session_name=$(proj_selector_session_name "$project_dir")

    if ! tmux_session_exists "$session_name"; then
        tmux_create_session "$session_name" "$project_dir"

        if is_not_empty "$cmd"; then
            tmux_send_keys "$session_name" "$cmd"
        fi
    fi

    # Add to history after successful session creation/switch
    history_add "$project_dir"

    tmux_switch_to "$session_name"
}

# Fallback: attach to first available session with chooser
# Used when switching to project fails
proj_selector_fallback_attach() {
    local first_session=$(tmux_get_first_session)
    if is_not_empty "$first_session"; then
        tmux_attach "$first_session"
        tmux_choose_tree
    fi
}

# Main interactive project selection flow
# Args: $1 - space-separated directories to search, $2 - command to run
# Returns: 0 if successful, exits on error
proj_selector_interactive() {
    local dirs_config="$1"
    local cmd="$2"

    # Validate inputs
    validate_required "$dirs_config" "DIRS" || exit 1
    validate_required "$cmd" "CMD" || exit 1

    # Expand directory paths
    local expanded_dirs=$(expand_path "$dirs_config")

    # Parse into array
    IFS=' ' read -r -a dir_array <<< "$expanded_dirs"

    # Select project with fzf
    local selected_project=$(proj_selector_select_with_fzf "${dir_array[@]}")

    # Exit if no selection
    if is_empty "$selected_project"; then
        exit 1
    fi

    # Open project or fallback
    proj_selector_open_project "$selected_project" "$cmd" || proj_selector_fallback_attach
}

# Direct project selection (no fzf, direct path)
# Args: $1 - project directory path, $2 - command to run (optional)
# Returns: 0 if successful, exits on error
proj_selector_direct() {
    local project_dir="$1"
    local cmd="$2"

    # Validate input
    validate_required "$project_dir" "PROJECT_DIR" || exit 1

    # Open project or fallback
    proj_selector_open_project "$project_dir" "$cmd" || proj_selector_fallback_attach
}
