#!/bin/bash
cp Dockerfile_python-3.3.5 Dockerfile
docker build -t cyberdojo/python-3.3.5  .

cp Dockerfile_python-3.3.5_unittest Dockerfile
docker build -t cyberdojo/python-3.3.5_unittest .

docker push cyberdojo/python-3.3.5
docker push cyberdojo/python-3.3.5_unittest
