Quasardb Debian packages
========================

This repository contains script that transforms the quasardb tarballs into .deb files.

# Compilation instructions:

1. Download the tarball package from https://download.quasardb.net/quasardb
2. Invoke the corresponding build script, with the path of the tarball on the command line

### Example

    # Clone this repository
    git clone https://github.com/bureau14/qdb-pkg-debian.git
    cd qdb-pkg-debian

    # Build package "server"
    cd qdb-server
    wget https://download.quasardb.net/quasardb/2.0/2.0.0rc2/server/qdb-2.0.0-linux-64bit-server.tar.gz
    ./pack-server.sh qdb-2.0.0-linux-64bit-server.tar.gz
