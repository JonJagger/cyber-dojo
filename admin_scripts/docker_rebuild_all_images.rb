#!/usr/bin/ruby

def cyber_dojo_root
  '/var/www/cyber-dojo'
end

def docker_context_dir_name
  '_docker_context'
end

def build_docker_image_in(dir)
  "cd '#{dir}'; cd '#{docker_context_dir_name}'; ./build-docker-image.sh"
end

def print_and_run(command)
  p command
  `#{command}`
end

print_and_run build_docker_image_in("#{cyber_dojo_root}/languages/build-essential")

Dir.glob("#{cyber_dojo_root}/languages/*/").sort.each do |language_dir|
  print_and_run(build_docker_image_in(language_dir))
  Dir.glob("#{language_dir}*/").sort.each do |test_dir|
    next if test_dir.end_with? "#{docker_context_dir_name}/"
    print_and_run(build_docker_image_in(test_dir))
  end
end
