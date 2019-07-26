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
