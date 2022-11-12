# Style

## Capitalization

- Environment variables that are passed into and exported out of the script are written in UPPERCASE.
- Local variables that are used within the script are written in lowercase.
- Hence, no need to keep track of environment variables so you don't overwrite them.
- No need to resort to LOCAL_FOO variable names either.

## Invocation - which bash?

A surprising amount of systems do not have `/bin/bash`, or run a different Bash binary that's stored elsewhere on the system. This is especially the case with the BSDs, where I've ever only seen Bash in `/usr/local/bin`, *MacOS*, which ships with an ancient version of Bash that serious users will replace with Bash from Homebrew, and with *NixOS*, where `/bin` is empty by design.

This document will therefore standardize on

```bash
#!/usr/bin/env bash
```

in all examples.

## Automatically deleting temporary files on exit

Use an event handler to automatically remove temporary files on exit.

```bash
#!/usr/bin/env bash

function cleanup(){
	trap - INT QUIT TERM EXIT
	rm -f "$tmpfile1"
	rm -f "$tmpfile1"
}
trap cleanup INT QUIT TERM EXIT

tmpfile1="$(mktemp)"
tmpfile1="$(mktemp)"

echo "$tmpfile1"
echo "$tmpfile2"
```

## Trapping errors verbosely

```bash
#!/usr/bin/env bash
set -o errexit
function errorexit() {
        trap - ERR
        printf "Error on line %s\n" "$(caller)"
        exit 1
}
trap errorexit ERR
```

* [https://www.gnu.org/software/bash/manual/bash.html#Signals](https://www.gnu.org/software/bash/manual/bash.html#Signals)
* [https://www.gnu.org/software/bash/manual/bash.html#index-trap](https://www.gnu.org/software/bash/manual/bash.html#index-trap)

## Establishing who you are

Finding the name of the script itself and the directory where it is stored.

```bash
#!/usr/bin/env bash
set -o errexit

me_path="$(readlink -f "$0")"
me_dir="$(dirname "${me_path}")"
me_base="$(basename "${me_path}")"

source "${me_dir}/config.conf"
printf "%s is up and running.\n" "${me_base}"
```

