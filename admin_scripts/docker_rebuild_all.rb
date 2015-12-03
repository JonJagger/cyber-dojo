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

print_and_run build_docker_container_in("#{cyber_dojo_root}/languages/build-essential")

Dir.glob("#{cyber_dojo_root}/languages/*/").sort.each do |language_dir|
  print_and_run(build_docker_container_in(language_dir))
  Dir.glob("#{language_dir}*/").sort.each do |test_dir|
    next if test_dir.end_with? '/_docker_context/'
    print_and_run(build_docker_container_in(test_dir))
  end
end
