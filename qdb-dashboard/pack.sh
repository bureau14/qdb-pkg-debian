#!/bin/sh

set -eu

TARBALL=$(readlink -e $1)

cd $(dirname $0)

VERSION=$(../common/get_version.sh $TARBALL)

(
    rm -rf data
    mkdir data
    cd data


    mkdir -p var/lib/qdb/assets
    tar -xf "$TARBALL" -C var/lib/qdb/assets/
)

../common/pack.sh $VERSION
