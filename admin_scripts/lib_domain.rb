
require 'json'
require_relative '../lib/all'
require_relative '../app/lib/all'
require_relative '../app/models/all'

def cyber_dojo_root
  '/var/www/cyber-dojo'
end

ENV['CYBER_DOJO_EXERCISES_ROOT'] ||= "#{cyber_dojo_root}/exercises/"
ENV['CYBER_DOJO_LANGUAGES_ROOT'] ||= "#{cyber_dojo_root}/languages/"
ENV['CYBER_DOJO_KATAS_ROOT']     ||= "#{cyber_dojo_root}/katas/"

#ENV['CYBER_DOJO_RUNNER_CLASS'] ||= 'DockerRunner'
ENV['CYBER_DOJO_RUNNER_CLASS'] ||= 'HostRunner'
ENV['CYBER_DOJO_DISK_CLASS']   ||= 'HostDisk'
ENV['CYBER_DOJO_GIT_CLASS']    ||= 'HostGit'

def dojo
  Dojo.new
end

def number(value,width)
  spaces = ' ' * (width - value.to_s.length)
  "#{spaces}#{value.to_s}"
end

def dots(dot_count)
  dots = '.' * (dot_count % 32)
  spaces = ' ' * (32 - dot_count % 32)
  dots + spaces + number(dot_count,5)
end

def mention(exceptions)
  if exceptions != [ ]
    puts
    puts
    puts "# #{exceptions.length} Exceptions saved in exceptions.log"
    `echo '#{exceptions.to_s}' > exceptions.log`
    puts
    puts
  end
end
