#!/bin/bash

while read -a FIELDS -r 
do
	# Uses no subprocess at all
	SERVICENAME=${FIELDS[0]}
	SERVICEPORT=${FIELDS[1]}
	printf "%s on %s\n" "$SERVICENAME" "$SERVICEPORT"
done < /etc/services
