#!/bin/bash

#==============================================================================
# HEADER
#==============================================================================
#
# NAME
#    Trapper
#
# DESCRIPTION
#     This script is designed to be sourced and provides reusable functions,
#     that traps Exit, Interrupt Signal (CTRL + C) and Error.
#
# DEPENDENCIES
#    Script "utils/_logger.sh"          Handles logging.
#    Script "utils/_common_utils.sh"    Handles errors and logging on
#                                       common commands.
#    Variable "${current_dir}"          Must be initialized from the main
#                                       program. It is expected to contain
#                                       the "${PWD}".
#    Variable "${script_params}"        Must be initialized from the main
#                                       program. Should contain
#                                       all parameters used.
#    Variable "${script_tempdir}"       Must be initialized from the main
#                                       program. Should contain a
#                                       Temporary Directory
#    Variable "${script_tempfile}"      Must be initialized from the main
#                                       program. Should contain a
#                                       Temporary File
#
#==============================================================================
# TRAPS
    trap ctrl_c_trapper INT  # Trap CTRL_C and call ctrl_c
    trap err_trapper ERR     # Trap ERR and call err_trapper
    trap exit_trapper EXIT   # Trap EXIT and call exit_trapper
    trap "" SIGTSTP          # Disable CTRL_Z
#
#==============================================================================
# END_OF_HEADER
#==============================================================================

function ctrl_c_trapper() {

    # Disable the ctrl_c trap handler to prevent recursion
    command trap "" INT

    warning "Interrupt signal intercepted! Exiting now..."

    command exit 130
}

function err_trapper() {

    local exit_code="${?}"

    # Disable the error trap handler to prevent recursion
    command trap - ERR

    critical "An exception ocurred near line: ${BASH_LINENO[0]}."
    debug "Script Parameters: '${script_params}'."

    command exit "${exit_code}"
}

function exit_trapper {

    local exit_code="${?}"

    # Disable the exit trap handler to prevent recursion
    command trap - ERR

    do_cd "${current_dir}"
    do_rm --recursive --force "${script_tempdir}" "${script_tempfile}"

    debug "Script terminated with exit status: ${exit_code}"

    command exit "${exit_code}"
}
