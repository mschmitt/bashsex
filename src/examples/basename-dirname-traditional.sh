#!/bin/bash

while read -r FILE
do
	BASENAME="$(basename "$FILE")"
	DIRNAME="$(dirname "$FILE")"
	FILESIZE="$(stat --format '%s' "$FILE")"
	printf "%s (%s bytes) in %s\n" "$BASENAME" "$FILESIZE" "$DIRNAME"
done < <(find /usr/lib -type f)
