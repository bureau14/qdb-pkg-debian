#!/bin/bash

set -eux

PACKAGE_TARBALL=$(readlink -e $1); shift
cd $(dirname $0)

PACKAGE_VERSION=$(../common/get_version.sh)

(
    rm -rf data
    mkdir -p data/usr
    cd data/usr

    tar -xf "$PACKAGE_TARBALL"

    # Note: .so files are not executable on Debian
    chmod 644 lib/libqdb_api.so

    mv lib/libqdb_api.so lib/libqdb_api-$PACKAGE_VERSION.so

    mv include/qdb include/qdb-$PACKAGE_VERSION

    mkdir -p share/qdb/
    mv examples/ share/qdb/
)

../common/pack.sh $PACKAGE_VERSION
