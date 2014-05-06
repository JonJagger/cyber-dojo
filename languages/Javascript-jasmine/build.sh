#!/bin/bash

cp Dockerfile_javascript-0.10.15_jasmine Dockerfile
docker build -t cyberdojo/javascript-0.10.15_jasmine  .
rm Dockerfile
