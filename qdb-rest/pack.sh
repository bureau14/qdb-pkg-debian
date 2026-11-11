#!/bin/bash

set -eux

PACKAGE_TARBALL=$(readlink -e $1); shift
cd $(dirname $0)

PACKAGE_VERSION=$(../common/get_version.sh)

(
    rm -rf data
    mkdir data
    cd data

    # The archive holds bin/qdb_rest and etc/qdb_rest.yaml.
    mkdir usr
    tar -xf "$PACKAGE_TARBALL" -C usr/

    # The configuration is in the payload, so dpkg tracks it as the
    # conffile that control/conffiles names.
    mkdir -p etc/qdb/
    mv usr/etc/qdb_rest.yaml etc/qdb/
    rmdir usr/etc

    mkdir -p usr/lib/systemd/system/
    cp ../systemd/qdb_rest.service usr/lib/systemd/system/
)

../common/pack.sh $PACKAGE_TARBALL $PACKAGE_VERSION
