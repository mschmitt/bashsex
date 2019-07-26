#!/bin/bash

# UTF-8 multibyte characters
STRING="ÄÖÜ" 
CHARACTERS=$(echo -n "$STRING" | wc -m)     # 3 Characters
BYTES=$(echo -n "$STRING" | wc -c)          # 6 Bytes


printf "%s (%s characters, %s bytes)\n" "$STRING" "$CHARACTERS" "$BYTES"
