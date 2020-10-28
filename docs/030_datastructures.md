## Data Structures

I used to say that once you find you need data structures it's time to move on to a complete scripting language, but *bash* nowadays actually does have arrays and hashes, and I consider it a challenge to make good use of them.

* [https://www.gnu.org/software/bash/manual/bash.html#Arrays](https://www.gnu.org/software/bash/manual/bash.html#Arrays)

### Arrays (indexed Arrays)

#### Initialization

Initialize with values:

```bash
thearray=("1 One" "2 Two" "3 Three" "4 Four")
```

Initialize an empty array:

```bash
declare -a thearray
```

#### Accessing values

Number of Values:

```bash
$ echo ${#thearray[*]}
4
```

First and last Value:

```bash
$ echo "${thearray[0]}"
1 One
$ echo "${thearray[-1]}"
4 Four
```

#### Iterating over all Values

Right:

```bash
$ for element in "${thearray[@]}"; do echo "${element}"; done
1 One
2 Two
3 Three
4 Four
```

Wrong:

```bash
$ for ELEMENT in ${thearray[@]}; do echo "${element}"; done
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

```bash
$ unset thearray[2]
$ for element in "${thearray[@]}"; do echo "${element}"; done
1 One
2 Two
4 Four
$ echo ${#thearray[*]}
3
```

Add:

```bash
$ thearray+=("5 Five")
$ for element in "${thearray[@]}"; do echo "${element}"; done
1 One
2 Two
4 Four
5 Five
```

#### Concatenate and Slice

Concatenate:

```bash
$ array2=("6 Six" "7 Seven")
$ thearray=("${thearray[@]}" "${array2[@]}")
$ for element in "${thearray[@]}"; do echo "${element}"; done
1 One
2 Two
4 Four
5 Five
6 Six
7 Seven
```

Slice:

```bash
$ thearray=("${thearray[@]:0:2}" "3 Three" "${thearray[@]:2:4}")

$ for element in "${thearray[@]}"; do echo "${element}"; done
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

```bash
$ declare -A thehash
$ thehash=(["Month 1"]="January" ["Month 2"]="February")
$ thehash["Month 3"]="March"
```

#### Accessing Values

```bash
$ echo ${thehash["Month 1"]}
January
```

#### Iterating over all Values

```bash
$ for key in "${!thehash[@]}"; do printf "%s -> %s\n" "$key" "${thehash["$key"]}"; done
Month 2 -> February
Month 3 -> March
Month 1 -> January
```

#### Deleting Values

```bash
$ unset thehash["Month 3"]
```

### Showing contents of an indexed or associative array

This uses parameter transformation to create a *declare* command that could be used to recreate the given data.

```bash
#!/bin/bash

declare -A thehash
thehash=(["Month 1"]="January" ["Month 2"]="February")
thearray=("1 One" "2 Two" "3 Three" "4 Four")

echo "${thehash[@]@A}"
echo "${thearray[@]@A}"
```

* [https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion)