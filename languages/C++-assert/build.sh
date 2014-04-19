#!/bin/bash

cp Dockerfile_gpp_4.8.1 Dockerfile
docker build -t cyberdojo/gpp-4.8.1  .
rm Dockerfile

cp Dockerfile_gpp_4.8.1_assert Dockerfile
docker build -t cyberdojo/gpp-4.8.1_assert .
rm Dockerfile

