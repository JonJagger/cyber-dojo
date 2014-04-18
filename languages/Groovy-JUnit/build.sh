#!/bin/bash
cp Dockerfile_groovy Dockerfile
docker build -t cyberdojo/groovy  .
rm Dockerfile

#docker push cyberdojo/groovy
#docker push cyberdojo/groovy_junit
