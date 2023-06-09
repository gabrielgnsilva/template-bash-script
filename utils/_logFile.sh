#!/bin/bash

#=======================================================================
# HEADER
#=======================================================================
# NAME
#       Logger
#
#=======================================================================
# SYNOPSIS
#       logFile --type=<LOG_TYPE> MESSAGE..
#
#=======================================================================
# DESCRIPTION
#       This script is designed to be sourced and provides a reusable
#       function, that handles logging on the terminal and a log file.
#
#=======================================================================
# DEPENDENCIES
#       "${scriptLogLevel}"     Must be initialized from main program.
#
#       "${scriptLogFile}"      Custom log file location.
#                               Must be initialized from main program.
#
#=======================================================================
# EXAMPLE
#    logFile --type=warning "WARNING MESSAGE"
#    logFile --type=error "ERROR MESSAGE"
#    printf "ERROR MESSAGE" 2>&1 | logFile --type=critical
#
#=======================================================================
# END_OF_HEADER
#=======================================================================

function _logUsage(){
    {
        printf "Usage: 'logFile --type=debug MESSAGE'\n\n"
        printf "OPTIONS\n"
        printf "%s\n" "--type=critical    Log as critical"
        printf "%s\n" "--type=error       Log as error"
        printf "%s\n" "--type=warning     Log as warning"
        printf "%s\n" "--type=info        Log as info"
        printf "%s\n" "--type=trace       Log as trace"
        printf "%s\n" "--type=debug       Log as trace"
    } >&2
}

function _validLogType() {

    if [[ "${#}" -ne 1 ]]; then
        printf "_validLogType: No argument or too much arguments\n" >&2
        prinf "eg: _validLogType <TYPE>\n" >&2
        exit 1
    fi

    if [[ "${logLevels[*],,}" == *"${1?}"* ]]; then
        return 0
    fi

    return 1
}

function _logFromPipe() {
    for i in "${pipedMessage[@]}"; do
        case "${logLevel}" in
            0 | 3 ) printf "%s: %s\n" "${logFormat}" "${i}" >&2 ;;
            *     ) printf "%s: %s\n" "${logFormat}" "${i}"     ;;
        esac
    done
}

_logFromArgs() {
    case "${logLevel}" in
        0 | 3 ) printf "%s: %s\n" "${logFormat}" "${message[*]}" >&2 ;;
        *     ) printf "%s: %s\n" "${logFormat}" "${message[*]}"     ;;
    esac
}

function logFile() {

    if [[ "${#}" -lt 1 ]]; then
        _logUsage
        exit 1
    fi

    local logLevels=(
        "CRITICAL" "0"  "[!]"
        "ERROR"    "3"  "[X]"
        "WARNING"  "6"  "[W]"
        "INFO"     "9"  "[-]"
        "DEBUG"    "12" "[+]"
        "TRACE"    "15" "[>]"
    )

    local i
    local logLevel
    local logType
    local logIcon
    local logDate
    local logFormat
    local match
    local message=()
    local pipedMessage=()

    while [[ "${#}" -gt 0 ]]; do
        case "${1:-}" in
            --type=* )
                if [[ -n "${logType:-}" ]]; then
                    { printf "logFile: choose only one log type !\n"
                    printf "eg: '%s'\n" "logFile --type=critical MESSAGE"
                    } >&2
                    exit 1
                fi

                if ! _validLogType "${1#--type=}"; then
                    _logUsage
                    exit 1
                fi

                logType="${1#--type=}"
                ;;
            * )
                message+=( "${1}" )
                ;;
        esac
        shift
    done

    if [[ -z "${logType}" ]]; then
        _logUsage
        exit 1
    fi

    if [[ -p "/dev/stdin" ]]; then
        while IFS= read -r line; do
            pipedMessage+=( "${line}" )
        done
    fi

    if [[ "${#message[@]}" -eq 0 && "${#pipedMessage[@]}" -eq 0 ]]; then
        _logUsage
        exit 1
    fi

    for i in "${!logLevels[@]}"; do
        if [[ "${logLevels[$i],,}" == "${logType}" ]]; then
            logLevel="${i}"
            break
        fi
    done

    logIcon="${logLevels[$(( logLevel + 2 ))]}"
    logDate="$(date +"%Y/%m/%d %H:%M:%S")"

    logFormat="[${logDate}] ${logIcon}"

    if [[ "$(( scriptLogLevel * 3 ))" -ge "${logLevel}" ]]; then
        _logFromArgs | tee --append "${scriptLogFile:-logs/.log}"
        _logFromPipe | tee --append "${scriptLogFile:-logs/.log}"
    fi
}
