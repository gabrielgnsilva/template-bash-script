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

## Utils

- Script "utils/_checkDependencies.sh": Check for missing dependencies.
- Script "utils/_create.sh": Creates a file or a folder if it does not exist.
- Script "utils/_doCountdown.sh": Perform a countdown for the specified number of seconds.
- Script "utils/_displayHelp.sh": Handles the help messages, either full or usage, from the info on this header.
- Script "utils/_validateArguments.sh": Used to validate a string or argument.
- Script "utils/_hasWritePermission.sh": Used to check if the user has write permission on a given folder.
