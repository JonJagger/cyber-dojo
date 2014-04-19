#!/bin/bash

cp Dockerfile_java_1.8 Dockerfile
docker build -t cyberdojo/java-1.8 .
rm Dockerfile

cp Dockerfile_java_1.8_junit Dockerfile
docker build -t cyberdojo/java-1.8_junit .
rm Dockerfile
