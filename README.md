# TMUX Project Select

A project selector for TMUX. This plugin allows changing projects by creating a new session for project launched.

## Feature

- Displays the list of projects in a popup window
- Allows select the desired command when the new session is created. The default command is `nvim`.

## Configurations

| ENV name           | Default | Description                               |
| ------------------ | ------- | ----------------------------------------- |
| PROJECT_SELECT_DIR | `~/dev` | Root directory for all the projects       |
| PROJECT_SELECT_CMD | `nvim`  | Default command when creating the session |
