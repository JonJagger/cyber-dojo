#!/bin/bash

docker build -t cyberdojofoundation/katas-data .
docker create --name cyber-dojo-katas-data-container cyberdojofoundation/katas-data
