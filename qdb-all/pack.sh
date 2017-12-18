#!/bin/sh

set -eu

API_TARBALL=$(ls *-c-api.tar.gz)
SERVER_TARBALL=$(ls *-server.tar.gz)
UTILS_TARBALL=$(ls *-utils.tar.gz)
WEB_BRIDGE_TARBALL=$(ls *-web-bridge.tar.gz)

TARBALL=$(readlink -e $1)

cd $(dirname $0)

VERSION=$(../common/get_version.sh $TARBALL)

(
    rm -rf data
    mkdir -p data
    mkdir -p data/usr
    cd data

    mkdir -p etc/sysctl.d/
    cp sysctl.d/* data/etc/sysctl.d/

    mkdir -p usr/share/qdb/
    cp -r upstart/ data/usr/share/qdb/
    cp -r systemd/ data/usr/share/qdb/

    tar -xf "$API_TARBALL" -C data/usr
    tar -xf "$SERVER_TARBALL" -C data/usr
    tar -xf "$UTILS_TARBALL" -C data/usr
    tar -xf "$WEB_BRIDGE_TARBALL" -C data/usr

    # Note: .so files are not executable on Debian
    chmod 644 data/usr/lib/libqdb_api.so

    mv data/usr/lib/libqdb_api.so data/usr/lib/libqdb_api-$VERSION.so

    mv data/usr/include/qdb data/usr/include/qdb-$VERSION

    mv data/usr/examples/ data/usr/share/qdb/

)

../common/pack.sh $VERSION
