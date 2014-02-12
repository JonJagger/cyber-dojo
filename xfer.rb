# A ruby script to download zips of dojos identified by
# the output of the prunt_large.rb script

txt_file = ARGV[0]
lo = (ARGV[1] || "0").to_i
hi = (ARGV[2] || "10000").to_i

`cat #{ARGV[0]}`.scan(/^will rm ([A-Z0-9]*) ([0-9]*)/) do |matches|
  id = matches[0]
  rags = matches[1].to_i
  if lo <= rags && rags <= hi
    p id + " " + rags.to_s
    xfer_cmd = "wget -q -O #{id}.tar.gz http://cyber-dojo.com/dashboard/download/#{id}"
    `#{xfer_cmd}`
  end
end
