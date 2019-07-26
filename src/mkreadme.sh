#!/bin/bash

RE='Example: (.*)'
while read -r LINE
do
	if [[ "$LINE" =~ $RE ]]
	then
		echo "Example: *examples/${BASH_REMATCH[1]}*"
		EXAMPLE="examples/${BASH_REMATCH[1]}"
		if [[ -s "$EXAMPLE" ]]
		then
			echo '```'
			cat "$EXAMPLE"
			echo '```'
		else
			echo "$EXAMPLE not found."
			exit 1
		fi
	else
		echo "$LINE"
	fi
done < README.raw.md > ../README.md

cat <<End > ../README.html
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Guide to Bash Scripting Exellence</title>
</head>

<xmp theme="united" style="display:none;">
End

cat ../README.md >> ../README.html

cat <<End >> ../README.html 
</xmp>

<script src="strapdown/v/0.2/strapdown.js"></script>
</html>
End
