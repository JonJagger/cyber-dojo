#!/usr/bin/env ruby

require_relative '../admin_scripts/lib_domain'
require_relative '../admin_scripts/cyberdojofoundation_docker_update_all.rb'

cyberdojo_foundation_docker_update_all
dojo.languages.refresh_cache
