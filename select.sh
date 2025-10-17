#!/bin/bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/domain/proj_selector.sh"

proj_selector_interactive "$1" "$2"
