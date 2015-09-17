#!/usr/bin/env ruby

def root
  '/var/www/cyber-dojo'
end

(0..255).each do |n|
  
  hex = "%02X" % n
  from_remote = "root@cyber-dojo.org:#{root}/katas/#{hex}"
  to_local = "#{root}/katas"
  rsync = "rsync -avzP --stats #{from_remote} #{to_local}"
  print "#{rsync}\n"
  `#{rsync}`
  print "sleeping\n"
  `sleep 30`

end