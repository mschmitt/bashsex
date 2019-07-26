#!/bin/bash

while read BYTES
do
	let TOTAL+=$BYTES
done < <(sudo sed -n '/.*postfix\/qmgr.*size=/s/.*postfix\/qmgr.*size=\([0-9][0-9]*\),.*/\1/p' /var/log/mail.info )

echo $TOTAL
