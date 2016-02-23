#!/bin/sh
set -e

docker rm -f cdf-exercises-DATA-CONTAINER
docker rm -f cdf-languages-DATA-CONTAINER
docker rm -f cdf-test-DATA-CONTAINER
docker rm -f cdf-rails-tmp-DATA-CONTAINER
docker rm -f cdf-rails-log-DATA-CONTAINER
docker rm -f cdf-rails-app-DATA-CONTAINER
docker rm -f cdf-web
docker rm -f cdf-nginx
