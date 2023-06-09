#!/bin/bash

#=======================================================================
# HEADER
#=======================================================================
# NAME
#       Check Dependency(ies)
#
#=======================================================================
# SYNOPSIS
#       checkDependencies [OPTION] [PROGRAM..]
#
#=======================================================================
# DESCRIPTION
#       This is a Bash script that provides a function called
#       checkDependencies. The purpose of this function is to check for
#       missing dependencies by using the "command -v" command. The
#       script takes one or more program names as arguments and checks
#       if each program is available in the system.
#
#=======================================================================
# OPTIONS
#       -c, --critical      Used to exit the script if the dependency
#                           is not found.
#
#=======================================================================
# DEPENDENCIES
#       Script "utils/_validateArguments.sh"
#           Handles arguments validation
#
#=======================================================================
# EXAMPLE
#       checkDependencies "git"
#       checkDependencies "zip" "unzip" --critical
#
#=======================================================================
# END_OF_HEADER
#=======================================================================

function _checkPrograms() {

    missingDependencies=()
    foundDependencies=()

    local i
    for i in "${@}"; do
        if ! command -v "${i}" > /dev/null 2>&1 ; then
            missingDependencies+=( "${i}" )
            continue
        fi
        foundDependencies+=( "${i}" )
    done
}

function checkDependencies() {

    if [[ "${#}" -lt 1 ]]; then
        printf "checkDependencies: missing required\n" >&2
        printf "e.g, $ checkDependencies zip unzip --critical\n" >&2
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
        printf "checkDependencies: missing required\n" >&2
        printf "e.g, $ checkDependencies zip unzip --critical\n" >&2
        exit 1
    fi

    validateArguments "${dependencies[@]}" --if-empty --special-chars
    _checkPrograms "${dependencies[@]}"

    if [[ "${#foundDependencies[@]}" -gt 0 ]]; then
        printf "checkDependencies: found dependency(ies): "
        printf "'%s'." "${foundDependencies[*]}"
    fi

    if [[ "${#missingDependencies[@]}" -gt 0 ]]; then
        printf "checkDependencies: couldn't find " >&2
        printf "'%s'." "${missingDependencies[*]}" >&2
    fi

    if [[ "${do_exit:-}" == 1 && "${#missingDependencies[@]}" -gt 0 ]]; then
        printf "checkDependencies: make sure the program(s) are installed." >&2
        exit 127
    fi
}
