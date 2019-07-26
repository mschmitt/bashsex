# Guide to Bash Scripting Exellence

Calm down. This is nothing more than a cheat sheet for me and a bunch of
friends and colleagues.

* Primary site: https://team-frickel.de/bashsex/
* Github: https://github.com/mschmitt/bashsex.git
* Bash Reference Manual: https://www.gnu.org/software/bash/manual/bash.html

## Beautification

### Automatically deleting temporary files on exit

Use an event handler to automatically remove temporary files on exit.

Example: *examples/tmp-autoclean.sh*
```
#!/bin/bash

function cleanup(){
	rm -f "$TMPFILE1"
	rm -f "$TMPFILE2"
}
trap cleanup INT QUIT TERM EXIT

TMPFILE1="$(mktemp)"
TMPFILE2="$(mktemp)"

echo "$TMPFILE1"
echo "$TMPFILE2"
```

* https://www.gnu.org/software/bash/manual/bash.html#Signals
* https://www.gnu.org/software/bash/manual/bash.html#index-trap

## Avoid Chained Pipes

Interactive ad-hoc pipes get us through a lot of our daily tasks.
Nevertheless, those anonymous pipes should be avoided in scripts, as for
the reader or later maintainer it's going to be impossible to tell what's
actually happening inside all of this plumbing.

### Don't: Establish cryptic Plumbing

Here's an extremely ad-hoc one-liner that retrieves all mail sizes from a
*Postfix* mail log and calculates a total number of bytes delivered.

```
grep postfix.qmgr /var/log/mail.info | grep size= | while read LINE; do SIZE=$(echo $LINE | sed '/size=/s/^.*size=//' | sed 's/[^0-9].*//'); let TOTALSIZE+=SIZE; echo $TOTALSIZE; done | tail -n 1
```

### Do: Split the lines and add comments

```
sudo grep postfix.qmgr /var/log/mail.info | # qmgr messages from postfix
grep size= | # only lines that contain a size value
while read LINE; # process each line and extract size
do SIZE=$(echo $LINE | sed '/size=/s/^.*size=//' | sed 's/[^0-9].*//')
let TOTALSIZE+=SIZE; echo $TOTALSIZE; done | # add this size to total size
tail -n 1 # show only last line
```

### Do: Get rid of the pipes altogether

Note how the pipe above globally searches for the string *size=* and then
individually for each line makes substitutions around it. We process each
line and use *bash* pattern matching and arithmetics to extract the size
and calculate the total.

Example: *examples/pipefree.sh*
```
#!/bin/bash

REGEX='.*postfix/qmgr.*size=([0-9]+),.*'
while read LINE
do
	if [[ "$LINE" =~ $REGEX ]]
	then
		BYTES=${BASH_REMATCH[1]}
		let TOTAL+=$BYTES
	fi
done < <(sudo cat /var/log/mail.info)

echo $TOTAL
```

### Do: Break the rules

In this special case, a lot can be gained from having the extraction handled by
*sed* again, but we need to execute it only once, on the global input stream,
outside the *while* loop. The obvious downside is that this requires somewhat
solid *sed* skills, which the pure *bash* example above does not.

Example: *examples/pipefree2.sh*
```
#!/bin/bash

while read BYTES
do
	let TOTAL+=$BYTES
done < <(sudo sed -n '/.*postfix\/qmgr.*size=/s/.*postfix\/qmgr.*size=\([0-9][0-9]*\),.*/\1/p' /var/log/mail.info )

echo $TOTAL
```

## Data Structures

I used to say that once you find you need data structures it's time to move
on to a complete scripting language, but *bash* nowadays actually does have
arrays and hashes, and I consider it a challenge to make good use of them.

* https://www.gnu.org/software/bash/manual/bash.html#Arrays

### Arrays (indexed Arrays)

#### Initialization

Initialize with values:

```
THEARRAY=("1 One" "2 Two" "3 Three" "4 Four")
```

Initialize an empty array:

```
declare -a THEARRAY
```

#### Accessing values

Number of Values:

```
$ echo ${#THEARRAY[*]}
4
```

First and last Value:

```
$ echo "${THEARRAY[0]}"
1 One
$ echo "${THEARRAY[-1]}"
4 Four
```

#### Iterating over all Values

Right:

```
$ for ELEMENT in "${THEARRAY[@]}"; do echo "$ELEMENT"; done
1 One
2 Two
3 Three
4 Four
```

Wrong:

```
$ for ELEMENT in ${THEARRAY[@]}; do echo "$ELEMENT"; done
1
One
2
Two
3
Three
4
Four
```

#### Deleting or adding Values

Delete:

