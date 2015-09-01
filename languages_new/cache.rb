#!/usr/bin/env ruby

require_relative '../admin_scripts/lib_domain'
require_relative '../admin_scripts/cyberdojofoundation_docker_update_all.rb'

update_cyber_dojo_docker_images

dojo.languages.refresh_cache
