#!/bin/bash

cp Dockerfile_erlang Dockerfile
docker build -t cyberdojo/erlang  .
rm Dockerfile

cp Dockerfile_erlang_eunit Dockerfile
docker build -t cyberdojo/erlang_eunit .
rm Dockerfile

