#!/bin/bash

#==============================================================================
# HEADER
#==============================================================================
#
# NAME
#    Check Dependency(ies)
#
# SYNOPSIS
#    check_dependency [OPTION] [PROGRAM..]
#
# DESCRIPTION
#    This is a Bash script that provides a function called check_dependencies.
#    The purpose of this function is to check for missing dependencies by using
#    the "command -v" command. The script takes one or more program names
#    as arguments and checks if each program is available in the system.
#
# OPTIONS
#    -c, --critical                 Used to exit the script if the dependency
#                                   is not found.
#
# DEPENDENCIES
#    Script "utils/_logger.sh"          Handles logging.
#    Script "utils/_validate_arg.sh"    Handles arguments validation.
#
# EXAMPLE
#    check_dependencies "git"
#    check_dependencies "zip" "unzip" --critical
#
#==============================================================================
# END_OF_HEADER
#==============================================================================

function check_programs() {

    missing_dependencies=()
    found_dependencies=()

    local i
    for i in "${@}"; do
        if ! command -v "${i}" > /dev/null 2>&1 ; then
            missing_dependencies+=( "${i}" )
            continue
        fi
        found_dependencies+=( "${i}" )
    done
}

function check_dependencies() {

    if [[ "${#}" -lt 1 ]]; then
        error "Missing required argument(s) to 'check_dependency()' near line ${BASH_LINENO[0]}."
        error "e.g, $ check_dependencies zip unzip --critical"
        exit 1
    fi

    local do_exit
    local dependencies=()

    while [[ "${#}" -gt 0 ]]; do
        case "${1:-}" in
            -c | --critical )
                do_exit=1
                ;;
            * )
                dependencies+=( "${1}" )
                ;;
        esac
        shift
    done

    if [[ "${#dependencies[@]}" -eq 0 ]]; then
        error "Missing required argument(s) to 'check_dependency()' near line ${BASH_LINENO[0]}"
        error "e.g, $ check_dependencies zip unzip --critical"
        exit 1
    fi

    validate_arguments "${dependencies[@]}" --if-empty --special-chars
    check_programs "${dependencies[@]}"

    if [[ "${#found_dependencies[@]}" -gt 0 ]]; then
        debug "Found dependency(ies): '${found_dependencies[*]}'."
    fi

    if [[ "${#missing_dependencies[@]}" -gt 0 ]]; then
        error "Missing dependency(ies): Couldn't find '${missing_dependencies[*]}'."
    fi

    if [[ "${do_exit:-}" == 1 && "${#missing_dependencies[@]}" -gt 0 ]]; then
        error "Make sure the program(s) are installed."
        exit 127
    fi
}
