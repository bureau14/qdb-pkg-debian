#!/bin/sh

echo "$1" | sed -r 's/.*qdb-([0-9\.a-z_]+)-linux-.*/\1/'
