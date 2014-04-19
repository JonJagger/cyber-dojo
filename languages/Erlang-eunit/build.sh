#!/bin/bash

cp Dockerfile_erlang_5.10.2 Dockerfile
docker build -t cyberdojo/erlang-5.10.2  .
rm Dockerfile

cp Dockerfile_erlang_5.10.2_eunit Dockerfile
docker build -t cyberdojo/erlang-5.10.2_eunit .
rm Dockerfile
