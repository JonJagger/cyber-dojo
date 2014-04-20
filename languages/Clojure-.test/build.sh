#!/bin/bash

cp Dockerfile_clojure_1.4.0_test Dockerfile
docker build -t cyberdojo/clojure-1.4.0_test .
rm Dockerfile
