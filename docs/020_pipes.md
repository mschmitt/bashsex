# Pipes

## Avoid Chained Pipes

Interactive ad-hoc pipes get us through a lot of our daily tasks. Nevertheless, those anonymous pipes should be avoided in scripts, as for the reader or later maintainer it's going to be impossible to tell what's actually happening inside all of this plumbing.

### Don't: Establish cryptic Plumbing

Here's an extremely ad-hoc one-liner that retrieves all mail sizes from a *Postfix* mail log and calculates a total number of bytes delivered.

```bash
grep postfix.qmgr /var/log/mail.info | grep size= | while read LINE; do SIZE=$(echo $LINE | sed '/size=/s/^.*size=//' | sed 's/[^0-9].*//'); let TOTALSIZE+=SIZE; echo $TOTALSIZE; done | tail -n 1
```

### Do: Split the lines and add comments

```bash
sudo grep postfix.qmgr /var/log/mail.info | # qmgr messages from postfix
grep size= | # only lines that contain a size value
while read line; # process each line and extract size
do size=$(echo $line | sed '/size=/s/^.*size=//' | sed 's/[^0-9].*//')
let totalsize+=size; echo $totalsize; done | # add this size to total size
tail -n 1 # show only last line
```

### Do: Get rid of the pipes altogether

Note how the pipe above globally searches for the string *size=* and then individually for each line makes substitutions around it. We process each line and use *bash* pattern matching and arithmetics to extract the size and calculate the total.

```bash
#!/usr/bin/env bash

regex='.*postfix/qmgr.*size=([0-9]+),.*'
while read line
do
	if [[ "$line" =~ $regex ]]
	then
		bytes=${BASH_REMATCH[1]}
		let total+=$bytes
	fi
done < <(sudo cat /var/log/mail.info)

echo $total
```

### Do: Break the rules

In this special case, a lot can be gained from having the extraction handled by *sed* again, but we need to execute it only once, on the global input stream, outside the *while* loop. The obvious downside is that this requires somewhat solid *sed* skills, which the pure *bash* example above does not.

```bash
#!/usr/bin/env bash

while read bytes
do
	let total+=$bytes
done < <(sudo sed -n '/.*postfix\/qmgr.*size=/s/.*postfix\/qmgr.*size=\([0-9][0-9]*\),.*/\1/p' /var/log/mail.info )

echo $total
```
