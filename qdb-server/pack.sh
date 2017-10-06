#!/bin/sh

set -eu

TARBALL=$(readlink -e $1)

cd $(dirname $0)

VERSION=$(../common/get_version.sh $TARBALL)

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

../common/pack.sh $VERSION