```
$ unset THEARRAY[2]
$ for ELEMENT in "${THEARRAY[@]}"; do echo "$ELEMENT"; done
1 One
2 Two
4 Four
$ echo ${#THEARRAY[*]}
3
```

Add:

```
$ THEARRAY+=("5 Five")
$ for ELEMENT in "${THEARRAY[@]}"; do echo "$ELEMENT"; done
1 One
2 Two
4 Four
5 Five
```

#### Concatenate and Slice

Concatenate:

```
$ ARRAY2=("6 Six" "7 Seven")
$ THEARRAY=("${THEARRAY[@]}" "${ARRAY2[@]}")
$ for ELEMENT in "${THEARRAY[@]}"; do echo "$ELEMENT"; done
1 One
2 Two
4 Four
5 Five
6 Six
7 Seven
```

Slice:

```
$ THEARRAY=("${THEARRAY[@]:0:2}" "3 Three" "${THEARRAY[@]:2:4}")

$ for ELEMENT in "${THEARRAY[@]}"; do echo "$ELEMENT"; done
1 One
2 Two
3 Three
4 Four
5 Five
6 Six
7 Seven
```

### Hashes (Associative Arrays)

#### Initialization

*declare* is mandatory for hashes:

```
$ declare -A THEHASH
$ THEHASH=(["Month 1"]="January" ["Month 2"]="February")
$ THEHASH["Month 3"]="March"
```

#### Accessing Values

```
$ echo ${THEHASH["Month 1"]}
January
```

#### Iterating over all Values

```
$ for KEY in "${!THEHASH[@]}"; do printf "%s -> %s\n" "$KEY" "${THEHASH["$KEY"]}"; done
Month 2 -> February
Month 3 -> March
Month 1 -> January
```

#### Deleting Values

```
$ unset THEHASH["Month 3"]
```

### Showing contents of an indexed or associative array

This uses parameter transformation to create a *declare* command that could
be used to recreate the given data.

Example: *examples/parameter-transform.sh*
```
#!/bin/bash

declare -A THEHASH
THEHASH=(["Month 1"]="January" ["Month 2"]="February")
THEARRAY=("1 One" "2 Two" "3 Three" "4 Four")

echo "${THEHASH[@]@A}"
echo "${THEARRAY[@]@A}"
```

* https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion

## Avoidance of external processes

### Search and replace

#### Don't: Waste time and processes using traditional tools such as *grep* or *sed*.

I've done this so many times, it's embarrassing.

Example: *examples/grep-sed.sh*
```
#!/bin/bash

for WORD in "foo" "bar" "baz"
do
	echo $WORD | grep -q "bar"
	if [[ $? -eq 0 ]]
	then
		echo "$WORD" | sed 's/bar/BAR/'
	else
		echo "$WORD"
	fi
done
```

#### Do: Use built-in regex matching and/or *bash* Parameter Expansion.

Example: *examples/search-replace-bash.sh*
```
#!/bin/bash

for WORD in "foo" "bar" "baz"
do
	if [[ "$WORD" =~ bar ]]
	then
		echo "${WORD//bar/BAZ}"
	else
		echo "$WORD"
	fi
done
```

* https://www.gnu.org/software/bash/manual/bash.html#index-_005b_005b
* https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching
* https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion

### *while* loop: Variable scope

#### Don't: Pipe through *while* loop.

Piping through a *while* loop creates a subprocess and all variables set
within the *while* loop are forgotten afterwards.

Example: *examples/pipe-through-while.sh*
```
#!/bin/bash

# Count the lines in some random input

LINES=0
dd if=/dev/urandom count=1000 | strings | while read LINE
do
	let LINES+=1
	echo "Read lines: $LINES"
done

# Back to outer process: LINES is 0 again, oops.
echo "Total lines: $LINES"
```

#### Do: Use process substition.

*<(foo)* in places where one would normally read from a file replaces the
file with the output from process *foo*. An additional *<* for input
redirection is still required, just like when reading from a file.

Example: *examples/while-process-substitution.sh*
```
#!/bin/bash

# Count the lines in some random input

LINES=0
while read -r LINE
do
	let LINES+=1
	echo "Read lines: $LINES"
done < <(dd if=/dev/urandom count=1000 | strings)

# LINES has never been used in a different process scope now.
echo "Total lines: $LINES"
```

* https://www.gnu.org/software/bash/manual/bash.html#Process-Substitution

### looping over results from *sed*, *awk* and other streaming editing tools

#### Don't: Execute *awk*, *sed*, *tr* repeatedly within a loop.

Example: *examples/sed-inside-loop.sh*
```
#!/bin/bash

# Substitute something in some random input
while read -r INPUT
do
	INPUT=$(echo "$INPUT" | sed 's/foo/bar/g')
done < <(dd if=/dev/urandom count=1000)
```

