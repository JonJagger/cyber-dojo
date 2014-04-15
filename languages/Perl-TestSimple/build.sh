#!/bin/bash
cp Dockerfile_perl Dockerfile
docker build -t cyberdojo/perl .
rm Dockerfile

cp Dockerfile_perl_test_simple Dockerfile
docker build -t cyberdojo/perl_test_simple .
rm Dockerfile

docker push cyberdojo/perl
docker push cyberdojo/perl_test_simple
