#!/bin/bash

docker run -d \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -v /usr/local/bin/docker:/bin/docker \
           --volumes-from cyber-dojo-katas-data-container \
           --name=cyber-dojo \
           -p 80:80 cyberdojofoundation/server:1.0

docker exec cyber-dojo bash -c /var/www/cyber-dojo/caches/refresh_all.sh

docker-machine ip default
