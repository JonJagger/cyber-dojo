#!/bin/bash

cp Dockerfile_cofeescript-X Dockerfile
docker build -t cyberdojo/coffeescript-X  .
rm Dockerfile
