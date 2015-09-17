#!/usr/bin/env ruby

# After running this script you want to get the tgz file off the server you need
# scp root@cyber-dojo.org:/var/www/cyber-dojo/admin_scripts/refactoring_dojos/refactoring_dojos.tgz .

require_relative '../lib_domain'

dirs = [ ]
refactoring_ids.each do |id|
  outer_dir = id[0..1]
  inner_dir = id[2..-1]
  kata_dir = "katas/#{outer_dir}/#{inner_dir}"
  dirs << kata_dir
end

tar_command = "tar -C /var/www/cyber-dojo -czf #{refactoring_tar_filename} #{dirs.join(' ')}"

`rm -f #{refactoring_tar_filename}`
`#{tar_command}`