#### Do: Avoid repeated execution by making the edit outside the loop.

Execution speed will be significantly higher.

Example: *examples/sed-outside-loop.sh*
```
#!/bin/bash

# Substitute something in some random input
while read -r INPUT
do
	true # nothing
done < <(dd if=/dev/urandom count=1000 | sed 's/foo/bar/g')
```

#### See also: Bash native pattern replacement.

Example: *examples/native-replace.sh*
```
#!/bin/bash

# Native bash pattern replacement

FOO="foo"
BAR=${FOO//foo/bar}

echo $FOO $BAR
```

* https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion

### Splitting input

#### Don't: Split input by using external commands such as *awk* or *cut*.

Example: *examples/split-awk-cut.sh*
```
#!/bin/bash

while read -r LINE
do
	# Uses 2 subprocesses each:
	SERVICENAME=$(echo "$LINE" | cut -f 1)
	SERVICEPORT=$(echo "$LINE" | awk '{print $2}')
	printf "%s on %s\n" "$SERVICENAME" "$SERVICEPORT"
done < /etc/services
```

#### Do: Use *read* to split directly into fields of an array and work from there.

Example: *examples/split-array.sh*
```
#!/bin/bash

while read -a FIELDS -r 
do
	# Uses no subprocess at all
	SERVICENAME=${FIELDS[0]}
	SERVICEPORT=${FIELDS[1]}
	printf "%s on %s\n" "$SERVICENAME" "$SERVICEPORT"
done < /etc/services
```

* https://www.gnu.org/software/bash/manual/bash.html#index-read
* https://www.gnu.org/software/bash/manual/bash.html#Word-Splitting

### Length of a string

#### Don't: By all means don't use *wc*.

If you believe you do have to use *wc*,
don't waste further resources by parsing it's output through *awk*, but use
*wc*'s native option for the byte or character count. I've seen (and DONE!)
this countless times and I have no idea if this ever, in any long-forgotten
era, was the reasonable thing to do.

Example: *examples/length-wc.sh*
```
#!/bin/bash

# UTF-8 multibyte characters
STRING="ÄÖÜ" 
CHARACTERS=$(echo -n "$STRING" | wc -m)     # 3 Characters
BYTES=$(echo -n "$STRING" | wc -c)          # 6 Bytes


printf "%s (%s characters, %s bytes)\n" "$STRING" "$CHARACTERS" "$BYTES"
```

#### Do: Use *bash* Parameter Expansion.

It returns the length in characters, with multi-byte characters counted
according to the *LANG* environment.

Example: *examples/length-bash.sh*
```
#!/bin/bash

# UTF-8 multibyte characters
STRING="ÄÖÜ" 
LANG='C.utf8'     CHARACTERS=${#STRING}     # 3 Characters
LANG='C'          BYTES=${#STRING}          # 6 Bytes

printf "%s (%s characters, %s bytes)\n" "$STRING" "$CHARACTERS" "$BYTES"
```

* https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion

### Execute *n* times

#### Don't: Use *seq*.

Example: *examples/n-times-seq.sh*
```
#!/bin/bash

for I in $(seq 1 10)
do
	echo "$I"
done
```

#### Do: Use a *for* loop

...just like you would everywhere else. Don't expect any performance gain,
though.

Example: *examples/n-times-for.sh*
```
#!/bin/bash

for (( I=1 ; I<=10 ; I++ ))
do
	echo "$I"
done
```

* https://www.gnu.org/software/bash/manual/bash.html#index-for

### *bash* Loadables

Check out the *bash* loadables in your OS distribution. Use of these comes at
the cost of a loss of portability, though, because the loadables may be
installed in differing directories.

#### Without Loadables

Example: *examples/basename-dirname-traditional.sh*
```
#!/bin/bash

while read -r FILE
do
	BASENAME="$(basename "$FILE")"
	DIRNAME="$(dirname "$FILE")"
	FILESIZE="$(stat --format '%s' "$FILE")"
	printf "%s (%s bytes) in %s\n" "$BASENAME" "$FILESIZE" "$DIRNAME"
done < <(find /usr/lib -type f)
```

#### With Loadables

Example: *examples/basename-dirname-loadable.sh*
```
#!/bin/bash

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

* https://www.gnu.org/software/bash/manual/bash.html#index-enable

## Math

* https://www.gnu.org/software/bash/manual/bash.html#Arithmetic-Expansion
* https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic

### Simple calculation with integers

```
$ echo "$(( 4 / 2 ))"
2
```

But:

> Evaluation is done in fixed-width integers

```
$ echo "$(( 2 / 3 ))"
0
```

### Working with Floats means moving to another language such as awk or perl

```
$ echo $(perl -e '{printf "%.2f", 2/3}')
0.67
```
