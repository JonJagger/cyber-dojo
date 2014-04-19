#!/bin/bash

cp Dockerfile_haskell Dockerfile
docker build -t cyberdojo/haskell  .
rm Dockerfile

cp Dockerfile_haskell_hunit Dockerfile
docker build -t cyberdojo/haskell_hunit .
rm Dockerfile

