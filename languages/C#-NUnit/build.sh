#!/bin/bash
cp Dockerfile_csharp Dockerfile
docker build -t cyberdojo/csharp  .
rm Dockerfile

cp Dockerfile_csharp_nunit Dockerfile
docker build -t cyberdojo/csharp_nunit .
rm Dockerfile

docker push cyberdojo/csharp
docker push cyberdojo/csharp_nunit
