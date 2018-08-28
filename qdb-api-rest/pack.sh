#!/bin/sh

set -eu

TARBALL=$(readlink -e $1)

cd $(dirname $0)

VERSION=$(../common/get_version.sh $TARBALL)

(
    rm -rf 'data'
    mkdir -p 'data/usr'
    cd 'data/usr'

    tar -xf "$TARBALL"

    mkdir -p usr/share/qdb/
    cp -r ../upstart/ usr/share/qdb/
    cp -r ../systemd/ usr/share/qdb/
    cp share/qdb/default.cfg usr/share/qdb/
)

../common/pack.sh $VERSION
