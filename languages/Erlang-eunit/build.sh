#!/bin/bash
cp Dockerfile_erlang Dockerfile
docker build -t cyberdojo/erlang  .

cp Dockerfile_erlang_eunit Dockerfile
docker build -t cyberdojo/erlang_eunit .

docker push cyberdojo/erlang
docker push cyberdojo/erlang_eunit
