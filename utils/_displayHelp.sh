#!/bin/bash

#==============================================================================
# HEADER
#==============================================================================
# NAME
#       Helper
#
#==============================================================================
# DESCRIPTION
#       This script is designed to be sourced and provides reusable
#       functions to display a help message for the main script,
#       base on its header. The script expects the varible "scriptHead"
#       to be set from the main script, containing the length of the
#       scripts's header and the variable "scriptName", which sould
#       contain the script's name.
#
#==============================================================================
# USAGE
#       displayHelpUsage
#           Display usage help.
#
#       displayFullHelp
#           Display a full help.

#       displayVersion
#           Display version information.
#
#==============================================================================
# EXAMPLE
#       displayFullHelp
#
#==============================================================================
# END_OF_HEADER
#==============================================================================

function _displayHelp() {

    local helpOption="${1}"
    local filter
    local header
    local filterheader
    local formatheader


    header="$(head -"${scriptHead:-99}" "${0}")"
    case "${helpOption}" in
        version )
            filter="^#-[ ]*"
            filterheader="$(echo "${header}" | grep --regexp="${filter}")"
            formatheader="$(echo "${filterheader}"     \
                | sed --expression="s/${filter}//g"    \
                    --expression="s/\${scriptName}//g" \
                    --expression="s/Version//g"        \
                    --expression="s/ //g"
            )"

            printf "%b\n" "${formatheader}"
            ;;
        usage )
            filter="^#+[ ]*"
            filterheader="$(echo "${header}" | grep --regexp="${filter}")"
            formatheader="$(echo "${filterheader}"                            \
                | sed --expression="s/${filter}//g"                           \
                    --expression="0,/\${scriptName}/s//Usage: ${scriptName}/" \
                    --expression="s/\${scriptName}/${scriptName}/g"
            )"

            printf "%b\n" "${formatheader}"
            ;;
        * )
            filter="^#[%/)+-]"
            filterheader="$(echo "${header}" | grep --regexp="${filter}")"
            formatheader="$(echo "${filterheader}"                  \
                | sed --expression="s/${filter}//g"                 \
                    --expression="s/\${scriptName}/${scriptName}/g"
            )"

            printf "%b\n" "${formatheader}"
            ;;
    esac
}

function displayHelpUsage() {
    _displayHelp "usage"
}

function displayFullHelp() {
    _displayHelp "full"
}

function displayVersion() {
    _displayHelp "version"
}
