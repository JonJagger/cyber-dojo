#!/bin/bash

pushd /var/www/cyber-dojo/docker
docker-compose -f docker-compose.yml -f docker-compose.debian-jessie.yml up &
popd
