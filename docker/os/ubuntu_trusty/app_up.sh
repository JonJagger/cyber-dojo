#!/bin/bash

# Brings up cyber-dojo after running bootstrap.sh
# which puts both .yml files into the same folder.
# Port 80 must be open.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ${DIR}
docker-compose -f docker-compose.yml -f docker-compose.ubuntu_trusty.yml up &
popd
