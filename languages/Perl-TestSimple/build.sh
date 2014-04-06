#!/bin/bash
cp Dockerfile_perl Dockerfile
docker build -t cyberdojo/perl .

cp Dockerfile_perl_testsimple Dockerfile
docker build -t cyberdojo/perl_testsimple .

docker push cyberdojo/perl
docker push cyberdojo/perl_testsimple
