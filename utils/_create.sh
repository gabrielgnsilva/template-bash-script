#!/bin/bash

#=======================================================================
# HEADER
#=======================================================================
# NAME
#       Create
#
#=======================================================================
# SYNOPSIS
#       create [OPTION] [PATH..]
#
#=======================================================================
# DESCRIPTION
#       This script is designed to be sourced and provides a reusable
#       function to check if a file or folder exists before creating it,
#       ignoring if true.
#
#=======================================================================
# OPTIONS
#       -f, --file          Create a file along with its
#                           parents directory, if not found
#
#       -d, --directory     Create a fodler along with its
#                           parents directory, if not found
#
#=======================================================================
# DEPENDENCIES
#       Script "utils/_validateArguments.sh"
#           Handles arguments validation
#
#=======================================================================
# EXAMPLE
#    create --file "PATH/TO/FILE"
#    create --directory "PATH/TO/DIRECTORY" "PATH/TO/OTHER/DIRECTORY"
#
#=======================================================================
# END_OF_HEADER
#=======================================================================

function create(){

    if [[ "${#}" -lt 1 ]]; then
        printf "create: missing required argument\n" >&2
        printf "e.g, $ create --directory PATH/TO/DIR\n" >&2
        printf "e.g, $ create --file PATH/TO/FILE" >&2
        exit 1
    fi

    local createFile
    local createDirectory
    local paths=()

    while [[ "${#}" -gt 0 ]]; do
        case "${1:-}" in
            -f | --file )
                createFile=1
                ;;
            -d | --directory )
                createDirectory=1
                ;;
            * )
                paths+=( "${1}" )
                ;;
        esac
        shift
    done

    if [[ "${createFile:-}" -eq "${createDirectory:-}" ]]; then
        printf "create: choose only one operation\n" >&2
        printf "e.g, $ create --directory PATH/TO/DIR\n" >&2
        printf "e.g, $ create --file PATH/TO/FILE\n" >&2
        exit 1
    fi

    if [[ "${#paths[@]}" -eq 0 ]]; then
        printf "create: missing required argument\n" >&2
        printf "e.g, $ create --directory PATH/TO/DIR\n" >&2
        printf "e.g, $ create --file PATH/TO/FILE\n" >&2
        exit 1
    fi

    validateArguments "${paths[@]}" --if-empty --special-chars

    local i
    for i in "${paths[@]}"; do
        if [[ "${createFile:-}" == 1 ]]; then

            if [[ -f "${i}" ]]; then
                printf "create: skipping file '%s': already found\n" "${i}"
                continue
            fi

            mkdir --parents "$(dirname "${i}")" \
                && touch "${i}"

            printf "create: Created file '%s'\n" "${i}"
        fi

        if [[ "${createDirectory:-}" == 1 ]]; then

            if [[ -d "${i}" ]]; then
                printf "create: skipping directory "
                printf "'%s': already found.\n" "${i}"
                continue
            fi

            mkdir --parents "${i}"

            printf "Created directory '%s'\n" "${i}"
        fi
    done
}
