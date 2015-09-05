#!/usr/bin/env ruby

# After running this script you want to get the tgz file off the server you need
# scp root@cyber-dojo.org:/var/www/cyber-dojo/admin_scripts/refactoring_dojos/refactoring_dojos.tgz .

ids = [ ]

# http://jonjagger.blogspot.co.uk/2012/05/yahtzee-cyber-dojo-refactoring-in-java.html
ids << 'E2285E5C2B'  # Yahtzee C#-NUnit deer 9
ids << '9D5B580C30'  # Yahtzee Java-JUnit deer 9
ids << '76DD58DE08'  # Yahtzee C++-assert frog 18
ids << '5C5B71C765'  # Yahtzee Python-unittest hippo 42

# http://coding-is-like-cooking.info/2013/01/setting-up-a-new-code-kata-in-cyber-dojo/
ids << '672E047F5D'  # Tennis  C#-NUnit buffalo 11
ids << '3367E4B0E9'  # Tennis  Ruby-TestUnit raccoon 4
ids << 'B22DCD17C3'  # Tennis  Java-JUnit buffalo 13
ids << 'A06DCDA217'  # Tennis  C++-assert wolf 7
ids << '435E5C1C88'  # Tennis  Python-unittest moose 5


`rm -f refactoring_dojos.tgz`
dirs = [ ]
ids.each do |id|
  outer_dir = id[0..1]
  inner_dir = id[2..-1]
  kata_dir = "katas/#{outer_dir}/#{inner_dir}"
  dirs << kata_dir
end

tar_command = "tar -C /var/www/cyber-dojo -czf refactoring_dojos.tgz #{dirs.join(' ')}"
`#{tar_command}`