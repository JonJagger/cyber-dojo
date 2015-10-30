#!/usr/bin/ruby

cyber_dojo_root = File.expand_path('..', File.dirname(__FILE__))

language_dirs = []
Dir.glob("#{cyber_dojo_root}/languages/*/") do |dir|
  language_dirs << dir
end

language_dirs.sort.each do |language_dir|
  cmd = "cd '#{language_dir}'; ./build-docker-container.sh"
  p cmd
  `#{cmd}`
  test_dirs = Dir.glob("#{language_dir}*/") do |test_dir|
   cmd = "cd '#{test_dir}'; ./build-docker-container.sh"
   p cmd
   `#{cmd}`
  end
end
