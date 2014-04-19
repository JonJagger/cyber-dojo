#!/bin/bash

cp Dockerfile_perl_5.14.2 Dockerfile
docker build -t cyberdojo/perl-5.14.2 .
rm Dockerfile

cp Dockerfile_perl_5.14.2_test_simple Dockerfile
docker build -t cyberdojo/perl-5.14.2_test_simple .
rm Dockerfile
