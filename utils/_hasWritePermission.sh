#!/bin/bash

#=======================================================================
# HEADER
#=======================================================================
# NAME
#       Write Permission
#
#=======================================================================
# SYNOPSIS
#       hasWritePermission FILE...
#
#=======================================================================
# DESCRIPTION
#       This script is designed to be sourced and provides a reusable
#       function that checks if the user has permission to write on a
#       given path or any of its parent directories. If the path doesn't
#       exist, the script will check one level down util it returns 0,
#       indicating that the user has permission to write in the path,
#       or 1, indicating that the user doesn't have write permission.
#
#=======================================================================
# EXAMPLE
#       hasWritePermission "/path/to/file"
#       hasWritePermission "/path/to/folder"
#       hasWritePermission "$HOME/path/to/folder"
#       hasWritePermission "path/to/folder"
#
#=======================================================================
# END_OF_HEADER
#=======================================================================

hasWritePermission() {

    if [[ "${#}" -ne 1 ]]; then
        printf "hasWritePermission: missing required argument\n" >&2
        printf "e.g, $ hasWritePermission path/to/file\n" >&2
        exit 1
    fi

    local dir="${1}"
    local parentDir

    while true; do
        if [[ -w "${dir}" ]]; then
            return 0
        fi

        parentDir=$(dirname "${dir}")
        if [[ "${parentDir}" == "${dir}" ]]; then
            return 1
        fi

        dir="${parentDir}"
    done
}
