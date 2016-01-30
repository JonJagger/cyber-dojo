#!/bin/bash

# script to bring up cyber-dojo after running bootstrap.sh
# which puts both .yml files into the same folder

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ${DIR}
docker-compose -f docker-compose.yml -f docker-compose.debian_jessie.yml up &
popd
