#!/usr/bin/ruby

cyber_dojo_root = File.expand_path('../..', File.dirname(__FILE__))

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

print_and_run build_docker_image_in("#{cyber_dojo_root}/app/languages/build-essential")
print_and_run build_docker_image_in("#{cyber_dojo_root}/app/languages/alpine-base")

# images in test folders are *not* always based on the image in their parent
# language folder. When they are not the reason is usually
# 1. to inherit common libraries
# 2. to keep image sizes down

Dir.glob("#{cyber_dojo_root}/app/languages/*/").sort.each do |language_dir|
  print_and_run(build_docker_image_in(language_dir))
end

Dir.glob("#{cyber_dojo_root}/app/languages/*/").sort.each do |language_dir|
  Dir.glob("#{language_dir}*/").sort.each do |test_dir|
    next if test_dir.end_with? "#{docker_context_dir_name}/"
    print_and_run(build_docker_image_in(test_dir))
  end
end
