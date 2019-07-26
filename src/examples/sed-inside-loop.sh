#!/bin/bash

# Substitute something in some random input
while read -r INPUT
do
	INPUT=$(echo "$INPUT" | sed 's/foo/bar/g')
done < <(dd if=/dev/urandom count=1000)
