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

	mkdir -p etc/sysctl.d/
	cp ../sysctl.d/* etc/sysctl.d/

	mkdir usr
	tar -xf "$TARBALL" -C usr

	mkdir -p usr/share/qdb/
	cp -r ../upstart/ usr/share/qdb/
	cp -r ../systemd/ usr/share/qdb/
)

pack.sh $VERSION
