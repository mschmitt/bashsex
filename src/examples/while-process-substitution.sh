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
