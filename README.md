# Shellscript Template

This is a template for a shell script.

## Synopsis

```bash
./install [OPTION]... [ARGUMENT]...
```

## Options

- -h, --help
  - Display a help message and exit
- -v, --version
  - Display version information and exit
- -l, --log-file
  - Custom log file location
- -o, --option
  - Do nothing

## Example

```bash
./install --help
./install -l script.log --option
```

## Logging

This script uses a trap on DEBUG when _initLogger is called,
which prints the output of all commands to a log file, and
by default it also does not print stderr and stdout
on the terminal, unless explicitly told to.

If you need to print a text on the terminal, redirect the
output do FD3:

```bash
#!/bin/bash

command >&3
```

or use the function "println", which redirects printf to FD3:

```bash
#!/bin/bash

function println() {

  command printf "%b\n" "${*}" >&3
}

println "Output to the terminal"
```

You can use the function "log" to ouput a formated log
message, prefixed with "+++" and the line number to the
log file. Otherwise, use echo or printf command without a
FD set.

```bash
#!/bin/bash

function log() {

  command printf "+++ (%s): %b\n" "${BASH_LINENO[0]}" "${*}"
}

log "Output to the log file"
```

## Utils

- Script "utils/_checkDependencies.sh": Check for missing dependencies.
- Script "utils/_create.sh": Creates a file or a folder if it does not exist.
- Script "utils/_doCountdown.sh": Perform a countdown for the specified number of seconds.
- Script "utils/_displayHelp.sh": Handles the help messages, either full or usage, from the info on this header.
- Script "utils/_validateArguments.sh": Used to validate a string or argument.
- Script "utils/_hasWritePermission.sh": Used to check if the user has write permission on a given folder.
