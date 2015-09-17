#!/bin/sh

echo "$1" | sed -r 's/qdb-(.*)-linux-.*/\1/'
