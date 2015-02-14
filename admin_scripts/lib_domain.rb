
require 'json'
require_relative '../lib/all'
require_relative '../app/lib/all'
require_relative '../app/models/all'

def create_dojo
  thread = Thread.current
  thread[:disk] = Disk.new
  thread[:git] = Git.new
  thread[:runner] = DockerTestRunner.new
  
  me = File.expand_path(File.dirname(__FILE__))
  cyber_dojo_home_dir = File.expand_path('..', me) + '/'  
  
  thread[:exercises_path] = cyber_dojo_home_dir + 'exercises/'
  thread[:languages_path] = cyber_dojo_home_dir + 'languages/'
  thread[:katas_path    ] = cyber_dojo_home_dir + 'katas/'
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
