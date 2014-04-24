#!/bin/bash

cp Dockerfile_php_N Dockerfile
docker build -t cyberdojo/php_N .
rm Dockerfile

cp Dockerfile_php_N_phpunit Dockerfile
docker build -t cyberdojo/php_N_phpunit .
rm Dockerfile
