#!/bin/bash

#=======================================================================
# HEADER
#=======================================================================
# NAME
#       Countdown
#
#=======================================================================
# SYNOPSIS
#       doCountdown [seconds]
#
#=======================================================================
# DESCRIPTION
#       This script is designed to be sourced and provides a reusable
#       function that perform a countdown for the specified number of
#       seconds.
#
#=======================================================================
# EXAMPLE
#       doCountdown 15
#
#=======================================================================
# END_OF_HEADER
#=======================================================================

# shellcheck disable=SC2120
function doCountdown() {

    if [[ "${#}" -ne 1 ]]; then
        printf "doCountdown: missing required argument(s)\n" >&2
        printf "e.g, $ doCountdown 15  # In seconds\n" >&2
        exit 1
    fi

    if [[ ! "${1}" =~ ^[0-9]+$ ]]; then
        printf "doCountdown: requires a number to countdown from\n" >&2
        printf "e.g, $ doCountdown 5  # In seconds\n" >&2
        exit 1
    fi

    local seconds="${1}"

    printf "Continuing in: %ss\n" "${seconds}"

    local i
    for ((i = seconds ; i > -1 ; i--)); do
        printf "\rCountdown: %s seconds remaining." "${i}"
        sleep 1
    done

    printf "\n"
}
