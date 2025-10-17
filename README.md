# TMUX Project Select

A project selector for TMUX. This plugin allows changing projects by creating a new session for project launched.

## Installation

Using [TPM](https://github.com/tmux-plugins/tpm), add the following line to the `.tmux.conf`

```bash
set -g @plugin 'safv12/tmux-proj-select'
```

## Features

- Displays the list of projects in a popup window
- **Recently used projects prioritized** - Your most recently accessed projects appear first in the list
- Allows select the desired command when the new session is created. The default command is `nvim`.

## Configurations

| Variable                    | Default                          | Description                                 |
| --------------------------- | -------------------------------- | ------------------------------------------- |
| TMUX_PROJ_SELECT_LAUNCH_KEY | `C-p`                            | Keybinding to trigger project selection     |
| TMUX_PROJ_SELECT_DIR        | `~/dev ~/.config`                | Space separated list of directories         |
| TMUX_PROJ_SELECT_CMD        | `nvim`                           | Command to run right after session creation |
| TMUX_PROJ_SELECT_HISTORY_FILE | `~/.tmux-proj-select-history` | Location of the project history file        |

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
