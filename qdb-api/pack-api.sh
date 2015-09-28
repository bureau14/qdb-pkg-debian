#!/bin/sh

set -eu

PATH="$PATH:$(dirname $0)/../common"

TARBALL=$(readlink -e $1)
VERSION=$(get_version.sh $1)

cd $(dirname $0)

(
	rm -rf data
	mkdir -p data/usr
	cd data/usr

	tar -xf "$TARBALL"

    # Note: .so files are not executable on Debian
    chmod 644 lib/libqdb_api.so 

    mv lib/libqdb_api.so lib/libqdb_api-$VERSION.so   

    mv include/qdb include/qdb-$VERSION

	mkdir -p share/qdb/
	mv example/ share/qdb/
)

pack.sh $VERSION
