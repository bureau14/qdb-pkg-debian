#!/bin/sh

set -eu

PATH="$PATH:$(dirname $0)/../common"

TARBALL=$(readlink -e $1)
VERSION=$(get_version.sh $1)

cd $(dirname $0)

(
	rm -rf 'data'
	mkdir 'data'
	cd 'data'

	tar -xf "$TARBALL"

	mkdir -p 'usr/share/qdb/console'
	mv 'bin/html' 'usr/share/qdb/console'

	mkdir -p 'usr/sbin'
	mv "bin/qdbd" 'usr/sbin/'
	mv "bin/qdb_httpd" 'usr/sbin/'

	mkdir -p 'etc/init'
	cp "../init/qdbd.conf" 'etc/init/'
	cp "../init/qdb_httpd.conf" 'etc/init/'

	mv 'bin' 'usr/'	
)

'pack.sh' $VERSION
