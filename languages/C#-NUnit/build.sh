#!/bin/bash
cp Dockerfile_csharp Dockerfile
docker build -t cyberdojo/csharp  .

cp Dockerfile_csharp_nunit Dockerfile
docker build -t cyberdojo/csharp_nunit .

docker push cyberdojo/csharp
docker push cyberdojo/csharp_nunit
