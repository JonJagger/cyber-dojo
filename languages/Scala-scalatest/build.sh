#!/bin/bash

cp Dockerfile_scala-2.9.2 Dockerfile
docker build -t cyberdojo/scala-2.9.2  .
rm Dockerfile

cp Dockerfile_scala-2.9.2_scalatest Dockerfile
docker build -t cyberdojo/scala-2.9.2_scalatest  .
rm Dockerfile
