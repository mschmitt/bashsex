#!/bin/bash

function cleanup(){
	rm -f "$TMPFILE1"
	rm -f "$TMPFILE2"
}
trap cleanup INT QUIT TERM EXIT

TMPFILE1="$(mktemp)"
TMPFILE2="$(mktemp)"

echo "$TMPFILE1"
echo "$TMPFILE2"
