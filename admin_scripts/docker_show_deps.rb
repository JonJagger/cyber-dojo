require 'json'

CYBER_DOJO_ROOT_DIR = ARGV[0]
if CYBER_DOJO_ROOT_DIR === nil
  puts "ruby docker_show_deps.rb [root-dir]"
  exit
end

dependencies = [ ]
Dir.glob("#{CYBER_DOJO_ROOT_DIR}/languages/*/Dockerfile") do |file|
  sh = File.expand_path(File.dirname(file)) + '/build-docker-container.sh'
  to = IO.read(sh).split[4]
  from = IO.read(file).split[1]
  if !to.start_with?('cyberdojo')
    puts "#{sh}'s target container-name does not start with cyberdojo"
    exit
  end
  dependencies << [from,to]
end

dependencies.sort.each do |dep|
  print dep[0] + "-->" + dep[1] + "\n"
end
