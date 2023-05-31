#!/bin/bash

#==============================================================================
# HEADER
#==============================================================================
#
# NAME
#    Countdown
#
# SYNOPSIS
#    do_countdown [seconds]
#
# DESCRIPTION
#    This script is designed to be sourced and provides a reusable function
#    that perform a countdown for the specified number of seconds.
#
# DEPENDENCIES
#    Script "utils/_logger.sh"      Handles logging.
#
# EXAMPLE
#    do_countdown 15
#
#==============================================================================
# END_OF_HEADER
#==============================================================================

# shellcheck disable=SC2120
function do_countdown() {

    if [[ "${#}" -ne 1 ]]; then
        error "Missing required argument(s) to 'do_countdown()' near line ${BASH_LINENO[0]}."
        error "e.g, $ do_countdown 15  # In seconds"
        exit 1
    fi

    if [[ ! "${1}" =~ ^[0-9]+$ ]]; then
        error "'do_countdown()' requires a number to countdown from, near line ${BASH_LINENO[0]}."
        error "e.g, $ do_countdown 5  # In seconds"
        exit 1
    fi

    local seconds="${1}"

    warning "Continuing in: ${seconds}s."

    local i
    for ((i = seconds ; i > -1 ; i--)); do
        command printf "\rCountdown: %s seconds remaining." "${i}"
        sleep 1
    done
}
