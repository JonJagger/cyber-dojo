#!/bin/bash

cp Dockerfile_coffeescript-1.14.3 Dockerfile
docker build -t cyberdojo/coffeescript-1.14.3  .
rm Dockerfile

cp Dockerfile_coffeescript-1.14.3_jasmine Dockerfile
docker build -t cyberdojo/coffeescript-1.14.3_jasmine .
rm Dockerfile
