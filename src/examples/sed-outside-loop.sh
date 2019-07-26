#!/bin/bash

# Substitute something in some random input
while read -r INPUT
do
	true # nothing
done < <(dd if=/dev/urandom count=1000 | sed 's/foo/bar/g')
