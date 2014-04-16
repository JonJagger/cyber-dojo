#!/bin/bash
cp Dockerfile_python-3.3.5 Dockerfile
docker build -t cyberdojo/python-3.3.5  .
rm Dockerfile

cp Dockerfile_python-3.3.5_unittest Dockerfile
docker build -t cyberdojo/python-3.3.5_unittest .
rm Dockerfile

docker push cyberdojo/python-3.3.5
docker push cyberdojo/python-3.3.5_unittest
