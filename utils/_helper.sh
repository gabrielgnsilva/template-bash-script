#!/bin/bash

#==============================================================================
# HEADER
#==============================================================================
#
# NAME
#    Helper
#
# SYNOPSIS
#    display_usage_help
#    display_full_help
#
# DESCRIPTION
#    This script is designed to be sourced and provides reusable functions
#    to display a help message for the main script, base on its header.
#
# Usage
#    display_usage_help             Display usage help.
#
#    display_full_help              Display a full help.
#
# EXAMPLE
#    display_usage_help
#
#==============================================================================
# END_OF_HEADER
#==============================================================================

function _display_help() {

    local help_option="${1}"
    case "${help_option}" in
        "usage" ) filter="^#+[ ]*" ;;
        "full"  ) filter="^#[%/)+]" ;;
    esac

    command head -"${script_head:-99}" "${0}"                         \
        | command grep --regexp="${filter}"                           \
        | command sed --expression="s/${filter}//g"                   \
            --expression="s/\${script_name}:/Usage: ${script_name}/g" \
        | command sed --expression="s/${filter}//g"                   \
            --expression="s/\${script_name}/${script_name}/g"
}

function display_usage_help() {

    _display_help "usage"
}

function display_full_help() {

    _display_help "full"
}
