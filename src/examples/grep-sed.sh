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
