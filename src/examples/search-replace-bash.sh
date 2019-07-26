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
