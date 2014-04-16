#!/bin/bash
cp Dockerfile_ruby_1.9.3 Dockerfile
docker build -t cyberdojo/ruby-1.9.3  .
rm Dockerfile

cp Dockerfile_ruby_1.9.3_test_unit Dockerfile
docker build -t cyberdojo/ruby-1.9.3_test_unit  .
rm Dockerfile

docker push cyberdojo/ruby-1.9.3
docker push cyberdojo/ruby-1.9.3_test_unit
