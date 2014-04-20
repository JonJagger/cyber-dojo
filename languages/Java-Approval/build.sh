#!/bin/bash

cp Dockerfile_java_1.8_approval Dockerfile
docker build -t cyberdojo/java-1.8_approval .
rm Dockerfile
