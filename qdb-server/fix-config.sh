#!/usr/bin/env sh

# Note: this file is *not* used in the actual .deb package, only for our
# own integration tests. As such it's fine to use jq as we control the
# environment.

IP=`which ip`
AWK=`which awk`

HOSTNAME=$(hostname)

IP=$(cat /etc/hosts | grep ${HOSTNAME} | ${AWK} '{print $1}')

cat /etc/qdb/qdbd.conf \
    | jq '.local.depot.rocksdb.max_open_files = 60000' \
    | jq ".local.network.listen_on = \"${IP}:2836\"" \
    | jq ".global.security.enabled = false" \
    | jq "del(.global.security.cluster_private_file)" \
    | jq "del(.global.security.user_list)" \
    > /tmp/qdbd.conf.new && \
    mv /tmp/qdbd.conf.new /etc/qdb/qdbd.conf

chown qdb:qdb /etc/qdb/qdbd.conf
