#!/usr/bin/env ruby

# Checks if there are updates (and pulls them if there are) to the
# docker containers for  all *already* installed docker containers.
#
# $ docker pull container-name
#
# is a (fairly fast) no-op if there is no change to the container.

# This needs to be done before requiring lib_doman so the correct
# runner class is used.
ENV['CYBER_DOJO_RUNNER_CLASS_NAME'] ||= 'DockerVolumeMountRunner'

require_relative 'lib_domain'

dojo.languages.each do |language|
  if language.runnable?
    cmd = "docker pull #{language.image_name}"
    print cmd + "\n"
    `#{cmd}`
  end
end

