#!/bin/bash
cp Dockerfile_python-3.3.5_pytest Dockerfile
docker build -t cyberdojo/python-3.3.5_pytest .
rm Dockerfile

docker push cyberdojo/python-3.3.5_pytest
