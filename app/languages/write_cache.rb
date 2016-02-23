#!/usr/bin/env ruby

# Make app/languages/cache.json file
# Do this before creating a new cyberdojofoundation/languages image
# or new cyber-dojo-languages data-container.

host_languages_root = File.expand_path(File.dirname(__FILE__))
require_relative '../domain'
ENV['CYBER_DOJO_LANGUAGES_ROOT'] = host_languages_root
ENV['CYBER_DOJO_DISK_CLASS'] = 'HostDisk'
dojo.languages.write_cache
