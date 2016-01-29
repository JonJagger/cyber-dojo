#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ${DIR}
docker-compose -f docker-compose.yml -f docker-compose.ubuntu_trusty.yml up &
popd
