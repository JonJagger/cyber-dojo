# script to scp cyberdojo katas from one server to another

require './script_lib.rb'

IP = ARGV[0]
if IP === nil
  puts "ruby scp_all IP-ADDRESS"
  exit
end

n = 0
index('katas') do |kata_dir,id|
  p "#{n} #{kata_dir}"
  outer = id[0..1]
  inner = id[2..-1]
  `tar cfz tmp_scp_all/#{id}.tgz #{kata_dir}`
  `scp tmp_scp_all/#{id}.tgz root@#{IP}:/var/www/cyberdojo/tmp_scp_all`
  `mkdir -p katas_moved/#{outer}/#{inner}`
  `mv katas/#{outer}/#{inner} katas_moved/#{outer}`
  `rm tmp_scp_all/#{id}.tgz`
  n += 1
  #break if n == 1
end

