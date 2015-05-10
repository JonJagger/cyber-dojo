#!/usr/bin/env ruby

require_relative 'lib_domain'

dojo = create_dojo
dojo.languages.each do |language|
  cmd = "docker pull #{language.image_name}"
  print cmd + "\n"
  `#{cmd}`
end

