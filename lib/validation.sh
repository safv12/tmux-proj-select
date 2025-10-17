#!/bin/bash
# Validation utilities - generic validation functions

# Validate required argument is not empty
# Args: $1 - value to validate, $2 - argument name for error message
# Returns: 0 if valid, exits with error if invalid
validate_required() {
    local value="$1"
    local name="$2"

    if [ -z "$value" ]; then
        echo "Error: $name is required but was empty" >&2
        return 1
    fi
    return 0
}

# Validate directory exists
# Args: $1 - directory path, $2 - argument name for error message
# Returns: 0 if valid, 1 if invalid
validate_directory() {
    local dir="$1"
    local name="$2"

    if [ ! -d "$dir" ]; then
        echo "Error: $name directory '$dir' does not exist" >&2
        return 1
    fi
    return 0
}

# Validate file exists
# Args: $1 - file path, $2 - argument name for error message
# Returns: 0 if valid, 1 if invalid
validate_file() {
    local file="$1"
    local name="$2"

    if [ ! -f "$file" ]; then
        echo "Error: $name file '$file' does not exist" >&2
        return 1
    fi
    return 0
}
