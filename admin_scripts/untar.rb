
# run from /var/www/cyberdojo/tmp_scp_all
n = 0
`ls`.split.each do |id_tgz|
  p "#{n} #{id_tgz}"
  `tar xf #{id_tgz} -C ..`
  n += 1
  # break if n == 1
end
