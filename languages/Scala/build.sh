#!/bin/bash

cp Dockerfile_scala-X Dockerfile
docker build -t cyberdojo/scala-X  .
rm Dockerfile

cp Dockerfile_scala-X_scalatest Dockerfile
docker build -t cyberdojo/scala-X_scalatest  .
rm Dockerfile
