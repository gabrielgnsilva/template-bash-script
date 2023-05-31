#!/bin/bash

#==============================================================================
# HEADER
#==============================================================================
#
# NAME
#    Create
#
# SYNOPSIS
#    create [OPTION] [PATH..]
#
# DESCRIPTION
#    This script is designed to be sourced and provides a reusable function
#    to check if a file or folder exists before creating it, ignoring if true.
#
# OPTIONS
#    -f, --file                     Create a file along with its
#                                   parents directory, if not found.
#
#    -d, --directory                Create a fodler along with its
#                                   parents directory, if not found.
#
# DEPENDENCIES
#    Script "utils/_logger.sh"          Handles logging.
#    Script "utils/_validate_arg.sh"    Handles arguments validation.
#    Script "utils/_common_utils.sh"    Handles errors and logging
#                                       on common commands.
#
# EXAMPLE
#    create --file "PATH/TO/FILE"
#    create --directory "PATH/TO/DIRECTORY" "PATH/TO/OTHER/DIRECTORY"
#
#==============================================================================
# END_OF_HEADER
#==============================================================================

function create(){

    if [[ "${#}" -lt 1 ]]; then
        error "Missing required argument to 'create()' near line ${BASH_LINENO[0]}."
        error "e.g, $ create --directory PATH/TO/DIR"
        error "e.g, $ create --file PATH/TO/FILE"
        exit 1
    fi

    local create_file
    local create_directory
    local paths=()

    while [[ "${#}" -gt 0 ]]; do
        case "${1:-}" in
            -f | --file )
                create_file=1
                ;;
            -d | --directory )
                create_directory=1
                ;;
            * )
                paths+=( "${1}" )
                ;;
        esac
        shift
    done

    if [[ "${create_file:-}" -eq "${create_directory:-}" ]]; then
        error "Choose only one operation to use on 'create()' near line ${BASH_LINENO[0]}."
        error "e.g, $ create --directory PATH/TO/DIR"
        error "e.g, $ create --file PATH/TO/FILE"
        exit 1
    fi

    if [[ "${#paths[@]}" -eq 0 ]]; then
        error "Missing required argument to 'create()' near line ${BASH_LINENO[0]}."
        error "e.g, $ create --directory PATH/TO/DIR"
        error "e.g, $ create --file PATH/TO/FILE"
        exit 1
    fi

    validate_arguments "${paths[@]}" --if-empty --special-chars

    local i
    for i in "${paths[@]}"; do
        if [[ "${create_file:-}" == 1 ]]; then

            if [[ -f "${i}" ]]; then
                debug "Skipping file '${i}' at line number ${BASH_LINENO[0]}, already found."
                continue
            fi

            do_mkdir --parents "$(dirname "${i}")" \
                && do_touch "${i}"

            debug "Created file '${i}', line ${BASH_LINENO[0]}"
        fi

        if [[ "${create_directory:-}" == 1 ]]; then

            if [[ -d "${i}" ]]; then
                debug "Skipping directory '${i}' at line number ${BASH_LINENO[0]}, already found."
                continue
            fi

            do_mkdir --parents "${i}"

            debug "Created directory '${i}', line ${BASH_LINENO[0]}"
        fi
    done
}
