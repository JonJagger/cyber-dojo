#!/bin/bash

docker ps -a -q | xargs docker rm

docker rm $(docker ps -a -q)

docker stop $(docker ps -a -q)