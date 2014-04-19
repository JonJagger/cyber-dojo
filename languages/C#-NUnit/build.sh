#!/bin/bash

cp Dockerfile_csharp_2.10.8.1 Dockerfile
docker build -t cyberdojo/csharp-2.10.8.1  .
rm Dockerfile

cp Dockerfile_csharp_2.10.8.1_nunit Dockerfile
docker build -t cyberdojo/csharp-2.10.8.1_nunit .
rm Dockerfile
