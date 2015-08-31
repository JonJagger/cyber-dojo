#!/usr/bin/env ruby

# Ruby script to download dojos tar.gz file(s) of cyber-dojos by their IDs
#
# download.rb cyber-dojo.org 572F35 E7734A
#

ip_address = ARGV[0]
ids = ARGV[1..-1]

ids.each do |id|
  puts id
  xfer_cmd = "wget -q -O #{id}.tar.gz http://#{ip_address}/downloader/download/#{id}"
  `#{xfer_cmd}`
end
