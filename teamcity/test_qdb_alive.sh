#!/bin/bash

set -eux

sleep 5
docker-compose up -d qdb-server
echo "qdb-server running:"
sleep 5
docker-compose run --rm qdb-utils '/bin/bash' '-c' "qdbsh --cluster qdb://qdb-server:2836 -c 'node_status qdb://qdb-server:2836'"
echo "success!"