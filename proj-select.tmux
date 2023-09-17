#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Customizations
[ -z "$TMUX_PROJ_SELECT_LAUNCH_KEY" ] && TMUX_PROJ_SELECT_LAUNCH_KEY="C-o"
[ -z "$TMUX_PROJ_SELECT_CMD" ] && TMUX_PROJ_SELECT_CMD="nvim"
[ -z "$TMUX_PROJ_SELECT_DIR" ] && TMUX_PROJ_SELECT_DIR="~/Dev"

tmux bind-key "$TMUX_PROJ_SELECT_LAUNCH_KEY" display-popup -E "$CURRENT_DIR/select.sh $TMUX_PROJ_SELECT_DIR $TMUX_PROJ_SELECT_CMD"
