#!/bin/bash

declare -A THEHASH
THEHASH=(["Month 1"]="January" ["Month 2"]="February")
THEARRAY=("1 One" "2 Two" "3 Three" "4 Four")

echo "${THEHASH[@]@A}"
echo "${THEARRAY[@]@A}"
