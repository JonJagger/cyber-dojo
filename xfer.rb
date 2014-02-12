# A ruby script to download zips of dojos identified by the output of
# the prunt_large.rb script

`cat #{ARGV[0]}`.scan(/^will rm ([A-Z0-9]*)/) do |md|
  id = md[0]
  p id
  xfer_cmd = "wget -O #{id}.tar.gz http://cyber-dojo.com/dashboard/download/#{id}"
  `#{xfer_cmd}`
end