# Input/Output

## Heredocs

Everybody knows *Heredocs*:

```bash
$ rotix <<Here
> Lorem ipsum dolor sit amet, consectetur adipiscing elit,
> sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
> Here
Yberz vcfhz qbybe fvg nzrg, pbafrpgrghe nqvcvfpvat ryvg,
frq qb rvhfzbq grzcbe vapvqvqhag hg ynober rg qbyber zntan nyvdhn.
```

### Heredoc Indentation

Contrary to popular belief, *heredocs* don't need to be outdented within blocks, by prefixing the End pattern with a -.

```bash
#!/bin/bash

if true
then
        rotix <<-Here
        Lorem ipsum dolor sit amet, consectetur adipiscing elit,
        sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
        Here
fi
```

- [https://www.gnu.org/software/bash/manual/bash.html#Here-Documents](https://www.gnu.org/software/bash/manual/bash.html#Here-Documents)

### Heredoc Quoting

```bash
$ cat <<Here
> My name is $LOGNAME
> Running on $(uname -s)
> Here
My name is martin
Running on Linux
```

```bash
$ cat <<"Here"
> My name is $LOGNAME
> Running on $(uname -s)
> Here
My name is $LOGNAME
Running on $(uname -s)
```


## Here Strings

Bash also knows here strings, for passing input without echoing through a pipe:

```bash
$ rotix <<<'Lorem Ipsum'
Yberz Vcfhz

$ figlet <<<'Lorem Ipsum'
 _                               ___
| |    ___  _ __ ___ _ __ ___   |_ _|_ __  ___ _   _ _ __ ___
| |   / _ \| '__/ _ \ '_ ` _ \   | || '_ \/ __| | | | '_ ` _ \
| |__| (_) | | |  __/ | | | | |  | || |_) \__ \ |_| | | | | | |
|_____\___/|_|  \___|_| |_| |_| |___| .__/|___/\__,_|_| |_| |_|
                                    |_|

```

- [https://www.gnu.org/software/bash/manual/bash.html#Here-Strings](https://www.gnu.org/software/bash/manual/bash.html#Here-Strings)

## Process Substitution

Process substitution allows a process’s input or output to be referred to using a filename.

Extremely useful where you would usually pass a file but only have an input stream.

```bash
$ diff /etc/services <(ssh 192.168.1.35 cat /etc/services)
```

- [https://www.gnu.org/software/bash/manual/bash.html#Process-Substitution](https://www.gnu.org/software/bash/manual/bash.html#Process-Substitution)

## Splitting input

#### Don't: Split input by using external commands such as *awk* or *cut*.

```bash
#!/bin/bash

while read -r LINE
do
	# Uses 2 subprocesses each:
	servicename=$(echo "$LINE" | cut -f 1)
	serviceport=$(echo "$LINE" | awk '{print $2}')
	printf "%s on %s\n" "$serviceport" "$serviceport"
done < /etc/services
```

#### Do: Use *read* to split directly into fields of an array and work from there.

```bash
#!/bin/bash

while read -a fields -r 
do
	# Uses no subprocess at all
	servicename=${fields[0]}
	serviceport=${fields[1]}
	printf "%s on %s\n" "$servicename" "$serviceport"
done < /etc/services
```

* [https://www.gnu.org/software/bash/manual/bash.html#index-read](https://www.gnu.org/software/bash/manual/bash.html#index-read)
* [https://www.gnu.org/software/bash/manual/bash.html#Word-Splitting](

