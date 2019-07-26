#!/bin/bash

REGEX='.*postfix/qmgr.*size=([0-9]+),.*'
while read LINE
do
	if [[ "$LINE" =~ $REGEX ]]
	then
		BYTES=${BASH_REMATCH[1]}
		let TOTAL+=$BYTES
	fi
done < <(sudo cat /var/log/mail.info)

echo $TOTAL
