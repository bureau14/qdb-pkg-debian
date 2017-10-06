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
    tar -xf "$TARBALL" -C usr
    cp -r ../upstart/ usr/share/qdb/
    cp -r ../systemd/ usr/share/qdb/
)

../common/pack.sh $VERSION
