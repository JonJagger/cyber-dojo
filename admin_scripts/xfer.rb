#!/usr/bin/env ruby

# Ruby script to transfer dojos with specific IDs from a
# cyber-dojo server with a specific IP address to the calling
# server (which is assumed to also be a cyber-dojo server)
#
# xfer.rb cyber-dojo.org 572F35
#

ip_address = ARGV[0]
ids = ARGV[1..-1]

ids.each do |id|
  puts id
  tar_filename = "#{id}.tar.gz"
  folder = "/var/www/cyber-dojo/katas"
  xfer_cmd = "wget -q -O #{folder}/#{tar_filename} http://#{ip_address}/downloader/download/#{id}"
  untar_cmd = "cd #{folder}; tar -xvf #{id}.tar.gz"
  rm_cmd = "rm #{folder}/#{tar_filename}"
  `#{xfer_cmd}`
  `#{untar_cmd}`
  `#{rm_cmd}`
end
