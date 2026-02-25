# TMUX Project Select

tmux-proj-select is a tmux plugin that provides a fast, fzf-powered project switcher. It creates (or attaches to) a dedicated tmux session per project, and remembers your most recently accessed projects so they appear at the top of the list.

## Requirements

- [tmux](https://github.com/tmux/tmux)
- [fzf](https://github.com/junegunn/fzf)

## Installation

Using [TPM](https://github.com/tmux-plugins/tpm), add the following line to the `.tmux.conf`

```bash
set -g @plugin 'safv12/tmux-proj-select'
```

## Usage

1. Press the tmux prefix (usually `C-b`) followed by `C-p` (or your configured key) from within any tmux session
2. A popup appears with a fuzzy-searchable list of projects
3. Select a project — the plugin creates or switches to a tmux session for it
4. Newly created sessions automatically run the configured command (default: `nvim`)

## Features

- Displays the list of projects in a popup window
- **Recently used projects prioritized** — your most recently accessed projects appear first in the list
- Configurable command run on new session creation (default: `nvim`)

## Configuration

| Variable                      | Default                        | Description                                 |
| ----------------------------- | ------------------------------ | ------------------------------------------- |
| TMUX_PROJ_SELECT_LAUNCH_KEY   | `C-p`                          | Keybinding to trigger project selection     |
| TMUX_PROJ_SELECT_DIR          | `~/dev`                        | Space separated list of directories         |
| TMUX_PROJ_SELECT_CMD          | `nvim`                         | Command to run right after session creation |
| TMUX_PROJ_SELECT_HISTORY_FILE | `~/.tmux-proj-select-history`  | Location of the project history file        |

Add overrides to your `.tmux.conf`:

```bash
set-environment -g TMUX_PROJ_SELECT_LAUNCH_KEY "C-p"
set-environment -g TMUX_PROJ_SELECT_DIR "~/dev ~/work"
set-environment -g TMUX_PROJ_SELECT_CMD "nvim"
```

## CLI Usage

`bin/proj_select` opens a project directly without fzf, useful for scripting or aliases:

```bash
./bin/proj_select /path/to/project
```

This creates (or attaches to) a tmux session for the given directory and runs the configured command.

## Recent Projects (MRU)

The plugin automatically tracks your recently used projects and displays them first in the fzf list. This makes switching between frequently accessed projects much faster.

**How it works:**
- Every time you open a project, it's added to the history
- Recent projects appear at the top of the selection list
- History persists across tmux sessions
- Keeps up to 100 recent projects

**Managing history:**

The history is stored in `~/.tmux-proj-select-history` by default. You can:

```bash
# View history
cat ~/.tmux-proj-select-history

# Clear history
rm ~/.tmux-proj-select-history

# Use custom history location
set-environment -g TMUX_PROJ_SELECT_HISTORY_FILE "/custom/path/history"
```
