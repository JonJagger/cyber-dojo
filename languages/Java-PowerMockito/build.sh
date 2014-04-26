#!/bin/bash

cp Dockerfile_java_1.8_powermockito Dockerfile
docker build -t cyberdojo/java-1.8_powermockito .
rm Dockerfile
