#!/bin/sh

set -eu

PATH="$PATH:$(dirname $0)/../common"

TARBALL=$(readlink -e $1)
VERSION=$(get_version.sh $1)

cd $(dirname $0)

(
	rm -rf 'data'
	mkdir -p 'data/usr'
	cd 'data/usr'

	tar -xf "$TARBALL"

	mkdir -p 'share/qdb'
	mv 'example' 'share/qdb/'
)

'pack.sh' $VERSION
