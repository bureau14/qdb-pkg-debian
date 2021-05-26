#!/bin/bash

set -eux

export COMPOSE_INTERACTIVE_NO_CLI=1

docker-compose run --rm qdb-rest '/bin/sh' '-c' "curl -s -k -H 'Origin: http://0.0.0.0:3449' -H 'Content-Type: application/json' -X POST https://qdb-rest:40443/api/login | grep 'credential in body is required'"
docker-compose run --rm qdb-rest '/bin/sh' '-c' "curl -k -H 'Origin: http://0.0.0.0:3449' https://qdb-rest:40443/index.html"