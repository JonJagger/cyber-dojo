
me = File.expand_path(File.dirname(__FILE__))
CYBERDOJO_HOME_DIR = File.expand_path('..', me) + '/'

$LOAD_PATH << CYBERDOJO_HOME_DIR + 'lib'
$LOAD_PATH << CYBERDOJO_HOME_DIR + 'app/lib'
$LOAD_PATH << CYBERDOJO_HOME_DIR + 'app/models'

require 'OsDisk'
require 'OsDir'
require 'Git'
require 'DockerTestRunner'
require 'DummyTestRunner'
require 'Dojo'
require 'Languages'
require 'Language'
require 'Exercises'
require 'Exercise'
require 'Katas'
require 'Kata'
require 'Avatars'
require 'Avatar'
require 'Sandbox'
require 'Light'
require 'json'

def create_dojo
  externals = {
    :disk   => OsDisk.new,
    :git    => Git.new,
    :runner => DummyTestRunner.new
  }
  Dojo.new(CYBERDOJO_HOME_DIR,externals)
end

def number(value,width)
  spaces = ' ' * (width - value.to_s.length)
  "#{spaces}#{value.to_s}"
end

def dots(dot_count)
  dots = '.' * (dot_count % 32)
  spaces = ' ' * (32 - dot_count%32)
  dots + spaces + number(dot_count,5)
end

def mention(exceptions)
  if exceptions != [ ]
    puts
    puts
    puts "#{exceptions.length} Exceptions saved in exceptions.log"
    puts "The probable cause is katas in the old .rb format."
    puts "Convert these old katas into the new .json format"
    puts "using admin_scripts/convert_katas_format.rb"
    `echo '#{exceptions.inspect}' > exceptions.log`
    puts
    puts
  end
end
