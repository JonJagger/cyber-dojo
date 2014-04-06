#!/bin/bash
cp Dockerfile_haskell Dockerfile
docker build -t cyberdojo/erlang  .

cp Dockerfile_haskell_hunit Dockerfile
docker build -t cyberdojo/erlang_eunit .

docker push cyberdojo/haskell
docker push cyberdojo/haskell_hunit
