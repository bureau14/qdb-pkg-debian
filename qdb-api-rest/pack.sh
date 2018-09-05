#!/bin/sh

set -eu

TARBALL=$(readlink -e $1)

cd $(dirname $0)

VERSION=$(../common/get_version.sh $TARBALL)

(
    rm -rf data
    mkdir data
    cd data


    mkdir usr
    tar -xf "$TARBALL" -C usr/

    mkdir -p etc/qdb/
    mkdir -p usr/share/qdb/
    mv usr/etc/* etc/qdb/
    cp -r ../systemd/ usr/share/qdb/
)

../common/pack.sh $VERSION
