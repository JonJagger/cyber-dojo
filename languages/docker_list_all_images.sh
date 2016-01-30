#!/bin/bash

dcn='temporary_cdf_list_images'

docker run --name=${dcn} --entrypoint="bin/sh" cyberdojofoundation/languages
docker run --rm --volumes-from=${dcn} rails:4.1 /var/www/cyber-dojo/languages/docker_list_all_images.rb
docker stop ${dcn} > /dev/null
docker rm   ${dcn} > /dev/null
