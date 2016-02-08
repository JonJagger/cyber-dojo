#!/bin/bash

# Runs list_all_images.rb using docker containers

PID=$(docker create --name lang cyberdojofoundation/languages /bin/true)
docker run --rm --volumes-from ${PID} cyberdojofoundation/web bash -c "./languages/list_all_images.rb"
docker rm ${PID} > /dev/null
