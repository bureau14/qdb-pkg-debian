#!/bin/bash

set -eux

PACKAGE_TARBALL=$1
QDB_VERSION=$2
PACKAGE_NAME=$(basename $(pwd))
# PACKAGE_ARCH is x86_64 by default, but aarch64 if the tarball contains
# that name.
PACKAGE_ARCH="amd64"
if [[ $PACKAGE_TARBALL == *"aarch64"* ]]; then
    PACKAGE_ARCH="arm64"
fi

DEB_FILENAME="${PACKAGE_NAME}_${QDB_VERSION}.${PACKAGE_ARCH}.deb"
COPYRIGHT="$(dirname $(readlink -e $0))/copyright"

rm -f "$DEB_FILENAME" 'control.tar.gz' 'data.tar.bz2'

(
	cd 'data'

	mkdir -p "usr/share/doc/$PACKAGE_NAME"
	cp "$COPYRIGHT" "usr/share/doc/$PACKAGE_NAME/copyright"

	find * -maxdepth 1 -mindepth 1 -type d -not -name 'control' | xargs \
		tar -cvjf '../data.tar.bz2' --owner 0 --group 0 --mode g=o
	find * -type f | xargs \
		md5sum | sed 's/*//g' > '../control/md5sums'
)

(
	cd 'control'

	find -type f -name '*.in' -exec \
		sh -c "export QDB_VERSION=$QDB_VERSION; export PACKAGE_ARCH=$PACKAGE_ARCH; envsubst '\$QDB_VERSION \$PACKAGE_ARCH' < \$0 > \${0%.in}" {} \;
	find * -type f -not -name '*.in' | xargs \
		tar -cvzf '../control.tar.gz' --owner 0 --group 0 --mode g=o
)

echo '2.0' > 'debian-binary'

ar -rDv "$DEB_FILENAME" 'debian-binary' 'control.tar.gz' 'data.tar.bz2' 2>&1
