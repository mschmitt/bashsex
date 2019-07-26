# Guide to Bash Scripting Exellence

Calm down. This is nothing more than a cheat sheet for me and a bunch of 
friends and colleagues. 

* Primary site: https://team-frickel.de/bashsex/
* Github: https://github.com/mschmitt/bashsex.git
* Bash Reference Manual: https://www.gnu.org/software/bash/manual/bash.html

## Beautification

### Automatically deleting temporary files on exit

Use an event handler to automatically remove temporary files on exit.

Example: tmp-autoclean.sh

* https://www.gnu.org/software/bash/manual/bash.html#Signals
* https://www.gnu.org/software/bash/manual/bash.html#index-trap

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

This uses parameter transformation to create a declare command that could
be used to recreate the given data.

Example: parameter-transform.sh

* https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion

## Avoidance of external processes 

### Search and replace

#### Don't: Waste time and processes using traditional tools such as *grep* or *sed*. 

I've done this so many times, it's embarrassing.

Example: grep-sed.sh

#### Do: Use built-in regex matching and/or *bash* Parameter Expansion.

Example: search-replace-bash.sh

* https://www.gnu.org/software/bash/manual/bash.html#index-_005b_005b
* https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching
* https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion

### *while* loop: Variable scope

#### Don't: Pipe through *while* loop. 

Piping through a *while* loop creates a subprocess and all variables set 
within the *while* loop are forgotten afterwards.

Example: pipe-through-while.sh

#### Do: Use process substition. 

*<(foo)* in places where one would normally read from a file replaces the 
file with the output from process *foo*. An additional *<* for input 
redirection is still required, just like when reading from a file.

Example: while-process-substitution.sh

* https://www.gnu.org/software/bash/manual/bash.html#Process-Substitution

### looping over results from *sed*, *awk* and other streaming editing tools

#### Don't: Execute *awk*, *sed*, *tr* repeatedly within a loop.

Example: sed-inside-loop.sh

#### Do: Avoid repeated execution by making the edit outside the loop. 

Execution speed will be significantly higher. 

Example: sed-outside-loop.sh

#### See also: Bash native pattern replacement.

Example: native-replace.sh

* https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion

### Splitting input

#### Don't: Split input by using external commands such as *awk* or *cut*.

Example: split-awk-cut.sh

#### Do: Use *read* to split directly into fields of an array and work from there.

Example: split-array.sh

* https://www.gnu.org/software/bash/manual/bash.html#index-read
* https://www.gnu.org/software/bash/manual/bash.html#Word-Splitting

### Length of a string

#### Don't: By all means don't use *wc*. 

If you believe you do have to use *wc*, 
don't waste further resources by parsing it's output through *awk*, but use
*wc*'s native option for the byte or character count. I've seen (and DONE!) 
this countless times and I have no idea if this ever, in any long-forgotten 
era, was the reasonable thing to do.

Example: length-wc.sh

#### Do: Use *bash* Parameter Expansion. 

It returns the length in characters, with multi-byte characters counted 
according to the *LANG* environment.

Example: length-bash.sh

* https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion

### Execute *n* times

#### Don't: Use *seq*.

Example: n-times-seq.sh

#### Do: Use a *for* loop

...just like you would everywhere else. Don't expect any performance gain,
though.

Example: n-times-for.sh

* https://www.gnu.org/software/bash/manual/bash.html#index-for

### *bash* Loadables

Check out the *bash* loadables in your OS distribution. Use of these comes at 
the cost of a loss of portability, though, because the loadables may be
installed in differing directories.

#### Without Loadables

Example: basename-dirname-traditional.sh

#### With Loadables

Example: basename-dirname-loadable.sh

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
