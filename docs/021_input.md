# Input Magic

Not sure how to categorize this.

Everybody knows heredocs:

```bash
$ rotix <<Here
> Lorem ipsum dolor sit amet, consectetur adipiscing elit,
> sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
> Here
Yberz vcfhz qbybe fvg nzrg, pbafrpgrghe nqvcvfpvat ryvg,
frq qb rvhfzbq grzcbe vapvqvqhag hg ynober rg qbyber zntan nyvdhn.
```

## Heredoc Indentation

Contrary to popular belief, Heredocs don't need to be outdented within blocks, by prefixing the End pattern with a -.

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

# Process Substitution

Process substitution allows a process’s input or output to be referred to using a filename.

Extremely useful where you would usually pass a file but only have an input stream.

```bash
$ diff /etc/services <(ssh 192.168.1.35 cat /etc/services)
```

- [https://www.gnu.org/software/bash/manual/bash.html#Process-Substitution](https://www.gnu.org/software/bash/manual/bash.html#Process-Substitution)

