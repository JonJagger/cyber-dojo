
# Post-Paas-refactoring domain lib

me = File.expand_path(File.dirname(__FILE__))
CYBERDOJO_HOME_DIR = File.expand_path('..', me) + '/'

$LOAD_PATH << CYBERDOJO_HOME_DIR + 'lib'
$LOAD_PATH << CYBERDOJO_HOME_DIR + 'app/lib'
$LOAD_PATH << CYBERDOJO_HOME_DIR + 'app/models'

require 'OsDisk'
require 'OsDir'
require 'Git'
require 'Paas'
require 'DockerRunner'
require 'Dojo'
require 'DummyRunner'
require 'Languages'
require 'Language'
require 'Exercises'
require 'Exercise'
require 'Katas'
require 'Kata'
require 'Avatars'
require 'Avatar'
require 'Lights'
require 'Light'
require 'Id'
require 'json'

def create_dojo
  disk = OsDisk.new
  git = Git.new
  runner = DummyRunner.new
  paas = Paas.new(disk, git, runner)
  paas.create_dojo(CYBERDOJO_HOME_DIR)
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
