
# A ruby script to download zips of dojos identified by
# the output of the prunt_large.rb script
#
# eg the following will find all dojos with 25 or more
# traffic lights that are at least 14 days old
#   ruby prune_large.rb false 25 14 > tl_25_age_14.txt
#
# from the target server you then run
#   ruby xfer.rb tl_25_age_14.txt 0 100
# which will xfer tar.gz files for all dojos with
# between 0 and 100 traffic lights (assuming cyber-dojo.com is up)

txt_file = ARGV[0]
lo = (ARGV[1] || "0").to_i
hi = (ARGV[2] || "10000").to_i

`cat #{ARGV[0]}`.scan(/^will rm ([A-Z0-9]*) ([0-9]*)/) do |matches|
  id = matches[0]
  # TODO: if already downloaded id don't wget it
  rags = matches[1].to_i
  if lo <= rags && rags <= hi
    p id + " " + rags.to_s
    xfer_cmd = "wget -q -O #{id}.tar.gz http://cyber-dojo.com/downloader/download/#{id}"
    `#{xfer_cmd}`
  end
end

# this will create lots of *.tar.gz files
# these can be untarred as follows
#   mv *.tar.gz dst_folder
#   cd dst_folder
#   find . -name '*.tar.gz' -print0 | xargs -0 -n1 tar xf
# and possibly then
#   chgrp -R www-data *
#   chown -R www-data *
# or if you have sudo
#   sudo -u www-data find . -name '*.tar.gz' -print0 | xargs -0 -n1 tar xf
# no sudo? try
#   apt-get install sudo
