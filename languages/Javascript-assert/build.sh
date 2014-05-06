#!/bin/bash

cp Dockerfile_javascript_node-0.10.15 Dockerfile
docker build -t cyberdojo/javascript_node-0.10.15  .
rm Dockerfile
