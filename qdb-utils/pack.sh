#!/bin/sh

set -eux

PACKAGE_TARBALL=$(readlink -e $1); shift
PACKAGE_VERSION=$1; shift
cd $(dirname $0)


if [[ ${PACKAGE_VERSION} == "nightly" ]]; then
    PACKAGE_VERSION=$(../common/get_version.sh ${PACKAGE_TARBALL})
    echo "No package version provided. Setting PACKAGE_VERSION: ${PACKAGE_VERSION}"
fi

(
    rm -rf 'data'
    mkdir -p 'data/usr'
    cd 'data/usr'

    tar -xf "$PACKAGE_TARBALL"
)

../common/pack.sh $PACKAGE_VERSION
