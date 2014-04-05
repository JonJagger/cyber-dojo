#!/bin/bash
cp Dockerfile_java_1.7 Dockerfile
docker build -t cyberdojo/java-1.7  .

cp Dockerfile_java_1.8 Dockerfile
docker build -t cyberdojo/java-1.8 .

docker push cyberdojo/java-1.7
docker push cyberdojo/java-1.8
