#!/usr/bin/env ruby

require 'json'

def current_images_names
  output = `docker images 2>&1`
  lines = output.split("\n").select { |line| line.start_with?('cyberdojo') }
  lines.collect { |line| line.split[0] }.sort.uniq
end

def latest_images_names
  images_names = []
  cyber_dojo_root = '/var/www/cyber-dojo'
  Dir.glob("#{cyber_dojo_root}/languages/*/*/manifest.json") do |filename|
    manifest = JSON.parse(IO.read(filename))
    images_names << manifest['image_name']
  end
  images_names.sort
end

def ok_or_failed
  $?.exitstatus == 0 ? 'OK' : 'FAILED'
end

# - - - - - - - - - - - - - -

def cyberdojo_foundation_docker_update_all
  current = current_images_names
  latest = latest_images_names
  latest.each do |latest_image_name|
    if !current.include?(latest_image_name)
      cmd = "docker pull #{latest_image_name}"
      print cmd
      `#{cmd}`
      puts " #{ok_or_failed}"
    end
  end
  current.each do |current_image_name|
    if !latest.include?(current_image_name)
      cmd = "docker rmi #{current_image_name}"
      print cmd
      `#{cmd}`
      puts " #{ok_or_failed}"
    end
  end
end
