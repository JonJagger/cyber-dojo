
# run from /var/www/cyberdojo/tmp_scp_all

n = 0
`ls`.split.each do |id_tgz|
  p "#{n} #{id_tgz}"
  `tar xfp #{id_tgz} -C ..`
  n += 1
  # break if n == 1
end

# to untar and force the files to belong to a specific user
#
# uid = `id -u www-data`.rstrip
# gid = `id -g www-data`.rstrip
#
# `tar ....... --owner=#{uid}  --group=#{gid}`
#
