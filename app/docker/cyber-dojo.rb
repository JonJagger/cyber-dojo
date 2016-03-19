#!/usr/bin/ruby

# TODO: pull ALL language images == fetch? all? pull=all?

$me = 'cyber-dojo.rb'
$my_dir = File.expand_path(File.dirname(__FILE__))

$docker_hub_username = 'cyberdojofoundation'
$docker_compose_file = 'docker-compose.yml'
$docker_compose_cmd = "docker-compose --file=#{$my_dir}/#{$docker_compose_file}"
$home = '/usr/src/cyber-dojo'  # home folder *inside* the server image

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def help
  [
    '',
    "Use: #{$me} COMMAND",
    "     #{$me} help",
    '',
    'COMMAND(server):',
    '     backup               Create tgz file of all practice sessions',
    '     down                 Stops and removes server',
    '     up                   Creates and starts the server',
    '',
    'COMMAND(languages):',
    '     catalog              Lists all language images',
    '     images               Lists pulled language images',
    '     pull IMAGE           Pulls language IMAGE',
    '     remove IMAGE         Removes a pulled language IMAGE',
    '     upgrade              Pulls the latest server and language images',
    ''
  ].each { |line| puts line }
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def run(command)
  puts command
  `#{command}`
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def backup
  cmd = 'docker run' +
    ' --user=root' +
    ' --rm' +
    ' --volumes-from=cdf-katas-DATA-CONTAINER' +
    " --volume=/backup:/backup" +
    " #{$docker_hub_username}/web" +
    " tar -cvz -f /backup/cyber-dojo_katas_backup.tgz -C #{$home} katas"
  `#{cmd}`
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def up
  return if pulled_images == []
  puts 'No language images pulled'
  puts 'Pulling a small starting collection of common language images'
  pull('gcc_assert')
  pull('ruby_mini_test')
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def catalog
  `#{$my_dir}/../languages/list_all_images.rb`
  # LANGUAGE          TESTS                IMAGE
  # Asm               assert               nasm_assert
  # BCPL              all_tests_passed     bcpl-all_tests_passed
  # Bash              shunit2              bash_shunit2
  # C (clang)         assert               clang_assert
  # C (gcc)           CppUTest             gcc_cpputest
  # ...
end

def in_catalog?(image)
  all = catalog.split("\n").drop(1)
  lines = all.map{ |line| line.split[-1] }
  # [ bcpl-all_tests_passed, bash_shunit2, clang_assert, gcc_cpputest, ...]
  lines.include?(image)
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def pulled_images
  di = `docker images | grep #{$docker_hub_username}`
  # cyberdojofoundation/visual-basic_nunit   latest  eb5f54114fe6 4 months ago 497.4 MB
  # cyberdojofoundation/ruby_mini_test       latest  c7d7733d5f54 4 months ago 793.4 MB
  # cyberdojofoundation/ruby_rspec           latest  ce9425d1690d 4 months ago 411.2 MB
  # ...
  di.split("\n").map{ |line| line.split[0].split('/')[1] }
  # visual-basic_nunit
  # ruby_mini_test
  # ruby_rspec
  # ...
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def images
  pulled = pulled_images
  all = catalog.split("\n")
  puts all.shift # heading
  all.each do |line|
    image = line.split[-1]
    puts line if pulled.include? image
  end
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def services
  `#{$docker_compose_cmd} config --services 2> /dev/null`.split
end

def upgrade
  services.each do |image|
    run "docker pull #{$docker_hub_username}/#{image}"
  end
  pulled_images.each do |image|
    run "docker pull #{$docker_hub_username}/#{image}"
  end
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def bad_image(image)
  if image.nil?
    puts 'missing IMAGE'
  else
    puts "unknown IMAGE #{image}"
  end
  puts "Try '#{$me} help'"
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def pull(image)
  if in_catalog?(image)
    run "docker pull #{$docker_hub_username}/#{image}:latest"
  else
    bad_image(image)
  end
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def remove(image)
  if in_catalog?(image)
    run "docker rmi #{$docker_hub_username}/#{image}"
  else
    bad_image(image)
  end
end

#= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

if ARGV.length == 0
  puts 'no command entered'
  puts "Try '#{$me} help'"
  exit
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

options = {}
arg = ARGV[0].to_sym
if [:help, :backup, :down, :up, :images, :catalog, :upgrade, :pull, :remove].include? arg
  options[arg] = true
else
  puts "#{$me}: #{arg} ?"
  puts "Try '#{$me} help"
  exit
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

help            if options[:help]
backup          if options[:backup]
up              if options[:up]
puts catalog    if options[:catalog]
images          if options[:images]
upgrade         if options[:upgrade]
pull(ARGV[1])   if options[:pull]
remove(ARGV[1]) if options[:remove]
