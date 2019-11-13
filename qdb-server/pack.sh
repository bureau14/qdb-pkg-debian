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
