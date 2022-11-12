# Math

* [https://www.gnu.org/software/bash/manual/bash.html#Arithmetic-Expansion](https://www.gnu.org/software/bash/manual/bash.html#Arithmetic-Expansion)
* [https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic](https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic)

## Simple calculation with integers

```bash
$ echo "$(( 4 / 2 ))"
2
```

But:

> Evaluation is done in fixed-width integers

```bash
$ echo "$(( 2 / 3 ))"
0
```

## Working with Floats means moving to another language such as awk or perl, or, more traditionally, bc.

```bash
$ echo $(perl -e '{printf "%.2f", 2/3}')
0.67
$ printf  "%.2f\n" $(bc --mathlib <<< '2/3')
0.67
```

