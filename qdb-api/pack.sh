#!/bin/bash

set -eux

PACKAGE_TARBALL=$(readlink -e $1); shift
PACKAGE_VERSION=$1; shift
cd $(dirname $0)

if [[ ${PACKAGE_VERSION} == "nightly" ]]; then
    PACKAGE_VERSION=$(../common/get_version.sh ${PACKAGE_TARBALL})
    PACKAGE_VERSION=$PACKAGE_VERSION-0.0
    echo "No package version provided. Setting PACKAGE_VERSION: ${PACKAGE_VERSION}"
fi

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
