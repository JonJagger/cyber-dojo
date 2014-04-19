#!/bin/bash

cp Dockerfile_go_1.1.2 Dockerfile
docker build -t cyberdojo/go-1.1.2  .
rm Dockerfile

cp Dockerfile_go_1.1.2_testing Dockerfile
docker build -t cyberdojo/go-1.1.2_testing .
rm Dockerfile
