#!/bin/bash

set -eux

PACKAGE_TARBALL=$(readlink -e $1); shift
PACKAGE_VERSION=$1; shift
cd $(dirname $0)

PACKAGE_VERSION=$(../common/get_version.sh ${PACKAGE_TARBALL} ${PACKAGE_VERSION})

echo "Set PACKAGE_VERSION: ${PACKAGE_VERSION}"

(
    rm -rf data
    mkdir data
    cd data

    mkdir -p etc/sysctl.d/
    cp ../sysctl.d/* etc/sysctl.d/

    mkdir usr
    tar -xf "$PACKAGE_TARBALL" -C usr

    mkdir -p usr/share/qdb/
    cp -r ../upstart/ usr/share/qdb/
    cp -r ../systemd/ usr/share/qdb/
)

../common/pack.sh $PACKAGE_VERSION
