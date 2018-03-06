#!/bin/sh

set -eu

TARBALL=$(readlink -e $1)
BENCHMARK_TARBALL=$(readlink -e *qdb-benchmark-*.tar.gz)

cd $(dirname $0)

VERSION=$(../common/get_version.sh $TARBALL)

(
    rm -rf 'data'
    mkdir -p 'data/usr'
    cd 'data/usr'

    tar -xf "$TARBALL"
    tar -xf "$BENCHMARK_TARBALL"
)

../common/pack.sh $VERSION
