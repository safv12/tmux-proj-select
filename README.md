# TMUX Project Select

A project selector for TMUX. This plugin allows changing projects by creating a new session for project launched.

## Feature

- Displays the list of projects in a popup window
- Allows select the desired command when the new session is created. The default command is `nvim`.

## Configurations

| Variable                    | Default       | Description                                 |
| --------------------------- | ------------- | ------------------------------------------- |
| TMUX_PROJ_SELECT_LAUNCH_KEY | `<prefix>C-o` | Keybinding to trigger project selection     |
| TMUX_PROJ_SELECT_DIR        | `~/Dev`       | Root directory for all the projects         |
| TMUX_PROJ_SELECT_CMD        | `nvim`        | Command to run right after session creation |
