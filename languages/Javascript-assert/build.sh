#!/bin/bash

cp Dockerfile_javascript-0.10.15 Dockerfile
docker build -t cyberdojo/javascript-0.10.15  .
rm Dockerfile

cp Dockerfile_javascript-0.10.15_assert Dockerfile
docker build -t cyberdojo/javascript-0.10.15_assert  .
rm Dockerfile
