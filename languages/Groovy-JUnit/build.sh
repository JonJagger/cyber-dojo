#!/bin/bash
cp Dockerfile_groovy-2.2.0 Dockerfile
docker build -t cyberdojo/groovy-2.2.0  .
rm Dockerfile

cp Dockerfile_groovy-2.2.0_junit Dockerfile
docker build -t cyberdojo/groovy-2.2.0_junit  .
rm Dockerfile

docker push cyberdojo/groovy-2.2.0
docker push cyberdojo/groovy-2.2.0_junit
