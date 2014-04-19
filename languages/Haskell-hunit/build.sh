#!/bin/bash

cp Dockerfile_haskell_7.6.3 Dockerfile
docker build -t cyberdojo/haskell-7.6.3  .
rm Dockerfile

cp Dockerfile_haskell_7.6.3_hunit Dockerfile
docker build -t cyberdojo/haskell-7.6.3_hunit .
rm Dockerfile
