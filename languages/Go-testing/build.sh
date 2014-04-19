#!/bin/bash

cp Dockerfile_go Dockerfile
docker build -t cyberdojo/go  .
rm Dockerfile

cp Dockerfile_go_testing Dockerfile
docker build -t cyberdojo/go_testing .
rm Dockerfile

