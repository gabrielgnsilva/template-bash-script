#!/bin/bash

#==============================================================================
# HEADER
#==============================================================================
#
# NAME
#    Validate Argument(s)
#
# SYNOPSIS
#    validate_arguments [OPTION..] [ARGUMENT..]
#
# DESCRIPTION
#    This script is designed to be sourced and provides a reusable
#    function that checks either if a argument(s) start with a hyphen (-)
#    or is(are) empty.
#
# OPTIONS
#    -s, --special-chars            Check if argument(s) starts with a
#                                   hyphen (-), should exit if true.
#
#    -e, --if-empty                 Check if argument(s) is empty,
#                                   should exit if true.
#
# DEPENDENCIES
#    "utils/_logger.sh"             Handles logging.
#
# EXAMPLE
#    validate_arguments "-arg1" "arg2" --if-empty
#    validate_arguments "" "-arg2" --if-empty --special-chars
#
#==============================================================================
# END_OF_HEADER
#==============================================================================

function validate_arguments() {

    if [[ "${#}" -lt 1 ]]; then
        error "Missing required argument to 'validade_str()' near line ${BASH_LINENO[0]}."
        error "e.g, $ validate_arguments zip -unzip "" --special-chars --empty"
        exit 1
    fi

    local do_exit
    local special
    local empty
    local args=()
    local badargs_empty=()
    local badargs_special=()

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
        error "Missing required arguments(s) to 'validate_arguments()' near line ${BASH_LINENO[0]}"
        error "e.g, $ validate_arguments [argument...] --special-chars --if-empty"
        exit 1
    fi

    local i
    for i in "${args[@]}"; do

        if [[ "${i}" =~ ^- ]]; then
            badargs_special+=( "${i}" )
        fi

        if [[ -z "${i}" ]]; then
            badargs_empty+=( "${i}" )
        fi
    done

    if [[ "${special:-}" == 1 && "${#badargs_special[@]}" -gt 0 ]]; then
        error "The argument(s) \"${badargs_special[*]}\", cannot start with a hyphen (-) near line ${BASH_LINENO[1]}."
        do_exit=1
    fi

    if [[ "${empty:-}" == 1 && "${#badargs_empty[@]}" -gt 0 ]]; then
        error "The argument(s) '${badargs_empty[*]}', cannot be empty near line ${BASH_LINENO[1]}."
        do_exit=1
    fi

    if [[ "${do_exit:-}" == 1 ]]; then
        exit 1
    fi
}
