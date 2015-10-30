#!/usr/bin/ruby

def cyber_dojo_root
  '/var/www/cyber-dojo'
end

def build_docker_container_in(dir)
   "cd '#{dir}'; ./build-docker-container.sh"
end

def print_and_run(command)
  p command
  `#{command}`
end

# have to do all language base containers first
# because some test frameworks are based on
# language containers for a different language

Dir.glob("#{cyber_dojo_root}/languages/*/").sort.each do |language_dir|
  print_and_run build_docker_container_in(language_dir)
end

Dir.glob("#{cyber_dojo_root}/languages/*/*/").sort.each do |test_dir|
 print_and_run build_docker_container_in(test_dir)
end

