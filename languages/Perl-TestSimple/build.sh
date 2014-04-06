#!/bin/bash
cp Dockerfile_perl Dockerfile
docker build -t cyberdojo/perl .

cp Dockerfile_perl_test_simple Dockerfile
docker build -t cyberdojo/perl_test_simple .

docker push cyberdojo/perl
docker push cyberdojo/perl_test_simple
