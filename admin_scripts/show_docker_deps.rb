#!/usr/bin/env ruby

require 'json'

root_dir = ARGV[0]
if root_dir.nil?
  puts "docker_show_deps.rb [root-dir]"
  exit
end

dependencies = [ ]
Dir.glob("#{root_dir}/languages/*/*/Dockerfile") do |file|
  sh = File.expand_path(File.dirname(file)) + '/build-docker-container.sh'
  to = IO.read(sh).split[4]
  from = IO.read(file).split[1]
  if !to.start_with?('cyberdojo')
    puts "#{sh}'s target container-name does not start with cyberdojo"
    exit
  end
  dependencies << [from,to]
end

# with some effort this could be displayed
# in a nicer nested format
dependencies.sort.each do |dep|
  print dep[0] + "-->" + dep[1] + "\n"
end
