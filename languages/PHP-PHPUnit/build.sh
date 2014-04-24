#!/bin/bash

cp Dockerfile_php_5.5.3 Dockerfile
docker build -t cyberdojo/php-5.5.3 .
rm Dockerfile

cp Dockerfile_php_5.5.3_phpunit Dockerfile
docker build -t cyberdojo/php-5.5.3_phpunit .
rm Dockerfile
