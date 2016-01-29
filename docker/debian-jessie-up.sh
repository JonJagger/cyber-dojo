#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ${DIR}
docker-compose -f docker-compose.yml -f docker-compose.debian-jessie.yml up &
popd
