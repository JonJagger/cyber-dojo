#!/bin/bash
cp Dockerfile_java_1.7 Dockerfile
docker build -t cyberdojo/java-1.7  .
rm Dockerfile

cp Dockerfile_java_1.8 Dockerfile
docker build -t cyberdojo/java-1.8 .
rm Dockerfile

docker push cyberdojo/java-1.7
docker push cyberdojo/java-1.8
