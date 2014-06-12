#!/usr/bin/env ruby

# Ruby script to transfer dojos with specific IDs from a
# cyber-dojo server with a specific IP address to the calling
# server (which is assumed to also be a cyber-dojo server)

ip_address = ARGV[0]
ids = ARGV[1..-1]

ids.each do |id|
  xfer_cmd = "wget -q -O /var/www/cyberdojo/katas/#{id}.tar.gz http://#{ip_address}/downloader/download/#{id}"
  untar_cmd = "cd /var/www/cyberdojo/katas; tar -xvf #{id}.tar.gz"
  `#{xfer_cmd}`
  `#{untar_cmd}`
end
