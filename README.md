# Shellscript Template

This is a template for a shell script.

## Synopsis

```bash
script_name [Options..] [Arguments..]
```

## Options

- -h, --help: Display help message and exit.
- -l, --log-file: Custom log file location. Default is '/dev/null'.
- -L, --log-level: Change the log level. Default is '3'.
  - 0: Log only CRITICAL messages.
  - 1: Log CRITICAL and ERROR messages.
  - 2: Log CRITICAL, ERROR, and WARNING messages.
  - 3: Log CRITICAL, ERROR, WARNING, and INFO messages.
  - 4: Log CRITICAL, ERROR, WARNING, INFO, and DEBUG messages.
  - 5: Log CRITICAL, ERROR, WARNING, INFO, DEBUG, and TRACE messages.
- -o, --option: Do nothing.

## Example

```bash
script_name --help
script_name -l script.log -L 5 --option
```

## Utils

- Script "utils/_check_dependencies.sh": Check for missing dependencies.
- Script "utils/_common_utils.sh": Handles errors and logging on common commands.
- Script "utils/_create.sh": Creates a file or a folder if it does not exist.
- Script "utils/_do_countdown.sh": Perform a countdown for the specified number of seconds.
- Script "utils/_helper.sh": Handles the help messages, either full or usage, from the info on this header.
- Script "utils/_logger.sh": Handles logging.
- Script "utils/_trapper.sh": Trap errors, exit, and interrupt signals to run some cleanup code.
- Script "utils/_validate_arguments.sh": Used to validate a string or argument.
- Script "utils/_write_permission.sh": Used to check if the user has write permission on a given folder.
