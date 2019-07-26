#!/bin/bash

# UTF-8 multibyte characters
STRING="ÄÖÜ" 
LANG='C.utf8'     CHARACTERS=${#STRING}     # 3 Characters
LANG='C'          BYTES=${#STRING}          # 6 Bytes

printf "%s (%s characters, %s bytes)\n" "$STRING" "$CHARACTERS" "$BYTES"
