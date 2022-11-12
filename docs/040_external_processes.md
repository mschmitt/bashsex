## Avoidance of external processes

### Search and replace

#### Don't: Waste time and processes using traditional tools such as *grep* or *sed*.

I've done this so many times, it's embarrassing.

```bash
#!/usr/bin/env bash

for word in "foo" "bar" "baz"
do
	echo $word | grep -q "bar"
	if [[ $? -eq 0 ]]
	then
		echo "$word" | sed 's/bar/BAR/'
	else
		echo "$word"
	fi
done
```

#### Do: Use built-in regex matching and/or *bash* Parameter Expansion.

```bash
#!/usr/bin/env bash

for word in "foo" "bar" "baz"
do
	if [[ "$word" =~ bar ]]
	then
		echo "${word//bar/BAZ}"
	else
		echo "$word"
	fi
done
```

* [https://www.gnu.org/software/bash/manual/bash.html#index-_005b_005b](https://www.gnu.org/software/bash/manual/bash.html#index-_005b_005b)
* [https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)
* [https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion)

### *while* loop: Variable scope

#### Don't: Pipe through *while* loop.

Piping through a *while* loop creates a subprocess and all variables set within the *while* loop are forgotten afterwards.

```bash
#!/usr/bin/env bash

# Count the lines in some random input

lines=0
dd if=/dev/urandom count=1000 | strings | while read line
do
	let lines+=1
	echo "Read lines: $lines"
done

# Back to outer process: lines is 0 again, oops.
echo "Total lines: $lines"
```

#### Do: Use process substition.

*<(foo)* in places where one would normally read from a file replaces the file with the output from process *foo*. An additional *<* for input redirection is still required, just like when reading from a file.

```bash
#!/usr/bin/env bash

# Count the lines in some random input

lines=0
while read -r line
do
	let lines+=1
	echo "Read lines: $lines"
done < <(dd if=/dev/urandom count=1000 | strings)

# lines has never been used in a different process scope now.
echo "Total lines: $lines"
```

* [https://www.gnu.org/software/bash/manual/bash.html#Process-Substitution](https://www.gnu.org/software/bash/manual/bash.html#Process-Substitution)

### looping over results from *sed*, *awk* and other streaming editing tools

#### Don't: Execute *awk*, *sed*, *tr* repeatedly within a loop.

```bash
#!/usr/bin/env bash

# Substitute something in some random input
while read -r input
do
	input=$(echo "$input" | sed 's/foo/bar/g')
done < <(dd if=/dev/urandom count=1000)
```

#### Do: Avoid repeated execution by making the edit outside the loop.

Execution speed will be significantly higher.

```bash
#!/usr/bin/env bash

# Substitute something in some random input
while read -r input
do
	true # nothing
done < <(dd if=/dev/urandom count=1000 | sed 's/foo/bar/g')
```

#### See also: Bash native pattern replacement.

```bash
#!/usr/bin/env bash

# Native bash pattern replacement

foo="foo"
bar=${foo//foo/bar}

echo $foo $bar
```

* [https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion)

* https://www.gnu.org/software/bash/manual/bash.html#Word-Splitting)

### Length of a string

#### Don't: By all means don't use *wc*.

If you believe you do have to use *wc*, don't waste further resources by parsing it's output through *awk*, but use
*wc*'s native option for the byte or character count. I've seen (and DONE!) this countless times and I have no idea if this ever, in any long-forgotten era, was the reasonable thing to do.

```bash
#!/usr/bin/env bash

# UTF-8 multibyte characters
string="ÄÖÜ" 
characters=$(echo -n "$string" | wc -m)     # 3 Characters
bytes=$(echo -n "$string" | wc -c)          # 6 Bytes


printf "%s (%s characters, %s bytes)\n" "$string" "$characters" "$bytes"
```

#### Do: Use *bash* Parameter Expansion.

It returns the length in characters, with multi-byte characters counted
according to the *LANG* environment.

```bash
#!/usr/bin/env bash

# UTF-8 multibyte characters
string="ÄÖÜ" 
LANG='C.utf8'     characters=${#string}     # 3 Characters
LANG='C'          bytes=${#string}          # 6 Bytes

printf "%s (%s characters, %s bytes)\n" "$string" "$characters" "$bytes"
```

* [https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion)

### Execute *n* times

#### Don't: Use *seq*.

```bash
#!/usr/bin/env bash

for i in $(seq 1 10)
do
	echo "$i"
done
```

#### Do: Use a *for* loop

...just like you would everywhere else. Don't expect any performance gain, though.

```bash
#!/usr/bin/env bash

for (( i=1 ; i<=10 ; i++ ))
do
	echo "$i"
done
```

* [https://www.gnu.org/software/bash/manual/bash.html#index-for](https://www.gnu.org/software/bash/manual/bash.html#index-for)

### *bash* Loadables

Check out the *bash* loadables in your OS distribution. Use of these comes at the cost of a loss of portability, though, because the loadables may be installed in differing directories. (Or not at all.)

#### Without Loadables

```bash
#!/usr/bin/env bash

while read -r FILE
do
	BASENAME="$(basename "$FILE")"
	DIRNAME="$(dirname "$FILE")"
	FILESIZE="$(stat --format '%s' "$FILE")"
	printf "%s (%s bytes) in %s\n" "$BASENAME" "$FILESIZE" "$DIRNAME"
done < <(find /usr/lib -type f)
```

#### With Loadables

```bash
#!/usr/bin/env bash

# Enable loadable bash extensions
BASH_LOADABLES_PATH=/usr/lib/bash:/usr/local/lib/bash
enable -f basename basename
enable -f dirname dirname
enable -f finfo finfo

while read -r FILE
do
	BASENAME="$(basename "$FILE")"
	DIRNAME="$(dirname "$FILE")"
	FILESIZE="$(finfo -s "$FILE")"
	printf "%s (%s bytes) in %s\n" "$BASENAME" "$FILESIZE" "$DIRNAME"
done < <(find /usr/lib -type f)
```

* [https://www.gnu.org/software/bash/manual/bash.html#index-enable](https://www.gnu.org/software/bash/manual/bash.html#index-enable)
