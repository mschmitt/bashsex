#!/bin/bash

while read -r LINE
do
	# Uses 2 subprocesses each:
	SERVICENAME=$(echo "$LINE" | cut -f 1)
	SERVICEPORT=$(echo "$LINE" | awk '{print $2}')
	printf "%s on %s\n" "$SERVICENAME" "$SERVICEPORT"
done < /etc/services
