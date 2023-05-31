#!/bin/bash

#==============================================================================
# HEADER
#==============================================================================
#
# NAME
#    Logger
#
# SYNOPSIS
#    LOGLEVEL [Message..]
#
# DESCRIPTION
#    This script is designed to be sourced and provides reusable functions,
#    that handles logging on the terminal and a log file.
#
# DEPENDENCIES
#    "${script_loglevel}"           Must be initialized from the main program.
#                                   Changes the log level, default is '3':
#                                       0 -> Log only CRITICAL messages.
#                                       1 -> Log CRITICAL and ERROR messages.
#                                       2 -> Log CRITICAL, ERROR and WARNING
#                                            messages.
#                                       3 -> Log CRITITAL, ERROR, WARNING and
#                                            INFO messages.
#                                       4 -> Log CRITICAL, ERROR, WARNING,
#                                            INFO and DEBUG messages.
#                                       5 -> log CRITICAL, ERROR, WARNING,
#                                            INFO, DEBUG and TRACE messages.
#
#    "${script_loglevel}"           Must be initialized from the main program.
#                                   Custom log file location.
#                                   Default is '/dev/null'.
#
# EXAMPLE
#    warning "WARNING MESSAGE"
#    error "ERROR MESSAGE"
#
#==============================================================================
# END_OF_HEADER
#==============================================================================

function log() {

    local loglevel_list
    local logicon
    local logdate
    local logterminal_fmt
    local logfile_fmt
    local caller

    loglevel_list=(
        "CRITICAL" "[!]"
        "ERROR"    "[X]"
        "WARNING"  "[W]"
        "INFO"     "[-]"
        "DEBUG"    "[+]"
        "TRACE"    "[>]"
    )

    logicon="${loglevel_list[$(( ${1} + 1 ))]}"
    logdate="$(command date +"%Y/%m/%d %H:%M:%S")"
    logterminal_fmt="[${logdate}] ${logicon}: ${2}"

    if [[ "${FUNCNAME[2]}" =~ ^(do_.*|check_dependencies) ]]; then
        caller=3
    fi

    if [[ "${FUNCNAME[2]}" =~ ^(validate_arguments|create) ]]; then
        caller=4
    fi

    logfile_fmt="[${logdate}] ${loglevel_list[${1}]} ${logicon} @${FUNCNAME[${caller:-2}]}(): ${2}"

    if [[ "$(( ${script_loglevel:-3} * 2 ))" -ge "${1}" ]]; then
        case "${1}" in
            0 | 1 ) command printf "%s\n" "${logterminal_fmt}" >&2 ;;
            *     ) command printf "%s\n" "${logterminal_fmt}"     ;;
        esac
    fi

    command echo "${logfile_fmt}" >> "${script_logfile:-/dev/null}" # \
        #| command fold --width=79 --spaces \
        #| command sed --expression '2,$s/^/    /' >> "${script_logfile:-/dev/null}"
}

function critical() {

    log "0" "${1}"
}

function error() {

    log "2" "${1}"
}

function warning() {

    log "4" "${1}"
}

function inf() {

    log "6" "${1}"
}

function debug() {

    log "8" "${1}"
}

function trace() {

    log "10" "${1}"
}
