
require 'json'
require_relative '../lib/all'
require_relative '../app/lib/all'
require_relative '../app/models/all'

include ExternalSetter

def create_dojo
  me = File.expand_path(File.dirname(__FILE__))
  root_folder = File.expand_path('..', me) + '/'  
  
  set_external(:disk,   Disk.new)
  set_external(:git,    Git.new)
  set_external(:runner, DockerTestRunner.new)
  set_external(:exercises_path, root_folder + 'exercises/')
  set_external(:languages_path, root_folder + 'languages/')
  set_external(:katas_path,     root_folder + 'katas/')
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
