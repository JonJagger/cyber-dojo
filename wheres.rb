
# ruby wheres.rb dojo-name
# >dojo-name is in ca/cfefd7daacd9694bd893527581c59596ebd21e

require 'digest/sha1'

sha = Digest::SHA1.hexdigest(ARGV[0])
inner = sha[0..1]   
outer = sha[2..-1]
print ARGV[0] + ' is in ' + inner + '/' + outer + "\n"



