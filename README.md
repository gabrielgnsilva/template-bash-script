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

This script uses a DEBUG trap when "_initLogger" is called, which prints the output of all commands to a log file, and by default it also does not print stderr and stdout on the terminal, unless explicitly told to.

To print command output on the terminal, redirect the output to FD3:

```bash
#!/bin/bash

command >&3

# Some commands like package managers output to both stdout and stderr
# and may ask for user input. In this case, redirect both FD1 and FD2
# to FD3, otherwise the user will not be aware of the command asking
# for input.

command >&3 2>&3
```

If you need to display a text on the terminal, you can use the function "println", which redirects printf to FD3, thus making it easier to type and distinguish which text get shown to the user:

```bash
#!/bin/bash

function println() {

  command printf "%b\n" "${*}" >&3
}

println "Output to the terminal"
```

You can use the function "log" to ouput a formated log message, prefixed with "+++" and the line number to the log file:

```bash
#!/bin/bash

function log() {

  command printf "+++ (%s): %b\n" "${BASH_LINENO[0]}" "${*}"
}

log "Output to the log file"
```

Otherwise, use echo or printf command without a FD set.

## Prompting

When presenting a user or a system with a specific message, question, or request in order to elicit a response or input, make sure to also redirect the message to FD3, otherwise the prompt message will not output to the user:

```bash
#!/bin/bash

read -r -p "Input: " ans 2>&3

read -r -p "$(printf "Input: " >&3)" ans
```

If you need to request input from the user, you can use the function "prompt", which redirects printf to FD3, thus making it easier to redirect multiple prompts:

```bash
#!/bin/bash

function prompt() {
  command printf "%s" "${*}" >&3
}

read -r -p "$(prompt "Input: ")" ans
```

## Utils

- Script "utils/_checkDependencies.sh": Check for missing dependencies.
- Script "utils/_create.sh": Creates a file or a folder if it does not exist.
- Script "utils/_doCountdown.sh": Perform a countdown for the specified number of seconds.
- Script "utils/_displayHelp.sh": Handles the help messages, either full or usage, from the info on this header.
- Script "utils/_validateArguments.sh": Used to validate a string or argument.
- Script "utils/_hasWritePermission.sh": Used to check if the user has write permission on a given folder.
