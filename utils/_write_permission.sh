#!/bin/bash

#==============================================================================
# HEADER
#==============================================================================
#
# NAME
#    Write Permission
#
# SYNOPSIS
#    has_write_permission [ARGUMENT]
#
# DESCRIPTION
#    This script is designed to be sourced and provides a reusable
#    function that checks if the user has permission to write on a given path
#    or any of its parent directories. If the path doesn't exist, the script
#    will check one level down util it returns 0, indicating that the user has
#    permission to write in the path, or 1, indicating that the user doesn't
#    have write permission.
#
# EXAMPLE
#    has_write_permission "/path/to/file"
#    has_write_permission "/path/to/folder"
#    has_write_permission "$HOME/path/to/folder"
#    has_write_permission "path/to/folder"
#
#==============================================================================
# END_OF_HEADER
#==============================================================================

_check_write_permission() {

    local dir="${1}"

    if [[ ! -w "${dir}" ]]; then
        return 1
    else
        return 0
    fi
}

has_write_permission() {

    if [[ "${#}" -ne 1 ]]; then
        command printf "Missing required argument to 'has_write_permission()' near line %s\n" "${BASH_LINENO[0]}"
        command printf "e.g, $ has_write_permission path/to/file"
        exit 1
    fi

    local dir="${1}"
    local parent_dir

    while true; do
        if _check_write_permission "${dir}"; then
            return 0
        fi

        parent_dir=$(dirname "${dir}")

        if [[ "${parent_dir}" == "${dir}" ]]; then
            return 1
        fi

        dir="${parent_dir}"
    done
}
