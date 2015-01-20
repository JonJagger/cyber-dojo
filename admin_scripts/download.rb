#!/usr/bin/env ruby

# Ruby script to download dojos zip file(s)
#
# xfer.rb cyber-dojo.org 572F35
#

ip_address = ARGV[0]
ids = ARGV[1..-1]

ids.each do |id|
  puts id
  xfer_cmd = "wget -q -O #{id}.tar.gz http://#{ip_address}/downloader/download/#{id}"
  `#{xfer_cmd}`
end
