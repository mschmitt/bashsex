#!/bin/bash

# Enable loadable bash extensions
BASH_LOADABLES_PATH=/usr/lib/bash:/usr/local/lib/bash
enable -f basename basename
enable -f dirname dirname
enable -f finfo finfo

while read -r FILE
do
	BASENAME="$(basename "$FILE")"
	DIRNAME="$(dirname "$FILE")"
	FILESIZE="$(finfo -s "$FILE")"
	printf "%s (%s bytes) in %s\n" "$BASENAME" "$FILESIZE" "$DIRNAME"
done < <(find /usr/lib -type f)
