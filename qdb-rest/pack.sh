#!/bin/bash

set -eux

PACKAGE_TARBALL=$(readlink -e $1); shift
PACKAGE_VERSION=$1; shift
cd $(dirname $0)

PACKAGE_VERSION=$(../common/get_version.sh ${PACKAGE_TARBALL} ${PACKAGE_VERSION})

(
    rm -rf data
    mkdir data
    cd data


    mkdir usr
    tar -xf "$PACKAGE_TARBALL" -C usr/

    mkdir -p etc/qdb/
    mkdir -p usr/share/qdb/
    mv usr/etc/* etc/qdb/
    cp -r ../systemd/ usr/share/qdb/
)

../common/pack.sh $PACKAGE_VERSION
