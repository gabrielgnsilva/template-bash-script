#!/bin/bash

#=======================================================================
# HEADER
#=======================================================================
# NAME
#       Validate Argument(s)
#
#=======================================================================
# SYNOPSIS
#       validateArguments [OPTION..] [ARGUMENT..]
#
#=======================================================================
# DESCRIPTION
#       This script is designed to be sourced and provides a reusable
#       function that checks either if a argument(s) start with a hyphen
#       (-) or is(are) empty.
#
#=======================================================================
# OPTIONS
#       -s, --special-chars     Check if argument(s) starts with a
#                               hyphen (-), should exit if true.
#
#       -e, --if-empty          Check if argument(s) is empty,
#                               should exit if true.
#
#=======================================================================
# EXAMPLE
#       validateArguments "-arg1" "arg2" --if-empty
#       validateArguments "" "-arg2" --if-empty --special-chars
#
#==============================================================================
# END_OF_HEADER
#==============================================================================

function validateArguments() {

    if [[ "${#}" -lt 1 ]]; then
        printf "validade_str: missing required argument\n" >&2
        printf "e.g, $ validateArguments -unzip '' --if-empty\n" >&2
        exit 1
    fi

    local doExit
    local special
    local empty
    local args=()
    local badargsEmpty=()
    local badargsSpecial=()

    while [[ "${#}" -gt 0 ]]; do
        case "${1:-}" in
            -s | --special-chars )
                special=1
                ;;
            -e | --if-empty )
                empty=1
                ;;
            * )
                args+=( "${1}" )
                ;;
        esac
        shift
    done

    if [[ "${#args[@]}" == 0 ]]; then
        printf "validade_str: missing required argument\n" >&2
        printf "e.g, $ validateArguments -unzip '' --if-empty\n" >&2
        exit 1
    fi

    local i
    for i in "${args[@]}"; do

        if [[ "${i}" =~ ^- ]]; then
            badargsSpecial+=( "${i}" )
        fi

        if [[ -z "${i}" ]]; then
            badargsEmpty+=( "${i}" )
        fi
    done

    if [[ "${special:-}" == 1 && "${#badargsSpecial[@]}" -gt 0 ]]; then
        printf "The argument(s) '%s', " "${badargsSpecial[*]}" >&2
        printf "cannot start with a hyphen (-)\n" >&2
        doExit=1
    fi

    if [[ "${empty:-}" == 1 && "${#badargsEmpty[@]}" -gt 0 ]]; then
        printf "The argument(s) '%s', " "${badargsEmpty[*]}" >&2
        printf "cannot be empty\n" >&2
        doExit=1
    fi

    if [[ "${doExit:-}" == 1 ]]; then
        exit 1
    fi
}
