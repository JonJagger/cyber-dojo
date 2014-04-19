#!/bin/bash

cp Dockerfile_gpp_4.8.1_googletest Dockerfile
docker build -t cyberdojo/gpp-4.8.1_googletest  .
rm Dockerfile
