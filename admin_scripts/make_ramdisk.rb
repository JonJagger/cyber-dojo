
require 'json'

# sudo ruby make_ramdisk.rb

ramdisk = '/mnt/ramdisk'

`umount #{ramdisk}`
`rm -rf #{ramdisk}`

# TODO: check if above commands fail
# if umount fails with Device or resource busy
#      $ sudo lsof +D /mnt/ramdisk
# to get the pid and then kill the process
# kill -9 PID

cyber_dojo_root = '/var/www/cyber-dojo'

`mkdir #{ramdisk}`
`mount -t tmpfs -o size=2m tmpfs #{ramdisk}`
`mkdir #{ramdisk}/katas`
`mkdir #{ramdisk}/languages`
`cp -R #{cyber_dojo_root}/exercises #{ramdisk}/exercises`

Dir.glob("#{cyber_dojo_root}/languages/*/*/manifest.json") do |filename|
  pattern = /languages\/([^\/]*)\/([^\/]*)\/manifest.json/
  match = pattern.match(filename)
  path = "languages/#{match[1]}/#{match[2]}"
  mkdir_cmd = "mkdir -p '#{ramdisk}/#{path}/'"
  `#{mkdir_cmd}`
  manifest = JSON.parse(IO.read(filename))
  visible_filenames = manifest['visible_filenames']
  visible_filenames << 'manifest.json'
  visible_filenames.each do |vfile|
    from = "'#{cyber_dojo_root}/#{path}/#{vfile}'"
    to = "'#{ramdisk}/#{path}/#{vfile}'"
    cp_cmd = "cp #{from} #{to}"
    `#{cp_cmd}`
  end
end

`chmod -R 555 #{ramdisk}`
`chmod -R 777 #{ramdisk}/katas`
`chown -R www-data:www-data #{ramdisk}`
