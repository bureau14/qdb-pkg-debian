#!/bin/sh

set -eu

QDB_VERSION=$1
PACKAGE_NAME=$(basename $(pwd))
DEB_FILENAME="${PACKAGE_NAME}_$QDB_VERSION-1.deb"
COPYRIGHT="$(dirname $(readlink -e $0))/copyright"

rm -f "$DEB_FILENAME" 'control.tar.gz' 'data.tar.bz2'

(
	chmod -R g=o data/
	cd 'data'
	
	mkdir -p "usr/share/doc/$PACKAGE_NAME"
	cp "$COPYRIGHT" "usr/share/doc/$PACKAGE_NAME/copyright"

	find * -maxdepth 1 -mindepth 1 -type d -not -name 'control' | xargs \
		tar -cvjf '../data.tar.bz2' --owner 0 --group 0
	find * -type f | xargs \
		md5sum | sed 's/*//g' > '../control/md5sums'
)

(
	chmod -R g=o control/
	cd 'control'

	find -type f -name '*.in' -exec \
		sh -c "export QDB_VERSION=$QDB_VERSION; envsubst < \$0 '\$QDB_VERSION' > \${0%.in}" {} \;
	find * -type f -not -name '*.in' | xargs \
		tar -cvzf '../control.tar.gz' --owner 0 --group 0
)

echo '2.0' > 'debian-binary'

ar -rv "$DEB_FILENAME" 'debian-binary' 'control.tar.gz' 'data.tar.bz2'
