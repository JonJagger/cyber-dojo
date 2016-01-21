#!/bin/bash

docker build -t cyberdojofoundation/tmp-data .
docker create --name cyber-dojo-tmp-data-container cyberdojofoundation/tmp-data
