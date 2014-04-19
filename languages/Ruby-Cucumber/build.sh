#!/bin/bash

cp Dockerfile_ruby_1.9.3_cucumber Dockerfile
docker build -t cyberdojo/ruby-1.9.3_cucumber  .
rm Dockerfile

