#!/usr/bin/env ruby

# Checks if there are updates (and pulls them if there are) to the
# docker containers for  all *already* installed docker containers.
#
# Except it doesn't. It issues unconditional 'docker pull' commands.
# 
# $ docker pull container-name
#
# is a (fairly fast) no-op if there is no change to the container.

require_relative 'lib_domain'

dojo.languages.each do |language|
  cmd = "docker pull #{language.image_name}"
  print cmd + "\n"
  `#{cmd}`
end

