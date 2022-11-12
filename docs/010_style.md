# Style

## Capitalization

- Environment variables that are passed into and exported out of the script are written in UPPERCASE.
- Local variables that are used within the script are written in lowercase.
- Hence, no need to keep track of environment variables so you don't overwrite them.
- No need to resort to LOCAL_FOO variable names either.

## Automatically deleting temporary files on exit

Use an event handler to automatically remove temporary files on exit.

```bash
#!/bin/bash

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
#!/bin/bash
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
