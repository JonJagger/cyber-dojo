
# ruby names.rb
# >dojo-name1 is in ca/cfefd7daacd9694bd893527581c59596ebd21e
# >dojo-name1 is in f6/893527581c59596ebd21ecfefd7daacd9694bd

require 'digest/sha1'

index = eval IO.popen('cat dojos/index.rb').read
names = index.map{|e| e[:name]}
names.each do |name|
  sha1 = Digest::SHA1.hexdigest(name)
  inner = sha1[0..1]   
  outer = sha1[2..-1]
  print inner + '/' + outer + '    ' + name + "\n"
end

