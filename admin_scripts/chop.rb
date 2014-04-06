# A ruby script to delete dojos identified by
# the output of the prune_large.rb script
# (after they have been xfer.rb'd to another server)
#
# eg the following will find all dojos with 25 or more
# traffic lights that are at least 14 days old
#   ruby prune_large.rb false 25 14 > tl_25_age_14.txt
#
# from the target server you then run
#   ruby xfer.rb tl_25_age_14.txt 0 10000
# which will xfer tar.gz files for all dojos with
# between 0 and 100 traffic lights (assuming cyber-dojo.com is up)
#
# then run this script
#  ruby chop.rb tl_25_age_14.txt

txt_file = ARGV[0]

`cat #{ARGV[0]}`.scan(/^will rm ([A-Z0-9]*) ([0-9]*)/) do |matches|
  id = matches[0]
  rags = matches[1]
  inner = id[0..1]
  outer = id[2..-1]
  rm_cmd = "rm -rf ./katas/#{inner}/#{outer}"
  `#{rm_cmd}`
  puts "#{rags} #{rm_cmd}"
end
