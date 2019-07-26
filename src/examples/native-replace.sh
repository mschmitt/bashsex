#!/bin/bash

# Native bash pattern replacement

FOO="foo"
BAR=${FOO//foo/bar}

echo $FOO $BAR
