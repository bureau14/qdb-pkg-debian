#!/bin/sh

set -eu

PATH="$PATH:$(dirname $0)/../common"

TARBALL=$(readlink -e $1)
VERSION=$(get_version.sh $1)

cd $(dirname $0)

(
	rm -rf data
	mkdir data
	cd data

	mkdir usr
	tar -xf "$TARBALL" -C usr
	cp -r ../upstart/ usr/share/qdb/
	cp -r ../systemd/ usr/share/qdb/
)

pack.sh $VERSION
