#!/bin/bash

set -eux

PACKAGE_TARBALL=$(readlink -e $1); shift
PACKAGE_VERSION=$1; shift
cd $(dirname $0)

PACKAGE_VERSION=$(../common/get_version.sh ${PACKAGE_TARBALL} ${PACKAGE_VERSION})

(
    rm -rf 'data'
    mkdir -p 'data/usr'
    cd 'data/usr'

    tar -xf "$PACKAGE_TARBALL"
)

../common/pack.sh $PACKAGE_VERSION
