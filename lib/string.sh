#!/bin/bash
# String manipulation utilities - generic, reusable string functions

# Replace character in string
# Args: $1 - input string, $2 - character to replace, $3 - replacement character
# Returns: modified string (via stdout)
replace_char() {
    local input="$1"
    local from="$2"
    local to="$3"
    echo "$input" | tr "$from" "$to"
}

# Get basename of path
# Args: $1 - path
# Returns: basename (via stdout)
get_basename() {
    local path="$1"
    basename "$path"
}

# Sanitize string to valid identifier (replace dots and special chars with underscores)
# Args: $1 - input string
# Returns: sanitized string (via stdout)
sanitize_identifier() {
    local input="$1"
    echo "$input" | tr . _
}

# Check if string is empty
# Args: $1 - string to check
# Returns: 0 if empty, 1 if not
is_empty() {
    local str="$1"
    [ -z "$str" ]
}

# Check if string is not empty
# Args: $1 - string to check
# Returns: 0 if not empty, 1 if empty
is_not_empty() {
    local str="$1"
    [ -n "$str" ]
}
