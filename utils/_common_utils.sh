#!/bin/bash

#==============================================================================
# HEADER
#==============================================================================
#
# NAME
#    Common Utilities
#
# SYNOPSIS
#    DO_COMMAND [OPTION..] [ARGUMENTS..]
#
# DESCRIPTION
#    This is a Bash script that provides several reusable functions for common
#    operations like changing directories (cd), copying files (cp),
#    moving files (mv), creating directories (mkdir), creating files (touch),
#    creating symbolic links (ln), removing files (rm), and printing formatted
#    output (printf). These functions handle logging and error reporting
#    to both the terminal and a log file. They also include debug and critical
#    logging levels, providing information about the execution status of
#    each function.
#
# OPTIONS
#    do_cd                          Changes the current directory to the
#                                   specified path (see cd(1) man page).
#
#    do_cp                          Copies files or directories from a source
#                                   path to a destination path
#                                   (see cp(1) man page).
#
#    do_mv                          Moves files or directories from a source
#                                   path to a destination path
#                                   (see mv(1) man page).
#
#    do_mkdir                       Creates a directory at the specified path
#                                   (see mkdir(1) man page).
#
#    do_touch                       Creates an empty file at the
#                                   specified path (see touch(1) man page).
#
#    do_ln                          Creates a symbolic link from a source file
#                                   to a destination path (see ln(1) man page).
#
#    do_rm                          Removes files or directories
#                                   at the specified path (see rm(1) man page).
#
#    do_input                       Prints text without a newline character.
#                                   (see print(1) man page)
#
#    do_printf                      Prints formatted text with a newline
#                                   character (see print(1) man page).
#
#==============================================================================
# END_OF_HEADER
#==============================================================================

# shellcheck disable=SC2015
function do_cd() {

    local exitcode

    command cd "${@}" \
        && {
            exitcode="${?}"
            debug "'do_cd ${*}' exit status ${exitcode}, executed near line ${BASH_LINENO[0]}."
        } \
        || {
            exitcode="${?}"
            critical "'do_cd ${*}' exit status ${exitcode}, failed near line ${BASH_LINENO[0]}."
            exit "${exitcode}"
        }
}

# shellcheck disable=SC2015
function do_cp() {

    local exitcode

    command cp "${@}" \
        && {
            exitcode="${?}"
            debug "'do_cp ${*}' exit status ${exitcode}, executed near line ${BASH_LINENO[0]}."
        } \
        || {
            exitcode="${?}"
            critical "'do_cp ${*}' exit status ${exitcode}, failed near line ${BASH_LINENO[0]}."
            exit "${exitcode}"
        }
}

# shellcheck disable=SC2015
function do_mv() {

    local exitcode

    command mv "${@}" \
        && {
            exitcode="${?}"
            debug "'do_mv ${*}' exit status ${exitcode}, executed near line ${BASH_LINENO[0]}."
        } \
        || {
            exitcode="${?}"
            critical "'do_mv ${*}' exit status ${exitcode}, failed near line ${BASH_LINENO[0]}."
            exit "${exitcode}"
        }
}

# shellcheck disable=SC2015
function do_mkdir() {

    local exitcode

    command mkdir "${@}" \
        && {
            exitcode="${?}"
            debug "'do_mkdir ${*}' exit status ${exitcode}, executed near line ${BASH_LINENO[0]}."
        } \
        || {
            exitcode="${?}"
            error "'do_mkdir ${*}' exit status ${exitcode}, failed near line ${BASH_LINENO[0]}."
        }
}

# shellcheck disable=SC2015
function do_touch() {

    local exitcode

    command touch "${@}" \
        && {
            exitcode="${?}"
            debug "'do_touch ${*}' exit status ${exitcode}, executed near line ${BASH_LINENO[0]}."
        } \
        || {
            exitcode="${?}"
            critical "'do_touch ${*}' exit status ${exitcode}, failed near line ${BASH_LINENO[0]}."
            exit "${exitcode}"
        }
}

# shellcheck disable=SC2015
function do_ln() {

    local exitcode

    command ln "${@}" \
        && {
            exitcode="${?}"
            debug "'do_ln ${*}' exit status ${exitcode}, executed near line ${BASH_LINENO[0]}."
        } \
        || {
            exitcode="${?}"
            critical "'do_ln ${*}' exit status ${exitcode}, failed near line ${BASH_LINENO[0]}."
            exit "${exitcode}"
        }
}

# shellcheck disable=SC2015
function do_rm() {

    local exitcode

    command rm "${@}" \
        && {
            exitcode="${?}"
            debug "'do_rm ${*}' exit status ${exitcode}, executed near line ${BASH_LINENO[0]}."
        } \
        || {
            exitcode="${?}"
            error "'do_rm ${*}' exit status ${exitcode}, failed near line ${BASH_LINENO[0]}."
        }
}

function do_printf() {

    command printf "%b" "${*}" 2>/dev/null
}

function do_println() {

    command printf "%b\n" "${*}" 2>/dev/null
}
