#!/bin/bash

cp Dockerfile_java_1.8_cucumber Dockerfile
docker build -t cyberdojo/java-1.8_cucumber .
rm Dockerfile
