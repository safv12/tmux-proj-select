# TMUX Project Select

A project selector for TMUX. This plugin allows changing projects by creating a new session for project launched.

## Installation

Using [TPM](https://github.com/tmux-plugins/tpm), add the following line to the `.tmux.conf`

```bash
set -g @plugin 'safv12/tmux-proj-select'
```

## Feature

- Displays the list of projects in a popup window
- Allows select the desired command when the new session is created. The default command is `nvim`.

## Configurations

| Variable                    | Default       | Description                                 |
| --------------------------- | ------------- | ------------------------------------------- |
| TMUX_PROJ_SELECT_LAUNCH_KEY | `C-p`         | Keybinding to trigger project selection     |
| TMUX_PROJ_SELECT_DIR        | `~/dev`       | Root directory for all the projects         |
| TMUX_PROJ_SELECT_CMD        | `nvim`        | Command to run right after session creation |
