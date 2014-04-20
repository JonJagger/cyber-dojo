#!/bin/bash

cp Dockerfile_java_1.8_mockito Dockerfile
docker build -t cyberdojo/java-1.8_mockito .
rm Dockerfile
