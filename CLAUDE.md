# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

tmux-proj-select is a TMUX plugin that provides a project selector interface using fzf. It allows users to quickly switch between projects by creating or attaching to TMUX sessions.

## Architecture

The plugin uses a highly modular architecture that separates generic utilities from domain-specific logic:

### Core Scripts (Entry Points)
1. **proj-select.tmux** - Main plugin entry point that registers the keybinding with TMUX
2. **select.sh** - Interactive project selector entry point (sources domain/proj_selector.sh)
3. **bin/proj_select** - CLI utility for direct project selection (sources domain/proj_selector.sh)

### Library Modules (`lib/`) - Generic, Reusable Utilities
These are framework-agnostic utilities that can be used by any feature:

- **string.sh** - String manipulation (replace_char, sanitize_identifier, is_empty, etc.)
- **tmux.sh** - TMUX operations (session management, switching, listing, key sending)
- **filesystem.sh** - File/directory operations (expand_path, find_directories, etc.)
- **validation.sh** - Input validation (validate_required, validate_directory, etc.)

### Domain Modules (`domain/`) - Feature-Specific Logic
Business logic for specific features, built using lib utilities:

- **proj_selector.sh** - Project selector feature implementation
  - Configuration management (defaults, loading env vars)
  - Project discovery and selection with fzf
  - Session name generation from project paths
  - Interactive and direct project opening flows
  - Fallback attach logic

### Flow

**Interactive Selection (`select.sh`):**
1. User triggers keybinding (default: `C-p`) → TMUX launches `select.sh` in a popup
2. `select.sh` calls `proj_selector_interactive()` from `domain/proj_selector.sh`
3. Domain layer validates inputs, expands paths using `lib/filesystem.sh`
4. Searches directories and presents via fzf using `proj_selector_select_with_fzf()`
5. Creates/switches to session using `lib/tmux.sh` utilities
6. Session names derived from directory basenames via `lib/string.sh` (dots → underscores)

**Direct Selection (`bin/proj_select`):**
1. Called with directory path argument
2. Calls `proj_selector_direct()` from `domain/proj_selector.sh`
3. Validates input, creates session, switches directly without fzf

### Configuration Variables

The plugin reads three environment variables (set in `.tmux.conf`):
- `TMUX_PROJ_SELECT_LAUNCH_KEY` - Keybinding (default: `C-p`)
- `TMUX_PROJ_SELECT_DIR` - Space-separated list of parent directories to search (default: `~/dev`)
- `TMUX_PROJ_SELECT_CMD` - Command to run after session creation (default: `nvim`)

### Layered Design Philosophy

**lib/** → Generic utilities (no business logic, reusable across features)
- Pure functions with single responsibilities
- No knowledge of project selector domain
- Can be tested independently
- Example: `tmux_session_exists()` just checks session existence

**domain/** → Feature implementations (compose lib utilities)
- Business logic for specific features
- Orchestrates lib utilities to implement workflows
- Example: `proj_selector_open_project()` uses `tmux_session_exists()`, `tmux_create_session()`, etc.

**Core scripts** → Thin entry points
- Minimal logic, just source domain and call functions
- Example: `select.sh` just calls `proj_selector_interactive()`

## Adding New Features

The modular architecture makes it easy to extend functionality:

### Adding Generic Utilities
Add to `lib/` when the function is reusable across features:

**Example: Add git repository detection to `lib/filesystem.sh`:**
```bash
is_git_repo() {
    local dir="$1"
    [ -d "$dir/.git" ]
}
```

### Adding Feature-Specific Logic
Add to `domain/` for business logic specific to a feature:

**Example: Create `domain/session_manager.sh` for session operations:**
```bash
#!/bin/bash
source "$(dirname "${BASH_SOURCE[0]}")/../lib/tmux.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../lib/string.sh"

session_manager_list_all() {
    tmux_list_sessions "#{session_name}: #{session_windows} windows"
}

session_manager_delete() {
    local session_name="$1"
    if tmux_session_exists "$session_name"; then
        tmux kill-session -t "$session_name"
    fi
}
```

### Adding New Commands
Create entry point scripts in `bin/` that source domain modules:

**Example: `bin/session_manager`:**
```bash
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../domain/session_manager.sh"

session_manager_list_all
```

### Guidelines
1. **Generic utilities** → `lib/` (no business logic)
2. **Feature workflows** → `domain/` (compose lib utilities)
3. **Entry points** → Root scripts or `bin/` (thin wrappers)
4. All domain modules should source required lib utilities
5. Keep functions focused on single responsibilities

## Testing

### Integration Testing
1. Install via TPM in a test TMUX environment
2. Run `./select.sh "~/dev" "nvim"` to test interactive selector
3. Run `./bin/proj_select /path/to/project` to test direct selection

### Unit Testing Utilities
Test lib utilities in isolation by sourcing them:
```bash
source lib/string.sh
result=$(sanitize_identifier "my.project")
echo "$result"  # Should output: my_project

source lib/tmux.sh
if tmux_session_exists "test_session"; then
    echo "Session exists"
fi
```

### Domain Testing
Test domain logic by sourcing and calling functions:
```bash
source domain/proj_selector.sh
session_name=$(proj_selector_session_name "/path/to/my.project")
echo "$session_name"  # Should output: my_project
```
