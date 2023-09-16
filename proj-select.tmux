#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Customizations
PROJ_DIR="${PROJECT_SELECT_DIR:-~/Dev}"
DEFAULT_CMD="${PROJECT_SELECT_CMD:-nvim}"

tmux bind-key C-p display-popup -E "$CURRENT_DIR/select.sh $PROJ_DIR $DEFAULT_CMD"
