#!/bin/bash

pushd /var/www/cyber-dojo/docker
docker-compose -f docker-compose.yml -f docker-compose.ubuntu-14.04.yml up &
popd
