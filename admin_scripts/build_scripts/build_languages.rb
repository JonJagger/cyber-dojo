#!/usr/bin/env ruby

require_relative("directory_build_image.rb")

CYBER_DOJO_ROOT_DIR = '/var/www/cyber-dojo'

build_images("#{CYBER_DOJO_ROOT_DIR}/languages/build-essential/build*.sh")
build_images("#{CYBER_DOJO_ROOT_DIR}/languages/*/build*.sh")
